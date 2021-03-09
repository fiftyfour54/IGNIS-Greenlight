--魔鍵疑—羅一

--scripted by XyleN5967
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_series={SET_MAGIKEY}
function s.cfilter(c) 
	return c:IsFaceup() and (c:IsSetCard(SET_MAGIKEY) and c:IsType(TYPE_RITUAL)
		or c:IsSetCard(SET_MAGIKEY) and c:IsType(TYPE_MONSTER) and c:IsSummonLocation(LOCATION_EXTRA))
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil) then return false end
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re)
		and Duel.Destroy(eg,REASON_EFFECT)~=0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
		local att=Duel.AnnounceAttribute(tp,1,0xffff)
		e:SetLabel(att)
		local g=Duel.GetMatchingGroup(aux.FilterFaceupFunction(Card.IsType,TYPE_MONSTER),tp,0,LOCATION_MZONE,nil)
		local tc=g:GetFirst() 
		if tc then
			for tc in aux.Next(g) do
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
				e1:SetValue(e:GetLabel())
				e1:SetReset(RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1) 
			end
		end
	end
end
