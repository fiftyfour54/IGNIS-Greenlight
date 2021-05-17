--革命の御旗
--Revered Banner of the Revolution
--Scripted by Eerie Code
local s,id=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,id+100)
	e3:SetCondition(s.descon)
	e3:SetTarget(s.destg)
	e3:SetOperation(s.desop)
	c:RegisterEffect(e3)
	--destruction replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,id+200)
	e4:SetTarget(s.reptg)
	e4:SetValue(s.repval)
	e4:SetOperation(s.repop)
	c:RegisterEffect(e4)
end
s.listed_names={72022087}
function s.thcfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT)
		and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousControler(tp)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.thcfilter,1,nil,tp)
end
function s.thfilter(c)
	return c:IsCode(72022087) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	if not bc then return false end
	if tc:IsControler(1-tp) then tc,bc=bc,tc end
	if tc:IsType(TYPE_SYNCHRO) or bc:IsType(TYPE_SYNCHRO) then
		e:SetLabelObject(bc)
		return true
	else return false end
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local bc=e:GetLabelObject()
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,bc,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetLabelObject()
	if bc:IsRelateToBattle() then
		Duel.Destroy(bc,REASON_EFFECT)
	end
end
function s.desfilter(c,e,tp)
	return c:IsFaceup() and c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function s.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsReason(REASON_EFFECT)
			and not c:IsReason(REASON_REPLACE) and c:IsSetCard(0x14e) and c:IsType(TYPE_FUSION)
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsContains(e:GetHandler())
		and Duel.IsExistingMatchingCard(s.desfilter,tp,LOCATION_MZONE,0,1,eg,e,tp) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,s.desfilter,tp,LOCATION_MZONE,0,1,1,eg,e,tp)
		Duel.SetTargetCard(g)
		g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	else return false end
end
function s.repval(e,c)
	return c==e:GetHandler()
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(g,REASON_EFFECT+REASON_REPLACE)
end
