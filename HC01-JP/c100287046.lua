-- 運命の囚人
-- Prisoner of Destiny
-- Scripted by Hatter
local s,id=GetID()
function s.initial_effect(c)
	-- Allow counter placement and limit it to 3
	c:EnableCounterPermit(0x20b)
	c:SetCounterLimit(0x20b,3)
	-- Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e0)
	-- Place counter and apply effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_COUNTER+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(s.ctcon)
	e1:SetTarget(s.cttg)
	e1:SetOperation(s.ctop)
	c:RegisterEffect(e1)
end
s.counter_place_list={0x20b}
function s.ctconfilter(c)
	return c:IsType(TYPE_LINK) and c:IsSummonType(SUMMON_TYPE_LINK) and c:IsLink(4)
end
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.ctconfilter,1,nil)
end
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanAddCounter(0x20b,1) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x20b)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsRelateToEffect(e) and c:IsFaceup() and c:AddCounter(0x20b,1)) then return end
	local ct=c:GetCounter(0x20b)
	-- Declare card name and negate effects
	if ct==1 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
		local ac=Duel.AnnounceCard(tp)
		Duel.BreakEffect()
		-- Negate effects
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
		e1:SetTarget(function(_,c) return c:IsOriginalCodeRule(ac) end)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(function(_,_,_,_,_,re) return re:GetHandler():IsOriginalCodeRule(ac) end)
		e2:SetOperation(function(_,_,_,_,ev) Duel.NegateEffect(ev) end)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
		e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		Duel.RegisterEffect(e3,tp)
	-- Special Summon from the GY
	elseif ct==2 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spgyfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spgyfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if #g==0 then return end
		Duel.BreakEffect()
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	-- Send self to the GY and Special Summon a Link monster
	elseif ct==3 and c:IsAbleToGrave() and Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(s.spexfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
		Duel.BreakEffect()
		if Duel.SendtoGrave(c,REASON_EFFECT)<1 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spexfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if #g==0 then return end
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.spgyfilter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spexfilter(c,e,tp)
	return c:IsLink(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end