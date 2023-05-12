# Greenlight
For cards and scripts to be tested before upload


## Guidelines for passcodes

Announced OCG/TCG cards receive a nine-digit prerelease passcode until they are
released as official product, when the official passcode is used. Speed Duel has
[its own policy](https://github.com/ProjectIgnis/CardScripts/wiki/Skill-Documentation#cdb-handling)
with the `30ZYYYXXX` range and Rush Duel has its own policy in the `160ZYYXXX` range.

- `XXX` is the card index within its set
- `Y` or `YY` is the set index, incremented by one for each chronological set of that product type
	- For Structure Decks, `YY` comes from the prefix, e.g. SD38, ST18, SR10
	- For Structure Deck Enhancement Packs, they share `YY` with the Deck and add 50 to `XXX`
	- For Deck Build Packs, `YY` counts up from the previous one
	- For Duelist Packs, `YY` comes the prefix
	- TODO: there is potential overlap with this above scheme, to be eventually reworked
- Main set: `10ZZYYXXX`
	- Series `ZZ`: currently 11
- Side set: `1002YYXXX`
	- All VJMP-JP (V Jump) promos are considered part of set 200
	- All WJMP-JP (Weekly Shounen Jump) promos are considered part of set 203
	- All SJMP-JP (Saikyou Jump) promos are considered part of set 204
- Structure Deck and Starter Deck: `1003YYXXX`
- Deck Build Pack and Duelist Pack: `1004YYXXX`
- Rush Duel sets: `160ZYYXXX`
	- `Z` product type
	- 0: KP Deck Modification Pack "main booster"
	- 2: CP Character Pack "side booster"
	- 3: ST Starter Deck
	- 4: Promos

Unofficial cards fall under numerous ranges due to historical reasons but are
slowly being reworked and reorganized to the `511YYYXXX` range.

Cards with passcodes aliased to a passcode within 10 are treated as alternate
artworks.

### Upcoming sets

Release date | Set | Prefix | Prerelease passcode
--- | --- | --- | ---
14-Jan-2023 | [Cyberstorm Access][CYAC]                                | CYAC-JP    | 101112XXX
22-Apr-2023 | [Duelist Nexus][DUNE]                                    | DUNE-JP    | 101201XXX
10-Jun-2023 | [Animation Chronicle 2023][ACO03]                        | ACO03-JP   | 100299XXX
22-Jul-2023 | [Structure Deck: Pulse of the King][SD46-JP]             | SD46-JP    | 100346XXX
22-Jul-2023 | [Age of Overlord][AGOV]                                  | AGOV-JP    | 101202XXX
13-May-2023 | [Oblivion of the Flash][RD/KP13-JP]                      | RD/KP13-JP | 160013XXX
??-???-???? | [Saikyō Jump Promos][RD/KP13-JP]                         | SJMP-JP    | 160402XXX

[AGOV]: https://yugipedia.com/wiki/Age_of_Overlord
[DUNE]: https://yugipedia.com/wiki/Duelist_Nexus
[ACO03]: https://yugipedia.com/wiki/Animation_Chronicle_2023
[SD46-JP]: https://yugipedia.com/wiki/Structure_Deck:_Pulse_of_the_King
[CYAC]: https://yugipedia.com/wiki/Cyberstorm_Access
[RD/KP13-JP]: https://yugipedia.com/wiki/Oblivion_of_the_Flash
[SJMP-JP]: https://yugipedia.com/wiki/Saikyō_Jump_promotional_cards
