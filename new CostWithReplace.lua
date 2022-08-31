
function Auxiliary.CostWithReplace(base,replacecode,extracon,alwaysexecute)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		if alwaysexecute and not alwaysexecute(e,tp,eg,ep,ev,re,r,rp,0) then return false end
		local cond=base(e,tp,eg,ep,ev,re,r,rp,0)
		if chk==0 then
			if cond then return true end
			for _,eff in ipairs({Duel.GetPlayerEffect(tp,replacecode)}) do
				if eff:CheckCountLimit(tp) then
					local val=eff:GetValue()
					if type(val)=="number" and val==1 then return true end
					if type(val)=="function" and val(eff,e,tp,eg,ep,ev,re,r,rp,chk,extracon) then return true end
				end
			end
			return false
		end
		if alwaysexecute then alwaysexecute(e,tp,eg,ep,ev,re,r,rp,1) end
		local effs=cost_replace_getvalideffs(replacecode,extracon,e,tp,eg,ep,ev,re,r,rp,chk)
		if not cond or (#effs>0 and Duel.SelectYesNo(tp,98)) then
			local eff=effs[1]
			if #effs>1 then
				local effsPerCard={}							--sorting effects into a 2D table of "card:effects of that card"
				local effsHandlersGroup=Group.CreateGroup()	 --a group of all cost replacement effects' handlers
				for _,_eff in ipairs(effs) do
					local _effCard=_eff:GetHandler()
					effsHandlersGroup:AddCard(_effCard)
					if not effsPerCard[_effCard] then effsPerCard[_effCard]={} end
					table.insert(effsPerCard[_effCard],_eff)
				end
				local effCard=effsHandlersGroup:Select(tp,1,1,nil):GetFirst()	   --select the card with the cost replacement effect
				local effsOfThatCard=effsPerCard[effCard]
				eff=effsOfThatCard[1]
				if #effsOfThatCard>1 then					   --if the card has more than applicable cost replacement effect, apply the old description selection
					local desctable={}
					for _,_eff in ipairs(effsOfThatCard) do
						table.insert(desctable,_eff:GetDescription())
					end
					eff=effsOfThatCard[Duel.SelectOption(tp,false,table.unpack(desctable)) + 1]
				end
			end
			local res={eff:GetOperation()(eff,e,tp,eg,ep,ev,re,r,rp,chk)}
			eff:UseCountLimit(tp)
			return table.unpack(res)
		end
		return base(e,tp,eg,ep,ev,re,r,rp,1)
	end
end
