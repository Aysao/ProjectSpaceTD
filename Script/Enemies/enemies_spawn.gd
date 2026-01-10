extends Node3D


@export var enemiesPoolAmount := 2
var enemiesPool := []
var enemiesOnfied := []
var enemiesCooldown := 5.0
var enemiesCooldownTimer := 5.0

var ressourceManager = null
@onready var enemieNode := $"../GameNode/Enemies"
@onready var enemiesSpawnerMarker = $"."

var enemieScene := preload("res://Scene/Enemies/pirateSpaceShip.tscn")

signal resetTarget(target : Node3D)

func _ready() -> void:
	set_process(false)

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
			enemie.spawn_enemie(enemiesSpawnerMarker.global_position)


func generateEnemiesPool(bulletPool):
	for i in range(enemiesPoolAmount):
		var enemieInstance = enemieScene.instantiate()
		enemieNode.add_child(enemieInstance)
		enemieInstance.setPool(bulletPool)
		enemieInstance.deactivate()
		enemieInstance.onEnemieDeath.connect(_on_enemie_death)
		enemieInstance.global_position = enemiesSpawnerMarker.global_position
		enemiesPool.append(enemieInstance)

func _on_enemie_death(value: int, enemieNode):
	if value > 0:
		ressourceManager.update_material(value)
	resetTarget.emit(enemieNode)
	enemieNode.deactivate()
	enemiesPool.append(enemieNode)
	enemiesOnfied.erase(enemieNode)


func init(ressourceManagerIn : Node):
	ressourceManager = ressourceManagerIn

func launch_enemie_pool():
	set_process(true)
