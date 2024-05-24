extends Node
#69x106
#og 760x1000
@onready var base = $base
@onready var face = $face
@onready var button = $Button
var file
var player = 0 #0 is currPlayer/south, 1 is right, 2 is across, 3 is left
var tilenum
var oldfile
var played = 0 # 0 means hasn't been played, is still in hand (concealed unless player = 0)

#var backgroundWidth
#var backgroundHeight
#var backgroundScalex
#var backgroundScaley
#var oldScalex
#var oldScaley

var pastPlayed = 0
var pastPlayer

#var myPath = "res://tiles/"
#var rightPath = "res://righttiles/"
#var acrossPath = "res://acrosstiles/"
#var leftPath = "res://lefttiles/"

var filePaths:Array[String] = ["res://tilebase/frontTile.PNG", "res://tilebase/leftTile.PNG", "res://tilebase/acrossTile.PNG", "res://tilebase/rightTile.PNG"]
var fileBacks:Array[String] = ["res://graphics/rightback.PNG", "res://graphics/acrossback.PNG", "res://graphics/leftback.PNG"]

# Called when the node enters the scene tree for the first time.
func _ready():
	pastPlayer = player # Replace with function body.
	face.texture = load(file)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if oldfile != file or pastPlayed != played or pastPlayed != player:
		if played == 1:
			base.texture = load(filePaths[(player+2)%4])
			face.texture = load(file)
			face.visible = true
		elif player == 0:
			base.texture = load(filePaths[0])
			face.texture = load(file)
			face.visible = true
		else:
			base.texture = load(fileBacks[player-1])
			face.texture = load(file)
			face.visible = false
			if player == 0:
				face.visible = true
		oldfile = file
		pastPlayed = played

#func _on_button_pressed():
	#if player == 0 and played == 0:
		#played = 1
		#texture.texture = load(filePaths[2] + file)
		#self.scale.x = self.scale.x*.5
		#self.scale.y = self.scale.y*.4
		#self.position.x = (self.position.x - backgroundWidth/18)/oldScalex*backgroundScalex+backgroundWidth/18
		#self.position.y = backgroundHeight/5*3
		
var lastpos

func _on_mouse_entered():
	if player == 0 and played == 0:
		self.position.y -= 30
		lastpos = self.position.y

func _on_mouse_exited():
	if player == 0 and played == 0 and lastpos == self.position.y:
		self.position.y += 30
