-- Effect.CreateMysteruneQPEffect(c,id,[uniquecat,uniquetg,uniqueop,rmcount,uniqueprop,uniquecode])
-- Creates an activation Effect object for the "Mysterune" Quick-Play Spells.
-- Card c: the owner of the Effect
-- int id: the card ID used for the HOPT restriction and strings
-- int uniquecat: the category of the unique effect
-- function uniquetg: the unique effect's target function, excluding the banishment handling
-- function uniqueop: the unique effect's operation function, excluding the banishment handling,
--		the function must return true to proceed to the banishment part
-- int|function rmcount: the amount of cards to be banished from the opponent's deck if op is chosen,
-- 		can be a function with the signature (e,tp,eg,ep,ev,re,r,rp)
-- int uniqueprop: additional Effect properties if the unique effect is chosen
-- int uniquecode: a separate timing where the unique effect can be activated (instead of FREE_CHAIN)
--		if provided, the function will return the two Effect objects separately (unique effect first)

Effect.CreateMysteruneQPEffect = (function()
	local function skipop(e,tp,eg,ep,ev,re,r,rp)
		-- Skip next Battle Phase
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SKIP_BP)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		if Duel.IsTurnPlayer(tp) then
			e1:SetLabel(Duel.GetTurnCount())
			e1:SetCondition(function(e) return Duel.GetTurnCount()~=e:GetLabel() end)
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		else
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
		end
		Duel.RegisterEffect(e1,tp)
	end

	local function spfilter(c,e,tp)
		return c:IsSetCard(0x27b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and Duel.GetLocationCountFromEx(tp,tp,nil,c,0x60)>0
	end

	local function sptg(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	end

	local function spop(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,0x60)
		end
		skipop(e,tp,eg,ep,ev,re,r,rp)
	end

	local function rmtg(e,tp,eg,ep,ev,re,r,rp,chk,uniquetg,rmcount)
		local ct=type(rmcount)=="number" and rmcount or rmcount(e,tp,eg,ep,ev,re,r,rp)
		if chk==0 then return (not uniquetg or uniquetg(e,tp,eg,ep,ev,re,r,rp,0)) and ct>0
			and Duel.IsPlayerCanRemove(tp) and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=ct end
		if uniquetg then uniquetg(e,tp,eg,ep,ev,re,r,rp,1) end
		if ct>0 then Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,ct,1-tp,LOCATION_DECK) end
	end

	local function rmop(e,tp,eg,ep,ev,re,r,rp,uniqueop,rmcount)
		if not uniqueop or uniqueop(e,tp,eg,ep,ev,re,r,rp) and Duel.IsPlayerCanRemove(tp) then
			local ct=type(rmcount)=="number" and rmcount or rmcount(e,tp,eg,ep,ev,re,r,rp)
			local rg=Duel.GetDecktopGroup(1-tp,ct)
			if #rg>0 then
				Duel.DisableShuffleCheck()
				if uniqueop then Duel.BreakEffect() end -- don't break effect if we're only banishing
				Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
			end
		end
		skipop(e,tp,eg,ep,ev,re,r,rp)
	end

	local function choicetg(id,uniquecat,uniquetg,uniqueop,rmcount,uniqueprop)
		return function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
			if chkc then return uniquetg and uniquetg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) end
			local b1=rmtg(e,tp,eg,ep,ev,re,r,rp,0,uniquetg,rmcount)
			local b2=sptg(e,tp,eg,ep,ev,re,r,rp,0)
			if chk==0 then return b1 or b2 end
			local sel=aux.SelectEffect(tp,
				{b1,aux.Stringid(id,0)},
				{b2,aux.Stringid(id,1)})
			if sel==1 then
				if uniqueprop then e:SetProperty(uniqueprop) end
				e:SetCategory(uniquecat|CATEGORY_REMOVE)
				rmtg(e,tp,eg,ep,ev,re,r,rp,1,uniquetg,rmcount)
				e:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
					rmop(e,tp,eg,ep,ev,re,r,rp,uniqueop,rmcount)
				end)
			elseif sel==2 then
				e:SetCategory(CATEGORY_SPECIAL_SUMMON)
				sptg(e,tp,eg,ep,ev,re,r,rp,1)
				e:SetOperation(spop)
			else
				e:SetCategory(0)
				e:SetOperation(nil)
			end
		end
	end

	return function(c,id,uniquecat,uniquetg,uniqueop,rmcount,uniqueprop,uniquecode)
		uniquecat=uniquecat or 0
		rmcount=rmcount or 0
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_ACTIVATE)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
		e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
		if uniquecode then
			-- have the unique effect as separate
			local e0=Effect.CreateEffect(c)
			e0:SetDescription(aux.Stringid(id,0))
			e0:SetCategory(uniquecat|CATEGORY_REMOVE)
			e0:SetType(EFFECT_TYPE_ACTIVATE)
			e0:SetCode(EVENT_TO_HAND)
			e0:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
			if uniqueprop then
				e0:SetProperty(uniqueprop)
			end
			e0:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
				if chkc then return uniquetg and uniquetg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) end
				if chk==0 then return rmtg(e,tp,eg,ep,ev,re,r,rp,0,uniquetg,rmcount) end
				rmtg(e,tp,eg,ep,ev,re,r,rp,1,uniquetg,rmcount)
			end)
			e0:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
				rmop(e,tp,eg,ep,ev,re,r,rp,uniqueop,rmcount)
			end)
			-- complete the Special Summon effect
			e1:SetDescription(aux.Stringid(id,1))
			e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
			e1:SetTarget(sptg)
			e1:SetOperation(spop)
			return e0,e1
		else
			e1:SetTarget(choicetg(id,uniquecat,uniquetg,uniqueop,rmcount,uniqueprop))
			return e1
		end
	end
end)()