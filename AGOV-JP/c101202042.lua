--厄災の星ティ・フォン
--Stellar Nemesis T-PHON – Doomsday Star
--Scripted by Eerie Code
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Xyz.AddProcedure(c,nil,12,2,s.xyzfilter,aux.Stringid(id,0),2,s.xyzop)
	--prevent activation
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,1)
	e1:SetCondition(function(e) return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) end)
	e1:SetValue(s.actlimit)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(aux.dxmcostgen(1,1,nil))
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2,false,REGISTER_FLAG_DETACH_XMAT)
	--summon register
	aux.GlobalCheck(s,function()
		s.sum_count={}
		s.sum_count[0]=0
		s.sum_count[1]=0
		aux.AddValuesReset(function()
				s.sum_count[0]=0
				s.sum_count[1]=0
			end)
		end)
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end)
end
function s.checkfilter(c,tp)
	return c:IsSummonLocation(LOCATION_EXTRA) and c:IsSummonPlayer(tp)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do
		local gc=eg:FilterCount(s.checkfilter,nil,p)
		s.sum_count[p]=s.sum_count[p]+gc
		if s.sum_count[p]>=2 and not Duel.HasFlagEffect(p,id) then
			Duel.RegisterFlagEffect(p,id,RESET_PHASE|PHASE_END,0,2)
		end
	end
end
function s.xyzfilter2(c,atk)
	return c:IsFaceup() and c:GetAttack()>atk
end
function s.xyzfilter(c,tp,xyzc)
	return c:IsFaceup() and not Duel.IsExistingMatchingCard(s.xyzfilter2,tp,LOCATION_MZONE,0,1,nil,c:GetAttack())
end
function s.xyzop(e,tp,chk)
	if chk==0 then return Duel.HasFlagEffect(1-tp,id) end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e2,tp)
	aux.RegisterClientHint(c,nil,tp,1,0,aux.Stringid(id,3),nil)
	return true
end
function s.actlimit(e,re,tp)
	return re:IsMonsterEffect() and re:GetHandler():IsAttackAbove(3000)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,PLAYER_ALL,LOCATION_MZONE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
