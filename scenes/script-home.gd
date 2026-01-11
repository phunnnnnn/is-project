extends Node2D

@onready var button_play: Button = %ButtonPlay
@onready var button_play_easy: Button = %ButtonPlayEasy
@onready var button_play_normal: Button = %ButtonPlayNormal
@onready var button_play_hard: Button = %ButtonPlayHard
@onready var button_play_nightmare: Button = %ButtonPlayNightmare

const SCENE_MAIN = "res://scenes/scene-main.tscn"

func _ready():
	button_play.pressed.connect(_on_play_pressed.bind("play"))
	button_play_easy.pressed.connect(_on_play_pressed.bind("easy"))
	button_play_normal.pressed.connect(_on_play_pressed.bind("normal"))
	button_play_hard.pressed.connect(_on_play_pressed.bind("hard"))
	button_play_nightmare.pressed.connect(_on_play_pressed.bind("nightmare"))

func _on_play_pressed(diff_name: String):
	Globle.difficulty = diff_name
	get_tree().change_scene_to_file(SCENE_MAIN)
