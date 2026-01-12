extends Node2D

@onready var btnPlay: Button = %ButtonPlay
@onready var btnDefault: Button = %ButtonDefault
@onready var btnEndless: Button = %ButtonEndless

@onready var btnEasy: Button = %ButtonEasy
@onready var btnNormal: Button = %ButtonNormal
@onready var btnHard: Button = %ButtonHard
@onready var btnNightmare: Button = %ButtonNightmare

const GAME_SCENE := "res://scenes/game.tscn"

func _ready() -> void:
	
	btnPlay.pressed.connect(_on_play_pressed)
	btnDefault.pressed.connect(_on_default_pressed)
	btnEndless.pressed.connect(_on_endless_pressed)
	btnEasy.pressed.connect(_on_easy_pressed)
	btnNormal.pressed.connect(_on_normal_pressed)
	btnHard.pressed.connect(_on_hard_pressed)
	btnNightmare.pressed.connect(_on_nightmare_pressed)

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file(GAME_SCENE)

func _on_default_pressed() -> void:
	_select_default_mode()

func _on_endless_pressed() -> void:
	_select_endless_mode()

func _on_easy_pressed():
	Global.difficulty = Global.Difficulty.EASY
	_update_difficulty_visual()

func _on_normal_pressed():
	Global.difficulty = Global.Difficulty.NORMAL
	_update_difficulty_visual()

func _on_hard_pressed():
	Global.difficulty = Global.Difficulty.HARD
	_update_difficulty_visual()

func _on_nightmare_pressed():
	Global.difficulty = Global.Difficulty.NIGHTMARE
	_update_difficulty_visual()

	

func _select_default_mode() -> void:
	Global.game_mode = Global.GameMode.DEFAULT
	Global.question_limit = 10

	btnDefault.disabled = true
	btnEndless.disabled = false

	_set_difficulty_buttons(true)
	_update_visual()


func _select_endless_mode() -> void:
	Global.game_mode = Global.GameMode.ENDLESS
	Global.difficulty = Global.Difficulty.EASY

	btnDefault.disabled = false
	btnEndless.disabled = true

	_set_difficulty_buttons(false)
	_update_visual()
	_update_difficulty_visual()

func _set_difficulty_buttons(enable: bool) -> void:
	btnEasy.disabled = not enable
	btnNormal.disabled = not enable
	btnHard.disabled = not enable
	btnNightmare.disabled = not enable


func _update_visual() -> void:
	btnDefault.modulate = Color.WHITE if btnDefault.disabled else Color(0.7, 0.7, 0.7)
	btnEndless.modulate = Color.WHITE if btnEndless.disabled else Color(0.7, 0.7, 0.7)

func _update_difficulty_visual() -> void:
	var buttons := {
		Global.Difficulty.EASY: btnEasy,
		Global.Difficulty.NORMAL: btnNormal,
		Global.Difficulty.HARD: btnHard,
		Global.Difficulty.NIGHTMARE: btnNightmare
	}

	for diff in buttons.keys():
		var btn = buttons[diff]
		if Global.difficulty == diff:
			btn.modulate = Color.WHITE
		else:
			btn.modulate = Color(0.6, 0.6, 0.6)
