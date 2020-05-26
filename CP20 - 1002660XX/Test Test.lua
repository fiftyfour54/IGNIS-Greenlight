--Created using senpaizuri's Puzzle Maker (updated by Naim & Larry126)
Debug.ReloadFieldBegin(DUEL_ATTACK_FIRST_TURN+DUEL_SIMPLE_AI,5)
Debug.SetPlayerInfo(0,8000,0,0)
Debug.SetPlayerInfo(1,8000,0,0)

--Hand
Debug.AddCard(100266044,0,0,LOCATION_HAND,0,POS_FACEDOWN)
--GY
Debug.AddCard(100266038,0,0,LOCATION_GRAVE,0,POS_FACEUP,true)
Debug.AddCard(100266040,0,0,LOCATION_GRAVE,0,POS_FACEUP,true)
Debug.AddCard(100266040,0,0,LOCATION_GRAVE,0,POS_FACEUP,true)
Debug.AddCard(100266041,0,0,LOCATION_GRAVE,0,POS_FACEUP,true)
--Monster Zones
Debug.AddCard(100266038,0,0,LOCATION_MZONE,5,1,true)
--Spell & Trap Zones
Debug.AddCard(97077563,0,0,LOCATION_SZONE,3,10)
Debug.ReloadFieldEnd()
aux.BeginPuzzle()