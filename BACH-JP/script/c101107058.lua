--Ogdoadic Flood
--Scripted by Neo Yuno
local s,id=GetID()
function s.initial_effect(c)
	--Activate
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --Special Summon a Reptile from GY
	local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id)
    e2:SetCost(s.spcost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	--Send a Reptile from Deck to GY
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,{id,1})
	e3:SetCondition(s.tgcon)
	e3:SetTarget(s.tgtg)
	e3:SetOperation(s.tgop)
	c:RegisterEffect(e3)
end
--Special Summon a Reptile from GY
function s.tgfilter(c,e,tp,ft)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost() and (ft>0 or (c:GetSequence()<5 and c:IsControler(tp))) 
        and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,c:GetOriginalAttribute(),e,tp)
end
function s.spfilter(c,att,e,tp)
	return c:IsRace(RACE_REPTILE) and not c:IsOriginalAttribute(att) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and s.spfilter(chkc,e:GetLabel(),e,tp) end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return ft>-1 and Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil,e,tp,ft)
	end
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil,e,tp,ft)
	local att=g:GetFirst():GetOriginalAttribute()
	e:SetLabel(att)
	Duel.SendtoGrave(g,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,att,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
--Send a Reptile from Deck to GY
function s.filter(c,tp)
	return c:IsControler(1-tp) and c:IsType(TYPE_MONSTER)
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase() and eg:IsExists(s.filter,1,nil,tp)
end
function s.tgfilter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_REPTILE) and c:IsAbleToGrave()
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
end