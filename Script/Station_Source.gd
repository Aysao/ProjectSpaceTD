extends StationBase

@onready var animation := $Model/NewSource/AnimationPlayer

func init():
	update_label_position(true)
	var animIdle = animation.get_animation("idle")
	animIdle.loop_mode = Animation.LOOP_LINEAR
	animation.play("idle")
