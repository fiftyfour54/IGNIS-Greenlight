--烙印追放
--Branded Exile
--Logical Nonsense

--Substitute ID
local s,id=GetID()
function s.initial_effect(c)
	--Special Summon 1 "Despia" or level 8+ fusion monster from GY
	local fparams={aux.FilterBoolFunction(Card.IsLevelAbove,8),Fusion.OnFieldMat,s.fextra,Fusion.BanishMaterial,nil,nil}
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate(Fusion.SummonEffTG(table.unpack(fparams)),Fusion.SummonEffOP(table.unpack(fparams))))
	c:RegisterEffect(e1)
end
	--Lists "Despia" archetype
s.listed_series={0x166}

	--Check for "Despia" or level 8+ monster
function s.filter(c,e,tp)
	return (c:IsSetCard(0x166) or c:IsLevelAbove(8) and c:IsType(TYPE_FUSION)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
	--Activation legality
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and s.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
	--Special Summon 1 "Despia" or level 8+ fusion monster from GY
function s.activate(fustg,fusop)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local tc=Duel.GetFirstTarget()
		if not tc or not tc:IsRelateToEffect(e) then return end
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and fustg(e,tp,eg,ep,ev,re,r,rp,0) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		--Fusion Summon 1 level 8+ monster, by banishing monsters from either field
		Duel.BreakEffect()
			fusop(e,tp,eg,ep,ev,re,r,rp)
		end
	end
end
function s.fextra(e,tp,mg)
	return Duel.GetMatchingGroup(Fusion.IsMonsterFilter(Card.IsFaceup),tp,0,LOCATION_ONFIELD,nil)
end