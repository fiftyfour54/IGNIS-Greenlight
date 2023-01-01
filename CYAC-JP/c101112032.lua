--ウサミミ導師
--Bunny Instruct-ear
--scripted by Naim
local s,id=GetID()
function s.initial_effect(c)
	--Add 1 Bunny Ears Counter to a monster on the field
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.countercond)
	e1:SetTarget(s.countertg)
	e1:SetOperation(s.counterop)
	c:RegisterEffect(e1)
	--Monsters with Bunny Ears counters cannot be destroyed by battle
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(function(e,c) return c:GetCounter(0x1208)>0 end)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--Banish itself and a monster with a Bunny Ears Counter
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetCountLimit(1)
	e3:SetTarget(s.rmtg)
	e3:SetOperation(s.rmop)
	c:RegisterEffect(e3)
end
function s.countercond(e,tp,eg,ep,ev,re,r,rp)
	return re:IsMonsterEffect() and re:GetActivateLocation()==LOCATION_MZONE and not re:GetHandler():IsCode(id)
end
function s.countertg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsRelateToEffect(re) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,tp,LOCATION_HAND)
end
function s.counterop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) then
		rc:AddCounter(0x1208,1)
	end
end
function s.cfilter(c)
	return c:IsAbleToRemove() and c:GetCounter(0x1208)>0
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_ONFIELD) and s.cfilter(chkc) end
	if chk==0 then return c:IsAbleToRemove() and Duel.IsExistingTarget(s.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,s.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c)
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,2,0,0)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not (c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsFaceup()) then return end
	local rg=Group.FromCards(c,tc)
	if #rg>0 then
		aux.RemoveUntil(rg,nil,REASON_EFFECT,PHASE_STANDBY,id,e,tp,aux.DefaultFieldReturnOp)
	end
end