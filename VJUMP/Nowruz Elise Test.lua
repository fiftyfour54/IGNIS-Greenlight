--Created using senpaizuri's Puzzle Maker (updated by Naim & Larry126)
--Partially rewritten by edo9300
Debug.ReloadFieldBegin(DUEL_ATTACK_FIRST_TURN+DUEL_SIMPLE_AI,5)
Debug.SetPlayerInfo(0,8000,0,0)
Debug.SetPlayerInfo(1,8000,0,0)

--Hand (yours)
Debug.AddCard(49881766,0,0,LOCATION_HAND,0,POS_FACEDOWN)
Debug.AddCard(26378150,0,0,LOCATION_HAND,0,POS_FACEDOWN)
Debug.AddCard(53129443,0,0,LOCATION_HAND,0,POS_FACEDOWN)
Debug.AddCard(79182538,0,0,LOCATION_HAND,0,POS_FACEDOWN)
Debug.AddCard(89631141,0,0,LOCATION_HAND,0,POS_FACEDOWN)
Debug.AddCard(47355498,0,0,LOCATION_HAND,0,POS_FACEDOWN)

--Monster Zones (yours)
Debug.AddCard(100200198,0,0,LOCATION_MZONE,0,POS_FACEUP_ATTACK,true)

--GY (yours)
Debug.AddCard(100200198,0,0,LOCATION_GRAVE,0,POS_FACEUP)
Debug.AddCard(100200198,0,0,LOCATION_GRAVE,0,POS_FACEUP)

--Monster Zones (opponent's)
Debug.AddCard(79182538,1,1,LOCATION_MZONE,3,POS_FACEUP_ATTACK,true)

--Spell & Trap Zones (opponent's)
Debug.AddCard(44095762,1,1,LOCATION_SZONE,2,POS_FACEDOWN)
Debug.AddCard(511000461,1,1,LOCATION_SZONE,3,POS_FACEDOWN)

Debug.ReloadFieldEnd()
aux.BeginPuzzle()