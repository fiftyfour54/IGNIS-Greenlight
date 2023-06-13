--Ｃｏｎｃｏｕｒｓ ｄｅ Ｃｕｉｓｉｎｅ～菓冷なる料理対決～
--Concours de Cuisine (Confectionery Contest)
--scripted by Naim
local s,id=GetID()
function s.initial_effect(c)
	--Special Summon 1 "Nouvelles" Pendulum Monster and 1 "Patissciel" Pendulum Monster from your hand, Deck, and/or Extra Deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--Increase the ATK of a monster by 200 x the number of "Recipe" cards in the GYs
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,{id,1})
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.atktg)
	e2:SetOperation(s.atkop)
	c:RegisterEffect(e2)
end
s.listed_series={SET_NOUVELLES,SET_PATISSCIEL}
local locs=LOCATION_HAND|LOCATION_DECK|LOCATION_EXTRA
function s.cfilter(c,archetyp)
	return c:IsSetCard(archetyp) and c:IsType(TYPE_PENDULUM)
end
function s.spchk(c,e,tp,archtyp2)
	local loc=false
	if not c:IsLocation(LOCATION_EXTRA) then
		loc=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	else 
		loc=Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
	end
	return c:IsSetCard(archtyp2) and loc and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
end
function s.spfilter(c,e,tp,archtyp1,archtyp2)
	local loc=false
	if not c:IsLocation(LOCATION_EXTRA) then
		loc=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	else 
		loc=Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
	end
	return c:IsSetCard(archtyp1) and loc and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(s.spchk,tp,locs,0,1,nil,e,tp,archtyp2)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(s.cfilter,tp,locs,0,nil,SET_NOUVELLES)
	local g2=Duel.GetMatchingGroup(s.cfilter,tp,locs,0,nil,SET_PATISSCIEL)
	local g=g1+g2
	if chk==0 then return #g1>0 and #g2>0
		and (g:IsExists(s.spfilter,1,nil,e,tp,SET_NOUVELLES,SET_PATISSCIEL)
		or g:IsExists(s.spfilter,1,nil,e,tp,SET_PATISSCIEL,SET_NOUVELLES))
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,locs)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	--Cannot use monsters as material for a Fusion/Synchro/Xyz/Link Summon, except "Nouvelles" and "Patissciel" monsters
	aux.RegisterClientHint(e:GetHandler(),0,tp,1,0,aux.Stringid(id,3),0)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e1:SetTargetRange(LOCATION_ALL,LOCATION_ALL)
	e1:SetTarget(function(e,c) return not c:IsSetCard({SET_NOUVELLES,SET_PATISSCIEL}) end)
	e1:SetValue(s.sumlimit)
	e1:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	Duel.RegisterEffect(e3,tp)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	Duel.RegisterEffect(e4,tp)
	--Special Summon 1 "Nouvelles" and 1 "Patissciel" monster
	local g1=Duel.GetMatchingGroup(s.cfilter,tp,locs,0,nil,SET_NOUVELLES)
	local g2=Duel.GetMatchingGroup(s.cfilter,tp,locs,0,nil,SET_PATISSCIEL)
	if #g1==0 or #g2==0 then return end
	local g=g1+g2
	local op1=g:IsExists(s.spfilter,1,nil,e,tp,SET_NOUVELLES,SET_PATISSCIEL)
	local op2=g:IsExists(s.spfilter,1,nil,e,tp,SET_PATISSCIEL,SET_NOUVELLES)
	if not (op1 or op2) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc1=g:FilterSelect(tp,s.spfilter,1,1,nil,e,tp,SET_NOUVELLES,SET_PATISSCIEL):GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc2=g:FilterSelect(tp,s.spchk,1,1,sc1,e,tp,SET_PATISSCIEL):GetFirst()
	local b1=s.extrachk(sc1,e,tp) and s.extrachk(sc2,e,1-tp)
	local b2=s.extrachk(sc1,e,1-tp) and s.extrachk(sc2,e,tp)
	Duel.Hint(HINT_CARD,tp,sc1:GetCode())
	local op=Duel.SelectEffect(tp,
			{b1,aux.Stringid(id,1)}, --"summon to your field"
			{b2,aux.Stringid(id,2)})-1 --"summon to the opponent's field
	Duel.SpecialSummon(sc1,0,tp,op,false,false,POS_FACEUP)
	Duel.SpecialSummon(sc2,0,tp,1-op,false,false,POS_FACEUP)
end
function s.extrachk(c,e,tp)
	local loc=false
	if not c:IsLocation(LOCATION_EXTRA) then
		loc=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	else 
		loc=Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
	end
	return loc and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
end
function s.sumlimit(e,c)
	if not c then return false end
	return c:IsControler(e:GetHandlerPlayer())
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=Duel.GetMatchingGroupCount(Card.IsSetCard,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,SET_RECIPE)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return ct>0 and Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(Card.IsSetCard,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,SET_RECIPE)
	if ct==0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		tc:UpdateAttack(ct*200,RESET_EVENT|RESETS_STANDARD,e:GetHandler())
	end
end