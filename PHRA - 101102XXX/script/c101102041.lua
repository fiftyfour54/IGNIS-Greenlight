--アーク・リベリオン・エクシーズ・ドラゴン
--Ark Rebellion Xyz Dragon
--Scripted by AlphaKretin
local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,5,3)
	c:EnableReviveLimit()
	--cannot be destroyed
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(1)
	e2:SetCondition(s.indescon)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_NEGATE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,id)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(s.atkcost)
	e3:SetTarget(s.atktg)
	e3:SetOperation(s.atkop)
	c:RegisterEffect(e3,false,REGISTER_FLAG_DETACH_XMAT)
end
function s.indescon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function s.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.atkfilter(c)
	return c:IsFaceup() and c:GetBaseAttack()>0
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
end
function s.ovfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_XYZ)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsRelateToEffect(e) and c:IsFaceup()) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp,s.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c):GetFirst()
	if tc then
		if c:UpdateAttack(tc:GetBaseAttack())==tc:GetBaseAttack() and c:GetOverlayGroup():IsExists(s.ovfilter,1,nil) then
			local g1=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
			if #g1>0 then
				Duel.BreakEffect()
			end
			local ng=g1:Filter(aux.disfilter1,nil)
			local nc=ng:GetFirst()
			for nc in aux.Next(ng) do
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				nc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				nc:RegisterEffect(e2)
				if nc:IsType(TYPE_TRAPMONSTER) then
					local e3=Effect.CreateEffect(c)
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
					e3:SetReset(RESET_EVENT+RESETS_STANDARD)
					nc:RegisterEffect(e3)
				end
			end
		end
	end
end