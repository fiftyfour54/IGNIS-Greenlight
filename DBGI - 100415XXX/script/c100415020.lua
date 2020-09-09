--シークレット・パスフレーズ
--Secret Passphrase
--Scripted by AlphaKretin
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
end
s.listed_series={0x24c,0x24d,0x24e,0x24f}
function s.thfilter(c,add)
	local c1=(c:IsSetCard(0x24e) or c:IsSetCard(0x24f)) and c:IsType(TYPE_SPELL+TYPE_TRAP)
	local c2=c:IsSetCard(0x24e) and c:IsType(TYPE_MONSTER)
	return (c1 or (add and c2)) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local add=Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsSetCard,0x24c),tp,LOCATION_MZONE,0,1,nil)
			and Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsSetCard,0x24d),tp,LOCATION_MZONE,0,1,nil)
		return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil,add)
	end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local add=Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsSetCard,0x24c),tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsSetCard,0x24d),tp,LOCATION_MZONE,0,1,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,add)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end

