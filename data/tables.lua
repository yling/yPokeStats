-- Sources : 
-- Gen 1 Data Structure : https://bulbapedia.bulbagarden.net/wiki/Pok%C3%A9mon_data_structure_(Generation_I)
-- Gen 1 RAM map : http://datacrystal.romhacking.net/wiki/Pok%C3%A9mon_Red/Blue:RAM_map
-- Gen 2 Data Structure : https://bulbapedia.bulbagarden.net/wiki/Pok%C3%A9mon_data_structure_(Generation_II)
-- Gen 2 RAM map : http://datacrystal.romhacking.net/wiki/Pok%C3%A9mon_Red/Blue:RAM_map
-- GBC cartridge header : https://gbdev.gg8.se/wiki/articles/The_Cartridge_Header
-- Gen 2 Ram Stucture : http://datacrystal.romhacking.net/wiki/Pok%C3%A9mon_Crystal:RAM_map
-- Gen 3 RNG & Data structure : https://bulbapedia.bulbagarden.net/wiki/Pok%C3%A9mon_data_structure_(Generation_III)
-- Gen 4 RNG & Data structure : https://projectpokemon.org/home/docs/gen-4/pkm-structure-r65/
-- GBA format header : https://problemkaputt.de/gbatek.htm#gbacartridges
-- Gen 5 RNG & Data structure : https://projectpokemon.org/home/docs/gen-5/bw-save-structure-r60/
-- NDS format header : https://dsibrew.org/wiki/DSi_Cartridge_Header
-- Types colors : http://www.pokemonaaah.net/artsyfartsy/colordex/
-- Data for the data tables : https://bulbapedia.bulbagarden.net (various pages)

table,games={},{}

table["items"]={}
dofile "data/gen1data.lua" -- Gen 1 Pokemon ID and items
dofile "data/gen2data.lua" -- Gen 2 items
dofile "data/gen3data.lua" -- Gen 3 Pokemon ID and abilities
dofile "data/gen4data.lua" -- Gen 4 Items ID
dofile "data/gen5data.lua" -- Gen 5 Items ID
dofile "data/gamesdata.lua" -- Games titles and memory adresses
dofile "data/pokemondata.lua" -- Pokemon names, abilities, moves

-- Consoles resolutions by gen (to display things right on every game)
table["consoles"]={{160,144},{240,160},{256,192}}

-- Things to display (only has a cosmetic effect but might produce overlapping text if changed)
table["labels"]={"HP","AT","DF","SA","SD","SP"} -- Stats labels (Keep in the same order)
table["contests"]={"CO","BE","CU","SM","TH","FE"} -- Contest stats labels (Keep in the same order)
table["colors"]={"#ff0000","#f08030","#f8d030","#6890f0","#78c850","#f85888"} -- Stats colors (Keep in the same order)
table["typecolor"]={"#CB5F48","#7DA6DE","#B468B7","#CC9F4F","#B2A061","#94BC4A","#846AB6","#89A1B0","#EA7A3C","#539AE2","#71C558","#E5C531","#E5709B","#70CBD4","#6A7BAF","#736C75"} -- Types colors (Keep in the same order)
table["modes"]={"IVs", "EVs", "Stats", "Cont."} -- Modes names (Keep in the same order)
table["nature"]={"Hardy","Lonely","Brave","Adamant","Naughty","Bold","Docile","Relaxed","Impish","Lax","Timid","Hasty","Serious","Jolly","Naive","Modest","Mild","Quiet","Bashful","Rash","Calm","Gentle","Sassy","Careful","Quirky"} -- Natures names (Keep in the same order)
table["type"]={"Fighting","Flying","Poison","Ground","Rock","Bug","Ghost","Steel","Fire","Water","Grass","Electric","Psychic","Ice","Dragon","Dark"} -- Types names (Keep in the same order)

-- Data used for calculation - modifying it will break everything (but you can still do it if you want)
table["modesorder"]={"iv","ev","stats","contest"}
table["statsorder"]={1,2,3,6,4,5}
table["growth"]={1,1,1,1,1,1, 2,2,3,4,3,4, 2,2,3,4,3,4, 2,2,3,4,3,4}
table["attack"]={2,2,3,4,3,4, 1,1,1,1,1,1, 3,4,2,2,4,3, 3,4,2,2,4,3}
table["effort"]={3,4,2,2,4,3, 3,4,2,2,4,3, 1,1,1,1,1,1, 4,3,4,3,2,2}
table["misc"]  ={4,3,4,3,2,2, 4,3,4,3,2,2, 4,3,4,3,2,2, 1,1,1,1,1,1}

