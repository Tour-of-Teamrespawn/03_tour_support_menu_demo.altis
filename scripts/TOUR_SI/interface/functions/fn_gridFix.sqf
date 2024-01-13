private ["_array", "_strNew", "_posS", "_posA", "_posX", "_posY"]; 
 
_array =_this; 
_posS = str (round (_array select 0)); 
_posA = toArray _posS;
_posX = []; 
_s = 0;

for "_p" from 0 to 2 do 
{ 
	if (count _posA < 4 && (_p <= 1)) then  
	{
		_posX set [0,48];
		_posX set [1,48]; 
	}else
	{
		if (count _posA < 5 && (_p == 0)) then  
		{ 
			_posX set [0,48]; 
		}else
		{
			_posX set [_p, _posA select _s];
			_s = _s + 1; 
		};
	};
}; 

_posS = str (round (_array select 1)); 
_posA = toArray _posS; 
_posY = []; 
_s = 0;

for "_p" from 0 to 2 do 
{ 
	if (count _posA < 4 && (_p <= 1)) then  
	{
		_posY set [0,48];
		_posY set [1,48]; 
	}else
	{
		if (count _posA < 5 && (_p == 0)) then  
		{ 
			_posY set [0,48]; 
		}else
		{
			_posY set [_p, _posA select _s];
			_s = _s + 1; 
		};
	};
}; 
 
_strNew = "[" + (toString _posX) + "," + (toString _posY) + "]"; 
 
_strNew