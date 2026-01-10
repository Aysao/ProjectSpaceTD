extends StationBasePlacement

@onready var animation := $Model/NewSource/AnimationPlayer



func initAnimation():
	var animIdle = animation.get_animation("idle")
	animIdle.loop_mode = Animation.LOOP_LINEAR
	animation.play("idle")


func start_hold():
	pass
	
func stop_hold():
	pass
