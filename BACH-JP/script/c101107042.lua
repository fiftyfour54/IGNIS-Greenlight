--いろはもみじ
--Iroha Momiji
--Scripted by Eerie Code
local s,id=GetID()
function s.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,nil,1,1,Synchro.NonTuner(nil),1,99)
	c:EnableReviveLimit()
	--change attribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,{id,0})
	e1:SetTarget(s.atttg)
	e1:SetOperation(s.attop)
	c:RegisterEffect(e1)
	--send to gy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,{id,1})
	e2:SetTarget(s.gytg)
	e2:SetOperation(s.gyop)
	c:RegisterEffect(e2)
end
function s.atttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	local rc=Duel.AnnounceAttribute(tp,1,ATTRIBUTE_ALL)
	Duel.SetTargetParam(rc)	
end
function s.attop(e,tp,eg,ep,ev,re,r,rp)
	local rc=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e1:SetValue(s.value(rc))
	c:RegisterEffect(e1)
	e1:SetLabelObject(e1)
end
function s.value(rc)
	return  function(e,c)
				return rc
			end
end
function s.group(seq,tp)
	local g=Group.CreateGroup()
	local function optadd(loc,seq)
		local c=Duel.GetFieldCard(tp,loc,seq)
		if c then g:AddCard(c) end
	end
	if seq+1<=4 then optadd(LOCATION_MZONE,seq+1) end
	if seq-1>=0 then optadd(LOCATION_MZONE,seq-1) end
	if seq<5 then
		optadd(LOCATION_SZONE,seq)
		if seq==1 then optadd(LOCATION_MZONE,5) end
		if seq==3 then optadd(LOCATION_MZONE,6) end
	elseif seq==5 then
		optadd(LOCATION_MZONE,1)
	elseif seq==6 then
		optadd(LOCATION_MZONE,3)
	end
	return g
end
function s.gyfilter(c,tp)
	if c:GetSequence()>=5 then return false end
	return #(s.group(c:GetSequence(),tp))>0
end
function s.gytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and s.gyfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.gyfilter,tp,0,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.gyfilter,tp,0,LOCATION_MZONE,1,1,nil,tp)
end
function s.gyop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local g=s.group(tc:GetSequence(),tp)
		if #g>0 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
			local sg=g:Select(1-tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.SendtoGrave(sg,REASON_RULE)
		end
	end
end
