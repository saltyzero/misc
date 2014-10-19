-- request by Vitrex
-- Script by Rochet2 of EmuDevs
-- Updated by slp13at420 of EmuDevs
-- drunken slurred outbursts by Bender
-- to make it fire only when activly moving players are close enough to trigger event 27 remove the two lines marcked Constant.

local npcid = {10000, 10001, 10002}; -- you can apply this to multiple npc's here.
local delay = 1*30*1000 -- 30 seconds
local cycles = 1 -- must be value 1 . any value other than 1 MAY cause events to stack and freeze the core.

local  ANN = {};
-- {Statement, stated, linked, emote} 
-- statement // in quotes "blah blah" 
-- stated // say = 0 // yell = 1 
-- linked // table key id if your using multiple statements  for one announcement i.e.(yell THEN say)
-- emote // talk = 1 // yell = 5// Question = 6 // Dance = 10 // Rude = 14 // shout = 22 // 
-- http://collab.kpsn.org/display/tc/Emote

ANN[npcid] = {
	[1] = {"Well,, that was dumb.", 0, 0, 1},
	[2] = {"!Bite my shiney metal ass!", 1, 0, 14},
	[3] = {"Well,, were boned.", 0, 0, 1},
	[4] = {"Hey sexy momma .. Wanna kill all humans..??.", 0, 0, 1},
	[5] = {"Goodbye losers whom I allways hated", 1, 0, 22},
	[6] = {"!Shut the hell up!", 1, 0, 5},
	[7] = {"Would you kindly shut your noise hole?", 0, 0, 1},
	[8] = {"I'm gonna go build my own theme park.. with blackjack and hookerz.", 0, 101, 1},
	[9] = {"Who are you and why should i care?", 0, 0, 6},
	[10] = {"!Shut up and Pay attention To Me !!.. !!BENDER!!", 1, 0, 5},
	[11] = {"Hasta La Vista , Meat bag.", 0, 0, 1},
	[12] = {"Awww, heres a little song i wrote to cheer you up. Its called ", 0, 100, 1},
	[13] = {"Do the Bender ,, Do the Bender ,, its your birthday ,, do the bender", 0, 0, 10},
	[14] = {"Shut up baby , you love it", 0, 0, 1},
	[100] = {"!!Let's go allready!!", 1, 0, 5}, -- linked
	[101] = {"In fact ,, forget the park.", 0, 0, 1}, -- linked
		};
		
local function Drop_Event_On_Death(eventid, creature, killer)
	ANN[creature:GetGUIDLow()] = nil;
	creature:RemoveEvents()
end

local function Announce(id, creature)

	if(ANN[npcid][id][4] ~= (nil or 0))then
		creature:Emote(ANN[npcid][id][4])
	end
	if(ANN[npcid][id][2] == 0)then
		creature:SendUnitSay(ANN[npcid][id][1], 0)
	end
	if(ANN[npcid][id][2] == 1)then
		creature:SendUnitYell(ANN[npcid][id][1], 0)
	end
	if(ANN[npcid][id][3]~=(nil or 0))then
		Announce(ANN[npcid][id][3], creature)
	end
end

local function TimedSay(eventId, delay, repeats, creature)

	local ostime = tonumber(GetGameTime())
	local seed = (ostime*ostime)
	math.randomseed(seed)
	
	local Ann = math.random(1, #ANN[npcid])

	Announce(Ann, creature)	
	creature:RemoveEvents()
	ANN[creature:GetGUIDLow()] = nil;
	creature:RegisterEvent(TimedSay, delay, cycles) -- Constant
	ANN[creature:GetGUIDLow()] = {reset = 1,}; -- Constant

end

local function OnMotion(event, creature, unit)

	if(unit:GetObjectType()=="Player")then

		if(ANN[creature:GetGUIDLow()]==nil)then  
			ANN[creature:GetGUIDLow()] = {reset = 1,};
		    creature:RegisterEvent(TimedSay, delay, cycles)
		else
		end
	else
	end
end

for npc=1, #npcid do

	RegisterCreatureEvent(npcid[npc], 27, OnMotion) 
	RegisterCreatureEvent(npcid[npc], 4, Drop_Event_On_Death)
end
