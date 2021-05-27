-- yPokeStats 
-- by YliNG
-- v0.1
-- https://github.com/yling

dofile "data/tables.lua" -- Tables with games data, and various data - including names
dofile "data/memory.lua" -- Functions and Pokemon table generation

local gamedata = getGameInfo() -- Gets game info
version, lan, gen, sel = gamedata[1],gamedata[2],gamedata[3],gamedata[4]

settings={}
settings["pos"]={} -- Fixed blocks coordinates {x,y}{x,y}
settings["pos"][1]={2,2}
settings["pos"][2]={10,sel[2]/6}
settings["pos"][3]={2,sel[2]/64*61}
settings["key"]={	"J", -- Switch mode (EV,IV,Stats)
                    "K", -- Switch status (Enemy / player)
                    "L",  -- Sub Status + (Pokemon Slot)
                    "M", -- Toggle + display
                    "H" } -- Toggle help


print("Welcome to yPokeStats Unified ")


if version ~= 0 and games[version][lan] ~= nil then    
    print("Game :", games[version][lan][1])
    
	status, mode, help=1,1,1 -- Default status and substatus - 1,1,1 is Player's first Pokémon
	substatus={1,1,1}
	lastpid,lastchecksum=0,0 -- Will be useful to avoid re-loading the same pokemon over and over again
	count,clockcount,totalclocktime,lastclocktime,highestclocktime,yling=0,0,0,0,0,0 -- Monitoring - useless
    
    local prev={} -- Preparing the input tables - allows to check if a key has been pressed
    prev=input.get()
    
    function main() -- Main function - display (check memory.lua for calculations)
        nClock = os.clock() -- Set the clock (for performance monitoring -- useless)
        statusChange(input.get()) -- Check for key input and changes status
		
		if help==1 then -- Help screen display
			gui.box(settings["pos"][2][1]-5,settings["pos"][2][2]-5,sel[1]-5,settings["pos"][2][2]+sel[2]/2,"#ffffcc","#ffcc33")
			gui.text(settings["pos"][2][1],settings["pos"][2][2],"yPokemonStats","#ee82ee")
			gui.text(settings["pos"][2][1],settings["pos"][2][2]+sel[2]/16,"http://github.com/yling","#87cefa")
			gui.text(settings["pos"][2][1],settings["pos"][2][2]+sel[2]/16*2,"-+-+-+-+-","#ffcc33")
			gui.text(settings["pos"][2][1],settings["pos"][2][2]+sel[2]/16*3,settings["key"][1]..": IVs, EVs, Stats and Contest stats",table["colors"][5])
			gui.text(settings["pos"][2][1],settings["pos"][2][2]+sel[2]/16*4,settings["key"][2]..": Player team / Enemy team",table["colors"][4])
			gui.text(settings["pos"][2][1],settings["pos"][2][2]+sel[2]/16*5,settings["key"][3]..": Pokemon slot (1-6)",table["colors"][3])
			gui.text(settings["pos"][2][1],settings["pos"][2][2]+sel[2]/16*6,settings["key"][4]..": Show more data",table["colors"][2])
			gui.text(settings["pos"][2][1],settings["pos"][2][2]+sel[2]/16*7,settings["key"][5]..": Toggle this menu",table["colors"][1])
        end

            start = status==1 and games[version][lan][2]+games[version][lan][4]*(substatus[1]-1) or games[version][lan][3]+games[version][lan][4]*(substatus[2]-1) -- Set the pokemon start adress
			
			if memory.readdwordunsigned(start) ~= 0 or memory.readbyteunsigned(start) ~= 0 then -- If there's a PID
				if checkLast(lastpid,lastchecksum,start,gen) == 0 or pokemon["species"] == nil then -- If it's not the last loaded PID (cause you know) or if the pokemon data is empty
					pokemon = fetchPokemon(start) -- Fetch pokemon data at adress start
					count=count+1 -- Times data has been fetched from memory (for monitoring - useless)
					lastpid = gen >= 3 and pokemon["pid"] or pokemon["species"] -- Update last loaded PID
					lastchecksum = gen >= 3 and pokemon["checksum"] or pokemon["ivs"]
                end
                
                -- Permanent display --
				labels = mode == 4 and table["contests"] or table["labels"] -- Load contests labels or stats labels
				tmpcolor = status == 1 and "green" or "red" -- Dirty tmp var for status and substatus color for player of enemy
				tmpletter = status == 1 and "P" or "E" -- Dirty tmp var for status and substatus letter for player of enemy
				tmptext = tmpletter..substatus[1].." ("..table["modes"][mode]..")" -- Dirty tmp var for current mode
                helditem = pokemon["helditem"] == 0 and "none" or table["items"][gen][pokemon["helditem"]]
				
                -- GEN 1 & 2
				if gen <= 2 then
					for i=1,5 do -- For each DV
						gui.text(settings["pos"][1][1]+(i-1)*sel[1]/5,settings["pos"][1][2],table["gen1labels"][i], table["colors"][i]) -- Display label
						gui.text(settings["pos"][1][1]+sel[1]/5/4+(i-1)*sel[1]/5,settings["pos"][1][2], pokemon[table["modesorder"][mode]][i], table["colors"][i])
                        gui.text(settings["pos"][1][1]+sel[1]*4/10,settings["pos"][3][2], tmptext, tmpcolor) -- Display current status (using previously defined dirty temp vars)
						local shiny = pokemon["shiny"] == 1 and "Shiny" or "Not shiny"
						local shinycolor = pokemon["shiny"] == 1 and "green" or "red"
						gui.text(settings["pos"][1][1]+sel[1]*7/10,settings["pos"][3][2],shiny,shinycolor)

					end
                    
                -- GEN 3, 4 and 5
				else
					for i=1,6 do -- For each IV
						gui.text(settings["pos"][1][1]+(i+1)*sel[1]/8,settings["pos"][1][2],labels[i], table["colors"][i]) -- Display label
						gui.text(settings["pos"][1][1]+sel[1]/8/2+(i+1)*sel[1]/8,settings["pos"][1][2], pokemon[table["modesorder"][mode]][i], table["colors"][i]) -- Display current mode stat
						if mode ~= 4 then -- If not in contest mode
							if pokemon["nature"]["inc"]~=pokemon["nature"]["dec"] then -- If nature changes stats
								if i==table["statsorder"][pokemon["nature"]["inc"]+2] then -- If the nature increases current IV
									gui.text(settings["pos"][1][1]+sel[1]/8/2+sel[1]/8*(i+1),settings["pos"][1][2]+3, "__", "green") -- Display a green underline
									elseif i==table["statsorder"][pokemon["nature"]["dec"]+2] then -- If the nature decreases current IV
									gui.text(settings["pos"][1][1]+sel[1]/8/2+sel[1]/8*(i+1),settings["pos"][1][2]+3, "__", "red") -- Display a red underline
								end
								else -- If neutral nature
								if i==table["statsorder"][pokemon["nature"]["inc"]+1] then -- If current IV is HP
									gui.text(settings["pos"][1][1]+sel[1]/8/2+sel[1]/8*(i+1),settings["pos"][1][2]+3, "__", "grey") -- Display grey underline
								end
							end
						end
					end
                    gui.text(settings["pos"][1][1],settings["pos"][1][2], tmptext, tmpcolor) -- Display current status (using previously defined dirty temp vars)
                    gui.text(settings["pos"][1][1]+sel[1]*4/10,settings["pos"][3][2], "PID: "..bit.tohex(lastpid)) -- Last PID
				end
                
                -- All gens
				gui.text(settings["pos"][1][1], settings["pos"][1][2]+sel[2]/16, pokemon["species"]..": "..pokemon["speciesname"].." - "..pokemon["hp"]["current"].."/"..pokemon["hp"]["max"], tmpcolor) -- Pkmn National Number, Species name and HP
                frame = version == "POKEMON EMER" and "F. E/R: "..emu.framecount().."/"..memory.readdwordunsigned(0x020249C0) or "F. E: "..emu.framecount()
                gui.text(settings["pos"][3][1],settings["pos"][3][2], frame) -- Emu frame counter
				
                -- "More" menu --
				if more == 1 then
					gui.box(settings["pos"][2][1]-5,settings["pos"][2][2]-5,sel[1]-5,settings["pos"][2][2]+sel[2]/2,"#ffffcc","#ffcc33") -- Cute box 
                    -- For gen 3, 4, 5
					if gen >= 3 then 
						naturen = pokemon["nature"]["nature"] > 16 and pokemon["nature"]["nature"]-16 or pokemon["nature"]["nature"] -- Dirty trick to use types colors for natures
						naturecolor = table["typecolor"][naturen] -- Loading the tricked color
						gui.text(settings["pos"][2][1],settings["pos"][2][2], "Nature")
						gui.text(settings["pos"][2][1]+sel[2]/4,settings["pos"][2][2],table["nature"][pokemon["nature"]["nature"]+1],naturecolor)
                         -- Fetching held item name (if there's one)
						pokerus = pokemon["pokerus"] == 0 and "no" or "yes" -- Jolly little yes or no for Pokerus
						ability = gen == 3 and table["gen3ability"][pokemon["species"]][pokemon["ability"]+1] or pokemon["ability"] -- Fetching proper ability id for Gen 3
						
						gui.text(settings["pos"][2][1]+sel[1]/2,settings["pos"][2][2], "OT ID : "..pokemon["OTTID"])
						gui.text(settings["pos"][2][1]+sel[1]/2,settings["pos"][2][2]+sel[2]/16, "OT SID : "..pokemon["OTSID"])
						gui.text(settings["pos"][2][1]+sel[1]/2,settings["pos"][2][2]+2*sel[2]/16, "XP : "..pokemon["xp"])
						gui.text(settings["pos"][2][1]+sel[1]/2,settings["pos"][2][2]+3*sel[2]/16, "Item : "..helditem)
						gui.text(settings["pos"][2][1]+sel[1]/2,settings["pos"][2][2]+4*sel[2]/16, "Pokerus : "..pokerus)
						gui.text(settings["pos"][2][1]+sel[1]/2,settings["pos"][2][2]+5*sel[2]/16, "Friendship : "..pokemon["friendship"])
						gui.text(settings["pos"][2][1]+sel[1]/2,settings["pos"][2][2]+6*sel[2]/16, "Ability : "..table["ability"][ability])
                        
                    -- For gen 1 & 2
					else
                        gui.text(settings["pos"][2][1],settings["pos"][2][2], "TID: "..pokemon["TID"].." / Item: "..helditem)
						if version == "POKEMON YELL" and status == 1 and pokemon["species"] == 25 or gen == 2 then
							gui.text(settings["pos"][2][1],settings["pos"][2][2]+sel[2]/16*2, "Friendship : "..pokemon["friendship"])
						end
                    end
                    
                    -- For all gens
					gui.text(settings["pos"][2][1],settings["pos"][2][2]+sel[2]/16, "H.Power")
					gui.text(settings["pos"][2][1]+sel[2]/4,settings["pos"][2][2]+sel[2]/16, table["type"][pokemon["hiddenpower"]["type"]+1].." "..pokemon["hiddenpower"]["base"], table["typecolor"][pokemon["hiddenpower"]["type"]+1])
					gui.text(settings["pos"][2][1],settings["pos"][2][2]+3*sel[2]/16, "Moves:")
					for i=1,4 do -- For each move
						if table["move"][pokemon["move"][i]] ~= nil then 
							gui.text(settings["pos"][2][1],settings["pos"][2][2]+(i+3)*sel[2]/16, table["move"][pokemon["move"][i]].." - "..pokemon["pp"][i].."PP") -- Display name and PP
						end
					end
				end
            else -- No PID found
				if status == 1 then -- If player team just decrement n
					substatus[1] = 1
				elseif status == 2 then -- If enemy
					if substatus[2] == 1 then -- If was trying first enemy go back to player team
						status = 1
					else -- Else decrement n
						substatus[2] = 1
					end
				else -- Shouldn't happen but hey, warn me if it does
					print("Something's wrong.")
				end
				gui.text(settings["pos"][1][1],settings["pos"][1][2],"No Pokemon", "red") -- Beautiful red warning
			end
		
		-- Script performance (useless)
		clocktime = os.clock()-nClock
		clockcount = clockcount + 1
		totalclocktime = totalclocktime+clocktime
		lastclocktime = clocktime ~= 0 and clocktime or lastclocktime
		highestclocktime = clocktime > highestclocktime and clocktime or highestclocktime
		meanclocktime = totalclocktime/clockcount
		if yling==1 then -- I lied, there's a secret key to display script performance, but who cares besides me? (It's Y)
			gui.text(settings["pos"][2][1],2*settings["pos"][2][2],"Last clock time: "..numTruncate(lastclocktime*1000,2).."ms")
			gui.text(settings["pos"][2][1],2*settings["pos"][2][2]+sel[2]/16,"Mean clock time: "..numTruncate(meanclocktime*1000,2).."ms")
			gui.text(settings["pos"][2][1],2*settings["pos"][2][2]+2*sel[2]/16,"Most clock time: "..numTruncate(highestclocktime*1000,2).."ms")
			gui.text(settings["pos"][2][1],2*settings["pos"][2][2]+3*sel[2]/16,"Data fetched: "..count.."x")
        end
	end
else -- Game not in the data table
    if games[version]["E"] ~= nil then
        print("This version is supported, but not in this language. Check gamesdata.lua to add it.")
    else
        print("This game isn't supported. Is it a hackrom ? It might work but you'll have to add it yourself. Check gamesdata.lua")
    end
    print("Version: "..version)
    print("Language: "..bit.tohex(lan))
end

gui.register(main)
