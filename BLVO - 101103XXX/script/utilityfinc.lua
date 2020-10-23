function aux.SecurityTarget(e,_c)
    return _c:GetColumnGroup():IsExists(function(c,tp)return c:IsControler(tp) and c:IsFaceup() and c:IsSetCard(0x259) end,1,_c,e:GetHandlerPlayer())
end