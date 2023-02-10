--ホイール・シンクロン
--Wheel Synchron
--scripted by Naim
local s,id=GetID()
function s.initial_effect(c)
	--Can be treated as a non-Tuner for a Synchro Summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_NONTUNER)
	c:RegisterEffect(e1)
	--Normal Summon 1 Level 4 or lower monster
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.nstg)
	e2:SetOperation(s.nsop)
	c:RegisterEffect(e2)
	--Decrease the level of a Synchro monster by up to 4
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_LVCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,{id,1})
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(s.lvltg)
	e3:SetOperation(s.lvlop)
	c:RegisterEffect(e3)
end
function s.nsfilter(c,tp)
	return c:IsLevelBelow(4) and c:IsSummonable(true,nil)
		and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or c:IsLocation(LOCATION_MZONE))
end
function s.nstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.nsfilter,tp,LOCATION_HAND|LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,LOCATION_HAND|LOCATION_MZONE)
end
function s.nsop(e,tp,eg,ep,ev,re,r,rp)
	--Cannot summon from the Extra Deck, except Synchro monsters
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--Clock Lizard check
	aux.addTempLizardCheck(e:GetHandler(),tp,s.lizfilter)
	--Normal Summon 1 Level 4 or lower monster
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,s.nsfilter,tp,LOCATION_HAND|LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end
function s.splimit(e,c)
	return not (c:IsType(TYPE_SYNCHRO)) and c:IsLocation(LOCATION_EXTRA)
end
function s.lizfilter(e,c)
	return not (c:IsOriginalType(TYPE_SYNCHRO))
end
function s.synchfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsLevelAbove(1)
end
function s.lvltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.synchfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.synchfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_APPLYTO)
	Duel.SelectTarget(tp,s.synchfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.lvlop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not (tc:IsFaceup() and tc:IsRelateToEffect(e)) then return end
	local lvl=tc:GetLevel()
	if lvl==1 then return end
	local value=Duel.AnnounceNumberRange(tp,1,math.min(4,lvl-1))
	--Decrease level
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(-value)
	tc:RegisterEffect(e1)
end