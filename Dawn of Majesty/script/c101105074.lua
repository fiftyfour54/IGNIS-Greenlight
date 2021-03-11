--きまぐれ軍實握り

--scripted by XyleN5967
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--draw & to deck
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW) 
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_GRAVE) 
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost) 
	e2:SetTarget(s.drtg)
	e2:SetOperation(s.drop)
	c:RegisterEffect(e2)
end
s.listed_series={SET_SUSHIP}
s.listed_series={CARD_RICE_SUSHIP}
function s.cfilter(c)
	return c:IsCode(101105011) and not c:IsPublic() 
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetDecktopGroup(tp,3)
		return #g>=3 and g:FilterCount(Card.IsAbleToHand,nil)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tg=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_HAND,0,nil)
	if #tg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		local sg=tg:Select(tp,1,1,nil)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleHand(tp)
	end
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3) 
	if g and g:IsExists(Card.IsCode,1,nil,101105011)
		and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		local res=tp
		e:SetLabel(res)
	else
		local res=1-tp
		e:SetLabel(res)
	end
	local res=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,res,HINTMSG_ATOHAND)
	local sc=g:Select(res,1,1,nil):GetFirst()
	if sc:IsAbleToHand() then
		Duel.SendtoHand(sc,nil,REASON_EFFECT)
		Duel.ConfirmCards(res,sc)
		Duel.ShuffleHand(tp)
	else
		Duel.SendtoGrave(sc,REASON_RULE)
	end
	Duel.ShuffleDeck(tp)
end
function s.tdfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(SET_SUSHIP) and c:IsAbleToDeck()
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.tdfilter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(s.tdfilter,tp,LOCATION_GRAVE,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,s.tdfilter,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==3 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
