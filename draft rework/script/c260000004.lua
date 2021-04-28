-- Deck Modification Pack - Destined Power Destruction
if not DeckModificationPack_DestinedPowerDestruction then
	DeckModificationPack_DestinedPowerDestruction={}
	DeckModificationPack_DestinedPowerDestruction.size=5
	local s=DeckModificationPack_DestinedPowerDestruction
	s.RushRare = {}
	s.RushRare={
	160004000,160004015,160004024
	}
	s.RushRare.Ratio=(12)

	s.UltraRare = {}	
	s.UltraRare={
	160004020,
	160004021,
	160004022,
	160004023,
	160004029
	}
	s.UltraRare.Ratio=(10)

	s.SuperRare = {}
	s.SuperRare={
	160004015,
	160004032,
	160004042,
	160004049,
	160004051,
	160004052,
	160004060
	}
	s.SuperRare.Ratio=(6)
	
	s.Rare = {}
	s.Rare={
	160004002,
	160004005,
	160004019,
	160004025,
	160004028,
	160004030,
	160004034,
	160004037,
	160004038,
	160004040,
	160004041,
	160004043,
	160004044,
	160004048,
	160004050,
	160004053
	}
	
	s.Common = {}
	s.Common={
	160004001,
	160004003,
	160004004,
	160004006,
	160004007,
	160004008,
	160004009,
	160004010,
	160004011,
	160004012,
	160004013,
	160004014,
	160004016,
	160004018,
	160004026,
	160004027,
	160004033,
	160004035,
	160004036,
	160004039,
	160004045,
	160004046,
	160004047,
	160004054,
	160004055,
	160004056,
	160004057,
	160004058,
	160004059
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
	DeckModificationPack_DestinedPowerDestruction.export=function(p)
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

edopro_exports={DeckModificationPack_DestinedPowerDestruction.export,DeckModificationPack_DestinedPowerDestruction.size}

