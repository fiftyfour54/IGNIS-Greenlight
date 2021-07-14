--ジョウルリ－パンクナシワリ・サプライズ
--Joururi P.U.N.K. Nashiwari Surprise
--scripted by Rundas
local s,id=GetID()
function s.initial_effect(c)
	--Pop
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
end
s.listed_series={0x26e}
--Pop
function s.filter(c)
	return c:IsSetCard(0x26e) and c:IsMonster() and c:IsFaceup()
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local fu=Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil)
	if chkc then
		if fu then return chkc:IsOnField()
		else return chkc:IsOnField() and chkc:IsFacedown()
		end
	end
	if chk==0 then
		if fu then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil)
		else return Duel.IsExistingTarget(Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,nil)
		end
	end
	local tc
	if fu then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		tc=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		tc=Duel.SelectTarget(tp,Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,1-tp,LOCATION_ONFIELD)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end