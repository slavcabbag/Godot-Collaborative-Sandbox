extends Node3D
# Called every frame. 'delta' is the elapsed time since the previous frame.
var randnum = 0
var up_ = true
var scale__h
var doOnce = true


func _process(delta):
	if doOnce:
		randnum = randi_range(1,1) 
		if str(get_parent().get_script()) == "<GDScript#-9223295497769226097>":
			scale__h = get_parent().scale_h	
		doOnce = false
		
	if str(get_parent().get_script()) == "<GDScript#-9223295497769226097>":
		print(get_parent().name)
		pass
		#if Engine.get_frames_drawn() % randnum == 0.0:
			#if up_ && get_parent().scale_h > 3.4: up_ = false
			#if !up_ && get_parent().scale_h < 3: up_ = true
			#
			#if up_:
				#get_parent().scale_h = lerp(get_parent().scale_h, 5.5, delta * 5)
				#
			#else:
				#get_parent().scale_h = lerp(get_parent().scale_h, 1.5, delta * 5)
	else:
		if Engine.get_frames_drawn() % randnum == 0.0:
			if up_ && get_parent().scale.y > 2: up_ = false
			if !up_ && get_parent().scale.y < 1: up_ = true
			
			if up_:
				get_parent().scale.y = lerp(get_parent().scale.y, 2.1, delta * 5)
				
			else:
				get_parent().scale.y = lerp(get_parent().scale.y, 0.9, delta * 5)
