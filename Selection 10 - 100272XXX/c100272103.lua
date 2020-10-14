--銀河眼の極光波竜
--Galaxy-Eyes Cipher Ex Dragon
local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,10,2,s.ovfilter,aux.Stringid(id,0))
	c:EnableReviveLimit()
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
function s.ovfilter(c,tp,lc)
	return c:IsFaceup() and c:IsSetCard(0x10e5,lc,SUMMON_TYPE_XYZ,tp) and c:IsType(TYPE_XYZ,lc,SUMMON_TYPE_XYZ,tp)
end

function s.lizardcheck(c,tp)
	return c:IsAbleToExtra() and not c:IsHasEffect(CARD_CLOCK_LIZARD)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetOriginalCode(),{c:GetOriginalSetCard()},c:GetOriginalType(),c:GetBaseAttack(),c:GetBaseDefense(),c:GetOriginalLevel(),c:GetOriginalRace(),c:GetOriginalAttribute())
end

function s.filter(c,e,tp)
	return c:IsRankBelow(9) and c:IsRace(RACE_DRAGON) and e:GetHandler():IsCanBeXyzMaterial(c,tp)
	and Duel.GetLocationCountFromEx(tp,tp,e:GetHandler(),c)>0
	and Duel.GetLocationCountFromEx(tp,tp,e:GetHandler(),TYPE_XYZ)>0
	and s.lizardcheck(c,tp)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and s.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if #tc==0 or c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsControler(1-tp) or c:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	if tc then
		local mg=c:GetOverlayGroup()
		if #mg~=0 then
			Duel.Overlay(tc,mg)
		end
		tc:SetMaterial(Group.FromCards(c))
		Duel.Overlay(tc,Group.FromCards(c))
		Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end