----------------------------------------------------------------------------------------------------
-- Scrolling Input
-- Original Authors for this Script: Dammit
-- Homepage: http://code.google.com/p/mame-rr/
-- requires the Lua gd library (http://luaforge.net/projects/lua-gd/)
----------------------------------------------------------------------------------------------------
lib = {}
--[[
Scrolling input display Lua script
requires the Lua gd library (http://luaforge.net/projects/lua-gd/)
written by Dammit (dammit9x at hotmail dot com)

Works with MAME, FBA, pcsx, snes9x and Gens:
http://code.google.com/p/mame-rr/downloads/list
http://code.google.com/p/fbarr/downloads/list
http://code.google.com/p/pcsxrr/downloads/list
http://code.google.com/p/snes9x-rr/downloads/list
http://code.google.com/p/gens-rerecording/downloads/list
]]

png={}
png[1]="89504E470D0A1A0A0000000D4948445200000040000000200203000000DFF3961700000009504C5445000000FFFFFF00000073C683710000000174524E530040E6D8660000002449444154289163605AC0800A3813D00454B3D0944C0D252480A105C3500C6B47C1A0040033D007895CB63ACD0000000049454E44AE426082"
png[2]="89504E470D0A1A0A0000000D4948445200000040000000200203000000DFF3961700000009504C5445000000FFFFFF00000073C683710000000174524E530040E6D8660000002649444154289163605AC0800A9866A009AC9A86263035740101010C2D188662583B0A062500002EE5080D13A28F410000000049454E44AE426082"
png[3]="89504E470D0A1A0A0000000D4948445200000040000000200203000000DFF3961700000009504C5445000000FFFFFF00000073C683710000000174524E530040E6D8660000002949444154289163605AC0800A3823D00454C3D004A686A2E9591985268061068600D70A8651300400008A8706202173B2D70000000049454E44AE426082"
png[4]="89504E470D0A1A0A0000000D4948445200000040000000200203000000DFF3961700000009504C5445000000FFFFFF00000073C683710000000174524E530040E6D8660000002649444154289163E05AC1800A38230809AC8C5A802A3035144D40358C90194C683A46C1E004008E7206204B55C5510000000049454E44AE426082"
png[5]="89504E470D0A1A0A0000000D4948445200000040000000200203000000DFF3961700000009504C5445000000999999000000A55445040000000174524E530040E6D8660000002949444154289163D05AC1800AA646A00B24105231330C4D60D1D40568226A687C060E74815130180100A6950696CDA8F4A30000000049454E44AE426082"
png[6]="89504E470D0A1A0A0000000D4948445200000040000000200203000000DFF3961700000009504C5445000000999999000000A55445040000000174524E530040E6D8660000002A49444154289163E05AC5800A384317A00A304D5D4040856A249AC0D4243401B506345B381846C1500000E9B8074BC03E891B0000000049454E44AE426082"
png[7]="89504E470D0A1A0A0000000D4948445200000040000000200203000000DFF3961700000009504C5445000000999999000000A55445040000000174524E530040E6D866000000294944415428916360E06040036A68FC455317A00ACC0C43533135025D2081900AAD15E8D68E82C1080033C40696E5C0BC450000000049454E44AE426082"
png[8]="89504E470D0A1A0A0000000D4948445200000040000000200203000000DFF3961700000009504C5445000000999999000000A55445040000000174524E530040E6D8660000002A49444154289163E06040036A0D6802539316A00AA846A2097086A209304D25A4826B15BABDA36030020091CC074B27E0B0C80000000049454E44AE426082"
png[9]="89504E470D0A1A0A0000000D4948445200000040000000200203000000DFF3961700000009504C544500000000FFFF000000970228BD0000000174524E530040E6D8660000002549444154289163D05AB5800105A886A209A8AD24A802DD0CB5060602025AE802A360500200541E087E115994D60000000049454E44AE426082"
png[10]="89504E470D0A1A0A0000000D4948445200000040000000200203000000DFF3961700000009504C5445000000FFFF00000000ADC385800000000174524E530040E6D8660000002549444154289163D05AB5800105A886A209A8AD24A802DD0CB5060602025AE802A360500200541E087E115994D60000000049454E44AE426082"
png[11]="89504E470D0A1A0A0000000D4948445200000040000000200203000000DFF3961700000009504C5445000000FF000000000067A7420C0000000174524E530040E6D8660000002549444154289163D05AB5800105A886A209A8AD24A802DD0CB5060602025AE802A360500200541E087E115994D60000000049454E44AE426082"
png[12]="89504E470D0A1A0A0000000D4948445200000040000000200203000000DFF3961700000009504C544500000000FFFF000000970228BD0000000174524E530040E6D8660000002349444154289163D0EA6240056ACBD005A6A109A8461012C0D082612886B5A36050020047490573033E95880000000049454E44AE426082"
png[13]="89504E470D0A1A0A0000000D4948445200000040000000200203000000DFF3961700000009504C5445000000FFFF00000000ADC385800000000174524E530040E6D8660000002349444154289163D0EA6240056ACBD005A6A109A8461012C0D082612886B5A36050020047490573033E95880000000049454E44AE426082"
png[14]="89504E470D0A1A0A0000000D4948445200000040000000200203000000DFF3961700000009504C5445000000FF000000000067A7420C0000000174524E530040E6D8660000002349444154289163D0EA6240056ACBD005A6A109A8461012C0D082612886B5A36050020047490573033E95880000000049454E44AE426082"
png[15]="89504E470D0A1A0A0000000D4948445200000040000000200203000000DFF3961700000009504C54450000006600FF00000083CB03760000000174524E530040E6D8660000002149444154289163E05AC1800A54C3D004D408AAE05A464805A616744347C1A00400184404CF4B586E0D0000000049454E44AE426082"


local buffersize   = 13     --how many lines to show
local margin_left  = 0.4      --space from the left of the screen, in tiles, for player 1
local margin_right = 7      --space from the right of the screen, in tiles, for player 2
local margin_top   = 12      --space from the top of the screen, in tiles
local timeout      = 45     --how many idle frames until old lines are cleared on the next input
local screenwidth  = 256    --pixel width of the screen for spacing calculations (only applies if emu.screenwidth() is unavailable)
local max_input	 = 999    --how long to hold input counter for
local frameskip_address = 0xFF801D


----------------------------------------------------------------------------------------------------

local gamekeys = {
	{ set =
		{ "capcom",            fba,       mame },
		{      "l",         "Left",     "Left" },
		{      "r",        "Right",    "Right" },
		{      "u",           "Up",       "Up" },
		{      "d",         "Down",     "Down" },
		{     "ul"},
		{     "ur"},
		{     "dl"},
		{     "dr"},
		{     "LP",   "Weak Punch", "Button 1" },
		{     "MP", "Medium Punch", "Button 2" },
		{     "HP", "Strong Punch", "Button 3" },
		{     "LK",    "Weak Kick", "Button 4" },
		{     "MK",  "Medium Kick", "Button 5" },
		{     "HK",  "Strong Kick", "Button 6" },
		{      "S",        "Start",    "Start" },
	},
}

local gd = require "gd"
local minimum_tile_size, maximum_tile_size = 8, 32
local icon_size  = minimum_tile_size
local thisframe, lastframe, module, keyset, changed = {}, {}
local margin, rescale_icons, recording, display, start, effective_width = {}, true, false
local draw = { [1] = true, [2] = true }
local allinputcounters  = { [1] =   {}, [2] =   {} }
local nullinputcounters = { [1] = {[1] = 0}, [2] = {[1] = 0}}  -- counters for null input for player 1 and player 2
local activeinputcounters = { [1] = {[1] = 0}, [2] = {[1] = 0}}  -- counters for active inputs player 1 and player 2
local idle = { [1] =    0, [2] =    0 }
local isplayernullinput = { [1] = true, [2] = true }

local frameskip_currval = 0
local frameskip_prevval = 0
local was_frameskip = false

for m, scheme in ipairs(gamekeys) do --Detect what set to use.
	if string.find("capcom", scheme.set[1]:lower()) then
		module = scheme
		for k, emu in pairs(scheme.set) do --Detect what emulator this is.
			if k > 1 and emu then
				keyset = k
				break
			end
		end
		break
	end
end
if not module then error("There's no module available for capcom", 0) end
if not keyset then error("The '" .. module.set[1] .. "' module isn't prepared for this emulator.", 0) end

-- printing functions
function table_print (tt, indent, done)
  done = done or {}
  indent = indent or 0
  if type(tt) == "table" then
    local sb = {}
    for key, value in pairs (tt) do
      table.insert(sb, string.rep (" ", indent)) -- indent it
      if type (value) == "table" and not done [value] then
        done [value] = true
        table.insert(sb, key .. " = {\n");
        table.insert(sb, table_print (value, indent + 2, done))
        table.insert(sb, string.rep (" ", indent)) -- indent it
        table.insert(sb, "}\n");
      elseif "number" == type(key) then
        table.insert(sb, string.format("\"%s\"\n", tostring(value)))
      else
        table.insert(sb, string.format(
            "%s = \"%s\"\n", tostring (key), tostring(value)))
       end
    end
    return table.concat(sb)
  else
    return tt .. "\n"
  end
end

function to_string( tbl )
    if  "nil"       == type( tbl ) then
        return tostring(nil)
    elseif  "table" == type( tbl ) then
        return table_print(tbl)
    elseif  "string" == type( tbl ) then
        return tbl
    else
        return tostring(tbl)
    end
end
---

emu = emu or gens
----------------------------------------------------------------------------------------------------
-- image-string conversion functions

local function hexdump_to_string(hexdump)
	local str = ""
	for n = 1, hexdump:len(), 2 do
		str = str .. string.char("0x" .. hexdump:sub(n,n+1))
	end
	return str
end

local function string_to_hexdump(str)
	local hexdump = ""
	for n = 1, str:len() do
		hexdump = hexdump .. string.format("%02X",str:sub(n,n):byte())
	end
	return hexdump
end
--example usage:
--local image = gd.createFromPng("image.png")
--local str = image:pngStr()
--local hexdump = string_to_hexdump(str)

local blank_img_hexdump =
"89504E470D0A1A0A0000000D49484452000000400000002001030000009853ECC700000003504C5445000000A77A3DDA00" ..
"00000174524E530040E6D8660000000D49444154189563601805F8000001200001BFC1B1A80000000049454E44AE426082"
local blank_img_string = hexdump_to_string(blank_img_hexdump)

----------------------------------------------------------------------------------------------------
-- display functions

local function text(x, y, row)
	gui.text(x, y, module[row][1])
end

local function image(x, y, row)
	gui.gdoverlay(x, y, img[row])
end

display = image

img={}
local function readimages()
	local scaled_width = icon_size
	if rescale_icons and emu.screenwidth and emu.screenheight then
		scaled_width = icon_size * emu.screenwidth()/emu.screenheight() / (4/3)
	end
	if display == image then
		for n, key in ipairs(module) do
			img[n] = gd.createFromPngStr(hexdump_to_string(png[n])):gdStr()
		end
	end
	effective_width = scaled_width
end
readimages()

----------------------------------------------------------------------------------------------------
-- update functions

local function filterinput(p, frame)
    isplayernullinput[p] = true
	for pressed, state in pairs(joypad.getdown(p)) do --Check current controller state >
		for row, name in pairs(module) do               --but ignore non-gameplay buttons.
			if pressed == name[keyset]
		--Arcade does not distinguish joypads, so inputs must be filtered by "P1" and "P2".
			or pressed == "P" .. p .. " " .. tostring(name[keyset])
		--MAME also has unusual names for the start buttons.
			or pressed == p .. (p == 1 and " Player " or " Players ") .. tostring(name[keyset]) then
				frame[row] = state
				isplayernullinput[p] = false
				break
			end
		end
	end
end

local function compositeinput(frame)          --Convert individual directions to diagonals.
	for _,dir in pairs({ {1,3,5}, {2,3,6}, {1,4,7}, {2,4,8} }) do --ul, ur, dl, dr
		if frame[dir[1]] and frame[dir[2]] then
			frame[dir[1]], frame[dir[2]], frame[dir[3]] = nil, nil, true
		end
	end
end

local function detectchanges(lastframe, thisframe)
    changed = false
	for key, state in pairs(thisframe) do       --If a key is pressed >
		if lastframe and not lastframe[key] then  --that wasn't pressed last frame >
			changed = true                          --then changes were made.
			break
		end
	end
	if lastframe then                               -- zass: add check for full state change
		for key, state in pairs(lastframe) do       -- also check that a key last frame
			if thisframe and not thisframe[key] then  --that wasn't pressed this frame >
				changed = true                          --then changes were made.
				break
			end
		end
	end
end

-- updated by zass to show counters
local function updaterecords(player, frame, nullinputcounters, activeinputcounters)
--print("player = " .. player)
if allinputcounters == nil then
-- 	print("input was nil")
	allinputcounters = { [1] =   {}, [2] =   {} }
--	draw = { [1] = true, [2] = true }
else
	if allinputcounters[player] == nil then
--  	print("input player was nil")
		allinputcounters[player] = {}
--		draw = { [1] = true, [2] = true }
	end
end
-- print(to_string(allinputcounters))
 local input = allinputcounters[player]
-- print(to_string(input))

		if changed then                         --If changes were made >
			for record = buffersize, 2, -1 do
				if input ~= nil then
					input[record] = input[record-1]   --then shift every old record by 1 >
				end
				nullinputcounters[record] = nullinputcounters[record-1]   --then shift every old record by 1 >
				activeinputcounters[record] = activeinputcounters[record-1]   --then shift every old record by 1 >
			end

			idle[player] = 0                      --Reset the idle count >
				input[1] = {}                         --and set current input as record 1 >
		if isplayernullinput[player] == true then
			nullinputcounters[1] = 1;
			activeinputcounters[1] = 0;
			if was_frameskip then
				nullinputcounters[1] = 2;
				activeinputcounters[1] = 0;
			end
		else
			nullinputcounters[1] = 0;
			activeinputcounters[1] = 1;
			if was_frameskip then
				nullinputcounters[1] = 0;
				activeinputcounters[1] = 2;
			end

		end
		local index = 1
		for row, name in ipairs(module) do    --but the order must not deviate from gamekeys.
			for key, state in pairs(frame) do
				if key == row then
						input[1][index] = row
					index = index+1
					break
				end
			end
		end
	else
		if idle[player] == nil then
			idle[player] = 0
		end
		idle[player] = idle[player]+1         --Increment the idle count if nothing changed.
		if isplayernullinput[player] == true then
			nullinputcounters[1] = nullinputcounters[1] + 1
			if nullinputcounters[1] > max_input then
				nullinputcounters[1] = max_input
			end
			if was_frameskip then             -- increment again if there was a frameskip
				nullinputcounters[1] = nullinputcounters[1] + 1
				if nullinputcounters[1] > max_input then
					nullinputcounters[1] = max_input
				end
			end
		else
			activeinputcounters[1] = activeinputcounters[1] + 1
			if activeinputcounters[1] > max_input then
				activeinputcounters[1] = max_input
			end
			if was_frameskip then
				activeinputcounters[1] = activeinputcounters[1] + 1
				if activeinputcounters[1] > max_input then
					activeinputcounters[1] = max_input
				end
			end
		end
	end
end

-- added by zass, increment counters if frameskip
local function checkframeskip()
	frameskip_prevval = frameskip_currval
	frameskip_currval = memory.readbyte(frameskip_address)
	local x = frameskip_currval - frameskip_prevval
	if x % 2 == 0 then
		was_frameskip = true
	else
		was_frameskip = false
	end
end

emu.registerafter(function()
	margin[1] = margin_left*effective_width
	margin[2] = (emu.screenwidth and emu.screenwidth() or screenwidth) - margin_right*effective_width
	margin[3] = margin_top*icon_size
	for player = 1, 2 do
		thisframe = {}
		if player == 1 then
			checkframeskip() -- only check frameskip once
		end
		filterinput(player, thisframe)
		compositeinput(thisframe)
		detectchanges(lastframe[player], thisframe)
		updaterecords(player, thisframe, nullinputcounters[player], activeinputcounters[player])
		lastframe[player] = thisframe

	end
end)

----------------------------------------------------------------------------------------------------
-- hotkey function
----------------------------------------------------------------------------------------------------

function lib.InputDisplay1_TogglePlayer()
	if not draw[1] and not draw[2] then
		draw[1] = true
		draw[2] = false
		--print("> Input display: P1 on / P2 off")
		return "P1 on / P2 off"
	elseif draw[1] and not draw[2] then
		draw[1] = false
		draw[2] = true
		--print("> Input display: P1 off / P2 on")
		return "P1 off / P2 on"
	elseif not draw[1] and draw[2] then
		draw[1] = true
		draw[2] = true
		--print("> Input display: Both players on")
		return "Both players on"
	elseif draw[1] and draw[2] then
		draw[1] = false
		draw[2] = false
		--print("> Input display: Both players off")
		return "Both players off"
	end
end

----------------------------------------------------------------------------------------------------
--Scrolling Input display
----------------------------------------------------------------------------------------------------
function InputDisplay1_Show()

	for player = 1, 2 do		
		if draw[player] then
		local i = 0
		local skip = 0
			for line in pairs(allinputcounters[player]) do
			i = i + 1

				if nullinputcounters[player][i] > 0 and i == 1 then
					gui.text(margin[player] + effective_width - 10, margin[3] + (line-1)*icon_size, "" .. nullinputcounters[player][i], 0xAACCCCFF)
				elseif i == 1 then
					if nullinputcounters[player][i+1] and nullinputcounters[player][i+1] > 0 then
						gui.text(margin[player] + effective_width - 10, margin[3] + (line-1)*icon_size, "" .. nullinputcounters[player][i+1], 0xAACCCCFF)
					end
					gui.text(margin[player] + effective_width  + 5, margin[3] + (line-1)*icon_size, "" .. activeinputcounters[player][i])

				elseif activeinputcounters[player][i] == 0 then
					skip = skip + 1 -- log a skip for an empty input
				else
					if nullinputcounters[player][i+1] and nullinputcounters[player][i+1] > 0 then
						gui.text(margin[player] + effective_width - 10, margin[3] + (line-1-skip)*icon_size, "" .. nullinputcounters[player][i+1], 0xAACCCCFF)
					end
					gui.text(margin[player] + effective_width  + 5, margin[3] + (line-1-skip)*icon_size, "" .. activeinputcounters[player][i], "yellow")
				end

				for index,row in pairs(allinputcounters[player][line]) do
					display(margin[player] + (index-1)*effective_width + 30, margin[3] + (line-1-skip)*icon_size, row)
				end


			end
		end
	end
end

----------------------------------------------------------------------------------------------------
--End Scrolling Input script by: Dammit
--Homepage: http://code.google.com/p/mame-rr/
----------------------------------------------------------------------------------------------------

function lib.Show()
	InputDisplay1_Show()
	InputDisplay2_Show()
end


----------------------------------------------------------------------------------------------------
-- Input Display version 2 - Show Fightstick in text mode
----------------------------------------------------------------------------------------------------
local t_color = { 
		on1  = 0xFF0000FF,
		on2  = 0x000000FF,
		off1 = 0xFFFFFFFF,
		off2 = 0x000000FF
	}

local InputDisplay2Enabled = true


function InputDisplay2_Show()

	if InputDisplay2Enabled ==false then
		return
	end

	local tabla_inp = {}
	local width,height = emu.screenwidth() ,emu.screenheight()
	--
	for n = 1, 2 do
		tabla_inp[n .. "^"] =  {(n-1)/n*width + 95 , height - 18, "P" .. n .. " Up"}
		tabla_inp[n .. "v"] =  {(n-1)/n*width + 95 , height - 12, "P" .. n .. " Down"}
		tabla_inp[n .. "<"] =  {(n-1)/n*width + 89 , height - 15, "P" .. n .. " Left"}
		tabla_inp[n .. ">"] =  {(n-1)/n*width + 101 , height - 15, "P" .. n .. " Right"}
		
		tabla_inp[n .. "LP"] = {(n-1)/n*width + 55 , height - 19, "P" .. n .. " Weak Punch"}
		tabla_inp[n .. "MP"] = {(n-1)/n*width + 65, height - 19, "P" .. n .. " Medium Punch"}
		tabla_inp[n .. "HP"] = {(n-1)/n*width + 75, height - 19, "P" .. n .. " Strong Punch"}
		
		tabla_inp[n .. "LK"] = {(n-1)/n*width + 55 , height - 11, "P" .. n .. " Weak Kick"}
		tabla_inp[n .. "MK"] = {(n-1)/n*width + 65, height - 11, "P" .. n .. " Medium Kick"}
		tabla_inp[n .. "HK"] = {(n-1)/n*width + 75, height - 11, "P" .. n .. " Strong Kick"}
			
	end
	
	for k,v in pairs(tabla_inp) do
		local color1,color2 = t_color.on1,t_color.on2
		if joypad.get()[v[3]] == false  then
			color1,color2 = t_color.off1,t_color.off2
		end
		gui.text(v[1], v[2], string.sub(k, 2), color1, color2)
	end
	
end

----------------------------------------------------------------------------------------------------
-- hotkey function
----------------------------------------------------------------------------------------------------
function lib.InputDisplay2_Enable()

	InputDisplay2Enabled = not InputDisplay2Enabled

	if InputDisplay2Enabled then
		return "On"
	else
		return "Off"
	end
end

return lib