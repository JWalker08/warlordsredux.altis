#include "..\warlords_constants.inc"

params ["_locality"];

switch (_locality) do {
	case "common": {
		BIS_WL_sidesArray = [WEST, EAST, RESISTANCE];
		BIS_WL_competingSides = [WEST, EAST];
		BIS_WL_targetVotingDuration = BIS_WL_initModule getVariable ["BIS_WL_targetVotingDuration", 15];
		BIS_WL_localSide = (BIS_WL_sidesArray - BIS_WL_competingSides) # 0;
		BIS_WL_missionEnd = FALSE;
		BIS_WL_sectorUpdateInProgress = FALSE;
		BIS_WL_mapSize = getNumber (configFile >> "cfgWorlds" >> worldName >> "mapSize");
		if (BIS_WL_mapSize == 0) then {BIS_WL_mapSize = getNumber (configFile >> "cfgWorlds" >> worldName >> "Grid" >> "OffsetY")};
		BIS_WL_mapAreaArray = [[BIS_WL_mapSize / 2, BIS_WL_mapSize / 2], BIS_WL_mapSize / 2, BIS_WL_mapSize / 2, 0, TRUE];
		BIS_WL_purchaseListTeplateArr = call compile (BIS_WL_initModule getVariable ["BIS_WL_requisitionPreset", "['A3DefaultAll']"]);
		BIS_WL_scanCost = BIS_WL_initModule getVariable ["BIS_WL_scanCost", 350];
		BIS_WL_fastTravelCostOwned = BIS_WL_initModule getVariable ["BIS_WL_fastTravelCostOwned", 0];
		BIS_WL_fastTravelCostContested = BIS_WL_initModule getVariable ["BIS_WL_fastTravelCostContested", 200];
		BIS_WL_fundsTransferCost = BIS_WL_initModule getVariable ["BIS_WL_fundsTransferCost", 500];
		BIS_WL_targetResetCost = BIS_WL_initModule getVariable ["BIS_WL_targetResetCost", 2000];
		BIS_WL_maxCP = BIS_WL_initModule getVariable ["BIS_WL_maxCP", 50000];
		BIS_WL_arsenalCost = BIS_WL_initModule getVariable ["BIS_WL_arsenalCost", 1000];
		BIS_WL_assetLimit = BIS_WL_initModule getVariable ["BIS_WL_assetLimit", 10];
		BIS_WL_maxSubordinates = BIS_WL_initModule getVariable ["BIS_WL_maxSubordinates", 2];
		BIS_WL_targetResetTimeout = BIS_WL_initModule getVariable ["BIS_WL_targetResetTimeout", 300];
		BIS_WL_baseValue = BIS_WL_initModule getVariable ["BIS_WL_baseValue", 10];
		BIS_WL_scanCooldown = (BIS_WL_initModule getVariable ["BIS_WL_scanCooldown", 90]) max WL_SCAN_DURATION;
		BIS_WL_lastLoadoutCost = BIS_WL_initModule getVariable ["BIS_WL_lastLoadoutCost", 100];
		BIS_WL_savedLoadoutCost = BIS_WL_initModule getVariable ["BIS_WL_savedLoadoutCost", 500];
	};
	case "server": {
		BIS_WL_baseDistanceMin = BIS_WL_initModule getVariable ["BIS_WL_baseDistanceMin", 1];
		BIS_WL_baseDistanceMax = BIS_WL_initModule getVariable ["BIS_WL_baseDistanceMax", -1];
		if (BIS_WL_baseDistanceMax < 0) then {BIS_WL_baseDistanceMax = 999};
		BIS_WL_playerIDArr = [[], []];
		BIS_WL_faction_WEST = "BLU_F";
		BIS_WL_faction_EAST = "OPF_F";
		BIS_WL_faction_GUER = "IND_F";
		{
			missionNamespace setVariable [format ["BIS_WL_boundTo%1", _x], []];
		} forEach BIS_WL_competingSides;
	};
	case "client": {
		BIS_WL_playerSide = side group player;
		BIS_WL_enemySide = (BIS_WL_competingSides - [BIS_WL_playerSide]) # 0;
		BIS_WL_autonomous_limit = BIS_WL_initModule getVariable ["BIS_WL_autonomous_limit", 2];
		BIS_WL_playerBase = BIS_WL_playerSide call BIS_fnc_WL2_getSideBase;
		BIS_WL_enemyBase = BIS_WL_enemySide call BIS_fnc_WL2_getSideBase;
		BIS_WL_mapSizeIndex = BIS_WL_mapSize / 8192;
		BIS_WL_colorMarkerFriendly = ["colorBLUFOR", "colorOPFOR", "colorIndependent"] # (BIS_WL_sidesArray find BIS_WL_playerSide);
		BIS_WL_colorMarkerEnemy = ["colorBLUFOR", "colorOPFOR", "colorIndependent"] # (BIS_WL_sidesArray find BIS_WL_enemySide);
		BIS_WL_targetVote = objNull;
		BIS_WL_terminateOSDEvent_voting = FALSE;
		BIS_WL_terminateOSDEvent_seizing = FALSE;
		BIS_WL_terminateOSDEvent_trespassing = FALSE;
		BIS_WL_terminateOSDEvent_seizingDisabled = FALSE;
		BIS_WL_resetTargetSelection_client = FALSE;
		BIS_WL_localized_m = localize "STR_A3_rscdisplayarcademap_meters";
		BIS_WL_localized_km = localize "STR_A3_WL_unit_km";
		BIS_WL_purchaseMenuVisible = FALSE;
		BIS_WL_purchaseMenuDiscovered = FALSE;
		BIS_WL_gearKeyPressed = FALSE;
		BIS_WL_currentSelection = WL_ID_SELECTION_NONE;
		BIS_WL_matesAvailable = floor (BIS_WL_maxSubordinates / 4);
		BIS_WL_lastLoadout = [];
		BIS_WL_savedLoadout = [];
		BIS_WL_loadoutApplied = FALSE;
		BIS_WL_selectionMapManager = -1;
		BIS_WL_currentlyScannedSectors = [];
		BIS_WL_currentTargetData = [
			"\A3\ui_f\data\map\markers\nato\b_hq.paa",
			[0, 0, 0, 0],
			[0, 0, 0]
		];
		BIS_WL_colorsArray = [
			[profileNamespace getVariable ["Map_BLUFOR_R", 0], profileNamespace getVariable ["Map_BLUFOR_G", 1], profileNamespace getVariable ["Map_BLUFOR_B", 1], profileNamespace getVariable ["Map_BLUFOR_A", 0.8]],
			[profileNamespace getVariable ["Map_OPFOR_R", 0], profileNamespace getVariable ["Map_OPFOR_G", 1], profileNamespace getVariable ["Map_OPFOR_B", 1], profileNamespace getVariable ["Map_OPFOR_A", 0.8]],
			[profileNamespace getVariable ["Map_Independent_R", 0], profileNamespace getVariable ["Map_Independent_G", 1], profileNamespace getVariable ["Map_Independent_B", 1], profileNamespace getVariable ["Map_Independent_A", 0.8]],
			[profileNamespace getVariable ["Map_Unknown_R", 0], profileNamespace getVariable ["Map_Unknown_G", 1], profileNamespace getVariable ["Map_Unknown_B", 1], profileNamespace getVariable ["Map_Unknown_A", 0.8]]
		];
		BIS_WL_sectorIconsArray = [
			"\A3\ui_f\data\map\markers\nato\b_installation.paa",
			"\A3\ui_f\data\map\markers\nato\o_installation.paa",
			"\A3\ui_f\data\map\markers\nato\n_installation.paa"
		];
		BIS_WL_colorFriendly = BIS_WL_colorsArray # (BIS_WL_sidesArray find BIS_WL_playerSide);
		BIS_WL_recentlyPurchasedAssets = [];
		BIS_WL_penalized = FALSE;
		BIS_WL_mapAssetTarget = objNull;
	};
};