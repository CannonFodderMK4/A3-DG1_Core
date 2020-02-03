[]spawn {
	private ["_previousCheck","_currentCheck","_cfgRandUnits","_randUnits"];

	if !(isClass (missionConfigFile >> "cfgRandUnits")) exitwith {};

	_cfgRandUnits = "true" configClasses (missionConfigFile >> "cfgRandUnits");

	if ((count _cfgRandUnits) == 0) exitwith {};
	_randUnits = [];

	//[unit,uniform,vest,backpack,headgear,facewear,primary,sidearm,launcher,inventory] call DG1_fnc_randomKit

	{
			private ["_unit","_uniform","_vest","_backpack","_headgear","_face","_primary","_sidearm","_launcher","_inventory"];
			_unit = configName _x;
			_uniform = [(_x), "uniformList" ,false] call BIS_fnc_returnConfigEntry;
			_vest = [(_x), "vestList" ,false] call BIS_fnc_returnConfigEntry;
			_backpack = [(_x), "backpackList" ,false] call BIS_fnc_returnConfigEntry;
			_headgear = [(_x), "headgearList" ,false] call BIS_fnc_returnConfigEntry;
			_face = [(_x), "faceList" ,false] call BIS_fnc_returnConfigEntry;
			_primary = [(_x), "mainWeaponList" ,false] call BIS_fnc_returnConfigEntry;
			_sidearm = [(_x), "sidearmList" ,false] call BIS_fnc_returnConfigEntry;
			_launcher = [(_x), "launcherList" ,false] call BIS_fnc_returnConfigEntry;
			_inventory = [(_x), "inventoryList" ,false] call BIS_fnc_returnConfigEntry;
			if (_inventory isEqualTo "SPLIT") then
			{
				_invUnif = [_x, "uniformInventory" ,false] call BIS_fnc_returnConfigEntry;
				_invVest = [_x, "vestInventory" ,false] call BIS_fnc_returnConfigEntry;
				_invBack = [_x, "backpackInventory" ,false] call BIS_fnc_returnConfigEntry;
				_inventory = [_invUnif,_invVest,_invBack];
			};
			
			if !(_uniform isEqualTo false && _vest isEqualTo false && _backpack isEqualTo false && _headgear isEqualTo false && _face isEqualTo false && _primary isEqualTo false && _sidearm isEqualTo false && _launcher isEqualTo false && _inventory isEqualTo false) then 
			{
				_randUnits append [[_unit,_uniform,_vest,_backpack,_headgear,_face,_primary,_sidearm,_launcher,_inventory]];
			};
	} forEach _cfgRandUnits;

	if ((count _randUnits) == 0) exitwith {};

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
			private ["_unit"];
			_unit = _x,
			{
				_type = _x select 0;
				if (typeOf _unit == _type) exitwith
				{
					_uniform = _x select 1;
					_vest = _x select 2;
					_backpack = _x select 3;
					_headgear = _x select 4;
					_face = _x select 5;
					_primary = _x select 6;
					_sidearm = _x select 7;
					_launcher = _x select 8;
					_inventory = _x select 9;
					
					[_unit,_uniform,_vest,_backpack,_headgear,_face,_primary,_sidearm,_launcher,_inventory] call DG1_fnc_randomKit;
				};
			} forEach _randUnits;
		} forEach _currentCheck;
	};
};