--宝玉神覚醒
--Awakening of the Crystal Lord
--scripted by Naim
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
local LOCATIONS=LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_SZONE
s.listed_series={0x1034,0x2034,0x283} --Crystal Beast, Ultimate Crystal, Bridge
function s.cfilter(c,opt)
	return c:IsSetCard(0x2034) and((opt==1 and not c:IsPublic()) or (opt==2 and c:IsFaceup()))
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil,1) --to reveal
	local b=Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil,2) --already on the field 
	if chk==0 then return a or b end
	local op=aux.SelectEffect(tp,
		{a,aux.Stringid(19048328,2)},
		{b,aux.Stringid(19048328,3)})
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND,0,1,1,nil,1)
		Duel.ConfirmCards(1-tp,g)
		e:SetLabel(1) --if revealed, can only use one of the effects
	else
		e:SetLabel(0) --if controled, can use both
	end
end
function s.thfilter(c)
	return c:IsSetCard(0x283) and not c:IsCode(93504463,23377425,18205590)
		and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x1034) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATIONS,0,1,nil,e,tp) 
	if chk==0 then return b1 or b2 end
	local label=e:GetLabel() --1, if revealed, 0 otherwise. 1=only 1 effect, 0=only 1 effect or both 
	--It might not be necessary to check for label in the second and third options here:
	local op=aux.SelectEffect(tp,
		{b1 and b2 and label==0, aux.Stringid(19048328,4)}, --both effects
		{b1 and (label==0 or label==1), aux.Stringid(19048328,5)},--to hand or to gy
		{b2 and (label==0 or label==1), aux.Stringid(19048328,6)})--special summon
	if op==1 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATIONS)
		Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
		Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	elseif op==2 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
		Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
		Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	elseif op==3 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATIONS)
	end
	e:SetLabel(op) --overwrite the label set in the cost
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local opt=e:GetLabel() --1= both, 2=TohandOrGY, 3= SpecialSummon
	local b1=Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATIONS,0,1,nil,e,tp)
	if b1 and (opt==1 or opt==2) then
		--Add to hand OR send to Grave
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
		local tc=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #tc>0 then
			aux.ToHandOrElse(tp,tc)
		end
	end
	if b2 and (opt==1 or opt==3) then
		--Special Summon
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATIONS,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	end
end