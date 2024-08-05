extends Node3D
# Called every frame. 'delta' is the elapsed time since the previous frame.
var enabled = false
var randnum = 0
var up_ = true
var scale__h
var doOnce = true
var switching_direction = false
var start_script = false
@onready var timer = $Timer
@onready var funny_timer = $Timer2

func _process(delta):
	if enabled:
		if doOnce:
			randnum = randi_range(1,6) 
			if name != "SimpleGrassTextured2":
				funny_timer.set_wait_time(0.3)
			doOnce = false
			timer.start()
		if start_script == false && funny_timer.time_left == 0.0 || name == "SimpleGrassTextured2": 
			start_script = true
		#if start_script == false && Engine.get_frames_drawn() % randnum == 0.0 || name == "SimpleGrassTextured2": 
			#start_script = true
		
		
		if str(get_parent().get_script()) == "<GDScript#-9223295497769226097>":
			pass
		else:
			if start_script == true:
				if up_ && get_parent().scale.y > 2: 
					up_ = false
					timer.start()
				if !up_ && get_parent().scale.y < 0.6: 
					up_ = true
					timer.start()
					
				if timer.time_left == 0:
					if up_:
						get_parent().scale.y = lerp(get_parent().scale.y, 2.05, delta * 12)
					if !up_:
						get_parent().scale.y = lerp(get_parent().scale.y, 0.55, delta * 12)









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
