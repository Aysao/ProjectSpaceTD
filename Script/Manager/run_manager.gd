extends Node3D
class_name RunManager

@onready var sourceSpawnMarker := $SourceSpawnMarker
@onready var playerSpawnMarker := $PlayerSpawnMarker
@onready var enemiesSpawnMaker := $EnemiesSpawnMarker
@onready var playerNode := $GameNode/Players
@onready var enemieNode := $GameNode/Enemies
@onready var player_items: Node3D = $GameNode/PlayerItems
@onready var hud := $GameNode/Control
@onready var camera_3d: Camera3D = $WorldParameters/Marker3D/Camera3D
@onready var bulletPool := $BulletManager
@onready var station_preview: Node3D = $WorldParameters/station_preview
@onready var placementManager := $PlacementManager
@onready var wave_manager := $WaveManager
@onready var ressources_manager: ResourcesManager = $RessourcesManager

var player : CharacterBody3D

@onready var visual_area_game: MeshInstance3D = $WorldParameters/StaticBody3D/MeshInstance3D

@export var world_radius:= 300.0


#Preload Scene
var playerScene := preload("res://Scene/player.tscn")
var sourceScene := preload("res://Scene/Station/PlacementStation/SourceStation.tscn")


func _process(delta: float) -> void:
	pass
		

func run_start() -> void:
	setup_world_parameters()
	
	var source = makeSourceSpawn()
	
	placementManager.init()
	
	bulletManagement()
	
	makePlayerSpawn(source)
	
	ressourcesManagerSetup()
	
	ennemiesManagement()
	
	wave_manager.setup_wave_manager()
	wave_manager.launch_wave()
	
	set_process(true)
	pass # Replace with function body.
	
func ressourcesManagerSetup():
	ressources_manager.setHud(hud)
	ressources_manager.initialize()
	ressources_manager.activate()

func bulletManagement():
	bulletPool.generateEnemieBulletPool()
	bulletPool.generatePlayerBulletPool()

func ennemiesManagement():
	enemiesSpawnMaker.connector_setup()
	enemiesSpawnMaker.generate_all_enemies_pool(bulletPool)
	enemiesSpawnMaker.launch_enemie_pool()


func setup_world_parameters():
	WorldParameters.area_radius = world_radius
	var torus_mesh : TorusMesh = visual_area_game.mesh
	torus_mesh.inner_radius = WorldParameters.area_radius + 2 
	torus_mesh.outer_radius = WorldParameters.area_radius + 150


func makePlayerSpawn(source: StationBase):
	var playerInstance = playerScene.instantiate()
	playerNode.add_child(playerInstance)
	playerInstance.global_position = playerSpawnMarker.global_position
	playerInstance.set_bullet_pool(bulletPool)
	camera_3d.target = playerInstance
	playerInstance.spawnParameters(camera_3d,player_items)
	hud.activate(playerInstance)
	player = playerInstance
	station_preview.init_player()

func makeSourceSpawn() -> StationBase :
	var sourceInstance = sourceScene.instantiate()
	player_items.add_child(sourceInstance)
	sourceInstance.global_position = sourceSpawnMarker.global_position
	return sourceInstance


func _on_player_items_child_entered_tree(node: Node) -> void:
	if node and node.is_in_group("Station") and (node.station_Type == StationReference.StationType.ATTACKER or node.station_Type == StationReference.StationType.SUPPORT) :
		EventBus.update_galaxium_rate.emit(-node.galaxiumConsumption)
	pass # Replace with function body.


func _on_player_items_child_exiting_tree(node: Node) -> void:
	if node and node.is_in_group("Station") and (node.station_Type == StationReference.StationType.ATTACKER or node.station_Type == StationReference.StationType.SUPPORT) :
		EventBus.update_galaxium_rate.emit(node.galaxiumConsumption)
	pass # Replace with function body.
