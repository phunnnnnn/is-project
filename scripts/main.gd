extends Node2D

@onready var lable_question: Label = %lableQuestion
@onready var lable_output: Label = %lableOutput

@onready var button_1: Button = $Control/HBoxContainer/Button
@onready var button_2: Button = $Control/HBoxContainer/Button2
@onready var button_3: Button = $Control/HBoxContainer/Button3
@onready var button_4: Button = $Control/HBoxContainer/Button4
@onready var button_5: Button = $Control/HBoxContainer/Button5
@onready var button_6: Button = $Control/HBoxContainer/Button6
@onready var button_7: Button = $Control/HBoxContainer/Button7
@onready var button_8: Button = $Control/HBoxContainer/Button8
@onready var button_9: Button = $Control/HBoxContainer/Button9
@onready var button_10: Button = $Control/HBoxContainer/Button10 # 0
@onready var button_11: Button = $Control/HBoxContainer/Button11 # erase

@onready var button_submit: Button = $ButtonSubmit

var numberFirst : int
var numberSecond : int
var answer : int

var player_visual_answer : String = ""


func _ready() -> void:
	_generate_question()
	_connect_buttons()


func _connect_buttons() -> void:
	button_1.pressed.connect(func(): _on_number_pressed("1"))
	button_2.pressed.connect(func(): _on_number_pressed("2"))
	button_3.pressed.connect(func(): _on_number_pressed("3"))
	button_4.pressed.connect(func(): _on_number_pressed("4"))
	button_5.pressed.connect(func(): _on_number_pressed("5"))
	button_6.pressed.connect(func(): _on_number_pressed("6"))
	button_7.pressed.connect(func(): _on_number_pressed("7"))
	button_8.pressed.connect(func(): _on_number_pressed("8"))
	button_9.pressed.connect(func(): _on_number_pressed("9"))
	button_10.pressed.connect(func(): _on_number_pressed("0"))

	button_11.pressed.connect(_on_erase_pressed)
	button_submit.pressed.connect(_on_submit_pressed)


func _generate_question():
	player_visual_answer = ""
	lable_output.text = ""
	numberFirst = randi_range(1, 9)
	numberSecond = randi_range(1, 9)
	answer = numberFirst + numberSecond
	lable_question.text = "%d + %d = ?" % [numberFirst, numberSecond]


func _on_number_pressed(num: String) -> void:
	if player_visual_answer.length() < 2:
		player_visual_answer += num
		lable_output.text = player_visual_answer


func _on_erase_pressed() -> void:
	if player_visual_answer.length() > 0:
		player_visual_answer = player_visual_answer.substr(0, player_visual_answer.length() - 1)
		lable_output.text = player_visual_answer


func _on_submit_pressed() -> void:
	var player_int = int(player_visual_answer)
	if player_visual_answer == "":
		lable_output.text = "กรุณากรอกคำตอบ"
		return
	if player_int == answer:
		lable_output.text = "ถูกต้อง!"
		await get_tree().create_timer(0.5).timeout  # รอแป๊บให้เด็กเห็นผล
		_generate_question()  # สุ่มโจทย์ใหม่
	else:
		lable_output.text = "ผิด!"
		player_visual_answer = ""       # ลบคำตอบเก่า
		await get_tree().create_timer(0.5).timeout
		lable_output.text = ""          # ล้างข้อความผลลัพธ์
