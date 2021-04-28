-- Deck Modification Pack - Fantastrike Mirage Impact
if not DeckModificationPack_FantastrikeMirageImpact then
	DeckModificationPack_FantastrikeMirageImpact={}
	DeckModificationPack_FantastrikeMirageImpact.size=5
	local s=DeckModificationPack_FantastrikeMirageImpact
	s.RushRare = {}
	s.RushRare={
	160003000,160003018,160003025
	}
	s.RushRare.Ratio=(12)

	s.UltraRare = {}	
	s.UltraRare={
	160003024,
	160003031,
	160003033,
	160003040,
	160003041
	}
	s.UltraRare.Ratio=(10)

	s.SuperRare = {}
	s.SuperRare={
	160003014,
	160003016,
	160003022,
	160003023,
	160003032,
	160003042,
	160003054
	}
	s.SuperRare.Ratio=(6)
	
	s.Rare = {}
	s.Rare={
	160003001,
	160003009,
	160003010,
	160003011,
	160003013,
	160003019,
	160003021,
	160003029,
	160003034,
	160003035,
	160003037,
	160003038,
	160003047,
	160003052,
	160003053,
	160003056,
	160003058
	}
	
	s.Common = {}
	s.Common={
	160003002,
	160003003,
	160003004,
	160003005,
	160003006,
	160003007,
	160003008,
	160003012,
	160003015,
	160003017,
	160003020,
	160003026,
	160003027,
	160003030,
	160003036,
	160003039,
	160003043,
	160003044,
	160003045,
	160003046,
	160003048,
	160003049,
	160003050,
	160003051,
	160003055,
	160003057,
	160003059,
	160003060
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
	DeckModificationPack_FantastrikeMirageImpact.export=function(p)
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

edopro_exports={DeckModificationPack_FantastrikeMirageImpact.export,DeckModificationPack_FantastrikeMirageImpact.size}

