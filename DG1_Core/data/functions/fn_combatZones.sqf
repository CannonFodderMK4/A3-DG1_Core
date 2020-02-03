_combatZones = [];
{
	if (["_CZ",triggerText _x] call BIS_fnc_inString) then
	{
		_trigTxt = (triggerText _x) splitString " ";
		switch (_trigTxt select 1) do
		{
			case "Wood": {_combatZones append [[_x,"WDL"]]};
			case "Arid": {_combatZones append [[_x,"DES"]]};
			case "Snow": {_combatZones append [[_x,"SNO"]]};
			case "Urban": {_combatZones append [[_x,"URB"]]};
		};
	};
} forEach (allMissionObjects "EmptyDetector");

_cfgTxt = [missionConfigFile, "_CZ_Base" ,""] call BIS_fnc_returnConfigEntry;

switch (_cfgTxt) do
{
	case "Wood": {_combatZones append [[_x,"WDL"]]};
	case "Arid": {_combatZones append [[_x,"DES"]]};
	case "Snow": {_combatZones append [[_x,"SNO"]]};
	case "Urban": {_combatZones append [[_x,"URB"]]};
};

if ((count _combatZones) == 0) exitWith {};
_combatZones spawn
{
	_combatZones = _this;
	_previousCheck = [];
	_currentCheck = [];
	for [{_i=0},{true},{_i=_i+1}] do
	{
		waituntil
		{
			uisleep 0.1;
			_currentCheck = allUnits;
			_currentCheck = _currentCheck - _previousCheck;
			_previousCheck = allUnits;
			(count _currentCheck >=1);
		};
		{
			if ("_WDL" in typeOf _x || "_DES" in typeOf _x || "_SNO" in typeOf _x || "_URB" in typeOf _x) then 
			{
				_unit = _x;
				_parent = false;
				if !((objectParent _x) isEqualTo objNull) then
				{
					_unit = objectParent _x;
					_parent = true;
				};
				{
					private ["_swapped"];
					_swapped = false;
					if (_unit inArea (_x select 0)) then
					{
						_unitClass = typeOf _unit;
						_search = _x select 1;
						if !(_search in _unitClass) then
						{
							_splitString = _unitClass splitString "_";
							_splitString set [(count _splitString) -1, _search];
							_newClass = _splitString joinString "_";
							
							_group = group _unit;
							
							if (_parent) then
							{
								_replacement = createVehicle [_newClass,_unit,[],0,"CAN_COLLIDE"];
								_newCrew = createVehicleCrew _replacement;
								_newCrew = units _newCrew;
								[_newCrew] join _group;
							}
							else
							{
								_group createUnit [_newClass,_unit,[],0,"CAN_COLLIDE"];
							};
							deleteVehicle _unit;
						};
						_swapped = true;
					};
					if (_swapped) exitwith {};
				} forEach _combatZones;
			};
		} forEach _currentCheck;
	};
};