--神碑の鬣スレイプニル
--Sleipnir the Runick Mane
--Scripted by Eerie Code
local s,id=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
    Fusion.AddProcMixN(c,true,true,aux.FilterBoolFunctionEx(Card.IsSetCard,SET_RUNICK),2)
    --banish
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,{id,0})
    e1:SetCondition(s.rmcon)
    e1:SetTarget(s.rmtg)
    e1:SetOperation(s.rmop)
    c:RegisterEffect(e1)
    --token
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_TO_HAND)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,{id,1})
    e2:SetCondition(s.tkcon)
    e2:SetTarget(s.tktg)
    e2:SetOperation(s.tkop)
    c:RegisterEffect(e2)
end
s.listed_cards={id+100}
s.listed_series={SET_RUNICK }
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
    local ph=Duel.GetCurrentPhase()
    if Duel.GetTurnPlayer()==tp then
        return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
    else
        return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
    end
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    local f=aux.FilterFaceupFunction(Card.IsAbleToRemove)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and not chkc:IsControler(tp) and f(chkc) end
    if chk==0 then return c:IsAbleToRemove() and Duel.IsExistingTarget(f,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectTarget(tp,f,tp,0,LOCATION_MZONE,1,1,nil)
    g:Add(c)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if not (c:IsRelateToEffect() and tc:IsRelateToEffect()) then return end
    local g=Group.FromCards(c,tc)
    Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_PHASE+PHASE_END)
    e2:SetReset(RESET_PHASE+PHASE_END)
    e2:SetLabelObject(g)
    e2:SetCountLimit(1)
    e2:SetOperation(s.retop)
    Duel.RegisterEffect(e2,tp)
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
    Duel.ReturnToField(e:GetLabelObject())
end
function s.cfilter(c,tp)
    return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function s.tkcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(s.cfilter,1,nil,1-tp)
end
function s.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanSpecialSummonMonster(tp,id+100,SET_RUNICK,TYPES_TOKEN,1500,1500,4,RACE_FAIRY,ATTRIBUTE_LIGHT,POS_FACEUP_ATTACK) end
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.tkop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
    if not Duel.IsPlayerCanSpecialSummonMonster(tp,id+100,SET_RUNICK,TYPES_TOKEN,1500,1500,4,RACE_FAIRY,ATTRIBUTE_LIGHT,POS_FACEUP_ATTACK) then return end
    local token=Duel.CreateToken(tp,id+100)
    Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_ATTACK)
end
