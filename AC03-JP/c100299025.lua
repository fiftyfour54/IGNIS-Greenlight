--異界共鳴－シンクロ・フュージョン
--Harmonic Synchro Fusion
--Scripted by Eerie Code
local s,id=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.counterfilter)
end
function s.counterfilter(c)
	return c:GetSummonLocation()~=LOCATION_EXTRA or c:IsType(TYPE_SYNCHRO|TYPE_FUSION)
end
function s.cfilter1(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_TUNER) and c:IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(s.cfilter2,tp,LOCATION_MZONE,0,1,c,e,tp,c)
end
function s.cfilter2(c,e,tp,tun)
	if not (c:IsFaceup() and not c:IsType(TYPE_TUNER) and c:IsAbleToGraveAsCost()) then return false end
	local g=Group.FromCards(tun,c)
	tun:AssumeProperty(ASSUME_LEVEL,tun:GetOriginalLevel())
	c:AssumeProperty(ASSUME_LEVEL,c:GetOriginalLevel())
	local chk=Duel.GetLocationCountFromEx(tp,tp,g)>=2 
		and Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,g)
		and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,g)
	Duel.AssumeReset()
	return chk
end
function s.filter1(c,e,tp,mg)
	if not (c:IsFacedown() and c:IsType(TYPE_FUSION) and (not c.material_location or (c.material_location & LOCATION_GRAVE)~=0)) then return false end
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:CheckFusionMaterial(mg)
end
function s.filter2(c,e,tp,mg)
	if not (c:IsFacedown() and c:IsType(TYPE_SYNCHRO)) then return false end
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSynchroSummonable(nil,mg)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0
		and Duel.IsExistingMatchingCard(s.cfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tun=Duel.SelectMatchingCard(tp,s.cfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp):GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local nt=Duel.SelectMatchingCard(tp,s.cfilter2,tp,LOCATION_MZONE,0,1,1,tun,e,tp,tun):GetFirst()
	Duel.SendtoGrave(Group.FromCards(tun,nt),REASON_COST)
	e:SetLabelObject(Duel.GetOperatedGroup())
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--Lizard check
	aux.addTempLizardCheck(e:GetHandler(),tp,s.lizfilter)
end
function s.lizfilter(e,c)
	return not c:IsOriginalType(TYPE_SYNCHRO|TYPE_FUSION)
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsType(TYPE_SYNCHRO|TYPE_FUSION) and c:IsLocation(LOCATION_EXTRA)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_EXTRA)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg=e:GetLabelObject()
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) or not (mg and mg:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)==2 and Duel.GetLocationCountFromEx(tp,tp,mg)>=2) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local fc=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,mg):GetFirst()
	if not fc then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,mg):GetFirst()
	if not sc then return end
	local g=Group.FromCards(fc,sc)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
