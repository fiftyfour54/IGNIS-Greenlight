-- 決闘塔アルカトラズ
-- Duel Tower Alcatraz
-- Scripted by Hatter
local s,id=GetID()
function s.initial_effect(c)
	-- Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	-- Reveal monsters
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetOperation(s.rvop)
	c:RegisterEffect(e1)
	-- Destroy all cards next End Phase
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(function(_,tp) return Duel.IsTurnPlayer(tp) end)
	e2:SetOperation(s.desregop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.descon)
	e3:SetTarget(s.destg)
	e3:SetOperation(s.desop)
	c:RegisterEffect(e3)
end
function s.rvfilter(c)
	return c:GetTextAttack()>=0 and c:IsAbleToRemove() and not c:IsPublic()
end
function s.rvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	-- Each player can choose to reveal
	local rv={}
	for p=0,1 do
		if Duel.IsExistingMatchingCard(s.rvfilter,p,LOCATION_DECK,0,1,nil)
			and Duel.SelectYesNo(p,aux.Stringid(id,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
			rv[p]=Duel.SelectMatchingCard(p,s.rvfilter,p,LOCATION_DECK,0,1,1,nil)
		end
	end
	-- Reveal later so player B doesn't know what player A chose
	local atk={}
	for p=0,1 do
		local g=rv[p]
		if g and #g>0 then
			Duel.ConfirmCards(1-p,g)
			Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
			atk[p]=g:GetFirst():GetAttack()
		else atk[p]=-1 end
	end
	-- The player that revealed the highest ATK can Special Summon
	if atk[tp]==atk[1-tp] then return end
	local p=(atk[tp]>atk[1-tp]) and tp or 1-tp
	if not Duel.IsExistingMatchingCard(Card.IsCanBeSpecialSummoned,p,LOCATION_HAND,0,1,nil,e,0,p,false,false)
		or not Duel.SelectYesNo(p,aux.Stringid(id,3)) then return end
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(p,Card.IsCanBeSpecialSummoned,p,LOCATION_HAND,0,1,1,nil,e,0,p,false,false):GetFirst()
	if not sc then return end
	if Duel.SpecialSummonStep(sc,0,p,p,false,false,POS_FACEUP) then
		-- Can attack directly
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(3205)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e1)
	end
	Duel.SpecialSummonComplete()
end
function s.desregop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,3,Duel.GetTurnCount())
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsTurnPlayer(tp) and c:GetFlagEffect(id)~=0 and c:GetFlagEffectLabel(id)~=Duel.GetTurnCount()
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():ResetFlagEffect(id)
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end