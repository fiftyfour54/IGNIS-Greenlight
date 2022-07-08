--ツインバレル・ドラゴン (Rush)
--Twin-Barrel Dragon (Rush)
--scripted by YoshiDuels
local s,id=GetID()
function s.initial_effect(c)
	c:Alias(70050374)
	--Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_COIN)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.descon)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
end
s.toss_coin=true
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsStatus(STATUS_SUMMON_TURN+STATUS_SPSUMMON_TURN)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	--Effect
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #g==0 then return end
	Duel.HintSelection(g,true)
	local c1,c2=Duel.TossCoin(tp,2)
	if c1+c2<2 then return end
	g=g:AddMaximumCheck()
	Duel.Destroy(g,REASON_EFFECT)
end
