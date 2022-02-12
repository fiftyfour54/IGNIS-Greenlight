--EM稀代の決闘者
--Performapal Peerless Duelist
--Scripted by Eerie Code
local s,id=GetID()
function s.initial_effect(c)
	--pendulum summon
	Pendulum.AddProcedure(c)
	--miracle
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.atkcon)
	e1:SetTarget(s.atktg)
	e1:SetOperation(s.atkop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	--banish
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetOperation(s.rmop)
	c:RegisterEffect(e3)
	--evasion
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_HANDES)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(s.atktg2)
	e4:SetOperation(s.atkop2)
	c:RegisterEffect(e4)
end
s.listed_names={100287037}
s.listed_series={0x10f8,0x20f8}
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc:IsControler(1-tp) then tc=Duel.GetAttackTarget() end
	e:SetLabelObject(tc)
	return tc and tc:IsControler(tp) and tc:IsRelateToBattle() and Duel.GetAttackTarget()~=nil
end
function s.filter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToRemove()
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) and c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if a:IsControler(1-tp) then a,d=d,a end
	if a:IsRelateToBattle() and a:IsControler(tp) then
		--Cannot be destroyed by that battle
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
		a:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetValue(HALF_DAMAGE)
		e2:SetReset(RESET_PHASE+PHASE_DAMAGE)
		Duel.RegisterEffect(e2,tp)
		if Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
			if #g>0 then
				Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
			end
		end
	end
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function s.thfilter(c)
	return ((c:IsType(TYPE_MONSTER) and (c:IsSetCard(0x10f8) or c:IsSetCard(0x20f8))) or c:IsCode(100287037)) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do
		local g=Duel.GetMatchingGroup(s.filter,p,LOCATION_DECK,0,1,nil)
		if #g>0 and Duel.SelectYesNo(p,aux.Stringid(id,2)) then
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_REMOVE)
			local rg=g:Select(p,1,1,nil)
			Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function s.atktg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local at=Duel.GetAttacker()
	local p=1-at:GetControler()
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,p,LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,1,p,LOCATION_HAND)
end
function s.thfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function s.atkop2(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	local p=1-at:GetControler()
	if Duel.IsExistingMatchingCard(s.thfilter2,p,LOCATION_REMOVED,0,1,nil) and Duel.SelectYesNo(p,aux.Stringid(id,3)) then
		local g=Duel.SelectMatchingCard(p,s.thfilter2,p,LOCATION_REMOVED,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		local tc=g:GetFirst()
		if tc:IsDiscardable(REASON_EFFECT) then
			Duel.BreakEffect()
			Duel.SendtoGrave(tc,REASON_EFFECT+REASON_DISCARD)
			Duel.NegateAttack()
		end
	end
end
