@tool
extends AudioStreamPlayer

var play_editor_intro_on_launch = true
var has_played_intro_music = false

const ELDEN_RING_TITLE_SCREEN_THEME = preload("res://Rey Projects/Assets/Music/Elden Ring Title Screen Theme.mp3")
const CHRONO_CROSS_OPENING = preload("res://Rey Projects/Assets/Music/Chrono Cross Opening.mp3")
const SUPER_SMASH_BROS_4_MAIN_THEME = preload("res://Rey Projects/Assets/Music/Super Smash Bros 4 Main Theme.mp3")

func _process(delta):
	if has_played_intro_music == false:
		if play_editor_intro_on_launch:
			if playing == false:
				var editor_intro_song = random_editor_intro_song()
				stream = editor_intro_song
				volume_db = set_volume_db_from_song(editor_intro_song)
				playing = true
		has_played_intro_music = true

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
