--c:card
--comc:card to compare
--val: value required
--return if the level of c-comc or comc-c is equal to val 
function Card.DifferLevel(c,compc,val)
	return (c:GetLevel()-comc:GetLevel())==val or (comc:GetLevel()-c:GetLevel())==val
end