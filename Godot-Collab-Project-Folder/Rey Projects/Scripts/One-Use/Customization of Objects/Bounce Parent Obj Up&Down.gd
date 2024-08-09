extends Node3D
# Called every frame. 'delta' is the elapsed time since the previous frame.
var enabled = false
var randnum = 0
var up_ = true
var scale__h
var doOnce = true
var switching_direction = false
var start_script = false
var speed_modifier = 1
@onready var timer = $Timer
@onready var funny_timer = $Timer2
@onready var funny_speed_timer = $Timer3

func _process(delta):
	if enabled:
		if doOnce:
			randnum = 1
			if get_parent().name.match("SimpleGrassTextured2"):
				funny_timer.wait_time = 0.11 + .5
			elif get_parent().name.to_lower().match("* fences*"):
				funny_timer.wait_time = 0.11 + .5
			elif get_parent().name.to_lower().match("* graves*"):
				funny_timer.wait_time = 0.23 + .5
			elif get_parent().name.match("Lightposts"):
				funny_timer.wait_time = 0.11 + .5
			elif get_parent().name.match("crypt2"):
				funny_timer.wait_time = 0.23 + .5
			else:
				funny_timer.wait_time = 0.01
			speed_modifier = .85
			funny_timer.start()
			timer.start()
			doOnce = false
		
		
		if start_script == false && funny_timer.time_left == 0.0:
			start_script = true
		#if start_script == false && Engine.get_frames_drawn() % randnum == 0.0 || name == "SimpleGrassTextured2": 
			#start_script = true
		
		

		if start_script == true:
			if up_ && get_parent().scale.y > 2: 
				up_ = false
				timer.start()
			if !up_ && get_parent().scale.y < 0.6: 
				up_ = true
				timer.start()

			if funny_speed_timer.time_left != 0:
				if up_:
					get_parent().scale.y = lerp(get_parent().scale.y, 2.05, delta * 21)
				if !up_:
					get_parent().scale.y = lerp(get_parent().scale.y, 0.55, delta * 21)
			else:
				if up_:
					get_parent().scale.y = lerp(get_parent().scale.y, 2.05, delta * 8.5 * speed_modifier)
				if !up_:
					get_parent().scale.y = lerp(get_parent().scale.y, 0.55, delta * 8.5 * speed_modifier)


# uses timer vvv

			#if timer.time_left == 0:
				#if funny_speed_timer.time_left != 0:
					#if up_:
						#get_parent().scale.y = lerp(get_parent().scale.y, 2.05, delta * 21 * speed_modifier)
					#if !up_:
						#get_parent().scale.y = lerp(get_parent().scale.y, 0.55, delta * 21 * speed_modifier)
				#else:
					#if up_:
						#get_parent().scale.y = lerp(get_parent().scale.y, 2.05, delta * 8.5 * speed_modifier)
					#if !up_:
						#get_parent().scale.y = lerp(get_parent().scale.y, 0.55, delta * 8.5 * speed_modifier)









			#Old Funny Version (ctrl + k to un-comment)

#extends Node3D
## Called every frame. 'delta' is the elapsed time since the previous frame.
#var randnum = 0
#var up_ = true
#var scale__h
#var doOnce = true
#var switching_direction = false
#var start_script = false
#var numnum = 1
#@onready var timer = $Timer
#
#func _process(delta):
	#
	#if doOnce:
		#randnum = randi_range(1,6) 
		#if str(get_parent().get_script()) == "<GDScript#-9223295497769226097>":
			#scale__h = get_parent().scale_h
		#doOnce = false
		#timer.start()
	#if start_script == false && Engine.get_frames_drawn() % randnum == 0.0: 
		#start_script = true
	#
	#if Input.is_key_pressed(KEY_6):
		#numnum = 1 
	#else: 
		#numnum = -1
	#
	#if str(get_parent().get_script()) == "<GDScript#-9223295497769226097>":
		#pass
	#else:
		#if start_script == true:
			#if up_ && get_parent().scale.y > 2: 
				#up_ = false
				#timer.start()
			#if !up_ && get_parent().scale.y < 0.5: 
				#up_ = true
				#timer.start()
				#
			#if timer.time_left == 0:
				#if up_:
					#get_parent().scale.y = lerp(get_parent().scale.y, 2.05, delta * numnum)
				#if !up_:
					#get_parent().scale.y = lerp(get_parent().scale.y, 0.45, delta * numnum)
