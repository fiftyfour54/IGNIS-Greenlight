--Magician's Act
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	aux.AddPreDrawSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return Duel.GetCurrentChain()==0 and Duel.GetTurnCount()==1
	and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,CARD_DARK_MAGICIAN)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	--ask if you want to activate the skill or not
	if not Duel.SelectYesNo(tp,aux.Stringid(id,0)) then return end
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--select option
	local opt=0
	local g1=Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,CARD_DARK_MAGICIAN)
	local g2=Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_HAND,0,1,nil,CARD_DARK_MAGICIAN)
	if g1 and g2 then
		opt=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
	elseif g1 then
		opt=Duel.SelectOption(tp,aux.Stringid(id,1))
	elseif g2 then
		opt=Duel.SelectOption(tp,aux.Stringid(id,2))+1
	else return end
	
	if opt==0 then
	--Add 1 "Dark Magician" from your Deck to your hand, then shuffle 1 card from your hand into the Deck.
		local g1=Duel.GetMatchingGroup(Card.IsCode,p,LOCATION_DECK,0,nil,CARD_DARK_MAGICIAN)
		local sg=g:Select(p,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		local g2=Duel.GetFieldGroup(tp,LOCATION_HAND,0):Select(tp,1,1,nil)
		Duel.SendtoDeck(g2,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	else
	--Shuffle 1 "Dark Magician" from your hand into the Deck, then draw 1 card.
		local g=Duel.GetMatchingGroup(Card.IsCode,p,LOCATION_HAND,0,nil,CARD_DARK_MAGICIAN)
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
		local sg=g:Select(p,1,1,nil)
		Duel.ConfirmCards(1-p,sg)
		Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		Duel.ShuffleDeck(p)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end