--サイバー・ダーク・キメラ
--Cyberdark Chimera
--Scripted by Rundas
--Necessary changes to the Fusion Proc made by pyrQ
local s,id=GetID()
function s.initial_effect(c)
	--Search + Extra Fusion Material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.thcost)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
end
--Search + Extra Fusion Material
function s.dcfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDiscardable() and c:IsAbleToGraveAsCost()
end
function s.thfilter(c)
	return c:IsCode(37630732) and c:IsAbleToHand()
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.dcfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,s.dcfilter,1,1,REASON_COST+REASON_DISCARD)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	--Extra Fusion Material
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_FUSION_MATERIAL)
	e1:SetTargetRange(LOCATION_GRAVE,0)
	e1:SetValue(1)
	e1:SetCountLimit(1,id)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetOperation(Fusion.BanishMaterial)
	Duel.RegisterEffect(e1,tp)
	--Material Restriction
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(0xff,0xff)
	e2:SetTarget(s.fustg)
	e2:SetValue(s.fuslimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function s.fuslimit(e,c)
	if not c then return false end
	return c:IsControler(e:GetHandlerPlayer())
end
function s.fustg(e,c)
	return not (c:IsSetCard(0x93) and (c:IsRace(RACE_DRAGON) or c:IsRace(RACE_MACHINE)))
end