if not aux.MaximumProcedure then
	aux.MaximumProcedure = {}
	Maximum = aux.MaximumProcedure
end
if not Maximum then
	Maximum = aux.MaximumProcedure
end
--Maximum Summon
Maximum.AddProcedure = aux.FunctionWithNamedArgs(
function(c,reg,desc)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	if desc then
		e1:SetDescription(desc)
	else
		e1:SetDescription(1074) --to update, it is the pendulum value
	end
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(Maximum.Condition())
	e1:SetOperation(Maximum.Operation())
	e1:SetValue(SUMMON_TYPE_MAXIMUM)
	c:RegisterEffect(e1)
	
end,"handler","register","desc")
--that function check if you can maximum summon the monster and its other part(s)
function Maximum.Condition()
	return	function(e,c,og)
			
		end
end
--operation that do the maximum summon
function Maximum.Operation()
	return	function(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
			local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		
		
		
		
		
		
		
	end
end

--function that return if the card is in Maximum Mode or not, atm it just return true as we are lacking info on how Maximum mode work
function Auxiliary.IsMaximumMode()
	return true
end