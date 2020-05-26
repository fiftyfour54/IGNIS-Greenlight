--Created using senpaizuri's Puzzle Maker (updated by Naim & Larry126)
Debug.ReloadFieldBegin(DUEL_ATTACK_FIRST_TURN+DUEL_SIMPLE_AI,5)
Debug.SetPlayerInfo(0,8000,0,0)
Debug.SetPlayerInfo(1,8000,0,0)

--Extra Deck
Debug.AddCard(100266041,0,0,LOCATION_EXTRA,0,8)
--Monster Zones
Debug.AddCard(100266038,0,0,LOCATION_MZONE,5,1,true)
Debug.AddCard(100266035,0,0,LOCATION_MZONE,0,1,true)
--Monster Zones
Debug.AddCard(55784832,1,1,LOCATION_MZONE,1,1,true)
Debug.AddCard(73911410,1,1,LOCATION_MZONE,2,1,true)
Debug.ReloadFieldEnd()
aux.BeginPuzzle()