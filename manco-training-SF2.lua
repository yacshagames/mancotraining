--========================================--
--             MANCO Traning              --
--  SF2 Lua Training Mode for Fightcade2  --
--      Credits: Intimarco / Yacsha       --
--                                        --
-- Based in Training: POF and Dammit      --
--========================================--
--
-- v0.4
-- 2021-09-05
-- A main menu and secondary subsmenus are added to manage multiple Training options
-- 2021-08-30
-- Add auto-block and auto-moves for player 2 (Candado Training Mode)
-- v0.3 2021-08-28
-- The training is renamed as MANCO Training Mode
-- v0.2 2021-08-15
-- - The dizzy did not work well, the infinite energy took away the fluidity of the blows (hadukens that did not fall to the opponent). HUD dashboard was not showing up in sf2ce and data was not being calculated in sf2ce
-- v0.1 2020-11-22
-- - First version: Support for sf2ce, sf2hf, ssf2t and ssf2x 
-- - based in SSF2X Lua Training Mode for Fightcade2 by pof v0.3 (2020/10/23) - https://github.com/poliva/ssf2xj
-- Contains borrowed code from:
--  * scrolling-input by Dammit
--  	+ frame display by zass
--  	+ fixed windows crash on FBNeo by pof
--  * hitbox viewer by Dammit, MZ, Felineki
--  * ST HUD by Pasky
--  * training mode & stage selctor by pof



local profile = require("modules/profile")
if not profile then	
	print("modules/profile.lua not found")
	return -- abort script
end

local stage_selector = require("modules/stage_selector")
if not stage_selector then	
	print("modules/stage_selector.lua not found")
	return -- abort script
end

local hitbox = require("modules/hitbox")
if not hitbox then	
	print("modules/hitbox.lua not found")
	return -- abort script
end

local lock_actions = require("modules/lock_actions")
if not lock_actions then	
	print("modules/lock_actions.lua not found")
	return -- abort script
end

local input_display = require("modules/input_display")
if not input_display then	
	print("modules/input_display.lua not found")
	return -- abort script
end

local sf2hud = require("modules/sf2hud")
if not sf2hud then	
	print("modules/sf2hud.lua not found")
	return -- abort script
end

local training = require("modules/training_mode")
if not training then	
	print("modules/training_mode.lua not found")
	return -- abort script
end

local macro_actions = require("modules/macro_actions")
if not macro_actions then	
	print("modules/macro_actions.lua not found")
	return -- abort script
end

----------------------------------------------------------------------------------------------------
--Interface Functions
----------------------------------------------------------------------------------------------------
local function EnableTraining()

	print( "> Training mode: " .. training.EnableTraining() )
end

local function LockActions()

	print("> Lock action: " ..  lock_actions.LockActions())	
end

local function ToggleHUD()

	print( "> HUD: " .. sf2hud.ToggleHUD() )
end

local function EnableHitboxes()

	print( hitbox.EnableHitboxes() )	
end

local function InputDisplay()

	print("> Input display: " .. input_display.toggleplayer())	
end

local function StageSelector()

	print( "> Stage: " .. stage_selector.StageSelector() )	
end

local function EnableMacroActions()

	print( "> Action1: " .. macro_actions.EnableMacroActions() )	
end


----------------------------------------------------------------------------------------------------
--Menus
----------------------------------------------------------------------------------------------------
local current_menu = 0 -- 0: Main; 1: Submenu1

function ShowMainMenu()
	
	current_menu = 0

	print("MANCO Training Street Fighter 2 for Fightcade2 v0.4")
	print("------- Credits: Pof / Yacsha - Tutorial: youtu.be/sAx-r1c24Ac -------")
	print("(Alt+1): Toggle Training Mode on/off")
	print("(Alt+2): Lock Actions (Candado Training)")
	print("(Alt+3): Toggle HUD Display")
	print("(Alt+4): Display/Hide Hitboxes")
	print("(Alt+5): More options...")
	print("---------------------------------------------------------------------------------")
end


local function ShowSubmenu1()
	
	current_menu = 1

	print("MANCO Training Street Fighter 2 for Fightcade2 v0.4")
	print("------- Credits: Pof / Yacsha - Tutorial: youtu.be/sAx-r1c24Ac -------")
	print("(Alt+1): Display/Hide Scrolling Input")
	print("(Alt+2): Toggle Background Stage Selector")
	print("(Alt+3): Return main menu...")
	print("---------------------------------------------------------------------------------")
end

----------------------------------------------------------------------------------------------------
--Hot Keys
----------------------------------------------------------------------------------------------------
input.registerhotkey(1, function()

	if current_menu==0 then
		EnableTraining()
	else
		InputDisplay()
	end
end)

input.registerhotkey(2, function()

	if current_menu==0 then
		LockActions()
	else
		StageSelector()
	end	
end)

input.registerhotkey(3, function()
--[[
	if current_menu==0 then
		ToggleHUD()
	else
		ShowMainMenu()
	end
]]--
	EnableMacroActions()
end)

input.registerhotkey(4, function()

	if current_menu==0 then
		EnableHitboxes()	
	end
end)

input.registerhotkey(5, function()
	
	if current_menu==0 then
		ShowSubmenu1()	
	end
end)




----------------------------------------------------------------------------------------------------
--Main loop
----------------------------------------------------------------------------------------------------
ShowMainMenu()

while true do
	-- Draw these functions on the same frame data is read
	gui.register(function()
		--Hitbox rendering
		hitbox.DrawHitboxes()

		--Scrolling Input display
		input_display.ScrollingInputDisplay()

		-- Training Script stuff
		training.training_logic()

		-- Toggle background stage
		stage_selector.toggle_background_stage()

		-- ST HUD
		sf2hud.render_hud()

		-- lock actions for player 1 and 2
		lock_actions.lock_actions()

		macro_actions.MacroActions()

	end)
	--Pause the script until the next frame
	emu.frameadvance()
end

