--メタリオン・ヴリトラスター 
--Metallion Vritrastar
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,CARD_IMAGINARY_ACTOR,160204008)
end