-- レプティレス・ラミフィケーション
-- Reptilianne Lamification
-- Scripted by Hatter
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE+CATEGORY_TOHAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
s.listed_series={0x3c}
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsAbleToGraveAsCost,1,1,REASON_COST)
end
 -- Lets a player choose n options
 -- Cannot be cancelled or finished early (no min-max)
function aux.SelectMultipleOptions(tp,n,sort,descs,cons,funcs,...)
	local excs={}
	local opts
	-- filter which options can be selected based on cons
	if cons then
		opts={}
		for i,desc in ipairs(descs) do
			if cons[i] then table.insert(opts,desc) else table.insert(excs,i-1) end
		end
	else opts={table.unpack(descs)} end
	-- start selection
	local sels={}
	for i=1,n do
		if #opts>0 then
			local sel=Duel.SelectOption(tp,table.unpack(opts))
			table.remove(opts,sel+1)
			-- adjust the selection so it corresponds
			-- to the index in the original table (descs)
			for _,exc in ipairs(excs) do
				if exc<=sel then sel=sel+1 end
			end
			table.insert(sels,sel)
			table.insert(excs,sel)
		end
	end
	-- execute optional functions for each selection
	if funcs then
		for _,sel in ipairs(sels) do
			if funcs[sel] then funcs[sel](...) end
		end
	end
	-- if sort is true, arrange according to position in original table
	-- if not, arrange according to order of selection
	return sort and table.sort(sels) or sels
end
function s.mfilter(c)
	return c:IsMonster() and c:IsSetCard(0x3c) and c:IsAbleToHand()
end
function s.stfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x3c) and not c:IsCode(id) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b0=Duel.IsExistingMatchingCard(s.mfilter,tp,LOCATION_DECK,0,1,nil)
	local b1=Duel.IsExistingMatchingCard(s.stfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsAttackAbove,1),tp,0,LOCATION_MZONE,1,nil)
	if chk==0 then return b0 and (b1 or b2) or (b1 and b2) end
	local tohand=0
	local opts=aux.SelectMultipleOptions(tp,2,false,
		{aux.Stringid(id,0),aux.Stringid(id,1),aux.Stringid(id,2)},
		{b0,b1,b2},
		{
			function() tohand=tohand+1 end,
			function() tohand=tohand+1 end,
			function() e:SetCategory(e:GetCategory()+CATEGORY_ATKCHANGE) end
		}
	)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,tohand,tp,LOCATION_DECK)
	e:SetLabelObject(opts)
end
function s.mthop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.mfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.stthop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.stfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATKDEF)
	local g=Duel.SelectMatchingCard(tp,aux.FilterFaceupFunction(Card.IsAttackAbove,1),tp,0,LOCATION_MZONE,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		-- ATK becomes 0
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		g:GetFirst():RegisterEffect(e1)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local ops={s.mthop,s.stthop,s.atkop}
	for _,opt in ipairs(e:GetLabelObject()) do
		ops[opt+1](e,tp,eg,ep,ev,re,r,rp)
	end
end