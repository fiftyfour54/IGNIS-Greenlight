--プランキッズ・ミュー
--Prank-Kids Mew
--Scripted by AlphaKretin
local s,id=GetID()
function s.initial_effect(c)
	--Link Summon
	c:EnableReviveLimit()
	Link.AddProcedure(c,s.mfilter,1,1)
	--Replace "Prank-Kids" monsters' Tribute cost (hardcoded by auxiliary function)
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(id)
    e1:SetRange(LOCATION_GRAVE)
    e1:SetTargetRange(1,0)
    c:RegisterEffect(e1)
end
