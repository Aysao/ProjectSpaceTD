extends CharacterBody3D

# MOVEMENT VARIABLE 
@export var SPEED = 15.0
@export var speedboost = 2
var actual_speed = 15.0
@export var rotation_speed := 10.0

# NODES
@export var camera: Camera3D  # Assigne ta caméra ici

# BULLET CONFIGURATION
@export var bullet_target = 3;
var bullet_layer = 0;
var fire_cooldown := 0.0

# BULLET STATS
@export var FIRE_RATE = 1.0
@export var DAMAGE = 20

var bullet = load("res://bullet.tscn")
@onready var pos = $posBullet

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(_delta):

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_back") - Input.get_action_strength("move_forward")
	)
	var direction = Vector3(input_dir.x, 0, input_dir.y).normalized()
	var actual_speed = SPEED
	if Input.is_action_pressed("Shift"):
		actual_speed = SPEED * speedboost
	if direction:
		velocity.x = direction.x * actual_speed
		velocity.z = direction.z * actual_speed
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
	if Input.is_action_pressed("Shoot"):
		if fire_cooldown > 0.0:
			fire_cooldown -= _delta
		
		if fire_cooldown <= 0.0:
			var instance = bullet.instantiate()
			instance.damage = DAMAGE
			instance.target=bullet_target
			instance.position= pos.global_position
			instance.transform.basis = pos.global_transform.basis
			instance.direction = -pos.global_transform.basis.z.normalized()
			
			get_parent().add_child(instance)
			fire_cooldown = FIRE_RATE

# --- Rotation vers la souris ---
	if camera:
		var mouse_world_pos = get_mouse_world_pos()
		mouse_world_pos.y = global_position.y  # On reste sur le même plan Y
		var target_dir = (mouse_world_pos - global_position).normalized()

		# Rotation fluide sur Y
		var target_basis = Basis().looking_at(target_dir, Vector3.UP)
		global_transform.basis = global_transform.basis.slerp(target_basis, _delta * rotation_speed)

	
	
func get_mouse_world_pos() -> Vector3:
	# Récupère le rayon de la caméra vers la souris
	var mouse_pos = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var dir = camera.project_ray_normal(mouse_pos)

	# --- Définir le plan virtuel ---
	# On définit un plan horizontal à la hauteur du joueur
	var plane_y = global_position.y
	var plane = Plane(Vector3.UP, plane_y)

	# --- Calcul de l'intersection ---
	var intersect = plane.intersects_ray(from, dir)
	if intersect != null:
		return intersect
	else:
		# Si pas d'intersection (rare), on renvoie un point devant le joueur
		return global_position + -global_transform.basis.z * 10
