--Barian
--Scripted by The Razgriz
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--CXyz, Number C and No. 101-107 cannot be targeted or destroyed
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(s.tg)
	e1:SetValue(aux.indoval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--Attach opponent's monster as material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetCondition(s.ovcon)
	e3:SetTarget(s.ovtg)
	e3:SetOperation(s.ovop)
	c:RegisterEffect(e3)
end
s.listed_series={0x48,0x1073,0x1048}
function s.tg(e,c)
	local no=c.xyz_number
	local tp=e:GetHandlerPlayer()
	return c:IsFaceup() and (c:IsSetCard(0x1048) or c:IsSetCard(0x1073) or (c:IsSetCard(0x48) and no and no>=101 and no<=107)) and c:IsControler(tp)
end
function s.ovcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsType,1,nil,TYPE_XYZ) and re and (re:IsActiveType(TYPE_SPELL) and re:GetHandler():IsSetCard(0x95) and re:GetHandlerPlayer()==e:GetHandlerPlayer())
end
function s.ovfilter(c)
	return c:IsFaceup() and not c:IsType(TYPE_TOKEN)
end
function s.xyzfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_XYZ) and Duel.IsExistingTarget(s.ovfilter,tp,0,LOCATION_MZONE,1,nil) and c:IsControler(tp)
end
function s.ovtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=eg:Filter(s.xyzfilter,nil,tp)
	if chkc then return false end
	if chk==0 then return #g>0 and Duel.IsExistingTarget(s.ovfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	local xyzc=g:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
	local og=Duel.SelectTarget(tp,s.ovfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetTargetCard(og+xyzc)
	e:SetLabelObject(xyzc)
end
function s.ovop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards(e)
	if #g<2 then return end
	local xyzc,tgc=(function()
		local c1=g:GetFirst()
		local c2=g:GetNext()
		if c1==e:GetLabelObject() then return c1,c2 else return c2,c1 end
	end)()
	if xyzc:IsRelateToEffect(e) and xyzc:IsControler(tp) and tgc:IsRelateToEffect(e) and tgc:IsControler(1-tp)
		and not xyzc:IsImmuneToEffect(e) and not tgc:IsImmuneToEffect(e) then
		Duel.Overlay(xyzc,tgc,true)
	end
end