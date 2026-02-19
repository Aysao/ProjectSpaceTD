extends Node3D

@onready var cargo_space_ship: AnimationPlayer = $Pivot/CargoSpaceShipSpawning/AnimationPlayer
@onready var spawn_position: Node3D = $SpawnPosition
@onready var pivot: Node3D = $Pivot
	

func spawn_cargo(wave_list):
	look_at(get_tree().get_first_node_in_group("Source").global_position,Vector3.UP)
	cargo_space_ship.play("cargo_spawning")
	await cargo_space_ship.animation_finished
	EventBus.spawn_enemie_group.emit(wave_list, spawn_position.global_position)
	await get_tree().create_timer(0.5).timeout
	cargo_space_ship.play("cargo_dispawning")
	await cargo_space_ship.animation_finished
	queue_free()
