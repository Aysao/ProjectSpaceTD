extends CanvasLayer

@export var main_keys := []
@export var sub_items := {}# dictionnaire: type -> tableau d'items
@onready var container := $main_container/HTypeBox
@onready var sub_container := $main_container/HStationBox
@onready var progressBar := $Resources/HBoxContainer/ProgressBar
@onready var progressBarLabel := $Resources/HBoxContainer/ProgressBar/GalaxiumValue
@onready var galaxiumPerSecond := $Resources/HBoxContainer/GalaxiumPerSecond
@onready var materialsBar := $Resources/Materials/ProgressBar
@onready var materialsLabelValue := $Resources/Materials/ProgressBar/MaterialsValue
var selected_index := 0
var sub_list_active := false
var sub_start_index := 0 # pour scroll de max 3 items

signal emit_spawn_request(station_name: String)

func _ready():
	main_keys = StationReference.Station_type_definition.keys()
	_refresh_main_list()
	sub_container.visible = false
	_update_sub_list()

func _input(event):
	if event.is_action_pressed("hud_left"):
		if sub_list_active:
			_scroll_sub_list(-1)
		else:
			_move_selection(-1)
	elif event.is_action_pressed("hud_right"):
		if sub_list_active:
			_scroll_sub_list(1)
		else:
			_move_selection(1)
	elif event.is_action_pressed("ui_select_sub"): # touche F
		var subitems = StationReference.Station_type_definition[main_keys[selected_index]]["sub_items"]
		if !subitems.is_empty():
			sub_list_active = not sub_list_active
			sub_container.visible = sub_list_active
			if sub_list_active:
				sub_start_index = 0
				_update_sub_list()
	elif event.is_action_pressed("build"): # click droit
		if sub_container.visible:
			print("trying to send signal from stationReference : %s " % StationReference.Station_type_definition[main_keys[selected_index]]["sub_items"].get(sub_start_index))
			emit_signal("emit_spawn_request",StationReference.Station_type_definition[main_keys[selected_index]]["sub_items"].get(sub_start_index))

func _refresh_main_list():
	_clear_container(container)
	for key in main_keys:
		var info = StationReference.Station_type_definition[key]
		var btn = TextureButton.new()
		btn.texture_normal = info["icon"]
		btn.size = Vector2(64,64)
		btn.name = info["name"]
		container.add_child(btn)
	_update_selection_visuals()


func _update_selection_visuals():
	for i in range(container.get_child_count()):
		var btn = container.get_child(i)
		if i == selected_index:
			btn.modulate = Color(1,1,1,1)  # opaque
			btn.offset_top = 10  # léger décalage
		else:
			btn.modulate = Color(1,1,1,0.5)  # transparent
			btn.offset_top = 0

func _move_selection(offset):
	selected_index = clamp(selected_index + offset, 0, main_keys.size() - 1)
	_update_selection_visuals()

# --- Sous-liste ---
func _update_sub_list():
	_clear_container(sub_container)
	var type_name = main_keys[selected_index]
	var sub_keys = StationReference.Station_type_definition[type_name]["sub_items"]
	var display_items = sub_keys.slice(sub_start_index, 3)
	for key in display_items:
		var btn = TextureButton.new()
		var info = StationReference.Station_sub_item_definition[key]
		btn.texture_normal = info["icon"]
		btn.size = Vector2(64,64)
		btn.name = info["name"]
		sub_container.add_child(btn)
	_update_sub_selection_visuals()
		
func _scroll_sub_list(offset):
	var type_name = main_keys[selected_index]
	var items = StationReference.Station_type_definition[type_name]["sub_items"]
	sub_start_index = clamp(sub_start_index + offset, 0, max(0, items.size() - 3))
	_update_sub_list()
	
func _update_sub_selection_visuals():
	for i in range(sub_container.get_child_count()):
		var btn = sub_container.get_child(i)
		if i == 1:  # item central (selection)
			btn.modulate = Color(1,1,1,1)
		else:
			btn.modulate = Color(1,1,1,0.5)

func _clear_container(container: Node):
	for child in container.get_children():
		child.queue_free()

func _on_main_close_sublist() -> void:
	sub_list_active = false
	sub_container.visible = sub_list_active
	pass # Replace with function body.
	
func updateProgressBar(ressourcesValue : int, ressourcesPerSecond : float):
	progressBar.value = ressourcesValue
	progressBarLabel.text = "%d / %d" % [ressourcesValue, progressBar.max_value]
	if ressourcesPerSecond > 0 :
		galaxiumPerSecond.text = "+ %f / sec" % ressourcesPerSecond
		galaxiumPerSecond.modulate = Color.WEB_GREEN
	elif ressourcesPerSecond < 0 :
		galaxiumPerSecond.text = "%f / sec" % ressourcesPerSecond
		galaxiumPerSecond.modulate = Color.DARK_RED
	else :
		galaxiumPerSecond.text = "%f / sec" % ressourcesPerSecond
		galaxiumPerSecond.modulate = Color.LIGHT_GRAY

func updateMaterialsValue(materialsValue: int):
	materialsBar.value = materialsValue
	materialsLabelValue.text = "%d / %d" % [materialsValue, materialsBar.max_value]

func activate(playerInstance: CharacterBody3D):
	playerInstance.updateMaterialsDisplay.connect(updateMaterialsValue)
	playerInstance.updateRessourcesDisplay.connect(updateProgressBar)
	visible = true
	set_process(true)
	
func deactivate(): 
	visible = false
	set_process(false)
