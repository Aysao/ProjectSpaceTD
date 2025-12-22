extends CharacterBody3D

# ENNEMIE CONFIGURATION 
var target = null
var activated = false
var fire_cooldown := 0.0
var bullet_layer = 3;
@export var bullet_target = 2;

# ENNEMIE STATS
@export var hit_point = 100.0
@export var maxHp := 100.0
@export var SPEED = 6.0
@export var FIRE_RATE = 1.0
@export var fire_distance = 20;
@export var DAMAGE = 15;
@export var materialsDropRate := 50
@export var materialsDropAmount := 1

@onready var pivotmesh := $Pivot
@onready var collisionMesh := $CollisionShape3D

var bulletPool : BulletPool
@onready var pos = $posBullet

#Signal
signal onEnemieDeath(value, enemieNode)

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if target == null:
		target = get_Target()
		
	if target:
		# regarde vers le prism
		look_at(target.global_position, Vector3.UP)
		if global_position.distance_to(target.global_position) > fire_distance:
			var direction = (target.global_position - global_position).normalized()
			velocity = direction * SPEED
			move_and_slide()
		else: 
			if fire_cooldown > 0.0:
				fire_cooldown -= delta
		
			if fire_cooldown <= 0.0:
				var instance = bulletPool.get_enemie_bullet()
				print("Bullet : %s" % instance)
				instance.damage = DAMAGE
				instance.target=bullet_target
				instance.position=pos.global_position
				instance.transform.basis = pos.global_transform.basis
				instance.direction = -pos.global_transform.basis.z.normalized()
				
				fire_cooldown = FIRE_RATE
	
	
	
		
func get_Target() -> CharacterBody3D:
	var closest_prism: CharacterBody3D = null
	var min_distance := INF
	
	for prism in get_tree().get_nodes_in_group("Station"):
		if  prism.is_inside_tree():
			var dist = global_position.distance_to(prism.global_position)
			if dist < min_distance:
				min_distance = dist
				closest_prism = prism
	return closest_prism
	
func set_Target():
	target = get_Target()
	
func dropCalculation() -> bool:
	return (randi() % 100 + 1) < materialsDropRate
	

func take_damage(damage: int) -> void:
	hit_point -= damage
	#$Label3D.text = String.num_scientific(hit_point)
	if hit_point <= 0:
		if dropCalculation():
			onEnemieDeath.emit(materialsDropAmount, self)
		else: 
			onEnemieDeath.emit(0, self)

func deactivate():
	set_process(false)
	set_physics_process(false)
	target = null
	activated = false
	hit_point = maxHp
	pivotmesh.hide()
	collisionMesh.disabled = true
	
func spawn_enemie(pos):
	global_position = pos
	activated = true
	set_process(true)
	set_physics_process(true)
	pivotmesh.show()
	collisionMesh.disabled = false
	
func is_active() -> bool :
	return activated
	
func setPool(bullet_pool : BulletPool):
	bulletPool = bullet_pool
