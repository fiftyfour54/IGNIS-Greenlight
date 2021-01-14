--Special Summon procedure for the "Bearcti" Synchro monsters from DBAG, applied directly to the card.
function Auxiliary.AddBearctiSummonProcedure(c,tune_filter,nt_filter)
	if tune_filter then tune_filter=aux.AND(tune_filter,aux.FilterBoolFunction(Card.IsType,TYPE_TUNER)) else tune_filter=aux.FilterBoolFunction(Card.IsType,TYPE_TUNER) end
	if nt_filter then nt_filter=aux.AND(nt_filter,aux.FilterBoolFunction(Card.IsNotTuner)) else nt_filter=aux.FilterBoolFunction(Card.IsNotTuner) end
	c:EnableReviveLimit()
	--Must be special summoned by its own method
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--Special summon procedure (from extra deck)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(Auxiliary.BearctiSummonCondition(tune_filter,nt_filter))
	e2:SetTarget(Auxiliary.BearctiSummonTarget(tune_filter,nt_filter))
	e2:SetOperation(Auxiliary.BearctiSummonOperation)
	c:RegisterEffect(e2)
end
function Auxiliary.BearctiSummonCostFilter(c)
	return c:IsFaceup() and c:IsHasLevel() and c:IsAbleToGraveAsCost()
end
function Auxiliary.BearctiSummonCostCheck(lv,tune_filter,nt_filter)
	return	function(sg,e,tp,mg)
				if #sg==2 and sg:IsExists(tune_filter,1,nil) and sg:IsExists(nt_filter,1,nil) and Duel.GetLocationCountFromEx(tp,tp,sg,e:GetHandler())>0 then
					local tc1=sg:GetFirst()
					local tc2=sg:GetNext()
					return math.abs(tc1:GetLevel()-tc2:GetLevel())==lv
				else return false end
			end
end
function Auxiliary.BearctiSummonCondition(tune_filter,nt_filter)
	return	function(e,c)
				if c==nil then return true end
				local tp=c:GetControler()
				local lv=e:GetHandler():GetLevel()
				local g=Duel.GetMatchingGroup(Auxiliary.BearctiSummonCostFilter,tp,LOCATION_MZONE,0,nil)
				return aux.SelectUnselectGroup(g,e,tp,2,2,Auxiliary.BearctiSummonCostCheck(lv,tune_filter,nt_filter),0)
			end
end
function Auxiliary.BearctiSummonTarget(tune_filter,nt_filter)
	return	function(e,tp,eg,ep,ev,re,r,rp,c)
				local g=Duel.GetMatchingGroup(Auxiliary.BearctiSummonCostFilter,tp,LOCATION_MZONE,0,nil)
				local sg=aux.SelectUnselectGroup(g,e,tp,2,2,Auxiliary.BearctiSummonCostCheck(lv,tune_filter,nt_filter),1,tp,HINTMSG_TOGRAVE)
				if #sg==2 then
					sg:KeepAlive()
					e:SetLabelObject(sg)
					return true
				end
				return false
			end
end
function Auxiliary.BearctiSummonOperation(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.SendtoGrave(g,REASON_COST)
	g:DeleteGroup()
end
