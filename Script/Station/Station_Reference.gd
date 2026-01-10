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
		"sub_items": ["Galaxy_gun"]
		}
}

const Station_sub_item_definition := {
	"Station_deployer": {
		"name": "Station Deployer",
		"neededArea": StationType.SOURCE,
		"icon": preload("res://Asset/icons/deployer.png"),
		"scene": "res://Scene/Station/PlacementStation/DeployerStation.tscn"
	},
	"Galaxy_gun": {
		"name": "Galaxy Gun",
		"neededArea": StationType.DEPLOYER,
		"icon": preload("res://Asset/icons/galaxyGun.png"),
		"scene": "res://Scene/Station/AttackerStation/GalaxyGun_Station.tscn"
	}
}

enum StationType{
	SOURCE,
	DEPLOYER,
	ATTACKER,
	NONE
}

enum StationSlotType {
	DEPLOYER_SLOT,
	ARM_DEPLOYER_SLOT,
	ATTACKERS_SLOT
}
