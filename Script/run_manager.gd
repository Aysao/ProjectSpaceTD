extends Node3D

@onready var sourceSpawnMarker := $SourceSpawnMarker
@onready var playerSpawnMarker := $PlayerSpawnMarker
@onready var enemiesSpawnMaker := $EnemiesSpawnMarker
@onready var playerNode := $GameNode/Players
@onready var enemieNode := $GameNode/Enemies
@onready var playerItems = $GameNode/PlayerItems
@onready var hud := $GameNode/Control
@onready var ressourcesManager := $RessourcesManager
@onready var camera := $GameNode/WorldParameters/Marker3D/Camera3D
@onready var bulletPool := $BulletManager
var player : CharacterBody3D

@export var enemiesPoolAmount := 2
var enemiesPool := []
var enemiesOnfied := []
var enemiesCooldown := 5.0
var enemiesCooldownTimer := 5.0

var ressources := 0
var materials := 0

# Ressource
@export var galaxium_max : int = 100.0
@export var current_galaxium : int = 0.0
@export var galaxium_rate : float = 1.0
@export var galaxium_bonus_rate : float = 1.0
@export var galaxium_timerate : float = 1.0
var cooldown_galaxium = 1.0

#Preload Scene
var enemieScene := preload("res://Scene/ennemie.tscn")
var playerScene := preload("res://Scene/player.tscn")
var sourceScene := preload("res://Scene/station_source.tscn")

#Signal
signal resetTarget(target : Node3D)

func _process(delta: float) -> void:
	enemiesCooldownTimer -= delta
		
	if enemiesCooldownTimer <= 0 && enemiesPool.size() > 0:
		print("POOL CONTENT:", enemiesPool)
		print("POOL SIZE BEFORE:", enemiesPool.size())
		var enemie = enemiesPool.pop_back()
		enemiesCooldownTimer = enemiesCooldown
		if enemie :
			print(enemiesPool.size())
			enemiesOnfied.append(enemie)
			enemie.spawn_enemie(enemiesSpawnMaker.global_position)
		
	

func _on_main_menu_run_start() -> void:
	
	var source = makeSourceSpawn()
	bulletPool.generateEnemieBulletPool()
	bulletPool.generatePlayerBulletPool()
	makePlayerSpawn(source)
	generateEnemiesPool(bulletPool)
	ressourcesManager.setHud(hud)
	ressourcesManager.initialize()
	
	set_process(true)
	pass # Replace with function body.

func generateEnemiesPool(bulletPool):
	for i in range(enemiesPoolAmount):
		var enemieInstance = enemieScene.instantiate()
		enemieNode.add_child(enemieInstance)
		enemieInstance.setPool(bulletPool)
		enemieInstance.deactivate()
		enemieInstance.onEnemieDeath.connect(_on_enemie_death)
		enemieInstance.global_position = enemiesSpawnMaker.global_position
		enemiesPool.append(enemieInstance)
		
		

func _on_enemie_death(value: int, enemieNode):
	if value > 0:
		ressourcesManager.update_material(value)
	resetTarget.emit(enemieNode)
	enemieNode.deactivate()
	enemiesPool.append(enemieNode)
	enemiesOnfied.erase(enemieNode)
	

func makePlayerSpawn(source: StationBase):
	var playerInstance = playerScene.instantiate()
	playerNode.add_child(playerInstance)
	playerInstance.global_position = playerSpawnMarker.global_position
	playerInstance.bindBuildArea(source)
	playerInstance.set_bullet_pool(bulletPool)
	camera.target = playerInstance
	playerInstance.spawnParameters(camera)
	playerInstance.spawnRequest.connect(_on_player_spawn_request)
	hud.activate(playerInstance)
	player = playerInstance

func makeSourceSpawn() -> StationBase :
	var sourceInstance = sourceScene.instantiate()
	playerItems.add_child(sourceInstance)
	sourceInstance.global_position = sourceSpawnMarker.global_position
	return sourceInstance

func _on_player_spawn_request(obj_instance: Variant, position: Variant) -> void:
	print("spawn request accepted")
	ressourcesManager.update_material(-obj_instance.materialPrice)
	var spawn_pos = position
	obj_instance.global_transform.origin = spawn_pos
	playerItems.add_child(obj_instance)
	obj_instance.initialisation(ressourcesManager)
	emit_signal("closeSublist")
	
	# Met à jour tous les ennemis
	if obj_instance.station_Type == StationReference.StationType.DEPLOYER :
		var enemies = get_tree().get_nodes_in_group("enemies")
		for enemy in enemies:
			enemy.set_Target()
	elif obj_instance.station_Type == StationReference.StationType.ATTACKER :
		resetTarget.connect(obj_instance.reset_target)
		obj_instance.set_bullet_pool(bulletPool)
		
	
	pass # Replace with function body.

	
func _on_control_emit_spawn_request(station_name: String) -> void:
	if player.spawnBluePrint.get_child_count() == 0 :
		var station_scene = StationReference.Station_sub_item_definition[station_name]["scene"]
		var instance = load(station_scene).instantiate()
		if ressourcesManager.isEnough(instance.materialPrice) :
			instance.activated = 0
			player.spawnBluePrint.add_child(instance)
			player.is_building_mode = true
			player.buildcooldown = player.buildCooldownAmount
			player.neededBuildArea = instance.neededAreaToBuild
		else :
			instance.queue_free()
	pass # Replace with function body.


func _on_player_items_child_entered_tree(node: Node) -> void:
	print("test")
	if node and node.is_in_group("Station") and node.station_Type == StationReference.StationType.ATTACKER :
		ressourcesManager.update_galaxium_rate(-node.galaxiumConsumption)
	pass # Replace with function body.


func _on_player_items_child_exiting_tree(node: Node) -> void:
	if node and node.is_in_group("Station") and node.station_Type == StationReference.StationType.ATTACKER :
		ressourcesManager.update_galaxium_rate(node.galaxiumConsumption)
	pass # Replace with function body.
