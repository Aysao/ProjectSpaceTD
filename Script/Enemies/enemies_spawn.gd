extends Node3D


@export var enemiesPoolAmount := 100
@export var spawn_radius := 3.0
var enemiesPoolDict := {}
var enemiesCooldown := 5.0
var enemiesCooldownTimer := 5.0
var enemies_onfield_count := 0
var enemies_count := 0

@onready var enemieNode := $"../GameNode/Enemies"
@onready var enemiesSpawnerMarker = $"."

var cargo_preload := preload("res://Scene/Enemies/cargo_enemie.tscn")

var enemieScene := preload("res://Scene/Enemies/pirateSpaceShip.tscn")


func _ready() -> void:
	set_process(false)


func generateEnemie(bulletPool, scene, list) :
	
	for i in range(enemiesPoolAmount):
		var enemieInstance = scene.instantiate()
		enemieNode.add_child(enemieInstance)
		enemieInstance.setPool(bulletPool)
		enemieInstance.deactivate()
		
		enemieInstance.global_position = enemiesSpawnerMarker.global_position
		list.append(enemieInstance)

func generate_all_enemies_pool(bulletPool):
	for i in EnemyReference.EnemyRace.values():
		for enemyType in EnemyReference.enemyType[i].values():
			var scene = load(enemyType["scene"])
			var free_list := []
			var used_list := []
			generateEnemie(bulletPool, scene, free_list)
				
			enemiesPoolDict[enemyType["name"]] = {
				"scene" : scene,
				"free_list" : free_list,
				"used_list" : used_list
			}

func spawn_wave(wave_list, spawn_position):
	enemies_onfield_count = 0
	enemies_count = wave_list.size()
	for enemie in wave_list:
		enemies_onfield_count += 1
		spawn_enemie(enemie["name"], spawn_position)

func get_random_spawn_position(spawn_position) -> Vector3:
	var angle = randf_range(0, 2*PI)
	var radius = randf_range(0.0,spawn_radius)
	var x = cos(angle) * radius
	var z = sin(angle) * radius
	var y = 0
	return Vector3(x,y,z) + spawn_position

func spawn_enemie(enemie_name, spawn_position):
	if enemiesPoolDict[enemie_name]:
		var enemie = enemiesPoolDict[enemie_name]["free_list"].pop_back()
		enemiesCooldownTimer = enemiesCooldown
		if enemie :
			print(enemiesPoolDict[enemie_name]["free_list"].size())
			enemiesPoolDict[enemie_name]["used_list"].append(enemie)
			enemie.spawn_enemie(get_random_spawn_position(spawn_position))

func make_cargo_spawn(wave_list : Array):
	var angle := randf() * TAU
	var offset := Vector3(
		cos(angle) * (WorldParameters.area_radius+10),
		0.0,
		sin(angle) * (WorldParameters.area_radius+10)
	)
	var instantiate_cargo = cargo_preload.instantiate()
	enemieNode.add_child(instantiate_cargo)
	instantiate_cargo.global_position = offset
	instantiate_cargo.spawn_cargo(wave_list)


func launch_enemie_pool():
	set_process(true)

func connector_setup():
	EventBus.start_spawn.connect(make_cargo_spawn)
	EventBus.spawn_enemie_group.connect(spawn_wave)
