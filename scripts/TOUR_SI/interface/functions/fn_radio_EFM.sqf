private ["_position", "_rounds", "_amount", "_radius", "_interval", "_unit", "_groupstring", "_grouparty", "_ammo", "_strPos", "_pos"];
	
_position = _this select 0;
_rounds = _this select 1;
_amount = _this select 2;
_radius = _this select 3;
_interval = _this select 4;
_unit = _this select 5;
_groupstring = (str group _unit) call TOUR_SI_fnc_groupNameFix;
_grouparty = (str (TOUR_SI_core getVariable "TOUR_SI_artygroup")) call TOUR_SI_fnc_groupNameFix;
_ammo = switch (toLower _rounds) do
{
	case "155mm he rounds": {["sh_155mm_amos", "155mm HE rounds", "32rnd_155mm_mo_shells"]};
	case "82mm he rounds": {["sh_82mm_amos", "82mm HE rounds", "8rnd_82mm_mo_shells"]};
	case "82mm flare rounds":	{["flare_82mm_amos_white", "82mm flare rounds", "8rnd_82mm_mo_flare_white"]};
	case "82mm smoke rounds": {["smoke_82mm_amos_white", "82mm smoke rounds", "8rnd_82mm_mo_smoke_white"]};
	case "82mm guided rounds": {["sh_82mm_amos", "82mm guided rounds", "8rnd_82mm_mo_guided"]};
	case "82mm laser guided rounds": {["sh_82mm_amos", "82mm laser guided rounds", "8rnd_82mm_mo_lg"]};
	case "155mm smoke rounds": {["smoke_120mm_amos_white", "155mm smoke rounds", "6rnd_155mm_mo_smoke"]};
	case "155mm guided rounds":	{["sh_155mm_amos", "155mm guided rounds", "2rnd_155mm_mo_guided"]};
	case "155mm laser guided rounds": {["sh_155mm_amos", "155mm laser guided rounds", "2rnd_155mm_mo_lg"]};
	case "155mm mine rounds": {["mine_155mm_amos_range", "155mm mine rounds", "6rnd_155mm_mo_mine"]};
	case "155mm at mine rounds": {["at_mine_155mm_amos_range", "155mm AT mine rounds", "6rnd_155mm_mo_at_mine"]};
	case "155mm cluster rounds": {["cluster_155mm_amos", "155mm cluster rounds", "2rnd_155mm_mo_cluster"]};
	default {["smoke_82mm_amos_white", "nil poi"]};
};

	if (isServer) then
	{
	
		_array = [];
		{
			if ((_ammo select 2) == (_x select 0)) then
			{ 
				_array set [count _array, [(_x select 0), ((_x select 1) - _amount)]];
			}else
			{
				_array set [count _array, _x];
			};
		}forEach ((TOUR_SI_core getVariable "TOUR_SI_ammo") select 0);

		_condition = (TOUR_SI_core getVariable "TOUR_SI_ammo") select 1;
		TOUR_SI_core setVariable ["TOUR_SI_Ammo", [_array, _condition], true];
	
		[_interval, _ammo, _position, _amount, _radius] spawn
		{
			private ["_interval", "_ammo", "_position", "_amount", "_shell", "_pos", "_height", "_radius", "_firefrom"];
			_interval = _this select 0;
			_ammo = _this select 1;
			_position = _this select 2;
			_amount = _this select 3;
			_radius = _this select 4;
			sleep (17 + (10 + 18));

			for "_i" from 1 to _amount do
			{			
				if (((_ammo select 1) in ["155mm laser guided rounds", "155mm guided rounds"])&&(count (_position nearEntities [["LaserTargetE","LaserTargetW","I_IRStrobe","W_IRStrobe","E_IRStrobe"], 50]) > 0)) then 
				{
					_pos = getpos ((_position nearEntities [["LaserTargetE","LaserTargetW","I_IRStrobe","W_IRStrobe","E_IRStrobe"], 50]) select 0);
				}else 
				{
					_pos = [_position, ((round (random _radius)) + (round (random 15))), (round (random 360))]call BIS_fnc_relPos;
				};

				[_pos,(_ammo select 0),0,1,1,{false},0,500,200,["shell1","shell2"]] spawn BIS_fnc_fireSupportVirtual;

				sleep _interval;
			};
			sleep 10;
			TOUR_SI_core setVariable ["TOUR_SI_inUse", nil, true];
		};

	};
	
	if (!isDedicated) then
	{
		enableRadio true;
		sleep 2;
		_unit sideChat format ["%2 this is %1, how copy? OVER", _groupstring, _grouparty];
		sleep 5;
		leader (TOUR_SI_core getVariable "TOUR_SI_artygroup") sideChat format ["This is %2 we read you %1, go ahead. OVER", _groupstring, _grouparty];
		sleep 5;
		_strPos = _position call TOUR_SI_fnc_gridFix;
		_unit sideChat format ["%2, we require %4 strike at %3. OVER", _groupstring, _grouparty, _strPos, (_ammo select 1)];
		sleep 5;
		if ((_ammo select 1) in ["155mm laser guided rounds", "155mm guided rounds"]) then
		{
			leader (TOUR_SI_core getVariable "TOUR_SI_artygroup") sideChat format ["Copy %1, fire mission received. %2 firing, paint your target!  OVER", _groupstring, _grouparty];
		}else
		{
			leader (TOUR_SI_core getVariable "TOUR_SI_artygroup") sideChat format ["Copy %1, fire mission received. %2 firing on target! OVER", _groupstring, _grouparty];
		};
		[_interval, _amount, _groupstring, _grouparty]spawn
		{
			_interval = _this select 0;
			_amount = _this select 1;
			_groupstring = _this select 2;
			_grouparty = _this select 3;
			sleep (10 + 18);
			if ((10 + (_interval * _amount)) <=  20) then
			{
				leader (TOUR_SI_core getVariable "TOUR_SI_artygroup") sideChat format ["SPLASH, %2 OUT", _groupstring, _grouparty];
				sleep 2;
				enableRadio false;
			}else
			{
				leader (TOUR_SI_core getVariable "TOUR_SI_artygroup") sideChat format ["SPLASH, OVER", _groupstring, _grouparty];
			};
		};
		sleep (10 + (_interval * _amount));

		if ((10 + (_interval * _amount)) > 20) then
		{
			leader (TOUR_SI_core getVariable "TOUR_SI_artygroup") sideChat format ["Rounds complete, %2 OUT", _groupstring, _grouparty];
			sleep 2;
			enableRadio false;
		}else
		{
			leader (TOUR_SI_core getVariable "TOUR_SI_artygroup") sideChat format ["Rounds complete, standby, OVER", _groupstring, _grouparty];
		};
	};

	