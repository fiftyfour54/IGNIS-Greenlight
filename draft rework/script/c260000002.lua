--Deck Modification Pack - Shocking Lightning Attack!!
local s,id=GetID()
function s.initial_effect(c)
		
	s.RushRare = {}
	s.RushRare={
	160002000,160002017,160002031
	}
	s.RushRare.Ratio=(12)

	s.UltraRare = {}	
	s.UltraRare={
	160002018,
	160002021,
	160002022,
	160002025,
	}
	s.UltraRare.Ratio=(10)

	s.SuperRare = {}
	s.SuperRare={
	160002016,
	160002027,
	160002028,
	160002029,
	160002030,
	160002047
	}
	s.SuperRare.Ratio=(6)
	
	s.Rare = {}
	s.Rare={
	160002001,
	160002005,
	160002008,
	160002011,
	160002019,
	160002020,
	160002023,
	160002032,
	160002033,
	160002034,
	160002035,
	160002036,
	160002039,
	160002042,
	160002046,
	160002048
	}
	
	s.Common = {}
	s.Common={
	
	160002002,
	160002003,
	160002004,
	160002006,
	160002007,
	160002009,
	160002010,
	160002012,
	160002013,
	160002014,
	160002015,
	160002024,
	160002026,
	160002037,
	160002038,
	160002040,
	160002041,
	160002043,
	160002044,
	160002045,
	160002049,
	160002050
	}
	s.CommonNumber=3
	--function to generate the 4th card of the set that can be a Super or just a common
	function s.FourthCardGen(g)
		local super=Duel.GetRandomNumber(0,999)%s.SuperRare.Ratio
		local c=nil
		if super~=0 then
			local rand=Duel.GetRandomNumber(0,50)
			local num=rand%(#s.Common)+1
			local c=Duel.CreateToken(1,s.Common[num])
			while g:IsExists(Card.IsOriginalCode,1,nil,c:GetOriginalCode()) do
				local rand=Duel.GetRandomNumber(0,50)
				local num=rand%(#s.Common)+1
				c=Duel.CreateToken(1,s.Common[num])
			end
			g:AddCard(c)
		else
			local rand=Duel.GetRandomNumber(0,50)
			local num=rand%(#s.SuperRare)+1
			local c=Duel.CreateToken(1,s.SuperRare[num])
			while g:IsExists(Card.IsOriginalCode,1,nil,c:GetOriginalCode()) do
				rand=Duel.GetRandomNumber(0,50)
				num=rand%(#s.SuperRare)+1
				c=Duel.CreateToken(1,s.SuperRare[num])
			end
			g:AddCard(c)
		end
	end
	--function to generate the pac
	-- function s.PackGen(e,tp,eg,ep,ev,re,r,rp)
	function s.PackGen(p)
		local g=Group.CreateGroup()
		--generate the common cards
		for i = s.CommonNumber,1,-1 do 
			local rand=Duel.GetRandomNumber(0,50)
			local num=rand%(#s.Common)+1
			local c=Duel.CreateToken(p,s.Common[num])
			while g:IsExists(Card.IsOriginalCode,1,nil,c:GetOriginalCode()) do
				rand=Duel.GetRandomNumber(0,50)
				num=rand%(#s.Common)+1
				c=Duel.CreateToken(1,s.Common[num])
			end
			g:AddCard(c)
		end
		--generate the 4th card
		s.FourthCardGen(g)
		
		--generate the 5th card
		local test=Duel.GetRandomNumber(0,9999)
		if (test%s.RushRare.Ratio)==0 then
			local num=Duel.GetRandomNumber(0,50)%(#s.RushRare)+1
			local c=Duel.CreateToken(p,s.RushRare[num])
			while g:IsExists(Card.IsOriginalCode,1,nil,c:GetOriginalCode()) do
				rand=Duel.GetRandomNumber(0,50)
				num=rand%(#s.RushRare)+1
				c=Duel.CreateToken(1,s.RushRare[num])
			end
			g:AddCard(c)
		elseif (test%s.UltraRare.Ratio)==0 then
			local num=Duel.GetRandomNumber(0,50)%(#s.UltraRare)+1
			local c=Duel.CreateToken(p,s.UltraRare[num])
			while g:IsExists(Card.IsOriginalCode,1,nil,c:GetOriginalCode()) do
				rand=Duel.GetRandomNumber(0,50)
				num=rand%(#s.UltraRare)+1
				c=Duel.CreateToken(1,s.UltraRare[num])
			end
			g:AddCard(c)
		else
			local num=Duel.GetRandomNumber(0,50)%(#s.Rare)+1
			
			local c=Duel.CreateToken(p,s.Rare[num])
			while g:IsExists(Card.IsOriginalCode,1,nil,c:GetOriginalCode()) do
				rand=Duel.GetRandomNumber(0,50)
				num=rand%(#s.Rare)+1
				c=Duel.CreateToken(1,s.Rare[num])
			end
			g:AddCard(c)
		end
		
		-- test to see the pack content
		-- local tc=g:GetFirst()
		-- for tc in aux.Next(g) do
			-- Debug.Message(tc:GetOriginalCode())
			-- Duel.Hint(HINT_CARD,tp,tc:GetOriginalCode())
		-- end
		
		return g
	end
end

	


