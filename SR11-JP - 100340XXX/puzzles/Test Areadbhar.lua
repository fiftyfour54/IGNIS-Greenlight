--Created using senpaizuri's Puzzle Maker (updated by Naim & Larry126)
Debug.ReloadFieldBegin(DUEL_ATTACK_FIRST_TURN+DUEL_SIMPLE_AI,5)
Debug.SetPlayerInfo(0,8000,0,0)
Debug.SetPlayerInfo(1,8000,0,0)

--Extra Deck
Debug.AddCard(100340051,0,0,LOCATION_EXTRA,0,8)
--Monster Zones
Debug.AddCard(59755122,0,0,LOCATION_MZONE,1,4,true)
Debug.AddCard(44508094,0,0,LOCATION_MZONE,2,4,true)
Debug.AddCard(11012154,0,0,LOCATION_MZONE,0,4,true)
--Spell & Trap Zones
Debug.AddCard(83968380,0,0,LOCATION_SZONE,1,10)
Debug.AddCard(83968380,0,0,LOCATION_SZONE,2,10)
Debug.AddCard(83968380,0,0,LOCATION_SZONE,3,10)
Debug.AddCard(83968380,0,0,LOCATION_SZONE,4,10)
--Monster Zones
Debug.AddCard(97300502,1,1,LOCATION_MZONE,0,1,true)
Debug.AddCard(55784832,1,1,LOCATION_MZONE,2,1,true)
--Spell & Trap Zones
Debug.AddCard(83968380,1,1,LOCATION_SZONE,1,10)
Debug.AddCard(83968380,1,1,LOCATION_SZONE,2,10)
Debug.AddCard(83968380,1,1,LOCATION_SZONE,3,10)
Debug.AddCard(83968380,1,1,LOCATION_SZONE,4,10)
Debug.ReloadFieldEnd()
aux.BeginPuzzle()