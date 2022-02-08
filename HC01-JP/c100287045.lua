--青い涙の天使
--Angel with Blue Tears
--Logical Nonsense

--Substitute ID
local s,id=GetID()
function s.initial_effect(c)
	--Negate 1 face-up monster on the field
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--Set 1 Normal Trap from hand or Deck
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return r&REASON_EFFECT~=0 end)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
end
	--Activation legality
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and aux.disfilter1(chkc) end --No idea how to handle retargeting
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,LOCATION_HAND)>0 and Duel.IsExistingTarget(aux.disfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g1,g2=Group.CreateGroup(),Group.CreateGroup()
		--Include opponent's monsters, if your hand>0. You are the one taking damage
	if Duel.GetMatchingGroupCount(nil,tp,LOCATION_HAND,0,e:GetHandler())>0 then
		fg1=Duel.GetMatchingGroup(aux.disfilter1,tp,0,LOCATION_MZONE,nil,nil)
		g1:Merge(fg1)
	end
		--Include your monsters, if opponent's hand>0. Opponent is the one taking damage
	if Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)>0 then
		fg2=Duel.GetMatchingGroup(aux.disfilter1,tp,LOCATION_MZONE,0,nil,nil)
		g2:Merge(fg2)
	end
	g1:Merge(g2)
	local sg=g1:Select(tp,1,1,nil)
	Duel.SetTargetCard(sg)
	local p=sg:GetFirst():GetControler()
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,sg,1,0,0)
	Duel.SetTargetPlayer(1-p)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-p,Duel.GetFieldGroupCount(1-p,LOCATION_HAND,0)*200)
end
	--Negate 1 face-up monster on the field
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local p=tc:GetControler()
		local d=Duel.GetFieldGroupCount(1-p,LOCATION_HAND,0)*200
		local dam=Duel.Damage(1-p,d,REASON_EFFECT)
		if dam>0 and tc:IsFaceup() and not tc:IsDisabled() then
			Duel.BreakEffect()
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local c=e:GetHandler()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
		end
	end
end
	--Check for a Normal Trap
function s.setfilter(c)
	return c:GetType()==TYPE_TRAP and c:IsSSetable()
end
	--Activation legality
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
	--Set 1 Normal Trap from hand or Deck
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g)
		--If it was set from hand, it can be activated this turn
		if not g:GetFirst():IsPreviousLocation(LOCATION_HAND) then return end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		g:GetFirst():RegisterEffect(e1)
	end
end