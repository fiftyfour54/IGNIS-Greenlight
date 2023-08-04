--ヴァルモニカ・ヴェルサーレ
--Valmonica Versare
--Scripted by Eerie Code
local s,id=GetID()
function s.initial_effect(c)
	--register effects
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_RECOVER|CATEGORY_TOHAND|CATEGORY_SEARCH)
	e1:SetTarget(s.rctg)
	e1:SetOperation(s.rcop)
	c:RegisterEffect(e1,false,REGISTER_FLAG_VALMONICA_RCV)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DAMAGE|CATEGORY_TOGRAVE)
	e2:SetTarget(s.dmgtg)
	e2:SetOperation(s.dmgop)
	c:RegisterEffect(e2,false,REGISTER_FLAG_VALMONICA_DMG)
	--activate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e3:SetLabelObject({e1,e2})
	e3:SetTarget(s.target)
	c:RegisterEffect(e3)
end
s.listed_series={SET_VALMONICA }
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ef=e:GetLabelObject()
	local p=Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,1,nil,SET_VALMONICA) and tp or 1-tp
	local op=Duel.SelectOption(p,ef[1]:GetDescription(),ef[2]:GetDescription())
	ef[op]:GetTarget()(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetCategory(ef[op]:GetCategory())
	e:SetOperation(ef[op]:GetOperation())
end
function s.rctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.rcop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_DECK,0,nil,SET_VALMONICA)
	local dcount=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if Duel.Recover(tp,500,REASON_EFFECT)~=0 then
		if dcount==0 then return end
		if #g==0 then
			Duel.ConfirmDecktop(tp,dcount)
			Duel.ShuffleDeck(tp)
			return
		end
		if not Duel.SelectYesNo(tp,aux.Stringid(id,2)) then return end
		Duel.BreakEffect()
		local seq=-1
		local spcard=nil
		for tc in g:Iter() do
			if tc:GetSequence()>seq then
				seq=tc:GetSequence()
				spcard=tc
			end
		end
		Duel.ConfirmDecktop(tp,dcount-seq)
		if spcard:IsAbleToHand() then
			Duel.SendtoHand(spcard,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,spcard)
			Duel.ShuffleHand(tp)
		end
		Duel.ShuffleDeck(tp)
	end
end
function s.dmgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,500)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.gyfilter(c)
	return c:IsSetCard(SET_VALMONICA) and not c:IsCode(id) and c:IsAbleToGrave()
end
function s.dmgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.gyfilter,tp,LOCATION_DECK,0,nil)
	if Duel.Damage(tp,500,REASON_EFFECT)~=0 and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
