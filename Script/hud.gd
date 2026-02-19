extends CanvasLayer

@export var main_keys := []
@export var sub_items := {}# dictionnaire: type -> tableau d'items
@export var upgradeCardScene := preload("res://Scene/UpgradeCard.tscn")
@onready var progressBar := $Resources/HBoxContainer/ProgressBar
@onready var progressBarLabel := $Resources/HBoxContainer/ProgressBar/GalaxiumValue
@onready var galaxiumPerSecond := $Resources/HBoxContainer/GalaxiumPerSecond
@onready var materialsBar := $Resources/Materials/ProgressBar
@onready var materialsLabelValue := $Resources/Materials/ProgressBar/MaterialsValue
@onready var messageLabel := $Message_Panel/Message
@onready var messagePanel := $Message_Panel
@onready var upgradePanel := $UpgradePanel
@onready var upgradeContainer := $UpgradePanel/VBoxContainer/UpgradeContainer

var selected_index := 0
var sub_list_active := false
var upgrade_display := false
var current_station_on_upgrade : StationBase
var sub_start_index := 0 # pour scroll de max 3 items

@onready var station_menu: Control = $station_menu

signal emit_spawn_request(station_name: String)

func updateProgressBar(ressourcesValue : int, ressourcesPerSecond : float):
	progressBar.value = ressourcesValue
	progressBarLabel.text = "%d / %d" % [ressourcesValue, progressBar.max_value]
	if ressourcesPerSecond > 0 :
		galaxiumPerSecond.text = "+ %.2f / sec" % ressourcesPerSecond
		galaxiumPerSecond.modulate = Color.WEB_GREEN
	elif ressourcesPerSecond < 0 :
		galaxiumPerSecond.text = "%.2f / sec" % ressourcesPerSecond
		galaxiumPerSecond.modulate = Color.DARK_RED
	else :
		galaxiumPerSecond.text = "%.2f / sec" % ressourcesPerSecond
		galaxiumPerSecond.modulate = Color.LIGHT_GRAY

func updateMaterialsValue(materialsValue: int):
	materialsBar.value = materialsValue
	materialsLabelValue.text = "%d / %d" % [materialsValue, materialsBar.max_value]
	
func display_current_upgrade(station: StationBase):
	upgrade_display = !upgrade_display
	clear()
	upgradePanel.visible = upgrade_display
	if station:
		current_station_on_upgrade = station
		for i in station.upgrade_list.keys():
			var upgrade = station.upgrade_list[i]
			var card = upgradeCardScene.instantiate()
			upgradeContainer.add_child(card)
			card.setup(upgrade,i)
			card.on_click_upgrade.connect(_on_upgrade_card_request)
			
			
func _on_upgrade_card_request(upgrade_name, dictionnary):
	current_station_on_upgrade.upgrade(upgrade_name)
	display_current_upgrade(null)
	

func clear():
	for child in upgradeContainer.get_children():
		child.queue_free()


func activate(playerInstance: CharacterBody3D):
	EventBus.send_message.connect(display_message)
	EventBus.close_display.connect(hide_message)
	visible = true
	set_process(true)
	
func display_message(message):
	messageLabel.text = message
	messagePanel.visible = true
	
func hide_message():
	messageLabel.text = ""
	messagePanel.visible = false
	
func deactivate(): 
	visible = false
	set_process(false)


func _on_station_menu_emit_spawn_request(station_name: String) -> void:
	emit_spawn_request.emit(station_name) # Replace with function body.
