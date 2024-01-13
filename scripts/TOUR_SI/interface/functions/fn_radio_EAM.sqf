private ["_position", "_rounds", "_amount", "_radius", "_interval", "_unit", "_groupstring", "_groupAS", "_ammo", "_strPos"];
	
_position = _this select 0;
_rounds = _this select 1;
_amount = _this select 2;
_radius = _this select 3;
_interval = _this select 4;
_unit = _this select 5;
_groupstring = (str group _unit) call TOUR_SI_fnc_groupNameFix;
_groupAS = (str (TOUR_SI_core getVariable "TOUR_SI_ASgroup")) call TOUR_SI_fnc_groupNameFix;
_ammo = switch (toLower _rounds) do
{
	case "500lb napalm bombs": {"vn_bomb_500_blu1b_fb_ammo"};
	case "500lb he bombs": {"bo_mk82"};
	case "500lb he cluster bombs": {"bombcluster_03_ammo_f"};
	case "750lb he cluster bombs": {"bombcluster_01_ammo_f"};
	case "1100lb he cluster bombs": {"bombcluster_02_ammo_f"};
	default {"nil poi"};
};

	if (isServer) then
	{
	
		_array = [];
		{
			if (_ammo == (_x select 0)) then
			{ 
				_array set [count _array, [(_x select 0), ((_x select 1) - _amount)]];
			}else
			{
				_array set [count _array, _x];
			};
		}forEach ((TOUR_SI_core getVariable "TOUR_SI_ASammo") select 0);

		_condition = (TOUR_SI_core getVariable "TOUR_SI_ASammo") select 1;
		TOUR_SI_core setVariable ["TOUR_SI_ASAmmo", [_array, _condition], true];	
	
		[_interval, _ammo, _position, _amount, _radius] spawn
		{
			private ["_interval", "_ammo", "_position", "_amount", "_shell", "_pos", "_height", "_radius", "_firefrom"];
			_interval = _this select 0;
			_ammo = _this select 1;
			_position = _this select 2;
			_amount = _this select 3;
			_radius = _this select 4;
			_start = _position getPos [5000, _radius + 180];
			sleep 10;
			_plane = createVehicle [TOUR_SI_ASplaneType, [_start select 0, _start select 1, 1000], [], 0, "FLY"];
			_plane setDir _radius;
			if (surfaceIsWater _start) then
			{
				_plane setposASL [_start select 0, _start select 1, 1000];
			}else
			{
				_plane setposATL [_start select 0, _start select 1, 1000];
			};
			_group = createVehicleCrew _plane;
			waitUntil {count units _group > 0};
			
			{
				_x setCaptive true;
				_x setbehaviour "CARELESS";
				_x setSkill 1;
			}forEach units _group;
			_plane flyinHeight 100;
			_wp = _group addWaypoint [_position, 0];
			_wp2 = _group addWaypoint [(_position getPos [5000, _radius]), 0];
			waitUntil {(isNull _plane) or !(canMove _plane) or (_position distance _plane) < 500};
			
			if (!isNull _plane && canMove _plane) then
			{
				TOUR_SI_core setVariable ["TOUR_SI_ASClose", 1, true];
				sleep 4;
				for "_i" from 1 to _amount do
				{
					_pos = _position getPos [((_i * 60) - 30), _radius];
					_bomb = _ammo createVehicle [_pos select 0, _pos select 1, 1];
					_bomb setposATL _pos;
					sleep 0.25;
				}
			}else
			{
				TOUR_SI_core setVariable ["TOUR_SI_ASClose", 2, true];
			};
			waitUntil {((TOUR_SI_core getVariable "TOUR_SI_ASClose") == 2) or (isNull _plane) or !(canMove _plane) or ((_position getPos [5000, _radius]) distance _plane) < 500};
			if (!isNull _plane) then
			{
				{
					_plane deleteVehicleCrew _x;
				}forEach crew _plane;
				deleteVehicle _plane;
			};
			sleep 5;
			TOUR_SI_core setVariable ["TOUR_SI_ASClose", nil, true];
			TOUR_SI_core setVariable ["TOUR_SI_inUse", nil, true];
		};

	};
	
	if (!isDedicated) then
	{
		enableRadio true;
		sleep 2;
		_unit sideChat format ["%2 this is %1, how copy? OVER", _groupstring, _groupAS];
		sleep 5;
		leader (TOUR_SI_core getVariable "TOUR_SI_ASgroup") sideChat format ["This is %2 we read you %1, go ahead. OVER", _groupstring, _groupAS];
		sleep 5;
		_strPos = _position call TOUR_SI_fnc_gridFix;
		_unit sideChat format ["%2, we require %4 strike at %3. OVER", _groupstring, _groupAS, _strPos, _rounds];
		sleep 5;
		leader (TOUR_SI_core getVariable "TOUR_SI_ASgroup") sideChat format ["Copy %1, mission received. %2 is inbound! OVER", _groupstring, _groupAS];
		
		[_interval, _amount, _groupstring, _groupAS]spawn
		{
			_interval = _this select 0;
			_amount = _this select 1;
			_groupstring = _this select 2;
			_groupAS = _this select 3;
			waitUntil {!isNil {TOUR_SI_core getVariable "TOUR_SI_ASClose"}};
			
			if (TOUR_SI_core getVariable "TOUR_SI_ASClose" == 1) then
			{
				leader (TOUR_SI_core getVariable "TOUR_SI_ASgroup") sideChat format ["Bombs away! %2 OUT", _groupstring, _groupAS];
				sleep 2;
				enableRadio false;
			};
		};
	};

	