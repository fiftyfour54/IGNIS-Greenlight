--アマゾネス拝謁の間
--Amazoness Hall
--scripted by Naim
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--Gain LP equal to a target's ATK
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_sZONE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.lpcond)
	e2:SetTarget(s.lptg)
	e2:SetOperation(s.lpop)
	c:RegisterEffect(e2)
end
s.listed_series={0x4}
function s.pzcheck(tp)
	return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
end
function s.pendfilter(c,tp)
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and s.pzcheck(tp) 
end
function s.cfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x4) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) 
		and (c:IsAbleToHand() or s.pendfilter(c,tp))
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,nil,tp)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
		local tc=g:Select(tp,1,1,nil)
		aux.ToHandOrElse(tc,tp,s.pendfilter(tc,tp),
						function(tc,tp) Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true) end,
						aux.Stringid(id,2)
						)
	end
end
function s.amzfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x4) and c:IsOriginalType(TYPE_MONSTER)
end
function s.lpcond(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.amzfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function s.lpfilter(c,e,p)
	return c:IsControler(p) and c:IsFaceup() and c:GetAttack()>0 and c:IsCanBeEffectTarget(e)
end
function s.lptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and s.lpfilter(chkc,e,1-tp) end
	if chk==0 then return eg:IsExists(s.lpfilter,1,nil,e,1-tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=eg:FilterSelect(tp,s.lpfilter,1,1,nil,e,1-tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetAttack())
end
function s.lpop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local value=tc:GetAttack()
		if value==0 then return end
		Duel.Recover(tp,value,REASON_EFFECT)
	end
end