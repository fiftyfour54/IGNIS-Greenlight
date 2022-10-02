--凶導の白き天底
--White Zoa of Dogmatika
--Scripted by Eerie Code
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Cannot be special summoned
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(s.ritlimit)
	c:RegisterEffect(e1)
	--Unaffected by activated effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x146))
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(s.unaval)
	c:RegisterEffect(e2)
	--activate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id)
	e3:SetTarget(s.target)
	c:RegisterEffect(e3)
end
s.listed_names={31002402}
s.listed_series={0x146}
function s.ritlimit(e,se,sp,tp)
	return aux.ritlimit(e,se,sp,tp) and se:GetHandler():IsSetCard(0x146)
end
function s.unaval(e,te)
	local tc=te:GetOwner()
	return te:IsActiveType(TYPE_MONSTER) and te:IsActivated() 
		and te:GetOwnerPlayer()~=e:GetHandlerPlayer() 
		and te:GetHandler():IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK)
end
function s.thfilter(c)
	return c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local exc=Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)
	local b1=exc>=2
	local thg=Duel.GetMatchingGroup(s.thfilter,tp,0,LOCATION_MZONE,nil)
	local b2=#thg>0
	if chk==0 then return b1 or b2 end
	local op=Duel.SelectEffect(1-tp,{b1,aux.Stringid(id,1)},{b2,aux.Stringid(id,2)})
	if op==1 then
		e:SetCategory(CATEGORY_TOGRAVE)
		e:SetOperation(s.gyop)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,exc/2,1-tp,LOCATION_HAND+LOCATION_EXTRA)
	elseif op==2 then
		e:SetCategory(CATEGORY_TOHAND)
		e:SetOperation(s.thop)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,b2,#b2,0,0)
	else
		e:SetCategory(0)
		e:SetOperation(nil)
	end
end
function s.gyop(e,tp,eg,ep,ev,re,r,rp)
	local exc=Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)/2
	if exc>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(1-tp,nil,tp,0,LOCATION_HAND+LOCATION_EXTRA,exc,exc,nil)
		if #g>0 then Duel.SendtoGrave(g,REASON_EFFECT) end
	end
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.thfilter,tp,0,LOCATION_MZONE,nil)
	if #g>0 then Duel.SendtoHand(g,nil,REASON_EFFECT) end
end
