--Created using senpaizuri's Puzzle Maker (updated by Naim & Larry126)
--Partially rewritten by edo9300
Debug.ReloadFieldBegin(DUEL_ATTACK_FIRST_TURN+DUEL_SIMPLE_AI,5)
Debug.SetPlayerInfo(0,8000,0,0)
Debug.SetPlayerInfo(1,8000,0,0)

--Main Deck (yours)
Debug.AddCard(100415001,0,0,LOCATION_DECK,0,POS_FACEDOWN)
Debug.AddCard(86120751,0,0,LOCATION_DECK,1,POS_FACEDOWN)

--Extra Deck (yours)
Debug.AddCard(100415008,0,0,LOCATION_EXTRA,0,POS_FACEDOWN)
Debug.AddCard(100415008,0,0,LOCATION_EXTRA,1,POS_FACEDOWN)

--Hand (yours)
Debug.AddCard(100415001,0,0,LOCATION_HAND,0,POS_FACEDOWN)

--Monster Zones (yours)
Debug.AddCard(67696066,0,0,LOCATION_MZONE,0,POS_FACEUP_ATTACK,true)
Debug.AddCard(46986414,0,0,LOCATION_MZONE,1,POS_FACEUP_ATTACK,true)

Debug.ReloadFieldEnd()
aux.BeginPuzzle()