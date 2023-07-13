-- ＴＧ グレイブ・ブラスター
--T.G. Glaive Blaster
local s,id=GetID()
function s.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsType,TYPE_SYNCHRO),1,1,Synchro.NonTunerEx(Card.IsType,TYPE_SYNCHRO),2,99)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1)

	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e2:SetTarget(s.rmtg)
	e2:SetOperation(s.rmop)
	c:RegisterEffect(e2)
	--If an monster is banished, special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_REMOVE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,{id,1})
	e3:SetCost(s.sscost)
	e3:SetCondition(s.sscon)
	e3:SetTarget(s.sstg)
	e3:SetOperation(s.ssop)
end
s.synchro_tuner_required=1
s.synchro_nt_required=2
s.listed_series={0x27}
function s.mfilter(c)
	return not c:IsType(TYPE_TUNER)
end
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetMaterial()
	local ct=g:FilterCount(s.mfilter,nil)
	return e:GetHandler():GetFlagEffect(id)<ct
end
--banish
function s.rmfilter(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsSummonLocation(LOCATION_EXTRA) and c:IsAbleToRemove()
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.rmfilter(chkc) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(s.rmfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,s.rmfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end

--special summon
	--Check for opponent's sent monster in GY/banished
function s.ssfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:IsMonster() and c:IsFaceup()
		and c:IsCanBeEffectTarget(e) and c:IsLocation(LOCATION_REMOVED)
end
	--Activation legality
function s.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(s.ssfilter,nil,e,tp)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and #g>0 end
	local c=nil
	if #g>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		c=g:Select(tp,1,1,nil):GetFirst()
	else
		c=g:GetFirst()
	end
	Duel.SetTargetCard(c)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,g:GetFirst():GetLocation())
end
	--If an opponent's monster is in GY/banished due to your effect, special summon
function s.ssop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
	end
end