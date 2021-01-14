--c:card
--compc:card to compare
--val: value required
--return if the level of c-comc or comc-c is equal to val 
function Card.DifferLevel(c,compc,val)
	return math.abs((c:GetLevel()-compc:GetLevel()))==val
end