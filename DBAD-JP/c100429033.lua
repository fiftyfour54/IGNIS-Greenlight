--御巫の誘い輪舞
--Inviting Rondo of the Mikanko
--scripted by Naim
local s,id=GetID()
function s.initial_effect(c)
	local e0=aux.AddEquipProcedure(c,1)
	e0:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	--Can only control 1 "Inviting Rondo of the Mikanko"
	c:SetUniqueOnField(1,0,id)
	--Gain control of the monster while you control a "Mikanko" monster
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_SET_CONTROL)
	e1:SetValue(function(e) return e:GetHandlerPlayer() end)
	e1:SetCondition(s.contcond)
	c:RegisterEffect(e1)
	--Equipped monster cannot activate its effect while under your control
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_CANNOT_TRIGGER)
	e2:SetCondition(s.actcond)
	c:RegisterEffect(e2)
end
s.listed_series={0x28a}
function s.contcond(e)
	return Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsSetCard,0x28a),e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function s.actcond(e)
	local ec=e:GetHandler():GetEquipTarget()
	return ec:GetControler()==e:GetHandlerPlayer()
end