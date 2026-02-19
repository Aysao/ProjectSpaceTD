extends Control

@export var main_keys := []
@export var current_sub_list := {}
@onready var container: HBoxContainer = $mainlist/HBoxContainer
@onready var sub_container: VBoxContainer = $sublist/VBoxContainer
@onready var sublist: Panel = $sublist
@onready var mainlist: Panel = $mainlist

var sub_list_active := false
var selected_index := 0
var start_sub_list_index := 0
var selected_sub_index := 0

var load_station_panel := preload("res://Scene/hud_component/station_panel.tscn")

signal emit_spawn_request(station_name: String)


func _ready():
	main_keys = StationReference.Station_type_definition.keys()
	_refresh_main_list()
	if container.get_child_count() > 0:
		container.get_child(selected_index).selected()

func _refresh_main_list():
	_clear_container(container)
	for key in main_keys:
		var info = StationReference.Station_type_definition[key]
		var station_icon: StationPanel = load_station_panel.instantiate()
		container.add_child(station_icon)
		station_icon.setup(info["icon"]) 
		station_icon.name = key
	

func _clear_container(current_container: Node):
	for child in current_container.get_children():
		child.free()



func _input(event):
	if event.is_action_pressed("hud_left"):
		if selected_index > 0 and !sub_list_active:
			move_main_selected(-1)
		elif selected_sub_index > 0 and sub_list_active:
			move_sub_selected(-1)
			change_preview()
			
	elif event.is_action_pressed("hud_right"):
		if selected_index < container.get_child_count()-1 and !sub_list_active:
			move_main_selected(1)
		elif selected_sub_index < sub_container.get_child_count()-1 and sub_list_active:
			move_sub_selected(1)
			change_preview()
			
	elif event.is_action_pressed("ui_select_sub"): # touche F
		var subitems = StationReference.Station_type_definition[main_keys[selected_index]]["sub_items"]
		if !subitems.is_empty():
			sub_list_active = not sub_list_active
			var icon_center = container.get_node(main_keys[selected_index]).global_position + container.get_node(main_keys[selected_index]).size * 0.5
			sublist.global_position = icon_center - Vector2(sublist.size.x * 0.5, sublist.size.y + mainlist.size.y)
			sublist.visible = sub_list_active
			EventBus.building_mode.emit(sublist.visible)
			if sub_list_active:
				selected_sub_index = 0
				start_sub_list_index = 0
				_update_sub_list()
				emit_signal("emit_spawn_request",StationReference.Station_type_definition[main_keys[selected_index]]["sub_items"].get(selected_sub_index))
			else:
				EventBus.cancel_placement.emit()
				
	
	elif event.is_action_pressed("build"): # click droit
		if sublist.visible:
			print("trying to send signal from stationReference : %s " % StationReference.Station_type_definition[main_keys[selected_index]]["sub_items"].get(start_sub_list_index))
			emit_signal("emit_spawn_request",StationReference.Station_type_definition[main_keys[selected_index]]["sub_items"].get(selected_sub_index))

func _update_sub_list():
	_clear_container(sub_container)
	var type_name = main_keys[selected_index]
	var sub_keys = StationReference.Station_type_definition[type_name]["sub_items"]
	var display_items = sub_keys.slice(start_sub_list_index, 3)
	
	for key in display_items:
		var station_icon: StationPanel = load_station_panel.instantiate()
		var info = StationReference.Station_sub_item_definition[key]
		sub_container.add_child(station_icon)
		station_icon.setup(info["icon"])
		station_icon.name = info["name"]
	if sub_container.get_child_count() > 0:
		sub_container.get_child(selected_sub_index).selected()

func move_main_selected(index):
	container.get_child(selected_index).unselected()
	selected_index += index
	container.get_child(selected_index).selected()
	
func move_sub_selected(index):
	sub_container.get_child(selected_sub_index).unselected()
	selected_sub_index += index
	sub_container.get_child(selected_sub_index).selected()
	
func change_preview():
	EventBus.cancel_placement.emit()
	emit_signal("emit_spawn_request",StationReference.Station_type_definition[main_keys[selected_index]]["sub_items"].get(selected_sub_index))
