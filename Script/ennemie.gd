extends CharacterBody3D

# ENNEMIE CONFIGURATION 
var target = null
var fire_cooldown := 0.0
var bullet_layer = 3;
@export var bullet_target = 2;

# ENNEMIE STATS
@export var HIT_POINT = 100.0
@export var SPEED = 6.0
@export var FIRE_RATE = 1.0
@export var fire_distance = 20;
@export var DAMAGE = 15;


var bullet = load("res://Scene/bullet.tscn")
@onready var pos = $posBullet

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
				var instance = bullet.instantiate()
				instance.damage = DAMAGE
				instance.target=bullet_target
				instance.position=pos.global_position
				instance.transform.basis = pos.global_transform.basis
				instance.direction = -pos.global_transform.basis.z.normalized()
				
				get_parent().add_child(instance)
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
	
func take_damage(damage: int) -> void:
	HIT_POINT -= damage
	#$Label3D.text = String.num_scientific(HIT_POINT)
	if HIT_POINT <= 0:
		queue_free()
	
