extends CharacterBody3D


@export var HIT_POINT = 100.0;
@export var type := "Source" # "little", "Source"
@export var bullet_layer = 2;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
