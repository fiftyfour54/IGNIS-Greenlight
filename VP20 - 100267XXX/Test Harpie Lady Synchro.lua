--Created using senpaizuri's Puzzle Maker (updated by Naim & Larry126)
Debug.ReloadFieldBegin(DUEL_ATTACK_FIRST_TURN+DUEL_SIMPLE_AI,5)
Debug.SetPlayerInfo(0,8000,0,0)
Debug.SetPlayerInfo(1,8000,0,0)

--Main Deck
Debug.AddCard(9411399,0,0,LOCATION_DECK,0,POS_FACEDOWN)
--Extra Deck
Debug.AddCard(100267002,0,0,LOCATION_EXTRA,0,8)
--Hand
Debug.AddCard(66719324,0,0,LOCATION_HAND,0,POS_FACEDOWN)
Debug.AddCard(75064463,0,0,LOCATION_HAND,0,POS_FACEDOWN)
--GY
Debug.AddCard(5133471,0,0,LOCATION_GRAVE,0,POS_FACEUP)
Debug.AddCard(9411399,0,0,LOCATION_GRAVE,0,POS_FACEUP)
--Monster Zones
Debug.AddCard(9411399,0,0,LOCATION_MZONE,0,4,true)
Debug.AddCard(40975574,0,0,LOCATION_MZONE,1,4,true)
Debug.AddCard(85696777,0,0,LOCATION_MZONE,5,1,true)
Debug.AddCard(76812113,0,0,LOCATION_MZONE,2,1,true)
Debug.AddCard(12206212,0,0,LOCATION_MZONE,3,1,true)
Debug.AddCard(76812113,0,0,LOCATION_MZONE,4,1,true)
--Monster Zones
Debug.AddCard(55885348,1,1,LOCATION_MZONE,1,1,true)
Debug.AddCard(64280356,1,1,LOCATION_MZONE,2,8,true)
--Spell & Trap Zones
Debug.AddCard(44095762,1,1,LOCATION_SZONE,3,10)
Debug.ReloadFieldEnd()
aux.BeginPuzzle()