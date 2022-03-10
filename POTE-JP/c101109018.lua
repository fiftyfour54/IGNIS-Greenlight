-- 花と野原の春化精
-- Vernalizer Fairy of Flowers and Fields
-- Scripted by Hatter
local s,id=GetID()
function s.initial_effect(c)
	-- Effect targetting protection
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x27e))
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	-- Add 1 "Vernalizer Fairy" card from the GY to the hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,id)
	e2:SetCost(s.thcost)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
s.listed_names={id}
s.listed_series={0x27e}
function s.thcostfilter(c)
	return (c:IsMonster() or c:IsSetCard(0x27e)) and c:IsDiscardable()
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable()
		and Duel.IsExistingMatchingCard(s.thcostfilter,tp,LOCATION_HAND,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,s.thcostfilter,tp,LOCATION_HAND,0,1,1,c)
	Duel.SendtoGrave(g+c,REASON_COST+REASON_DISCARD)
end
function s.thfilter(c)
	return c:IsAttribute(ATTRIBUTE_EARTH) and not c:IsCode(id) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if #g<1 or Duel.SendtoHand(g,nil,REASON_EFFECT)<1 or not g:GetFirst():IsLocation(LOCATION_HAND) then return end
	Duel.ConfirmCards(1-tp,g)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if #sg<1 then return end
		Duel.BreakEffect()
		if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)>0 then
			-- Cannot activate monster effects, except EARTH monsters'
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
			e1:SetDescription(aux.Stringid(id,2))
			e1:SetTargetRange(1,0)
			e1:SetValue(function(e,re) return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsAttribute(ATTRIBUTE_EARTH) end)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end