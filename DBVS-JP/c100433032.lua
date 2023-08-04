--悪魔の聲
--Demone Valmonica
--Scripted by Eerie Code
local s,id=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(COUNTER_RESONANCE,LOCATION_PZONE)
	Pendulum.AddProcedure(c)
	--add counter
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(s.ctcon)
	e1:SetOperation(s.ctop)
	c:RegisterEffect(e1)
	--atk down
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(s.atkval)
	c:RegisterEffect(e2)
	--place in pzone
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,{id,0})
	e3:SetCost(s.pzcost)
	e3:SetTarget(s.pztg)
	e3:SetOperation(s.pzop)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,{id,1})
	e4:SetCondition(s.cpcon)
	e4:SetCost(s.cpcost)
	e4:SetTarget(s.cptg)
	e4:SetOperation(s.cpop)
	c:RegisterEffect(e4)
	aux.GlobalCheck(s,function()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetLabel(id)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetOperation(aux.sumreg)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge2:SetLabel(id)
		Duel.RegisterEffect(ge2,0)
	end)
end
s.listed_names={CARD_VALMONICA_ANGELO }
s.listed_series={SET_VALMONICA }
s.counter_list={COUNTER_RESONANCE }
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and r&REASON_EFFECT ~= 0 and Duel.IsExistingMatchingCard(Card.IsOriginalRace,tp,LOCATION_PZONE,0,1,nil,RACE_FAIRY)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(COUNTER_RESONANCE,1)
end
function s.atkval(e,c)
	return Duel.GetCounter(e:GetHandlerPlayer(),LOCATION_ONFIELD,0,COUNTER_RESONANCE)*-100
end
function s.pzcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
end
function s.pzfilter(c)
	return c:IsCode(CARD_VALMONICA_ANGELO) and not c:IsForbidden()
end
function s.pztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) and Duel.CheckLocation(tp,LOCATION_PZONE,1)
		and Duel.IsExistingMatchingCard(s.pzfilter,tp,LOCATION_DECK,0,1,nil) and not c:IsForbidden() end
end
function s.pzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (Duel.CheckPendulumZones(tp) and c:IsRelateToEffect(e)) then return end
	local tc=Duel.GetFirstMatchingCard(s.pzfilter,tp,LOCATION_DECK,0,nil)
	if not tc then return end
	Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
end
function s.cpcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(id)>0
end
function s.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function s.cpfilter(c,tp)
	if not (c:IsSetCard(SET_VALMONICA) and (c:IsNormalSpell() or c:IsNormalTrap()) and c:IsAbleToRemoveAsCost()) then return false end
	local eff={c:GetCardEffect(EFFECT_REG_VALMONICA_DMG)}
	for _,teh in ipairs(eff) do
		local te=teh:GetLabelObject()
		local con=te:GetCondition()
		local tg=te:GetTarget()
		if (not con or con(te,tp,Group.CreateGroup(),PLAYER_NONE,0,teh,REASON_EFFECT,PLAYER_NONE,0)) 
			and (not tg or tg(te,tp,Group.CreateGroup(),PLAYER_NONE,0,teh,REASON_EFFECT,PLAYER_NONE,0)) then return true end
	end
	return false
end
function s.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(s.cpfilter,tp,LOCATION_GRAVE,0,1,nil,tp)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,s.cpfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	Duel.SendtoGrave(tc,REASON_COST)
	local eff={tc:GetCardEffect(EFFECT_REG_VALMONICA_DMG)}
	local te=nil
	local acd={}
	local ac={}
	for _,teh in ipairs(eff) do
		local temp=teh:GetLabelObject()
		local con=temp:GetCondition()
		local tg=temp:GetTarget()
		if (not con or con(temp,tp,Group.CreateGroup(),PLAYER_NONE,0,teh,REASON_EFFECT,PLAYER_NONE,0)) 
			and (not tg or tg(temp,tp,Group.CreateGroup(),PLAYER_NONE,0,teh,REASON_EFFECT,PLAYER_NONE,0)) then
			table.insert(ac,teh)
			table.insert(acd,temp:GetDescription())
		end
	end
	if #ac==1 then te=ac[1] elseif #ac>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
		op=Duel.SelectOption(tp,table.unpack(acd))
		op=op+1
		te=ac[op]
	end
	if not te then return end
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function s.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
