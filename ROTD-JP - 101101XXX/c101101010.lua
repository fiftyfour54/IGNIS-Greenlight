--教導枢機テトラドラグマ
--Cardinal of Dogma Tetradragmatton
--Scripted by Eerie Code
local s,id=GetID()
local TYPE_FULL=TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK
local TYPE_ARRAY={TYPE_FUSION,TYPE_SYNCHRO,TYPE_XYZ,TYPE_LINK }
function s.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetCondition(s.descon)
	e4:SetTarget(s.destg)
	e4:SetOperation(s.desop)
	c:RegisterEffect(e4)
end
function s.rmfilter(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_FULL) and c:IsAbleToRemove() and c:IsCanBeEffectTarget(e)
end
function s.spcheck(sg,e,tp,mg)
	if #sg<4 then return false end
	for _,ty in ipairs(TYPE_ARRAY) do
		if not sg:IsExists(Card.IsType,1,nil,ty) then return false end
	end
	return true
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.rmfilter,tp,0,LOCATION_GRAVE,nil,e)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and aux.SelectUnselectGroup(g,e,tp,4,4,s.spcheck,0) end
	local tg=aux.SelectUnselectGroup(g,e,tp,4,4,s.spcheck,1,tp,HINTMSG_REMOVE)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tg,4,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetTargetCards(e)
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and #tg>0 then
		Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
	end
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsAttackPos,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAttackPos,tp,0,LOCATION_MZONE,nil)
	if #g>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
		local ct=Duel.GetOperatedGroup():FilterCount(Card.IsType,nil,TYPE_FULL)
		if ct>0 then
			Duel.BreakEffect()
			Duel.Damage(1-tp,ct*800,REASON_EFFECT)
		end
	end
end
