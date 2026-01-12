extends Node

enum GameMode {
	DEFAULT,
	ENDLESS
}

enum Difficulty {
	PLAY,
	EASY,
	NORMAL,
	HARD,
	NIGHTMARE
}

var game_mode: GameMode = GameMode.DEFAULT
var question_limit: int = 10

var difficulty: Difficulty = Difficulty.PLAY
