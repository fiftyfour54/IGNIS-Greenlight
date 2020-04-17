--Created using senpaizuri's Puzzle Maker (updated by Naim & Larry126)
Debug.ReloadFieldBegin(DUEL_ATTACK_FIRST_TURN+DUEL_SIMPLE_AI,5)
Debug.SetPlayerInfo(0,8000,0,0)
Debug.SetPlayerInfo(1,8000,0,0)

--Main Deck
Debug.AddCard(29587993,0,0,LOCATION_DECK,0,POS_FACEDOWN)
--Extra Deck
Debug.AddCard(49121795,0,0,LOCATION_EXTRA,0,8)
--Monster Zones
Debug.AddCard(20248754,0,0,LOCATION_MZONE,1,1,true)
--Spell & Trap Zones
Debug.AddCard(101012090,0,0,LOCATION_SZONE,1,10)
Debug.AddCard(101012090,0,0,LOCATION_SZONE,2,5)
Debug.AddCard(101012090,0,0,LOCATION_SZONE,3,5)
--Main Deck
Debug.AddCard(81994591,1,1,LOCATION_DECK,0,POS_FACEDOWN)
--Extra Deck
Debug.AddCard(49121795,1,1,LOCATION_EXTRA,0,8)
Debug.AddCard(49121795,1,1,LOCATION_EXTRA,0,8)
--Hand
Debug.AddCard(75878039,1,1,LOCATION_HAND,0,POS_FACEDOWN)
--Monster Zones
Debug.AddCard(21844576,1,1,LOCATION_MZONE,3,1,true)
Debug.AddCard(79979666,1,1,LOCATION_MZONE,2,1,true)
Debug.ReloadFieldEnd()
aux.BeginPuzzle()