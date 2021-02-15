function Card.GetScale(c)
    if not c:IsType(TYPE_PENDULUM) then return 0 end
    local sc=0
    if c:IsLocation(LOCATION_PZONE) then
        local seq=c:GetSequence()
        if seq==0 then sc=c:GetLeftScale() else sc=c:GetRightScale() end
    else
        sc=c:GetLeftScale()
    end
    return sc
end
function Card.IsOddScale(c)    
    if not c:IsType(TYPE_PENDULUM) then return false end
    return c:GetScale() % 2 ~= 0
end
function Card.IsEvenScale(c)    
    if not c:IsType(TYPE_PENDULUM) then return false end
    return c:GetScale() % 2 == 0
end