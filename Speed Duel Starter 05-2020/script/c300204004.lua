--Toon Mayem!
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opt check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp)
end
s.listed_names={15259703}
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	local c=e:GetHandler()
		--immune
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e1:SetTargetRange(LOCATION_SZONE,0)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,15259703))
		e1:SetValue(s.indct)
		Duel.RegisterEffect(e1,tp)
end
function s.indct(e,re,r,rp)
	if (r&REASON_EFFECT)~=0 then
		return 1
	else
		return 0
	end
end