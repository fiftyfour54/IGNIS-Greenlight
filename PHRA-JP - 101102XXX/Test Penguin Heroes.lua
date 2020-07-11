--Created using senpaizuri's Puzzle Maker (updated by Naim & Larry126)
--Partially rewritten by edo9300
Debug.ReloadFieldBegin(DUEL_ATTACK_FIRST_TURN+DUEL_TEST_MODE,5)
Debug.SetPlayerInfo(0,8000,0,0)
Debug.SetPlayerInfo(1,8000,0,0)

--Main Deck (yours)
Debug.AddCard(93920745,0,0,LOCATION_DECK,0,POS_FACEDOWN)
Debug.AddCard(9126351,0,0,LOCATION_DECK,1,POS_FACEDOWN)

--Extra Deck (yours)
Debug.AddCard(101102039,0,0,LOCATION_EXTRA,0,POS_FACEDOWN)

--Monster Zones (yours)
Debug.AddCard(9126351,0,0,LOCATION_MZONE,3,POS_FACEDOWN_DEFENSE,true)
Debug.AddCard(2792265,0,0,LOCATION_MZONE,4,POS_FACEDOWN_DEFENSE,true)
Debug.AddCard(79169622,0,0,LOCATION_MZONE,0,POS_FACEUP_ATTACK,true)
Debug.AddCard(48531733,0,0,LOCATION_MZONE,1,POS_FACEUP_ATTACK,true)

--Hand (opponent's)
Debug.AddCard(14558127,1,1,LOCATION_HAND,0,POS_FACEDOWN)

--Spell & Trap Zones (opponent's)
Debug.AddCard(4178474,1,1,LOCATION_SZONE,1,POS_FACEDOWN)

Debug.ReloadFieldEnd()
aux.BeginPuzzle()