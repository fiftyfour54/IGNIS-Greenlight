--Created using senpaizuri's Puzzle Maker (updated by Naim & Larry126)
--Partially rewritten by edo9300
Debug.ReloadFieldBegin(DUEL_ATTACK_FIRST_TURN+DUEL_SIMPLE_AI,5)
Debug.SetPlayerInfo(0,8000,0,0)
Debug.SetPlayerInfo(1,8000,0,0)

--Hand (yours)
Debug.AddCard(100415001,0,0,LOCATION_HAND,0,POS_FACEDOWN)
Debug.AddCard(67696066,0,0,LOCATION_HAND,1,POS_FACEDOWN)
Debug.AddCard(49003308,0,0,LOCATION_HAND,2,POS_FACEDOWN)

--GY (yours)
Debug.AddCard(100415001,0,0,LOCATION_GRAVE,0,POS_FACEUP)
Debug.AddCard(100415001,0,0,LOCATION_GRAVE,1,POS_FACEUP)
Debug.AddCard(100415005,0,0,LOCATION_GRAVE,2,POS_FACEUP)

--Monster Zones (yours)
Debug.AddCard(67696066,0,0,LOCATION_MZONE,1,POS_FACEUP_DEFENSE,true)

Debug.ReloadFieldEnd()
aux.BeginPuzzle()