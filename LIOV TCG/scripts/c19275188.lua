--War Rock Generations
--Scripted by fiftyfour


local s,id=GetID()
function s.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCondition(s.condition)
    e1:SetOperation(s.ssop)
    e1:SetTarget(s.target)
    e1:SetCountLimit(1,id)
    c:RegisterEffect(e1)
end


function s.cfilter(c,e,tp)
    return c:IsSetCard(0x161) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsBattlePhase() and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end

function s.atklimit(e,c)
	return c:GetRealFieldID()==e:GetLabel()
end

function s.ssop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    local c=e:GetHandler()
    if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) then
        if Duel.GetTurnPlayer()~=tp then
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_FIELD)
            e1:SetCode(EFFECT_ONLY_ATTACK_MONSTER)
            e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e1:SetRange(LOCATION_MZONE)
            e1:SetTargetRange(0,LOCATION_MZONE)
            e1:SetValue(s.atklimit)
            e1:SetLabel(tc:GetRealFieldID())
            e1:SetReset(RESET_PHASE+PHASE_END)
            tc:RegisterEffect(e1)
        end
        Duel.SpecialSummonComplete()
    end
end

