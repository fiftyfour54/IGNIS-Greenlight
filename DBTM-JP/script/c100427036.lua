-- 黄金の雫の神碑
-- Mysterune of the Raging Storm
-- Scripted by Hatter
local s,id=GetID()
function s.initial_effect(c)
	-- Activate
	local e1=Effect.CreateMysteruneQPEffect(c,id,0,s.rmtg,s.rmop,0)
	c:RegisterEffect(e1)
end
s.listed_series={0x27b}
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	if chk==0 then return ct>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=ct end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,ct,1-tp,LOCATION_DECK)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local rg=Duel.GetDecktopGroup(1-tp,Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD))
	if #rg>0 then
		Duel.DisableShuffleCheck()
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	end
end