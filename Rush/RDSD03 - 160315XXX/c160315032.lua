--ＲＢドラフォン
--RB Draphone
--scripted by YoshiDuels
local s,id=GetID()
function s.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
s.listed_names={160010101,160315001}
function s.cfilter(c,tp)
	return c:GetPreviousRaceOnField()&RACE_DRAGON>0 and c:GetReasonPlayer()==1-tp and c:IsPreviousControler(tp) 
		and c:IsPreviousLocation(LOCATION_MZONE) and (c:IsReason(REASON_EFFECT) or (c:IsReason(REASON_BATTLE) and Duel.GetAttacker():IsControler(1-tp)))
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,2)
end
function s.spfilter(c,e,sp)
	return c:IsCode(160010101,160315001) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,2,REASON_EFFECT)
	if Duel.GetOperatedGroup():GetCount()==2 then
		Duel.BreakEffect()
		if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
			and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
			if #g>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
