extends CharacterBody3D

@onready var collision := $Area3D/CollisionShape3D
@export var speed = 50;
var direction: Vector3 = Vector3.ZERO;
@export var damage = 10;
@export var bullet_range = 300;
@export var target = 0;
var activated = false

signal releaseBullet(bullet)


func _physics_process(delta: float) -> void:
	if(activated):
		move_and_collide(direction * speed *delta)

		if global_position.length() > bullet_range:
			freeBullet()
	


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body and body.is_in_group("shootable") && body.is_active():
		if body.bullet_layer == target:
			body.take_damage(damage)
		freeBullet()
	pass # Replace with function body.

func initBullet(in_direction, in_target, in_damage, in_position):
	position = in_position.global_position
	transform.basis = in_position.global_transform.basis
	target = in_target
	damage = in_damage
	direction = in_direction

func freeBullet():
	releaseBullet.emit(self)
