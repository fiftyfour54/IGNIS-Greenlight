--Created using senpaizuri's Puzzle Maker (updated by Naim & Larry126)
Debug.ReloadFieldBegin(DUEL_ATTACK_FIRST_TURN+DUEL_SIMPLE_AI,5)
Debug.SetPlayerInfo(0,8000,0,0)
Debug.SetPlayerInfo(1,8000,0,0)

--Main Deck
Debug.AddCard(68881649,0,0,LOCATION_DECK,0,POS_FACEDOWN)
--Hand
Debug.AddCard(100200183,0,0,LOCATION_HAND,0,POS_FACEDOWN)
Debug.AddCard(21390858,0,0,LOCATION_HAND,0,POS_FACEDOWN)
--Monster Zones
Debug.AddCard(83293307,0,0,LOCATION_MZONE,0,8,true)
Debug.ReloadFieldEnd()
