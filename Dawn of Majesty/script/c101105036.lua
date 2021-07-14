--魔鍵召獣－アンシャラボラス
--Magikey Summon Beast - Ansyalabolas
--scripted by Rundas
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,aux.FilterBoolFunctionEx(s.matfilter1(c)),aux.FilterBoolFunctionEx(s.matfilter2(c)))
	--Search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.thcon)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--Change to Def Pos + DEF reduce
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_POSITION+CATEGORY_DEFCHANGE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.postg)
	e2:SetOperation(s.posop)
	c:RegisterEffect(e2)
	--Banish
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_BATTLE_DESTROY_REDIRECT)
	e3:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e3)
end
s.listed_names={id,101105056}
s.listed_series={SET_MAGIKEY}
function s.matfilter1(fc)
	return function(c)
		return c:IsSetCard(SET_MAGIKEY) and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial(fc)
	end
end
function s.matfilter2(fc)
	return function(c)
		return c:IsType(TYPE_NORMAL) and not c:IsType(TYPE_TOKEN) and c:IsCanBeFusionMaterial(fc)
	end
end
--Search
function s.thfilter(c)
	return c:IsCode(101105056) and c:IsAbleToHand()
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--To Def + DEF reduce
function s.posfilter(c,att)
	return c:IsFaceup() and c:IsCanChangePosition() and c:GetAttribute()&att>0
end
function s.attfilter(c)
	return c:IsSetCard(SET_MAGIKEY) or c:IsType(TYPE_NORMAL)
end
function s.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local att=0
	for tc in ~Duel.GetMatchingGroup(s.attfilter,tp,LOCATION_GRAVE,0,nil) do
		att=att|tc:GetAttribute()
	end
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.posfilter(chkc,att) end
	if chk==0 then return Duel.IsExistingTarget(s.posfilter,tp,0,LOCATION_MZONE,1,nil,att) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,s.posfilter,tp,0,LOCATION_MZONE,1,1,nil,att)
	Duel.SetOperationInfo(0,CATEGORY_POSITION+CATEGORY_DEFCHANGE,g,1,1-tp,LOCATION_MZONE)
end
function s.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() then
		if Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)>0 then
			if tc:GetDefense()>0 then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_DEFENSE)
				e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
				e1:SetRange(LOCATION_MZONE)
				e1:SetValue(-1000)
				tc:RegisterEffect(e1)
			end
		end
	end
end