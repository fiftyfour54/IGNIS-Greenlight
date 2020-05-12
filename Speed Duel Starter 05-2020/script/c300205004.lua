--Twisted Personality
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
s.listed_names={CARD_GAIA_CHAMPION}
s.listed_series={0xbd}
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opt check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,id+1)==0 then
		--counter handler
		local e0=Effect.CreateEffect(c)
		e1:SetLabel(0)
		Duel.RegisterEffect(e0,tp)
		--add counter
		local lp1=Duel.GetLP(c:GetControler())
		local lp2=Duel.GetLP(1-c:GetControler())
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_ADJUST)
		e2:SetRange(LOCATION_SZONE)
		e2:SetLabel(lp1)
		e2:SetLabelObject(e0)
		e2:SetCondition(s.lpcon1)
		e2:SetOperation(s.lpop1)
		c:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_ADJUST)
		e3:SetRange(LOCATION_SZONE)
		e3:SetLabel(lp2)
		e3:SetLabelObject(e0)
		e3:SetCondition(s.lpcon2)
		e3:SetOperation(s.lpop2)
		c:RegisterEffect(e3)
	end
	Duel.RegisterFlagEffect(ep,id+1,0,0,0)
	--
	local g1=e0:GetLabel()>1 and Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)>0
	--fusion
	local g2=e0:GetLabel()>2 and Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)>0

	local opt=0
	if g1 and g2 then
		opt=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
	elseif g1 then
		opt=Duel.SelectOption(tp,aux.Stringid(id,1))
	elseif g2 then
		opt=Duel.SelectOption(tp,aux.Stringid(id,2))+1
	else return end
	if opt==0 then
		e0:SetLabel(e0:GetLabel()-2)
		Debug.Message(e0:GetLabel() .. "counter on the Skill")
		local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
		if #g==0 then return end
		local sg=g:RandomSelect(1-tp,1)
		Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
	else opt==1 then
		e0:SetLabel(e0:GetLabel()-3)
		Debug.Message(e0:GetLabel() .. "counter on the Skill")
		local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
		if #g==0 then return end
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
function s.lpcon1(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandler():GetControler()
	return (Duel.GetLP(p)~=e:GetLabel() and not Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)) or Duel.GetLP(p)>e:GetLabel()
end
function s.lpcon2(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandler():GetControler()
	return (Duel.GetLP(1-p)~=e:GetLabel() and not Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)) or Duel.GetLP(1-p)>e:GetLabel()
end
function s.lpop1(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandler():GetControler()
	e:SetLabel(Duel.GetLP(p))
	if e:GetLabelObject():GetLabel()<3 then
		e:GetLabelObject():SetLabel(e:GetLabelObject():GetLabel()+1)
		Debug.Message(e0:GetLabel() .. "counter on the Skill")
	end 
end
function s.lpop2(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandler():GetControler()
	e:SetLabel(Duel.GetLP(1-p))
	if e:GetLabelObject():GetLabel()<3 then
		e:GetLabelObject():SetLabel(e:GetLabelObject():GetLabel()+1)
		Debug.Message(e0:GetLabel() .. "counter on the Skill")
	end 
end