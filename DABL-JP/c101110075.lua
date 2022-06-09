--肆世壊の双牙
--Scareclaw Twinsaw
--scripted by Naim
local s,id=GetID()
local s,id=GetID()
function s.initial_effect(c)
	--Tribute 1 "Scareclaw" monster to destroy 2 targets
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--Prevent the activation of effect of Link monsters
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(s.gycond)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.gytg)
	e2:SetOperation(s.gyop)
	c:RegisterEffect(e2)
end
s.listed_names={CARD_VISAS_STARFROST}
s.listed_series={0x17c}
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function s.spcheck(sg,tp,exg,dg)
	local a=0
	for c in aux.Next(sg) do
		if dg:IsContains(c) then a=a+1 end
		for tc in aux.Next(c:GetEquipGroup()) do
			if dg:IsContains(tc) then a=a+1 end
		end
	end
	return #dg-a>=2
end
function s.cfilter(c)
	return c:IsSetCard(0x17c)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc~=e:GetHandler() end
	local dg=Duel.GetMatchingGroup(Card.IsCanBeEffectTarget,tp,0,LOCATION_ONFIELD,e:GetHandler(),e)
	if chk==0 then
		if e:GetLabel()==1 then
			e:SetLabel(0)
			return Duel.CheckReleaseGroupCost(tp,s.cfilter,1,false,s.spcheck,nil,dg)
		else
			return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,e:GetHandler())
		end
	end
	if e:GetLabel()==1 then
		e:SetLabel(0)
		local sg=Duel.SelectReleaseGroupCost(tp,s.cfilter,1,1,false,s.spcheck,nil,dg)
		Duel.Release(sg,REASON_COST)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,2,2,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,tp,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_REMOVE,g,#g,tp,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	local loc=LOCATION_REMOVED and Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsCode,CARD_VISAS_STARFROST),tp,LOCATION_ONFIELD,0,1,nil)
	Duel.Destroy(sg,REASON_EFFECT,loc)
end
function s.gycond(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsLinkAbove,3),tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function s.gytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 and Duel.GetFlagEffect(1-tp,id)==0 end
end
function s.gyop(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(1-tp,id,RESET_PHASE+PHASE_END,0,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,1)
	e1:SetValue(s.actlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.actlimit(e,re,tp)
	local loc=re:GetActivateLocation()
	return loc==LOCATION_MZONE and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsType(TYPE_LINK)
end