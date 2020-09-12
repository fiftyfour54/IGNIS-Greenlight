--Created using senpaizuri's Puzzle Maker (updated by Naim & Larry126)
--Partially rewritten by edo9300
Debug.ReloadFieldBegin(DUEL_ATTACK_FIRST_TURN+DUEL_SIMPLE_AI,5)
Debug.SetPlayerInfo(0,8000,0,0)
Debug.SetPlayerInfo(1,8000,0,0)

--Hand (yours)
Debug.AddCard(100340002,0,0,LOCATION_DECK,0,POS_FACEDOWN)
--[[
Debug.AddCard(100340002,0,0,LOCATION_HAND,0,POS_FACEDOWN)
Debug.AddCard(100340002,0,0,LOCATION_HAND,0,POS_FACEDOWN)
Debug.AddCard(55737443,0,0,LOCATION_HAND,0,POS_FACEDOWN)
]]
--GY (yours)
Debug.AddCard(100340002,0,0,LOCATION_GRAVE,0,POS_FACEUP)
Debug.AddCard(100340002,0,0,LOCATION_GRAVE,0,POS_FACEUP)

--Monster Zones (yours)
Debug.AddCard(50321796,0,0,LOCATION_MZONE,1,POS_FACEUP_ATTACK,true)
Debug.AddCard(50032342,0,0,LOCATION_MZONE,2,POS_FACEUP_ATTACK,true)

--Monster Zones (opponent's)
Debug.AddCard(84388461,1,1,LOCATION_MZONE,3,POS_FACEUP_DEFENSE,true)
Debug.AddCard(27134689,1,1,LOCATION_MZONE,2,POS_FACEUP_DEFENSE,true)

--Spell & Trap Zones (opponent's)
Debug.AddCard(17626381,1,1,LOCATION_SZONE,4,POS_FACEUP)
Debug.AddCard(17626381,1,1,LOCATION_SZONE,3,POS_FACEUP)

Debug.ReloadFieldEnd()
aux.BeginPuzzle()