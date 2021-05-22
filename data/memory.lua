-- Functions and variables definition
function bts(bytes,l) -- Bytes array to string
    local name = ""
    for i=1,l do
		nchar = bytes[i]==0 and "" or string.char(bytes[i])
        name = name..nchar
    end
    return name
end

function numTruncate(x,n) -- Truncate to n decimals
	local o=math.pow(10,n)
	local y=math.floor(x*o)
	return y/o
end

function getGameInfo() -- Reads game memory to determine which game is running
    local version, lan, gen, sel
    if string.find(bts(memory.readbyterange(0x080000A0, 12),12), "POKEMON") or string.find(bts(memory.readbyterange(0x080000A0, 12),12), "PKMN") then
        version = bts(memory.readbyterange(0x080000A0, 12),12)
        lan = string.char(memory.readbyte(0x080000AF))
        gen = 3
        sel = table["consoles"][1]
    elseif string.find(bts(memory.readbyterange(0x023FF000,12),12), "POKEMON") then
        version = bts(memory.readbyterange(0x023FF000,12),12)
        lan = string.char(memory.readbyte(0x023FFE0F))
        gamecode = bts(memory.readbyterange(0x023FF000+0xA8C,4),4) -- Or E0C ?
        gen = 4
        sel = table["consoles"][2]
    elseif string.find(bts(memory.readbyterange(0x023FFE00,12),12), "POKEMON") then
        version = bts(memory.readbyterange(0x023FFE00,12),12)
        lan = string.char(memory.readbyte(0x023FFE0F))
        gamecode = bts(memory.readbyterange(0x023FFE00+0xA8C,4),4) -- Or E0C ?
        gen = 5
        sel = table["consoles"][2]
    else	
        version = 0
        lan = 0
        gen = 0
        sel = table["consoles"][1]
    end
	-- I think all PAL regions use the same adresses. Here's the dirt hack to make them all work
	if lan == "D" or lan == "H" or lan == "I" or lan =="S" or lan == "X" or lan == "Y" or lan == "Z" then
		lan = "F"
	end
	local gamedata = {version, lan, gen, sel}
	return gamedata
end

function statusChange(input) -- Manages modes change through key presses
    if input[settings["key"][1]] and not prev[settings["key"][1]] then 
        if mode < 4 then mode=mode+1 else mode=1 end
    end
    if input[settings["key"][2]] and not prev[settings["key"][2]] then 
        if status==1 then status = 2 else status = 1 end
    end
    if input[settings["key"][3]] and not prev[settings["key"][3]] then
        if substatus[status] < 6 then substatus[status] = substatus[status]+1 else substatus[status]=1 end
    end
    if input[settings["key"][4]] and not prev[settings["key"][4]] then 
		help = 0
        more = more == 1 and 0 or 1
    end
	if input[settings["key"][5]] and not prev[settings["key"][5]] then
		more = 0
		help = help == 1 and 0 or 1
	end
	if input["Y"] and not prev["Y"] then
		more = 0
		help = 0
		status = 1
		substatus = {1,1,1}
		yling = yling == 1 and 0 or 1
	end
    prev=input
end

function checkLast(pid,checksum,start,gen) -- Compares pid and checksum with current pid and checksum
	local mdword=memory.readdwordunsigned
	local mword=memory.readwordunsigned
	
	local lastpid = pid
	local lastchecksum = checksum
	local currentpid = mdword(start)
	local currentchecksum = gen == 3 and mdword(start+6) or mword(start+6)
	
	if lastpid == currentpid and lastchecksum == currentchecksum then
		return 1
	else
		return 0
		
	end
end

function fetchPokemon(start) -- Fetches Pokemon info from memory and returns a table with all the data
    local mdword=memory.readdwordunsigned 
    local mword=memory.readwordunsigned
    local mbyte=memory.readbyteunsigned
	local mbyterange=memory.readbyterangeunsigned
    local bnd,br,bxr=bit.band,bit.bor,bit.bxor
    local rshift, lshift=bit.rshift, bit.lshift
    local prng
    
    function getbits(a,b,d) -- Get bits (kinda obvious right ?)
        return rshift(a,b)%lshift(1,d)
    end
    
    function mult32(a,b) -- 32 bits multiplication
        local c=rshift(a,16)
        local d=a%0x10000
        local e=rshift(b,16)
        local f=b%0x10000
        local g=(c*f+d*e)%0x10000
        local h=d*f
        local i=g*0x10000+h
        return i
    end
	
	function gettop(a) -- Rshift for data decryption
		return(rshift(a,16))
	end
    
    if gen == 3 then -- Routine for Gen 3
		local pokemon={}

			pokemon["pid"] = mdword(start)
			pokemon["TID"] = mdword(start+4)
			pokemon["checksum"] = mdword(start+6)
			magicword=bxr(pokemon["pid"], pokemon["TID"])
			i=pokemon["pid"]%24
			
			pokemon["offset"]={}
			pokemon["offset"]["growth"]=(table["growth"][i+1]-1)*12
			pokemon["offset"]["attack"]=(table["attack"][i+1]-1)*12
			pokemon["offset"]["effort"]=(table["effort"][i+1]-1)*12
			pokemon["offset"]["misc"]=(table["misc"][i+1]-1)*12
			pokemon["growth"]={bxr(mdword(start+32+pokemon["offset"]["growth"]),magicword),bxr(mdword(start+32+pokemon["offset"]["growth"]+4),magicword),bxr(mdword(start+32+pokemon["offset"]["growth"]+8),magicword)}
			pokemon["attack"]={bxr(mdword(start+32+pokemon["offset"]["attack"]),magicword),bxr(mdword(start+32+pokemon["offset"]["attack"]+4),magicword),bxr(mdword(start+32+pokemon["offset"]["attack"]+8),magicword)}
			pokemon["effort"]={bxr(mdword(start+32+pokemon["offset"]["effort"]),magicword),bxr(mdword(start+32+pokemon["offset"]["effort"]+4),magicword),bxr(mdword(start+32+pokemon["offset"]["effort"]+8),magicword)}
			pokemon["misc"]={bxr(mdword(start+32+pokemon["offset"]["misc"]),magicword),bxr(mdword(start+32+pokemon["offset"]["misc"]+4),magicword),bxr(mdword(start+32+pokemon["offset"]["misc"]+8),magicword)}
			pokemon["nature"]={}
			pokemon["nature"]["nature"]=pokemon["pid"]%25
			pokemon["nature"]["inc"]=math.floor(pokemon["nature"]["nature"]/5)
			pokemon["nature"]["dec"]=pokemon["nature"]["nature"]%5
			pokemon["species"] = table["gen3id"][getbits(pokemon["growth"][1],0,16)]
			pokemon["speciesname"] = table["pokemon"][pokemon["species"]]
			pokemon["helditem"]=getbits(pokemon["growth"][1],16,16)
			pokemon["OTTID"] = getbits(mdword(start+4),0,16)
			pokemon["OTSID"] = getbits(mdword(start+4),16,16)
			pokemon["xp"]=pokemon["growth"][2]
			pokemon["friendship"] = getbits(pokemon["growth"][3],8,8)
			pokemon["ability"] = getbits(pokemon["misc"][2],31,1)
			pokemon["ev"]={getbits(pokemon["effort"][1],0,8),getbits(pokemon["effort"][1],8,8),getbits(pokemon["effort"][1],16,8),getbits(pokemon["effort"][2],0,8),getbits(pokemon["effort"][2],8,8),getbits(pokemon["effort"][1],24,8)}
			pokemon["contest"]={getbits(pokemon["effort"][2],16,8),getbits(pokemon["effort"][2],24,8),getbits(pokemon["effort"][3],0,8),getbits(pokemon["effort"][3],8,8),getbits(pokemon["effort"][3],16,8),getbits(pokemon["effort"][3],24,8)}
			pokemon["move"] = {getbits(pokemon["attack"][1],0,16),getbits(pokemon["attack"][1],16,16),getbits(pokemon["attack"][2],0,16),getbits(pokemon["attack"][2],16,16)}
			pokemon["pp"] = {getbits(pokemon["attack"][3],0,8),getbits(pokemon["attack"][3],8,8),getbits(pokemon["attack"][3],16,8),getbits(pokemon["attack"][3],24,8)}
			pokemon["iv"]={getbits(pokemon["misc"][2],0,5),getbits(pokemon["misc"][2],5,5),getbits(pokemon["misc"][2],10,5),getbits(pokemon["misc"][2],20,5),getbits(pokemon["misc"][2],25,5),getbits(pokemon["misc"][2],15,5)}
			pokemon["hiddenpower"]={}
			pokemon["hiddenpower"]["type"]=math.floor(((pokemon["iv"][1]%2 + 2*(pokemon["iv"][2]%2) + 4*(pokemon["iv"][3]%2) + 8*(pokemon["iv"][4]%2) + 16*(pokemon["iv"][5]%2) + 32*(pokemon["iv"][6]%2))*15)/63)
			pokemon["hiddenpower"]["base"]=math.floor((( getbits(pokemon["iv"][1],1,1) + 2*getbits(pokemon["iv"][2],1,1) + 4*getbits(pokemon["iv"][3],1,1) + 8*getbits(pokemon["iv"][4],1,1) + 16*getbits(pokemon["iv"][5],1,1) + 32*getbits(pokemon["iv"][6],1,1))*40)/63 + 30)
			pokemon["pokerus"]=getbits(pokemon["misc"][1],0,8)
			pokemon["hp"]={}
			pokemon["hp"]["current"] = mword(start+86)
			pokemon["hp"]["max"] = mword(start+88)
			pokemon["stats"]={mword(start+88),mword(start+90),mword(start+92),mword(start+96),mword(start+98),mword(start+94)}
		return pokemon
    elseif gen >= 4 then -- Routine for gens 4 and 5
		local pokemon={}
		local decrypted={}
		
		pokemon["addr"] = start
		pokemon["pid"] = mdword(pokemon["addr"])
		pokemon["checksum"] = mword(pokemon["addr"]+6)
		pokemon["shift"] = (rshift((bnd(pokemon["pid"],0x3E000)),0xD)) % 24
		
		pokemon["nature"]={}
		pokemon["nature"]["nature"]=pokemon["pid"]%25
		pokemon["nature"]["inc"]=math.floor(pokemon["nature"]["nature"]/5)
		pokemon["nature"]["dec"]=pokemon["nature"]["nature"]%5
		
		-- Offsets
		offset={}
		offset["A"] = (table["growth"][pokemon["shift"]+1]-1) * 32
		offset["B"] = (table["attack"][pokemon["shift"]+1]-2) * 32
		offset["C"] = (table["effort"][pokemon["shift"]+1]-3) * 32
		offset["D"] = (table["misc"][pokemon["shift"]+1]-4) * 32
		
		-- PRNG is seeded with checksum then it has to be calculated every 2 bytes word
		prng = pokemon["checksum"]
		
		-- Decrypting the memory into a table
		for i=0x08, 0x86, 2 do
			prng = mult32(prng,0x41C64E6D) + 0x6073
			decrypted[i]=bxr(mword(pokemon["addr"]+i), gettop(prng))
		end
		
		-- Battle Stats
		-- Seed is PID (and the bytes aren't shuffled)
		prng = pokemon["pid"]
		-- Then we keep decrypting the memory the same way
		for i=0x88, 0xEA, 2 do
			prng = mult32(prng,0x41C64E6D) + 0x6073
			decrypted[i]=bxr(mword(pokemon["addr"]+i), gettop(prng))
		end 
		
		-- Creating a table by adding the offsets to sort the decrypted base values
		-- Block A
		pokemon["species"] = decrypted[0x08+offset["A"]]
		pokemon["speciesname"]=table["pokemon"][decrypted[0x08+offset["A"]]]
		pokemon["helditem"] = decrypted[0x0A+offset["A"]]
		pokemon["OTTID"] = decrypted[0x0C+offset["A"]]
		pokemon["OTSID"] = decrypted[0x0E+offset["A"]]
		pokemon["xp"] = decrypted[0x10+offset["A"]]
		pokemon["friendship"] = getbits(decrypted[0x14+offset["A"]],0,8)
		pokemon["ability"] = getbits(decrypted[0x14+offset["A"]],8,8)
		pokemon["markings"] = decrypted[0x16+offset["A"]]
		pokemon["language"] = decrypted[0x17+offset["A"]]
        pokemon["ev"]={getbits(decrypted[0x18+offset["A"]],0,8),getbits(decrypted[0x18+offset["A"]],8,8),getbits(decrypted[0x1A+offset["A"]],0,8),getbits(decrypted[0x1C+offset["A"]],0,8),getbits(decrypted[0x1C+offset["A"]],8,8),getbits(decrypted[0x1A+offset["A"]],8,8)}
        pokemon["contest"]={getbits(decrypted[0x1E+offset["A"]],0,8),getbits(decrypted[0x1E+offset["A"]],8,8),getbits(decrypted[0x20+offset["A"]],0,8),getbits(decrypted[0x20+offset["A"]],8,8),getbits(decrypted[0x22+offset["A"]],0,8),getbits(decrypted[0x22+offset["A"]],8,8)}
        pokemon["ribbon"]={decrypted[0x24+offset["A"]],decrypted[0x26+offset["A"]]}
		-- Block B
		pokemon["move"]={decrypted[0x28+offset["B"]],decrypted[0x2A+offset["B"]],decrypted[0x2C+offset["B"]],decrypted[0x2E+offset["B"]]}
		pokemon["pp"]={getbits(decrypted[0x30+offset["B"]],0,8),getbits(decrypted[0x30+offset["B"]],8,8),getbits(decrypted[0x32+offset["B"]],0,8),getbits(decrypted[0x32+offset["B"]],8,8)}
		pokemon["ivs"]=decrypted[0x38+offset["B"]]  + lshift(decrypted[0x3A+offset["B"]],16)
		pokemon["iv"]={getbits(pokemon["ivs"],0,5),getbits(pokemon["ivs"],5,5),getbits(pokemon["ivs"],10,5),getbits(pokemon["ivs"],20,5),getbits(pokemon["ivs"],25,5),getbits(pokemon["ivs"],15,5)}
		pokemon["stats"]={decrypted[0x90],decrypted[0x92],decrypted[0x94],decrypted[0x98],decrypted[0x9A],decrypted[0x96]}
		pokemon["pokerus"]=getbits(decrypted[0x82],0,8)
		pokemon["hp"]={}
		pokemon["hp"]["current"]=decrypted[0x8E]
		pokemon["hp"]["max"]=decrypted[0x90]
		pokemon["hiddenpower"]={}
		pokemon["hiddenpower"]["type"]=math.floor(((pokemon["iv"][1]%2 + 2*(pokemon["iv"][2]%2) + 4*(pokemon["iv"][3]%2) + 8*(pokemon["iv"][4]%2) + 16*(pokemon["iv"][5]%2) + 32*(pokemon["iv"][6]%2))*15)/63)
		pokemon["hiddenpower"]["base"]=math.floor((( getbits(pokemon["iv"][1],1,1) + 2*getbits(pokemon["iv"][2],1,1) + 4*getbits(pokemon["iv"][3],1,1) + 8*getbits(pokemon["iv"][4],1,1) + 16*getbits(pokemon["iv"][5],1,1) + 32*getbits(pokemon["iv"][6],1,1))*40)/63 + 30)
		lastpid = pokemon["pid"]
		return pokemon
    end
end