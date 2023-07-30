#include "..\warlords_constants.inc"

params ["_asset"];

_rearmActionID = -1;
while {alive _asset} do {
	_nearbyVehicles = (_asset nearObjects ["All", WL_MAINTENANCE_RADIUS]) select {alive _x};
	_rearmCooldown = ((_asset getVariable "BIS_WL_nextRearm") - serverTime) max 0;
	_rearmVehicleIndex = _nearbyVehicles findIf {getNumber (configFile >> "CfgVehicles" >> typeOf _x >> "transportAmmo") > 0};
	
	if (_rearmVehicleIndex != -1) then {
		if (_rearmActionID == -1) then {
			_rearmActionID = _asset addAction [
				"",
				{
					params ["_asset"];
					if ((_asset getVariable "BIS_WL_nextRearm") <= serverTime) then {
						_curWeapon = currentWeapon _asset;
						_asset selectWeapon _curWeapon;

						[player] spawn GOM_fnc_aircraftLoadout;
						_rearmTime = switch true do {
							case (_asset isKindOf "Helicopter"): { WL_MAINTENANCE_COOLDOWN_REARM_Helicopter };
							case (_asset isKindOf "Plane"): { WL_MAINTENANCE_COOLDOWN_REARM_Jets };
							default { WL_MAINTENANCE_COOLDOWN_REARM };
						};
						_asset setVariable ["BIS_WL_nextRearm", serverTime + _rearmTime]; 
						
						playSound3D ["A3\Sounds_F\sfx\UI\vehicles\Vehicle_Rearm.wss", _asset, FALSE, getPosASL _asset, 2, 1, 75];
						[toUpper localize "STR_A3_WL_popup_asset_rearmed"] spawn BIS_fnc_WL2_smoothText;
					} else {
						playSound "AddItemFailed";
					};
				},
				[],
				5,
				true,
				false,
				"",
				"alive _target && {(group _this) == (_target getVariable ['BIS_WL_ownerAsset', grpNull]) && {vehicle _this == _this}}",
				WL_MAINTENANCE_RADIUS,
				false
			];
			_asset setVariable ["BIS_WL_rearmActionID", _rearmActionID];
		};

		_amount = (_nearbyVehicles # _rearmVehicleIndex) getvariable ["GOM_fnc_ammocargo", 0];
		_amountText = format ["(%1)", (_amount call GOM_fnc_kgToTon)];
		_asset setUserActionText [_rearmActionID, if (_rearmCooldown == 0) then {format ["<t color = '#4bff58'>%1 %2</t>", localize "STR_rearm", _amountText]} else {format ["<t color = '#7e7e7e'><t align = 'left'>%1 %2</t><t align = 'right'>%3     </t></t>", localize "STR_rearm", _amountText, [_rearmCooldown, "MM:SS"] call BIS_fnc_secondsToString]}, format ["<img size='2' color = '%1' image='\A3\ui_f\data\IGUI\Cfg\Actions\reammo_ca.paa'/>", if (_rearmCooldown == 0) then {"#ffffff"} else {"#7e7e7e"}]];
	} else {
		if (_rearmActionID != -1) then {
			_asset removeAction _rearmActionID;
			_rearmActionID = -1;
		};
	};
	sleep WL_TIMEOUT_STANDARD;
};
_asset removeAction _rearmActionID;