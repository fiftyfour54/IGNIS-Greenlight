function aux.SecurityTarget(e,c)
	local tp=e:GetHandlerPlayer()
	local sg,og=(c:GetColumnGroup()+c):Filter(Card.IsLocation,nil,LOCATION_MZONE):Split(Card.IsControler,nil,tp)
	local g1=sg:GetMaxGroup(Card.GetSequence)
	if not g1 then return false end
	local g2=og:GetMaxGroup(Card.GetSequence)
	local c1=g1:GetFirst()
	local c2=g2:GetFirst()
	return c1 and c2==c and c1:IsFaceup() and c1:IsSetCard(0x260)
end