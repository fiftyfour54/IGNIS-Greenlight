--Created using senpaizuri's Puzzle Maker (updated by Naim & Larry126)
--Partially rewritten by edo9300
Debug.ReloadFieldBegin(DUEL_ATTACK_FIRST_TURN+DUEL_SIMPLE_AI,5)
Debug.SetPlayerInfo(0,8000,0,0)
Debug.SetPlayerInfo(1,8000,0,0)

--Hand (yours)
Debug.AddCard(5318639,0,0,LOCATION_HAND,0,POS_FACEDOWN)

--Spell & Trap Zones (yours)
Debug.AddCard(160002050,0,0,LOCATION_SZONE,1,POS_FACEDOWN)
Debug.AddCard(160002050,0,0,LOCATION_SZONE,4,POS_FACEDOWN)
Debug.AddCard(79766336,0,0,LOCATION_SZONE,2,POS_FACEDOWN)
Debug.AddCard(79766336,0,0,LOCATION_SZONE,3,POS_FACEDOWN)
Debug.AddCard(48712195,0,0,LOCATION_SZONE,0,POS_FACEUP)

--Spell & Trap Zones (opponent's)
Debug.AddCard(5318639,1,1,LOCATION_SZONE,3,POS_FACEDOWN)

Debug.ReloadFieldEnd()
aux.BeginPuzzle()