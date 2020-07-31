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

function s.op(e,tp,eg,ep,ev,re,r,rp)
	local fg=Duel.GetFieldGroup(0,0x43,0x43)
	--remove all cards
	Duel.SendtoDeck(fg,nil,-2,REASON_RULE)
	
	--announce number of pack drafted
	local r={}
	local j=1
	for k=1,15 do
		r[j]=k
		j=j+1
	end
	local packnum=Duel.AnnounceNumber(tp,table.unpack(r))
	
	--declare kind of pack
	--maybe an array could be used instead of declare name?
	s.announce_filter={0x700,OPCODE_ISSETCARD,code,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND}
	local pack=Group.CreateGroup()
	for i=1,packnum do
		local ac=Duel.AnnounceCard(tp,table.unpack(s.announce_filter))
		
		local c=Duel.CreateToken(tp,ac)
		pack:AddCard(c)
	end
	local packopp=pack:Clone()
	--variable for later
	local pick=Group.CreateGroup()
	local pickopp=Group.CreateGroup()
	
	local packopen=Group.CreateGroup()
	local packopenopp=Group.CreateGroup()
	--pack opening
	Debug.Message(#pack)
	for i=1,#pack do
		--each player pick their pack
		local packpick=pack:Select(tp,1,1,nil)
		
		local packpickopp=packopp:Select(1-tp,1,1,nil)
		--remove the pack
		pack:Sub(packpick)
		packopp:Sub(packpickopp)
		
		--pack gen
		Debug.Message(packpick)
		local m = packpick:GetFirst():GetMetatable()
		local n = packpickopp:GetFirst():GetMetatable()
		packopen=m.PackGen(tp)
		packopenopp=n.PackGen(1-tp)
		pickturn=tp
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