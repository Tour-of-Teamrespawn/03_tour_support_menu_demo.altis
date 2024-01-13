//check assets are available and linked to player

private ["_return"];

_return = false;
_return = switch (toLower (_this select 0)) do 
{
	case "artillery": {call (TOUR_SI_Core getVariable "TOUR_SI_ammo" select 1)};
	case "Airstrike": {call (TOUR_SI_Core getVariable "TOUR_SI_AStypes" select 1)};
	case "Helicopter": {
							if (count TOUR_SI_core getVariable "TOUR_SI_Helicopters" > 0) then
							{
								{
									if (call (_x select 1)) then 
									{
										_return = true;
									};
								}forEach (TOUR_SI_core getVariable "TOUR_SI_Helicopters");
							};
						};
	case "Plane": 	{	
						if (count TOUR_SI_core getVariable "TOUR_SI_Planes" > 0) then
						{
							{
								if (call (_x select 1)) then 
								{
									_return = true;
								};
							}forEach (TOUR_SI_core getVariable "TOUR_SI_Planes");
						};
					};
};

_return