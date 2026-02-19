extends Control
class_name StationPanel

enum State { NORMAL , SELECTED }
@onready var panel: Panel = $Panel

@onready var icon: TextureRect = $Panel/Icon

@export var state: State = State.NORMAL

func setup(station_icon):
	apply_style()
	icon.texture = station_icon
	pass
	
func selected():
	state = State.SELECTED
	apply_style()
	pass

func unselected():
	state = State.NORMAL
	apply_style()
	pass


func apply_style():
	match state:
		State.NORMAL:
			panel.remove_theme_stylebox_override("panel")
		State.SELECTED:
			var sb = panel.get_theme_stylebox("selected")
			if sb:
				panel.add_theme_stylebox_override("panel", sb)
