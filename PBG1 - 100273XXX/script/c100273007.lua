--Zolga the Prophet
--Scripted by The Razgriz

--Substitute ID
local s,id=GetID()
function s.initial_effect(c)
	--Special Summon/Look at top 5 cards
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.spcon)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+100)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(s.con)
	e2:SetTarget(s.tg)
	e2:SetOperation(s.op)
	c:RegisterEffect(e2)
end
function s.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_EARTH) and not c:IsCode(id)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local g1=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
		local g2=Duel.GetFieldGroup(1-tp,LOCATION_DECK,0)
		local ct1=1
		local ct2=1
		if #g1==1 then 
			ct1=1
		elseif #g1==2 then 
			ct1=Duel.AnnounceNumber(tp,1,2)
		elseif #g1==3 then 
			ct1=Duel.AnnounceNumber(tp,1,2,3)
		elseif #g1==4 then 
			ct1=Duel.AnnounceNumber(tp,1,2,3,4)
		else
			ct1=Duel.AnnounceNumber(tp,1,2,3,4,5)
		end
		if #g2==1 then 
			ct2=1
		elseif #g2==2 then 
			ct2=Duel.AnnounceNumber(tp,1,2)
		elseif #g2==3 then 
			ct2=Duel.AnnounceNumber(tp,1,2,3)
		elseif #g2==4 then 
			ct2=Duel.AnnounceNumber(tp,1,2,3,4)
		else
			ct2=Duel.AnnounceNumber(tp,1,2,3,4,5)
		end
		Duel.ConfirmDecktop(tp,ct1)
		Duel.ConfirmDecktop(1-tp,ct2)
	end
end
function s.con(e,tp,eg,ev,ep,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetReasonCard()
	local at=Duel.GetAttacker()
	return (e:GetHandler():IsReason(REASON_RELEASE) and not e:GetHandler():IsReason(REASON_EFFECT)) and tc:IsType(TYPE_MONSTER) and at==tc
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local at=Duel.GetAttacker()
	local tc=e:GetHandler():GetReasonCard()
	if (e:GetHandler():IsReason(REASON_RELEASE) and not e:GetHandler():IsReason(REASON_EFFECT)) and tc:IsType(TYPE_MONSTER) and at==tc then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,2000)
	end
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetHandler():GetReasonCard()
	local at=Duel.GetAttacker()
	if not tc:IsReason(REASON_SUMMON) or (not c:IsReason(REASON_RELEASE) or c:IsReason(REASON_EFFECT)) and not at==tc then return end
	if at==tc then 
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			Duel.Damage(1-tp,2000,REASON_EFFECT)
		end
	end
end