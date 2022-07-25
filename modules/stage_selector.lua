lib = {}

--local stage_selector = game.number_of_stages + 1 -- Default value: Random stage
local stage_selector = game.number_of_stages -- Default value: Disabled
local stage_selected = 0
local prev_is_p1_human
local prev_is_p2_human
local is_p1_human = 0
local is_p2_human = 0
local is_first_match = true

-- random seed
math.randomseed(os.clock()*100000000000)

function toggle_background_stage()

	if romname=="ssf2t" then
		--ssf2x ssf2t
		cond = memory.readbyte(0xff8008)
		if cond == 0x04 then
			memory.writebyte(0xff8c4f,stage_selected)
		end
		memory.writebyte(0xFF8C51,0)
		memory.writeword(0xFFE18A,stage_selected)
	else
		--sf2ce, sf2hf

		if is_first_match  then
			memory.writeword( game.training_logic.A20,stage_selected)
		else
			-- Select stage for sf2ce and sd2hf
			-- Code by Mezdap
			-- http://www.mamecheat.co.uk/forums/viewtopic.php?f=4&t=12820
			temp0=memory.readword(0xFFDD5E)
			temp1=memory.readbyte(0xFF89D7)
			temp2=0xFF89BF
			temp3=memory.readbyte(0xFF896C)		
			memory.writebyte(0xFF866C, temp3)

			-- allow continue stage 
			if stage_selected < 0xC then
				memory.writebyte(0xFF89F5, stage_selected)
			end

			-- allow skip stage
			if temp0 == stage_selected then
				temp2 = stage_selected
			end

			-- same background
			memory.writeword(0xFFDD5E, stage_selected)
			memory.writeword(0xFFDD60, stage_selected)
			memory.writeword(0xFFDD62, stage_selected)
			memory.writeword(0xFFDD64, stage_selected)
			memory.writeword(0xFFDD66, stage_selected)
			memory.writeword(0xFFDD68, stage_selected)
			memory.writeword(0xFFDD6A, stage_selected)
			memory.writeword(0xFFDD6C, stage_selected)
			memory.writeword(0xFFDD6E, stage_selected)
			memory.writeword(0xFFDD70, stage_selected)
			memory.writeword(0xFFDD72, stage_selected)
			memory.writeword(0xFFDD74, stage_selected)

			-- disabled ending and bonus stages
			memory.writebyte(0xFF89C1, 0x00)
			memory.writebyte(0xFF89D4, 0x00)
		end

	end

	--print("Stage: ".. stage_selected)	
end


function calculate_stage()
	
	if stage_selector == game.number_of_stages then
		-- No valid stage selected
		return
	elseif stage_selector == game.number_of_stages+1 then

		-- random stage
		stage_selected = math.random(0, game.number_of_stages-1)
	else
		-- select current stage
		stage_selected = stage_selector
	end
end

function lib.select_background_stage()	

	
	if stage_selector == game.number_of_stages then
		-- No valid stage selected
		return
	end

	if is_first_match then
		toggle_background_stage()
	end

	prev_is_p1_human = is_p1_human
	prev_is_p2_human = is_p2_human

	is_p1_human = memory.readbyte(game.training_logic.IsPlayer1Human)
	is_p2_human = memory.readbyte(game.training_logic.IsPlayer2Human)

	--print(is_p1_human .. "-" .. is_p2_human)

	-- select stage at the end of the match
	if (((is_p1_human==1 and is_p2_human==0) or (is_p1_human==0 and is_p2_human==1) ) and (prev_is_p1_human==1 and prev_is_p2_human==1) ) then
		is_first_match = false
		calculate_stage()
		toggle_background_stage()
	end	
end

----------------------------------------------------------------------------------------------------
-- hotkey function
----------------------------------------------------------------------------------------------------
function lib.StageSelector(incrementCounter)

	stage_selector = stage_selector + incrementCounter

	if stage_selector > game.number_of_stages+1 then
		stage_selector=0
	elseif stage_selector < 0 then
		stage_selector = game.number_of_stages+1
	end

	-- reselect stage
	calculate_stage()
	toggle_background_stage()

	if stage_selector == game.number_of_stages+1 then
		-- Random stage
		return "Random"
	elseif stage_selector == game.number_of_stages then
		return "Disabled"
	elseif stage_selector == 0 then
		return "Japan (Ryu)"
	elseif stage_selector == 1 then
		return "Japan (Honda)"
	elseif stage_selector == 2 then
		return "Brazil (Blanka)"
	elseif stage_selector == 3 then
		return "USA (Guile)"
	elseif stage_selector == 4 then
		return "USA (Ken)"
	elseif stage_selector == 5 then
		return "China (Chun-Li)"
	elseif stage_selector == 6 then
		return "USSR (Zangief)"
	elseif stage_selector == 7 then
		return "India (Dhalsim)"
	elseif stage_selector == 8 then
		return "Thailand (Dictator)"
	elseif stage_selector == 9 then
		return "Thailand (Sagat)"
	elseif stage_selector == 0xa then
		return "USA (Boxer)"
	elseif stage_selector == 0xb then
		return "Spain (Claw)"
	elseif stage_selector == 0xc then
		return "England (Cammy)"
	elseif stage_selector == 0xd then
		return "Mexico (T.Hawk)"
	elseif stage_selector == 0xe then
		return "HongKong (Fei-Long)"
	elseif stage_selector == 0xf then
		return "Jamaica (DeeJay)"
	end
	
end

return lib