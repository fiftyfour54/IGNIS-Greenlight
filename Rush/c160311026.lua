--jp name
--Vacua Annihilation
local s,id=GetID()
function s.initial_effect(c)
	--Destroy Attack position monsters
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.glxfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_GALAXY) and c:IsType(TYPE_NORMAL) and c:IsLevelAbove(7)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp) and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsPosition,tp,0,LOCATION_MZONE,nil,POS_FACEUP_ATTACK)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,LOCATION_MZONE)
end
function s.glxnfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_GALAXY) and c:IsType(TYPE_NORMAL)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	--Effect
	local g=Duel.GetMatchingGroup(s.glxnfilter,tp,LOCATION_MZONE,0,nil)
	local dg=Duel.GetMatchingGroupCountRush(Card.IsPosition,tp,0,LOCATION_MZONE,nil,POS_FACEUP_ATTACK)
	if #dg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		sg=g:Select(tp,1,#g,nil)
		sg=sg:AddMaximumCheck()
		if #sg>0 then
			Duel.Destroy(sg,REASON_EFFECT)
		end
	end
end
