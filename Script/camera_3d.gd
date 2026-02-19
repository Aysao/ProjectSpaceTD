extends Camera3D

@export var target: Node3D      # Ton joueur
@export var offset := Vector3(0, 50, 0)  # hauteur de la caméra
@export var smooth_speed := 5.0          # fluidité du suivi

@onready var marker_3d: Marker3D = $".."


var shake_intensity := 0.0
var shake_decay := 5.0

func _ready():
	if target:
		global_position = target.global_position + offset

func _process(delta):
	if target == null:
		return
	
	# Position cible = position du joueur + offset
	var desired_pos = target.global_position + offset
	
	# On lisse le déplacement de la caméra (évite les secousses)
	global_position = global_position.lerp(desired_pos, delta * smooth_speed)
	
	# On verrouille la rotation (vue fixe vers le bas)
	look_at(target.global_position, Vector3.FORWARD)
	rotation_degrees.x = 12  # oriente la caméra vers le bas
	
	if shake_intensity > 0:
		marker_3d.transform.origin = Vector3(
			randf_range(-1,1),
			randf_range(-1,1),
			randf_range(-1,1)
		) * shake_intensity
		
		shake_intensity = max(shake_intensity - shake_decay * delta, 0)


func shake(intensity: float):
	shake_intensity = intensity
