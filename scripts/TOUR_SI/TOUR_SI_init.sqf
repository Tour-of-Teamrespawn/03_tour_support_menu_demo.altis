waitUntil {!isNil "BIS_fnc_init"};

private ["_mainArray", "_arty", "_heli"];

TOUR_SI_core = _this select 0;
_side = _this select 1;
_action = _this select 2;
_sAction = _this select 3;
TOUR_SI_extraEnabled = _this select 4;
_array = _this select 5;
if (TOUR_SI_extraEnabled == 1) then
{
	TOUR_SI_fnc_userEnding = _this select 6;
	TOUR_SI_extraCheck = _this select 7;
}else
{
	TOUR_SI_fnc_userEnding = "";
	TOUR_SI_extraCheck = {false};
};
if (count _this >= 9) then 
{
	TOUR_SI_playerFeatures = _this select 8;
}else 
{
	TOUR_SI_playerFeatures = [];
};

_if = _this execVM "scripts\TOUR_SI\interface\init.sqf";
waitUntil {scriptDone _if};

if (isServer) then
{

	{
		if (toLower (_x select 0) == "artillery") then
		{
			TOUR_SI_group  = createGroup _side;
			_typeof = switch (toLower str _side) do
			{
				case "east": {"O_Soldier_unarmed_F"};
				case "west": {"B_Soldier_unarmed_F"};
				case "guer": {"I_Soldier_unarmed_F"};
				default {"error!"};
			};
			TOUR_SI_unit = _typeof createUnit [getPosATL TOUR_SI_core, TOUR_SI_group];
			TOUR_SI_core setVariable ["TOUR_SI_artygroup", TOUR_SI_group, true];
			TOUR_SI_types = _x select 2;
			_arty = [];
			{
				_arty set [count _arty, _x];
			}forEach TOUR_SI_types;
			TOUR_SI_core setVariable ["TOUR_SI_ammo", [_arty, _x select 3], true];
		};
	}forEach _array;
	
	{
		if (toLower (_x select 0) == "airstrike") then
		{
			TOUR_SI_ASgroup  = createGroup _side;
			TOUR_SI_ASplaneType = _x select 1;
			_typeof = switch (toLower str _side) do
			{
				case "east": {"O_Soldier_unarmed_F"};
				case "west": {"B_Soldier_unarmed_F"};
				case "guer": {"I_Soldier_unarmed_F"};
				default {"error!"};
			};
			TOUR_SI_ASunit = _typeof createUnit [getPosATL TOUR_SI_core, TOUR_SI_ASgroup];
			TOUR_SI_core setVariable ["TOUR_SI_ASgroup", TOUR_SI_ASgroup, true];
			TOUR_SI_AStypes = _x select 3;
			_AS = [];
			{
				_AS set [count _AS, _x];
			}forEach TOUR_SI_AStypes;
			TOUR_SI_core setVariable ["TOUR_SI_ASammo", [TOUR_SI_AStypes, _x select 4], true];
		};
	}forEach _array;

	_mainArray = [];	
	{
		if (toLower (_x select 0) == "helicopter") then
		{
			if (!isNull (driver (_x select 1))) then
			{
				//group, choppervariable, support types array //, status
				_heli = [(group (driver (_x select 1))), (_x select 1), (_x select 3)];
				_mainArray set [count _mainArray, [_heli, _x select 5]];
				[(_x select 1), (group driver (_x select 1)), (_x select 2), (_x select 4) ] execFSM "scripts\TOUR_SI\interface\fsm\helicopter.fsm";
			};
		};
	}forEach _array;
	TOUR_SI_core setVariable ["TOUR_SI_helicopters", _mainArray, true];

	_mainArray = [];	
	{
		if (toLower (_x select 0) == "plane") then
		{
			if (!isNull (driver (_x select 1))) then
			{
				//group, planevariable, support types array, status
				_plane = [(group (driver (_x select 1))), (_x select 1), (_x select 3)];
				_mainArray set [count _mainArray, _plane];
				[(_x select 1), (group driver (_x select 1)), (_x select 2), (_x select 4), (_x select 5)] execFSM "scripts\TOUR_SI\interface\fsm\plane.fsm";
			}else
			{
				TOUR_SI_Planegroup = createGroup _side;
				_typeof = switch (toLower str _side) do
				{
					case "east": {"O_Soldier_unarmed_F"};
					case "west": {"B_Soldier_unarmed_F"};
					case "guer": {"I_Soldier_unarmed_F"};
					default {"error!"};
				};
				TOUR_SI_Planeunit = _typeof createUnit [getPosATL TOUR_SI_core, TOUR_SI_group];
				TOUR_SI_planeTypes = _x select 2;
				TOUR_SI_core setVariable ["TOUR_SI_planeGroup", TOUR_SI_planeGroup, true];
				_plane = [];
				{
					_plane set [count _plane, _x];
				}forEach TOUR_SI_planeTypes;
				TOUR_SI_core setVariable ["TOUR_SI_planeAmmo", [_plane, _x select 5], true];
			};
		};
	}forEach _array;
	TOUR_SI_core setVariable ["TOUR_SI_vPlanes", _mainArray, true];
};

private ["_id"];
_id = "TOUR_SI_nil";
{
	if (toLower (_x select 0) == "artillery") then
	{
		_id = _x select 1;
	};
}forEach _array;

private ["_idAS"];
_idAS = "TOUR_SI_nil";
{
	if (toLower (_x select 0) == "airstrike") then
	{
		_idAS = _x select 2;
	};
}forEach _array;

if (_id != "TOUR_SI_nil") then
{
	waitUntil {!isNil {TOUR_SI_core getVariable "TOUR_SI_artygroup"}};
	waitUntil {count units (TOUR_SI_core getVariable "TOUR_SI_artygroup") > 0};

	{
		_x hideObject true;
		_x allowDamage false;
		_x setGroupID [_id];
	} forEach units (TOUR_SI_core getVariable "TOUR_SI_artygroup"); 
};

if (_idAS != "TOUR_SI_nil") then
{
	waitUntil {!isNil {TOUR_SI_core getVariable "TOUR_SI_ASgroup"}};
	waitUntil {count units (TOUR_SI_core getVariable "TOUR_SI_ASgroup") > 0};

	{
		_x hideObject true;
		_x allowDamage false;
		_x setGroupID [_idAS];
	} forEach units (TOUR_SI_core getVariable "TOUR_SI_ASgroup"); 
};

{
	if (toLower (_x select 0) == "helicopter") then
	{
		waitUntil {!isNil {TOUR_SI_core getVariable "TOUR_SI_helicopters"}};
		if (!isNull (_x select 1)) then
		{
			if (!isNull (driver (_x select 1))) then
			{
				if !(isPlayer driver (_x select 1)) then
				{
					((driver (_x select 1))) setGroupID [(_x select 2)];
					waitUntil {!isNil {(_x select 1) getVariable "TOUR_SI_unitStatus"}};
					(_x select 1) addAction ["<t color=""#D7DF01"">"+"TALK TO PILOT - RTB", "scripts\TOUR_SI\interface\actionRTB.sqf", "", 0, false, true, "", "(player == leader group player) && (!isNil {vehicle player getVariable ""TOUR_SI_unitStatus""}) && !((vehicle player getVariable ""TOUR_SI_unitStatus"") in [""return to base"", ""idle"", ""servicing""]) "];
				};
			};
		};
	};
	
	if (toLower (_x select 0) == "plane") then
	{
		waitUntil {!isNil {TOUR_SI_core getVariable "TOUR_SI_planes"}};
		if (!isNull (_x select 1)) then
		{
			if (!isNull (driver (_x select 1))) then
			{
				if !(isPlayer driver (_x select 1)) then
				{
					((driver (_x select 1))) setGroupID [(_x select 2)];
				};
			};
		};
	};
}forEach _array;

