-- エピュアリィ・プランプ
-- Epurery Plump
-- Scripted by Hatter
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	-- 2 Level 2 monsters
	Xyz.AddProcedure(c,nil,2,2)
	-- Attach 2 Spell/Trap cards
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.gyovcon)
	e1:SetCost(s.gyovcost)
	e1:SetTarget(s.gyovtg)
	e1:SetOperation(s.gyovop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	c:RegisterEffect(e2)
	-- Attack "Purery" Quick-Play Spell
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(3)
	e3:SetCondition(s.qpovcon)
	e3:SetTarget(s.qpovtg)
	e3:SetOperation(s.qpovop)
	c:RegisterEffect(e3)
end
s.listed_names={100429023}
s.listed_series={0x289}
function s.gyovcon(e,tp,eg,ep,ev,re,r,rp)
	return e:IsHasType(EFFECT_TYPE_QUICK_O)==e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,100429023)
end
function s.gyovcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(id)==0 end
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function s.gyovfilter(c,xc,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsCanBeXyzMaterial(xc,tp,REASON_EFFECT)
end
function s.gyovtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and s.gyovfilter(chkc,c,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.gyovfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,c,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectTarget(tp,s.gyovfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,2,nil,c,tp)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,#g,0,0)
end
function s.gyovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) then return end
	local g=Duel.GetTargetCards(e):Filter(s.gyovfilter,nil,c,tp):Remove(Card.IsImmuneToEffect,nil,e)
	if #g>0 then
		Duel.Overlay(c,g)
	end
end
function s.qpovcon(e,tp,eg,ep,ev,re,r,rp)
	if rp~=tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local rc=re:GetHandler()
	return rc:IsSetCard(0x289) and rc:GetType()==TYPE_SPELL+TYPE_QUICKPLAY
		and rc:IsOnField() and rc:IsCanBeXyzMaterial(e:GetHandler(),tc,REASON_EFFECT)
end
function s.qpovtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) end
	Duel.SetPossibleOperationInfo(0,CATEGORY_REMOVE,nil,1,PLAYER_ALL,LOCATION_MZONE)
end
function s.qpovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if c:IsRelateToEffect(e) and rc:IsRelateToEffect(re)
		and not c:IsImmuneToEffect(e) and not rc:IsImmuneToEffect(e)
		and rc:IsCanBeXyzMaterial(c,tp,REASON_EFFECT) then
		Duel.Overlay(c,rc)
		if not c:GetOverlayGroup():IsContains(rc) then return end
		rc:CancelToGrave()
		if Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
			if #g==0 then return end
			Duel.BreakEffect()
			Duel.RemoveUntil(g,nil,REASON_EFFECT,PHASE_END,e,tp,id+100)
		end
	end
end
function Duel.RemoveUntil(card_or_group,pos,reason,phase,e,tp,flag)
	local g=(type(card_or_group)=="Group" and card_or_group or Group.FromCards(card_or_group))
	if Duel.Remove(g,pos,reason|REASON_TEMPORARY)==0 or g:Match(Card.IsLocation,nil,LOCATION_REMOVED)==0 then return 0 end
	local c=e:GetHandler()
	local function retcon(eff) return eff:GetLabelObject():GetFlagEffect(flag)>0 end
	local function retop(eff) Duel.ReturnToField(eff:GetLabelObject()) end
	for tc in g:Iter() do
		tc:RegisterFlagEffect(flag,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(4825390,1)) -- use string from "Ichiroku's Ledger Book" for now
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE|phase)
		e1:SetReset(RESET_PHASE|phase)
		e1:SetLabelObject(tc)
		e1:SetCountLimit(1)
		e1:SetCondition(retcon)
		e1:SetOperation(retop)
		Duel.RegisterEffect(e1,tp)
	end
	return #g
end
