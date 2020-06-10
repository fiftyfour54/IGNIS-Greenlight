--Created using senpaizuri's Puzzle Maker (updated by Naim & Larry126)
Debug.ReloadFieldBegin(DUEL_ATTACK_FIRST_TURN+DUEL_SIMPLE_AI,5)
Debug.SetPlayerInfo(0,8000,0,0)
Debug.SetPlayerInfo(1,8000,0,0)

--Main Deck
Debug.AddCard(876330,0,0,LOCATION_DECK,0,POS_FACEDOWN)
Debug.AddCard(28183605,0,0,LOCATION_DECK,0,POS_FACEDOWN)
--Hand
Debug.AddCard(100340026,0,0,LOCATION_HAND,0,POS_FACEDOWN)
Debug.AddCard(53241226,0,0,LOCATION_HAND,0,POS_FACEDOWN)
Debug.AddCard(28183605,0,0,LOCATION_HAND,0,POS_FACEDOWN)
--GY
Debug.AddCard(59755122,0,0,LOCATION_GRAVE,0,POS_FACEUP)
--Monster Zones
Debug.AddCard(22091647,0,0,LOCATION_MZONE,0,1,true)
Debug.AddCard(30012506,0,0,LOCATION_MZONE,1,1,true)
--Monster Zones
Debug.AddCard(55784832,1,1,LOCATION_MZONE,2,1,true)
Debug.ReloadFieldEnd()
aux.BeginPuzzle()