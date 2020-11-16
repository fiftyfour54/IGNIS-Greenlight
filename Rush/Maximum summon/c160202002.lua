--Super Magitek Deity Magnum Over Road
local s,id=GetID()
function s.initial_effect(c)
	Maximum.AddProcedure(c,nil,s.filter1,s.filter2)
	--Cannot be destroyed
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.indcon)
	e2:SetValue(s.indval)
	c:RegisterEffect(e2)
	c:AddMaximumAtkHandler()
end
s.MaximumAttack=3500
function s.filter1(c)
	return c:IsCode(160202001)
end
function s.filter2(c)
	return c:IsCode(170000003)
end
function s.indcon(e)
	--maximum mode check to do
	return e:GetHandler():IsMaximumModeCenter()
end
function s.indval(e,re,rp)
	return re:IsActiveType(TYPE_TRAP)
end