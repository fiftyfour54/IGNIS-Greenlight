--Created using senpaizuri's Puzzle Maker (updated by Naim & Larry126)
--Partially rewritten by edo9300
Debug.ReloadFieldBegin(DUEL_ATTACK_FIRST_TURN+DUEL_SIMPLE_AI,5)
Debug.SetPlayerInfo(0,8000,0,0)
Debug.SetPlayerInfo(1,8000,0,0)

--Hand (yours)
Debug.AddCard(45082499,0,0,LOCATION_HAND,0,POS_FACEDOWN)
Debug.AddCard(81471108,0,0,LOCATION_HAND,0,POS_FACEDOWN)
Debug.AddCard(92365601,0,0,LOCATION_HAND,0,POS_FACEDOWN)

--Monster Zones (yours)
Debug.AddCard(84013237,0,0,LOCATION_MZONE,2,POS_FACEUP_ATTACK,true)

--Extra Deck (yours)
Debug.AddCard(101104104,0,0,LOCATION_EXTRA,0,POS_FACEDOWN)


Debug.ReloadFieldEnd()
aux.BeginPuzzle()
