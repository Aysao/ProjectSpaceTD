extends Node3D

@export var follow_speed: float = 10.0
@export var snap_speed: float = 15.0

var player: Node3D
var locked_slot = null
var needed_slot = null
var is_snapped: bool = false

var cooldown_rate = 1.0
var preview_cooldown = 1.0

func _process(delta):
	if locked_slot:
		# Mode snap : va vers le slot
		_snap_to_slot(delta)
	elif player:
		# Mode suivi : suit le joueur
		_follow_player(delta)
	
func init_player():
	player = get_tree().get_first_node_in_group("Player")
	if not player:
		push_error("Pas de joueur trouvé!")

func _follow_player(delta):
	# Récupère la direction dans laquelle regarde le joueur
	var forward = -player.global_transform.basis.z  # Direction avant
	var up = Vector3.UP
	
	# Position devant le joueur
	var distance_forward = 10.0  # Distance devant
	var height = 1.0  # Hauteur au-dessus du sol
	
	var target = player.global_position + forward * distance_forward + up * height
	
	self.global_position = self.global_position.lerp(target, follow_speed * delta)
	
func _snap_to_slot(delta):
	var target_pos = locked_slot.global_position
	global_position = global_position.lerp(target_pos, snap_speed * delta)	
	
func lock_to_slot(slot: Node3D):
	locked_slot = slot
	is_snapped = true
	_update_visual(true)
	
func unlock_from_slot():
	locked_slot = null
	is_snapped = false
	_update_visual(false)


func reset():
	if get_child_count() > 0: 
		get_child(0).queue_free()
	unlock_from_slot()
	locked_slot = null
	needed_slot = null
	is_snapped = false
	
func _update_visual(snapped: bool):
	# Change la couleur ou l'apparence
	pass
	
