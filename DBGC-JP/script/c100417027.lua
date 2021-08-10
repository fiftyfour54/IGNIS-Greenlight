-- 遺跡の魔鉱戦士
-- Magicite Warrior of the Ancient Ruins
-- Scripted by Hatter
local s,id=GetID()
function s.initial_effect(c)
	-- Cannot attack unless you control a "Brave Token"
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetCondition(aux.NOT(s.bravecon))
	c:RegisterEffect(e1)
	-- Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.bravecon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	-- Set Trap that lists "Brave Token" from the Deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e3:SetCountLimit(1,id+100)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.setcon)
	e3:SetTarget(s.settg)
	e3:SetOperation(s.setop)
	c:RegisterEffect(e3)
end
s.listed_names={TOKEN_BRAVE}
function s.bravecon(e)
	return Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsCode,TOKEN_BRAVE),e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.btfilter(c)
	return aux.IsCodeListed(c,TOKEN_BRAVE) and c:GetBattledGroupCount()>0
end
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.btfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.setfilter(c)
	return c:IsType(TYPE_TRAP) and aux.IsCodeListed(c,TOKEN_BRAVE) and c:IsSSetable()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if not tc then return end
	Duel.SSet(tp,tc)
	if tc.act_turn then
		-- Allow activation in the same turn it's set
		local e0=Effect.CreateEffect(tc)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e0)
	end
end