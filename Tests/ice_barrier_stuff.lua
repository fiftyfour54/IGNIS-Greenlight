--Created using senpaizuri's Puzzle Maker (updated by Naim & Larry126)
--Partially rewritten by edo9300
Debug.ReloadFieldBegin(DUEL_ATTACK_FIRST_TURN+DUEL_SIMPLE_AI,5)
Debug.SetPlayerInfo(0,8000,0,0)
Debug.SetPlayerInfo(1,8000,0,0)

--Hand (yours)
Debug.AddCard(14087893,0,0,LOCATION_HAND,0,POS_FACEDOWN)
Debug.AddCard(14087893,0,0,LOCATION_HAND,0,POS_FACEDOWN)
Debug.AddCard(14087893,0,0,LOCATION_HAND,0,POS_FACEDOWN)
Debug.AddCard(14087893,0,0,LOCATION_HAND,0,POS_FACEDOWN)

--Monster Zones (yours)
Debug.AddCard(52687916,0,0,LOCATION_MZONE,2,POS_FACEUP_ATTACK,true)
Debug.AddCard(50321796,0,0,LOCATION_MZONE,1,POS_FACEUP_ATTACK,true)
Debug.AddCard(70583986,0,0,LOCATION_MZONE,3,POS_FACEUP_ATTACK,true)

--Spell & Trap Zones (yours)
Debug.AddCard(30459350,0,0,LOCATION_SZONE,1,POS_FACEDOWN)
Debug.AddCard(83968380,0,0,LOCATION_SZONE,2,POS_FACEDOWN)

--Hand (opponent's)
Debug.AddCard(19230407,1,1,LOCATION_HAND,0,POS_FACEDOWN)

--GY (opponent's)
Debug.AddCard(4035199,1,1,LOCATION_GRAVE,0,POS_FACEUP)

--Monster Zones (opponent's)
Debug.AddCard(4035199,1,1,LOCATION_MZONE,1,POS_FACEUP_ATTACK,true)
Debug.AddCard(97940434,1,1,LOCATION_MZONE,2,POS_FACEUP_ATTACK,true)

Debug.ReloadFieldEnd()
-- aux.BeginPuzzle()
