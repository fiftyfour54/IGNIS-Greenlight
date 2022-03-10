CARD_VERNALIZER_FLOWER_CROWN=101109061

--[[
	Effect.CreateVernalizerSPEffect(c,id,desc,uniquecat,uniquetg,uniqueop)

	Creates an ignition Effect object for the "Vernalizer Fairy" effects that
	discard themselves and another card from the hand.
	Includes handling for "Flower Crown of the Vernalizer Fairy" cost replacement.

	Card c: the owner of the Effect
	int id: the card ID used for the HOPT restriction and strings
	int desc: the string ID of the effect description (will also be used for the limitcount code)
	int uniquecat: the category of the unique effect
	function uniquetg: the target function for the effect
	function uniqueop: the unique effect's operation function, excluding the special summoning and lingering restriction,
		the function must return true to proceed to the special summon,
		it can also return an optional passcode (int) which will be excluded from the special summon
--]]
Effect.CreateVernalizerSPEffect=(function()
	local stringbase=101109016 -- use strings from "Hills and Blooms" so they don't need to be stored in every card

	local function verncostfilter(c)
		return (c:IsMonster() or c:IsSetCard(0x27e)) and c:IsDiscardable()
	end

	local function verncost(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		if chk==0 then return c:IsDiscardable() and Duel.IsExistingMatchingCard(verncostfilter,tp,LOCATION_HAND,0,1,c) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local g=Duel.SelectMatchingCard(tp,verncostfilter,tp,LOCATION_HAND,0,1,1,c)
		Duel.SendtoGrave(g+c,REASON_COST+REASON_DISCARD)
	end

	function vernspfilter(c,e,tp,code)
		return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not (code and c:IsCode(code))
	end

	local function vernop(uniqueop,e,tp,eg,ep,ev,re,r,rp)
		local proceed,exemptID=uniqueop(e,tp,eg,ep,ev,re,r,rp)
		if proceed and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(vernspfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,exemptID)
			and Duel.SelectYesNo(tp,aux.Stringid(stringbase,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,vernspfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,exemptID)
			if #sg>0 then
				Duel.BreakEffect()
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
		-- Cannot activate monster effects, except EARTH monsters'
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e1:SetDescription(aux.Stringid(stringbase,2))
		e1:SetTargetRange(1,0)
		e1:SetValue(function(e,re) return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsAttribute(ATTRIBUTE_EARTH) end)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end

	return function(c,id,desc,uniquecat,uniquetg,uniqueop)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,desc))
		e1:SetCategory(uniquecat|CATEGORY_SPECIAL_SUMMON)
		e1:SetType(EFFECT_TYPE_IGNITION)
		e1:SetRange(LOCATION_HAND)
		e1:SetCountLimit(1,{id,desc})
		e1:SetCost(aux.CostWithReplace(verncost,CARD_VERNALIZER_FLOWER_CROWN))
		e1:SetTarget(uniquetg)
		e1:SetOperation(function(...) vernop(uniqueop,...) end)
		return e1
	end
end)()