--========================================--
--             MANCO Traning              --
--  SF2 Lua Training Mode for Fightcade2  --
--      Credits: Intimarco / Yacsha       --
--                                        --
-- Based in Training: POF and Dammit      --
--========================================--

--*****************************************
-- CHALLENGE OFFLINE
--*****************************************

----------------------------------------------------------------------------------------------------
--Include Main Module
----------------------------------------------------------------------------------------------------
local main = loadfile("manco-training-SF2.lua")

if not main then
	print("manco-training-SF2.lua not found")
	return -- abort script	
end

----------------------------------------------------------------------------------------------------
-- Activate variables by default only for Replay mode
----------------------------------------------------------------------------------------------------
main(
0,	-- Fightstick input display: 0=Disuabled, 1=Yzkof
true,	-- Enable or disabled 'Show menu when holding down the coin button': true = Enabled, false = Disabled
true	-- Random Selected Stage: true = Random, false = Disabled
)



