--リザレクション・ブレス
--Resurrection Breath
--scripted by Rundas
local s,id=GetID()
function s.initial_effect(c)
	--SS + Equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.con)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
s.listed_names={TOKEN_BRAVE}
--SS + Equip
function s.eqfilter(c,tp)
	return c:GetActivateEffect():IsActivatable(tp,true,false) and c:IsType(TYPE_EQUIP) and Duel.IsExistingMatchingCard(s.eqfilter2,tp,LOCATION_MZONE,0,1,nil,c) and aux.IsCodeListed(c,TOKEN_BRAVE)
end
function s.eqfilter2(c,tc)
	return c:IsFaceup() and tc:CheckEquipTarget(c)
end
function s.con(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,TOKEN_BRAVE)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g,ft=Duel.GetMatchingGroup(Card.IsCanBeSpecialSummoned,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,0,tp,false,false),math.min(2,Duel.GetLocationCount(tp,LOCATION_MZONE))
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	if chk==0 then return aux.SelectUnselectGroup(g,e,tp,1,ft,aux.dncheck,0) and ft>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local g,ft=Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsCanBeSpecialSummoned),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,0,tp,false,false),math.min(2,Duel.GetLocationCount(tp,LOCATION_MZONE))
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	g=aux.SelectUnselectGroup(g,e,tp,1,ft,aux.dncheck,1,tp,HINTMSG_SPSUMMON,nil,nil,false)
	if #g>0 then
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
			for tc in ~g do
				--Banish it when it leaves the field
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetDescription(3300)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
				e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
				e1:SetValue(LOCATION_REMOVED)
				tc:RegisterEffect(e1,true)
			end
			if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.eqfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
				local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.eqfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
				local tc2=Duel.SelectMatchingCard(tp,s.eqfilter2,tp,LOCATION_MZONE,0,1,1,nil,tc):GetFirst()
				Duel.Equip(tp,tc,tc2)
			end
		end
	end
end