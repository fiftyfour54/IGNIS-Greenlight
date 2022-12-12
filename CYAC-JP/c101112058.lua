--伍世壊＝カラリウム
--Primal Planet Kalarium
--scripted by Naim
local SET_MANADOME=0x28e --to be removed
local s,id=GetID()
function s.initial_effect(c)
	--Activate and add 1 "Manadome" monster or "Visas Starfrost" to the hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--Increase the ATK of LIGHT monsters you control by 100 per each Tuner
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT))
	e2:SetValue(s.atkvalue)
	c:RegisterEffect(e2)
	--Special Summon 1 destroyed monster
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,id)
	e3:SetCondition(s.spcond)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end
s.listed_names={CARD_VISAS_STARFROST}
s.listed_series={SET_MANADOME}
function s.thfilter(c)
	return ((c:IsMonster() and c:IsSetCard(SET_MANADOME)) or c:IsCode(CARD_VISAS_STARFROST)) and c:IsAbleToHand()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function s.atkvalue(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetMatchingGroupCount(aux.FaceupFilter(Card.IsType,TYPE_TUNER),tp,LOCATION_MZONE|LOCATION_GRAVE,0,nil)*100
end
function s.cfilter(c,tp,e)
	return c:IsPreviousPosition(POS_FACEUP) and c:IsLocation(LOCATION_GRAVE|LOCATION_REMOVED) and c:IsFaceup()
		and (c:IsType(TYPE_TUNER) or (c:GetPreviousTypeOnField()&TYPE_TUNER)>0)
		and c:IsPreviousControler(tp) and c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
		and c:IsCanBeEffectTarget(e)
end
function s.spcond(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp,e)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return eg:IsContains(chkc) and s.cfilter(chkc,tp,e) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and eg:IsExists(s.cfilter,1,nil,tp,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tg=eg:FilterSelect(tp,s.cfilter,1,1,nil,tp,e)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tg,#tg,tp,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end