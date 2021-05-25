-- This file contains the titles and memory adresses for every game.
-- You might have to modify the file if your game isn't supported.
-- However, all PAL languages should be supported. 
-- The console output should have reported the GAME TITLE and LANGUAGE if your game wasn't in this list
-- Here is the structure :

-- GAME TITLE is the game title. Look at your rom info to find it.
-- In theory, all games already have at least one language added.
--
-- LANGUAGE is the language letter - E for US, F for FR, J for Japan and all the other letters

-- If you don't know how to find the pokemon adresses, you'd better Google it. A comment in a script is not the place to learn.
-- Pro-tip : I think most EUR languages and US use the same adresses
-- 
-- games["GAME TITLE"]["LANGUAGE"][1] = Title for display
-- games["GAME TITLE"]["LANGUAGE"][2] = Player pokemon adress
-- games["GAME TITLE"]["LANGUAGE"][3] = Enemy pokemon adress
-- games["GAME TITLE"]["LANGUAGE"][4] = Offset between Pokemon

-- Here's and example you can copy and paste at the end of the file (it matters)
-- (You have to remove the "--" or it'll stay a comment
--
-- For Pokemon Ruby FR (but all PAL are treated as FR)
-- games["POKEMON RUBY"]["F"][1] = {"Pokemon Rubis (FR)", 0x03004360, 0x30045C0, 0x64}

-- This creates the arrays to hold the game data, don't change it (excepted if I forgot a game)
games["POKEMON RUBY"],games["POKEMON SAPP"],games["POKEMON EMER"],games["PKMN EMER P "],games["POKEMON FIRE"],games["POKEMON LEAF"]={},{},{},{},{},{} -- Gen 3
games["POKEMON D"],games["POKEMON P"],games["POKEMON PL"],games["POKEMON HG"],games["POKEMON SS"]={},{},{},{},{} -- Gen 4
games["POKEMON B"],games["POKEMON W"],games["POKEMON B2"],games["POKEMON W2"]={},{},{},{} -- Gen 5

-- Gen 3
games["POKEMON RUBY"]["E"]={"Pokemon Ruby (US)",0x03004360,0x30045C0,100} -- RUBY US - OK
games["POKEMON RUBY"]["F"]={"Pokemon Ruby (PAL)",0x03004370,0x30045D0,100} -- RUBY FR - OK
games["POKEMON RUBY"]["J"]={"Pokemon Ruby (JAP)",0x3004290,0x30044F0,100} -- RUBY J -- UNTESTED

games["POKEMON SAPP"]["E"]={"Pokemon Sapphire (US)",0x03004360,0x30045C0,100} -- SAPPHIRE US - OK
games["POKEMON SAPP"]["F"]={"Pokemon Sapphire (PAL)",0x03004370,0x30045D0,100} -- SAPPHIRE FR - OK
games["POKEMON SAPP"]["J"]={"Pokemon Sapphire (JAP)",0x3004290,0x30044F0,100} -- SAPPHIRE J -- UNTESTED

games["POKEMON EMER"]["E"]={"Pokemon Emerald (US)",0x20244EC,0x2024744,100} -- EMERALD US - OK
games["POKEMON EMER"]["F"]={"Pokemon Emerald (PAL)",0x20244EC,0x2024744,100} -- EMERALD FR - OK
games["PKMN EMER P "]["F"]={"Pokemon Emeraude+",0x20244EC,0x2024744,100} -- EMERAUDE PLUS - OK
games["POKEMON EMER"]["J"]={"Pokemon Emerald (JAP)",0x2024190,0x20242E8,100} -- EMERALD -- UNTESTED

games["POKEMON FIRE"]["E"]={"Pokemon Fire Red (US)",0x02024284,0x0202402C,100} -- FIRE RED US - OK
games["POKEMON FIRE"]["F"]={"Pokemon Fire Red (PAL)",0x02024284,0x0202402C,100} -- FIRE RED FR - OK
games["POKEMON FIRE"]["J"]={"Pokemon Fire Red (JAP)",0x20241E4,0x2023F8C,100} -- FIRE RED JAP - UNTESTED

games["POKEMON LEAF"]["E"]={"Pokemon Leaf Green (US)",0x02024284,0x0202402C,100} -- LEAF GREEN US - OK
games["POKEMON LEAF"]["F"]={"Pokemon Leaf Green (PAL)",0x02024284,0x0202402C,100} -- LEAF GREEN US - OK
games["POKEMON LEAF"]["J"]={"Pokemon Leaf Green (JAP)",0x20241E4,0x2023F8C,100} -- LEAF GREEN JAP - UNTESTED

-- Gen 4
games["POKEMON D"]["F"]={"Pokemon Diamond (PAL)", memory.readdword(0x0210712C) + 0xD2AC, memory.readdword(memory.readdword(0x0210712C) + 0x364C8) + 0x774, 0xEC} -- OK
games["POKEMON D"]["E"]={"Pokemon Diamond (US)", memory.readdword(0x0210712C) + 0xD2AC, memory.readdword(memory.readdword(0x0210712C) + 0x364C8) + 0x774, 0xEC} -- OK
games["POKEMON D"]["J"]={"Pokemon Diamond (JAP)", memory.readdword(0x0210712C) + 0xD2AC, memory.readdword(memory.readdword(0x0210712C) + 0x364C8) + 0x774, 0xEC} -- UNTESTED

games["POKEMON P"]["F"]={"Pokemon Pearl (PAL)", memory.readdword(0x0210712C) + 0xD2AC, memory.readdword(memory.readdword(0x0210712C) + 0x364C8) + 0x774, 0xEC}   -- OK
games["POKEMON P"]["E"]={"Pokemon Pearl (US)", memory.readdword(0x0210712C) + 0xD2AC, memory.readdword(memory.readdword(0x0210712C) + 0x364C8) + 0x774, 0xEC}   -- OK
games["POKEMON P"]["J"]={"Pokemon Pearl (JAP)", memory.readdword(0x0210712C) + 0xD2AC, memory.readdword(memory.readdword(0x0210712C) + 0x364C8) + 0x774, 0xEC}   -- UNTESTED

games["POKEMON PL"]["F"]={"Pokemon Platinum (PAL)", memory.readdword(0x02101D2C) + 0xD094, memory.readdword(memory.readdword(0x02101D2C) + 0x352F4) + 0x7A0, 0xEC} -- OK
games["POKEMON PL"]["E"]={"Pokemon Platinum (US)", memory.readdword(0x02101D2C) + 0xD094, memory.readdword(memory.readdword(0x02101D2C) + 0x352F4) + 0x7A0, 0xEC} -- OK
games["POKEMON PL"]["J"]={"Pokemon Platinum (JAP)", memory.readdword(0x02101D2C) + 0xD094, memory.readdword(memory.readdword(0x02101D2C) + 0x352F4) + 0x7A0, 0xEC} -- UNTESTED

-- Gen 5
games["POKEMON B"]["E"]={"Pokemon Black (US)", 0x02234934, 0x0226ACF4, 0xDC} -- UNTESTED
games["POKEMON B"]["J"]={"Pokemon Black (JAP)", 0x02234934, 0x0226ACF4, 0xDC} -- UNTESTED
games["POKEMON B"]["F"]={"Pokemon Black (PAL)", 0x02234934, 0x0226ACF4, 0xDC} -- OK

games["POKEMON W"]["E"]={"Pokemon White (US)", 0x02234954, 0x0226AD14, 0xDC} -- UNTESTED
games["POKEMON W"]["J"]={"Pokemon White (JAP)", 0x02234954, 0x0226AD14, 0xDC} -- UNTESTED
games["POKEMON W"]["F"]={"Pokemon White (PAL)", 0x02234954, 0x0226AD14, 0xDC} -- OK

games["POKEMON B2"]["E"]={"Pokemon Black 2 (US)", 0x0221E3EC, 0x02258834, 0xDC} -- UNTESTED
games["POKEMON B2"]["J"]={"Pokemon Black 2 (JAP)", 0x0221E3EC, 0x02258834, 0xDC} -- UNTESTED
games["POKEMON B2"]["F"]={"Pokemon Black 2 (PAL)", 0x0221E3EC, 0x02258834, 0xDC} -- OK

games["POKEMON W2"]["E"]={"Pokemon White 2 (US)", 0x0221E42C, 0x02258874, 0xDC} -- UNTESTED
games["POKEMON W2"]["J"]={"Pokemon White 2 (JAP)", 0x0221E42C, 0x02258874, 0xDC} -- UNTESTED
games["POKEMON W2"]["F"]={"Pokemon White 2 (PAL)", 0x0221E42C, 0x02258874, 0xDC} -- OK