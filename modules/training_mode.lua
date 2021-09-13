---------------------------------------
-- Training mode
-- credits: Pof/Yacsha
---------------------------------------
local lib =  {}

local training_mode = 0
local DELAY=0x0a    -- from 0 to ff (set to ff to disable)
local p1timer=0
local p2timer=0
local p1counter = 32
local p2counter = 32

function lib.training_logic()	
	
	if lib.training_mode == 0 then
		return
	end

	if lib.training_mode == 2 then
		--  Never get dizzied - Dizzy OFF
		memory.writeword(game.training_logic.A17a,0)
		memory.writeword(game.training_logic.A17b,0)
		memory.writeword(game.training_logic.A18a,0)
		memory.writeword(game.training_logic.A18b,0)
	end

	if lib.training_mode == 3 then
		-- Always get dizzie - Dizzy ON
		memory.writeword(game.training_logic.A17a,0x40)
		memory.writeword(game.training_logic.A17b,0x40)
		memory.writeword(game.training_logic.A18a,0x40)
		memory.writeword(game.training_logic.A18b,0x40)
	end

	-- infinite time
	timer = memory.readbyte(game.training_logic.A19)
	if (timer < 0x98) then
		memory.writeword(game.training_logic.A19,0x9928)
	end

	c1 = memory.readbyte(game.training_logic.C1)--(4)=(1)-27
	c2 = memory.readword(game.training_logic.C2)--(5)=(1)+2
	c3 = memory.readbyte(game.training_logic.C3)--(4)+400
	c4 = memory.readword(game.training_logic.C4)--(5)+400
	c5 = memory.readbyte(game.training_logic.C5)--(6)=(3)+1
	c6 = memory.readbyte(game.training_logic.C6)--(6)+400

	-- timers
	if c1 == 0x14 or c1 == 0xe then
		p1timer=DELAY
	end
	if c3 == 0x14 or c3 == 0xe then
		p2timer=DELAY
	end
	if p1timer > 0 and DELAY ~= 0xff then
		p1timer=p1timer-1
	end
	if p2timer > 0 and DELAY ~= 0xff then
		p2timer=p2timer-1
	end



	-- method1: recharge energy when opponent is idle/crouching and we're not blocking or after being hit/thrown
	if ((c1 ~= 0x14 and c1 ~= 0xe and c1 ~= 8) and c2 < 90 and (c3==2 or c3==0) and p1timer==0) then
		memory.writeword(game.training_logic.A1,0x90)--(1)
		memory.writeword(game.training_logic.A2,0x90)--(2)
		memory.writeword(game.training_logic.A3,0x90)--(3)
	end
	if ((c3 ~= 0x14 and c3 ~= 0xe and c3 ~= 8) and c4 < 90 and (c1==2 or c1==0) and p2timer==0) then
		memory.writeword(game.training_logic.A5,0x90)--(1)+400
		memory.writeword(game.training_logic.A6,0x90)--(2)+400
		memory.writeword(game.training_logic.A7,0x90)--(3)+400
	end
	
	if romname=="ssf2t" then
		-- These options are not supported with the dizzy in sf2ce/sf2hf 

		-- method2: recharge energy when round is about to end
		if (c2 < 0xa and (c1 == 0x14 or c1 == 0xe) and p1counter == 0) or (c5 < 2) or (c2 < 2) then
			memory.writeword(game.training_logic.A1,0x90)--(1)
			memory.writeword(game.training_logic.A2,0x90)--(2)
			memory.writeword(game.training_logic.A3,0x90)--(3)
			memory.writebyte(game.training_logic.C7,0)
			p1counter = 32
		end
		if (c4 < 0xa and (c3 == 14 or c3 == 0xe) and p2counter == 0) or (c6 < 2) or (c4 < 2) then
			memory.writeword(game.training_logic.A5,0x90)--(1)+400
			memory.writeword(game.training_logic.A6,0x90)--(2)+400
			memory.writeword(game.training_logic.A7,0x90)--(3)+400
			memory.writebyte(game.training_logic.C7,0)--(7) FF82E2
			p2counter = 32
		end

		-- fix glitches with stun/dizzy & disable KO slowdown when recharging energy using method2
		if p1counter > 0 then
			memory.writebyte(game.training_logic.A8,0)
			memory.writeword(game.training_logic.A9,0)
			memory.writeword(game.training_logic.A10,0)
			memory.writebyte(game.training_logic.C7,0)
			p1counter = p1counter - 1
		end
	
		if p2counter > 0 then
			memory.writebyte(game.training_logic.A11,0)
			memory.writeword(game.training_logic.A12,0)
			memory.writeword(game.training_logic.A13,0)
			memory.writebyte(game.training_logic.C7,0)
			p2counter = p2counter - 1
		end
		
		-- infinite super
		if (memory.readword(game.training_logic.A14) == 0xa) then
			memory.writebyte(game.training_logic.A15,0x30)
			memory.writebyte(game.training_logic.A16,0x30)
		end		
	end
	return
end

----------------------------------------------------------------------------------------------------
-- hotkey function
----------------------------------------------------------------------------------------------------
function lib.EnableTraining()
	training_mode = training_mode + 1
	if training_mode > 3 then
		training_mode = 0
	end
	if training_mode == 0 then
		--print("> Training mode Disabled")
		return "Disabled"
	elseif training_mode  == 1 then
		--print("> Training mode Enabled") -- Normal Dizzy
		return "Enabled"
	elseif training_mode  == 2 then
		--print("> Training mode Enabled: Never get dizzied") -- Dizzy OFF
		return "Enabled: Never get dizzied"
	elseif training_mode  == 3 then
		--print("> Training mode Enabled: Always get dizzied") -- Dizzy ON
		return "Enabled: Always get dizzied"
	end
end

return lib