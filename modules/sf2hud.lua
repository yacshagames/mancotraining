-- SF2 HUD - Heads-Up Display for SF2 (Panel de visualización de datos)
lib = {}

----------------------------------------------------------------------------------------------------
-- Global Variables
----------------------------------------------------------------------------------------------------
local draw_hud=0 -- Default value: Hiding HUD
local stage_timer=false
local draw_hitboxes = true
local p1_projectile = false
local p2_projectile = false
local frameskip = true
----------------------------------------------------------------------------------------------------
--Miscellaneous functions
----------------------------------------------------------------------------------------------------

-- Calculate positional difference between the two dummies
local function calc_range()
	local range = 0
	if memory.readword(game.training_logic.A22x) >= memory.readword(game.training_logic.A22x+game.p2) then
		if memory.readword(game.training_logic.A22y) >= memory.readword(game.training_logic.A22y+game.p2) then
			range = (memory.readword(game.training_logic.A22x) - memory.readword(game.training_logic.A22x+game.p2)) .. "/" .. (memory.readword(game.training_logic.A22y) - memory.readword(game.training_logic.A22y+game.p2))
		else
			range = (memory.readword(game.training_logic.A22x) - memory.readword(game.training_logic.A22x+game.p2)) .. "/" .. (memory.readword(game.training_logic.A22y+game.p2) - memory.readword(game.training_logic.A22y))
		end
	else
		if memory.readword(game.training_logic.A22y+game.p2) >= memory.readword(game.training_logic.A22y) then
			range = (memory.readword(game.training_logic.A22x+game.p2) - memory.readword(game.training_logic.A22x)) .. "/" .. (memory.readword(game.training_logic.A22y+game.p2) - memory.readword(game.training_logic.A22y))
		else
			range = (memory.readword(game.training_logic.A22x+game.p2) - memory.readword(game.training_logic.A22x)) .. "/" .. (memory.readword(game.training_logic.A22y) - memory.readword(game.training_logic.A22y+game.p2))
		end
	end

	return range
end

--Determines if a projectile is still in game and if one can be exectued
local function projectile_onscreen(player)
	local text
	if player == 0 then
		if memory.readbyte(game.training_logic.ProjectileOn) > 0 then
			text = "Not Ready"
		else
			text = "Ready"
		end
	else
		if memory.readbyte(game.training_logic.ProjectileOn+game.p2) > 0 then
			text = "Not Ready"
		else
			text = "Ready"
		end
	end
	return text
end

--Determines if a special cancel can be performed after a normal move has been executed
local function check_cancel(player) 
	local text
	if player == 1 then
		if memory.readbyte(game.training_logic.SpecialCancelOn) > 0 then
			text = "Ready"
		else
			text = "Not Ready"
		end
	else
		if memory.readbyte(game.training_logic.SpecialCancelOn+game.p2) > 0 then
			text = "Ready"
		else
			text = "Not Ready"
		end
	end
	return text
end

--Determine the character being used and draw approriate readings
local function determine_char(player, char1, char2)
	local text
	if player == 1 then
		if char1 == 0x0A then
			--Balrog
			gui.text(2,65,"Ground Straight: ".. memory.readbyte(game.moves.BoxerGroundStraight))
			gui.text(2,73,"Ground Upper: " ..memory.readbyte(game.moves.BoxerGroundUpper))
			gui.text(2,81,"Straight: " .. memory.readbyte(game.moves.BoxerStraight))
			gui.text(80,65,"Upper Dash: " .. memory.readbyte(game.moves.BoxerUpperDash))
			gui.text(80,73,"Buffalo Headbutt: " .. memory.readbyte(game.moves.BoxerBuffaloHeadbutt))
			gui.text(80,81,"Crazy Buffalo: " .. memory.readbyte(game.moves.BoxerCrazyBuffalo))
			p1_projectile = false
			return
		elseif char1 == 0x02 then
			--Blanka
			gui.text(2,65,"Normal Roll: " .. memory.readbyte(game.moves.BlankaNormalRoll))
			gui.text(2,73,"Vertical Roll: " .. memory.readbyte(game.moves.BlankaVerticalRoll))
			gui.text(2,81,"Ground Shave Roll: " .. memory.readbyte(game.moves.BlankaGroundShaveRoll))
			p1_projectile = false
			return
		elseif char1 == 0x0C then
			--Cammy
			gui.text(2,65,"Spin Knuckle: " .. memory.readbyte(game.moves.CammySpinKnuckle))
			gui.text(2,73,"Cannon Spike: " .. memory.readbyte(game.moves.CammyCannonSpike))
			gui.text(2,81,"Spiral Arrow: ".. memory.readbyte(game.moves.CammySpiralArrow))
			gui.text(80,65,"Hooligan Combination: " .. memory.readbyte(game.moves.CammyHooliganCombination))
			gui.text(80,73,"Spin Drive Smasher: " .. memory.readbyte(game.moves.CammySpinDriveSmasher))
			p1_projectile = false
			return
		elseif char1 == 0x05 then
			--Chun Li
			gui.text(2,65,"Kikouken: ".. memory.readbyte(game.moves.ChunLiKikouken))
			gui.text(2,73,"Up Kicks: " .. memory.readbyte(game.moves.ChunLiUpKicks))
			gui.text(2,81,"Spinning Bird Kick: " .. memory.readbyte(game.moves.ChunLiSpinningBirdKick))
			gui.text(80,65,"Senretsu Kyaku: " .. memory.readbyte(game.moves.ChunLiSenretsuKyaku))
			p1_projectile = true
			return
		elseif char1 == 0x0F then
			--Dee Jay
			gui.text(2,65,"Air Slasher: " .. memory.readbyte(game.moves.DeeJayAirSlasher))
			gui.text(2,73,"Sovat Kick: " .. memory.readbyte(game.moves.DeeJaySovatKick))
			gui.text(2,81,"Jack Knife: ".. memory.readbyte(game.moves.DeeJayJackKnife))
			gui.text(80,65,"Machine Gun Upper: " .. memory.readbyte(game.moves.DeeJayMachineGunUpper))
			gui.text(80,73,"Sovat Carnival: " .. memory.readbyte(game.moves.DeeJaySovatCarnival))
			p1_projectile = true
			return
		elseif char1 == 0x07 then  
			--Dhalsim
			gui.text(2,65,"Yoga Blast: " .. memory.readbyte(game.moves.DhalsimYogaBlast))
			gui.text(2,73,"Yoga Flame: " .. memory.readbyte(game.moves.DhalsimYogaFlame))
			gui.text(2,81,"Yoga Fire: " .. memory.readbyte(game.moves.DhalsimYogaFire))
			gui.text(80,65,"Yoga Teleport: ".. memory.readbyte(game.moves.DhalsimYogaTeleport))
			gui.text(80,73,"Yoga Inferno: " .. memory.readbyte(game.moves.DhalsimYogaInferno))	
			p1_projectile = true
			return
		elseif char1 == 0x01 then
			--Honda
			gui.text(2,65,"Flying Headbutt: " .. memory.readbyte(game.moves.HondaFlyingHeadbutt))
			gui.text(2,73,"Butt Drop: " .. memory.readbyte(game.moves.HondaButtDrop))
			gui.text(2,81,"Oichio Throw: " .. memory.readbyte(game.moves.HondaOichioThrow))
			gui.text(80,65, "Double Headbutt: " .. memory.readbyte(game.moves.HondaDoubleHeadbutt))
			p1_projectile = false
			return
		elseif char1 == 0x0E then
			--Fei Long
			gui.text(2,65,"Rekka: " .. memory.readbyte(game.moves.FeiLongRekka))
			gui.text(2,73,"Rekka 2: " .. memory.readbyte(game.moves.FeiLongRekka2))
			gui.text(2,81,"Flame Kick: " .. memory.readbyte(game.moves.FeiLongFlameKick))
			gui.text(80,65,"Chicken Wing: " .. memory.readbyte(game.moves.FeiLongChickenWing))
			gui.text(80,73,"Rekka Sinken: " .. memory.readbyte(game.moves.FeiLongRekkaSinken))
			p1_projectile = false
			return
		elseif char1 == 0x03 then 
			--Guile
			gui.text(2,65,"Sonic Boom: " .. memory.readbyte(game.moves.GuileSonicBoom))
			gui.text(2,73,"Flash Kick: " .. memory.readbyte(game.moves.GuileFlashKick))
			gui.text(2,81,"Double Somersault: " .. memory.readbyte(game.moves.GuileDoubleSomersault))
			p1_projectile = true
			return
		elseif char1 == 0x04 then 
			--Ken
			gui.text(2,65, "Hadouken: ".. memory.readbyte(game.moves.KenHadouken))
			gui.text(2,73, "Shoryuken: " .. memory.readbyte(game.moves.KenShoryuken))
			gui.text(2,81, "Hurricane Kick: " .. memory.readbyte(game.moves.KenHurricaneKick))
			gui.text(42,89, "Shoryureppa: " .. memory.readbyte(game.moves.KenShoryureppa))
			gui.text(80,65, "Crazy Kick 1: " .. memory.readbyte(game.moves.KenCrazyKick1))
			gui.text(80,73, "Crazy Kick 2: " .. memory.readbyte(game.moves.KenCrazyKick2))
			gui.text(80,81, "Crazy Kick 3: " .. memory.readbyte(game.moves.KenCrazyKick3))
			p1_projectile = true
			return
		elseif char1 == 0x08 then 
			--Dictator
			gui.text(2,65,"Scissor Kick: " .. memory.readbyte(game.moves.DictatorScissorKick))
			gui.text(2,73,"Head Stomp: ".. memory.readbyte(game.moves.DictatorHeadStomp))
			gui.text(2,81,"Devil's Reverse: " .. memory.readbyte(game.moves.DictatorDevilsReverse))
			gui.text(80,65,"Psycho Crusher: " .. memory.readbyte(game.moves.DictatorPsychoCrusher))
			gui.text(80,73,"Knee Press Knightmare: " .. memory.readbyte(game.moves.DictatorKneePressKnightmare))
			p1_projectile = false
			return
		elseif char1 == 0x00 then 
			--Ryu
			gui.text(2,65,"Hadouken: " .. memory.readbyte(game.moves.RyuHadouken))
			gui.text(2,73,"Shoryuken: " .. memory.readbyte(game.moves.RyuShoryuken))
			gui.text(2,81, "Hurricane Kick: " .. memory.readbyte(game.moves.RyuHurricaneKick))
			gui.text(80,65, "Red Hadouken: " .. memory.readbyte(game.moves.RyuRedHadouken))
			gui.text(80,73, "Shinku Hadouken: " .. memory.readbyte(game.moves.RyuShinkuHadouken))
			p1_projectile = true
		elseif char1 == 0x09 then 
			--Sagat
			gui.text(2,65,"Tiger Shot: " .. memory.readbyte(game.moves.SagatTigerShot))
			gui.text(2,73,"Tiger Knee: " .. memory.readbyte(game.moves.SagatTigerKnee))
			gui.text(2,81,"Tiger Uppercut: " .. memory.readbyte(game.moves.SagatTigerUppercut))
			gui.text(80,65, "Tiger Genocide: " .. memory.readbyte(game.moves.SagatTigerGenocide))
			p1_projectile = true
			return
		elseif char1 == 0x0D then  
			--T.Hawk
			gui.text(2,65,"Mexican Typhoon: " .. memory.readbyte(game.moves.THawkMexicanTyphoon1) .. ", " .. memory.readbyte(game.moves.THawkMexicanTyphoon2))
			gui.text(2,73,"Tomahawk: " .. memory.readbyte(game.moves.THawkTomahawk))
			gui.text(2,81,"Double Typhoon: " .. memory.readbyte(game.moves.THawkDoubleTyphoon1) .. ", " .. memory.readbyte(game.moves.THawkDoubleTyphoon2))
			p1_projectile = false
			return
		elseif char1 == 0x0B then 
			--Claw
			gui.text(2,65,"Wall Dive (Kick): " .. memory.readbyte(game.moves.ClawWallDiveKick))
			gui.text(2,73,"Wall Dive (Punch): " .. memory.readbyte(game.moves.ClawWallDivePunch))
			gui.text(2,81,"Crystal Flash: " .. memory.readbyte(game.moves.ClawCrystalFlash))
			gui.text(90,65,"Flip Kick: " .. memory.readbyte(game.moves.ClawFlipKick))
			gui.text(90,73,"Rolling Izuna Drop: " .. memory.readbyte(game.moves.ClawRollingIzunaDrop))
			p1_projectile = false
			return
		elseif char1 == 0x06 then 
			--Zangief
			gui.text(2,65, "Bear Grab: " .. memory.readbyte(game.moves.ZangiefBearGrab1) ..  ", " .. memory.readbyte(game.moves.ZangiefBearGrab2))
			gui.text(2,73, "Spinning Pile Driver: " .. memory.readbyte(game.moves.ZangiefSpinningPileDriver1) .. ", " .. memory.readbyte(game.moves.ZangiefSpinningPileDriver2))
			gui.text(2,81, "Banishing Flat: " .. memory.readbyte(game.moves.ZangiefBanishingFlat))
			gui.text(2,89, "Final Atomic Buster: " .. memory.readbyte(game.moves.ZangiefFinalAtomicBuster1) .. ", " .. memory.readbyte(game.moves.ZangiefFinalAtomicBuster2))
			p1_projectile = false
			return
		end
	else
		if char2 == 0x0A then
			--Balrog
			gui.text(230,65,"Ground Straight: ".. memory.readbyte(game.moves.BoxerGroundStraight+game.p2))
			gui.text(230,73,"Ground Upper: " ..memory.readbyte(game.moves.BoxerGroundUpper+game.p2))
			gui.text(230,81,"Straight: " .. memory.readbyte(game.moves.BoxerStraight+game.p2))
			gui.text(307,65,"Upper Dash: " .. memory.readbyte(game.moves.BoxerUpperDash+game.p2))
			gui.text(307,73,"Buffalo Headbutt: " .. memory.readbyte(game.moves.BoxerBuffaloHeadbutt+game.p2))
			gui.text(307,81,"Crazy Buffalo: " .. memory.readbyte(game.moves.BoxerCrazyBuffalo+game.p2))
			p1_projectile = false
			return
		elseif char2 == 0x02 then
			--Blanka
			gui.text(302,65,"Normal Roll: " .. memory.readbyte(game.moves.BlankaNormalRoll+game.p2))
			gui.text(302,73,"Vertical Roll: " .. memory.readbyte(game.moves.BlankaVerticalRoll+game.p2))
			gui.text(302,81,"Ground Shave Roll: " .. memory.readbyte(game.moves.BlankaGroundShaveRoll+game.p2))
			p1_projectile = false
			return
		elseif char2 == 0x0C then
			--Cammy
			gui.text(218,65,"Spin Knuckle: " .. memory.readbyte(game.moves.CammySpinKnuckle+game.p2))
			gui.text(218,73,"Cannon Spike: " .. memory.readbyte(game.moves.CammyCannonSpike+game.p2))
			gui.text(218,81,"Spiral Arrow: ".. memory.readbyte(game.moves.CammySpiralArrow+game.p2))
			gui.text(290,65,"Hooligan Combination: " .. memory.readbyte(game.moves.CammyHooliganCombination+game.p2))
			gui.text(290,73,"Spin Drive Smasher: " .. memory.readbyte(game.moves.CammySpinDriveSmasher+game.p2))
			p1_projectile = false
			return
		elseif char2 == 0x05 then
			--Chun Li
			gui.text(233,65,"Kikouken: ".. memory.readbyte(game.moves.ChunLiKikouken+game.p2))
			gui.text(233,73,"Up Kicks: " .. memory.readbyte(game.moves.ChunLiUpKicks+game.p2))
			gui.text(233,81,"Spinning Bird Kick: " .. memory.readbyte(game.moves.ChunLiSpinningBirdKick+game.p2))
			gui.text(313,65,"Senretsu Kyaku: " .. memory.readbyte(game.moves.ChunLiSenretsuKyaku+game.p2))
			p1_projectile = true
			return
		elseif char2 == 0x0F then
			--Dee Jay
			gui.text(223,65,"Air Slasher: " .. memory.readbyte(game.moves.DeeJayAirSlasher+game.p2))
			gui.text(223,73,"Sovat Kick: " .. memory.readbyte(game.moves.DeeJaySovatKick+game.p2))
			gui.text(223,81,"Jack Knife: ".. memory.readbyte(game.moves.DeeJayJackKnife+game.p2))
			gui.text(303,65,"Machine Gun Upper: " .. memory.readbyte(game.moves.DeeJayMachineGunUpper+game.p2))
			gui.text(303,73,"Sovat Carnival: " .. memory.readbyte(game.moves.DeeJaySovatCarnival+game.p2))
			p1_projectile = true
			return
		elseif char2 == 0x07 then  
			--Dhalsim
			gui.text(223,65,"Yoga Blast: " .. memory.readbyte(game.moves.DhalsimYogaBlast+game.p2))
			gui.text(223,73,"Yoga Flame: " .. memory.readbyte(game.moves.DhalsimYogaFlame+game.p2))
			gui.text(223,81,"Yoga Fire: " .. memory.readbyte(game.moves.DhalsimYogaFire+game.p2))
			gui.text(303,65,"Yoga Teleport: ".. memory.readbyte(game.moves.DhalsimYogaTeleport+game.p2))
			gui.text(303,73,"Yoga Inferno: " .. memory.readbyte(game.moves.DhalsimYogaInferno+game.p2))	
			p1_projectile = true
			return
		elseif char2 == 0x01 then
			--Honda
			gui.text(223,65,"Flying Headbutt: " .. memory.readbyte(game.moves.HondaFlyingHeadbutt+game.p2))
			gui.text(223,73,"Butt Drop: " .. memory.readbyte(game.moves.HondaButtDrop+game.p2))
			gui.text(223,81,"Oichio Throw: " .. memory.readbyte(game.moves.HondaOichioThrow+game.p2))
			gui.text(303,65, "Double Headbutt: " .. memory.readbyte(game.moves.HondaDoubleHeadbutt+game.p2))
			p1_projectile = false
			return
		elseif char2 == 0x0E then
			--Fei Long
			gui.text(242,65,"Rekka: " .. memory.readbyte(game.moves.FeiLongRekka+game.p2))
			gui.text(242,73,"Rekka 2: " .. memory.readbyte(game.moves.FeiLongRekka2+game.p2))
			gui.text(242,81,"Flame Kick: " .. memory.readbyte(game.moves.FeiLongFlameKick+game.p2))
			gui.text(322,65,"Chicken Wing: " .. memory.readbyte(game.moves.FeiLongChickenWing+game.p2))
			gui.text(322,73,"Rekka Sinken: " .. memory.readbyte(game.moves.FeiLongRekkaSinken+game.p2))
			p1_projectile = false
			return
		elseif char2 == 0x03 then 
			--Guile
			gui.text(302,65,"Sonic Boom: " .. memory.readbyte(game.moves.GuileSonicBoom+game.p2))
			gui.text(302,73,"Flash Kick: " .. memory.readbyte(game.moves.GuileFlashKick+game.p2))
			gui.text(302,81,"Double Somersault: " .. memory.readbyte(game.moves.GuileDoubleSomersault+game.p2))
			p1_projectile = true
			return
		elseif char2 == 0x04 then 
			--Ken
			gui.text(223,65, "Hadouken: ".. memory.readbyte(game.moves.KenHadouken+game.p2))
			gui.text(223,73, "Shoryuken: " .. memory.readbyte(game.moves.KenShoryuken+game.p2))
			gui.text(223,81, "Hurricane Kick: " .. memory.readbyte(game.moves.KenHurricaneKick+game.p2))			
			gui.text(272,89, "Shoryureppa: " .. memory.readbyte(game.moves.KenShoryureppa+game.p2))
			gui.text(322,65, "Crazy Kick 1: " .. memory.readbyte(game.moves.KenCrazyKick1+game.p2))
			gui.text(322,73, "Crazy Kick 2: " .. memory.readbyte(game.moves.KenCrazyKick2+game.p2))
			gui.text(322,81, "Crazy Kick 3: " .. memory.readbyte(game.moves.KenCrazyKick3+game.p2))			
			p1_projectile = true
			return
		elseif char2 == 0x08 then 
			--Dictator
			gui.text(217,65,"Scissor Kick: " .. memory.readbyte(game.moves.DictatorScissorKick+game.p2))
			gui.text(217,73,"Head Stomp: ".. memory.readbyte(game.moves.DictatorHeadStomp+game.p2))
			gui.text(217,81,"Devil's Reverse: " .. memory.readbyte(game.moves.DictatorDevilsReverse+game.p2))
			gui.text(290,65,"Psycho Crusher: " .. memory.readbyte(game.moves.DictatorPsychoCrusher+game.p2))
			gui.text(290,73,"Knee Press Knightmare: " .. memory.readbyte(game.moves.DictatorKneePressKnightmare+game.p2))
			p1_projectile = false
			return
		elseif char2 == 0x00 then 
			--Ryu
			gui.text(210,65,"Hadouken: " .. memory.readbyte(game.moves.RyuHadouken+game.p2))
			gui.text(210,73,"Shoryuken: " .. memory.readbyte(game.moves.RyuShoryuken+game.p2))
			gui.text(210,81, "Hurricane Kick: " .. memory.readbyte(game.moves.RyuHurricaneKick+game.p2))
			gui.text(310,65, "Red Hadouken: " .. memory.readbyte(game.moves.RyuRedHadouken+game.p2))
			gui.text(310,73, "Shinku Hadouken: " .. memory.readbyte(game.moves.RyuShinkuHadouken+game.p2))
			p1_projectile = true
		elseif char2 == 0x09 then 
			--Sagat
			gui.text(214,65,"Tiger Shot: " .. memory.readbyte(game.moves.SagatTigerShot+game.p2))
			gui.text(214,73,"Tiger Knee: " .. memory.readbyte(game.moves.SagatTigerKnee+game.p2))
			gui.text(214,81,"Tiger Uppercut: " .. memory.readbyte(game.moves.SagatTigerUppercut+game.p2))
			gui.text(314,65, "Tiger Genocide: " .. memory.readbyte(game.moves.SagatTigerGenocide+game.p2))
			p1_projectile = true
			return
		elseif char2 == 0x0D then  
			--T.Hawk
			gui.text(294,65,"Mexican Typhoon: " .. memory.readbyte(game.moves.THawkMexicanTyphoon1) .. ", " .. memory.readbyte(game.moves.THawkMexicanTyphoon2+game.p2))
			gui.text(294,73,"Tomahawk: " .. memory.readbyte(game.moves.THawkTomahawk+game.p2))
			gui.text(294,81,"Double Typhoon: " .. memory.readbyte(game.moves.THawkDoubleTyphoon1) .. ", " .. memory.readbyte(game.moves.THawkDoubleTyphoon2+game.p2))
			p1_projectile = false
			return
		elseif char2 == 0x0B then 
			--Claw
			gui.text(210,65,"Wall Dive (Kick): " .. memory.readbyte(game.moves.ClawWallDiveKick+game.p2))
			gui.text(210,73,"Wall Dive (Punch): " .. memory.readbyte(game.moves.ClawWallDivePunch+game.p2))
			gui.text(210,81,"Crystal Flash: " .. memory.readbyte(game.moves.ClawCrystalFlash+game.p2))
			gui.text(298,65,"Flip Kick: " .. memory.readbyte(game.moves.ClawFlipKick+game.p2))
			gui.text(298,73,"Rolling Izuna Drop: " .. memory.readbyte(game.moves.ClawRollingIzunaDrop+game.p2))
			p1_projectile = false
			return
		elseif char2 == 0x06 then 
			--Zangief
			gui.text(275,65, "Bear Grab: " .. memory.readbyte(game.moves.ZangiefBearGrab1) ..  ", " .. memory.readbyte(game.moves.ZangiefBearGrab2+game.p2))
			gui.text(275,73, "Spinning Pile Driver: " .. memory.readbyte(game.moves.ZangiefSpinningPileDriver1) .. ", " .. memory.readbyte(game.moves.ZangiefSpinningPileDriver2+game.p2))
			gui.text(275,81, "Banishing Flat: " .. memory.readbyte(game.moves.ZangiefBanishingFlat+game.p2))
			gui.text(275,89, "Final Atomic Buster: " .. memory.readbyte(game.moves.ZangiefFinalAtomicBuster1) .. ", " .. memory.readbyte(game.moves.ZangiefFinalAtomicBuster2+game.p2))
			p1_projectile = false
			return
		end
	end
end

local function fskip()
	if frameskip == true	then
		memory.writebyte(0xFF8CD3,0x70)
	else
		memory.writebyte(0xFF8CD3,0xFF)
	end
end

----------------------------------------------------------------------------------------------------
--Dizzy meters
----------------------------------------------------------------------------------------------------

--Determine the color of the bar based on the value (higher = darker)
local function diz_col(val,type)
	local color = 0x00000000
	
	if type == 0 then
		if val <= 5.66 then
			color = 0x00FF5DA0
			return color
		elseif val > 5.66 and val <= 11.22 then
			color = 0x54FF00A0
			return color
		elseif val > 11.22 and val <= 16.88 then
			color = 0xAEFF00A0
			return color
		elseif val > 16.88 and val <= 22.44 then
			color = 0xFAFF00A0
			return color
		elseif val > 22.4 and val <= 28.04 then
			color = 0xFF5400A0
			return color
		elseif val > 28.04 then
			color = 0xFF0026A0
			return color
		end
	else
		if val <= 10922.5 then
			color = 0x00FF5DA0
			return color
		elseif val > 10922.5 and val <= 21845 then
			color = 0x54FF00A0
			return color
		elseif val > 21845 and val <= 32767.5 then
			color = 0xAEFF00A0
			return color
		elseif val > 32767.5 and val <= 43690 then
			color = 0xFAFF00A0
			return color
		elseif val > 43690 and val <= 54612.5 then
			color = 0xFF5400A0
			return color
		elseif val > 54612.5 then
			color = 0xFF0026A0
			return color
		end
	end
end

local function draw_dizzy()

	local p1_s = memory.readbyte(game.training_logic.A8) -- 0xFF84AD
	local p1_c = memory.readword(game.training_logic.A10) -- 0xFF84AB
	local p1_d = memory.readword(game.training_logic.A9) -- 0xFF84AE
	local p1_f = memory.readword(game.training_logic.A17c) -- P1 only greater than zero in stun
	
	
	local p2_s = memory.readbyte(game.training_logic.A11) -- 0xFF88AD
	local p2_c = memory.readword(game.training_logic.A13) -- 0xFF88AB
	local p2_d = memory.readword(game.training_logic.A12) -- 0xFF88AE
	local p2_f = memory.readbyte(game.training_logic.A18c) -- P2 only greater than zero in stun	
	
	-- P1 Stun meter
	if p1_s > 0 then
		if p1_s <= 10 then
			gui.box(35,45,(35+(3.38 * p1_s)),49,diz_col(p1_s,0),0x000000FF)
		elseif p1_s > 10 and p1_s <= 20 then
			gui.box(35,45,(35+(3.38 * p1_s)),49,diz_col(p1_s,0),0x000000FF)
		elseif p1_s > 20 then
			gui.box(35,45,(35+(3.38 * p1_s)),49,diz_col(p1_s,0),0x000000FF)
		end
	end
	
	-- P1 Stun counter
	if p1_c > 0 then
		if p1_c <= 70 then
			gui.box(35,49,(35+(0.001754 * p1_c)),53,diz_col(p1_c,1),0x000000FF)
		elseif p1_c > 70 and p1_c <= 150 then
			gui.box(35,49,(35+(0.001754* p1_c)),53,diz_col(p1_c,1),0x000000FF)
		elseif p1_c > 150 then
			gui.box(35,49,(35+(0.001754 * p1_c)),53,diz_col(p1_c,1),0x000000FF)
		end
	end
	
	-- P2 Stun meter
	if p2_s > 0 then
		if p2_s <= 10 then
			gui.box(233,45,(233+(3.38 * p2_s)),49,diz_col(p2_s,0),0x000000FF)
		elseif p2_s > 10 and p2_s <= 20 then
			gui.box(233,45,(233+(3.38 * p2_s)),49,diz_col(p2_s,0),0x000000FF)
		elseif p2_s > 20 then
			gui.box(233,45,(233+(3.38 * p2_s)),49,diz_col(p2_s,0),0x000000FF)
		end
	end
	
	-- P2 Stun counter
	if p2_c > 0 then
		if p2_c <= 70 then
			gui.box(233,49,(233+(0.001754 * p2_c)),53,diz_col(p2_c,1),0x000000FF)
		elseif p2_c > 70 and p2_c <= 150 then
			gui.box(233,49,(233+(0.001754 * p2_c)),53,diz_col(p2_c,1),0x000000FF)
		elseif p2_c > 150 then
			gui.box(233,49,(233+(0.001754 * p2_c)),53,diz_col(p2_c,1),0x000000FF)
		end
	end
	
	if p1_f > 0 then
		gui.box(3,100,11,190,0x00000040,0x000000FF)
		gui.box(3,190,11,(190 - (0.428 * p1_d)),0xFF0000B0,0x00000000)
		gui.text(3,192,p1_d)
	end
	

	if p2_f > 0 then
		gui.box(370,100,378,190,0x00000040,0x000000FF)
		gui.box(370,190,378,(190 - (0.428 * p2_d)),0xFF0000B0,0x00000000)
		gui.text(365,192,p2_d)
	end
	
end

----------------------------------------------------------------------------------------------------
--Grab meters
----------------------------------------------------------------------------------------------------
count_of_zeros = false

local function draw_grab(player,p1_char,p2_char,p_gc)

local p_a = 0
local p1_hg = memory.readbyte(game.training_logic.p1_hg)
local p2_hg = memory.readbyte(game.training_logic.p1_hg+game.p2)

	if player == 0 then
	
		-- Draw the grab speed meter
		
		if p1_hg == 0x15 then
			gui.box(16,190,22,180,0xFF0C00C0,0x000000FF)
			gui.text(18,182,"1")
		elseif p1_hg == 0x12 then
			gui.box(16,190,22,170,0xFF0C00C0,0x000000FF)
			gui.text(18,172,"2")
		elseif p1_hg == 0x0F then
			gui.box(16,190,22,160,0xFF0C00C0,0x000000FF)
			gui.text(18,162,"3")
		elseif p1_hg == 0x0C then
			gui.box(16,190,22,150,0xFF0C00C0,0x000000FF)
			gui.text(18,152,"4")
		elseif p1_hg == 0x09 then
			gui.box(16,190,22,140,0xFF0C00C0,0x000000FF)
			gui.text(18,142,"5")
		elseif p1_hg == 0x06 then
			gui.box(16,190,22,130,0xFF0C00C0,0x000000FF)
			gui.text(18,132,"6")
		elseif p1_hg == 0x03 then
			gui.box(16,190,22,120,0xFF0C00FF,0x000000FF)
			gui.text(18,122,"7")
		end
		
		
		gui.box(16,120,22,190,0x00000040,0x000000FF)
		gui.line(16,130,22,130,0x000000FF,0x000000FF)
		gui.line(16,140,22,140,0x000000FF,0x000000FF)
		gui.line(16,150,22,150,0x000000FF,0x000000FF)
		gui.line(16,160,22,160,0x000000FF,0x000000FF)
		gui.line(16,170,22,170,0x000000FF,0x000000FF)
		gui.line(16,180,22,180,0x000000FF,0x000000FF)


		if p1_char == 0x04 or p1_char == 0x0D then
		--Ken thawk
		p_a = (90 / 120)
		gui.box(3,100,11,190,0x00000040,0x000000FF)
		gui.box(370,100,378,190,0x00000040,0x000000FF)
		gui.box(3,190,11,190 - (p_a * memory.readbyte(p_gc)),0xFFFF00B0,0x00000000)
		gui.box(370,190,378,190 - ((90 / 63) * memory.readbyte(game.training_logic.p1_gb+game.p2)),0xFF0000B0,0x00000000)
		gui.text(363,192,memory.readbyte(game.training_logic.p1_gb+game.p2) .. "/" .. "63")
		gui.text(1,192,memory.readbyte(p_gc) .. "/" .. "120")
		elseif p1_char == 0x02 or p1_char == 0x01 then
		--Blanka E.Honda
		p_a = (90 / 130)
		gui.box(3,100,11,190,0x00000040,0x000000FF)
		gui.box(370,100,378,190,0x00000040,0x000000FF)
		gui.box(3,190,11,190 - (p_a * memory.readbyte(p_gc)),0xFFFF00B0,0x00000000)
		gui.box(370,190,378,190 - ((90 / 63) * memory.readbyte(game.training_logic.p1_gb+game.p2)),0xFF0000B0,0x00000000)
		gui.text(363,192,memory.readbyte(game.training_logic.p1_gb+game.p2) .. "/" .. "63")
		gui.text(1,192,memory.readbyte(p_gc) .. "/" .. "130")
		elseif p1_char == 0x06 or p1_char == 0x07 then
		--Dhalsim Zangief
		p_a = (90 / 180)
		gui.box(3,100,11,190,0x00000040,0x000000FF)
		gui.box(370,100,378,190,0x00000040,0x000000FF)
		gui.box(3,190,11,190 - (p_a * memory.readbyte(p_gc)),0xFFFF00B0,0x00000000)
		gui.box(370,190,378,190 - ((90 / 63) * memory.readbyte(game.training_logic.p1_gb+game.p2)),0xFF0000B0,0x00000000)
		gui.text(363,192,memory.readbyte(game.training_logic.p1_gb+game.p2) .. "/" .. "63")
		gui.text(1,192,memory.readbyte(p_gc) .. "/" .. "180")
		elseif p1_char == 0x0A then
		--Boxer

		count = memory.readbyte(p_gc)
		if romname=="ssf2t" then
			p_a = (90 / 210)
			gui.text(355,192,memory.readbyte(p_gc) .. "/" .. "210")
		else
			p_a = (90 / 300)

			-- Boxer has a grab count of 300, which is greater than 1 byte. So a correction is applied 
			-- to the count provided by p_gc, so that the count varies from 300 to 0 in a linear way.
			local count1
			if count_of_zeros then 
				count1 = count
			else
				count1 = count + 255
			end

			if count==0  then
				count_of_zeros  = not count_of_zeros
			end
			count = count1

			gui.text(1,192,count .. "/" .. "300")
		end

		gui.box(3,100,11,190,0x00000040,0x000000FF)
		gui.box(370,100,378,190,0x00000040,0x000000FF)
		gui.box(3,190,11,190 - (p_a * count),0xFFFF00B0,0x00000000)
		gui.box(370,190,378,190 - ((90 / 63) * memory.readbyte(game.training_logic.p1_gb+game.p2)),0xFF0000B0,0x00000000)
		gui.text(363,192,memory.readbyte(game.training_logic.p1_gb+game.p2) .. "/" .. "63")
		
		end
		
	else
	
		-- Draw grab speed
		
		if p2_hg == 0x15 then
			gui.box(357,190,363,180,0xFF0C00C0,0x000000FF)
			gui.text(359,182,"1")
		elseif p2_hg == 0x12 then
			gui.box(357,190,363,170,0xFF0C00C0,0x000000FF)
			gui.text(359,172,"2")
		elseif p2_hg == 0x0F then
			gui.box(357,190,363,160,0xFF0C00C0,0x000000FF)
			gui.text(359,162,"3")
		elseif p2_hg == 0x0C then
			gui.box(357,190,363,150,0xFF0C00C0,0x000000FF)
			gui.text(359,152,"4")
		elseif p2_hg == 0x09 then
			gui.box(357,190,363,140,0xFF0C00C0,0x000000FF)
			gui.text(359,142,"5")
		elseif p2_hg == 0x06 then
			gui.box(357,190,363,130,0xFF0C00C0,0x000000FF)
			gui.text(359,132,"6")
		elseif p2_hg == 0x03 then
			gui.box(357,190,363,120,0xFF0C00C0,0x000000FF)
			gui.text(359,122,"7")
		end
		
		
		gui.box(357,190,363,120,0x00000040,0x000000FF)
		gui.line(357,130,363,130,0x000000FF,0x000000FF)
		gui.line(357,140,363,140,0x000000FF,0x000000FF)
		gui.line(357,150,363,150,0x000000FF,0x000000FF)
		gui.line(357,160,363,160,0x000000FF,0x000000FF)
		gui.line(357,170,363,170,0x000000FF,0x000000FF)
		gui.line(357,180,363,180,0x000000FF,0x000000FF)
		if p2_char == 0x04 or p2_char == 0x0D then
		--Ken thawk
		p_a = (90 / 120)
		gui.box(3,100,11,190,0x00000040,0x000000FF)
		gui.box(370,100,378,190,0x00000040,0x000000FF)
		gui.box(370,190,378,190 - (p_a * memory.readbyte(p_gc)),0xFFFF00B0,0x00000000)
		gui.box(3,190,11,190 - ((90 / 63) * memory.readbyte(game.training_logic.p1_gb)),0xFF0000B0,0x00000000)
		gui.text(1,192,memory.readbyte(game.training_logic.p1_gb) .. "/" .. "63")
		gui.text(355,192,memory.readbyte(p_gc) .. "/" .. "120")
		elseif p2_char == 0x02 or p2_char == 0x01 then
		--Blanka E.Honda
		p_a = (90 / 130)
		gui.box(3,100,11,190,0x00000040,0x000000FF)
		gui.box(370,100,378,190,0x00000040,0x000000FF)
		gui.box(370,190,378,190 - (p_a * memory.readbyte(p_gc)),0xFFFF00B0,0x00000000)
		gui.box(3,190,11,190 - ((90 / 63) * memory.readbyte(game.training_logic.p1_gb)),0xFF0000B0,0x00000000)
		gui.text(1,192,memory.readbyte(game.training_logic.p1_gb) .. "/" .. "63")
		gui.text(355,192,memory.readbyte(p_gc) .. "/" .. "130")
		elseif p2_char == 0x06 or p2_char == 0x07 then
		--Dhalsim Zangief
		p_a = (90 / 180)
		gui.box(3,100,11,190,0x00000040,0x000000FF)
		gui.box(370,100,378,190,0x00000040,0x000000FF)
		gui.box(370,190,378,190 - (p_a * memory.readbyte(p_gc)),0xFFFF00B0,0x00000000)
		gui.box(3,190,11,190 - ((90 / 63) * memory.readbyte(game.training_logic.p1_gb)),0xFF0000B0,0x00000000)
		gui.text(1,192,memory.readbyte(game.training_logic.p1_gb) .. "/" .. "63")
		gui.text(355,192,memory.readbyte(p_gc) .. "/" .. "180")
		elseif p2_char == 0x0A then
		--Boxer

		count = memory.readbyte(p_gc)
		if romname=="ssf2t" then
			p_a = (90 / 210)
			gui.text(355,192,memory.readbyte(p_gc) .. "/" .. "210")
		else
			p_a = (90 / 300)

			-- Boxer has a grab count of 300, which is greater than 1 byte. So a correction is applied 
			-- to the count provided by p_gc, so that the count varies from 300 to 0 in a linear way.
			local count1
			if count_of_zeros then 
				count1 = count
			else
				count1 = count + 255
			end

			if count==0  then
				count_of_zeros  = not count_of_zeros
			end
			count = count1

			gui.text(355,192, count .. "/" .. "300")
		end
	--[[
		ss=""
		if count_zero then
		ss="1"
		else
		ss = "0"
		end

		print(count..","..ss)--]]

		gui.box(3,100,11,190,0x00000040,0x000000FF)
		gui.box(370,100,378,190,0x00000040,0x000000FF)
		gui.box(370,190,378,190 - (p_a * count),0xFFFF00A0,0x00000000)
		gui.box(3,190,11,190 - ((90 / 63) * memory.readbyte(game.training_logic.p1_gb)),0xFF0000B0,0x00000000)
		gui.text(1,192,memory.readbyte(game.training_logic.p1_gb) .. "/" .. "63")	
		end
	end

end

local function check_grab()

local p1_c = memory.readbyte(game.training_logic.p1_c) -- P1 Character
local p1_gc = 0 -- P1 Grab counter
local p1_gb = memory.readbyte(game.training_logic.p1_gb) -- P1 Grab Break
local p1_gf = memory.readbyte(game.training_logic.p1_gf) -- P1 Grab flag
local p1_tf = memory.readbyte(game.training_logic.p1_tf) -- P1 Throw Flag
 
local p2_c = memory.readbyte(game.training_logic.p1_c+game.p2) -- P2 Character
local p2_gc = 0 -- P1 Grab counter
local p2_gb = memory.readbyte(game.training_logic.p1_gb+game.p2) -- P2 Grab Break
local p2_gf = memory.readbyte(game.training_logic.p1_gf+game.p2) -- P2 Grab flag
local p2_tf = memory.readbyte(game.training_logic.p1_tf+game.p2) -- P2 Throw Flag

	

	if p1_c == 0x01 or p1_c == 0x02 or p1_c == 0x04 or p1_c == 0x06 or p1_c == 0x07 or p1_c == 0x0A or p1_c == 0x0D then
		
		if p1_c == 0x01  or p1_c == 0x02 or p1_c == 0x04 or p1_c == 0x07 or p1_c == 0x0D then -- Blanka, Dhalsim, E.Honda, Ken, T.Hawk
			if p1_c == 0x07 then
				p1_gv = 0x06
			end
			p1_gc = game.training_logic.p1_gc_others
		elseif p1_c == 0x06 then -- Gief
			p1_gc = game.training_logic.p1_gc_zangief
		elseif p1_c == 0x0A then -- Boxer
			p1_gc = game.training_logic.p1_gc_boxer
		end		
		
		if p2_tf == 0xFF then

			if p1_c == 0x04 or p1_c == 0x02 then -- Check ken and Blanka
				if p1_gf == 0x07 then
					draw_grab(0,p1_c,p2_c,p1_gc)
				end
			elseif p1_c == 0x01 then -- Check Honda
				if p1_gf == 0x07 or p1_gf == 0x04 then
					draw_grab(0,p1_c,p2_c,p1_gc)
				end
			elseif p1_c == 0x07 then  -- Check Dhalsim
				if p1_gf == 0x06 then
					draw_grab(0,p1_c,p2_c,p1_gc)
				end
			elseif p1_c == 0x0A then -- Check Balrog
				if p1_gf == 0x06 or p1_gf == 0x05 then
					draw_grab(0,p1_c,p2_c,p1_gc)
				end
			elseif p1_c == 0x0D then -- Check Hawk
				if p1_gf == 0x06 or p1_gf == 0x07 then
					draw_grab(0,p1_c,p2_c,p1_gc)
				end
			elseif p1_c == 0x06 then -- Check Zangief
				if romname=="ssf2t" then
					if p1_gf == 0x05 or p1_gf == 0x06 or p1_gf == 0x03 then
						draw_grab(0,p1_c,p2_c,p1_gc)
					end
				else
					if p1_gf == 0x05 or p1_gf == 0x07 or p1_gf == 0x03 then
						draw_grab(0,p1_c,p2_c,p1_gc)
					end
				end
			end
		
		end
		
	--	if p1_gf == p1_gv and p2_tf == 0xFF then
			
	--		draw_grab(0,p1_c,p2_c,p1_gc)
	--	end
	end
	
	if p2_c == 0x01 or p2_c == 0x02 or p2_c == 0x04 or p2_c == 0x06 or p2_c == 0x07 or p2_c == 0x0A or p2_c == 0x0D then
		
		if p2_c == 0x01  or p2_c == 0x02 or p2_c == 0x04 or p2_c == 0x07 or p2_c == 0x0D then  -- Blanka, Dhalsim, E.Honda, Ken, T.Hawk
			p2_gc = game.training_logic.p1_gc_others + game.p2
		elseif p2_c == 0x06 then -- Gief
			p2_gc = game.training_logic.p1_gc_zangief + game.p2
		elseif p2_c == 0x0A then -- Boxer
			p2_gc = game.training_logic.p1_gc_boxer + game.p2
		end

		if p1_tf == 0xFF then		
			if p2_c == 0x04 or p2_c == 0x02 then -- Check ken and Blanka
				if p2_gf == 0x07 then							
					draw_grab(1,p1_c,p2_c,p2_gc)
				end
			elseif p2_c == 0x01 then -- Check Honda
				if p2_gf == 0x07 or p2_gf == 0x04 then
					draw_grab(1,p1_c,p2_c,p2_gc)
				end
			elseif p2_c == 0x07 then  -- Check Dhalsim
				if romname=="ssf2t" then
					if p2_gf == 0x06 then
						draw_grab(1,p1_c,p2_c,p2_gc)
					end
				else
					if p2_gf == 0x00 then
						draw_grab(1,p1_c,p2_c,p2_gc)
					end
				end
			elseif p2_c == 0x0A then -- Check Balrog
				if p2_gf == 0x06 or p2_gf == 0x05 then
					draw_grab(1,p1_c,p2_c,p2_gc)
				end
			elseif p2_c == 0x0D then -- Check Hawk
				if p2_gf == 0x06 or p2_gf == 0x07 then
					draw_grab(1,p1_c,p2_c,p2_gc) 
				end
			elseif p2_c == 0x06 then -- Check Zangief

				if romname=="ssf2t" then
					if p2_gf == 0x05 or p2_gf == 0x06 or p2_gf == 0x03 then
						draw_grab(1,p1_c,p2_c,p2_gc)
					end
				else
					if p2_gf == 0x05 or p2_gf == 0x06 or p2_gf == 0x03 or p2_gf == 0x07 then
						draw_grab(1,p1_c,p2_c,p2_gc)
					end
				end
			end
		end
			
				
	--	if p2_gf == p2_gv and p1_tf == 0xFF  then
		--	draw_grab(1,p1_c,p2_c,p2_gc)
		--end
	end

	-- reset count_of_zeros if not grab
	if count_of_zeros and p1_tf~=0xFF and p2_tf~=0xFF then
		count_of_zeros = false		
	end
end

----------------------------------------------------------------------------------------------------
--Draw HUD
----------------------------------------------------------------------------------------------------

function lib.render_hud()

	in_match = memory.readword(game.training_logic.A21)
	
	if in_match == 0 then
		return
	end
	
		if draw_hud > 0 then
			--Universal
			gui.text(153,12,"Distance X/Y: " .. calc_range()) 
			--P1
			gui.text(6,16,"X/Y: ") 
			gui.text(2,24,memory.readword(game.training_logic.A22x) .. "," .. memory.readword(game.training_logic.A22y)) -- 0xFF8454 / 0xFF8458
			gui.text(35,22,"Life: " .. memory.readbyte(game.training_logic.A22life)) -- 0xFF8479
			gui.text(154,41,memory.readbyte(game.training_logic.A8) .. "/34") -- 0xFF84AD
			gui.text(154,50,memory.readword(game.training_logic.A10)) -- 0xFF84AB
			gui.box(35,45,150,49,0x00000040,0x000000FF)
			gui.box(35,49,150,53,0x00000040,0x000000FF)
			gui.line(136,45,136,49,0x000000FF)

			if romname=="ssf2t" then 
				gui.text(22,206,"Super: " .. memory.readbyte(game.training_logic.A15)) -- 0xFF8702
				gui.text(6,216,"Special/Super Cancel: " .. check_cancel(1))
			else
				gui.text(6,216,"Special Cancel: " .. check_cancel(1))
			end

			--P2
			gui.text(363,16,"X/Y: ")
			gui.text(356,24,memory.readword(game.training_logic.A23x) .. "," .. memory.readword(game.training_logic.A23y))
			gui.text(314,22,"Life: " .. memory.readbyte(game.training_logic.A23life))
			gui.text(212,41,memory.readbyte(game.training_logic.A8) .. "/34")
			gui.text(212,50,memory.readword(game.training_logic.A10))
			gui.box(233,45,348,49,0x00000040,0x000000FF)
			gui.box(233,49,348,53,0x00000040,0x000000FF)
			gui.line(334,45,334,49,0x000000FF)

			if romname=="ssf2t" then 
				gui.text(327,206,"Super: " .. memory.readbyte(game.training_logic.A16)) -- 0xFF8B02
				gui.text(255,216,"Special/Super Cancel: " .. check_cancel(2))
			else
				gui.text(255,216,"Special Cancel: " .. check_cancel(2))
			end
			
			-- Character specific HUD
			if draw_hud == 2 then

				char1 = memory.readbyte(game.training_logic.p1_c)
				char2 = memory.readbyte(game.training_logic.p1_c+game.p2)
			
				determine_char(1, char1, char2)
				determine_char(2, char1, char2)
			end 
			if p1_projectile == true then
				gui.text(34,56,"Projectile: " .. projectile_onscreen(0))
			end
			if p2_projectile == true then
				gui.text(266,56,"Projectile: " .. projectile_onscreen(1))
			end
			draw_dizzy()
			check_grab()
			fskip()
		end
end

----------------------------------------------------------------------------------------------------
-- hotkey function
----------------------------------------------------------------------------------------------------
function lib.ToggleHUD(incrementCounter)

	draw_hud = draw_hud + incrementCounter

	if draw_hud>2 then
		draw_hud = 0
	elseif draw_hud<0 then
		draw_hud = 2
	end

	-- Toggle SF2 HUD
	if draw_hud == 1 then	
		return "Showing basic HUD"
	elseif draw_hud == 2 then
		return "Showing full HUD"
	elseif draw_hud == 0 then
		return "Hiding HUD"
	end
end

return lib