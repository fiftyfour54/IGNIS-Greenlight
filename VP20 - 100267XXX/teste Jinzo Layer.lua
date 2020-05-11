--Created using senpaizuri's Puzzle Maker (updated by Naim & Larry126)
Debug.ReloadFieldBegin(DUEL_ATTACK_FIRST_TURN+DUEL_SIMPLE_AI,5)
Debug.SetPlayerInfo(0,8000,0,0)
Debug.SetPlayerInfo(1,8000,0,0)

--Extra Deck
Debug.AddCard(100267003,0,0,LOCATION_EXTRA,0,8)
--Monster Zones
Debug.AddCard(100267003,0,0,LOCATION_MZONE,4,1,true)
Debug.AddCard(51916032,0,0,LOCATION_MZONE,4,POS_FACEUP_ATTACK)
Debug.AddCard(9411399,0,0,LOCATION_MZONE,0,4,true)
Debug.AddCard(9411399,0,0,LOCATION_MZONE,1,1,true)
--Spell & Trap Zones
Debug.AddCard(17626381,0,0,LOCATION_SZONE,1,10)
Debug.AddCard(9064354,0,0,LOCATION_SZONE,2,10)
--Monster Zones
Debug.AddCard(55885348,1,1,LOCATION_MZONE,2,4,true)
Debug.AddCard(64280356,1,1,LOCATION_MZONE,3,8,true)
Debug.AddCard(40975574,1,1,LOCATION_MZONE,4,4,true)
Debug.AddCard(12299841,1,1,LOCATION_MZONE,1,1,true)
Debug.ReloadFieldEnd()
aux.BeginPuzzle()