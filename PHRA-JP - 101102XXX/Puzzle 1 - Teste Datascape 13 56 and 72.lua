--Created using senpaizuri's Puzzle Maker (updated by Naim & Larry126)
--Partially rewritten by edo9300
Debug.ReloadFieldBegin(DUEL_ATTACK_FIRST_TURN+DUEL_SIMPLE_AI,5)
Debug.SetPlayerInfo(0,8000,0,0)
Debug.SetPlayerInfo(1,8000,0,0)

--Main Deck (yours)
Debug.AddCard(8736823,0,0,LOCATION_DECK,0,POS_FACEDOWN)
Debug.AddCard(101102013,0,0,LOCATION_DECK,0,POS_FACEDOWN)
Debug.AddCard(101102056,0,0,LOCATION_DECK,0,POS_FACEDOWN)
Debug.AddCard(101102072,0,0,LOCATION_DECK,0,POS_FACEDOWN)

--GY (yours)
Debug.AddCard(8736823,0,0,LOCATION_GRAVE,0,POS_FACEUP)
Debug.AddCard(101102072,0,0,LOCATION_GRAVE,0,POS_FACEUP)
Debug.AddCard(101102056,0,0,LOCATION_GRAVE,0,POS_FACEUP)
Debug.AddCard(101102013,0,0,LOCATION_HAND,0,POS_FACEUP)

--Banished (yours)
Debug.AddCard(8736823,0,0,LOCATION_REMOVED,0,POS_FACEUP)
Debug.AddCard(35252119,0,0,LOCATION_REMOVED,1,POS_FACEDOWN)
Debug.AddCard(35252119,0,0,LOCATION_REMOVED,2,POS_FACEUP)
Debug.AddCard(61641818,0,0,LOCATION_REMOVED,3,POS_FACEUP)

--Monster Zones (yours)
Debug.AddCard(35252119,0,0,LOCATION_MZONE,3,POS_FACEUP_DEFENSE)
Debug.AddCard(61641818,0,0,LOCATION_MZONE,4,POS_FACEUP_DEFENSE)
Debug.AddCard(55885348,0,0,LOCATION_MZONE,2,POS_FACEUP_DEFENSE)

--Spell & Trap Zones (yours)
Debug.AddCard(101102072,0,0,LOCATION_SZONE,1,POS_FACEDOWN)
Debug.AddCard(101102056,0,0,LOCATION_SZONE,2,POS_FACEDOWN)

--Monster Zones (opponent's)
Debug.AddCard(55885348,1,1,LOCATION_MZONE,3,POS_FACEUP_ATTACK)

--Spell & Trap Zones (opponent's)
Debug.AddCard(17626381,1,1,LOCATION_SZONE,2,POS_FACEDOWN)
Debug.AddCard(17626381,1,1,LOCATION_SZONE,4,POS_FACEUP)

Debug.ReloadFieldEnd()
