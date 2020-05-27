--ゴッド・ブレイズ・キャノン
--Blaze Cannon
--Logical Nonsense

--Substitute ID
local s,id=GetID()

function s.initial_effect(c)
	--Grant multiple effects to 1 "The Winged Dragon of Ra"
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	e1:SetHintTiming(TIMING_STANDBY_PHASE+TIMING_END_PHASE)
	c:RegisterEffect(e1)
end
	--Specifically lists "The Winged Dragon of Ra"
s.listed_names={CARD_RA}

	--Check for "The Winged Dragon of Ra"
function s.filter(c)
	return c:IsFaceup() and c:IsCode(CARD_RA) and c:GetFlagEffect(id)==0
end
	--Activation legality
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
	--Grant multiple effects to 1 "The Winged Dragon of Ra"
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if tc:GetFlagEffect(id)==0 then
			tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			--Unaffected by opponent's card effects
			local e1=Effect.CreateEffect(tc)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetValue(s.efilter)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			--Tribute any number of other monsters; gain ATK equal to the combined ATK of the tributed monsters
			local e2=Effect.CreateEffect(tc)
			e2:SetCategory(CATEGORY_ATKCHANGE)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
			e2:SetCode(EVENT_ATTACK_ANNOUNCE)
			e2:SetCost(s.cost)
			e2:SetOperation(s.atkop)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
			--After damage calculation, send all opponent's monsters to GY
			local e3=Effect.CreateEffect(tc)
			e3:SetDescription(aux.Stringid(id,0))
			e3:SetCategory(CATEGORY_TOGRAVE)
			e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
			e3:SetCode(EVENT_BATTLED)
			e3:SetCondition(s.sendcon)
			e3:SetTarget(s.sendtg)
			e3:SetOperation(s.sendop)
			tc:RegisterEffect(e3)
		end
	end
end
	--Unaffected by opponent's card effects
function s.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
	--Check for monsters that did not attacked
function s.atkfilter(e,tp,eg,ep,ev,re,r,rp)
	return c:GetAttackAnnouncedCount()==0 and c:IsFaceup() and c:GetTextAttack()>0
end
	--Tribute cost
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,s.atkfilter,1,false,nil,e:GetHandler()) end
	local g=Duel.SelectReleaseGroupCost(tp,s.atkfilter,1,99,false,nil,e:GetHandler())
	local ct=Duel.Release(g,REASON_COST)
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
	return true
	end
	return false
end
	--Gain ATK equal to the combined ATK of the tributed monsters
function s.atkop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	local atk=0
	local tc=g:GetFirst()
	for tc in aux.Next(g) do
		local batk=tc:GetTextAttack()
		if batk>0 then
			atk=atk+batk
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(atk)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	g:DeleteGroup()
end
	--If this card attacked
function s.sendcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler()
end
	--Activation legality
function s.sendtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,#g,0,0,nil)
end
	--After damage calculation, send all opponent's monsters to GY
function s.sendop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
end