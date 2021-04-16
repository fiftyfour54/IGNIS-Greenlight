--ＬＬ－セレスト・ワグテイル
--Lyrilusc - Celeste Wagtail
--Scripted by The Razgriz
local s,id=GetID()
function s.initial_effect(c)
	--Add 1 LL S/T from Deck to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--Attach to 1 LL Xyz monster from GY
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_LEAVE_GRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id+100)
	e2:SetCondition(s.atchcon)
	e2:SetOperation(s.atchop)
	c:RegisterEffect(e2)
end
s.listed_series={0xf7}
function s.thfilter(c)
	return c:IsSetCard(0xf7) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.filter(c)
	return c:IsSetCard(0xf7) and c:IsType(TYPE_XYZ)
end
function s.atchcon(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	return Duel.IsExistingTarget(aux.FilterFaceupFunction(s.filter),tp,LOCATION_MZONE,0,1,nil)
end
function s.atchop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectTarget(tp,aux.FilterFaceupFunction(s.filter),tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	if tc and tc:IsControler(tp) and not tc:IsFacedown() then
		Duel.Overlay(tc,c)
	end
end