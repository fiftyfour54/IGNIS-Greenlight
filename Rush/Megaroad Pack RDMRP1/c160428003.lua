--Supreme Beast Magnum Overlord [L]
local s,id=GetID()
function s.initial_effect(c)
	-- cannot attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.maxCon)
	e1:SetTargetRange(0,1)
	e1:SetValue(s.aclimit)
	c:RegisterEffect(e1)
	c:AddSideMaximumHandler(e1)
	--register flag
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.regcon)
	e2:SetOperation(s.regop)
	c:RegisterEffect(e2)
	c:AddSideMaximumHandler(e2)
end
s.MaximumSide="Right"
function s.maxCon(e)
	--maximum mode check to do
	return e:GetHandler():GetFlagEffect(id) and e:GetHandler():IsMaximumModeCenter()
end
function s.aclimit(e,re,tp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return rc~=c and re:IsActiveType(TYPE_MONSTER) and rc:IsOnField()
		and rc:IsSummonType(SUMMON_TYPE_SPECIAL) and rc:IsLevelBelow(10)
end
function s.cfilter(c,ec)
	if c:IsLocation(LOCATION_MZONE) then
		return c:IsLevelAbove(5) and c:IsFaceup()
	else
		return c:IsLevelAbove(5) and c:IsPreviousPosition(POS_FACEUP)
	end
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,e:GetHandler()) and e:GetHandler():IsMaximumModeCenter()
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end