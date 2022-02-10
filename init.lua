-- Effect.CreateMysteruneQPEffect(c,id,categ,uniquetg,uniqueop,rmcount)
-- Creates an activation Effect object for the "Mysterune" Quick-Play Spells
-- c: the owner of the Effect
-- id: the card ID used for the HOPT restriction and strings
-- categ: the category of the unique effect
-- uniquetg: the unique effect's target function, excluding the banishment handling
-- uniqueop: the unique effect's operation function, excluding the banishment handling
-- (uniqueop must return true to proceed to the banishment part)

Effect.CreateMysteruneQPEffect = (function()
	local function spfilter(c,e,tp)
		return c:IsSetCard(0x27b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and Duel.GetLocationCountFromEx(tp,tp,nil,c,0x60)>0
	end

	local function target(id,categ,uniquetg,rmcount)
		return function(e,tp,eg,ep,ev,re,r,rp,chk)
			local b1=uniquetg(e,tp,eg,ep,ev,re,r,rp,0) and Duel.IsPlayerCanRemove(tp)
				and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=rmcount
			local b2=Duel.IsExistingMatchingCard(spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
			if chk==0 then return b1 or b2 end
			local sel=aux.SelectEffect(tp,
				{b1,aux.Stringid(id,0)},
				{b2,aux.Stringid(id,1)})
			e:SetLabel(sel)
			if sel==1 then
				e:SetCategory(categ)
				uniquetg(e,tp,eg,ep,ev,re,r,rp,0)
				Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_DECK)
			elseif sel==2 then
				e:SetCategory(CATEGORY_SPECIAL_SUMMON)
				Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
			else
				e:SetCategory(0)
				e:SetOperation(nil)
			end
		end
	end

	local function operation(uniqueop,rmcount)
		return function(e,tp,eg,ep,ev,re,r,rp)
			local sel=e:GetLabel()
			if sel==1 then
				if uniqueop(e,tp,eg,ep,ev,re,r,rp) and Duel.IsPlayerCanRemove(tp) then
					local rg=Duel.GetDecktopGroup(1-tp,rmcount)
					if #rg<1 then return end
					Duel.DisableShuffleCheck()
					Duel.BreakEffect()
					Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
				end
			elseif sel==2 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(tp,spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
				if #g>0 then
					Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,0x60)
				end
			end
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
	end

	return function(c,id,categ,uniquetg,uniqueop,rmcount)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_ACTIVATE)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
		e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
		e1:SetTarget(target(id,categ,uniquetg,rmcount))
		e1:SetOperation(operation(uniqueop,rmcount))
		return e1
	end
end)()