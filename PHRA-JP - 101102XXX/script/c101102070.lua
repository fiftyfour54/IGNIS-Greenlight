--鉄獣の抗戦
--Tribrigade Revolt
--Scripted by Naim
local s,id=GetID()
function s.initial_effect(c)
	--Special Summon from hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.spfilter2(c,fg)
	return c:IsRace(RACES_BEAST_BWARRIOR_WINGB) and c:IsLinkSummonable(fg,fg)
end
function s.spfilter(c,e,tp,fg)
	--Debug.Message(Duel.IsExistingMatchingCard(s.spfilter2,tp,LOCATION_EXTRA,0,1,nil,fg))
	return c:IsRace(RACES_BEAST_BWARRIOR_WINGB) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (c:IsLocation(LOCATION_GRAVE) or (c:IsLocation(LOCATION_REMOVED) and c:IsFaceup()))
		and Duel.IsExistingMatchingCard(s.spfilter2,tp,LOCATION_EXTRA,0,1,nil,fg)
end
function s.filtercheck(c,e,tp)
	return c:IsCanBeLinkMaterial() and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsRace(RACES_BEAST_BWARRIOR_WINGB)
		and (c:IsLocation(LOCATION_GRAVE) or (c:IsLocation(LOCATION_REMOVED) and c:IsFaceup()))
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local fg=Duel.GetMatchingGroup(s.filtercheck,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
	Debug.Message(#fg)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,fg)
		and Duel.IsPlayerCanSpecialSummonCount(tp,2) and ft>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,nil,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local fg=Duel.GetMatchingGroup(s.filtercheck,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
	if ft<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,ft,nil,e,tp,fg)
	if (not g or #g==0 or not Duel.SpecialSummonStep(g,0,tp,tp,false,false,POS_FACEUP)) then
		return false
	end
	local c=e:GetHandler()
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2)
		Duel.SpecialSummonComplete()
	end
	local tg=Duel.GetMatchingGroup(s.spfilter2,tp,LOCATION_EXTRA,0,nil,g)
	if #tg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=tg:Select(tp,1,1,nil)
		local sc=sg:GetFirst()
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_SPSUMMON_SUCCESS)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		e3:SetOperation(s.regop)
		sc:RegisterEffect(e3)
		Duel.LinkSummon(tp,sc,g,nil)
	end
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetOwner()
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(rc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_TRIGGER)
	c:RegisterEffect(e2)
	e:Reset()
end