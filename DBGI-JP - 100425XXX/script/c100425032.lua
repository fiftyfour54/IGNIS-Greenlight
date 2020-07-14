--流星輝巧群
--Meteornis Draitron
--Scripted by Eerie Code
local s,id=GetID()
function s.initial_effect(c)
    --activate
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(1171)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
    --to hand
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_ATKCHANGE)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,id)
    e2:SetTarget(s.thtg)
    e2:SetOperation(s.thop)
    c:RegisterEffect(e2)
end
s.listed_series={0x24a}
function s.filter(c,e,tp,m)
    if not c:IsRitualMonster() or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
    local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
    if c.ritual_custom_condition then
        return c:ritual_custom_condition(mg,forcedselection,RITPROC_GREATER)
    end
    if c.mat_filter then
        mg=mg:Filter(c.mat_filter,c,tp)
    end
    if c.ritual_custom_check then
        forcedselection=aux.tableAND(c.ritual_custom_check,forcedselection or aux.TRUE)
    end
    local sg=Group.CreateGroup()
    return s.check(nil,sg,mg,tp,c,c:GetAttack(),forcedselection,e)
end
function s.check(c,sg,mg,tp,sc,atk,forcedselection,e)
    if not c and not forcedselection and #sg==0 then
        return s.fast_check(e:GetHandlerPlayer(),atk,mg,sc)
    end
    if c then
        sg:AddCard(c)
    end
    local res=false
    local stop=false
    Duel.SetSelectedCard(sg)
    local cont=true
    res,cont=sg:CheckWithSumGreater(Card.GetAttack,atk,sc)
    stop=not cont
    res=res and Duel.GetMZoneCount(tp,sg,tp)>0
    if res and forcedselection then
        res,stop=forcedselection(e,tp,sg,sc)
    end
    if not res and not stop then
        res=mg:IsExists(s.check,1,sg,sg,mg,tp,sc,atk,forcedselection,e)
    end
    if c then
        sg:RemoveCard(c)
    end
    return res
end
function s.fast_check(tp,atk,mg,sc)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
        return mg:CheckWithSumGreater(Card.GetAttack,atk,sc)
    else
        return mg:IsExists(s.filterf,1,nil,tp,mg,sc,atk)
    end
end
function s.filterf(c,tp,mg,sc,atk)
    if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
        Duel.SetSelectedCard(c)
        return mg:CheckWithSumGreater(Card.GetAttack,atk,sc)
    else return false end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsRace,nil,RACE_MACHINE)
        return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,e:GetHandler(),e,tp,mg)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function s.select_mats(sc,mg,forcedselection,atk,tp,e)
    local sg=Group.CreateGroup()
    while true do
        local cg=mg:Filter(s.check,sg,sg,mg,tp,sc,lv,forcedselection,e)
        if #cg==0 then break end
        local finish=s.check(nil,sg,sg,tp,sc,lv,forcedselection,e)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
        local tc=cg:SelectUnselect(sg,tp,finish,finish,lv)
        if not tc then break end
        if not sg:IsContains(tc) then
            sg:AddCard(tc)
        else
            sg:RemoveCard(tc)
        end
    end
    return sg
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsRace,nil,RACE_MACHINE)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp,mg)
    if #tg>0 then
        local tc=tg:GetFirst()
        local atk=tc:GetAttack()
        local mat=nil
        mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
        if specificmatfilter then
            mg=mg:Filter(specificmatfilter,nil,tc,mg,tp)
        end
        if tc.ritual_custom_operation then
            tc:ritual_custom_operation(mg,forcedselection,RITPROC_GREATER)
            mat=tc:GetMaterial()
        else
            if tc.ritual_custom_check then
                forcedselection=aux.tableAND(tc.ritual_custom_check,forcedselection or aux.TRUE)
            end
            if tc.mat_filter then
                mg=mg:Filter(tc.mat_filter,tc,tp)
            end
            if ft>0 and not forcedselection then
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
                mat=mg:SelectWithSumGreater(tp,Card.GetAttack,atk,tc)
            else
                mat=mg.select_mats(tc,mg,forcedselection,atk,tp,e)
            end
        end
        if not customoperation then
            tc:SetMaterial(mat)
            if extraop then
                extraop(mat:Clone(),e,tp,eg,ep,ev,re,r,rp,tc)
            else
                Duel.ReleaseRitualMaterial(mat)
            end
            Duel.BreakEffect()
            Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
            tc:CompleteProcedure()
        else
            customoperation(mat:Clone(),e,tp,eg,ep,ev,re,r,rp,tc)
        end
    end
end
function s.atkfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x24a) and c:GetAttack()>=1000
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and s.atkfilter(chkc) end
    if chk==0 then return e:GetHandler():IsAbleToHand() and Duel.IsExistingTarget(s.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,s.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:UpdateAttack(-1000,RESET_PHASE+PHASE_END+RESET_OPPO_TURN)==-1000 and c:IsRelateToEffect(e) then
        Duel.SendtoHand(c,nil,REASON_EFFECT)
    end
end
