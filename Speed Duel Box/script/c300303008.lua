--Spell of Mask (Skill Card)
--Scripted by The Razgriz
local s,id=GetID()
function s.initial_effect(c)
    aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
s.listed_names={48948935,49064413,94377247}
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetFlagEffect(ep,id)>0 then return false end
    --opd check
    return aux.CanActivateSkill(tp) and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
    Duel.Hint(HINT_CARD,tp,id)
    --Tribute to add Curse of MB/MB to hand
    Duel.RegisterFlagEffect(ep,id,0,0,0)
    local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE,0,nil)
    local tc=g:FilterSelect(tp,Card.IsReleasable,1,1,nil):GetFirst()
    if Duel.Release(tc,REASON_COST)>0 then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g1=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp)
        if #g1>0 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
            local g2=Duel.SelectMatchingCard(tp,s.thfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp)
            g1:Merge(g2)
            Duel.SendtoHand(g1,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,g1)
        end
    end    
    --Special Summon MB Des Gardius
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_DESTROYED)
    e1:SetCondition(s.spcon)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    Duel.RegisterEffect(e1,tp)
end
function s.desfilter(c,tp)
    return c:IsCode(49064413) and c:IsSummonType(SUMMON_TYPE_RITUAL) and c:IsReason(REASON_EFFECT)
end
function s.spfilter(c,e,tp)
    return c:IsCode(48948935) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(s.desfilter,1,nil,tp) and rp==1-tp and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) and Duel.GetFlagEffect(ep,id+1)==0
end
function s.sptg(e,tp,ep,eg,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if Duel.SelectYesNo(tp,aux.Stringid(id,0)) and ft>0 then
        Duel.RegisterFlagEffect(ep,id+1,0,0,0)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local tc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
        if tc then
            Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
        end
    end
end
function s.cfilter(c)
    return c:IsCode(48948935) and c:IsFaceup() 
end
function s.thfilter(c,tp)
    return c:IsCode(49064413) and c:IsAbleToHand()
        and Duel.IsExistingMatchingCard(s.thfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
end
function s.thfilter2(c)
    return c:IsCode(94377247) and c:IsAbleToHand()
end
