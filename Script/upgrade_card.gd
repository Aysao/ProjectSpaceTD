extends Control

@export var upgrade_data: Dictionary
var base_style: StyleBoxFlat
var hover_style: StyleBoxFlat
@onready var hover_tween: Tween

var upgradeKey := ""
var template_cost_label = "Cost\n"
var template_level = "Level\n"
var template_galaxium_cost = "galaxium\ncost\n"
var disabled := false
signal on_click_upgrade(card_key,upgrade_data: Dictionary)



func setup(upgrade: Dictionary, key: String):
	upgrade_data = upgrade
	upgradeKey = key
	$Card/Upgrade_name.text = upgrade.get("name")
	$Card/Upgrade_description.text = str(upgrade.get("description"))
	$Card/Cost_label.text = template_cost_label + upgrade.get("cost")
	$Card/Current_level.text = template_level + "%s / %s" % [upgrade.get("level"),upgrade.get("max_level")]
	if upgrade.get("consumption_value") != null:
		$Card/galaxium_consumption.text = template_galaxium_cost + "%s / s" % upgrade.get("consumption_value")
	disabled = !upgrade.get("available")
	if(!get_tree().get_first_node_in_group("resources_Manager").isEnough(int(upgrade.get("cost"))) or ! upgrade["max_level"] > upgrade["level"]):
		disabled = true
	$Card.disabled = disabled


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MouseButton.MOUSE_BUTTON_LEFT and !disabled:
			on_click_upgrade.emit(upgradeKey,upgrade_data)
