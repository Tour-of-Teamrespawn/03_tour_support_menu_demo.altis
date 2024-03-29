private ["_smoke", "_colour"];
_smoke = _this;
_colour = switch (toLower (typeOf _smoke)) do
{
	case "smokeshell" : { "white" };
	case "smokeshellred": { "red" };
	case "smokeshellgreen": { "green" };
	case "smokeshellyellow": { "yellow" };
	case "smokeshellpurple": { "purple" };
	case "smokeshellblue": { "blue" };
	case "smokeshellorange": { "orange" };
	case "g_40mm_smoke": { "white" };
	case "g_40mm_smokered": { "red" };
	case "g_40mm_smokegreen": { "green" };
	case "g_40mm_smokeyellow": { "yellow" };
	case "g_40mm_smokepurple": { "purple" };
	case "g_40mm_smokeblue": { "blue" };
	case "g_40mm_smokeorange": { "orange" };
	case "rhs_ammo_m18_red": { "red" };
	case "rhs_ammo_m18_green": { "green" };
	case "rhs_ammo_m18_yellow": { "yellow" };
	case "rhs_ammo_m18_purple": { "purple" };
	case "rhs_ammo_m18_blue": { "blue" };
	case "rhs_ammo_m18_orange": { "orange" };
	case "rhssaf_ammo_brd_m83_white": { "white" };
	case "rhssaf_ammo_brd_m83_green": { "green" };
	case "rhssaf_ammo_brd_m83_red": { "red" };
	case "rhssaf_ammo_brd_m83_yellow": { "yellow" };
	case "rhssaf_ammo_brd_m83_purple": { "purple" };
	case "rhssaf_ammo_brd_m83_orange": { "orange" };
	case "rhssaf_ammo_brd_m83_blue": { "blue" };
	case "uk3cb_baf_smokeshell": { "white" };
	case "uk3cb_baf_smokeshellred": { "red" };
	case "uk3cb_baf_smokeshellgreen": { "green" };
	case "uk3cb_baf_smokeshellyellow": { "yellow" };
	case "uk3cb_baf_smokeshellpurple": { "purple" };
	case "uk3cb_baf_smokeshellblue": { "blue" };
	case "uk3cb_baf_smokeshellorange": { "orange" };
	case "uk3cb_baf_smokeshellyellow": { "yellow" };
	case "rhs_ammo_rdg2_black": { "black" };
	case "rhs_ammo_rdg2_white": { "white" };
	case DEFAULT { "some" };
};
//hint str _colour;
_colour;
