lib = {}

local lock_action_param
local lock_action_selector = 0
local current_frame = 0

local actions = {
	{ 0x00,  "Neutral (Stand)" },
	{ 0xfd,  "Block Everything" },
	--{ 0xfc,  "Block Ground Attacks" },
	{ 0x08,  "Up (Jump)" },
	{ 0x09,  "Up-Right" },
	{ 0x0A,  "Up-Left" },
	{ 0x04,  "Down (Crouch)" },
	{ 0x05,  "Down-Right" },
	{ 0x06,  "Down-Left" },
	{ 0x01,  "Right" },
	{ 0x02,  "Left" },
	{ 0xff,  "Throw-Right (fierce throw)" },
	{ 0xfe,  "Throw-Left (fierce throw)" },
}


-- bitwise AND operator
function band(a, b)
   local r, m, s = 0, 2^31

   local oper = 4 -- OR(oper=1), XOR(oper=2), AND(oper=4)
   repeat
      s,a,b = a+b+m, a%m, b%m
      r,m = r + m*oper%(s-a-b), m/2
   until m < 1
   return r
end


function lib.lock_actions()

	if current_frame >= 59 then
		current_frame = 0
	end
	current_frame = current_frame + 1
	
	if lock_action_selector == 0 then
		return
	end

	if romname=="ssf2t" then

		-- only works on ssf2

		-- Throw-Right (fierce throw)
		if lock_action_param ==  0xFF and current_frame%2==0 then	
			memory.writeword(game.training_logic.LA1,0x0001)
		end
		if lock_action_param ==  0xFF and current_frame%2~=0 then
			memory.writeword(game.training_logic.LA1,0x0041)
		end

		-- Throw-Left (fierce throw)
		if lock_action_param ==  0xFE and current_frame%2==0 then
			memory.writeword(game.training_logic.LA1,0x0002)
		end
		if lock_action_param ==  0xFE and current_frame%2~=0 then
			memory.writeword(game.training_logic.LA1,0x0042)
		end
	end

	-- Auto-moves "Candado"
	if lock_action_param <  0x0F then
		memory.writebyte(game.training_logic.LAaction,lock_action_param)
	end	

	-- block everything 1 --	
	if lock_action_param==0xFD or lock_action_param==0xFC then

		-- block ground attacks --

		LA6 = memory.readbyte(game.training_logic.LA6) 
		LA7 = memory.readbyte(game.training_logic.LA7) 
		LA8 = memory.readbyte(game.training_logic.LA8)
	
		if LA6==0  then -- neutral when opponent is neutral

			memory.writeword(game.training_logic.LA1,0x0000)

		elseif LA6==0xA or LA6==0xC then -- if opponent attacking and pressing down, block low (on P1 side)
			
			bandLA7 = band(LA7,4)			

			-- if opponent attacking and pressing down, block low (on P1 side
			if bandLA7==4 and LA8==0 then
				memory.writeword(game.training_logic.LA1,0x0005)
			end
			
			-- if opponent attacking and pressing down, block low (on P2 side)
			if bandLA7==4 and LA8==1 then
				memory.writeword(game.training_logic.LA1,0x0006)
			end

			-- if opponent attacking and not pressing down, block high (on P1 side)
			if bandLA7~=4 and LA8==0 then
				memory.writeword(game.training_logic.LA1,0x0001)
			end

			-- if opponent attacking and not pressing down, block high (on P2 side)
			if bandLA7~=4 and LA8==1 then
				memory.writeword(game.training_logic.LA1,0x0002)
			end
		end
	
	end

	-- block everything 2 --
	if lock_action_param==0xFD then
		
		-- jump attacks (LA6==4) --

		if LA6==0x4 then

			LA9 = memory.readword(game.training_logic.LA9) 
			LA10 = memory.readword(game.training_logic.LA10)			
			

			-- block high if the opponent is at close range (<0xF) on P1 side 
			if ( LA9-LA10 < 0xF) and LA8==0 then
				memory.writeword(game.training_logic.LA1,0x0001)
			end
			
			-- block high if the opponent is at close range (<0xF) on P2 side
			if ( LA10-LA9 < 0xF) and LA8==1 then
				memory.writeword(game.training_logic.LA1,0x0002)
			end

			-- stop blocking if the opponent is farther than 0x20 on P1 side 
			if ( LA9-LA10 > 0x20) and LA8==0 then
				memory.writeword(game.training_logic.LA1,0x0000)
			end

			-- stop blocking if the opponent is farther than 0x20 on P2 side
			if ( LA10-LA9 > 0x20) and LA8==1 then
				memory.writeword(game.training_logic.LA1,0x0000)
			end
		
			-- ... except if: the opponent hits any kick or punch button

			--[[ Disabled because the code produces unexpected behavior
			
			LA11 = memory.readword(game.training_logic.LA11) 

			if band(LA11,0xFFF1)~=0 and LA8==0 then

				memory.writeword(game.training_logic.LA1,0x0001)
			end
	
			if band(LA11,0xFFF1)~=0 and LA8==1 then	
				memory.writeword(game.training_logic.LA1,0x0002)
			end
			]]--

			--... and do not block when the opponent is so far that he can't reach us with a jumping normal attack

			if ( LA9-LA10 > 0x70) and LA8==0 then
				memory.writeword(game.training_logic.LA1,0x0000)
			end
	
			if ( LA10-LA9 > 0x70) and LA8==1 then
				memory.writeword(game.training_logic.LA1,0x0000)
			end

		end
			
	end

end


----------------------------------------------------------------------------------------------------
-- hotkey function
----------------------------------------------------------------------------------------------------
function lib.LockActions(incrementCounter)

	-- Auto-block and auto-moves for player 2 (Candado Training Mode)

	lock_action_selector = lock_action_selector + incrementCounter
	
	if lock_action_selector >= game.look_actions_count then
		lock_action_selector=0
	elseif lock_action_selector<0 then
		lock_action_selector=game.look_actions_count-1
	end	
	
	if lock_action_selector == 0 then
		-- off lock actions
		memory.writeword(game.training_logic.LA1,0x0)
		memory.writeword(game.training_logic.LA2,game.training_logic.LAoff1)
		memory.writeword(game.training_logic.LA3,game.training_logic.LAoff2)
		memory.writeword(game.training_logic.LA4,game.training_logic.LAoff3)
		memory.writeword(game.training_logic.LA5,game.training_logic.LAoff4)
		return "Disabled"
	else
		-- on lock actions
		memory.writeword(game.training_logic.LA2,game.training_logic.LAon)
		memory.writeword(game.training_logic.LA3,game.training_logic.LAon)
		memory.writeword(game.training_logic.LA4,game.training_logic.LAon)
		memory.writeword(game.training_logic.LA5,game.training_logic.LAon)
	end	
	
	lock_action_param = actions[lock_action_selector][1]

	-- action name
	return actions[lock_action_selector][2]	
end

return lib