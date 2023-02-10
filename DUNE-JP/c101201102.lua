--レボリューション・シンクロン
--Revolution Synchron
--scripted by Naim
local s,id=GetID()
function s.initial_effect(c)
	--Can be used as material from the hand for "Power Tool" Synchro Monster or Level 7/8 Dragon Monster
	--Incomplete, synchro summon procedure might not support it
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_HAND_SYNCHRO)
	e1:SetCountLimit(1,id)
	e1:SetValue(s.synval)
	c:RegisterEffect(e1)
	-- Send the top card from your Deck to the GY and Special Summon itself from the GY
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DECKDES+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id,EFFECT_COUNT_CODE_DUEL)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
s.lsited_series={SET_POWER_TOOL}

function s.spconfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsLevelAbove(7)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.spconfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardDeck(tp,1,REASON_EFFECT)>0 and Duel.GetOperatedGroup():GetFirst():IsLocation(LOCATION_GRAVE) then
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
			--Level becomes 1
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1,true)
		end
		Duel.SpecialSummonComplete()
	end
end
function s.cfilter(c)
	return c:IsType(TYPE_SYNCHRO) and (c:IsSetCard(SET_POWER_TOOL) or (c:IsType(TYPE_DRAGON) and (c:IsLevel(7) or c:IsLevel(8))))
end
function s.synval(e,c,sc) --effect's handler, card being used, monster to be summoned
	return s.cfilter(sc)
	-- if s.cfilter(sc) then
		-- local e1=Effect.CreateEffect(e:GetHandler())
		-- e1:SetType(EFFECT_TYPE_SINGLE)
		-- e1:SetCode(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)
		-- e1:SetLabel(id)
		-- e1:SetTarget(s.synchktg)
		-- e:GetHandler():RegisterEffect(e1)
		-- return true
	-- else return false end
end
function s.chk(c)
	if not c:IsHasEffect(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK) then return false end
	local te={c:GetCardEffect(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)}
	for i=1,#te do
		local e=te[i]
		if e:GetLabel()~=id then return false end
	end
	return true
end
function s.chk2(c)
	if not c:IsHasEffect(EFFECT_HAND_SYNCHRO) or c:IsHasEffect(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK) then return false end
	local te={c:GetCardEffect(EFFECT_HAND_SYNCHRO)}
	for i=1,#te do
		local e=te[i]
		if e:GetLabel()==id then return true end
	end
	return false
end
function s.synchktg(e,c,sg,tg,ntg,tsg,ntsg)
	if c then
		local res=true
		if sg:IsExists(s.chk,1,c) or (not tg:IsExists(s.chk2,1,c) and not ntg:IsExists(s.chk2,1,c) 
			and not sg:IsExists(s.chk2,1,c)) then return false end
		local trg=tg:Filter(s.chk,nil)
		local ntrg=ntg:Filter(s.chk,nil)
		return res,trg,ntrg
	else
		return true
	end
end