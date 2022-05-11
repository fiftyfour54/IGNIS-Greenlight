--Ｎｏ．２ 蚊学忍者シャドー・モスキート
--Number 2: Ninja Shadow Mosquito
--scripted by Naim
local s,id=GetID()
function s.initial_effect(c)
	--Xyz summon
	Xyz.AddProcedure(c,nil,2,2,nil,nil,99)
	c:EnableReviveLimit()
	--Cannotbe destroyed by battle
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--Avoid battle damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--Monsters the opponent controls must attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCode(EFFECT_MUST_ATTACK)
	c:RegisterEffect(e3)
	--When a monster declares attack, place 1 Hallucination Counter
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_COUNTER)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(s.countertg)
	e4:SetOperation(s.counterop)
	c:RegisterEffect(e4)
	--When a monster declares attack, inflict damage
	local e5=e4:Clone()
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetCategory(CATEGORY_DAMAGE)
	e5:SetTarget(s.dmgtg)
	e5:SetOperation(s.dmgop)
	c:RegisterEffect(e5)
end
s.xyz_number=2
s.counter_place_list={0x1101} --same as the anime version for now. Or 0x120d, according to CCM
function s.countertg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) and
		Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,tp,0x1101)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:RemoveOverlayCard(tp,1,1,REASON_EFFECT) then
		local cg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		if #cg==0 then return end
		local tc=cg:Select(tp,1,1):GetFirst()
		Duel.HintSelection(tc,true)
		tc:AddCounter(0x1101,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetCondition(s.disable)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function s.disable(e)
	return e:GetHandler():GetCounter(0x1101)>0
end
function s.hcounter(c)
	return c:IsFaceup() and c:GetCounter(0x1101)>0 and c:GetAttack()>0 --should this last check be kept?
end
function s.dmgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.hcounter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function s.dmgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.hcounter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if #g==0 then return end
	local tc=g:Select(tp,1,1):GetFirst()
	Duel.HintSelection(tc,true)
	Duel.Damage(1-tp,tc:GetAttack(),REASON_EFFECT)
end