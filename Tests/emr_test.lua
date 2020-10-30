--Created using senpaizuri's Puzzle Maker (updated by Naim & Larry126)
--Partially rewritten by edo9300
Debug.ReloadFieldBegin(DUEL_ATTACK_FIRST_TURN+DUEL_SIMPLE_AI,5)
Debug.SetPlayerInfo(0,8000,0,0)
Debug.SetPlayerInfo(1,8000,0,0)

--Extra Deck (yours)
Debug.AddCard(56910167,0,0,LOCATION_EXTRA,0,POS_FACEDOWN)
Debug.AddCard(26096328,0,0,LOCATION_EXTRA,0,POS_FACEDOWN)

--Hand (yours)
Debug.AddCard(25789292,0,0,LOCATION_HAND,0,POS_FACEDOWN)
Debug.AddCard(51126152,0,0,LOCATION_HAND,0,POS_FACEDOWN)
Debug.AddCard(13647631,0,0,LOCATION_HAND,0,POS_FACEDOWN)

--GY (yours)
Debug.AddCard(51916853,0,0,LOCATION_GRAVE,0,POS_FACEUP)

--Spell & Trap Zones (yours)
Debug.AddCard(4178474,0,0,LOCATION_SZONE,2,POS_FACEDOWN)

--Monster Zones (opponent's)
Debug.AddCard(27125110,1,1,LOCATION_MZONE,2,POS_FACEUP_DEFENSE,true)
Debug.AddCard(27125110,1,1,LOCATION_MZONE,1,POS_FACEUP_DEFENSE,true)
Debug.AddCard(27125110,1,1,LOCATION_MZONE,3,POS_FACEUP_DEFENSE,true)

--Spell & Trap Zones (opponent's)
Debug.AddCard(59197169,1,1,LOCATION_FZONE,0,POS_FACEUP)
Debug.AddCard(69279219,1,1,LOCATION_SZONE,2,POS_FACEDOWN)
Debug.AddCard(83968380,1,1,LOCATION_SZONE,1,POS_FACEDOWN)
Debug.AddCard(29549364,1,1,LOCATION_SZONE,3,POS_FACEDOWN)

Debug.ReloadFieldEnd()
aux.BeginPuzzle()
