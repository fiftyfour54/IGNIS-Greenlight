--Created using senpaizuri's Puzzle Maker (updated by Naim & Larry126)
Debug.ReloadFieldBegin(DUEL_ATTACK_FIRST_TURN+DUEL_SIMPLE_AI,5)
Debug.SetPlayerInfo(0,8000,0,0)
Debug.SetPlayerInfo(1,8000,0,0)

--Extra Deck
Debug.AddCard(100266040,0,0,LOCATION_EXTRA,0,8)
--Hand
Debug.AddCard(100266043,0,0,LOCATION_HAND,0,POS_FACEDOWN)
Debug.AddCard(100266043,0,0,LOCATION_HAND,0,POS_FACEDOWN)
--GY
Debug.AddCard(100266038,0,0,LOCATION_GRAVE,0,POS_FACEUP)
Debug.AddCard(100266035,0,0,LOCATION_GRAVE,0,POS_FACEUP)
Debug.ReloadFieldEnd()
aux.BeginPuzzle()