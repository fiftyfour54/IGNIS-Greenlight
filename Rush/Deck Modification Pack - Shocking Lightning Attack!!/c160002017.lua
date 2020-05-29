-- ライトニング・ボルコンドル
-- Lightning Bolcondor
local s,id=GetID()
function s.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.tgfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost() and c:IsAttribute(ATTRIBUTE_WATER)
end
function s.filter(c)
	return c:IsType(TYPE_MONSTER)
	and Duel.IsExistingMatchingCard(s.atkfilter,tp,LOCATION_HAND,0,1,nil,c:GetAttribute())
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDefensePos,tp,0,LOCATION_MZONE,1,e:GetHandler()) end
end

function s.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
	and Duel.IsExistingMatchingCard(s.atkfilter,tp,0,LOCATION_MZONE,1,nil,c:GetAttribute())
end
function s.atkfilter(c,att)
	return c:IsFaceup() and c:IsAttribute(att)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--requirement
	local tc=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	Duel.SendtoGrave(tc,REASON_COST)
	--effect
	if c:IsRelateToEffect(e) then
		local g=Duel.GetMatchingGroup(s.atkfilter,tp,0,LOCATION_MZONE,nil,tc:GetAttribute)
		if #g>0 then
		local sc=g:GetFirst()
		local atk=tc:GetLevel()*300
		for sc in aux.Next(g) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetValue(-atk)
			sc:RegisterEffect(e1)
		end
		else return end
	end
end