-- for effects that trigger when a card(s) leave the field, e.g. the Exorsister cards
-- c is the Card, e is the base Effect (no SetCode), and [...] are the optional params for RegisterEffect
-- it returns the effects in case of additional stuff (like adding to AshBlossom/GhostBelle)
function Auxiliary.RegisterOnLeaveGraveEffect(c,e,...)
    e:SetCode(EVENT_SPSUMMON_SUCCESS)
    e:SetCondition(aux.AND(e:GetCondition(),aux.LeaveGraveCondition))
    c:RegisterEffect(e,...)
    local e1=e:Clone()
    e1:SetCode(EVENT_TO_DECK)
    c:RegisterEffect(e1,...)
    local e2=e:Clone()
    e2:SetCode(EVENT_TO_HAND)
    c:RegisterEffect(e2,...)
    local e3=e:Clone()
    e3:SetCode(EVENT_REMOVE)
    c:RegisterEffect(e3,...)
    return e,e1,e2,e3
end
function Auxiliary.LeaveGraveCondition(e,tp,eg,ep,ev,re,r,rp)
    if e:GetType()&EFFECT_TYPE_SINGLE==EFFECT_TYPE_SINGLE then
        return e:GetHandler():IsPreviousLocation(LOCATION_GRAVE)
    end
    return eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_GRAVE)
end