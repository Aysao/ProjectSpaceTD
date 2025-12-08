extends Node

@onready var player = $Players/Player
@onready var playerItems = $PlayerItems

#signal
signal createUpdate

#preload Scene 
var deployer = preload("res://Scene/Deployer.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass


func _on_player_spawn_request(obj_instance: Variant) -> void:
	var spawn_pos = player.get_global_position() + Vector3(0,0,5)
	obj_instance.global_transform.origin = spawn_pos
	
	playerItems.add_child(obj_instance)
	
	# Met à jour tous les ennemis
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		enemy.set_Target()
	pass # Replace with function body.
