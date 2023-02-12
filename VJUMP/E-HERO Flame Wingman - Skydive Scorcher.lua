--E・HERO フレイム・ウィングマン－フレイム・シュート
--Elemental HERO Flame Wingman - Infernal Rage
--Scripted by Larry126
local s,id=GetID()
function s.initial_effect(c)
	--Fusion procedure
	c:EnableReviveLimit()
	Fusion.AddProcMixN(c,true,true,s.ffilter,2)
	--Add 1 "Favorite" card from your Deck or GY to your hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--Special Summon 1 Level 7 or lower "Elemental HERO" monster from your Deck or Extra Deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,{id,1})
	e2:SetCondition(s.spcon)
	e2:SetCost(s.spcost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(s.valcheck)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end
s.material_setcode={SET_ELEMENTAL_HERO}
s.listed_series={SET_ELEMENTAL_HERO,SET_FAVOURITE}
function s.fusfilter(c,attr,fc,sumtype,tp)
	return c:IsAttribute(attr,fc,sumtype,tp) and not c:IsHasEffect(511002961)
end
function s.ffilter(c,fc,sumtype,tp,sub,mg,sg)
	return c:IsSetCard(SET_ELEMENTAL_HERO,fc,sumtype,tp) and c:GetAttribute(fc,sumtype,tp)~=0
		and (not sg or not sg:IsExists(s.fusfilter,1,c,c:GetAttribute(fc,sumtype,tp),fc,sumtype,tp))
end
function s.thfilter(c)
	return c:IsSetCard(SET_FAVOURITE) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.valcheck(e,c)
	e:GetLabelObject():SetLabel(c:GetMaterial():FilterCount(Card.IsType,nil,TYPE_NORMAL))
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and e:GetLabel()>0
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function s.spfilter(c,e,tp,ec)
	return c:IsSetCard(SET_ELEMENTAL_HERO) and c:IsLevelBelow(7) and not c:IsSummonableCard()
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
		and (c:IsLocation(LOCATION_DECK) and Duel.GetMZoneCount(tp,ec)>0
		or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,ec,c)>0)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp,e:GetHandler())
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
