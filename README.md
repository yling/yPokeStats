# yPokeStats
## Unified Pokemon Stats & RNG tool
yPokeStats is a LUA script that can display a lot of information about Pokemon games.

### What it can display
* IVs, EVs, Stats and Contest Stats
* Nature
* Hidden Power
* Held Item
* Pokerus Status
* Frames Count (Emerald even displays frame count as reported by the game)
* Friendship 
* Ability
* TID / SID
* Moves and PP
* Shiny check for Gen 1 & 2

### Supported games
It natively supports all gen 1, 2, 3, 4 and 5 games:
* Pokemon Red/Blue/Green (US, JAP, ES, IT, DE, FR)
* Pokemon Yellow (US, JAP, ES, IT, DE, FR)
* Pokemon Silver/Gold (US, JAP, ES, IT, DE, FR)
* Pokemon Crystal (US, JAP, ES, IT, DE, FR)
* Pokemon Ruby / Sapphire
* Pokemon Emerald (and french hackrom Emeraude Plus)
* Pokemon Fire Red / Leaf Green
* Pokemon Diamond / Pearl
* Pokemon Platinum
* Pokemon Heart Gold / Soul Silver
* Pokemon Black / White
* Pokemon Black 2 / White 2

![Red](/screens/1_red.png)
![Silver More](/screens/2_silver_more.png)
![Emerald Help Menu](/screens/3_emerald_help.png)
![Emerald Enemy](/screens/3_emerald_fight.png)
![Emerald Enemy More](/screens/3_emerald_fight_more.png)
![Fire Red Enemy More](/screens/3_firered_fight_more.png)
![Platinum Enemy More](/screens/4_platinum_fight_more.png)
![Black Help Menu](/screens/5_black_help.png)
![Black More](/screens/5_black_more.png)

### How does it work ?
It fetches the GAME TITLE from the rom header to identify the current game. Then it reads and decrypts the data to be displayed by the script.
It uses several data tables to convert numeric IDs (for Pokemon, Items, Abilities) to their actual name.
The information about IDs and how pokemon data is stored and encrypted comes from several sources:
* Gen 1 Data Structure : https://bulbapedia.bulbagarden.net/wiki/Pok%C3%A9mon_data_structure_(Generation_I)
* Gen 1 RAM map : http://datacrystal.romhacking.net/wiki/Pok%C3%A9mon_Red/Blue:RAM_map
* Gen 2 Data Structure : https://bulbapedia.bulbagarden.net/wiki/Pok%C3%A9mon_data_structure_(Generation_II)
* Gen 2 RAM map : http://datacrystal.romhacking.net/wiki/Pok%C3%A9mon_Red/Blue:RAM_map
* GBC cartridge header : https://gbdev.gg8.se/wiki/articles/The_Cartridge_Header
* Gen 2 Ram Stucture : http://datacrystal.romhacking.net/wiki/Pok%C3%A9mon_Crystal:RAM_map
* Gen 3 RNG & Data structure : https://bulbapedia.bulbagarden.net/wiki/Pok%C3%A9mon_data_structure_(Generation_III)
* Gen 4 RNG & Data structure : https://projectpokemon.org/home/docs/gen-4/pkm-structure-r65/
* NDS format header : https://dsibrew.org/wiki/DSi_Cartridge_Header
* Types colors : http://www.pokemonaaah.net/artsyfartsy/colordex/
* Data for the data tables : https://bulbapedia.bulbagarden.net (various pages

To make this script, I started by reading other people's code. Here are the scripts I used :
* Gen 3 : https://github.com/red-the-dev/gen3-pokemonstatsdisplay
* Gen 4,5 : https://github.com/dude22072/PokeStats/blob/master/LUA%20scripts/

### It doesn't work !
First, be sure to have all files (ylingstats.lua and the data folder).
Then if you do, please tell me which game and region you are using so that I can check and add it.

I hope you'll find my code cleaner, if not, please share your thoughts on how to improve.

## TODO
* Make a Python interpreter for 6th and 7th gens