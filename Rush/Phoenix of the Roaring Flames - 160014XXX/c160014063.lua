--アミュージー・アノイアンス
--Amusi Annoyance
--scripted by YoshiDuels
local s,id=GetID()
function s.initial_effect(c)
	--Increase the ATK of 1 monster you control
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,1-tp) and Duel.IsMainPhase() and Duel.IsTurnPlayer(1-tp)
end
function s.filter(c,tp)
	return c:IsPreviousLocation(LOCATION_DECK) and c:GetOwner()==tp
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if eg:IsExists(s.filter,1,nil,1-tp) then
		e:SetLabel(1)
	end
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if chk==0 then return ct>0 end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*300)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local ct=#dg
	if ct>0 and Duel.Damage(1-tp,ct*300,REASON_EFFECT)>0 and e:GetLabel()==1 then
		local g=dg:RandomSelect(tp,1)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
