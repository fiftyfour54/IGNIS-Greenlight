--Japanese name
--How Did Dai Get Here?
--scripted by Naim
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.cfilter(c,tp,rp)
	return c:IsReason(REASON_BATTLE|REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsPreviousControler(tp) and rp==1-tp
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp,rp)
end
function s.fieldfilter(c,codes)
	return c:IsFieldSpell() and not c:IsCode(codes) and not c:IsForbidden()
end
function s.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local codes=Duel.GetMatchingGroup(Card.IsFaceup,0,LOCATION_FZONE,LOCATION_FZONE,nil):GetClass(Card.GetCode)
		local sg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
		return #sg>=5 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(s.fieldfilter,tp,LOCATION_DECK,0,1,nil,codes)
			and aux.SelectUnselectGroup(sg,e,tp,5,5,aux.dncheck,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local codes=Duel.GetMatchingGroup(Card.IsFaceup,0,LOCATION_FZONE,LOCATION_FZONE,nil):GetClass(Card.GetCode)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,s.fieldfilter,tp,LOCATION_DECK,0,1,1,nil,codes):GetFirst()
	if not tc then return end
	local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
	if fc then
		Duel.SendtoGrave(fc,REASON_RULE)
		Duel.BreakEffect()
	end
	if Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0then
		local sg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
		if #sg<5 then return end
		local g=aux.SelectUnselectGroup(sg,e,tp,5,5,aux.dncheck,1,tp,HINTMSG_CONFIRM)
		Duel.ConfirmCards(1-tp,g)
		local sc=g:RandomSelect(1-tp,1)
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		Duel.ShuffleDeck(tp)
	end
end