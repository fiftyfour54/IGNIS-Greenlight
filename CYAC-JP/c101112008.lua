--深淵の獣アルベル
--The Bystial Aluber
--scripted by Naim
local s,id=GetID()
function s.initial_effect(c)
	--Change name
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(CARD_ALBAZ)
	c:RegisterEffect(e1)
	--Take control of or Special Summon 1 Dragon monster
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id)
	e2:SetCost(s.cost)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
s.listed_names={CARD_ALBAZ}
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function s.cfilter(c,e,tp)
	return c:IsRace(RACE_DRAGON) and
		((c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsControlerCanBeChanged(true))
		 or (c:IsLocation(LOCATION_GRAVE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp,e:GetHandler())>0))
end
--Note:
--the parameter set to true in IsControlerCanBeChanged allows this to be activated even if all mzones are full
--because Aluber will send itself to the graveyard. If this is incorrect, remove the parameter.
--A similar reason is being used for the special summon (a zone will be free after using it)
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return s.cfilter(chkc,e,tp) end
	if chk==0 then return e:GetHandler():IsAbleToGrave() and Duel.IsExistingTarget(s.cfilter,tp,0,LOCATION_MZONE|LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_APPLYTO)
	local tc=Duel.SelectTarget(tp,s.cfilter,tp,0,LOCATION_MZONE|LOCATION_GRAVE,1,1,nil,e,tp):GetFirst()
	if tc:IsLocation(LOCATION_MZONE) then
		e:SetLabel(1)
		e:SetCategory(CATEGORY_CONTROL)
		Duel.SetOperationInfo(0,CATEGORY_CONTROL,tc,1,0,0)
	else
		e:SetLabel(2)
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,0,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,tp,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsAbleToGrave() and Duel.SendtoGrave(c,REASON_EFFECT)>0 and c:IsLocation(LOCATION_GRAVE) then
		local tc=Duel.GetFirstTarget()
		if not tc:IsRelateToEffect(e) then return end
		if e:GetLabel()==1 then
			Duel.GetControl(tc,tp,PHASE_END,1)
		elseif e:GetLabel()==2 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end