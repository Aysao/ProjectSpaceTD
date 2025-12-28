extends Node3D


var hud : CanvasLayer

var ressources := 0
var materials := 0


var activated := false
# Ressource
@export var galaxium_max : int = 100.0
@export var current_galaxium : int = 0.0
@export var galaxium_rate : float = 1.0
@export var galaxium_bonus_rate : float = 1.0
@export var galaxium_timerate : float = 1.0
var cooldown_galaxium = 1.0

func _ready() -> void:
	set_process(false)

func _process(delta: float) -> void:
	cooldown_galaxium -= delta
	if cooldown_galaxium <= 0 :
		cooldown_galaxium = galaxium_timerate
		if (current_galaxium + galaxium_rate * galaxium_bonus_rate) <= galaxium_max:
			current_galaxium += galaxium_rate * galaxium_bonus_rate
			hud.updateProgressBar(current_galaxium, galaxium_rate*galaxium_bonus_rate)


func setHud(_in_hud: CanvasLayer):
	hud = _in_hud

func initialize():
	hud.updateProgressBar(current_galaxium, galaxium_rate*galaxium_bonus_rate)
	hud.updateMaterialsValue(0)

func update_material(value_to_update : int):
	materials += value_to_update
	hud.updateMaterialsValue(materials)
	
func update_galaxium(value_to_update : float):
	current_galaxium += value_to_update
	hud.updateProgressBar(current_galaxium, galaxium_rate*galaxium_bonus_rate)

func update_galaxium_rate(value_to_update : float):
	galaxium_rate += value_to_update
	hud.updateProgressBar(current_galaxium, galaxium_rate*galaxium_bonus_rate)

func isEnough(value : int) -> bool :
	return materials >= value
	
	
func activate():
	set_process(true)
	
func deactivate():
	set_process(false)
	
