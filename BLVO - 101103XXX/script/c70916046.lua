--壱時砲固定式
--Stationary One-o'-Clock Linear Accelerator
--Scripted by Eerie Code
local s,id=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_TODECK+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function s.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and c:IsHasLevel()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,0,LOCATION_MZONE,1,nil)
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
	local ac=Duel.AnnounceNumber(tp,1,2,3,4,5,6)
	e:SetLabel(ac)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_ONFIELD)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local gc=0
	local dc=e:GetLabel()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local ct=(tc:GetLevel()*dc)+Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
		if ct==Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) then
			local tbl={}
			for i=dc,1,-1 do
				if Duel.IsPlayerCanDiscardDeck(tp,i) then table.insert(tbl,i) end
			end
			local ac=Duel.AnnounceNumber(tp,table.unpack(tbl))
			Duel.DiscardDeck(tp,ac,REASON_EFFECT)
			gc=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
			if gc>0 then
				local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,gc,nil)
				if #g>0 then
					Duel.SendtoDeck(g,nil,-2,REASON_EFFECT)
				end
			end
		end
	end
	if gc==0 then
		local lp=Duel.GetLP(tp)
		Duel.SetLP(tp,math.max(lp-(dc*500),0))
	end
end
