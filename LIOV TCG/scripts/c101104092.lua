--War Rock Big Blow
--Scripted by fiftyfour

local s,id=GetID()
function s.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCountLimit(1,id)
    e1:SetCode(EVENT_LEAVE_FIELD)
    e1:SetCondition(s.condition)
    e1:SetOperation(s.desop)
    e1:SetTarget(s.target)
    c:RegisterEffect(e1)
end


function s.cfilter(c,tp)
    return c:IsSetCard(0x161) and c:GetReasonPlayer()==1-tp and 
    c:IsReason(REASON_EFFECT) and c:IsPreviousControler(tp) and 
    c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase() and eg:IsExists(s.cfilter, 1, nil, tp)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,1-tp,0)
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,2,nil)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end