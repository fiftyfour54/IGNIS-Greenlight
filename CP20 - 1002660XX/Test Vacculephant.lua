--Created using senpaizuri's Puzzle Maker (updated by Naim & Larry126)
Debug.ReloadFieldBegin(DUEL_ATTACK_FIRST_TURN+DUEL_SIMPLE_AI,5)
Debug.SetPlayerInfo(0,8000,0,0)
Debug.SetPlayerInfo(1,8000,0,0)

--Extra Deck
Debug.AddCard(100266040,0,0,LOCATION_EXTRA,0,8)
--Hand
Debug.AddCard(70368879,0,0,LOCATION_HAND,0,POS_FACEDOWN)
--Monster Zones
Debug.AddCard(100266038,0,0,LOCATION_MZONE,5,1,true)
Debug.AddCard(100266035,0,0,LOCATION_MZONE,0,1,true)
--Monster Zones
Debug.AddCard(55784832,1,1,LOCATION_MZONE,0,1,true)
--Spell & Trap Zones
Debug.AddCard(70368879,1,1,LOCATION_SZONE,2,10)
Debug.ReloadFieldEnd()
aux.BeginPuzzle()