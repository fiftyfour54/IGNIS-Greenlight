-- Deck Modification Pack - Hyperspeed Rush Road!!
if not DeckModificationPack_HyperspeedRushRoad then
	DeckModificationPack_HyperspeedRushRoad={}
	local s=DeckModificationPack_HyperspeedRushRoad
	s.RushRare = {}
	s.RushRare={
	160001000,160301001,160302001
	}
	s.RushRare.Ratio=(12)

	s.UltraRare = {}	
	s.UltraRare={
	160001021,
	160001026,
	160001028,
	160001029,
	}
	s.UltraRare.Ratio=(10)

	s.SuperRare = {}
	s.SuperRare={
	160001018,
	160001022,
	160001030,
	160001036,
	160001041,
	160001049
	}
	s.SuperRare.Ratio=(6)
	
	s.Rare = {}
	s.Rare={
	160001011,
	160001012,
	160001013,
	160001014,
	160001015,
	160001016,
	160001017,
	160001024,
	160001025,
	160001031,
	160001033,
	160001034,
	160001039,
	160001045,
	160001046,
	160001047
	}
	
	s.Common = {}
	s.Common={
	160001001,
	160001002,
	160001003,
	160001004,
	160001005,
	160001006,
	160001007,
	160001008,
	160001009,
	160001010,
	160001019,
	160001020,
	160001032,
	160001035,
	160001037,
	160001038,
	160001040,
	160001042,
	160001043,
	160001044,
	160001048,
	160001050
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
			Debug.Message(g:IsExists(Card.IsOriginalCode,1,nil,c:GetOriginalCode()))
			while g:IsExists(Card.IsOriginalCode,1,nil,c:GetOriginalCode()) do
				Debug.Message("g contain c")
				rand=Duel.GetRandomNumber(0,50)
				num=rand%(#s.SuperRare)+1
				c=Duel.CreateToken(1,s.SuperRare[num])
			end
			g:AddCard(c)
		end
	end
	--function to generate the pac
	-- function s.PackGen(e,tp,eg,ep,ev,re,r,rp)
	DeckModificationPack_HyperspeedRushRoad.export=function(p)
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

edopro_exports={DeckModificationPack_HyperspeedRushRoad.export,5}

