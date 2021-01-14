--Special Summon procedure for the "Bearcti" Synchro monsters from DBAG, applied directly to the card.
function Auxiliary.AddBearctiSummonProcedure(c)
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
	e2:SetCondition(Auxiliary.BearctiSummonCondition)
	e2:SetTarget(Auxiliary.BearctiSummonTarget)
	e2:SetOperation(Auxiliary.BearctiSummonOperation)
	c:RegisterEffect(e2)
end
function Auxiliary.BearctiSummonCostFilter(c)
	return c:IsFaceup() and c:IsHasLevel() and c:IsAbleToGraveAsCost()
end
function Auxiliary.BearctiSummonCostCheck(lv)
	return	function(sg,e,tp,mg)
				if #sg==2 and sg:IsExists(Card.IsType,1,nil,TYPE_TUNER) and sg:IsExists(Card.IsNotTuner,1,nil) and Duel.GetLocationCountFromEx(tp,tp,sg,e:GetHandler())>0 then
					local tc1=sg:GetFirst()
					local tc2=sg:GetNext()
					return math.abs(tc1:GetLevel()-tc2:GetLevel())==lv
				else return false end
			end
end
function Auxiliary.BearctiSummonCondition(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local lv=e:GetHandler():GetLevel()
	local g=Duel.GetMatchingGroup(Auxiliary.BearctiSummonCostFilter,tp,LOCATION_MZONE,0,nil)
	return aux.SelectUnselectGroup(g,e,tp,2,2,Auxiliary.BearctiSummonCostCheck(lv),0)
end
function Auxiliary.BearctiSummonTarget(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(Auxiliary.BearctiSummonCostFilter,tp,LOCATION_MZONE,0,nil)
	local sg=aux.SelectUnselectGroup(g,e,tp,2,2,Auxiliary.BearctiSummonCostCheck(lv),1,tp,HINTMSG_TOGRAVE)
	if #sg==2 then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	end
	return false
end
function Auxiliary.BearctiSummonOperation(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.SendtoGrave(g,REASON_COST)
	g:DeleteGroup()
end
