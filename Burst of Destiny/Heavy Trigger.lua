--ヘヴィ・トリガー
--Heavy Trigger
--Scripted by Eerie Code
local s,id=GetID()
function s.initial_effect(c)
	Ritual.AddProcGreater({handler=c,filter=s.ritualfil,lv=8,extrafil=s.extrafil,extraop=s.extraop,stage2=s.stage2})
end
s.listed_names={CARD_BORREL_RIOT}
s.fit_monster={CARD_BORREL_RIOT} --should be removed in hardcode overhaul
s.listed_series={0x102}
function s.ritualfil(c)
	return c:IsCode(CARD_BORREL_RIOT) and c:IsRitualMonster()
end
function s.mfilter(c,e)
	return c:HasLevel() and c:IsSetCard(0x102) and c:IsType(TYPE_MONSTER) and c:IsDestructable(e)
end
function s.extrafil(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_GRAVE,0,nil,e)
end
function s.extraop(mg,e,tp,eg,ep,ev,re,r,rp)
	local rg=mg:Filter(s.mfilter,nil,e)
	local mat2=Group.CreateGroup()
	if #rg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		mat2=rg:FilterSelect(tp,s.mfilter,1,#rg,nil,e)
		mg:Sub(mat2)
	end
	Duel.ReleaseRitualMaterial(mg)
	Duel.Destroy(mat2,REASON_EFFECT)
end
function s.stage2(e,tc,tp,sg,chk)
	if chk==0 then
		--immune
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(id,1))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(s.efilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		--Cannot be destroyed by battle
		local e2=e1:Clone()
		e2:SetDescription(aux.Stringid(id,2))
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e2:SetValue(s.indval)
		tc:RegisterEffect(e2,true)
	end
end
function s.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:IsActivated()
		and te:GetHandler():GetSummonLocation()==LOCATION_EXTRA
end
function s.indval(e,c)
	return c:GetSummonLocation()==LOCATION_EXTRA
end
