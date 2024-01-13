/* 
###MISSION_VERSION 1.0
*/

function_missionEnding = {hint "End my mission please!!!"}; // create a function that contains code to end missions or run an ending sequence etc.

_siAction = if (true) then			// you can input the condition directly. I use this as some missions can run with or without ACRE and mods and some not, therefore this makes it dynamic.
{
	"(alive player) && ([player, ""ACRE_PRC148""] call acre_api_fnc_hasKindOfRadio)"
}else
{
	"(alive player) && (""ItemRadio"" in (assignedItems player))"
};

_si = 
[
	TOUR_core, // Name of game logic on the map - this must be a safe location if possible as invisible units spawn there.
	WEST, // Side of the support menu units
	_siAction, // action condition as string, to bring up the support menu
	"(alive player) && (player == leader group player) && (player distance TOUR_Officer < 2.5) && (count (TDMC_core getVariable ""A2S_taskArray"") == 0)", // To allow action for setup during game - specifically made for DMC missions though can be used
	1, // boolean - to define whether it needs integrating into the mission for ending mission or for integration to DMC to allow for additional functions to find enemy locations on maps. 0 = off, 1 = mission end option, 2 = DMC integration.
	[
		[																// array for artillery
			"artillery",												// string to define is as artillery 
			"Thunder One",												// name of the unit (string)
			[															// array of ammo and numbers of shells
				["8rnd_82mm_mo_shells", 0],
				["8rnd_82mm_mo_flare_white", 0],
				["8rnd_82mm_mo_smoke_white", 0],
				["8rnd_82mm_mo_guided", 0],
				["8rnd_82mm_mo_lg", 0],
				["32rnd_155mm_mo_shells", 0],
				["6rnd_155mm_mo_smoke", 30],
				["2rnd_155mm_mo_guided", 0],
				["2rnd_155mm_mo_lg", 0],
				["6rnd_155mm_mo_mine", 0],
				["6rnd_155mm_mo_at_mine", 0],
				["2rnd_155mm_mo_cluster", 10],
				["2rnd_155mm_mo_cluster", 0]
			],
			{[player, "ACRE_PRC148"] call acre_api_fnc_hasKindOfRadio}	// code to return a boolean that will allow the user of the support menu to access the artillery
		],
		[
			"helicopter",													// string to define helicopter role
			TOUR_chopper_1,													// unit variable name in the editor 
			"Transport One",												// name of the unit (string)
			[																// string array of commands
				"Circle",
				"Land",
				"Land (Engine Off)",
				"Move To",
				"Pickup",
				"Return To Base"
			],
			getPosATL myHeliPad,											// position defined as base for landing when RTB
			{([player, "ACRE_PRC77"] call acre_api_fnc_hasKindOfRadio)}	// code to return a boolean that will allow the user of the support menu to access the helicopter unit and command it
		],
		[
			"helicopter",
			TOUR_chopper_2,
			"Overwatch One",
			[
				"Circle",
				"CAS",
				"Land",
				"Land (Engine Off)",
				"Move To",
				"Pickup",
				"Return To Base"
			],
			getPosATL TOUR_chopper_2,
			{true}
		],
		[
			"helicopter",
			TOUR_chopper_3,
			"Destroyer One",
			[
				"CAS", 
				"CAS (Laser Designation)",
				"Move To",
				"Return To Base"
			],
			getPosATL TOUR_chopper_3,
			{([player, "ACRE_PRC343"] call acre_api_fnc_hasKindOfRadio)}
		],
		[
			"Airstrike",													// string to define support type
			"rhsusf_f22",													// typeof unit			
			"Condor One",													// unit name
			[																// array of ammunition available for the unit
				["Bo_Mk82", 20],
				["BombCluster_03_Ammo_F", 20],
				["BombCluster_01_Ammo_F", 20],
				["BombCluster_02_Ammo_F", 20]
			],
			{player == leader group player}	// code to return a boolean that will allow the user of the support menu to access the airstrike function
		]
	],
	"function_missionEnding",		// function name when the ending is called - executes on all machines
	{true}							// condition to allow the mission ending to be visible
] execVM "scripts\TOUR_SI\TOUR_SI_init.sqf";