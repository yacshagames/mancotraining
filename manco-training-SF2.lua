--========================================--
--             MANCO Traning              --
--  SF2 Lua Training Mode for Fightcade2  --
--      Credits: Intimarco / Yacsha       --
--                                        --
-- Based in Training: POF and Dammit      --
--========================================--
--
-- v2.1
-- 2022-07-24
-- Yzkof Virtual fightstick added
-- Minor changes to more easily update the version number in all menus
-- v2.0
-- 2021-09-26
-- MadCatz Virtual fightstick added (Classic fightstick)
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

----------------------------------------------------------------------------------------------------
--Name and Versión
----------------------------------------------------------------------------------------------------
local strMainName1 = "MANCO Training Street Fighter 2 v2.1"
local strMainName2 = "for Fightcade"
local strCredits = "Credits: intiMarqo / Pof / Yacsha"
local strFecha = "Jul.2022"
local strShortTittle = "MANCO Training v2.1"

----------------------------------------------------------------------------------------------------
--Include Modules
----------------------------------------------------------------------------------------------------
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

local fightstick_input = require("modules/fightstick_input")
if not fightstick_input then	
	print("modules/fightstick_input.lua not found")
	return -- abort script
end

----------------------------------------------------------------------------------------------------
--Interface Functions
----------------------------------------------------------------------------------------------------
local function EnableTraining(incrementCounter)

	result = training.EnableTraining(incrementCounter)
	print( "> Training mode: " .. result )
	return result
end

local function LockActions(incrementCounter)

	result = lock_actions.LockActions(incrementCounter)
	print("> Lock action: " ..  result)
	return result
end

local function ToggleHUD(incrementCounter)
	result = sf2hud.ToggleHUD(incrementCounter) 
	print( "> HUD: " .. result )
	return result
end

local function EnableHitboxes(incrementCounter)

	result = hitbox.EnableHitboxes(incrementCounter) 
	print( "> Hitboxes: " .. result )	
	return result
end

local function InputDisplay1(incrementCounter)

	result = input_display.InputDisplay_TogglePlayer(incrementCounter) 
	print("> Scroll input display: " .. result)	
	return result
end

local function InputDisplay2(incrementCounter)

	result = fightstick_input.EnableFightstickDisplay(incrementCounter) 
	print("> Fightstick input display: " .. result)	
	return result
end

local function StageSelector(incrementCounter)
	result = stage_selector.StageSelector(incrementCounter)
	print( "> Stage: " .. result )	
	return result
end

local function EnableMacroActions(incrementCounter)

	result = macro_actions.EnableMacroActions(incrementCounter)
	print( "> Macro action: " .. result )	
	return result
end


----------------------------------------------------------------------------------------------------
--Interactive Visual Menu
----------------------------------------------------------------------------------------------------
-- Menu colors
local K_N = 0x000000FF
local K_R = 0XFF0000FF
local K_A = 0X87CEEBFF
local K_B = 0XFFFFFFFF

-- Menu variabkes
local menuActivo=false
local contadordeentradas=0
local contadorMenu=0
local MenuShowFirstTime = true

local seleccionMenu={   vertical=1
			,horizontal=1
}

local menuOpcion={
	  {"Training Mode   :",false,""}
	 ,{"Lock Actions    :",false,""}
	 ,{"Macro Actions   :",false,""}
	 ,{"HUD Display     :",false,""}
	 ,{"Stage selector  :",false,""}
	 ,{"Hitboxes        :",false,""}
 	 ,{"Scrolling Input :",false,""}
 	 ,{"Fightstick      :",false,""}
}


local menuEstatico={
			    cabecera	= {"-- MENU OPTIONS --"}
			 ,  pie		= { strMainName1, strMainName2, strCredits, strFecha}
			 ,  titulo	= strShortTittle
}

-- Menu functions
local function MenuExecute( optionMenu, incrementCounter )

	if optionMenu==1 then
		return EnableTraining(incrementCounter)
	elseif optionMenu==2 then
		return LockActions(incrementCounter)
	elseif optionMenu==3 then
		return EnableMacroActions(incrementCounter)
	elseif optionMenu==4 then
		return ToggleHUD(incrementCounter)
	elseif optionMenu==5 then
		return StageSelector(incrementCounter)
	elseif optionMenu==6 then
		return EnableHitboxes(incrementCounter)
	elseif optionMenu==7 then
		return InputDisplay1(incrementCounter)
	elseif optionMenu==8 then
		return InputDisplay2(incrementCounter)	
	end

	return "None"
end

local function LoadVisualMenuOptions()

	-- Load default option to array menuOpcion
	for i=1, #menuOpcion do
		 menuOpcion[i][3] = MenuExecute( i, 0 )
	end

	print( "Press -P1 Coin- for show menu - " .. menuEstatico.titulo )
end

local function menuHabilitar()
	local inp = joypad.get()
	
	if inp["P1 Coin"] then	
		contadordeentradas=contadordeentradas+1
	else
		contadordeentradas=0
	end
		
	if contadordeentradas == 30 then 
		if menuActivo then
			menuActivo=false
		else
			menuActivo=true	
			MenuShowFirstTime = false
		end
	end
end

local function dibujaMenu()
		local width,height = emu.screenwidth() ,emu.screenheight()
		
		x1 = width/4
		y1 = height/6
		
		x2 = width-x1
		y2 = height-y1
		
		gui.box(x1,y1,x2,y2,K_N,K_R)
		
		separacion_texto_v=8
		separacion_texto_h=10
		
		for x=1, #menuEstatico.cabecera do
			y1=y1+separacion_texto_v
			gui.text(((width/2) - 4*(string.len(menuEstatico.cabecera[x])/2)), y1 , menuEstatico.cabecera[x])
		end
		
		x1=x1+separacion_texto_h
		y1=y1+(2*separacion_texto_v)
		
		for i=1, #menuOpcion do
			
			if menuOpcion[i][2] then
				gui.text(x1, y1 , menuOpcion[i][1],K_R)
			else
				gui.text(x1, y1 , menuOpcion[i][1])
			end
			
			-- Show current "tool option" selected
			gui.text(x1+75, y1 , menuOpcion[i][3])
			
			y1=y1+separacion_texto_v
		end
		
		puntoImpresionTexto_y=height-70
		for r=1, #menuEstatico.pie do
			gui.text(((width/2) - 4*(string.len(menuEstatico.pie[r])/2)), puntoImpresionTexto_y , menuEstatico.pie[r],K_A)
			puntoImpresionTexto_y=puntoImpresionTexto_y+separacion_texto_v
		end
		
end

local function ShowVisualMenu()

	local width,height = emu.screenwidth() ,emu.screenheight()
	
	menuHabilitar()
	--[[
	if MenuShowFirstTime then
		-- show a help text to get the menu, only the first time the menu is invoked
		x = width/15
		y = height/21	
		--texto = "Press -P1 Coin- for show menu - " .. menuEstatico.titulo		
		gui.text(( x - (string.len(texto)/2)), y, texto)
	else ]]--
		-- Show Title
		x = width/2
		y = height/21
		gui.text(( x - 4*(string.len(menuEstatico.titulo)/2)), y , menuEstatico.titulo)
	--end 	
	
	if not menuActivo then 
		return 
	end	
	
	local inp = joypad.get()
	
	if inp["P1 Down"] then	
		contadorMenu=contadorMenu+1
		if contadorMenu == 1 then
			seleccionMenu.vertical=seleccionMenu.vertical+1
		end
	elseif inp["P1 Up"] then
		contadorMenu=contadorMenu+1
		if contadorMenu == 1 then
			seleccionMenu.vertical=seleccionMenu.vertical-1
		end
	elseif inp["P1 Right"] then
		contadorMenu=contadorMenu+1
		
		if contadorMenu == 1 then			
			menuOpcion[seleccionMenu.vertical][3] = MenuExecute(seleccionMenu.vertical,1)
		end	
	elseif inp["P1 Left"] then
		contadorMenu=contadorMenu+1

		if contadorMenu == 1 then			
			menuOpcion[seleccionMenu.vertical][3] = MenuExecute(seleccionMenu.vertical,-1)
		end	
	else
		contadorMenu=0
	end
	
	if seleccionMenu.vertical > #menuOpcion then 
		seleccionMenu.vertical=1
	elseif 	seleccionMenu.vertical < 1 then
		seleccionMenu.vertical=#menuOpcion
	end
	
	for i=1, #menuOpcion do
		if seleccionMenu.vertical == i  then
			menuOpcion[i][2]=true
		else
			menuOpcion[i][2]=false
		end
	end	
	
	if menuActivo then 	
		dibujaMenu()
	end
	
end
----------------------------------------------------------------------------------------------------
--Lua Console Menu
----------------------------------------------------------------------------------------------------

-- Options
local current_menu = 0 -- 0: Main; 1: Submenu1

local function ShowMainMenu()
	
	current_menu = 0

	print(strMainName1 .. " " .. strMainName2)
	print( "-- " .. strCredits .. " - Tutorial: youtu.be/sAx-r1c24Ac --")
	print("(Alt+1): Toggle Training Mode on/off")
	print("(Alt+2): Lock Actions (Candado Training)")
	print("(Alt+3): Macro Actions")
	print("(Alt+4): Toggle HUD Display")
	print("(Alt+5): More options...")
	print("---------------------------------------------------------------------------------")
end


local function ShowSubmenu1()
	
	current_menu = 1

	print(strMainName1 .. " " .. strMainName2)
	print( "-- " .. strCredits .. " - Tutorial: youtu.be/sAx-r1c24Ac --")
	print("(Alt+1): Toggle Background Stage Selector")
	print("(Alt+2): Display/Hide Hitboxes")
	print("(Alt+3): Display/Hide Scrolling Input")
	print("(Alt+4): Display/Hide Joystick Input")
	print("(Alt+5): Return main menu...")
	print("---------------------------------------------------------------------------------")
end


--Hot Keys
input.registerhotkey(1, function()

	if current_menu==0 then
		menuOpcion[1][3] = EnableTraining(1)
	else
		menuOpcion[5][3] = StageSelector(1)
	end
end)

input.registerhotkey(2, function()

	if current_menu==0 then
		menuOpcion[2][3] = LockActions(1)
	else
		menuOpcion[6][3] = EnableHitboxes(1)
	end
end)

input.registerhotkey(3, function()

	if current_menu==0 then
		menuOpcion[3][3] = EnableMacroActions(1)
	else
		menuOpcion[7][3] = InputDisplay1(1)
	end
end)

input.registerhotkey(4, function()

	if current_menu==0 then		
		menuOpcion[4][3] = ToggleHUD(1)
	else
		menuOpcion[8][3] = InputDisplay2(1)
	end
end)

input.registerhotkey(5, function()
	
	if current_menu==0 then
		ShowSubmenu1()
	else
		ShowMainMenu()
	end
end)

----------------------------------------------------------------------------------------------------
--Main loop
----------------------------------------------------------------------------------------------------
ShowMainMenu()
LoadVisualMenuOptions()

while true do
	-- Draw these functions on the same frame data is read
	gui.register(function()
		--Hitbox rendering
		hitbox.DrawHitboxes()

		--Scrolling Input display
		input_display.Show()

		-- Training Script stuff
		training.training_logic()

		-- Toggle background stage
		stage_selector.select_background_stage()

		-- ST HUD
		sf2hud.render_hud()

		-- lock actions for player 1 and 2
		lock_actions.lock_actions()
		
		-- Macro Actions
		macro_actions.MacroActions()

		fightstick_input.Fightstick_Show()

		-- Show Visual Menu
		ShowVisualMenu()
	end)
	--Pause the script until the next frame
	emu.frameadvance()
end

