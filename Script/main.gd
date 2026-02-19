extends Node

var run_loader = preload("res://Scene/run_manager.tscn")
var current_run_manager: RunManager


func _ready() -> void:
	call_deferred("init_connector")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func init_connector():
	EventBus.back_to_menu.connect(_on_back_to_menu)
	EventBus.replay.connect(_on_replay_button)

func launch_game():
	current_run_manager = run_loader.instantiate()
	add_child(current_run_manager)
	current_run_manager.run_start()
	

func _on_back_to_menu():
	var canvas_layer = get_node("CanvasLayer")
	canvas_layer.visible = true
	current_run_manager.queue_free()

func _on_replay_button():
	current_run_manager.queue_free()
	launch_game()
