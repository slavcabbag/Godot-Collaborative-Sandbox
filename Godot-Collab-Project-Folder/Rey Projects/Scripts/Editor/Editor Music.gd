@tool
extends AudioStreamPlayer

@onready var timer = $"../Timer"

var spooky_enabled = true

var play_editor_intro_on_launch = true
var has_played_intro_music = false


#inputdumb variables to have key released (input.action stuff doesn't work)
var ctrl_held_last_frame = false
var one_held_last_frame = false
var tilde_held_last_frame = false

var song_type = "short"

const ELDEN_RING_TITLE_SCREEN_THEME = preload("res://Rey Projects/Assets/Music/Elden Ring Title Screen Theme.mp3")
const CHRONO_CROSS_OPENING = preload("res://Rey Projects/Assets/Music/Chrono Cross Opening.mp3")
const SUPER_SMASH_BROS_4_MAIN_THEME = preload("res://Rey Projects/Assets/Music/Super Smash Bros 4 Main Theme.mp3")
const WILLY_WONKA_PURE_IMAGINATION = preload("res://Rey Projects/Assets/Music/Willy Wonka - Pure Imagination (Future James Trap Remix).mp3")
const PAPER_IDOL_JAMES_BOND = preload("res://Rey Projects/Assets/Music/Paper Idol – James Bond.mp3")
const SPOOKY_SCARY_SKELETONS = preload("res://Rey Projects/Assets/Music/Spooky, Scary Skeletons - Undead Tombstone.mp3")
const S_M_U_G__D_A_N_C_I_N = preload("res://Rey Projects/Assets/Music/S M U G  - D A N C I N.mp3")
const UGOVHB_WTF_2 = preload("res://Rey Projects/Assets/Music/UGOVHB - WTF 2.mp3")
const JAXOMY_PEDRO_PEDRO = preload("res://Rey Projects/Assets/Music/Jaxomy_Pedro_Pedro.mp3")

func _process(delta):
	if !Engine.is_editor_hint():
		if spooky_enabled:
			if play_editor_intro_on_launch:
				random_select_music()
				play_editor_intro_on_launch = false
				
				playing = true
				autoplay = true

		#turn off song and autoplay
		if Input.is_key_pressed(KEY_CTRL) && Input.is_key_pressed(KEY_1):
			autoplay = false
			playing = false
		monitor_held_last_frame_variables()


	if !Engine.is_editor_hint():
		if !spooky_enabled:
			autoplay = false
			playing = false
		pass	 
	if Engine.is_editor_hint():
		
		if has_played_intro_music == false:
			if play_editor_intro_on_launch:
				if playing == false:
					random_select_music()
			has_played_intro_music = true
			print("press ctrl + `/~ to play the music. ctrl + 1 to stop it")
			print("tap \"ctrl + `/~\" twice to play long music")
		
		# ctrl + ` once = autoplay on, twice = playing song
		# ctrl + ` thrice = randomize song and play
		# await only waits after something is done, it seems to make it smoother somehow
		if key_ctrl_released() && tilde_held_last_frame || key_tilde_released() && ctrl_held_last_frame:
			if timer.time_left < timer.wait_time-0.01 && timer.time_left != 0:
				song_type = "long"
			else:
				timer.start()
				song_type = "short"
			if autoplay == true:
				print("playing music")
				await random_select_music()
				playing = true
			elif playing == false && autoplay == false:
				autoplay = true
				print("autoplay on")
			
		#turn off song and autoplay
		if Input.is_key_pressed(KEY_CTRL) && Input.is_key_pressed(KEY_1):
			autoplay = false
			playing = false
		monitor_held_last_frame_variables()
	
	


func get_all_children(in_node, children_acc = []):
	children_acc.push_back(in_node)
	for child in in_node.get_children():
		children_acc = get_all_children(child, children_acc)

	return children_acc
	
func random_editor_intro_song(song_type):
	var songs
	if song_type == 'short':
		songs = [JAXOMY_PEDRO_PEDRO, ELDEN_RING_TITLE_SCREEN_THEME, CHRONO_CROSS_OPENING, SUPER_SMASH_BROS_4_MAIN_THEME, UGOVHB_WTF_2]
	elif song_type == 'long':
		songs = [JAXOMY_PEDRO_PEDRO, WILLY_WONKA_PURE_IMAGINATION, PAPER_IDOL_JAMES_BOND, S_M_U_G__D_A_N_C_I_N]
	var chosen_song = songs.pick_random()
	return chosen_song
func set_volume_db_from_song(song):
	if song == ELDEN_RING_TITLE_SCREEN_THEME:
		return 5.0
	elif song == CHRONO_CROSS_OPENING:
		return -6.0
	elif song == SUPER_SMASH_BROS_4_MAIN_THEME:
		return -5
	elif song == WILLY_WONKA_PURE_IMAGINATION:
		return -2.2
	elif song == PAPER_IDOL_JAMES_BOND:
		return -9.0
	elif song == S_M_U_G__D_A_N_C_I_N:
		return -4
	elif song == UGOVHB_WTF_2: #saw in an edit, supa high energi. #prob dirty lyrics, but I don't speak that language hahaha
		return -11
	elif song == JAXOMY_PEDRO_PEDRO:
		return -5
func random_select_music():
	print(song_type)
	var editor_intro_song = random_editor_intro_song(song_type)
	stream = editor_intro_song
	volume_db = set_volume_db_from_song(editor_intro_song)
	if !Engine.is_editor_hint():
		stream = SPOOKY_SCARY_SKELETONS
		volume_db = -13

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
