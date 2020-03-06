{
	if (["_Base",triggerText _x] call BIS_fnc_inString && count ((allMissionObjects "") inAreaArray _x) >= 1) then
	{
		_x spawn
		{
			private ["_trigTxt","_infantry","_vehicles","_statics"];
			_trigTxt = triggerText _this;
			_range = "0";
			if (count (_trigTxt splitString "., ") > 1) then
			{
				_range = (_trigTxt splitString "., ") select 1;
			}
			else
			{
				_range = [] call DG1_fnc_defaultRange;
			};
			_basePos = position _this;
			
			_infantry = [];
			_vehicles = [];
			//_statics = [];
			_groups = [];
			_vehStr = [];
			
			//Get a list of all Infantry Groups in area
			{
				if (isNull objectParent _x) then
				{
					_groups pushBackUnique (group _x);
				};
			} forEach (allUnits inAreaArray _this);
			
			//Save Infantry Groups in Area
			{
				//Get Squad Waypoints
				_waypointPositions = [];
				_waypointBehaviours = [];
				_waypointTypes = [];
				_waypointSpeeds = [];
				_waypoints = waypoints _x;
				{
					_waypointPositions set [count _waypointPositions, waypointPosition _x];
					_waypointBehaviours set [count _waypointBehaviours, waypointBehaviour _x];
					_waypointTypes set [count _waypointTypes, waypointType _x];
					_waypointSpeeds set [count _waypointSpeeds, waypointSpeed _x];
				} forEach _waypoints;
				_side = side _x;
				
				//Get Squad Members
				_squad = [];
				{
					_type = typeOf _x;
					_pos = getPosATL _x;
					_dir = getDir _x;
					_dam = getDammage _x;
					_loadout = getUnitLoadout _x;
					_squad append [[_type,_pos,_dir,_dam,_loadout]];
					deleteVehicle _x;
				} forEach (units _x);
				
				_x deleteGroupWhenEmpty true;
				
				_infantry append [[_side,_squad,_waypointPositions,_waypointBehaviours,_waypointTypes,_waypointSpeeds]]
			} forEach _groups;
			
			//Save Vehicles + crew in area
			{
				_veh = _x;
				_type = typeOf _x;
				_pos = getPosATL _x;
				_dir = getDir _x;
				_dam = getDammage _x;
				_tex = getObjectTextures _x;
				_crew = [];
				_side = west;
				_group = grpNull;
				{
					_side = side _x;
					_typeC = typeOf _x;
					_loadout = getUnitLoadout _x;
					_damC = getDammage _x;
					_crew append [[_typeC,_loadout,_damC]];
					_group = group _x;
					_group deleteGroupWhenEmpty false;
					_veh deleteVehicleCrew _x;
				} forEach (crew _x);
				
				//Get Vehicle Waypoints
				_waypointPositions = [];
				_waypointBehaviours = [];
				_waypointTypes = [];
				_waypointSpeeds = [];
				_waypoints = waypoints _group;
				{
					_waypointPositions set [count _waypointPositions, waypointPosition _x];
					_waypointBehaviours set [count _waypointBehaviours, waypointBehaviour _x];
					_waypointTypes set [count _waypointTypes, waypointType _x];
					_waypointSpeeds set [count _waypointSpeeds, waypointSpeed _x];
				} forEach _waypoints;
				
				_vehicles append [[_type,_pos,_dir,_dam,_tex,_side,_crew,_waypointPositions,_waypointBehaviours,_waypointTypes,_waypointSpeeds]];
				_vehStr append [_type];
				deleteVehicle _x;
				_group deleteGroupWhenEmpty true;
			} forEach (vehicles inAreaArray _this);
			
			/* vv Unnecessary at this time, saving for potential use later vv
			
			_allBuildings = (((allMissionObjects "") inAreaArray _this) - (allUnits inAreaArray _this)) - (vehicles inAreaArray _this);
			
			{
				if !(isSimpleObject _x) then
				{
					_type = typeOf _x;
					_pos = getPosATL _x;
					_dir = getDir _x;
					_dam = getDammage _x;
					_statics append [[_type,_pos,_dir,_dam]];
					deleteVehicle _x;
				}
			} forEach _allBuildings; 
			
			^^ Unnecessary at this time, saving for potential use later ^^*/
			
			if (((count _infantry) + (count _vehicles)) > 0) then
			{
				waitUntil
				{
					uisleep 5;
					({(_x distance2d _basePos) < (parseNumber _range)} count allPlayers > 0);
				};
				//Load Infantry
				{
					_grp = createGroup (_x select 0);
					{
						_unit = _grp createUnit [(_x select 0),[0,0,0],[],0,"CAN_COLLIDE"];
						_unit setPosATL (_x select 1);
						_unit setDir (_x select 2);
						_unit setFormDir (_x select 2);
						_unit setUnitLoadout (_x select 4);
						_unit setDammage (_x select 3);
					} forEach (_x select 1);
					
					if (count (_x select 2) > 0) then
					{
						_waypointBehaviours = (_x select 3);
						_waypointTypes = (_x select 4);
						_waypointSpeeds = (_x select 5);
						
						{
							private ["_way"];
							_way = _grp addWaypoint [_x, 0];
							_way setWaypointBehaviour (_waypointBehaviours select _forEachIndex);
							_way setWaypointType (_waypointTypes select _forEachIndex);
							_way setWaypointSpeed (_waypointSpeeds select _forEachIndex);
						} forEach (_x select 2);
					};
					
					((waypoints _grp) select 1) setWaypointPosition [(getPosASL(leader _grp)),-1];
					
				} forEach _infantry;
				
				{
					_veh = createVehicle [(_x select 0),(_x select 1),[],0,"CAN_COLLIDE"];
					_veh setDir (_x select 2);
					{
						_veh setObjectTextureGlobal [_forEachIndex,_x];
					} forEach (_x select 4);
					
					_grp = createGroup (_x select 5);
					_grp addVehicle _veh;
					{
						_unit = _grp createUnit [(_x select 0),[0,0,0],[],0,"NONE"];
						_unit setUnitLoadout (_x select 1);
						_unit setDammage (_x select 2);
					} forEach (_x select 6);
					
					{_x moveInAny _veh;} forEach units _grp;
					
					_veh setDammage (_x select 3);
					
					if (count (_x select 7) > 0) then
					{
						_waypointBehaviours = (_x select 8);
						_waypointTypes = (_x select 9);
						_waypointSpeeds = (_x select 10);
						
						{
							private ["_way"];
							_way = _grp addWaypoint [_x, 0];
							_way setWaypointBehaviour (_waypointBehaviours select _forEachIndex);
							_way setWaypointType (_waypointTypes select _forEachIndex);
							_way setWaypointSpeed (_waypointSpeeds select _forEachIndex);
						} forEach (_x select 7);
					};
					
					((waypoints _grp) select 1) setWaypointPosition [(getPosASL(leader _grp)),-1];
					
				} forEach _vehicles;
			};
			
		};
	};
}forEach (allMissionObjects "EmptyDetector");