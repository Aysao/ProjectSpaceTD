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
@onready var station_preview := $GameNode/WorldParameters/station_preview
@onready var placementManager := $PlacementManager
var player : CharacterBody3D



#Preload Scene
var playerScene := preload("res://Scene/player.tscn")
var sourceScene := preload("res://Scene/Station/PlacementStation/SourceStation.tscn")


func _process(delta: float) -> void:
	pass
		

func _on_main_menu_run_start() -> void:
	
	var source = makeSourceSpawn()
	
	placementManager.init()
	
	bulletManagement()
	
	makePlayerSpawn(source)
	
	ressourcesManagerSetup()
	
	ennemiesManagement()
	
	set_process(true)
	pass # Replace with function body.
	
func ressourcesManagerSetup():
	ressourcesManager.setHud(hud)
	ressourcesManager.initialize()
	ressourcesManager.activate()

func bulletManagement():
	bulletPool.generateEnemieBulletPool()
	bulletPool.generatePlayerBulletPool()

func ennemiesManagement():
	enemiesSpawnMaker.generateEnemiesPool(bulletPool)
	enemiesSpawnMaker.init(ressourcesManager)
	enemiesSpawnMaker.launch_enemie_pool()




func makePlayerSpawn(source: StationBase):
	var playerInstance = playerScene.instantiate()
	playerNode.add_child(playerInstance)
	playerInstance.global_position = playerSpawnMarker.global_position
	playerInstance.set_bullet_pool(bulletPool)
	camera.target = playerInstance
	playerInstance.spawnParameters(camera,playerItems)
	hud.activate(playerInstance)
	player = playerInstance
	station_preview.init_player()

func makeSourceSpawn() -> StationBase :
	var sourceInstance = sourceScene.instantiate()
	playerItems.add_child(sourceInstance)
	sourceInstance.global_position = sourceSpawnMarker.global_position
	return sourceInstance


func _on_player_items_child_entered_tree(node: Node) -> void:
	if node and node.is_in_group("Station") and node.station_Type == StationReference.StationType.ATTACKER :
		ressourcesManager.update_galaxium_rate(-node.galaxiumConsumption)
	pass # Replace with function body.


func _on_player_items_child_exiting_tree(node: Node) -> void:
	if node and node.is_in_group("Station") and node.station_Type == StationReference.StationType.ATTACKER :
		ressourcesManager.update_galaxium_rate(node.galaxiumConsumption)
	pass # Replace with function body.
