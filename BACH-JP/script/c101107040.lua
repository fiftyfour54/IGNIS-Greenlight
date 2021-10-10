--ガーディアン・キマイラ
--Guardian Chimera
--Scripted by Eerie Code
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	local eff=Fusion.AddProcMixN(c,true,true,s.ffilter,3)
	if not c:IsStatus(STATUS_COPYING_EFFECT) then
		eff[1]:SetValue(s.matfilter)
	end
	--draw and destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,{id,0})
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.immcon)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
end
s.listed_names={CARD_POLYMERIZATION}
function s.ffilter(c,fc,sumtype,tp,sub,mg,sg)
	--return (not sg or not sg:IsExists(s.fusfilter,1,c,c:GetCode(fc,sumtype,tp),fc,tp))
	if sg then
		--if sg:IsExists(s.fusfilter,1,c,c:GetCode(fc,sumtype,tp),fc,tp) then return false end
		--local lc=sg:GetClassCount(Card.GetLocation)
		----Debug.Message("Checking "..c:GetCode()..", location "..c:GetLocation()..": #sg = "..#sg..", lc = "..lc..", #mg = "..#mg..", mloc = "..mg:GetClassCount(Card.GetLocation))
		--if lc==0 or lc==2 then 
		--	return true
		--elseif lc==1 then
		--	return sg:IsExists(aux.NOT(Card.IsLocation),1,nil,c:GetLocation())
		--end
		return not sg:IsExists(s.fusfilter,1,c,c:GetCode(fc,sumtype,tp),fc,tp)
	else
		return true
	end
end
function s.fusfilter(c,code,fc,tp)
	return c:IsSummonCode(fc,SUMMON_TYPE_FUSION,tp,code) and not c:IsHasEffect(511002961)
end
function s.matfilter(c,fc,sub,sub2,mg,sg,tp,contact,sumtype)
	if sumtype&SUMMON_TYPE_FUSION~=0 and fc:IsLocation(LOCATION_EXTRA) then
		return c:IsLocation(LOCATION_ONFIELD+LOCATION_HAND) and c:IsControler(tp)
	end
	return true
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and re and re:IsActiveType(TYPE_SPELL)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=e:GetHandler():GetMaterial()
	local hc=mg:FilterCount(Card.IsPreviousLocation,nil,LOCATION_HAND)
	local fc=mg:FilterCount(Card.IsPreviousLocation,nil,LOCATION_ONFIELD)
	if chk==0 then return hc>0 and fc>0 and Duel.IsPlayerCanDraw(tp,hc)
		and Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>=fc end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,hc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,fc,1-tp,LOCATION_ONFIELD)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local mg=c:GetMaterial()
	local hc=mg:FilterCount(Card.IsPreviousLocation,nil,LOCATION_HAND)
	local fc=mg:FilterCount(Card.IsPreviousLocation,nil,LOCATION_ONFIELD)
	if Duel.Draw(p,hc,REASON_EFFECT)==hc then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,fc,fc,nil)
		if #g>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
function s.immcon(e)
	return Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil,CARD_POLYMERIZATION)
end
