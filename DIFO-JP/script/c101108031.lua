--リバースポッド
--Flip Jar
--Logical Nonsense

--Substitute ID
local s,id=GetID()
function s.initial_effect(c)
	--Change as many other monsters to face-down defense
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_TOHAND)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,#g,0,0)
end
	--Change as many other monsters to face-down defense
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	if #g==0 then return end
	Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	local g2=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	if #g2<=0 then return end
	Duel.BreakEffect()
	Duel.SendtoHand(g2,nil,REASON_EFFECT)
	g2=Duel.GetOperatedGroup():Match(function(c)return c:IsLocation(LOCATION_HAND)end,nil)
	local ct1=g2:FilterCount(Card.IsControler,nil,tp)
	local ct2=#g2-ct1
	--Each player can set Spells/Traps from hand
	for p=tp,1-tp do
		local set=Duel.GetMatchingGroup(Card.IsSSetable,p,LOCATION_HAND,0,nil)
		local zcount=Duel.GetLocationCount(p,LOCATION_SZONE)
		--For if full S/T zones and field spell is in hand
		if set:FilterCount(Card.IsType,nil,TYPE_FIELD)>0 then zcount=zcount+1 end
		local setg=math.min(zcount,ct1)
		if p==tp then
			setg=math.min(zcount,ct1)
		else
			setg=math.min(zcount,ct2)
		end
		if #set>0 and Duel.SelectYesNo(p,aux.Stringid(id,0)) then
			Duel.ShuffleHand(p)
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SET)
			local sg=set:Select(p,1,setg,nil)
			Duel.SSet(p,sg,p,false)
		end
	end
end