--デメット爺さん
--Grandpa Demetto
--Logical Nonsense

--Substitute ID
local s,id=GetID()
function s.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DETACH_EVENT)
	--Special summon up to 2 normal monsters from GY
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--Destroy 1 monster your opponent controls, inflict damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+100)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.descon)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
	--Global check
	aux.GlobalCheck(s,function()
		--s['mat_chk']=nil
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DETACH_MATERIAL)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end)
end
	--Specifically lists "Princess Cologne"
s.listed_names={75574498}

	--Check for "Princess Cologne"
function s.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsCode(75574498)
end
	--Detach 1 material from "Princess Cologne" as cost
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Group.CreateGroup()
	local mg=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(mg) do
		g:Merge(tc:GetOverlayGroup())
	end
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
	local sg=g:Select(tp,1,1,nil)
	Duel.SendtoGrave(sg,REASON_COST)
end
	--Check for a normal monster with 0 ATK or DEF
function s.spfilter(c,e,tp)
	return c:IsType(TYPE_NORMAL) and (c:IsAttack(0) or c:IsDefense(0)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
	--Activation legality
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
	--Special summon 2 normal monsters from GY
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local c=e:GetHandler()
	if ft>2 then ft=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE,0,1,ft,nil,e,tp)
	if #g>0 then
		local tc=g:GetFirst()
		for tc in aux.Next(g) do
			--They become level 8 DARK monsters
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(ATTRIBUTE_DARK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(8)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
		end
		Duel.SpecialSummonComplete()
	end
end
	
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local cid=Duel.GetCurrentChain()
	if cid>0 and r&REASON_COST==REASON_COST then 
		s['mat_chk']=Duel.GetChainInfo(cid,CHAININFO_CHAIN_ID)
		--local ct=eg:GetFirst()
		--e:SetLabelObject(ct)
	end
end
	
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)==s['mat_chk']-- and e:GetLabel()==1
		and re:GetHandler():IsCanBeEffectTarget(e) and re:GetHandler():GetControler()==tp
		and re:IsActiveType(TYPE_XYZ)-- and e:GetLabelObject() and e:GetLabelObject():IsType(TYPE_NORMAL)
end

--[[function s.matfilter(c)
	return c:GetPreviousLocation()&LOCATION_OVERLAY~=0 and (c:IsType(TYPE_NORMAL) and not c:IsType(TYPE_GEMINI))
end]]
	--Activation legality
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
		--and Duel.IsExistingMatchingCard(s.matfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	Duel.SetTargetCard(re:GetHandler())
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
	--Destroy 1 monster your opponent controls, inflict damage
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local ex,g=Duel.GetOperationInfo(0,CATEGORY_DESTROY)
	if g:GetFirst():IsRelateToEffect(e) then
		if Duel.Destroy(g,REASON_EFFECT) then
			local tc=Duel.GetFirstTarget()
			if not (tc and tc:IsRelateToEffect(e) and tc:IsFaceup()) then return end
			local dam=tc:GetRank()*300
			Duel.Damage(1-tp,dam,REASON_EFFECT)
		end
	end
end