--冥占術姫タロットレイス
--Nether Prediction Princess Tarotreith
--Scripted by DyXel
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--TODO: Prediction Princess Tarotrei Special Summoning condition.
	--FLIP: Special Summon 1 Flip monster from Deck.
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--Flip face-up or face-down any number of monsters.
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMINGS_CHECK_MONSTER_E,0)
	e2:SetRange(LOCATION_MZONE,0)
	e2:SetCountLimit(1,{id,1})
	e2:SetTarget(s.postg)
	e2:SetOperation(s.posop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(id,3))
	e3:SetTarget(s.postg2)
	e3:SetOperation(s.posop2)
	c:RegisterEffect(e3)
end
s.listed_names={101110063,94997874}
function s.spfilter(c,e,tp)
	return c:IsType(TYPE_FLIP) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
		       Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,1,nil)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
	Duel.ConfirmCards(1-tp,sg)
end
function s.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_MZONE,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,POS_FACEUP_DEFENSE)
end
function s.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	Duel.ChangePosition(g:Select(tp,1,#g,false,nil),POS_FACEUP_DEFENSE)
end
function s.posfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function s.postg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.posfilter,tp,LOCATION_MZONE,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,POS_FACEDOWN_DEFENSE)
end
function s.posop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.posfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	Duel.ChangePosition(g:Select(tp,1,#g,false,nil),POS_FACEUP_DEFENSE)
end
