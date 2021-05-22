# yPokeStats
## Unified Pokemon Stats & RNG tool
yPokeStats is a LUA script that can display a lot of information about Pokemon games.

### What it can do
* Display IVs, EVs, Stats and Contest Stats
* Display Nature
* Display Hidden Power
* Display Held Item
* Display Pokerus Status
* Display Frames Count (Emerald even displays frame count as reported by the game)
* Display Friendship 
* Display Ability
* Display TID / SID
* Display moves and PP

### Supported games
It natively supports all gen 3, 4 and 5 games:
* Pokemon Ruby / Sapphire
* Pokemon Emerald (and french hackrom Emeraude Plus)
* Pokemon Fire Red / Leaf Green
* Pokemon Diamond / Pearl
* Pokemon Platinum
* Pokemon Heart Gold / Soul Silver
* Pokemon Black / White
* Pokemon Black 2 / White 2

### How does it work ?
It fetches the GAME TITLE from the rom header to identify the current game. Then it reads and decrypts the data to be displayed by the script.
It uses several data tables to convert numeric IDs (for Pokemon, Items, Abilities) to their actual name.
The information about IDs and how pokemon data is stored and encrypted comes from several sources:
* Gen 3 RNG & Data structure : https://bulbapedia.bulbagarden.net/wiki/Pok%C3%A9mon_data_structure_(Generation_III)
* Gen 4 RNG & Data structure : https://projectpokemon.org/home/docs/gen-4/pkm-structure-r65/
* NDS format header : https://dsibrew.org/wiki/DSi_Cartridge_Header
* Types colors : http://www.pokemonaaah.net/artsyfartsy/colordex/
* Data for the data tables : https://bulbapedia.bulbagarden.net (various pages

To make this script, I started by reading other people's code. Here are the scripts I used :
* Gen 3 : https://github.com/red-the-dev/gen3-pokemonstatsdisplay
* Gen 4,5 : https://github.com/dude22072/PokeStats/blob/master/LUA%20scripts/

I hope you'll find my code cleaner, if not, please share your thoughts on how to improve.