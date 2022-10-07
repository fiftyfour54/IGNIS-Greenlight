--Ｇ・ボール・シュート
--Giant Ballshoot
--scripted by Naim
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--Switch control of 2 targets
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.ctrltg)
	e2:SetOperation(s.ctrlop)
	c:RegisterEffect(e2)
end
function s.spfilter(c,e,tp,ft)
	return ft>0 and c:IsRace(RACE_INSECT) and c:IsLevelBelow(6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.spfilter(chkc,e,tp,ft) end
	if chk==0 then return true end
	if Duel.IsExistingTarget(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,ft) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,ft)
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,tp,0)
		Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,0)
	else
		e:SetCategory(0)
		e:SetProperty(0)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.rvlfilter(c,tp)
	return c:IsRace(RACE_INSECT) and c:IsAttackAbove(1) and not c:IsPublic()
		and Duel.IsExistingTarget(s.filter1,tp,LOCATION_MZONE,0,1,nil,c:GetAttack())
end
function s.filter1(c,atk)
	local tp=c:GetControler()
	return c:IsAttackBelow(atk) and c:IsFaceup() and c:IsRace(RACE_INSECT) and c:IsAbleToChangeControler()
		and Duel.GetMZoneCount(tp,c,tp,LOCATION_REASON_CONTROL)>0
end
function s.filter2(c)
	local tp=c:GetControler()
	return c:IsFaceup() and c:IsAbleToChangeControler()
		and Duel.GetMZoneCount(tp,c,tp,LOCATION_REASON_CONTROL)>0
end
function s.ctrltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	Debug.Message("First test="..tostring(Duel.IsExistingMatchingCard(s.rvlfilter,tp,LOCATION_HAND,0,1,nil,tp)))
	Debug.Message("second test="..tostring(Duel.IsExistingTarget(s.filter2,tp,0,LOCATION_MZONE,1,nil)))
	if chk==0 then return Duel.IsExistingMatchingCard(s.rvlfilter,tp,LOCATION_HAND,0,1,nil,tp)
		 and Duel.IsExistingTarget(s.filter2,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.rvlfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	local atk=g:GetFirst():GetAttack()
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g1=Duel.SelectTarget(tp,s.filter2,tp,0,LOCATION_MZONE,1,1,nil)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g2=Duel.SelectTarget(tp,s.filter1,tp,LOCATION_MZONE,0,1,1,nil,atk)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g1,2,0,0)
end
function s.ctrlop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards(e)
	local a=g:GetFirst()
	local b=g:GetNext()
	if a:IsRelateToEffect(e) and b:IsRelateToEffect(e) then
		if Duel.SwapControl(a,b) then
			local tc=e:GetLabelObject()
			if tc:IsControler(tp) and not tc:IsRace(RACE_INSECT) then
				--Monster becomes Insect
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_RACE)
				e1:SetValue(RACE_INSECT)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
			end
		end
	end
end