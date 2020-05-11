--Created using senpaizuri's Puzzle Maker (updated by Naim & Larry126)
Debug.ReloadFieldBegin(DUEL_ATTACK_FIRST_TURN+DUEL_SIMPLE_AI,5)
Debug.SetPlayerInfo(0,8000,0,0)
Debug.SetPlayerInfo(1,8000,0,0)

--Extra Deck
Debug.AddCard(100267001,0,0,LOCATION_EXTRA,0,8)
--Hand
Debug.AddCard(24094653,0,0,LOCATION_HAND,0,POS_FACEDOWN)
Debug.AddCard(79109599,0,0,LOCATION_HAND,0,POS_FACEDOWN)
--Monster Zones
Debug.AddCard(100267001,0,0,LOCATION_MZONE,5,1,true)
Debug.AddCard(71625222,0,0,LOCATION_MZONE,0,1,true)
Debug.AddCard(75878039,0,0,LOCATION_MZONE,4,4,true)
Debug.AddCard(77994337,0,0,LOCATION_MZONE,3,8,true)
Debug.AddCard(24550676,0,0,LOCATION_MZONE,1,4,true)
--Monster Zones
Debug.AddCard(30270176,1,1,LOCATION_MZONE,2,1,true)
Debug.AddCard(15610297,1,1,LOCATION_MZONE,3,4,true)
Debug.ReloadFieldEnd()
aux.BeginPuzzle()