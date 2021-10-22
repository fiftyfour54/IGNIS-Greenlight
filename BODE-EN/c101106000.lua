--Heritage of the Light
--Scripted by Eerie Code
local s,id=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,{id,0})
	e2:SetCondition(s.drcon)
	e2:SetTarget(s.drtg)
	e2:SetOperation(s.drop)
	c:RegisterEffect(e2)
end
function s.cfilter(c,tp)
	if c:IsSummonType(SUMMON_TYPE_FUSION) then
		return Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsType,TYPE_FUSION),0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
	elseif c:IsSummonType(SUMMON_TYPE_RITUAL) then
		return Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsType,TYPE_RITUAL),0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
	elseif c:IsSummonType(SUMMON_TYPE_SYNCHRO) then
		return Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsType,TYPE_SYNCHRO),0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
	elseif c:IsSummonType(SUMMON_TYPE_XYZ) then
		return Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsType,TYPE_XYZ),0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
	else
		return false
	end
end
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.drcfilter,1,nil,tp)
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
