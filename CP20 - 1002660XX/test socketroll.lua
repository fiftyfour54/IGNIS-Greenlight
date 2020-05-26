--Created using senpaizuri's Puzzle Maker (updated by Naim & Larry126)
Debug.ReloadFieldBegin(DUEL_ATTACK_FIRST_TURN+DUEL_SIMPLE_AI,5)
Debug.SetPlayerInfo(0,8000,0,0)
Debug.SetPlayerInfo(1,8000,0,0)

--Main Deck
Debug.AddCard(100266035,0,0,LOCATION_DECK,0,POS_FACEDOWN)
--Hand
Debug.AddCard(100266035,0,0,LOCATION_HAND,0,POS_FACEDOWN)
--Monster Zones
Debug.AddCard(100266035,0,0,LOCATION_MZONE,2,1,true)
--GY
Debug.AddCard(100266035,1,1,LOCATION_GRAVE,0,POS_FACEUP)
--Spell & Trap Zones
Debug.AddCard(97077563,1,1,LOCATION_SZONE,2,10)
Debug.ReloadFieldEnd()
aux.BeginPuzzle()