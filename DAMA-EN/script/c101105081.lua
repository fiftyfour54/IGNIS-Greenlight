-- 
-- Baby Mudragon
-- Scripted by Hatter
local s,id=GetID()
function s.initial_effect(c)
	-- Can be treated as non-tuner for a Synchro Summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_NONTUNER)
	c:RegisterEffect(e1)
	-- Change Type or Attribute of a Synchro Monster
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(s.chcon)
	e2:SetTarget(s.chtg)
	e2:SetOperation(s.chop)
	c:RegisterEffect(e2)
end
function s.chcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function s.get_announceable(g)
	local race,att=0,0
	for c in aux.Next(g) do
		race=race|(~c:GetRace())
		att=att|(~c:GetAttribute())
	end
	return race,att
end
function s.chfilter(c,e)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsCanBeEffectTarget(e)
end
function s.chtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(s.chfilter,tp,LOCATION_MZONE,0,nil,e)
	local race,att=s.get_announceable(g)
	if chk==0 then return #g>0 and (race>0 or att>0) end
	local op
	if race>0 and att>0 then
		op=Duel.SelectOption(tp,aux.Stringid(1),aux.Stringid(2))
	elseif race>0 then
		op=Duel.SelectOption(tp,aux.Stringid(1))
	elseif att>0 then
		op=Duel.SelectOption(tp,aux.Stringid(2))+1
	end
	if op==0 then
		local rc=Duel.AnnounceRace(tp,1,race)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local sg=g:FilterSelect(tp,aux.NOT(Card.IsRace),1,1,nil,rc)
		Duel.SetTargetCard(sg)
		e:SetLabel(op,rc)
	elseif op==1 then
		local at=Duel.AnnounceAttribute(tp,1,att)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local sg=g:FilterSelect(tp,aux.NOT(Card.IsAttribute),1,1,nil,at)
		Duel.SetTargetCard(sg)
		e:SetLabel(op,at)
	end
end
function s.chop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	local op,decl=e:GetLabel()
	if op==0 and not tc:IsRace(decl) then
		-- Change monster type
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetValue(decl)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	elseif op==1 and not tc:IsAttribute(decl) then
		-- Change attribute
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(decl)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
