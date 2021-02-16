-- シドレミコード・ビューティア
-- Sidoremichord Beautia
-- scripted by Hatter
local s,id=GetID()
function s.initial_effect(c)
	-- pendulum
	Pendulum.AddProcedure(c)
	-- cannot activate s/t on pendulum summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(s.sucop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_CHAIN_END)
	e2:SetOperation(s.cedop)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	-- register banish effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id)
	e3:SetTarget(s.rmtg)
	e3:SetOperation(s.rmop)
	c:RegisterEffect(e3)
	-- destroy on battle
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetCountLimit(1)
	e4:SetTarget(s.destg)
	e4:SetOperation(s.desop)
	c:RegisterEffect(e4)
end
s.listed_series={0x261}
function s.chainlm(e,rp,tp)
	return tp==rp
end
function s.sucfilter(c,tp)
	return c:IsSetCard(0x261) and c:IsType(TYPE_PENDULUM) and c:IsControler(tp) and c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
function s.sucop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(s.sucfilter,1,nil,tp) then
		e:SetLabel(1)
	else e:SetLabel(0) end
end
function s.filter(c,e,st)
	return c:IsFaceup() and c:IsCanBeEffectTarget(e) and (c:IsType(TYPE_EFFECT) or (st and c:IsType(TYPE_SPELL|TYPE_TRAP)))
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local st=Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsEvenScale),tp,LOCATION_PZONE,0,1,nil)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_ONFIELD) and s.filter(chkc,e,st) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,0,LOCATION_ONFIELD,1,nil,e,st) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.filter,tp,0,LOCATION_ONFIELD,1,1,nil,e,st)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		-- banish it if it leaves the field
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(3300)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT+RESET_PHASE+PHASE_END)
		e1:SetValue(LOCATION_REMOVED)
		tc:RegisterEffect(e1,true)
	end
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetAttacker()
	if tc==e:GetHandler() then tc=Duel.GetAttackTarget() end
	if chk==0 then
		local g=Duel.GetMatchingGroup(aux.FilterFaceupFunction(Card.IsType,TYPE_PENDULUM),tp,LOCATION_PZONE,0,nil)
		local _,sc=g:GetMinGroup(function(c) return c:GetScale() end)
		return sc and tc and tc:IsControler(1-tp) and tc:IsAttackAbove(sc*300)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc==e:GetHandler() then tc=Duel.GetAttackTarget() end
	if tc and tc:IsRelateToBattle() then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end