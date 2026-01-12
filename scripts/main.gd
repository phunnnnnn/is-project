extends Node2D

# ==================================================
# UI REFERENCES
# ==================================================
@onready var labelQuestion: Label = %LableQuestion
@onready var labelAnswer: Label = %LableOutput
@onready var labelPoint: Label = %LablePoint

# Number buttons
@onready var btnNumbers := {
	"1": %ButtonOne,
	"2": %ButtonTwo,
	"3": %ButtonThree,
	"4": %ButtonFour,
	"5": %ButtonFive,
	"6": %ButtonSix,
	"7": %ButtonSeven,
	"8": %ButtonEight,
	"9": %ButtonNine,
	"0": %ButtonZero
}

@onready var btnErase: Button = %ButtonErase
@onready var btnSubmit: Button = $ButtonSubmit

# Visual grids
@onready var gridLeft: GridContainer = %GridFirst
@onready var gridRight: GridContainer = %GridSecond

@onready var btnBackToMenu: Button = %ButtonBackToMenu

# ==================================================
# CONSTANTS
# ==================================================
const SCENE_HOME := "res://scenes/menu.tscn"


# ==================================================
# GAME STATE VARIABLES
# ==================================================
var firstNumber: int
var secondNumber: int
var correctAnswer: int

var currentLevel: int = 1
var questionsToClear: int = 5
var correctCount: int = 0
var totalCorrect: int = 0

var playerAnswerText: String = ""

var lastFirstNumber: int = -1
var lastSecondNumber: int = -1

var questionsLimit: int = 10   # ผู้เล่นเลือกได้
var answeredCount: int = 0

var gameMode: Global.GameMode

# ==================================================
# LIFECYCLE
# ==================================================
func _ready() -> void:
	_connect_buttons()
	start_game(Global.game_mode, Global.question_limit)
	
	if Global.game_mode == Global.GameMode.ENDLESS:
		btnBackToMenu.visible = true
	else:
		btnBackToMenu.visible = false
	
	btnBackToMenu.pressed.connect(_on_back_button_pressed)
	
# ==================================================
# INITIAL SETUP
# ==================================================
func _reset_game_state() -> void:
	correctCount = 0
	totalCorrect = 0
	currentLevel = 1
	questionsToClear = 5

	_clear_grid(gridLeft)
	_clear_grid(gridRight)


func _connect_buttons() -> void:
	for num in btnNumbers.keys():
		btnNumbers[num].pressed.connect(func(): _on_number_pressed(num))

	btnErase.pressed.connect(_on_erase_pressed)
	btnSubmit.pressed.connect(_on_submit_pressed)


# ==================================================
# INPUT (KEYBOARD)
# ==================================================
func _input(event: InputEvent) -> void:
	if not event.is_pressed() or event.is_echo():
		return

	var keyMap := {
		"one": "1", "two": "2", "three": "3",
		"four": "4", "five": "5", "six": "6",
		"seven": "7", "eight": "8", "nine": "9",
		"zero": "0"
	}

	for action in keyMap.keys():
		if Input.is_action_just_pressed(action):
			_on_number_pressed(keyMap[action])
			return

	if Input.is_action_just_pressed("erase"):
		_on_erase_pressed()
	elif Input.is_action_just_pressed("confirm"):
		_on_submit_pressed()


# ==================================================
# GRID VISUAL HELPERS
# ==================================================
func _clear_grid(grid: GridContainer) -> void:
	for child in grid.get_children():
		child.queue_free()


func _fill_grid(grid: GridContainer, count: int) -> void:
	for i in range(count):
		var block := ColorRect.new()
		block.color = Color.WHITE
		block.custom_minimum_size = Vector2(40, 40)
		grid.add_child(block)


# ==================================================
# QUESTION GENERATION
# ==================================================
func _generate_question() -> void:
	playerAnswerText = ""
	labelAnswer.text = ""

	var a: int
	var b: int

	match Global.difficulty:
		Global.Difficulty.PLAY, Global.Difficulty.EASY:
			while true:
				a = randi_range(1, 9)
				b = randi_range(1, 9)
				if a + b < 10 and _is_new_question(a, b):
					break

		Global.Difficulty.NORMAL:
			while true:
				a = randi_range(10, 50)
				b = randi_range(1, 30)
				if (a % 10 + b % 10) < 10 and _is_new_question(a, b):
					break

		Global.Difficulty.HARD:
			while true:
				a = randi_range(10, 40)
				b = randi_range(1, 20)
				if (a % 10 + b % 10) >= 10 and (a + b) <= 50 and _is_new_question(a, b):
					break

		Global.Difficulty.NIGHTMARE:
			while true:
				a = randi_range(10, 90)
				b = randi_range(1, 30)
				if (a + b) <= 100 and (a % 10 + b % 10) < 20 and _is_new_question(a, b):
					break

		_:
			a = randi_range(1, 9)
			b = randi_range(1, 9)

	firstNumber = a
	secondNumber = b
	correctAnswer = a + b

	lastFirstNumber = a
	lastSecondNumber = b

	labelQuestion.text = "%d + %d = ?" % [a, b]

	_clear_grid(gridLeft)
	_clear_grid(gridRight)

	_fill_grid(gridLeft, a)
	_fill_grid(gridRight, b)


func _is_new_question(a: int, b: int) -> bool:
	return a != lastFirstNumber or b != lastSecondNumber


# ==================================================
# BUTTON ACTIONS
# ==================================================
func _on_number_pressed(num: String) -> void:
	if playerAnswerText.length() < 2:
		playerAnswerText += num
		labelAnswer.text = playerAnswerText


func _on_erase_pressed() -> void:
	if playerAnswerText.length() > 0:
		playerAnswerText = playerAnswerText.left(playerAnswerText.length() - 1)
		labelAnswer.text = playerAnswerText


func _on_submit_pressed() -> void:
	if playerAnswerText.is_empty():
		labelAnswer.text = "กรุณากรอกคำตอบ"
		return

	answeredCount += 1

	if int(playerAnswerText) == correctAnswer:
		_on_correct_answer()
	else:
		_on_wrong_answer()



# ==================================================
# ANSWER RESULT
# ==================================================
func _on_correct_answer() -> void:
	correctCount += 1
	totalCorrect += 1

	labelAnswer.text = "ถูกต้อง!"
	await get_tree().create_timer(0.4).timeout

	if gameMode == Global.GameMode.DEFAULT:
		if answeredCount >= questionsLimit:
			_finish_game()
			return

	_generate_question()
	_update_point_label()



func _on_wrong_answer() -> void:
	labelAnswer.text = "ผิด!"
	playerAnswerText = ""
	await get_tree().create_timer(0.4).timeout

	if gameMode == Global.GameMode.DEFAULT:
		if answeredCount >= questionsLimit:
			_finish_game()
			return

	labelAnswer.text = ""
	_generate_question()



# ==================================================
# GAME FLOW
# ==================================================
func _finish_game() -> void:
	labelQuestion.text = "จบเกม!"
	labelAnswer.text = "เก่งมาก 🎉"

	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file(SCENE_HOME)


func _update_point_label() -> void:
	if gameMode == Global.GameMode.ENDLESS:
		labelPoint.text = "คะแนน: %d" % totalCorrect
		return

	# DEFAULT MODE
	labelPoint.text = "%d / %d" % [answeredCount, questionsLimit]


func start_game(mode: Global.GameMode, limit: int = 10) -> void:
	gameMode = mode
	questionsLimit = limit

	answeredCount = 0
	correctCount = 0
	totalCorrect = 0

	_clear_grid(gridLeft)
	_clear_grid(gridRight)

	_generate_question()
	_update_point_label()
	
	

func _on_back_button_pressed():
	_reset_game_state()
	get_tree().change_scene_to_file("res://scenes/Menu.tscn")
