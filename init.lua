-- Common flag effects
FLAG_TO_ADD_COUNTER=1
FLAG_TEMPORARY_BANISH=2

--[[
	An operation function to be used with `aux.RemoveUntil`.
	Will return the banished cards to the monster zone.
	Makes the player select cards to return if there are less available zones than returnable cards.
--]]
function Auxiliary.DefaultFieldReturnOp(rg,e,tp)
	if #rg==0 then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE,0)
	local tg=rg
	if ft>0 and #tg>1 and #tg>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		tg=rg:Select(tp,ft,ft,nil)
	end
	for tc in tg:Iter() do
		Duel.ReturnToField(tc)
	end
	for tc in rg:Sub(tg):Iter() do
		Duel.ReturnToField(tc)
	end
end

--[[
	Banishes card(s) and applies an operation to them in a given phase (usually return them to their current location).

		Card|Group card_or_group: the cards to banish
		int|nil pos: the cards' position when banished. `nil` will use their current position
		int reason: the reason for banishing
		int phase: the phase when `op` will be applied to the banished cards
		Effect e: the effect performing the banishment
		int tp: the player performing the banishment, and will later perform `op`
		function op: a function with the signature (rg,e,tp,eg,ep,ev,re,r,rp)
			where `rg` is the group of cards that can be returned
		function|nil con: an additional condition function with the signature (rg,e,tp,eg,ep,ev,re,r,rp).
			By default, `rg` is automatically checked if it's not empty.
--]]
function Auxiliary.RemoveUntil(card_or_group,pos,reason,phase,e,tp,op,con)
	local g=(type(card_or_group)=="Group" and card_or_group or Group.FromCards(card_or_group))
	if Duel.Remove(g,pos,reason|REASON_TEMPORARY)==0 or g:Match(Card.IsLocation,nil,LOCATION_REMOVED)==0 then return end
	local fid=e:GetFieldID()
	for tc in g:Iter() do
		tc:RegisterFlagEffect(FLAG_TEMPORARY_BANISH,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
	end
	g:KeepAlive()
	local function get_returnable_group(e)
		return e:GetLabelObject():Filter(function(c)
			return c:GetFlagEffectLabel(FLAG_TEMPORARY_BANISH)==e:GetLabel()
		end,nil)
	end
	--Return
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE|phase)
	e1:SetReset(RESET_PHASE|phase)
	e1:SetLabelObject(g)
	e1:SetLabel(fid)
	e1:SetCountLimit(1)
	e1:SetCondition(function(eff,...)
		local rg=get_returnable_group(eff)
		return #rg>0 and (not con or con(rg,eff,...))
	end)
	e1:SetOperation(function(eff,...)
		if op then op(get_returnable_group(eff),eff,...) end
	end)
	Duel.RegisterEffect(e1,tp)
	return e1
end