--Discard and/or send to GY cost for Ice Barrier Monsters, support for Mirror Master of the Ice Barrier 
function Auxiliary.IceBarrierDiscardFilter(c,tp)
	return c:IsHasEffect(EFFECT_ICEBARRIER_REPLACE,tp) and c:IsAbleToRemoveAsCost()
end
function Auxiliary.IceBarrierDiscardGroup(minc)
	return function(sg,e,tp,mg)
		return sg:FilterCount(Auxiliary.IceBarrierDiscardFilter,nil,tp)<=1 and #sg>=minc
	end
end
function Auxiliary.IceBarrierDiscardCost(f,discard,minc,maxc)
	if discard then
		if f then aux.AND(f,Card.IsDiscardable) else f=Card.IsDiscardable end
	else
		if f then aux.AND(f,Card.IsAbleToGraveAsCost) else f=Card.IsAbleToGraveAsCost end
	end
	if not minc then minc=1 end
	if not maxc then maxc=1 end
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(f,tp,LOCATION_HAND,0,minc,nil) or Duel.IsExistingMatchingCard(Auxiliary.IceBarrierDiscardFilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
		local g=Duel.GetMatchingGroup(f,tp,LOCATION_HAND,0,nil)
		g:Merge(Duel.GetMatchingGroup(Auxiliary.IceBarrierDiscardFilter,tp,LOCATION_GRAVE,0,nil,tp))
		local sg=Auxiliary.SelectUnselectGroup(g,e,tp,minc,maxc,Auxiliary.IceBarrierDiscardGroup(minc),1,tp,Auxiliary.Stringid(EFFECT_ICEBARRIER_REPLACE,1))
		local rm=0
		if sg:IsExists(Card.IsHasEffect,1,nil,EFFECT_ICEBARRIER_REPLACE,tp) then
			local te=sg:Filter(Card.IsHasEffect,nil,EFFECT_ICEBARRIER_REPLACE)
			te:GetFirst():GetCardEffect(EFFECT_ICEBARRIER_REPLACE):UseCountLimit(tp)
			rm=Duel.Remove(te,POS_FACEUP,REASON_COST)
			sg:Sub(te)
		end
		if #sg>0 then
			if discard then
				return Duel.SendtoGrave(sg,REASON_COST+REASON_DISCARD) + rm
			else
				return Duel.SendtoGrave(sg,REASON_COST) + rm
			end
		end
	end
end
