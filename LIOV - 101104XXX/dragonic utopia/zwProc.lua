-- Description: Checks for whether the equip card still has the equip effect once it reaches SZONE
-- This is used to correct the interaction between Phantom of Chaos (or alike) and any monsters that equip themselves to another
function Auxiliary.EquipLimit(tc,te)
	return function(e,c)
		if c~=tc then return false end
		local effs={e:GetHandler():GetCardEffect(101104104+EFFECT_EQUIP_LIMIT)}
		for _,eff in ipairs(effs) do
			if eff==te then return true end
		end
		return false
	end
end
-- Description: Operation of equipping a card to another by its own effect and registering equip limit, used with aux.AddZWEquipLimit
-- c - equip card
-- e - usually linkedeffect
-- tp - trigger player
-- tc - equip target
-- code - used if a flag effect needs to be registered
-- previousPos - boolean, determine whether the equip card will use its Position from the previous location, default to true
function Auxiliary.EquipAndLimitRegister(c,e,tp,tc,code,previousPos)
	if not Duel.Equip(tp,c,tc,previousPos==nil and true or previousPos) then return false end
	--Add Equip limit
	if code then
		tc:RegisterFlagEffect(code,RESET_EVENT+RESETS_STANDARD,0,0)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(Auxiliary.EquipLimit(tc,e:GetLabelObject()))
	c:RegisterEffect(e1)
	return true
end
-- Description: Equip Limit Proc for cards that equip themselves to another card
-- con - condition for when the card can equip to another
-- equipval - filter for the equip target
-- equipop - what happens when the card is equipped to the target
-- (tc is equip target, c is equip card)
-- linkedeffect - usually the effect of Card c that equips, this ensures Phantom of Chaos handling
-- prop - extra effect properties
-- resetflag/resetcount - resets
function Auxiliary.AddZWEquipLimit(c,con,equipval,equipop,linkedeff,prop,resetflag,resetcount)
	local finalprop=EFFECT_FLAG_CANNOT_DISABLE
	if prop~=nil then
		finalprop=finalprop|prop
	end
	local e1=Effect.CreateEffect(c)
	if con then
		e1:SetCondition(con)
	end
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(finalprop,EFFECT_FLAG2_MAJESTIC_MUST_COPY)
	e1:SetCode(101104104)
	e1:SetLabelObject(linkedeff)
	if resetflag and resetcount then
		e1:SetReset(resetflag,resetcount)
	elseif resetflag then
		e1:SetReset(resetflag)
	end
	e1:SetValue(function(tc,c,tp) return equipval(tc,c,tp) end)
	e1:SetOperation(function(c,e,tp,tc) equipop(c,e,tp,tc) end)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(finalprop&~EFFECT_FLAG_CANNOT_DISABLE,EFFECT_FLAG2_MAJESTIC_MUST_COPY)
	e2:SetCode(101104104+EFFECT_EQUIP_LIMIT)
	if resetflag and resetcount then
		e2:SetReset(resetflag,resetcount)
	elseif resetflag then
		e2:SetReset(resetflag)
	end
	c:RegisterEffect(e2)
	linkedeff:SetLabelObject(e2)
end
