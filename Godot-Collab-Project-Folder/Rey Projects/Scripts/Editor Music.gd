@tool
extends AudioStreamPlayer

var play_editor_intro_on_launch = true
var has_played_intro_music = false

#inputdumb variables to have key released (input.action stuff doesn't work)
var ctrl_held_last_frame = false
var one_held_last_frame = false
var tilde_held_last_frame = false

const ELDEN_RING_TITLE_SCREEN_THEME = preload("res://Rey Projects/Assets/Music/Elden Ring Title Screen Theme.mp3")
const CHRONO_CROSS_OPENING = preload("res://Rey Projects/Assets/Music/Chrono Cross Opening.mp3")
const SUPER_SMASH_BROS_4_MAIN_THEME = preload("res://Rey Projects/Assets/Music/Super Smash Bros 4 Main Theme.mp3")




func _process(delta):
	# if is in editor 
	if Engine.is_editor_hint():
		if has_played_intro_music == false:
			if play_editor_intro_on_launch:
				if playing == false:
					random_select_music()
			has_played_intro_music = true
			print("press ctrl + `/~ to toggle the music")
		
		# ctrl + ` once = autoplay on, twice = playing song
		# ctrl + ` thrice = randomize song and play
		# await only waits after something is done, it seems to make it smoother somehow
		if key_ctrl_released() && tilde_held_last_frame || key_tilde_released() && ctrl_held_last_frame:
			print("e")
			if autoplay == true:
				await random_select_music()
				playing = true
			elif playing == false && autoplay == false:
				autoplay = true
			
		#turn off song and autoplay
		if Input.is_key_pressed(KEY_CTRL) && Input.is_key_pressed(KEY_1):
			autoplay = false
			playing = false
		monitor_held_last_frame_variables()
	
	if !Engine.is_editor_hint():
		autoplay = false
		playing = false
	


func get_all_children(in_node, children_acc = []):
	children_acc.push_back(in_node)
	for child in in_node.get_children():
		children_acc = get_all_children(child, children_acc)

	return children_acc
	
func random_editor_intro_song():
	var songs = [ELDEN_RING_TITLE_SCREEN_THEME, CHRONO_CROSS_OPENING, SUPER_SMASH_BROS_4_MAIN_THEME]
	var chosen_song = songs.pick_random()
	return chosen_song
func set_volume_db_from_song(song):
	if song == ELDEN_RING_TITLE_SCREEN_THEME:
		return -3.5
	elif song == CHRONO_CROSS_OPENING:
		return -12.5
	elif song == SUPER_SMASH_BROS_4_MAIN_THEME:
		return -15.5
func random_select_music():
	var editor_intro_song = random_editor_intro_song()
	stream = editor_intro_song
	volume_db = set_volume_db_from_song(editor_intro_song)

func monitor_held_last_frame_variables():
	ctrl_held_last_frame = Input.is_key_pressed(KEY_CTRL)
	one_held_last_frame = Input.is_key_pressed(KEY_1)
	tilde_held_last_frame = Input.is_key_pressed(KEY_QUOTELEFT)

func key_ctrl_released():
	if ctrl_held_last_frame &&  !Input.is_key_pressed(KEY_CTRL):
		return true
	else:
		return false
		
func key_one_released():
	if one_held_last_frame && !Input.is_key_pressed(KEY_1):
		return true
	else:
		return false

func key_tilde_released():
	if tilde_held_last_frame && !Input.is_key_pressed(KEY_QUOTELEFT):
		return true
	else:
		return false
