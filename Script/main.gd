extends Node

@onready var runManager := $RunManager
@onready var EnemiesSpawnMarker := $RunManager/EnemiesSpawnMarker

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	runManager.set_process(false)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
