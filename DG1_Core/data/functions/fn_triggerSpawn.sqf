/*-----------------------------------------------------------------------------------------------------------
	Degenerates Core Function: fn_triggerSpawn.sqf
-------------------------------------------------------------------------------------------------------------
>>Description
	This is a universal function designed to automatically spawn and despawn squads in missions. The squads are defined in the description.ext using the details int he documentation.
	
>>Documentation

	>>Syntax
		Inside Trigger Text:
			Side Squad Range
	
	>>Parameters
		Side = String : Defines which side the quad belongs to. This can be one of the following:
		
			Blufor
			Opfor
			Indep
			Civilian
			
		Squad = String : Defines the squad class from cfgSpawnGroups in the description.ext file
		Range = Number : Defines the range that the squad is activated as well as the despawn range for cleanup purposes.
	
	>>Special
		To define the squads two classes must be used with sub classes using the following hierarchy:
		
			cfgSpawnUnits
				Blufor
					Infantry
					Ground
					Air
					Water
				Opfor
					Infantry
					Ground
					Air
					Water
				Indep
					Infantry
					Ground
					Air
					Water
				Civilian
					Infantry
					Ground
					Air
					Water
			cfgSpawnGroups
				Blufor
					SquadClassName
				Opfor
					SquadClassName
				Indep
					SquadClassName
				Civilian
					SquadClassName
		
		Spawn units are defined by creating an array within the type class using the following Syntax:
		
			UnitType[] = {"UnitClassName1",probability,"UnitClassName2",probability}
			
		Squads are defined by inserting the following into the squad class:
		
			{
				Mounted = "";
				Vehicle = "";
				Leader = "";
				Infantry[] = {};
			};
			
		Mounted determines if the squad has a vehicle, this can be left blank to define a squad without a vehicle or replaced with a string matching the vehicle category ("Ground", "Air", or "Water") Air vehicles will spawn with default crew, all other vehicles will use the squad as crew.
		Vehicle defines the type of vehicle to spawn, this uses the UnitType Array defined in cfgSpawnUnits to select the apropriate vehicle (To Do: Spawn vehicle based on classname only definition).
		Leader defines the first unit placed, this is done using the unit Class name for the leader, this is not currently randomisable.
		Infantry defines the squad composition, using UnitType of the required unit, the same UnitType can be used multiple times to determine formation positions. use the format:
			Infantry[] = {"UnitType1",count,"UnitType2",count};
		
-----------------------------------------------------------------------------------------------------------*/

{
	if (["Blufor",triggerText _x] call BIS_fnc_inString || ["Opfor",triggerText _x] call BIS_fnc_inString || ["Indep",triggerText _x] call BIS_fnc_inString || ["Civilian",triggerText _x] call BIS_fnc_inString) then
	{
		_x spawn
		{
			private ["_side"];
			// Side Check
			if (["Blufor",triggerText _this] call BIS_fnc_inString) then
			{
				_side = west;
			};
			if (["Opfor",triggerText _this] call BIS_fnc_inString) then
			{
				_side = east;
			};
			if (["Indep",triggerText _this] call BIS_fnc_inString) then
			{
				_side = independent;
			};
			if (["Civilian",triggerText _this] call BIS_fnc_inString) then
			{
				_side = civilian;
			};
			
			//Get trigger defines
			_sideClass = ((triggerText _this) splitString ",. ") select 0;
			_squad = ((triggerText _this) splitString ",. ") select 1;
			_baseDist = ((triggerText _this) splitString ",. ") select 2;
			_basePos = position _this;
			_rad = (triggerArea _this) select 0;
			
			//get waypoints and save for repeated use
			_waypointPositions = [];
			_waypointBehaviours = [];
			_waypointTypes = [];
			_waypointSpeeds = [];
			if ((count (synchronizedObjects _this)) > 0) then
			{
				_waypoints = waypoints group ((synchronizedObjects _this) select 0);
				
				{
					_waypointPositions set [count _waypointPositions, waypointPosition _x];
					_waypointBehaviours set [count _waypointBehaviours, waypointBehaviour _x];
					_waypointTypes set [count _waypointTypes, waypointType _x];
					_waypointSpeeds set [count _waypointSpeeds, waypointSpeed _x];
				} forEach _waypoints;
				
				//delete waypoint slave
				deleteVehicle ((synchronizedObjects _this) select 0);
			};
			
			//remove trigger
			deleteVehicle _this;
			
			//Check if squad type defined
			if (isClass (missionConfigFile >> "cfgSpawnGroups" >> _sideClass >> _squad)) then
			{
				_squadClass = (missionConfigFile >> "cfgSpawnGroups" >> _sideClass >> _squad);
				for [{_i=0},{true},{_i=_i+1}] do
				{
					//Pause until squad in range of trigger
					waitUntil 
					{
						uisleep 5;
						({(_x distance2d _basePos) < (parseNumber _baseDist)} count allPlayers > 0);
					};
					
					//Check for Group Cap
					if ({side _x == _side} count allGroups > 240) exitWith {"Too many " + _sideClass +" groups at the same time!" call BIS_fnc_log};
					
					//Get Squad details
					_squadLead = getText (_squadClass >> "Leader");
					_squadInfantry = getArray (_squadClass >> "Infantry");
					_squadVehicle = "";
					_vehicleType = "";
					_vehicleCrew = "";
					if !((_squadClass >> "Mounted") isEqualTo "") then
					{
						_vehicleClass = getText (_squadClass >> "Vehicle");
						_vehicleType = getText (_squadClass >> "Mounted");
						
						//Create vehicle
						if (isArray (missionConfigFile >> "cfgSpawnUnits" >> _sideClass >> _vehicleType >> _vehicleClass)) then
						{
							_vehicleArray = getArray (missionConfigFile >> "cfgSpawnUnits" >> _sideClass >> _vehicleType >> _vehicleClass);
							if (count _vehicleArray >= 2 && {(_vehicleArray select 1) isEqualType 0}) then
							{
								private ["_vehicle"];
								_vehicleList = [];
								_probability = [];
								for "_i" from 0 to (count _vehicleArray -1) step 2 do
								{
									_vehicleList append [_vehicleArray select _i];
									_probability append [_vehicleArray select (_i +1)];
								};
								_vehicle = [_vehicleList, _probability] call BIS_fnc_selectRandomWeighted;
								_squadVehicle = createVehicle [_vehicle, _basePos, [], _rad, "FLY"];
								if (_vehicleType == "Air") then
								{
									_vehicleCrew = createVehicleCrew _squadVehicle;
								};
							};
						};
					};
					
					//Create Squad
					_squadGroup = createGroup _side;
					_leader = _squadGroup createUnit [_squadLead, _basePos, [], _rad, "NONE"];
					if !(_squadVehicle isEqualTo "") then
					{
						_leader moveInAny _squadVehicle;
					};
					
					_infantryUnit = [];
					_infantryCount = [];
					for "_i" from 0 to (count _squadInfantry -1) step 2 do
					{
						_infantryUnit append [_squadInfantry select _i];
						_infantryCount append [_squadInfantry select (_i +1)];
					};
					
					for "_i" from 0 to (count _infantryUnit -1) do
					{
						_unitClass = (_infantryUnit select _i);
						_count = (_infantryCount select _i);
						
						_unitArray = [];
						_unitArray = getArray (missionConfigFile >> "cfgSpawnUnits" >> _sideClass >> "Infantry" >> _unitClass);
						
						private ["_unit"];
						_unitList = [];
						_probability = [];
						_unit = "";
						for "_i" from 0 to (count _unitArray -1) step 2 do
						{
							if !(isArray (missionConfigFile >> "cfgSpawnUnits" >> _sideClass >> "Infantry" >> _unitClass)) exitwith {};
							_unitList append [_unitArray select _i];
							_probability append [_unitArray select (_i +1)];
						};
						
						for "_i" from 1 to _count do
						{
							if !(isArray (missionConfigFile >> "cfgSpawnUnits" >> _sideClass >> "Infantry" >> _unitClass)) exitwith {};
							_unit = [_unitList, _probability] call BIS_fnc_selectRandomWeighted;
							_member = _squadGroup createUnit [_unit, _leader,[],10,"NONE"];
							if !(_squadVehicle isEqualTo "") then
							{
								_member moveInAny _squadVehicle;
							};
						};
					};
					
					if ((count _waypointPositions) >= 1) then
					{
						{
							private ["_way"];
							_way = _squadGroup addWaypoint [_x, 0];
							_way setWaypointBehaviour (_waypointBehaviours select _forEachIndex);
							_way setWaypointType (_waypointTypes select _forEachIndex);
							_way setWaypointSpeed (_waypointSpeeds select _forEachIndex);
						} forEach _waypointPositions;
					}
					else
					{
						for "_i" from 0 to 4 do
						{
							private ["_way"];
							_way = _squadGroup addWaypoint [_basePos, _rad];
							_way setWaypointType "MOVE";
							_way setWaypointSpeed "LIMITED";
							_way setWaypointBehaviour "SAFE";
						};
						private ["_way"];
						_way = _squadGroup addWaypoint [waypointPosition [_squadGroup, 1], 0];
						_way setWaypointType "CYCLE";
					};
					if (_vehicleType == "Air") then
					{
						_vehicleCrew copyWaypoints _squadGroup;
					};
					
					_timeout = 0;
					
					waitUntil
					{
						uisleep 5;
						if (({(_x distance2d (leader _squadGroup)) < (parseNumber _baseDist)} count allPlayers == 0) || ({(_x distance2d (leader _squadGroup)) < ((parseNumber _baseDist) /2)} count allPlayers == 0 && !((behaviour leader _squadGroup) == "COMBAT"))) then
						{
							if (_timeout < 300) then
							{
								_timeout = _timeout +5;
							}
							else
							{
								{deletevehicle _x} forEach (units _squadGroup);
							};
						}
						else
						{
							_timeout = 0;
						};
						({alive _x} count (units _squadGroup) == 0);
					};
					
					uisleep 300;
					
					waitUntil
					{
						uisleep 5;
						({(_x distance2d _basePos) < (parseNumber _baseDist)} count allPlayers == 0);
					};
				};
				
			};
			
			
		};
	};
} forEach (allMissionObjects "EmptyDetector");