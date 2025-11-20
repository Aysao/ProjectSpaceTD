extends CharacterBody3D


@export var speed = 50;
var direction: Vector3 = Vector3.ZERO;
@export var damage = 10;
@export var bullet_range = 300;
@export var target = 0;

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(direction * speed *delta)
	
	if collision:
		var body = collision.get_collider()
		print(body);
		if body and body.is_in_group("shootable"):
			if body.bullet_layer == target:
				body.take_damage(damage)
		queue_free()

	if global_position.length() > bullet_range:
		queue_free()
	
