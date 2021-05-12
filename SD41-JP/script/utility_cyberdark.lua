local Cyberdark={}
function Cyberdark.EquipFilter(f)
	return	function(c,tp)
				return c:CheckUniqueOnField(tp) and not c:IsForbidden() and (not f or f(c))
			end
end
function Cyberdark.EquipTarget(f,targets,mandatory)
	f=Cyberdark.EquipFilter(f)
	if targets then
		return Cyberdark.EquipTarget_TG(f,mandatory)
	else
		return Cyberdark.EquipTarget_NTG(f,mandatory)
	end
end
function Cyberdark.EquipOperation(f,op,targets)
	f=Cyberdark.EquipFilter(f)
	if targets then
		return Cyberdark.EquipOperation_TG(f,op)
	else
		return Cyberdark.EquipOperation_NTG(f,op)
	end
end
function Cyberdark.EquipTarget_TG(f,mandatory)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		local wc=Duel.IsPlayerAffectedByEffect(tp,EFFECT_CYBERDARK_WORLD)
		if chkc then return chkc:IsLocation(LOCATION_GRAVE) and (wc or chkc:IsControler(tp)) and s.filter(chkc) end
		local op=0
		if wc then op=LOCATION_GRAVE end
		if chk==0 then return mandatory or (Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(f,tp,LOCATION_GRAVE,op,1,nil)) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectTarget(tp,f,tp,LOCATION_GRAVE,op,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
	end
end
function Cyberdark.EquipTarget_NTG(f,mandatory)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
		local wc=Duel.IsPlayerAffectedByEffect(tp,EFFECT_CYBERDARK_WORLD)
		local op=0, pl=tp
		if wc then 
			op=LOCATION_GRAVE 
			pl=PLAYER_ALL
		end
		if chk==0 then return mandatory or (Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(f,tp,LOCATION_GRAVE,op,1,nil)) end
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,pl,0)
		Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,pl,LOCATION_GRAVE)
	end
end
function Cyberdark.EquipOperation_TG(f)
	return	function(e,tp,eg,ep,ev,re,r,rp)
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
		local c=e:GetHandler()
		if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
		local tc=Duel.GetFirstTarget()
		if tc and tc:IsRelateToEffect(e) then
			if not aux.EquipByEffectAndLimitRegister(c,e,tp,tc) then return end
			op(c,e,tp,tc)
		end
	end
end
function Cyberdark.EquipOperation_NTG(f)
	return	function(e,tp,eg,ep,ev,re,r,rp)
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
		local c=e:GetHandler()
		if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
		local wc=Duel.IsPlayerAffectedByEffect(tp,EFFECT_CYBERDARK_WORLD)
		local op=0
		if wc then op=LOCATION_GRAVE end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(f),tp,LOCATION_GRAVE,op,1,1,nil,tp)
		local tc=g:GetFirst()
		if tc then
			if not aux.EquipByEffectAndLimitRegister(c,e,tp,tc) then return end
			op(c,e,tp,tc)
		end
	end
end
