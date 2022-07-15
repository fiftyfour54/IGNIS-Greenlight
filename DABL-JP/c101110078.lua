--同契魔術
--Simult Archfiends
--scripted by Naim
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
local ALLTYPES=TYPE_RITUAL+TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(0,id)==0 end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(0,id,RESET_PHASE+PHASE_END,0,1)
	local c=e:GetHandler()
	--Players cannot Special Summon monsters with the same type as they control
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetTargetRange(1,1)
	e1:SetTarget(s.sumlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--Increase ATK of monsters
	local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE,0,nil)
	if #g==0 then return end
	if s.countrepeatedtypes(g)<=1 then
		for tc in g:Iter() do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(500)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end
function s.cfilter(c)
	return c:IsFaceup() and c:GetType()&ALLTYPES>0
end
function s.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,sump,LOCATION_MZONE,0,nil)
	local mtypes=s.gettypesfromgroup(g)
	return c:GetType()&mtypes>0
end
function s.gettypesfromgroup(g)
	local totaltypes=0
	if not g then return totaltypes end
	for tc in g:Iter() do
		local res=tc:GetType()&ALLTYPES
		totaltypes=totaltypes|res
	end
	return totaltypes
end
function s.countrepeatedtypes(g) --WIP
	local ct=0
	if not g or #g<2 then return ct end
	local detectedtypes=0
	for tc in g:Iter() do
		local res=tc:GetType()&ALLTYPES
		detectedtypes=detectedtypes|res
		if res&detectedtypes>0 then
			ct = ct+1
		end
	end
	return ct
	--return ct,detectedtypes --maybe also return the detected types
end
--Print in hexadecimal
--Debug.Message(string.format("%x",variable_name*255))