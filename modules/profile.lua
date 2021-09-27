game = {}
romname = ""

profile = {
	{
		games = {"ssf2t"},
		status_type = "normal",
		address = {
			player           = 0xFF844E,
			projectile       = 0xFF97A2,
			left_screen_edge = 0xFF8ED4,
			stage            = 0xFFE18B,
		},
		p2 = 0x400, -- Player space		
		box_parameter_size = 1,		
		box_list = {
			{addr_table = 0x8, id_ptr = 0xD, id_space = 0x04, type = "push"},
			{addr_table = 0x0, id_ptr = 0x8, id_space = 0x04, type = "vulnerability"},
			{addr_table = 0x2, id_ptr = 0x9, id_space = 0x04, type = "vulnerability"},
			{addr_table = 0x4, id_ptr = 0xA, id_space = 0x04, type = "vulnerability"},
			{addr_table = 0x6, id_ptr = 0xC, id_space = 0x10, type = "attack"},
		},
		throw_box_list = {
			{param_offset = 0x6C, type = "throwable"},
			{param_offset = 0x64, type = "throw"},
		},
		number_of_stages = 16, -- number if stages o number of characters
		look_actions_count = 13,
		training_logic = { -- address for training_logic		
			-- const
			C1 = 0xFF8451,--(A1)-27
			C2 = 0xFF847A,--(A2)
			C3 = 0xFF8851,--(C1)+400
			C4 = 0xFF887A,--(C2)+400
			C5 = 0xFF860B,--(A3)+400
			C6 = 0xFF8A0B,--(C5)+400
			C7 = 0xFF82F2,
			--infinite energy Player 1
			A1 = 0xFF8478,
			A2 = 0xFF847A,
			A3 = 0xFF860A,			
			--infinite energy Player2
			A5 = 0xFF8878,--(A1)+400
			A6 = 0xFF887A,--(A2)+400
			A7 = 0xFF8A0A,--(A3)+400
			--fix glitches method2 Player 1
			A8 = 0xFF84AD,--(A10)+2
			A9 = 0xFF84AE,--(A10)+3
			A10 = 0xFF84AB,--(A1)+33
			--fix glitches method2 Player 2
			A11 = 0xFF88AD,--(A8)+400
			A12 = 0xFF88AE,--(A9)+400
			A13 = 0xFF88AB,--(A10)+400
			-- infinite super
			A14 = 0xFF8008,
			A15 = 0xFF8702,
			A16 = 0xFF8B02,
			-- disable dizzy
			A17a = 0xFF84AA,
			A17b = 0xFF84AC,
			A17c = 0xFF863E, -- P1 only greater than zero in stun
			A18a = 0xFF88AA,
			A18b = 0xFF88AC,
			A18c = 0xFF88AF, --(A17b)+400 -- P2 only greater than zero in stun
			-- infinite time
			A19 = 0xFF8DCE,
			-- Select Background
			A20 = 0xFF8C4F,
			-- In Match (is greater than zero only during the fight)
			A21 = 0xFF847F,
			-- Distance X Player 1
			A22x = 0xFF8454,-- (C1)+3
			-- Distance Y Player 1
			A22y = 0xFF8458, -- (C1)+7
			-- Life Player 1
			A22life = 0xFF8479, -- (A1)+1
			-- Distance X Player 2
			A23x = 0xFF8854,-- (A22x)+400
			-- Distance Y Player 2
			A23y = 0xFF8858, -- (A22x)+400
			-- Life Player 2
			A23life = 0xFF8879, -- (A22life)+400
			--Determines if a projectile is still in game and if one can be executed
			ProjectileOn = 0xFF8622,
			--Determines if a special cancel can be performed after a normal move has been executed
			SpecialCancelOn = 0xFF85E3,
			p1_c = 0xFF87DF, -- P1 Character
			p1_hg = 0xFF84CD, -- P1 grab speed meter
			p1_gb = 0xFF84CB, -- P1 Grab Break
			p1_gf = 0xFF85CE, -- P1 Grab flag
			p1_tf = 0xFF84B1, -- P1 Throw Flag
			-- P1 Grab counter
			p1_gc_others = 0xFF846C, -- Others
			p1_gc_zangief = 0xFF84D7, -- Zangief
			p1_gc_boxer = 0xFF84E3, -- Boxer
			--Lock Actions Player 2
			LAaction = 0xFF8BE1, -- Player 2 action param. The allowed values are defined in the actions array
			LA1 = 0xFF8BE0,
			LA2 = 0x078034,
			LA3 = 0x2CDA,
			LA4 = 0x2CDC,
			LA5 = 0x2CDE,
			LAon = 0x4E71, -- on value
			LAoff1 = 0x6710, -- off value 1
			LAoff2 = 0x3B6D, -- off value 3
			LAoff3 = 0x008A, -- off value 3
			LAoff4 = 0x0BE0, -- off value 4
			LA6 = 0xFF8451,
			LA7 = 0xFF87E1, 
			LA8 = 0xFF8A0C, 
			LA9 = 0xFF8854, 
			LA10 = 0xFF8454, 
			LA11 = 0xFF87E0, 
			-- Player1 and Player2 Won match
			Player1SetsWon = 0xFF87DE,
			Player2SetsWon = 0xFF8BDE,
			-- Player1 and Player2 is Human
			IsPlayer1Human = 0xFF87DC,
			IsPlayer2Human = 0xFF8BDC
		},
		moves = {
			--Boxer
			BoxerGroundStraight=0xFF84CE,
			BoxerGroundUpper=0xFF84D6,
			BoxerStraight=0xFF852B,
			BoxerUpperDash=0xFF8524,
			BoxerBuffaloHeadbutt=0xFF850E,
			BoxerCrazyBuffalo=0xFF8522,
			--Blanka
			BlankaNormalRoll=0xFF8507,
			BlankaVerticalRoll=0xFF84FE,
			BlankaGroundShaveRoll=0xFF850F,			
			--Cammy
			CammySpinKnuckle=0xFF84F0,
			CammyCannonSpike=0xFF84E0,
			CammySpiralArrow=0xFF84E4,
			CammyHooliganCombination=0xFF84F7,
			CammySpinDriveSmasher=0xFF84F4,			
			--ChunLi
			ChunLiKikouken=0xFF84CE,
			ChunLiUpKicks=0xFF8508,
			ChunLiSpinningBirdKick=0xFF84FE,
			ChunLiSenretsuKyaku=0xFF850D,			
			--DeeJay
			DeeJayAirSlasher=0xFF84E0,
			DeeJaySovatKick=0xFF84F4,
			DeeJayJackKnife=0xFF84E4,
			DeeJayMachineGunUpper=0xFF84F9,
			DeeJaySovatCarnival=0xFF84FD,		
			--Dhalsim
			DhalsimYogaBlast=0xFF84D2,
			DhalsimYogaFlame=0xFF84E8,
			DhalsimYogaFire=0xFF84CE,
			DhalsimYogaTeleport=0xFF84D6,
			DhalsimYogaInferno=0xFF84E4,				
			--Honda
			HondaFlyingHeadbutt=0xFF84D6,
			HondaButtDrop=0xFF84DE,
			HondaOichioThrow=0xFF84E4,
			HondaDoubleHeadbutt=0xFF84E2,			
			--FeiLong
			FeiLongRekka=0xFF84DE,
			FeiLongRekka2=0xFF84EE,
			FeiLongFlameKick=0xFF84E2,
			FeiLongChickenWing=0xFF8502,
			FeiLongRekkaSinken=0xFF84FE,			
			--Guile
			GuileSonicBoom=0xFF84CE,
			GuileFlashKick=0xFF84D4,
			GuileDoubleSomersault=0xFF84E2,			
			--Ken
			KenHadouken=0xFF84E2,
			KenShoryuken=0xFF84E6,
			KenHurricaneKick=0xFF84DE,
			KenShoryureppa=0xFF84EE,
			KenCrazyKick1=0xFF8534,
			KenCrazyKick2=0xFF8536,
			KenCrazyKick3=0xFF8538,			
			--Dictator
			DictatorScissorKick=0xFF84D6,
			DictatorHeadStomp=0xFF84DF,
			DictatorDevilsReverse=0xFF84FA,
			DictatorPsychoCrusher=0xFF84CE,
			DictatorKneePressKnightmare=0xFF8513,			
			--Ryu
			RyuHadouken=0xFF84E2,
			RyuShoryuken=0xFF84E6,
			RyuHurricaneKick=0xFF84DE,
			RyuRedHadouken=0xFF852E,
			RyuShinkuHadouken=0xFF84EE,
			--Sagat
			SagatTigerShot=0xFF84DA,
			SagatTigerKnee=0xFF84D2,
			SagatTigerUppercut=0xFF84CE,
			SagatTigerGenocide=0xFF84EC,			
			--T.Hawk
			THawkMexicanTyphoon1=0xFF84E0,
			THawkMexicanTyphoon2=0xFF84E1,
			THawkTomahawk=0xFF84DB,
			THawkDoubleTyphoon1=0xFF84E0,
			THawkDoubleTyphoon2=0xFF84ED,			
			--Claw
			ClawWallDiveKick=0xFF84DA,
			ClawWallDivePunch=0xFF84DE,
			ClawCrystalFlash=0xFF84D6,
			ClawFlipKick=0xFF84EB,
			ClawRollingIzunaDrop=0xFF84E7,			
			--Zangief
			ZangiefBearGrab1=0xFF84E9,
			ZangiefBearGrab2=0xFF84EA,
			ZangiefSpinningPileDriver1=0xFF84CE,
			ZangiefSpinningPileDriver2=0xFF84CF,
			ZangiefBanishingFlat=0xFF8501,
			ZangiefFinalAtomicBuster1=0xFF84FA,
			ZangiefFinalAtomicBuster2=0xFF84FB
		},
	},
	{	
		games = {"sf2ce", "sf2hf"},
		status_type = "normal",
		address = {
			player      = 0xFF83BE,
			projectile  = 0xFF9376,
			left_screen_edge = 0xFF8BC4,
		},	
		p2 = 0x300, -- Player space
		box_parameter_size = 1,
		box_list = {
			{addr_table = 0xA, id_ptr = 0xD, id_space = 0x04, type = "push"},
			{addr_table = 0x0, id_ptr = 0x8, id_space = 0x04, type = "vulnerability"},
			{addr_table = 0x2, id_ptr = 0x9, id_space = 0x04, type = "vulnerability"},
			{addr_table = 0x4, id_ptr = 0xA, id_space = 0x04, type = "vulnerability"},
			--{addr_table = 0x6, id_ptr = 0xB, id_space = 0x04, type = "weak"}, --present but nonfunctional
			{addr_table = 0x8, id_ptr = 0xC, id_space = 0x0C, type = "attack"},
		},
			throw_box_list = {
			{param_offset = 0x6C, type = "throwable"},
			{param_offset = 0x64, type = "throw"},
		},
		number_of_stages = 12, -- number if stages o number of characters
		look_actions_count = 11,
		training_logic = { -- address for training_logic		
			-- const
			C1 = 0xFF83C1,--(A1)-27 --
			C2 = 0xFF83EA,--(A2) --
			C3 = 0xFF86C1,--(C1)+300 --
			C4 = 0xFF86EA,--(C2)+300 --
			C5 = 0xFF887A,--(A3)+300 --
			C6 = 0xFF8B7A,--(C5)+300 --
			C7 = 0xFF82E2,--
			--infinite energy Player 1
			A1 = 0xFF83E8,--
			A2 = 0xFF83EA,--(A1)+2 --
			A3 = 0xFF857A,--			
			--infinite energy Player 2
			A5 = 0xFF86E8,--(A1)+300 --
			A6 = 0xFF86EA,--(A2)+300 --
			A7 = 0xFF887A,--(A3)+300 --			
			--fix glitches method2 Player 1
			A8 = 0xFF841D,--(A10)+2 --
			A9 = 0xFF841E,--(A10)+3 --
			A10 = 0xFF841B,--(A1)+33 --			
			--fix glitches method2 Player 2
			A11 = 0xFF871D,--(A8)+300 --
			A12 = 0xFF871E,--(A9)+300 --
			A13 = 0xFF871B,--(A10)+300 --			
			-- infinite super
			A14 = 0x0,
			A15 = 0x0,
			A16 = 0x0,
			-- disable dizzy
			A17a = 0xFF841A,--
			A17b = 0xFF841C,--
			A17c = 0xFF84E2,-- P1 only greater than zero in stun
			A18a = 0xFF871A,--
			A18b = 0xFF871C,--
			A18c = 0xFF871F,--(A17b)+300 -- P2 only greater than zero in stun
			-- infinite time
			A19 = 0xFF8ABE,--
			-- Select Background
			A20 = 0xFFDD5E,
			-- In Match (is greater than zero only during the fight)
			A21 = 0xFF83EF,
			-- Distance X Player 1
			A22x = 0xFF83C4,-- (C1)+3
			-- Distance Y Player 1
			A22y = 0xFF83C8, -- (C1)+7
			-- Life Player 1
			A22life = 0xFF83E9, -- (A1)+1
			-- Distance X Player 2
			A23x = 0xFF86C4,-- (A22x)+300
			-- Distance Y Player 2
			A23y = 0xFF86C8, -- (A22x)+300
			-- Life Player 2
			A23life = 0xFF86E9, -- (A22life)+300
			--Determines if a projectile is still in game and if one can be executed
			ProjectileOn = 0xFF8622-0x90,
			--Determines if a special cancel can be performed after a normal move has been executed
			SpecialCancelOn = 0xFF85E3-0x90,
			p1_c = 0xFF87DF-0x190, -- P1 Character
			p1_hg = 0xFF84CD-0x90, -- P1 grab speed meter		
			p1_gb = 0xFF84CB-0x90, -- P1 Grab Break
			p1_gf = 0xFF85CE-0x90, -- P1 Grab flag
			p1_tf = 0xFF84B1-0x90, -- P1 Throw Flag
			-- P1 Grab counter
			p1_gc_others = 0xFF846C-0x90, -- Others
			p1_gc_zangief = 0xFF84D7-0x90, -- Zangief
			p1_gc_boxer = 0xFF84E3-0x90, -- Boxer
			--Lock Actions Player 2
			LAaction = 0xFF8951, -- Player 2 action param. The allowed values are defined in the actions array
			LA1 = 0xFF8950,
			LA2 = 0x379F4,
			LA3 = 0x20F0,
			LA4 = 0x20F2,
			LA5 = 0x20F4,
			LAon = 0x4E71, -- on value
			LAoff1 = 0x6710, -- off value 1
			LAoff2 = 0x3B6D, -- off value 3
			LAoff3 = 0x007E, -- off value 3
			LAoff4 = 0x0950, -- off value 4,
			LA6 = 0xFF83C1, 
			LA7 = 0xFF8651, 
			LA8 = 0xFF887C, 
			LA9 = 0xFF86C4, 
			LA10 = 0xFF83C4, 
			LA11 = 0xFF8650, 
			-- Player1 and Player2 Won match
			Player1SetsWon = 0xFF864E,
			Player2SetsWon = 0xFF894E,
			-- Player1 and Player2 is Human
			IsPlayer1Human = 0xFF864C,
			IsPlayer2Human = 0xFF894C
		},
		moves = {
			--Boxer
			BoxerGroundStraight=0xFF84CE-0x90,
			BoxerGroundUpper=0xFF84D6-0x90,
			BoxerStraight=0xFF852B-0x90,
			BoxerUpperDash=0xFF8524-0x90,
			BoxerBuffaloHeadbutt=0xFF850E-0x90,
			BoxerCrazyBuffalo=0xFF8522-0x90,
			--Blanka
			BlankaNormalRoll=0xFF843E,
			BlankaVerticalRoll=0xFF84FE-0x90,
			BlankaGroundShaveRoll=0xFF850F-0x90,			
			--Cammy
			BlankaSpinKnuckle=0xFF84F0-0x90,
			BlankaCannonSpike=0xFF84E0-0x90,
			BlankaSpiralArrow=0xFF84E4-0x90,
			BlankaHooliganCombination=0xFF84F7-0x90,
			BlankaSpinDriveSmasher=0xFF84F4-0x90,			
			--ChunLi
			ChunLiKikouken=0xFF84FE-0x90,
			ChunLiUpKicks=0xFF8508-0x90,
			ChunLiSpinningBirdKick=0xFF84CE-0x90,
			ChunLiSenretsuKyaku=0xFF850D-0x90,			
			--DeeJay
			DeeJayAirSlasher=0xFF84E0-0x90,
			DeeJaySovatKick=0xFF84F4-0x90,
			DeeJayJackKnife=0xFF84E4-0x90,
			DeeJayMachineGunUpper=0xFF84F9-0x90,
			DeeJaySovatCarnival=0xFF84FD-0x90,		
			--Dhalsim
			DhalsimYogaBlast=0xFF84D2-0x90,
			DhalsimYogaFlame=0xFF8459,
			DhalsimYogaFire=0xFF8451,
			DhalsimYogaTeleport=0xFF84D6-0x90,
			DhalsimYogaInferno=0xFF84E4-0x90,				
			--Honda
			HondaFlyingHeadbutt=0xFF843E,
			HondaButtDrop=0xFF84DE-0x90,
			HondaOichioThrow=0xFF84E4-0x90,
			HondaDoubleHeadbutt=0xFF84E2-0x90,			
			--FeiLong
			FeiLongRekka=0xFF84DE-0x90,
			FeiLongRekka2=0xFF84EE-0x90,
			FeiLongFlameKick=0xFF84E2-0x90,
			FeiLongChickenWing=0xFF8502-0x90,
			FeiLongRekkaSinken=0xFF84FE-0x90,			
			--Guile
			GuileSonicBoom=0xFF84CE-0x90,
			GuileFlashKick=0xFF84D4-0x90,
			GuileDoubleSomersault=0xFF84E2-0x90,			
			--Ken
			KenHadouken=0xFF84DE-0x90,
			KenShoryuken=0xFF84EE-0x90,
			KenHurricaneKick=0xFF84E6-0x90,
			KenShoryureppa=0xFF84E2-0x90,
			KenCrazyKick1=0xFF8534-0x90,
			KenCrazyKick2=0xFF8536-0x90,
			KenCrazyKick3=0xFF8538-0x90,			
			--Dictator
			DictatorScissorKick=0xFF84D6-0x90,
			DictatorHeadStomp=0xFF84DF-0x90,
			DictatorDevilsReverse=0xFF84FA-0x90,
			DictatorPsychoCrusher=0xFF84CE-0x90,
			DictatorKneePressKnightmare=0xFF8513-0x90,			
			--Ryu
			RyuHadouken=0xFF84DE-0x90,
			RyuShoryuken=0xFF84EE-0x90,
			RyuHurricaneKick=0xFF84E6-0x90,
			RyuRedHadouken=0xFF852E-0x90,
			RyuShinkuHadouken=0xFF84E2-0x90,
			--Sagat
			SagatTigerShot=0xFF8451,
			SagatTigerKnee=0xFF8469,
			SagatTigerUppercut=0xFF8459,
			SagatTigerGenocide=0xFF84EC-0x90,			
			--T.Hawk
			THawkMexicanTyphoon1=0xFF84E0-0x90,
			THawkMexicanTyphoon2=0xFF84E1-0x90,
			THawkTomahawk=0xFF84DB-0x90,
			THawkDoubleTyphoon1=0xFF84E0-0x90,
			THawkDoubleTyphoon2=0xFF84ED-0x90,			
			--Claw
			ClawWallDiveKick=0xFF843E,
			ClawWallDivePunch=0xFF84EB-0x90,
			ClawCrystalFlash=0xFF84D6-0x90,
			ClawFlipKick=0xFF84EB-0x90,
			ClawRollingIzunaDrop=0xFF84E7-0x90,			
			--Zangief
			ZangiefBearGrab1=0xFF84E9-0x90,
			ZangiefBearGrab2=0xFF84EA-0x90,
			ZangiefSpinningPileDriver1=0xFF84CE-0x90,
			ZangiefSpinningPileDriver2=0xFF84CF-0x90,
			ZangiefBanishingFlat=0xFF8501-0x90,
			ZangiefFinalAtomicBuster1=0xFF84FA-0x90,
			ZangiefFinalAtomicBuster2=0xFF84FB-0x90
		},
	},
}

--------------------------------------------------------------------------------
-- initialize on game startup

local function whatgame()
	game = nil
	romname = nil
	for n, module in ipairs(profile) do
		for m, shortname in ipairs(module.games) do
			if emu.romname() == shortname or emu.parentname() == shortname then
				--print("drawing " .. shortname .. " hitboxes")
				game = module
				romname = shortname				
				return
			end
		end
	end
	print("Training is not prepared for " .. emu.romname() )
end


emu.registerstart( function()
	whatgame()
end)

return profile