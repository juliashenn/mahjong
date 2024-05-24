extends Node2D

@onready var playbutt = $PLAY
@onready var quitbutt = $QUIT
#300x271
func _on_quit_pressed():
	get_tree().quit()


func _on_play_pressed():
	get_tree().change_scene_to_file("res://world.tscn")

var screenWidth = 0
var screenHeight = 0
var lastViewWidth = screenWidth
var lastViewHeight = screenHeight
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(get_viewport_rect().size)
	var dim = get_viewport_rect().size
	if lastViewHeight != dim[1] and lastViewWidth != dim[0]:
		screenWidth = dim[0]
		screenHeight = dim[1]
		lastViewWidth = screenWidth
		lastViewHeight = screenHeight
		playbutt.position.x = screenWidth/2-400
		playbutt.position.y = screenHeight/2-135
		quitbutt.position.x = screenWidth/2+20
		quitbutt.position.y = screenHeight/2-135
func _ready():
	playbutt.position.x = screenWidth/2-400
	playbutt.position.y = screenHeight/2-135
	quitbutt.position.x = screenWidth/2+20
	quitbutt.position.y = screenHeight/2-135
