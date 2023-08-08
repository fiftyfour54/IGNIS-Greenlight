--炎王の結襲
--Solidarity Strike of the Fire Kings
--Scripted by Hatter
local s,id=GetID()
function s.initial_effect(c)
	--Special Summon 3 FIRE monsters
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--Prevent opponent from responding to Normal/Special Summon of "Fire King" monsters
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,{id,1})
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(s.chlimop)
	c:RegisterEffect(e2)
end
s.listed_series={SET_FIRE_KING}
function s.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsRace(RACES_BEAST_BWARRIOR_WINGB)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sprescon(sg)
	return sg:GetClassCount(Card.GetLocation)==3 and sg:GetClassCount(Card.GetRace)==3
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK|LOCATION_HAND|LOCATION_GRAVE,0,nil,e,tp)
		return not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>=3 and s.sprescon(g)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,tp,LOCATION_DECK|LOCATION_HAND|LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK|LOCATION_HAND|LOCATION_GRAVE,0,nil,e,tp)
	if not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>=3 then
		local sg=aux.SelectUnselectGroup(g,e,tp,3,3,s.sprescon,1,tp,HINTMSG_SPSUMMON)
		if #sg~=3 then return end
		for tc in aux.Next(sg) do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			--Negate their effects
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT|RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			tc:RegisterEffect(e2)
		end
		--Destroy then during the End Phase
		aux.DelayedOperation(sg,PHASE_END,id,e,tp,function(ag) Duel.Destroy(ag,REASON_EFFECT) end,nil,0)
		Duel.SpecialSummonComplete()
	end
end
function s.chlimop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--Cannot activate cards of effects
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(s.limop)
	e1:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	Duel.RegisterEffect(e2,tp)
end
function s.limop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(aux.FaceupFilter(Card.IsSetCard,SET_FIRE_KING),1,nil) then
		Duel.SetChainLimitTillChainEnd(function(re,rp,tp) return rp==tp end)
	end
end