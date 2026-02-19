extends Node
class_name StationReference

const Station_type_definition := {
	"SOURCE": {
		"name" : "Source",
		"icon" : preload("res://Asset/icons/sources.png"),
		"sub_items": ["Station_deployer"]
		},
	"DEPLOYER": {
		"name" : "Deployer",
		"icon" : preload("res://Asset/icons/deployer.png"),
		"sub_items": ["Galaxy_gun","Booster"]
		}
}

const Station_sub_item_definition := {
	"Station_deployer": {
		"name": "Station Deployer",
		"icon": preload("res://Asset/icons/deployer.png"),
		"scene": "res://Scene/Station/PlacementStation/DeployerStation.tscn"
	},
	"Galaxy_gun": {
		"name": "Galaxy Gun",
		"icon": preload("res://Asset/icons/galaxyGun.png"),
		"scene": "res://Scene/Station/AttackerStation/GalaxyGun_Station.tscn"
	},
	"Booster": {
		"name": "Booster",
		"icon": preload("res://Asset/icons/booster.png"),
		"scene": "res://Scene/Station/SupportStation/booster_station.tscn"
	}
}

enum StationType{
	SOURCE,
	DEPLOYER,
	ATTACKER,
	SUPPORT,
	NONE
}

enum StationSlotType {
	DEPLOYER_SLOT,
	ARM_DEPLOYER_SLOT,
	ATTACKERS_SLOT
}
