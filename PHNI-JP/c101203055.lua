--マチュア・クロニクル
--Mature Chronicle
--scripted by Naim
local s,id=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x25) --Chronicle Counter
	--Place 1 -Chronicle Counter on this card
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(s.countercon)
	e1:SetOperation(function(e) e:GetHandler():AddCounter(0x25,1) end)
	c:RegisterEffect(e1)
	--Remove any number of counters to apply the appropriate effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.countertg)
	c:RegisterEffect(e2)
end
s.listed_names={CARD_YUBEL,48130397} --Super Polymerization
s.counter_place_list={0x25}
function s.yubelfilter(c)
	return c:IsFaceup() and (c:IsCode(CARD_YUBEL) or c:ListsCode(CARD_YUBEL))
end
function s.countercon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.yubelfilter,1,nil)
end
function s.countertg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=c:IsCanRemoveCounter(tp,0x25,1,REASON_COST) and s.sptg(e,tp,eg,ep,ev,re,r,rp,0)
	local b2=c:IsCanRemoveCounter(tp,0x25,2,REASON_COST) and s.thtg(e,tp,eg,ep,ev,re,r,rp,0)
	local b3=c:IsCanRemoveCounter(tp,0x25,3,REASON_COST) and s.rmvtg(e,tp,eg,ep,ev,re,r,rp,0)
	local b4=c:IsCanRemoveCounter(tp,0x25,4,REASON_COST) and s.destg(e,tp,eg,ep,ev,re,r,rp,0)
	local b5=c:IsCanRemoveCounter(tp,0x25,5,REASON_COST) and s.superpolytg(e,tp,eg,ep,ev,re,r,rp,0)
	if chk==0 then return (b1 or b2 or b3 or b4 or b5) end
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(id,1)},
		{b2,aux.Stringid(id,2)},
		{b3,aux.Stringid(id,3)},
		{b4,aux.Stringid(id,4)},
		{b5,aux.Stringid(id,5)})
	c:RemoveCounter(tp,0x25,op,REASON_COST)
	if op==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		s.sptg(e,tp,eg,ep,ev,re,r,rp,1)
		e:SetOperation(s.spop)
	elseif op==2 then
		e:SetCategory(CATEGORY_TOHAND)
		s.thtg(e,tp,eg,ep,ev,re,r,rp,1)
		e:SetOperation(s.thop)
	elseif op==3 then
		e:SetCategory(CATEGORY_REMOVE)
		s.rmvtg(e,tp,eg,ep,ev,re,r,rp,1)
		e:SetOperation(s.rmvop)
	elseif op==4 then
		e:SetCategory(CATEGORY_DESTROY)
		s.destg(e,tp,eg,ep,ev,re,r,rp,1)
		e:SetOperation(s.desop)
	elseif op==5 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		s.superpolytg(e,tp,eg,ep,ev,re,r,rp,1)
		e:SetOperation(s.superpolyop)
	end
end
function s.spfilter(c,e,tp)
	return c:IsCode(CARD_YUBEL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_REMOVED,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.rmvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function s.rmvop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
	end
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,tp,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g,true)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function s.superpolyfilter(c)
	return c:IsCode(48130397) and c:IsAbleToHand()
end
function s.superpolytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.superpolyfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.superpolyop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.superpolyfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end