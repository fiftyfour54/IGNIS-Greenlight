--Forbidden Cyber Style Technique
--Scripted by the Razgriz
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
s.listed_series={0x93}
s.listed_name={70095154}
function s.filter(c,e,tp)
	return c:IsSetCard(0x93) and c:IsRace(RACE_MACHINE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	return aux.CanActivateSkill(tp) and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetFlagEffect(ep,id)==0 and Duel.GetLP(tp)<=1500 and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--OPD Register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--Reduce LP to 50 to Special Summon to 3 Machine "Cyber" monsters
	Duel.SetLP(tp,50)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	local sg=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,math.min(ft,3),nil,e,tp)
	for tc in sg:Iter() do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		tc:Recreate(70095154,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true)
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1,fid)
		--Cannot be Tributed
		local e0a=Effect.CreateEffect(c)
		e0a:SetType(EFFECT_TYPE_SINGLE)
		e0a:SetCode(EFFECT_UNRELEASABLE_SUM)
		e0a:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
		e0a:SetRange(LOCATION_MZONE)
		e0a:SetValue(1)
		e0a:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e0a)
		local e0b=e0a:Clone()
		e0b:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		e0b:SetValue(1)
		tc:RegisterEffect(e0b)
	end
	sg:KeepAlive()
	Duel.SpecialSummonComplete()
	--Cannot Summon/Set except by Fusion Summon until End Phase
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.sumlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	Duel.RegisterEffect(e3,tp)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CANNOT_MSET)
	Duel.RegisterEffect(e4,tp)
	--Cannot attack except with Fusion monsters
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_ATTACK)
	e5:SetRange(0x5f)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(function(e,c) return not c:IsType(TYPE_FUSION) end)
	Duel.RegisterEffect(e5,tp)
	--Destroy monsters Summoned by this Skill during End Phase
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e6:SetCountLimit(1)
	e6:SetLabel(fid)
	e6:SetLabelObject(sg)
	e6:SetCondition(s.descon)
	e6:SetOperation(s.desop)
	Duel.RegisterEffect(e6,tp)
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return (sumtype&SUMMON_TYPE_FUSION)~=SUMMON_TYPE_FUSION
end
end
function s.desfilter(c,fid)
	return c:GetFlagEffectLabel(id)==fid
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(s.desfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(s.desfilter,nil,e:GetLabel())
	Duel.Destroy(tg,REASON_EFFECT)
end