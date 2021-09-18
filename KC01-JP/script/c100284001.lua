--攻撃誘導アーマー
--Attack Guidance Armor
--Scripted by Larry126
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc~=Duel.GetAttacker() end
	if chk==0 then return true end
	e:SetProperty(0)
	local tg=Duel.GetMatchingGroup(Card.IsCanBeEffectTarget,tp,LOCATION_MZONE,LOCATION_MZONE,Duel.GetAttacker(),e)
	if tg:GetFirst() and Duel.SelectYesNo(aux.Stringid(id,0)) then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTACKTARGET)
		Duel.SetTargetCard(tg:Select(tp,1,1,nil))
	else
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,Duel.GetAttacker(),1,0,0)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local tc=Duel.GetFirstTarget()
	if not tc and a:IsRelateToBattle() then
		Duel.Destroy(a,REASON_EFFECT)
	elseif tc and tc:IsRelateToEffect(e) and a:CanAttack() and not a:IsImmuneToEffect(e) then
		Duel.CalculateDamage(a,tc)
	end
end
