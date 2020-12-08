--Created using senpaizuri's Puzzle Maker (updated by Naim & Larry126)
--Partially rewritten by edo9300
Debug.ReloadFieldBegin(DUEL_ATTACK_FIRST_TURN+DUEL_SIMPLE_AI,5)
Debug.SetPlayerInfo(0,8000,0,0)
Debug.SetPlayerInfo(1,8000,0,0)

--Monster Zones (yours)
Debug.AddCard(10000000,0,0,LOCATION_MZONE,2,POS_FACEUP_ATTACK,true)
Debug.AddCard(24696097,0,0,LOCATION_MZONE,6,POS_FACEUP_ATTACK,true)
Debug.AddCard(31111109,0,0,LOCATION_MZONE,5,POS_FACEUP_ATTACK,true)

--Spell & Trap Zones (yours)
Debug.AddCard(100274003,0,0,LOCATION_SZONE,2,POS_FACEDOWN)
Debug.AddCard(40605147,0,0,LOCATION_SZONE,1,POS_FACEDOWN)
Debug.AddCard(82732705,0,0,LOCATION_SZONE,3,POS_FACEDOWN)

--Monster Zones (opponent's)
Debug.AddCard(21208154,1,1,LOCATION_MZONE,2,POS_FACEUP_ATTACK,true)

Debug.AddCard(100274003,1,1,LOCATION_SZONE,2,POS_FACEDOWN)
Debug.AddCard(40605147,1,1,LOCATION_SZONE,1,POS_FACEDOWN)
Debug.AddCard(82732705,1,1,LOCATION_SZONE,3,POS_FACEDOWN)

Debug.ReloadFieldEnd()
aux.BeginPuzzle()