/*-----------------------------------------------------------------------------------------------------------
	Degenerates Core Function: fn_randomKit.sqf
-------------------------------------------------------------------------------------------------------------
>>Description
	This is a universal function designed to randomise a unit's equipment based on preset limits. This function will work with any unit in both the config file and the init in the 3DEN editor.
	
>>Documentation

	>>Syntax
		[unit,uniform,vest,backpack,headgear,facewear,primary,sidearm,launcher,inventory] call DG1_fnc_randomKit
		
	>>Parameters
		unit = Object : Unit to randomise
		uniform = Array or Boolean : Uniform list; this can be marked false to ignore. Use format ["uniform1",probability,"uniform2",probability], leave array empty to use unit config array "uniformList".
		vest = Array or Boolean : Vest list; this can be marked false to ignore. Use format ["vest1",probability,"vest2",probability], leave array empty to use unit config array "vestList".
		backpack = Array or Boolean : Backpack list; this can be marked false to ignore. Use format ["backpack1",probability,"backpack2",probability], leave array empty to use unit config array "backpackList".
		headgear = Array or Boolean : Headgear list; this can be marked false to ignore. Use format ["headgear1",probability,"headgear2",probability], leave array empty to use unit config array "headgearList".
		face = Array or Boolean : Facewear list; this can be marked false to ignore. Use format ["face1",probability,"face2",probability], leave array empty to use unit config array "faceList".
		primary = Array or Boolean : Main weapon list; this can be marked false to ignore. Use format ["primary1",probability,"primary2",probability], leave array empty to use unit config array "mainWeaponList", will automatically load with default round.
		sidearm = Array or Boolean : Sidearm list; this can be marked false to ignore. Use format ["sidearm1",probability,"sidearm2",probability], leave array empty to use unit config array "sidearmList", will automatically load with default round.
		launcher = Array or Boolean : Launcher list; this can be marked false to ignore. Use format ["launcher1",probability,"launcher2",probability], leave array empty to use unit config array "launcherList", will automatically load with default round.
		inventory = Array, Boolean, or String : Inventory list; this can be marked false to ignore. Use format ["inventory1",amount,"inventory2",amount]. Leave array empty to use unit config array "inventoryList" or, alternatively, use 'SPLIT' to define the use of "uniformInventory", "vestInventory" and "backpackInventory" arrays to define where items go.
		
	>>Special
		To add any of the config arrays, use the following syntax and replace with the appropriate array name and items as listed above:
		
			uniformList[] = {"uniform1",probability,"uniform2",probability};
		
		To call this from a config, add the following to the cfgVehicle class for your unit adhering to the syntax mentioned in Parameters:
		
			class EventHandlers
			{
				init="[(_this select 0),[],[],[],[],[],[],[],[],[]] call DG1_fnc_randomKit;"
			};
			
		You can disable any of the randomisations by marking the relevant position false and you can use the split inventory assignment by marking the last position 'SPLIT'.
			
		If type is not known, weapon magazines can be defined using "AMMO_PRIMARY", "AMMO_SIDEARM" & "AMMO_LAUNCHER" to automatically pick the default ammo for the relevant weapon. If magazine type is known for the weapon the class name can also be used.
		
	>>Examples
		The below is an example unit that uses the OPTRE Mod to make a randomised insurgent:
		
			class DG1_OPTRE_INNI_Rifleman_O: O_Soldier_base_F
			{
				faction="DG1_OPTRE_INNI_Insurrectionist_O";
				side=0;
				scope=2;
				displayName="Insurrectionist (Rifle)";
				editorSubcategory="EdSubcat_Personnel";
				
			//Randomiser List
				uniformList[]={"OPTRE_Ins_ER_jacket_brown_surplus",1,"OPTRE_Ins_ER_uniform_GGgrey",1,"OPTRE_Ins_ER_uniform_GGod",1,"OPTRE_Ins_ER_rolled_surplus_black",1,"OPTRE_Ins_ER_rolled_jean_orca",1,"OPTRE_Ins_ER_rolled_OD_blknblu",1,"OPTRE_Ins_ER_rolled_OD_blknred",1,"OPTRE_Ins_ER_rolled_OD_crimson",1,"OPTRE_Ins_ER_rolled_surplus_crimson",1,"OPTRE_Ins_ER_jacket_surplus_brown",1,"OPTRE_Ins_ER_jacket_surplus_OD",1,"OPTRE_Ins_ER_jacket_surplus_redshirt",1};
				vestList[]={"V_LegStrapBag_black_F",1,"V_LegStrapBag_coyote_F",1,"V_LegStrapBag_olive_F",1,"V_Rangemaster_belt",1,"V_BandollierB_blk",2,"V_BandollierB_cbr",2,"V_BandollierB_rgr",2,"V_BandollierB_khk",2,"V_BandollierB_oli",2};
				backpackList[]={"NO_BACKPACK",1};
				headgearList[]={"NO_HEADGEAR",10,"H_Bandanna_gry",1,"H_Bandanna_blu",1,"H_Bandanna_cbr",1,"H_Bandanna_khk_hs",1,"H_Bandanna_khk",1,"H_Bandanna_mcamo",1,"H_Bandanna_sgg",1,"H_Bandanna_sand",1,"H_Bandanna_camo",1,"H_Watchcap_blk",1,"H_Watchcap_cbr",1,"H_Watchcap_camo",1,"H_Watchcap_khk",1,"H_Beret_blk",1,"H_Booniehat_mgrn",1,"OPTRE_h_Booniehat_Grey",1,"H_Booniehat_khk_hs",1,"H_Booniehat_khk",1,"H_Booniehat_mcamo",1,"H_Booniehat_oli",1,"H_Booniehat_tan",1,"H_Booniehat_taiga",1,"H_Booniehat_tna_F",1,"H_Booniehat_wdl",1,"H_Cap_blk",1,"H_Cap_grn",1,"H_Cap_oli",1,"H_Cap_oli_hs",1,"H_Cap_red",1,"H_Cap_tan",1,"H_Hat_brown",1,"H_Hat_grey",1,"H_Hat_tan",1,"H_Cap_marshal",1,"H_MilCap_blue",1,"OPTRE_h_PatrolCap_Brown",1,"H_MilCap_grn",1,"OPTRE_h_PatrolCap_Green",1,"H_MilCap_gry",1,"H_MilCap_mcamo",1,"H_MilCap_tna_F",1,"H_MilCap_wdl",1,"H_Cap_headphones",1,"OPTRE_UNSC_Watchcap",1,"H_WirelessEarpiece_F",1};
				faceList[]={"NO_FACE",10,"G_Aviator",1,"G_Bandanna_aviator",1,"G_Bandanna_beast",1,"G_Bandanna_blk",1,"G_Bandanna_khk",1,"G_Bandanna_oli",1,"G_Bandanna_shades",1,"G_Bandanna_sport",1,"G_Bandanna_tan",1,"OPTRE_Glasses_Cigarette",1,"G_Combat",1,"G_Combat_Goggles_tna_F",1,"G_Lady_Blue",1,"G_Lowprofile",1,"G_Shades_Black",1,"G_Shades_Blue",1,"G_Shades_Green",1,"G_Shades_Red",1,"G_Spectacles",1,"G_Sport_Red",1,"G_Sport_Blackyellow",1,"G_Sport_BlackWhite",1,"G_Sport_Checkered",1,"G_Sport_Blackred",1,"G_Sport_Greenblack",1,"G_Spectacles_Tinted",1,"G_WirelessEarpiece_F",1};
				mainWeaponList[]={"OPTRE_MA32",5,"OPTRE_BR55",1,"arifle_AK12_F",5,"arifle_AK12U_F",5,"hgun_PDW2000_F",25,"arifle_TRG20_F",4,"arifle_Mk20_plain_F",5,"arifle_Mk20C_plain_F",5,"arifle_Katiba_F",2,"arifle_Katiba_C_F",3,"OPTRE_MA37",1,"SMG_05_F",25,"arifle_MX_Black_F",2,"arifle_MXC_Black_F",2,"arifle_MXM_Black_F",1,"SMG_03C_black",4,"SMG_03_black",1,"arifle_MSBS65_black_F",4,"arifle_MSBS65_Mark_black_F",1,"SMG_02_F",25,"arifle_TRG21_F",1,"SMG_01_F",25};
				sidearmList[]={"NO_WEAPON",1,"OPTRE_M6C",1};
				launcherList[]={"NO_WEAPON",1};
				inventoryList[]={"ACE_EarPlugs",1,"ACE_fieldDressing",10,"ACE_morphine",5,"ACE_epinephrine",2,"OPTRE_M2_Smoke",2,"OPTRE_M9_Frag",2,"AMMO_PRIMARY",5,"AMMO_SIDEARM",2};
				
			//Linked items (not randomised)
				linkedItems[]={"ItemRadio","ItemMap","ItemCompass","ItemWatch","OPTRE_Binoculars"};
				respawnLinkedItems[]={"ItemRadio","ItemMap","ItemCompass","ItemWatch","OPTRE_Binoculars"};
				weapons[]={"OPTRE_Binoculars","Put","Throw"};
				respawnWeapons[]={"OPTRE_Binoculars","Put","Throw"};
				
			//Clear Identity to ensure BIS default randomisation doesn't happen
				identityTypes[] = {"NoGlasses","LanguageENG_F","Head_NATO"};
				
			//Call Event Handler to run randomisation on unit creation
				class EventHandlers
				{
					init="[(_this select 0),[],[],[],[],[],[],[],[],[]] call DG1_fnc_randomKit;"
				};
			};
			
		The below is an alternate example using the same mod but splitting the inventory items by where they need to be placed:
		
			class DG1_OPTRE_INNI_Rifleman_O: O_Soldier_base_F
			{
				faction="DG1_OPTRE_INNI_Insurrectionist_O";
				side=0;
				scope=2;
				displayName="Insurrectionist (Rifle)";
				editorSubcategory="EdSubcat_Personnel";
				
			//Randomiser List
				weapons[]={"OPTRE_Binoculars","OPTRE_M73","OPTRE_M6C","Put","Throw"};
				respawnWeapons[]={"OPTRE_Binoculars","OPTRE_M73","OPTRE_M6C","Put","Throw"};
				uniformList[]={"OPTRE_Ins_ER_uniform_GAgreen",1,"OPTRE_Ins_ER_uniform_GAtan",1,"OPTRE_Ins_ER_uniform_GGgrey",1,"OPTRE_Ins_ER_uniform_GGod",1,"U_I_E_Uniform_01_sweater_F",1,"U_I_G_resistanceLeader_F",1,"U_I_E_Uniform_01_tanktop_F",1,"U_B_CombatUniform_mcam_tshirt",1,"U_B_CombatUniform_tshirt_mcam_wdL_f",1,"OPTRE_Ins_URF_Combat_Uniform",1,"U_I_C_Soldier_Para_2_F",1,"U_I_C_Soldier_Para_3_F",1,"U_I_C_Soldier_Para_4_F",1,"U_I_C_Soldier_Para_1_F",1,"U_I_L_Uniform_01_tshirt_olive_F",1,"U_BG_Guerilla2_3",1,"U_BG_Guerilla1_1",1,"U_BG_Guerilla1_2_F",1,"U_BG_Guerrilla_6_1",1};
				vestList[]={"V_PlateCarrier1_blk",1,"V_PlateCarrier1_rgr_noflag_F",1,"V_Chestrig_blk",1,"V_Chestrig_rgr",1,"V_Chestrig_khk",1,"V_Chestrig_oli",1,"V_PlateCarrierIA1_dgtl",1,"V_SmershVest_01_F",1,"V_SmershVest_01_radio_F",1,"V_HarnessOGL_brn",1,"V_HarnessOGL_ghex_F",1,"V_HarnessOGL_gry",1,"V_HarnessO_brn",1,"V_HarnessO_ghex_F",1,"V_HarnessO_gry",1,"V_CarrierRigKBT_01_light_EAF_F",1,"V_CarrierRigKBT_01_light_Olive_F",1,"V_TacVestIR_blk",1,"V_TacChestrig_cbr_F",1,"V_TacChestrig_grn_F",1,"V_TacChestrig_oli_F",1,"V_TacVest_blk",1,"V_TacVest_brn",1,"V_TacVest_camo",1,"V_TacVest_khk",1,"V_TacVest_oli",1,"V_I_G_resistanceLeader_F",1};
				backpackList[]={"B_AssaultPack_blk",1,"B_AssaultPack_cbr",1,"B_AssaultPack_eaf_F",1,"B_AssaultPack_rgr",1,"B_AssaultPack_khk",1,"B_AssaultPack_mcamo",1,"B_AssaultPack_sgg",1,"B_AssaultPack_tna_F",1,"B_AssaultPack_wdl_F",1,"B_FieldPack_blk",1,"B_FieldPack_cbr",1,"B_FieldPack_ghex_F",1,"B_FieldPack_green_F",1,"B_FieldPack_ocamo",1,"B_FieldPack_khk",1,"B_FieldPack_oli",1,"B_FieldPack_taiga_F",1,"B_FieldPack_oucamo",1,"B_Messenger_Black_F",1,"B_Messenger_Coyote_F",1,"B_Messenger_Gray_F",1,"B_Messenger_Olive_F",1};
				headgearList[]={"NO_HEADGEAR",10,"H_Bandanna_gry",1,"H_Bandanna_blu",1,"H_Bandanna_cbr",1,"H_Bandanna_khk_hs",1,"H_Bandanna_khk",1,"H_Bandanna_mcamo",1,"H_Bandanna_sgg",1,"H_Bandanna_sand",1,"H_Bandanna_camo",1,"H_Watchcap_blk",1,"H_Watchcap_cbr",1,"H_Watchcap_camo",1,"H_Watchcap_khk",1,"H_Beret_blk",1,"H_Booniehat_mgrn",1,"OPTRE_h_Booniehat_Grey",1,"H_Booniehat_khk_hs",1,"H_Booniehat_khk",1,"H_Booniehat_mcamo",1,"H_Booniehat_oli",1,"H_Booniehat_tan",1,"H_Booniehat_taiga",1,"H_Booniehat_tna_F",1,"H_Booniehat_wdl",1,"H_Cap_blk",1,"H_Cap_grn",1,"H_Cap_oli",1,"H_Cap_oli_hs",1,"H_Cap_red",1,"H_Cap_tan",1,"H_Hat_brown",1,"H_Hat_grey",1,"H_Hat_tan",1,"H_Cap_marshal",1,"H_MilCap_blue",1,"OPTRE_h_PatrolCap_Brown",1,"H_MilCap_grn",1,"OPTRE_h_PatrolCap_Green",1,"H_MilCap_gry",1,"H_MilCap_mcamo",1,"H_MilCap_tna_F",1,"H_MilCap_wdl",1,"H_Cap_headphones",1,"OPTRE_UNSC_Watchcap",1,"H_WirelessEarpiece_F",1};
				faceList[]={"NO_FACE",10,"G_Aviator",1,"G_Bandanna_aviator",1,"G_Bandanna_beast",1,"G_Bandanna_blk",1,"G_Bandanna_khk",1,"G_Bandanna_oli",1,"G_Bandanna_shades",1,"G_Bandanna_sport",1,"G_Bandanna_tan",1,"OPTRE_Glasses_Cigarette",1,"G_Combat",1,"G_Combat_Goggles_tna_F",1,"G_Lady_Blue",1,"G_Lowprofile",1,"G_Shades_Black",1,"G_Shades_Blue",1,"G_Shades_Green",1,"G_Shades_Red",1,"G_Spectacles",1,"G_Sport_Red",1,"G_Sport_Blackyellow",1,"G_Sport_BlackWhite",1,"G_Sport_Checkered",1,"G_Sport_Blackred",1,"G_Sport_Greenblack",1,"G_Spectacles_Tinted",1,"G_WirelessEarpiece_F",1};
				mainWeaponList[]={"arifle_RPK12_F",10,"LMG_Zafir_F",5,"arifle_MX_SW_Black_F",10,"OPTRE_M247",2,"MMG_02_black_F",1,"MMG_02_sand_F",1,"arifle_SPAR_02_blk_F",10,"arifle_SPAR_02_snd_F",10,"MMG_01_tan_F",1,"LMG_03_F",10,"OPTRE_M73",2};
				sidearmList[]={"OPTRE_M6C",1};
				launcherList[]={"NO_WEAPON",1};
				uniformInventory[]={"ACE_EarPlugs",1,"ACE_fieldDressing",5};
				vestInventory[]={"AMMO_SIDEARM",2,"ACE_fieldDressing",5,"ACE_morphine",5,"ACE_epinephrine",2,"OPTRE_M2_Smoke",2,"OPTRE_M9_Frag",2,"AMMO_PRIMARY",5};
				backpackInventory[]={"AMMO_PRIMARY",10};
				
			//Linked items (not randomised)
				linkedItems[]={"ItemRadio","ItemMap","ItemCompass","ItemWatch","OPTRE_Binoculars"};
				respawnLinkedItems[]={"ItemRadio","ItemMap","ItemCompass","ItemWatch","OPTRE_Binoculars"};
				weapons[]={"OPTRE_Binoculars","Put","Throw"};
				respawnWeapons[]={"OPTRE_Binoculars","Put","Throw"};
				
			//Clear Identity to ensure BIS default randomisation doesn't happen
				identityTypes[] = {"NoGlasses","LanguageENG_F","Head_NATO"};
				
			//Call Event Handler to run randomisation on unit creation
				class EventHandlers
				{
					init="[(_this select 0),[],[],[],[],[],[],[],[],'SPLIT'] call DG1_fnc_randomKit;"
				};
			};
		
-----------------------------------------------------------------------------------------------------------*/

private ["_unit","_uniform","_vest","_backpack","_headgear","_face","_Pweapon","_Sweapon","_Tweapon","_inv"];

_unit = param [0,objNull,[objNull]];
_uniform = param [1,false,[[],false]];
_vest = param [2,false,[[],false]];
_backpack = param [3,false,[[],false]];
_headgear = param [4,false,[[],false]];
_face = param [5,false,[[],false]];
_Pweapon = param [6,false,[[],false]];
_Sweapon = param [7,false,[[],false]];
_Tweapon = param [8,false,[[],false]];
_nvg = param [9,false,[[],false,""]];
_inv = param [10,false,[[],false,""]];

//Ignore script during 3den editor & if custom loadout has been set.
if (_unit getVariable ["saved3DDENInventory",false]) exitWith {};

//check for local status
if (isMultiplayer && !(local _unit)) exitWith {false};

//Prepare Variables
_unitType = (typeOf _unit);

//Set uniform
if !(_uniform isEqualTo false) then 
{
	_uniformToUse = "";
	private ["_uniformList","_uniformPool","_probabilityPool"];
	if (_uniform isEqualType []) then
	{
		if (count _uniform >= 1) then
		{
			_uniformList = _uniform;
		}
		else
		{
			_uniformList = getArray(configFile >> "CfgVehicles" >> _unitType >> "uniformList");
		};
		if (count _uniformList >= 2 && {(_uniformList select 1) isEqualType 0}) then
		{
			_uniformPool = [];
			_probabilityPool = [];
			for "_i" from 0 to (count _uniformList -1) step 2 do
			{
				_uniformPool append [_uniformList select _i];
				_probabilityPool append [_uniformList select (_i +1)];
			};
			_uniformToUse = [_uniformPool, _probabilityPool] call BIS_fnc_selectRandomWeighted;
		};
	};
	if (isClass (configFile >> "CfgWeapons" >> _uniformToUse)) then
	{
		private _IsScopePrivate = (getNumber(configFile >> "CfgWeapons" >> _uniformToUse >> "scope") <1);
		if !(_IsScopePrivate) then
		{
			removeUniform _unit;
			_unit forceAddUniform _uniformToUse;
		};
	}
	else
	{
		if (_uniformToUse == "NO_UNIFORM") then
		{
			removeUniform _unit;
		};
	};
};

//Set vest
if !(_vest isEqualTo false) then 
{
	_vestToUse = "";
	private ["_vestList","_vestPool","_probabilityPool"];
	if (_vest isEqualType []) then
	{
		if (count _vest >= 1) then
		{
			_vestList = _vest;
		}
		else
		{
			_vestList = getArray(configFile >> "CfgVehicles" >> _unitType >> "vestList");
		};
		if (count _vestList >= 2 && {(_vestList select 1) isEqualType 0}) then
		{
			_vestPool = [];
			_probabilityPool = [];
			for "_i" from 0 to (count _vestList -1) step 2 do
			{
				_vestPool append [_vestList select _i];
				_probabilityPool append [_vestList select (_i +1)];
			};
			_vestToUse = [_vestPool, _probabilityPool] call BIS_fnc_selectRandomWeighted;
		};
	};
	if (isClass (configFile >> "CfgWeapons" >> _vestToUse)) then
	{
		private _IsScopePrivate = (getNumber(configFile >> "CfgWeapons" >> _vestToUse >> "scope") <1);
		if !(_IsScopePrivate) then
		{
			removeVest _unit;
			_unit addVest _vestToUse;
		};
	}
	else
	{
		if (_vestToUse == "NO_VEST") then
		{
			removeVest _unit;
		};
	};
};

//Set backpack
if !(_backpack isEqualTo false) then 
{
	_backpackToUse = "";
	private ["_backpackList","_backpackPool","_probabilityPool"];
	if (_backpack isEqualType []) then
	{
		if (count _backpack >= 1) then
		{
			_backpackList = _backpack;
		}
		else
		{
			_backpackList = getArray(configFile >> "CfgVehicles" >> _unitType >> "backpackList");
		};
		if (count _backpackList >= 2 && {(_backpackList select 1) isEqualType 0}) then
		{
			_backpackPool = [];
			_probabilityPool = [];
			for "_i" from 0 to (count _backpackList -1) step 2 do
			{
				_backpackPool append [_backpackList select _i];
				_probabilityPool append [_backpackList select (_i +1)];
			};
			_backpackToUse = [_backpackPool, _probabilityPool] call BIS_fnc_selectRandomWeighted;
		};
	};
	if (isClass (configFile >> "CfgVehicles" >> _backpackToUse)) then
	{
		private _IsScopePrivate = (getNumber(configFile >> "CfgVehicles" >> _backpackToUse >> "scope") <1);
		if !(_IsScopePrivate) then
		{
			removeBackpack _unit;
			_unit addBackpack _backpackToUse;
		};
	}
	else
	{
		if (_backpackToUse == "NO_BACKPACK") then
		{
			removeBackpack _unit;
		};
	};
};

//Set headgear
if !(_headgear isEqualTo false) then 
{
	_headgearToUse = "";
	private ["_headgearList","_headgearPool","_probabilityPool"];
	if (_headgear isEqualType []) then
	{
		if (count _headgear >= 1) then
		{
			_headgearList = _headgear;
		}
		else
		{
			_headgearList = getArray(configFile >> "CfgVehicles" >> _unitType >> "headgearList");
		};
		if (count _headgearList >= 2 && {(_headgearList select 1) isEqualType 0}) then
		{
			_headgearPool = [];
			_probabilityPool = [];
			for "_i" from 0 to (count _headgearList -1) step 2 do
			{
				_headgearPool append [_headgearList select _i];
				_probabilityPool append [_headgearList select (_i +1)];
			};
			_headgearToUse = [_headgearPool, _probabilityPool] call BIS_fnc_selectRandomWeighted;
		};
	};
	if (isClass (configFile >> "CfgWeapons" >> _headgearToUse)) then
	{
		private _IsScopePrivate = (getNumber(configFile >> "CfgWeapons" >> _headgearToUse >> "scope") <1);
		if !(_IsScopePrivate) then
		{
			removeHeadgear _unit;
			_unit addHeadgear _headgearToUse;
		};
	}
	else
	{
		if (_headgearToUse == "NO_HEADGEAR") then
		{
			removeHeadgear _unit;
		};
	};
};

//Set face
if !(_face isEqualTo false) then 
{
	_faceToUse = "";
	private ["_faceList","_facePool","_probabilityPool"];
	if (_face isEqualType []) then
	{
		if (count _face >= 1) then
		{
			_faceList = _face;
		}
		else
		{
			_faceList = getArray(configFile >> "CfgVehicles" >> _unitType >> "faceList");
		};
		if (count _faceList >= 2 && {(_faceList select 1) isEqualType 0}) then
		{
			_facePool = [];
			_probabilityPool = [];
			for "_i" from 0 to (count _faceList -1) step 2 do
			{
				_facePool append [_faceList select _i];
				_probabilityPool append [_faceList select (_i +1)];
			};
			_faceToUse = [_facePool, _probabilityPool] call BIS_fnc_selectRandomWeighted;
		};
	};
	if (isClass (configFile >> "cfgGlasses" >> _faceToUse)) then
	{
		removeGoggles _unit;
		_unit addGoggles _faceToUse;
	}
	else
	{
		if (_faceToUse == "NO_FACE") then
		{
			removeGoggles _unit;
		};
	};
};

//Set Pweapon
if !(_Pweapon isEqualTo false) then 
{
	_PweaponToUse = "";
	private ["_PweaponList","_PweaponPool","_probabilityPool"];
	if (_Pweapon isEqualType []) then
	{
		if (count _Pweapon >= 1) then
		{
			_PweaponList = _Pweapon;
		}
		else
		{
			_PweaponList = getArray(configFile >> "CfgVehicles" >> _unitType >> "mainWeaponList");
		};
		if (count _PweaponList >= 2 && {(_PweaponList select 1) isEqualType 0}) then
		{
			_PweaponPool = [];
			_probabilityPool = [];
			for "_i" from 0 to (count _PweaponList -1) step 2 do
			{
				_PweaponPool append [_PweaponList select _i];
				_probabilityPool append [_PweaponList select (_i +1)];
			};
			_PweaponToUse = [_PweaponPool, _probabilityPool] call BIS_fnc_selectRandomWeighted;
		};
	};
	if (isClass (configFile >> "CfgWeapons" >> _PweaponToUse)) then
	{
		_pWeap = primaryWeapon _unit;
		if !(_pWeap == "") then {
			_unit removeWeapon _pWeap;
		};
		[_unit, _PweaponToUse,1] call BIS_fnc_addWeapon;
	}
	else
	{
		if (_PweaponToUse == "NO_WEAPON") then
		{
			_pWeap = primaryWeapon _unit;
			if !(_pWeap == "") then {
				_unit removeWeapon _pWeap;
			};
		};
	};
};

//Set Sweapon
if !(_Sweapon isEqualTo false) then 
{
	_SweaponToUse = "";
	private ["_SweaponList","_SweaponPool","_probabilityPool"];
	if (_Sweapon isEqualType []) then
	{
		if (count _Sweapon >= 1) then
		{
			_SweaponList = _Sweapon;
		}
		else
		{
			_SweaponList = getArray(configFile >> "CfgVehicles" >> _unitType >> "sidearmList");
		};
		if (count _SweaponList >= 2 && {(_SweaponList select 1) isEqualType 0}) then
		{
			_SweaponPool = [];
			_probabilityPool = [];
			for "_i" from 0 to (count _SweaponList -1) step 2 do
			{
				_SweaponPool append [_SweaponList select _i];
				_probabilityPool append [_SweaponList select (_i +1)];
			};
			_SweaponToUse = [_SweaponPool, _probabilityPool] call BIS_fnc_selectRandomWeighted;
		};
	};
	if (isClass (configFile >> "CfgWeapons" >> _SweaponToUse)) then
	{
		_sWeap = handgunWeapon _unit;
		if !(_sWeap == "") then {
			_unit removeWeapon _sWeap;
		};
		[_unit, _SweaponToUse,1] call BIS_fnc_addWeapon;
	}
	else
	{
		if (_SweaponToUse == "NO_WEAPON") then
		{
			_sWeap = handgunWeapon _unit;
			if !(_sWeap == "") then {
				_unit removeWeapon _sWeap;
			};
		};
	};
};

//Set Tweapon
if !(_Tweapon isEqualTo false) then 
{
	_TweaponToUse = "";
	private ["_TweaponList","_TweaponPool","_probabilityPool"];
	if (_Tweapon isEqualType []) then
	{
		if (count _Tweapon >= 1) then
		{
			_TweaponList = _Tweapon;
		}
		else
		{
			_TweaponList = getArray(configFile >> "CfgVehicles" >> _unitType >> "launcherList");
		};
		if (count _TweaponList >= 2 && {(_TweaponList select 1) isEqualType 0}) then
		{
			_TweaponPool = [];
			_probabilityPool = [];
			for "_i" from 0 to (count _TweaponList -1) step 2 do
			{
				_TweaponPool append [_TweaponList select _i];
				_probabilityPool append [_TweaponList select (_i +1)];
			};
			_TweaponToUse = [_TweaponPool, _probabilityPool] call BIS_fnc_selectRandomWeighted;
		};
	};
	if (isClass (configFile >> "CfgWeapons" >> _TweaponToUse)) then
	{
		_tWeap = secondaryWeapon _unit;
		if !(_tWeap == "") then {
			_unit removeWeapon _tWeap;
		};
		[_unit, _TweaponToUse,1] call BIS_fnc_addWeapon;
	}
	else
	{
		if (_TweaponToUse == "NO_WEAPON") then
		{
			_tWeap = secondaryWeapon _unit;
			if !(_tWeap == "") then {
				_unit removeWeapon _tWeap;
			};
		};
	};
};

if !(_nvg isEqualTo false) then 
{
	_nvgToUse = "";
	private ["_nvgList","_nvgPool","_probabilityPool"];
	if (_nvg isEqualType []) then
	{
		if (count _nvg >= 1) then
		{
			_nvgList = _nvg;
		}
		else
		{
			_nvgList = getArray(configFile >> "CfgVehicles" >> _unitType >> "nvgList");
		};
		if (count _nvgList >= 2 && {(_nvgList select 1) isEqualType 0}) then
		{
			_nvgPool = [];
			_probabilityPool = [];
			for "_i" from 0 to (count _nvgList -1) step 2 do
			{
				_nvgPool append [_nvgList select _i];
				_probabilityPool append [_nvgList select (_i +1)];
			};
			_nvgToUse = [_nvgPool, _probabilityPool] call BIS_fnc_selectRandomWeighted;
		};
	};
	if (isClass (configFile >> "cfgGlasses" >> _nvgToUse)) then
	{
		_equipped = hmd _unit;
		_unit unlinkItem _equipped;
		_unit linkItem _nvgToUse;
	}
	else
	{
		if (_nvgToUse == "NO_NVG") then
		{
			_equipped = hmd _unit;
			_unit unlinkItem _equipped;;
		};
	};
};

if !(_inv isEqualTo false) then
{
	private ["_invList","_itemList","_itemAmount","_item", "_count"];
	if (_inv isEqualType []) then
	{
		if !((_inv select 0) isEqualType []) then
		{
			if (count _inv >= 1) then
			{
				_invList = _inv;
			}
			else
			{
				_invList = getArray(configFile >> "CfgVehicles" >> _unitType >> "inventoryList");
			};
			_itemList = [];
			_itemAmount = [];
			for "_i" from 0 to (count _invList -1) step 2 do
			{
				_itemList append [_invList select _i];
				_itemAmount append [_invList select (_i +1)];
			};
			for "_i" from 0 to (count _itemList -1) do
			{
				_item = (_itemList select _i);
				_count = (_itemAmount select _i);
				if (_item == "AMMO_PRIMARY" || _item == "AMMO_SIDEARM" || _item == "AMMO_LAUNCHER") then
				{
					_pWeap = primaryWeapon _unit;
					_sWeap = handgunWeapon _unit;
					_tWeap = secondaryWeapon _unit;
					
					if (_item == "AMMO_PRIMARY" && !(_pWeap == "")) then
					{
						_magazines = getArray(configFile >> "CfgWeapons" >> _pWeap >> "magazines");
						_mag = _magazines select 0;
						for "_i" from 1 to _count do
						{
							_unit addItem _mag;
						};
					};
					
					if (_item == "AMMO_SIDEARM" && !(_sWeap == "")) then
					{
						_magazines = getArray(configFile >> "CfgWeapons" >> _sWeap >> "magazines");
						_mag = _magazines select 0;
						for "_i" from 1 to _count do
						{
							_unit addItem _mag;
						};
					};
					
					if (_item == "AMMO_LAUNCHER" && !(_tWeap == "")) then
					{
						_magazines = getArray(configFile >> "CfgWeapons" >> _tWeap >> "magazines");
						_mag = _magazines select 0;
						for "_i" from 1 to _count do
						{
							_unit addItem _mag;
						};
					};
				}
				else
				{
					for "_i" from 1 to _count do
					{
						_unit addItem _item;
					};
				};
			};
		}
		else
		{
			_invList = _inv select 0;
			_itemList = [];
			_itemAmount = [];
			for "_i" from 0 to (count _invList -1) step 2 do
			{
				_itemList append [_invList select _i];
				_itemAmount append [_invList select (_i +1)];
			};
			for "_i" from 0 to (count _itemList -1) step 1 do
			{
				private ["_item", "_count"];
				_item = (_itemList select _i);
				_count = (_itemAmount select _i);
				if (_item == "AMMO_PRIMARY" || _item == "AMMO_SIDEARM" || _item == "AMMO_LAUNCHER") then
				{
					_pWeap = primaryWeapon _unit;
					_sWeap = handgunWeapon _unit;
					_tWeap = secondaryWeapon _unit;
					
					if (_item == "AMMO_PRIMARY" && !(_pWeap == "")) then
					{
						_magazines = getArray(configFile >> "CfgWeapons" >> _pWeap >> "magazines");
						_mag = _magazines select 0;
						for "_i" from 1 to _count step 1 do
						{
							_unit addItemToUniform _mag;
						};
					};
					
					if (_item == "AMMO_SIDEARM" && !(_sWeap == "")) then
					{
						_magazines = getArray(configFile >> "CfgWeapons" >> _sWeap >> "magazines");
						_mag = _magazines select 0;
						for "_i" from 1 to _count step 1 do
						{
							_unit addItemToUniform _mag;
						};
					};
					
					if (_item == "AMMO_LAUNCHER" && !(_tWeap == "")) then
					{
						_magazines = getArray(configFile >> "CfgWeapons" >> _tWeap >> "magazines");
						_mag = _magazines select 0;
						for "_i" from 1 to _count step 1 do
						{
							_unit addItemToUniform _mag;
						};
					};
				}
				else
				{
					for "_i" from 1 to _count step 1 do
					{
						_unit addItemToUniform _item;
					};
				};
			};
			_invList = _inv select 1;
			_itemList = [];
			_itemAmount = [];
			for "_i" from 0 to (count _invList -1) step 2 do
			{
				_itemList append [_invList select _i];
				_itemAmount append [_invList select (_i +1)];
			};
			for "_i" from 0 to (count _itemList -1) step 1 do
			{
				private ["_item", "_count"];
				_item = (_itemList select _i);
				_count = (_itemAmount select _i);
				if (_item == "AMMO_PRIMARY" || _item == "AMMO_SIDEARM" || _item == "AMMO_LAUNCHER") then
				{
					_pWeap = primaryWeapon _unit;
					_sWeap = handgunWeapon _unit;
					_tWeap = secondaryWeapon _unit;
					
					if (_item == "AMMO_PRIMARY" && !(_pWeap == "")) then
					{
						_magazines = getArray(configFile >> "CfgWeapons" >> _pWeap >> "magazines");
						_mag = _magazines select 0;
						for "_i" from 1 to _count step 1 do
						{
							_unit addItemToVest _mag;
						};
					};
					
					if (_item == "AMMO_SIDEARM" && !(_sWeap == "")) then
					{
						_magazines = getArray(configFile >> "CfgWeapons" >> _sWeap >> "magazines");
						_mag = _magazines select 0;
						for "_i" from 1 to _count step 1 do
						{
							_unit addItemToVest _mag;
						};
					};
					
					if (_item == "AMMO_LAUNCHER" && !(_tWeap == "")) then
					{
						_magazines = getArray(configFile >> "CfgWeapons" >> _tWeap >> "magazines");
						_mag = _magazines select 0;
						for "_i" from 1 to _count step 1 do
						{
							_unit addItemToVest _mag;
						};
					};
				}
				else
				{
					for "_i" from 1 to _count do
					{
						_unit addItemToVest _item;
					};
				};
			};
			_invList = _inv select 2;
			_itemList = [];
			_itemAmount = [];
			for "_i" from 0 to (count _invList -1) step 2 do
			{
				_itemList append [_invList select _i];
				_itemAmount append [_invList select (_i +1)];
			};
			for "_i" from 0 to (count _itemList -1) step 1 do
			{
				private ["_item", "_count"];
				_item = (_itemList select _i);
				_count = (_itemAmount select _i);
				if (_item == "AMMO_PRIMARY" || _item == "AMMO_SIDEARM" || _item == "AMMO_LAUNCHER") then
				{
					_pWeap = primaryWeapon _unit;
					_sWeap = handgunWeapon _unit;
					_tWeap = secondaryWeapon _unit;
					
					if (_item == "AMMO_PRIMARY" && !(_pWeap == "")) then
					{
						_magazines = getArray(configFile >> "CfgWeapons" >> _pWeap >> "magazines");
						_mag = _magazines select 0;
						for "_i" from 1 to _count step 1 do
						{
							_unit addItemToBackpack _mag;
						};
					};
					
					if (_item == "AMMO_SIDEARM" && !(_sWeap == "")) then
					{
						_magazines = getArray(configFile >> "CfgWeapons" >> _sWeap >> "magazines");
						_mag = _magazines select 0;
						for "_i" from 1 to _count step 1 do
						{
							_unit addItemToBackpack _mag;
						};
					};
					
					if (_item == "AMMO_LAUNCHER" && !(_tWeap == "")) then
					{
						_magazines = getArray(configFile >> "CfgWeapons" >> _tWeap >> "magazines");
						_mag = _magazines select 0;
						for "_i" from 1 to _count step 1 do
						{
							_unit addItemToBackpack _mag;
						};
					};
				}
				else
				{
					for "_i" from 1 to _count step 1 do
					{
						_unit addItemToBackpack _item;
					};
				};
			};
		};
	}
	else
	{
		if (_inv == "SPLIT") then
		{
			_invList = getArray(configFile >> "CfgVehicles" >> _unitType >> "uniformInventory");
			_itemList = [];
			_itemAmount = [];
			for "_i" from 0 to (count _invList -1) step 2 do
			{
				_itemList append [_invList select _i];
				_itemAmount append [_invList select (_i +1)];
			};
			for "_i" from 0 to (count _itemList -1) step 1 do
			{
				private ["_item", "_count"];
				_item = (_itemList select _i);
				_count = (_itemAmount select _i);
				if (_item == "AMMO_PRIMARY" || _item == "AMMO_SIDEARM" || _item == "AMMO_LAUNCHER") then
				{
					_pWeap = primaryWeapon _unit;
					_sWeap = handgunWeapon _unit;
					_tWeap = secondaryWeapon _unit;
					
					if (_item == "AMMO_PRIMARY" && !(_pWeap == "")) then
					{
						_magazines = getArray(configFile >> "CfgWeapons" >> _pWeap >> "magazines");
						_mag = _magazines select 0;
						for "_i" from 1 to _count step 1 do
						{
							_unit addItemToUniform _mag;
						};
					};
					
					if (_item == "AMMO_SIDEARM" && !(_sWeap == "")) then
					{
						_magazines = getArray(configFile >> "CfgWeapons" >> _sWeap >> "magazines");
						_mag = _magazines select 0;
						for "_i" from 1 to _count step 1 do
						{
							_unit addItemToUniform _mag;
						};
					};
					
					if (_item == "AMMO_LAUNCHER" && !(_tWeap == "")) then
					{
						_magazines = getArray(configFile >> "CfgWeapons" >> _tWeap >> "magazines");
						_mag = _magazines select 0;
						for "_i" from 1 to _count step 1 do
						{
							_unit addItemToUniform _mag;
						};
					};
				}
				else
				{
					for "_i" from 1 to _count step 1 do
					{
						_unit addItemToUniform _item;
					};
				};
			};
			_invList = getArray(configFile >> "CfgVehicles" >> _unitType >> "vestInventory");
			_itemList = [];
			_itemAmount = [];
			for "_i" from 0 to (count _invList -1) step 2 do
			{
				_itemList append [_invList select _i];
				_itemAmount append [_invList select (_i +1)];
			};
			for "_i" from 0 to (count _itemList -1) step 1 do
			{
				private ["_item", "_count"];
				_item = (_itemList select _i);
				_count = (_itemAmount select _i);
				if (_item == "AMMO_PRIMARY" || _item == "AMMO_SIDEARM" || _item == "AMMO_LAUNCHER") then
				{
					_pWeap = primaryWeapon _unit;
					_sWeap = handgunWeapon _unit;
					_tWeap = secondaryWeapon _unit;
					
					if (_item == "AMMO_PRIMARY" && !(_pWeap == "")) then
					{
						_magazines = getArray(configFile >> "CfgWeapons" >> _pWeap >> "magazines");
						_mag = _magazines select 0;
						for "_i" from 1 to _count step 1 do
						{
							_unit addItemToVest _mag;
						};
					};
					
					if (_item == "AMMO_SIDEARM" && !(_sWeap == "")) then
					{
						_magazines = getArray(configFile >> "CfgWeapons" >> _sWeap >> "magazines");
						_mag = _magazines select 0;
						for "_i" from 1 to _count step 1 do
						{
							_unit addItemToVest _mag;
						};
					};
					
					if (_item == "AMMO_LAUNCHER" && !(_tWeap == "")) then
					{
						_magazines = getArray(configFile >> "CfgWeapons" >> _tWeap >> "magazines");
						_mag = _magazines select 0;
						for "_i" from 1 to _count step 1 do
						{
							_unit addItemToVest _mag;
						};
					};
				}
				else
				{
					for "_i" from 1 to _count do
					{
						_unit addItemToVest _item;
					};
				};
			};
			_invList = getArray(configFile >> "CfgVehicles" >> _unitType >> "backpackInventory");
			_itemList = [];
			_itemAmount = [];
			for "_i" from 0 to (count _invList -1) step 2 do
			{
				_itemList append [_invList select _i];
				_itemAmount append [_invList select (_i +1)];
			};
			for "_i" from 0 to (count _itemList -1) step 1 do
			{
				private ["_item", "_count"];
				_item = (_itemList select _i);
				_count = (_itemAmount select _i);
				if (_item == "AMMO_PRIMARY" || _item == "AMMO_SIDEARM" || _item == "AMMO_LAUNCHER") then
				{
					_pWeap = primaryWeapon _unit;
					_sWeap = handgunWeapon _unit;
					_tWeap = secondaryWeapon _unit;
					
					if (_item == "AMMO_PRIMARY" && !(_pWeap == "")) then
					{
						_magazines = getArray(configFile >> "CfgWeapons" >> _pWeap >> "magazines");
						_mag = _magazines select 0;
						for "_i" from 1 to _count step 1 do
						{
							_unit addItemToBackpack _mag;
						};
					};
					
					if (_item == "AMMO_SIDEARM" && !(_sWeap == "")) then
					{
						_magazines = getArray(configFile >> "CfgWeapons" >> _sWeap >> "magazines");
						_mag = _magazines select 0;
						for "_i" from 1 to _count step 1 do
						{
							_unit addItemToBackpack _mag;
						};
					};
					
					if (_item == "AMMO_LAUNCHER" && !(_tWeap == "")) then
					{
						_magazines = getArray(configFile >> "CfgWeapons" >> _tWeap >> "magazines");
						_mag = _magazines select 0;
						for "_i" from 1 to _count step 1 do
						{
							_unit addItemToBackpack _mag;
						};
					};
				}
				else
				{
					for "_i" from 1 to _count step 1 do
					{
						_unit addItemToBackpack _item;
					};
				};
			};
		};
	};
};