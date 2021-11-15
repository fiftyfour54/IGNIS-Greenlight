--オッドアイズ・ペンデュラムグラフ・ドラゴン
--Odd-Eyes Pendulumgraph Dragon
--Scripted by Larry126
local s,id=GetID()
function s.initial_effect(c)
	Pendulum.AddProcedure(c)
	--revive limit
	c:EnableUnsummonable()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_REVIVE_LIMIT)
	e0:SetCondition(s.rvlimit)
	c:RegisterEffect(e0)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(s.splimit)
	c:RegisterEffect(e1)
	--Add Ritual Spell to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(s.damcon)
	e3:SetOperation(s.damop)
	c:RegisterEffect(e3)
	--Negate spell
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_DISABLE+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCountLimit(1)
	e4:SetCondition(s.condition)
	e4:SetTarget(s.target)
	e4:SetOperation(s.operation)
	c:RegisterEffect(e4)
end
s.listed_names={16494704}
s.listed_series={0x99}
function s.rvlimit(e)
	return not e:GetHandler():IsLocation(LOCATION_HAND)
end
function s.splimit(e,se,sp,st)
	return (st&SUMMON_TYPE_RITUAL)==SUMMON_TYPE_RITUAL or ((st&SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
		and e:GetHandler():IsLocation(LOCATION_HAND))
end
function s.filter(c)
	return c:IsRitualSpell() and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
		and e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_PZONE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) then
			Duel.BreakEffect()
			Duel.SendtoHand(c,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,Group.FromCards(c))
		end
	end
end
function s.damfilter(c,p)
	return c:IsSummonPlayer(p) and c:IsSummonLocation(LOCATION_EXTRA)
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.damfilter,1,nil,1-tp)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Damage(1-tp,300,REASON_EFFECT)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and re:IsActiveType(TYPE_SPELL) and Duel.IsChainDisablable(ev)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x99) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	local c=e:GetHandler()
	local sg=Group.CreateGroup()
	if c:IsSummonType(SUMMON_TYPE_RITUAL) then sg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp) end
	if c:IsRelateToEffect(e) and Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true) and Duel.NegateEffect(ev)
		and #sg>0 and Duel.SelectYesNo(aux.Stringid(id,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=sg:Select(tp,1,1,nil):GetFirst()
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	end
end
