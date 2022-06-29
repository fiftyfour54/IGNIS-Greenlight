--
--Analyze Phlogiston
--Scripted by YoshiDuels
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.costfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGraveAsCost()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND,0,1,nil) end
end
function s.tdfilter1(c,oppLvl)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_PYRO) and c:IsAbleToDeck() and c:GetLevel()>0
		and Duel.IsExistingMatchingCard(s.tdfilter2,tp,LOCATION_GRAVE,0,1,c,opplvl-c:GetLevel(),c)
end
function s.tdfilter2(c,opplvl,mc)
	local g=Group.CreateGroup()
	g:AddCard(c)
	g:AddCard(mc)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_PYRO) and c:IsAbleToDeck() and c:GetLevel()>0
		and Duel.IsExistingMatchingCard(s.tdfilter3,tp,LOCATION_GRAVE,0,1,c,opplvl-c:GetLevel(),g)
end
function s.tdfilter3(c,lvl)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_PYRO) and c:IsAbleToDeck() and c:IsLevel(lvl)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(aux.FilterMaximumSideFunctionEx(s.oppfilter),tp,0,LOCATION_MZONE,nil,0)
	local oppLvl=g:GetSum(Card.GetLevel)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tdfilter1,tp,LOCATION_GRAVE,0,1,nil,opplvl) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,3,1-tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.oppfilter(c)
	return c:IsFaceup() and c:IsAttackPos() and c:IsLevelBelow(8)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	--Requirement
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_HAND,0,1,1,nil)
	if Duel.SendtoGrave(g,REASON_COST)~=0 then
		--Effect
		local sg=Duel.GetMatchingGroup(aux.FilterMaximumSideFunctionEx(s.oppfilter),tp,0,LOCATION_MZONE,nil,0)
		local oppLvl=sg:GetSum(Card.GetLevel)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local dg1=Duel.SelectMatchingCard(tp,s.tdfilter1,tp,LOCATION_GRAVE,0,1,1,nil,oppLvl)
		if #dg1==0 then return end
		local tc1=dg1:GetFirst()
		local tc2=Duel.SelectMatchingCard(tp,s.tdfilter2,tp,LOCATION_GRAVE,0,1,1,tc1,oppLvl-tc1:GetLevel(),tc1):GetFirst()
		if tc2==nil then return end
		dg1:AddCard(tc2)
		local tc3=Duel.SelectMatchingCard(tp,s.tdfilter3,tp,LOCATION_GRAVE,0,1,1,dg1,oppLvl-tc1:GetLevel()-tc2:GetLevel()):GetFirst()
		if tc3==nil then return end
		dg1:AddCard(tc3)
		Duel.HintSelection(dg1,true)
		Duel.SendtoDeck(dg1,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.Destroy(sg,REASON_EFFECT)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(id,2))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetCondition(s.atkcon)
		e1:SetTarget(s.atktg)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EVENT_ATTACK_ANNOUNCE)
		e2:SetOperation(s.checkop)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetLabelObject(e1)
		Duel.RegisterEffect(e2,tp)
	end
end
function s.atkcon(e)
	return e:GetLabel()~=0
end
function s.atktg(e,c)
	return c:GetFieldID()~=e:GetLabel()
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local fid=eg:GetFirst():GetFieldID()
	e:GetLabelObject():SetLabel(fid)
end
