extends CharacterBody3D


@export var HIT_POINT = 100.0;
@export var type := "Source" # "little", "Source"
@export var bullet_layer = 2;
@export var buildZoneSize = 50.0
@export var galaxium_price = 10.0
@onready var buildZone = $Area3D/BuildZone


signal build_area_entered
signal build_area_exited

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if buildZone.shape == null:
		buildZone.shape = CylinderShape3D.new()
	if(buildZone.shape is CylinderShape3D):
		buildZone.shape.radius = buildZoneSize
	$Label3D.text = String.num_scientific(HIT_POINT)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func take_damage(damage: int) -> void:
	HIT_POINT -= damage
	$Label3D.text = String.num_scientific(HIT_POINT)
	if HIT_POINT <= 0:
		queue_free()


func _on_area_3d_body_entered(body: Node3D) -> void:
	print(body)
	if(body.is_in_group("Player")):
		emit_signal("build_area_entered")
	pass # Replace with function body.


func _on_area_3d_body_exited(body: Node3D) -> void:
	if(body.is_in_group("Player")):
		emit_signal("build_area_exited")
	pass # Replace with function body.
