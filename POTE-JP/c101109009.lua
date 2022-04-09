--セリオンズ・イレギュラー
--Therions' Irregular
--Scripted by Eerie Code
local s,id=GetID()
function s.initial_effect(c)
	--Special summon itself from hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,{id,0})
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,{id,1})
	e2:SetCost(s.descost)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,{id,2})
	e3:SetTarget(s.sptg2)
	e3:SetOperation(s.spop2)
	c:RegisterEffect(e3)
end
s.listed_names={21887075}
s.listed_series={0x17b}
function s.eqfilter(c)
	return c:IsSetCard(0x17b) and c:IsType(TYPE_MONSTER)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.eqfilter(chkc) end
	local ft=math.min(Duel.GetLocationCount(tp,LOCATION_SZONE),3)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and ft>0
		and Duel.IsExistingTarget(s.eqfilter,tp,LOCATION_GRAVE,0,1,nil)
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	local g=Duel.SelectTarget(tp,s.eqfilter,tp,LOCATION_GRAVE,0,1,ft,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,#g,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
		local g=Duel.GetTargetCards(e):Match(Card.IsType,nil,TYPE_MONSTER):Match(Card.IsSetCard,nil,0x17b)
		if ft<#g then return end
		Duel.BreakEffect()
		for tc in aux.Next(g) do
			Duel.Equip(tp,tc,c,false)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(s.eqlimit)
			tc:RegisterEffect(e1)
			tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
		end
	end
end
function s.eqlimit(e,c)
	return e:GetOwner()==c
end
function s.cfilter(c)
	return c:IsCode(21887075) and c:IsDiscardable()
end
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,s.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetHandler():GetEquipTarget()
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.Equip(tp,tc,c,true)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(s.eqlimit)
		e1:SetLabelObject(tc)
		tc:RegisterEffect(e1)
	end
end
