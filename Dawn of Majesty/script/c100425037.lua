--死眼の伝霊－プシュコポンポス
--Messenger Spirit of the Fatal Eye - Psychopompos
--scripted by Rundas
local s,id=GetID()
function s.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1,id)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--Stuff on Special Summon Success
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(s.sstg)
	e2:SetOperation(s.ssop)
	c:RegisterEffect(e2)
end
s.listed_names={id}
--Special Summon
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()==e:GetHandler():GetTurnID()+1
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_REMOVED)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 or not c:IsCanBeSpecialSummoned(e,0,tp,false,false) or not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
--Stuff on Special Summon Success
function s.remfilter(c)
	return c:IsMonster() and c:IsAbleToRemove() and aux.SpElimFilter(c,true)
end
function s.tgfilter(c)
	return c:IsMonster() and c:IsAbleToGrave()
end
function s.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ctm,ctst=Duel.GetMatchingGroupCount(Card.IsMonster,tp,0,LOCATION_GRAVE,nil),Duel.GetMatchingGroupCount(Card.IsType,tp,0,LOCATION_GRAVE,nil,TYPE_SPELL+TYPE_TRAP)
	if chk==0 then return ctm~=ctst end
end
function s.ssop(e,tp,eg,ep,ev,re,r,rp)
	local c,ctm,ctst=e:GetHandler(),Duel.GetMatchingGroupCount(Card.IsMonster,tp,0,LOCATION_GRAVE,nil),Duel.GetMatchingGroupCount(Card.IsType,tp,0,LOCATION_GRAVE,nil,TYPE_SPELL+TYPE_TRAP)
	local tg=ctm<ctst and Duel.IsExistingMatchingCard(s.tgfilter,tp,0,LOCATION_MZONE,1,nil) and c:IsAbleToGrave()
	local rem=ctm>ctst and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.remfilter),tp,0,LOCATION_GRAVE,1,nil) and c:IsAbleToRemove()
	if not tg and not rem then return end
	local tc
	if rem then
		if Duel.Remove(c,POS_FACEUP,REASON_EFFECT)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			tc=Duel.SelectMatchingCard(1-tp,aux.NecroValleyFilter(s.remfilter),tp,0,LOCATION_GRAVE,1,1,nil)
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	else
		if Duel.SendtoGrave(c,REASON_EFFECT)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			tc=Duel.SelectMatchingCard(1-tp,s.tgfilter,tp,0,LOCATION_MZONE,1,1,nil)
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
	end
end