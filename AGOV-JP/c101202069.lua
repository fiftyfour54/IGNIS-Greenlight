--覇王天龍の魂
--Soul of the Supreme Celestial King
--Scripted by Eerie Code
local s,id=GetID()
function s.initial_effect(c)
	--activate
	local params={fusfilter=aux.FilterBoolFunction(Card.IsCode,CARD_ZARC),matfilter=Card.IsAbleToRemove,extrafil=s.fextra,extraop=Fusion.BanishMaterial,extratg=s.extratarget,stage2=s.stage2}
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(Fusion.SummonEffTG(params))
	e1:SetOperation(Fusion.SummonEffOP(params))
	c:RegisterEffect(e1)
end
s.listed_names={CARD_ZARC }
s.listed_series={SET_PENDULUM_DRAGON,SET_FUSION_DRAGON,SET_SYNCHRO_DRAGON,SET_XYZ_DRAGON }
function s.fextra(e,tp,mg)
	local loc=LOCATION_DECK|LOCATION_EXTRA 
	if not Duel.IsPlayerAffectedByEffect(tp,69832741) then
		loc=loc | LOCATION_GRAVE 
	end
	return Duel.GetMatchingGroup(Fusion.IsMonsterFilter(Card.IsAbleToRemove),tp,loc,0,nil)
end
function s.cfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsRace(RACE_SPELLCASTER) and c:GetBaseAttack()==2500
end
function s.extratarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,s.cfilter,1,false,nil,nil) end
	local g=Duel.SelectReleaseGroupCost(tp,s.cfilter,1,1,false,nil,nil)
	Duel.Release(g,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,LOCATION_HAND|LOCATION_ONFIELD|LOCATION_GRAVE|LOCATION_DECK|LOCATION_EXTRA)
end
function s.chkfilter(set)
	return  function(c)
				return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(set)
			end
end
function s.stage2(e,tc,tp,sg,chk)
	if chk==0 then
		local check=true
		local sets={SET_PENDULUM_DRAGON,SET_FUSION_DRAGON,SET_SYNCHRO_DRAGON,SET_XYZ_DRAGON }
		for _,set in ipairs(sets) do
			if not Duel.IsExistingMatchingCard(s.chkfilter(set),tp,LOCATION_REMOVED,0,1,nil) then check=false end
		end
		if not check then tc:NegateEffects(e:GetHandler()) end
	end
end
