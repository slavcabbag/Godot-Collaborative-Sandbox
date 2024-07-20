@tool
extends StaticBody3D
var ctrl_held_last_frame = false
var comma_held_last_frame = false
var period_held_last_frame = false

var ramp_up = 0 #funny

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.is_editor_hint():
		pass
	if !Engine.is_editor_hint():
		if Input.is_key_pressed(KEY_CTRL) && Input.is_key_pressed(KEY_COMMA):
			ramp_up += 0.001#funny
			rotate_y(0.01 + ramp_up)
			scale = Vector3(randfn(scale.x,0.15),randfn(scale.x,0.15),randfn(scale.x,0.15))
		else:
			ramp_up = 0
		if key_released('ctrl') && comma_held_last_frame || key_released('comma') && ctrl_held_last_frame:
			var y_z_scale = randfn(scale.x,0.15)
			var x_scale = randfn(scale.z,0.15)
			#scale = Vector3(x_scale,y_z_scale,x_scale)
			scale = Vector3(randfn(scale.x,0.15),randfn(scale.x,0.15),randfn(scale.x,0.15))
		
		monitor_held_last_frame_variables()


func monitor_held_last_frame_variables():
	ctrl_held_last_frame = Input.is_key_pressed(KEY_CTRL)
	comma_held_last_frame = Input.is_key_pressed(KEY_COMMA)
	period_held_last_frame = Input.is_key_pressed(KEY_PERIOD)
	
func key_released(key):
	if key == 'ctrl':
		if ctrl_held_last_frame &&  !Input.is_key_pressed(KEY_CTRL):
			return true
		else:
			return false
	elif key == 'comma':
		if comma_held_last_frame &&  !Input.is_key_pressed(KEY_COMMA):
			return true
		else:
			return false
	elif key == 'period':
		if period_held_last_frame &&  !Input.is_key_pressed(KEY_PERIOD):
			return true
		else:
			return false

