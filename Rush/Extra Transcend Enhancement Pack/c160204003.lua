--メタリオン・エーラクレスター 
--Metallion Eraclestar
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,CARD_IMAGINARY_ACTOR,160204010)
end