extends Camera3D

@export var target: Node3D      # Ton joueur
@export var offset := Vector3(0, 50, 0)  # hauteur de la caméra
@export var smooth_speed := 5.0          # fluidité du suivi

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
