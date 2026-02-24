extends Node
class_name StationReference

const Station_type_definition := {
	"DEPLOYER": {
		"name" : "Deployer",
		"icon" : preload("res://Asset/icons/sources.png"),
		"sub_items": ["Galaxy_gun","Booster"]
		}
}

const Station_sub_item_definition := {
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
	ATTACKER,
	SUPPORT,
	NONE
}
