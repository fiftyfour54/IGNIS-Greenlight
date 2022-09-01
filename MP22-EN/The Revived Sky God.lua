--
--The Revived Sky God
--Scripted by Larry126
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DRAW_PHASE,TIMING_STANDBY_PHASE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_CANNOT_INACTIVATE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_END_PHASE,TIMING_END_PHASE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,{id,1})
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.tdtg)
	e2:SetOperation(s.tdop)
	c:RegisterEffect(e2)
end
s.listed_names={CARD_MONSTER_REBORN,10000020}
function s.spfilter(c,e,tp)
	return c:IsCode(10000020) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct1=6-Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local ct2=6-Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and ct1>0 and Duel.IsPlayerCanDraw(tp,ct1)
		and ct2>0 and Duel.IsPlayerCanDraw(1-tp,ct2) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,ct2)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.BreakEffect()
		local ct1=6-Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
		local ct2=6-Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
		if ct1>0 then
			Duel.Draw(tp,ct1,REASON_EFFECT)
		end
		if ct2>0 then
			Duel.Draw(1-tp,ct2,REASON_EFFECT)
		end
	end
end
function s.filter(c,deckCount)
	return c:IsCode(CARD_MONSTER_REBORN) and (c:IsLocation(LOCATION_DECK) and deckCount>1
		or not c:IsLocation(LOCATION_DECK) and c:IsAbleToDeck())
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)):GetFirst()
	if tc then
		if tc:IsLocation(LOCATION_DECK) then
			Duel.ShuffleDeck(tp)
			Duel.MoveToDeckTop(tc)
		else
			Duel.HintSelection(tc,true)
			Duel.SendtoDeck(tc,nil,SEQ_DECKTOP,REASON_EFFECT)
		end
		if not tc:IsLocation(LOCATION_EXTRA) then
			Duel.ConfirmDecktop(tp,1)
		end
		if (tc:IsLocation(LOCATION_DECK) and Duel.GetDecktopGroup(tp,1):IsContains(tc)
			or tc:IsLocation(LOCATION_EXTRA) and Duel.GetExtraTopGroup(tp,1):IsContains(tc))
			and Duel.IsExistingMatchingCard(Card.IsRace,tp,LOCATION_GRAVE,0,1,nil,RACE_DIVINE) then
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
