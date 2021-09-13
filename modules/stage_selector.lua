lib = {}

local stage_selector = -1

function lib.toggle_background_stage()
	if stage_selector == -1 then
		return
	end

	if romname=="ssf2t" then
		--ssf2x ssf2t
		cond = memory.readbyte(0xff8008)
		if cond == 0x04 then
			memory.writebyte(0xff8c4f,stage_selector)
		end
		memory.writebyte(0xFF8C51,0)
		memory.writeword(0xFFE18A,stage_selector)
	else
		--sf2ce, sf2hf
		memory.writeword( game.training_logic.A20,stage_selector)
	end
end

----------------------------------------------------------------------------------------------------
-- hotkey function
----------------------------------------------------------------------------------------------------
function lib.StageSelector()
	
	if stage_selector >= game.max_stage then
		stage_selector=-1
	end
	stage_selector = stage_selector + 1
	if stage_selector == 0 then
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
	else
		return stage_selector
	end
end

return lib