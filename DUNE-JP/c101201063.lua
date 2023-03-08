--超越進化薬β
--Transcendent Evolution Pill β
--scripted by Naim
local s,id=GetID()
function s.initial_effect(c)
	--Special Summon 1 level 5 or higher Dinosaur monster from the Deck or Extra Deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.spcheck(sg,tp,exg,e)
	return sg:IsExists(Card.IsRace,1,nil,RACE_DINOSAUR)
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK|LOCATION_EXTRA,0,1,nil,e,tp,sg)
end
function s.spfilter(c,e,tp,sg)
	local atk=sg:GetSum(Card.GetAttack)
	if not (c:IsAttackAbove(atk) and c:IsRace(RACE_DINOSAUR) and c:IsLevelAbove(5) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)) then return end
	if c:IsLocation(LOCATION_DECK) then
		return Duel.GetMZoneCount(tp,sg)>0
	else
		return Duel.GetLocationCountFromEx(tp,tp,sg)>0
	end
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,nil,2,2,true,s.spcheck,nil,e) end
	local sg=Duel.SelectReleaseGroupCost(tp,nil,2,2,true,s.spcheck,nil,e)
	e:SetLabel(sg:GetSum(Card.GetAttack))
	Duel.Release(sg,REASON_COST)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK|LOCATION_EXTRA)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	--Cannot Special Summon from the Extra Deck, except Dragon, Dinosaur, Sea Serpent, and Wyrm monsters
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--Clock Lizard check
	aux.addTempLizardCheck(e:GetHandler(),tp,s.lizfilter)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter2,tp,LOCATION_DECK|LOCATION_EXTRA,0,1,1,nil,e,tp,e:GetLabel())
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
	end
end
function s.spfilter2(c,e,tp,atk)
	return c:IsRace(RACE_DINOSAUR) and c:IsLevelAbove(5)
		and c:IsAttackAbove(atk) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
		and ((c:IsLocation(LOCATION_DECK) and Duel.GetLocationCount(tp,LOCATION_MZONE)) or Duel.GetLocationCountFromEx(tp,tp)>0)
end
function s.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsRace(RACE_DINOSAUR|RACE_DRAGON|RACE_SEASERPENT|RACE_WYRM) 
end
function s.lizfilter(e,c)
	return not c:IsRace(RACE_DINOSAUR|RACE_DRAGON|RACE_SEASERPENT|RACE_WYRM)
end