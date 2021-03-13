--軍貫処『海せん』
--Suship Galley Kaisen
--Scripted by The Razgriz
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Place Suship card on deck top
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCondition(s.dtcon)
	e1:SetTarget(s.dttg)
	e1:SetOperation(s.dtop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--Opponent pays LP, Special Summon Suship Xyz
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(s.xyztg)
	e3:SetOperation(s.xyzop)
	c:RegisterEffect(e3)
end
s.listed_series={SET_SUSHIP}
s.listed_names={CARD_RICE_SUSHIP}
function s.cfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(SET_SUSHIP) and c:IsSummonPlayer(tp)
end
function s.dtcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.dttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_DECK,0,1,nil,0x54) end
end
function s.dtop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
	local g=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_DECK,0,1,1,nil,0x54)
	local tc=g:GetFirst()
	if tc then
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(tc,0)
		Duel.ConfirmDecktop(tp,1)
	end
end
function s.filter(c,tp)
	return c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp and c:IsSetCard(0x54) and c:IsSummonLocation(LOCATION_EXTRA)
end
function s.xyzfilter(c,e,tp)
	return c:IsSetCard(SET_SUSHIP) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,true,false)
end
function s.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(s.filter,1,nil,tp) and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_HAND,0,1,nil,26082117) and Duel.IsExistingMatchingCard(s.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_HAND)
end
function s.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local def=0
	for tc in aux.Next(eg) do
		if tc:GetPreviousDefenseOnField()<0 then def=0 end
		def=def+tc:GetPreviousDefenseOnField()
	end
	Duel.PayLPCost(1-tp,def)
	if Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local hc=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_HAND,0,1,1,nil,CARD_RICE_SUSHIP)
		if Duel.SpecialSummon(hc,0,tp,tp,false,false,POS_FACEUP)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local xyzg=Duel.SelectMatchingCard(tp,s.xyzfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
			local sc=xyzg:GetFirst()
			if sc then
				Duel.Overlay(sc,hc)
				Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,true,false,POS_FACEUP)
				sc:CompleteProcedure()
			end
		end
	end
end