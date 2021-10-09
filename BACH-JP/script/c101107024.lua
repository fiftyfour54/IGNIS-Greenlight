--熟練の栗魔導士
--Skilled Chestnut Magician
--Scripted by Larry126
local s,id=GetID()
function s.initial_effect(c)
    c:EnableCounterPermit(COUNTER_SPELL)
    c:SetCounterLimit(COUNTER_SPELL,3)
	--Place Spell Counter
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e0:SetCode(EVENT_CHAINING)
    e0:SetRange(LOCATION_MZONE)
    e0:SetOperation(aux.chainreg)
    c:RegisterEffect(e0)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e1:SetCode(EVENT_CHAIN_SOLVED)
    e1:SetRange(LOCATION_MZONE)
    e1:SetOperation(s.acop)
    c:RegisterEffect(e1)
    --Change Level or add to hand
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_LVCHANGE+CATEGORY_SEARCH+CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,id)
    e2:SetCost(s.cost)
    e2:SetTarget(s.target)
    e2:SetOperation(s.operation)
    c:RegisterEffect(e2)
end
s.counter_place_list={COUNTER_SPELL}
s.listed_names={40703222}
s.listed_series={0xa4}
function s.acop(e,tp,eg,ep,ev,re,r,rp)
    if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and e:GetHandler():GetFlagEffect(1)>0 then
        e:GetHandler():AddCounter(COUNTER_SPELL,1)
    end
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,COUNTER_SPELL,1,REASON_COST) end
    e:GetHandler():RemoveCounter(tp,COUNTER_SPELL,1,REASON_COST)
end
function s.thfilter(c)
    return (c:IsCode(40703222) or c:IsSetCard(0xa4)) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local op=nil
    if Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then
        op=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
    else
        op=Duel.SelectOption(tp,aux.Stringid(id,1))
    end
    if op==1 then
        Duel.SetOperationInfo(0,CATEGORY_TOHAND,0,1,tp,LOCATION_DECK+LOCATION_GRAVE)
    end
    Duel.SetTargetParam(op)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local op=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
    if not op then return end
    if op==0 then
        local c=e:GetHandler()
        if c:IsRelateToEffect(e) and c:IsFaceup() then
                local e1=Effect.CreateEffect(c)
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_UPDATE_LEVEL)
                e1:SetValue(1)
                e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
                e1:SetRange(LOCATION_MZONE)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
                c:RegisterEffect(e1)
            local e2=e1:Clone()
            e2:SetCode(EFFECT_UPDATE_ATTACK)
            e2:SetValue(1500)
            c:RegisterEffect(e2)
        end
    elseif op==1 then
        Duel.Hint(HINT_SELECTMSG,tp, HINTMSG_ATOHAND)
            local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
        if #g>0 then
            Duel.SendtoHand(g,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,g)
        end
    end
end
