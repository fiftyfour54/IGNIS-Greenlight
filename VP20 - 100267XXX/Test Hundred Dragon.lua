--Created using senpaizuri's Puzzle Maker (updated by Naim & Larry126)
Debug.ReloadFieldBegin(DUEL_ATTACK_FIRST_TURN+DUEL_SIMPLE_AI,5)
Debug.SetPlayerInfo(0,8000,0,0)
Debug.SetPlayerInfo(1,8000,0,0)

--Extra Deck
Debug.AddCard(41999284,0,0,LOCATION_EXTRA,0,8)
--Hand
Debug.AddCard(19230407,0,0,LOCATION_HAND,0,POS_FACEDOWN)
Debug.AddCard(19230407,0,0,LOCATION_HAND,0,POS_FACEDOWN)
--Monster Zones
Debug.AddCard(100200182,0,0,LOCATION_MZONE,2,1,true)
Debug.AddCard(41999284,0,0,LOCATION_MZONE,0,1,true)
Debug.AddCard(50185950,0,0,LOCATION_MZONE,1,1,true)
Debug.AddCard(100200182,0,0,LOCATION_MZONE,3,1,true)
--Monster Zones
Debug.AddCard(75878039,1,1,LOCATION_MZONE,3,1,true)
Debug.ReloadFieldEnd()
