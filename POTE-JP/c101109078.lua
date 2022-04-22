-- 現世離レ
-- Sundered from Overroot
-- Scripted by Hatter
local s,id=GetID()
function s.initial_effect(c)
	-- Send 1 card to the GY and Set 1 card from the GY
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.tgtg)
	e1:SetOperation(s.tgop)
	c:RegisterEffect(e1)
end
function s.tgfilter(c,e)
	return c:IsAbleToGrave() and c:IsCanBeEffectTarget(e)
end
function s.setfilter(c,e,tp)
	return c:IsCanBeEffectTarget(e)
		and (c:IsType(TYPE_SPELL+TYPE_TRAP) or c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE,1-tp))
end
function s.rescon(sg,e,tp)
	local g1,g2=sg:Split(Card.IsOnField,nil)
	if #g1~=1 or #g2~=1 then return end
	local c1,c2=g1:GetFirst(),g2:GetFirst()
	if c2:IsMonster() then return Duel.GetMZoneCount(1-tp,c1)>0 end
	if c2:IsType(TYPE_SPELL) and c2:IsType(TYPE_FIELD) then return true end
	return c1:IsLocation(LOCATION_SZONE) and c1:GetSequence()<5 --[[and check if exc's zone is not disabled]]
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g1=Duel.GetMatchingGroup(s.tgfilter,tp,0,LOCATION_ONFIELD,nil,e)
	local g2=Duel.GetMatchingGroup(s.setfilter,tp,0,LOCATION_GRAVE,nil,e,tp)
	if chk==0 then return #g1>0 and #g2>0 and aux.SelectUnselectGroup(g1+g2,e,tp,2,2,s.rescon,0) end
	local tg=aux.SelectUnselectGroup(g1+g2,e,tp,2,2,s.rescon,1,tp,HINTMSG_TARGET)
	Duel.SetTargetCard(tg)
	g1,g2=tg:Split(Card.IsOnField,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g1,1,0,0)
	local cat=e:GetCategory()
	if g2:GetFirst():IsMonster() then
		e:SetCategory(cat|CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g2,1,0,0)
	else
		e:SetCategory(cat&~CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g2,1,0,0)
	end
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetTargetCards(e)
	local g1,g2=tg:Split(Card.IsOnField,nil)
	if #g1~=1 or #g2~=1 then return end
	local c1,c2=g1:GetFirst(),g2:GetFirst()
	if not c1:IsAbleToGrave() then return end
	if c2:IsMonster() then
		if Duel.GetMZoneCount(1-tp,c1)<1 or not c2:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE,1-tp) then return end
		Duel.SendtoGrave(c1,REASON_EFFECT)
		Duel.SpecialSummon(c2,0,tp,1-tp,false,false,POS_FACEDOWN_DEFENSE)
	elseif (c2:IsType(TYPE_SPELL) and c2:IsType(TYPE_FIELD))
		or (c1:IsLocation(LOCATION_SZONE) and c1:GetSequence()<5 --[[and check if exc's zone is not disabled]]) then
		Duel.SendtoGrave(c1,REASON_EFFECT)
		Duel.SSet(1-tp,c2)
	end
end