--Created using senpaizuri's Puzzle Maker (updated by Naim & Larry126)
--Partially rewritten by edo9300
Debug.ReloadFieldBegin(DUEL_ATTACK_FIRST_TURN+DUEL_SIMPLE_AI,5)
Debug.SetPlayerInfo(0,8000,0,0)
Debug.SetPlayerInfo(1,8000,0,0)

--Hand (yours)
Debug.AddCard(100425035,0,0,LOCATION_HAND,0,POS_FACEDOWN)
Debug.AddCard(66719324,0,0,LOCATION_HAND,1,POS_FACEDOWN)

--Monster Zones (yours)
Debug.AddCard(10789972,0,0,LOCATION_MZONE,0,POS_FACEUP_ATTACK,true)
Debug.AddCard(3629090,0,0,LOCATION_MZONE,1,POS_FACEUP_ATTACK,true)
Debug.AddCard(27660735,0,0,LOCATION_MZONE,2,POS_FACEUP_DEFENSE,true)
Debug.AddCard(8284390,0,0,LOCATION_MZONE,3,POS_FACEUP_ATTACK,true)

--Monster Zones (opponent's)
Debug.AddCard(55885348,1,1,LOCATION_MZONE,4,POS_FACEUP_ATTACK,true)
Debug.AddCard(75878039,1,1,LOCATION_MZONE,3,POS_FACEDOWN_DEFENSE,true)
Debug.AddCard(68473226,1,1,LOCATION_MZONE,2,POS_FACEUP_DEFENSE,true)

Debug.ReloadFieldEnd()
aux.BeginPuzzle()