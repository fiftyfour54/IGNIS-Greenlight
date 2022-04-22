--砂塵の大ハリケーン
--Twin Dust Trunade
--scripted by Naim
local s,id=GetID()
function s.initial_effect(c)
	--Return itself and set Spell/Traps to the hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMING_SSET+TIMING_END_PHASE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.tgfilter(c)
	return c:IsFacedown() and c:IsAbleToHand() and c:GetSequence()<5
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and s.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_SZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_SZONE,0,1,5,nil)
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetTargetCards(e)
	local rg=tg:Filter(aux.AND(Card.IsAbleToHand,Card.IsFacedown),nil)
	local c=e:GetHandler()
	c:CancelToGrave()
	if #tg==#rg and c:IsAbleToHand() then
		rg:AddCard(c)
		if Duel.SendtoHand(rg,nil,REASON_EFFECT)>0 then
			local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_HAND) 
			local stg=Duel.GetMatchingGroup(Card.IsSSetable,tp,LOCATION_HAND,0,nil):Filter(aux.NOT(Card.IsType),nil,TYPE_FIELD)
			local ft=math.min(#og,Duel.GetLocationCount(tp,LOCATION_SZONE))
			if #og>0 and #stg>#og and ft>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
				Duel.ShuffleHand(tp)
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
				local sg=stg:Select(tp,1,#og,nil)
				Duel.SSet(tp,sg,tp,false)
			end
		end
	end
end
