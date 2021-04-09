--デスピアン・クエリティス
--Despian Quaeritis
--scripted by Rundas
local s,id=GetID()
function s.initial_effect(c)
	Fusion.AddProcMix(c,true,true,s.matfilter,aux.FilterBoolFunctionEx(Card.IsSetCard,0x265))
	c:EnableReviveLimit()
	--Change ATK
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.atkcon)
	e1:SetTarget(s.atktg)
	e1:SetOperation(s.atkop)
	c:RegisterEffect(e1)
	--Search or Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(s.con)
	e2:SetTarget(s.tg)
	e2:SetOperation(s.op)
	c:RegisterEffect(e2)
end
s.listed_names={id,CARD_ALBAZ}
s.listed_series={0x265}
function s.matfilter(c,fc,st,tp)
	return c:IsAttribute(ATTRIBUTE_LIGHT,fc,st,tp) or c:IsAttribute(ATTRIBUTE_DARK,fc,st,tp)
end
--Change ATK
function s.atkfilter(c)
	return c:IsFaceup() and c:GetAttack()>0 and not (c:IsType(TYPE_FUSION) and c:IsLevelAbove(8))
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase()
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,#g,PLAYER_ALL,LOCATION_MZONE)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	for tc in ~g do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
--Search or Special Summon
function s.filter(c,e,tp)
	return (c:IsSetCard(0x265) or c:IsCode(CARD_ALBAZ)) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp~=tp and c:IsReason(REASON_EFFECT) and c:IsPreviousPosition(POS_FACEUP) and not c:IsLocation(LOCATION_DECK) and c:IsPreviousControler(tp)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	--Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	--Unsure about Operation Info if the precise category has 2b decided in the operation
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,4))
	local tc=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	local choice,th,ss=-1,tc:IsAbleToHand(),tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if th and ss then choice=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
	elseif th then choice=Duel.SelectOption(tp,aux.Stringid(id,2))
	elseif ss then choice=Duel.SelectOption(tp,aux.Stringid(id,3))+1
	else return end
	if tc and choice~=-1 then
		if choice==0 then
			Duel.SendtoHand(tc,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end