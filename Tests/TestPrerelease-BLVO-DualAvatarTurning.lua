--Created using senpaizuri's Puzzle Maker (updated by Naim & Larry126)
--Partially rewritten by edo9300
Debug.ReloadFieldBegin(DUEL_ATTACK_FIRST_TURN+DUEL_SIMPLE_AI,5)
Debug.SetPlayerInfo(0,8000,0,0)
Debug.SetPlayerInfo(1,8000,0,0)

--[[message
Used to test "Dual Avatar Turning" from BLVO.

"Tactical Exchanger" is used as a substitute for the actual card.
Should be able to activate this card if the player's monster zones are full (usual ft stuff should handle that).
Also should be able to activate if the EMZ is occupied (as the card summons from extra deck as well).
]]

--Main Deck (yours)
Debug.AddCard(13764602,0,0,LOCATION_DECK,0,POS_FACEDOWN)
Debug.AddCard(11759079,0,0,LOCATION_DECK,0,POS_FACEDOWN)
Debug.AddCard(85360035,0,0,LOCATION_DECK,0,POS_FACEDOWN)
Debug.AddCard(87669904,0,0,LOCATION_DECK,0,POS_FACEDOWN)
Debug.AddCard(68464358,0,0,LOCATION_DECK,0,POS_FACEDOWN)

Debug.AddCard(85360035,0,0,LOCATION_MZONE,3,POS_FACEUP_ATTACK,true)

--Extra Deck (yours)
Debug.AddCard(60237530,0,0,LOCATION_EXTRA,0,POS_FACEDOWN)
Debug.AddCard(101103041,0,0,LOCATION_EXTRA,0,POS_FACEDOWN)
Debug.AddCard(33026283,0,0,LOCATION_EXTRA,0,POS_FACEDOWN)
Debug.AddCard(7631534,0,0,LOCATION_EXTRA,0,POS_FACEDOWN)

--Hand (yours)
Debug.AddCard(11759079,0,0,LOCATION_HAND,0,POS_FACEDOWN)
Debug.AddCard(87669904,0,0,LOCATION_HAND,0,POS_FACEDOWN)
Debug.AddCard(85360035,0,0,LOCATION_HAND,0,POS_FACEDOWN)
Debug.AddCard(11759079,0,0,LOCATION_HAND,0,POS_FACEDOWN)

--GY (yours)
Debug.AddCard(58421530,0,0,LOCATION_GRAVE,0,POS_FACEUP)

--Spell & Trap Zones (yours)
Debug.AddCard(13764602,0,0,LOCATION_FZONE,0,POS_FACEDOWN)
Debug.AddCard(83764718,0,0,LOCATION_SZONE,1,POS_FACEDOWN)
Debug.AddCard(58421530,0,0,LOCATION_SZONE,3,POS_FACEDOWN)

--Monster Zones (opponent's)
Debug.AddCard(20721928,1,1,LOCATION_MZONE,3,POS_FACEUP_ATTACK,true)

Debug.ReloadFieldEnd()
aux.BeginPuzzle()