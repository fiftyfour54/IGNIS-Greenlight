--Recklessness and Punishment
--Scripted by Neo Yuno
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<Duel.GetLP(1-tp)
end
function s.desfilter(c,lp)
    return c:IsFaceup() and c:IsAttackBelow(lp)
end
function s.spfilter(c,e,tp,lp)
    return c:IsType(TYPE_MONSTER) and c:IsAttackBelow(lp) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local lp=Duel.GetLP(1-tp)-Duel.GetLP(tp)
	local g1=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_MZONE,nil,lp)
	local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp,lp)
	if chk==0 then return lp>0 and (#g1>0 or (#g2>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0)) end
	if #g1>0 and #g2>0 then
		e:SetLabel(Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1)))
	elseif #g1>0 then
		e:SetLabel(Duel.SelectOption(tp,aux.Stringid(id,0)))
	else
		e:SetLabel(Duel.SelectOption(tp,aux.Stringid(id,1))+1)
	end
	local g=(e:GetLabel()==0 and g1 or g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_GRAVE)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local lp=Duel.GetLP(1-tp)-Duel.GetLP(tp)
    if lp<=0 then return end
	if e:GetLabel()==0 then
        local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_MZONE,nil,lp)
        if #g==0 then return end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        local sg=g:Select(tp,1,1,nil)
        if #sg>0 then
            Duel.HintSelection(sg)
            Duel.Destroy(sg,REASON_EFFECT)
        end
	else 
        if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
        local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp,lp)
        if #g==0 then return end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sg=g:Select(tp,1,1,nil)
        if #sg>0 then
            Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
        end
	end
end