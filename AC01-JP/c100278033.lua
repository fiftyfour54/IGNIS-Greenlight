-- 人形の家
-- Doll House
-- Scripted by Hatter
local s,id=GetID()
function s.initial_effect(c)
	-- Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	-- Special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	-- Attach material and end battle phase
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(s.bpcon)
	e3:SetTarget(s.bptg)
	e3:SetOperation(s.bpop)
	c:RegisterEffect(e3)
end
s.listed_names={75574498,44190146}
function s.spfilter(c,code,e,tp)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.tgfilter(c,e,tp)
	return c:IsType(TYPE_NORMAL) and (c:IsAttack(0) or c:IsDefense(0))
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode(),e,tp)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>0 and Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	if Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsCode,75574498),tp,LOCATION_MZONE,0,1,nil)
		and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then
		ft=math.min(2,ft)
	else ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_GRAVE,0,1,ft,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,#g,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetTargetCards(e)
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<#g 
		or Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) 
	then return end
	-- Ensure there will be a summonable card for each target
	local tc=g:GetFirst()
	local sg1=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK,0,nil,tc:GetCode(),e,tp)
	if #sg1<1 then return end
	local sg2
	if #g==2 then
		tc=g:GetNext()
		sg2=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK,0,nil,tc:GetCode(),e,tp)
		if #sg2<1 or #sg1+#sg2<=1 then return end
	end
	-- Select cards to summon; ensure no overlap
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local ssg=sg1:Select(tp,1,1,false)
	if sg2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		ssg=ssg+sg2:Select(tp,1,1,false,ssg)
	end
	if #g==#ssg then
		for sc in ~ssg do
			-- Special summon as Level 6 DARK monster
			Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(ATTRIBUTE_DARK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CHANGE_LEVEL)
			e2:SetValue(6)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e2,true)
		end
		Duel.SpecialSummonComplete()
	end
end
function s.bpcon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetAttacker():GetOwner()
end
function s.bptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsCode,75574498),tp,LOCATION_MZONE,0,1,nil)
			and Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsCode,44190146),tp,LOCATION_MZONE,0,1,nil)
	end
end
function s.bpop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local mg=Duel.GetMatchingGroup(aux.FilterFaceupFunction(Card.IsCode,44190146),tp,LOCATION_MZONE,0,nil)
	local tg=Duel.GetMatchingGroup(aux.FilterFaceupFunction(Card.IsCode,75574498),tp,LOCATION_MZONE,0,nil)
	if #mg>0 and #tg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local mc=mg:Select(tp,1,1,false):GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
		local tc=tg:Select(tp,1,1,false):GetFirst()
		if mc and tc then
			Duel.Overlay(tc,mc)
			Duel.BreakEffect()
			Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
		end
	end
end