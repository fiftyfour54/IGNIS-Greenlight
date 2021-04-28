-- Deck Modification Pack - Dynamic Eternal Live!!
if not DeckModificationPack_DynamicEternalLive then
	DeckModificationPack_DynamicEternalLive={}
	DeckModificationPack_DynamicEternalLive.size=5
	local s=DeckModificationPack_DynamicEternalLive
	s.RushRare = {}
	s.RushRare={
	160005000,160005013,160005019,160005024
	}
	s.RushRare.Ratio=(2)

	s.UltraRare = {}	
	s.UltraRare={
	160005013,
	160005014,
	160005015,
	160005016,
	160005019,
	160005024,
	160005031
	}
	s.UltraRare.Ratio=(10)

	s.SuperRare = {}
	s.SuperRare={
	160005002,
	160005026,
	160005029,
	160005035,
	160005038,
	160005044,
	160005052,
	160005061,
	160005065
	}
	s.SuperRare.Ratio=(16)
	
	s.Rare = {}
	s.Rare={
	160005001,
	160005005,
	160005011,
	160005017,
	160005020,
	160005022,
	160005025,
	160005030,
	160005034,
	160005039,
	160005042,
	160005046,
	160005047,
	160005053,
	160005054,
	160005057,
	160005062
	}
	
	s.Common = {}
	s.Common={
	160005003,
	160005004,
	160005006,
	160005007,
	160005008,
	160005009,
	160005010,
	160005012,
	160005018,
	160005021,
	160005023,
	160005027,
	160005028,
	160005033,
	160005036,
	160005037,
	160005040,
	160005043,
	160005045,
	160005048,
	160005049,
	160005050,
	160005051,
	160005055,
	160005056,
	160005058,
	160005059,
	160005060,
	160005063,
	160005064
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
	DeckModificationPack_DynamicEternalLive.export=function(p)
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

edopro_exports={DeckModificationPack_DynamicEternalLive.export,DeckModificationPack_DynamicEternalLive.size}

