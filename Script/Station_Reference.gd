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
		"sub_items": []
		}
}

const Station_sub_item_definition := {
	"Station_deployer": {
		"name": "Station Deployer",
		"icon": preload("res://Asset/icons/deployer.png"),
		"scene": preload("res://Scene/station_deployer.tscn")
	},
	"Galaxy_gun": {
		"name": "Galaxy Gun",
		"icon": preload("res://icon.svg"),
		"scene": preload("res://Scene/station_deployer.tscn")
	}
}

enum StationType{
	SOURCE,
	DEPLOYER,
}
