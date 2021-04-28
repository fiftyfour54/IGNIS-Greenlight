--rush draft simulator
local s,id=GetID()
function s.initial_effect(c)
	--Pre-draw
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetCountLimit(1)
	e1:SetOperation(s.op)
	Duel.RegisterEffect(e1,0)
end
s.boostertable={260000001,260000002,260000003,260000004,260000005}
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local GetPackExports=function(code)
		local res,export=Duel.LoadScript("c"..code..".lua",false)
		return export
	end
	local fg=Duel.GetFieldGroup(0,0x43,0x43)
	--remove all cards
	Duel.SendtoDeck(fg,nil,-2,REASON_RULE)
	
	--announce number of pack drafted
	local packnum=Duel.AnnounceLevel(tp,1,15)
	
	--declare kind of pack
	--the list of packs might be loaded from another file as well
	local pack={}
	while packnum>0 do
		-- local ac=Duel.SelectCardsFromCodes(tp,1,1,false,false,260000001,260000002,260000003,260000004,260000005)
		local ac=Duel.SelectCardsFromCodes(tp,1,1,false,false,table.unpack(s.boostertable))
		local packadd=Duel.AnnounceLevel(tp,1,packnum)
		for i=1,packadd do
			table.insert(pack,ac)
			packnum=packnum-1
		end
	end
	
	local packopp={table.unpack(pack)}
	--variable for later
	local pick=Group.CreateGroup()
	local pickopp=Group.CreateGroup()
		
	--Preload pack group creator functions and pack counts
	local generators={}
	for _,_pack in ipairs(pack) do
		if not generators[_pack] then
			generators[_pack]=GetPackExports(_pack)
		end
	end
	
	--pack opening
	for i=1,#pack do
		--each player pick their pack
		local packpick=Duel.SelectCardsFromCodes(tp,1,1,false,true,table.unpack(pack))
		
		--Allows the selection of only a pack that has the same number of cards in it
		local packcount1=generators[packpick[1]][2]
		
		local validoppo={}
		validoppo[1]={}
		validoppo[2]={}
		
		for _,_pack in ipairs(packopp) do
			if generators[_pack][2]==packcount1 then
				table.insert(validoppo[1],_pack)
				table.insert(validoppo[2],_)
			end
		end
		
		local packpickopp=Duel.SelectCardsFromCodes(1-tp,1,1,false,true,table.unpack(validoppo[1]))
		--remove the pack
		table.remove(pack,packpick[2])
		table.remove(packopp,validoppo[2][packpickopp[2]])
		
		--pack gen
		local packopen=generators[packpick[1]][1](tp)
		local packopenopp=generators[packpickopp[1]][1](1-tp)
		local pickturn=tp
		--loop that make the player pick
		--a new token is generated in function of pick to set the owner
		for j=1,#packopen do
			if pickturn==tp then
				local tc= packopen:Select(tp,1,1,nil)
				packopen:Sub(tc)
				local c=Duel.CreateToken(tp,tc:GetFirst():GetOriginalCode())
				pick:AddCard(c)
				local tc2= packopenopp:Select(tp,1,1,nil)
				packopenopp:Sub(tc2)
				local c2=Duel.CreateToken(1-tp,tc2:GetFirst():GetOriginalCode())
				pickopp:AddCard(c2)
				pickturn=1-tp
			else
				local tc= packopenopp:Select(tp,1,1,nil)
				packopenopp:Sub(tc)
				local c=Duel.CreateToken(tp,tc:GetFirst():GetOriginalCode())
				pick:AddCard(c)
				local tc2= packopen:Select(tp,1,1,nil)
				packopen:Sub(tc2)
				local c2=Duel.CreateToken(1-tp,tc2:GetFirst():GetOriginalCode())
				pickopp:AddCard(c2)
				pickturn=tp
			end
		end
	end
	--add something to have the players pick the cards he want to keep
	
	Duel.SendtoDeck(pick,nil,tp,REASON_RULE)
	Duel.SendtoDeck(pickopp,nil,tp,REASON_RULE)
end