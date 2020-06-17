--Sin パラダイム・ドラゴン
--Malefic Paradigm Dragon
--Scripted by ahtelel
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddMaleficSummonProcedure(c,nil,LOCATION_EXTRA)
	--sp summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--self destruct
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetCondition(s.descon)
	c:RegisterEffect(e2)
	--sp summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(s.spcost)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end
s.listed_names={27564031}
function s.descon(e)
	return not (Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsCode,27564031),e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) or Duel.IsEnvironment(27564031))
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,id)
end
function s.costfilter(c)
	return c:IsSetCard(0x23) and c:IsAbleToGraveAsCost()
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.spfilter(c,e,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsLevel(8)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_REMOVED,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_REMOVED,0,1,1,nil):GetFirst()
	if g and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 
		and g:IsLocation(LOCATION_EXTRA) and g:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) then
		Duel.BreakEffect()
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end