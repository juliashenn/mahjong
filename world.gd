extends Node2D
#1152x648 
#get_viewport_rect().size
@onready var startbutt = $Button
@onready var background = $TableAni
@onready var pengbutt = $peng
@onready var chibutt = $chi
@onready var gangbutt = $gang
@onready var hubutt = $hu
@onready var cancelbutt = $cancel
@onready var amount = 144
@onready var tile_ = preload("res://Tile.tscn")
var files:Array[String]
var filePaths:Array[String] = ["res://tiles/", "res://righttiles/", "res://acrosstiles/", "res://lefttiles/"]
#var rightPath = "res://righttiles/"
#var acrossPath = "res://acrosstiles/"
#var leftPath = "res://lefttiles/"
#var alpha = 0.00001 #constant to make sure scale is never zero

var indices:Array[int] # the shuffled indices to deal tiles 

var myHand:Array[Area2D] #tiles in hand (not visible to other players)
var myPlayed:Array[Area2D] #tiles played in center, aka discarded tiles
var myValid:Array[Area2D] #tiles in the corner, hua, peng, chi, or gang aka valid groups
var newTile

var rightHand:Array[Area2D]
var rightPlayed:Array[Area2D]
var rightValid:Array[Area2D]

var leftHand:Array[Area2D]
var leftPlayed:Array[Area2D]
var leftValid:Array[Area2D]

var acrossHand:Array[Area2D]
var acrossPlayed:Array[Area2D]
var acrossValid:Array[Area2D]

var createdTiles:Array[Area2D] # all tiles 

var buttArray:Array[TextureButton] # array w all possible buttons actions 

var startPlayer:int = 0 # determines who gets the 14th and starts first

#var currTile #the tile just played (will determine who can chi, peng, and hu)

var screenWidth = 1920 #2688 phone
var screenHeight = 1080 #1242 phone
var widthScale = 2*screenWidth/23790
var heightScale = 4*screenHeight/30000

# Called when the node enters the scene tree for the first time.
func _ready():
	list_files_in_directory()
	var dim = get_viewport_rect().size
	screenWidth = dim[0]
	screenHeight = dim[1]
	print(screenWidth)
	print(screenHeight)
	widthScale = 2*screenWidth/23790
	heightScale = 4*screenHeight/30000
	startbutt.position.x = screenWidth/2
	startbutt.position.y = screenHeight/2
	background.position.x = 0
	background.position.y = 0
	background.scale.x = screenWidth/2000
	background.scale.y = screenHeight/1120
	oldBackgroundScaley = background.scale.y
	
	background.play('hold')
#	pengbutt.visible = false
#	chibutt.visible = false
#	gangbutt.visible = false
#	hubutt.visible = false
	#print(str(screenWidth) + "," + str(screenHeight))
	# Replace with function body.

func randomize_indices():
	indices.clear()
	for i in range(len(files)):
		indices.append(i)
	indices.shuffle()

func getHand(player):
	var hands = [myHand, rightHand, acrossHand,leftHand]
	return hands[player]

func getPlayed(player):
	var played = [myPlayed, rightPlayed, acrossPlayed,leftPlayed]
	return played[player]
	
func getValid(player):
	var valids = [myValid, rightValid, acrossValid, leftValid]
	return valids[player]
	

func list_files_in_directory():
	for filePath in DirAccess.get_files_at("res://tiles/"): #regular tiles
		if filePath.get_extension() == "PNG":  
			files.append("res://tiles/" + filePath)
			files.append("res://tiles/" + filePath)
			files.append("res://tiles/" + filePath)
			files.append("res://tiles/" + filePath)
	for filePath in DirAccess.get_files_at("res://tiles/flower/"): #flower tiles
		if filePath.get_extension() == "PNG":  
			files.append(("res://tiles/flower/"+filePath))
#	print(files.size())
			
	
func dealTiles():
	randomize_indices()	
	for i in range(13):
		#print(indices[0])
		for p in range(4):
			while indices[0] >= 136:
				getValid(p).append(createTile(files[indices[0]], indices[0], p, 1))
				indices.remove_at(0)
			getHand(p).append(createTile(files[indices[0]], indices[0], p, 0))
			indices.remove_at(0)
	while indices[0] >= 136:
		getValid(startPlayer).append(createTile(files[indices[0]], indices[0], startPlayer, 1))
		indices.remove_at(0)
	getHand(startPlayer).append(createTile(files[indices[0]], indices[0], startPlayer, 0))
	indices.remove_at(0)
#		while indices[0] >= 136:
#			rightValid.append(createTile(files[indices[0]], indices[0], 1, 1))
#			indices.remove_at(0)
#		rightHand.append(createTile(files[indices[0]], indices[0], 1, 0))
#		indices.remove_at(0)
#		while indices[0] >= 136:
#			acrossValid.append(createTile(files[indices[0]], indices[0], 2, 1))
#			indices.remove_at(0)
#		acrossHand.append(createTile(files[indices[0]], indices[0], 2, 0))
#		indices.remove_at(0)
#		while indices[0] >= 136:
#			leftValid.append(createTile(files[indices[0]], indices[0], 3, 1))
#			indices.remove_at(0)
#		leftHand.append(createTile(files[indices[0]], indices[0], 3, 0))
#		indices.remove_at(0)
	sortTiles()
#	randomize_indices()
#	var myind:Array[int]
#	var leftind:Array[int]
#	var rightind:Array[int]
#	var acrossind:Array[int]
#	for i in range(13):
#		#print(indices[0])
#		while indices[0] >= 136:
#			myValid.append(createTile(files[indices[0]], indices[0], 0, 1))
#			indices.remove_at(0)
##			print(files[indices[0]])
#		myind.append(indices[0])
#		indices.remove_at(0)
#		while indices[0] >= 136:
#			rightValid.append(createTile(files[indices[0]], indices[0], 1, 1))
#			indices.remove_at(0)
#		rightind.append(indices[0])
#		indices.remove_at(0)
#		while indices[0] >= 136:
#			acrossValid.append(createTile(files[indices[0]], indices[0], 2, 1))
#			indices.remove_at(0)
#		acrossind.append(indices[0])
#		indices.remove_at(0)
#		while indices[0] >= 136:
#			leftValid.append(createTile(files[indices[0]], indices[0], 3, 1))
#			indices.remove_at(0)
#		leftind.append(indices[0])
#		indices.remove_at(0)
#	myind.sort()
#	leftind.sort()
#	rightind.sort()
#	acrossind.sort()
#	for i in range(len(myind)):
#		myHand.append(createTile(files[myind[i]], myind[i], 0, 0))
#	for i in range(len(rightind)):
#		rightHand.append(createTile(files[rightind[i]], rightind[i], 1, 0))
#	for i in range(len(acrossind)):
#		acrossHand.append(createTile(files[acrossind[i]], acrossind[i], 2, 0))
#	for i in range(len(leftind)):
#		leftHand.append(createTile(files[leftind[i]], leftind[i], 3, 0))

func createTile(f, tilen, p, played):
	var new_tile = tile_.instantiate()
	new_tile.file = f
	new_tile.tilenum = tilen
	new_tile.player = p
	new_tile.played = played
	return new_tile

func sortTiles(): #only sorts tiles in the hand
	for x in range(myHand.size()-1):
		for i in range(myHand.size()-1):
			if myHand[i].tilenum > myHand[i+1].tilenum:
				var temp = myHand[i]
				myHand[i] = myHand[i+1]
				myHand[i+1] = temp
				i = max(0, i-3)
		for i in range(leftHand.size()-1):
			if leftHand[i].tilenum > leftHand[i+1].tilenum:
				var temp = leftHand[i]
				leftHand[i] = leftHand[i+1]
				leftHand[i+1] = temp
				i = max(0, i-2)
		for i in range(rightHand.size()-1):
			if rightHand[i].tilenum > rightHand[i+1].tilenum:
				var temp = rightHand[i]
				rightHand[i] = rightHand[i+1]
				rightHand[i+1] = temp
				i = max(0, i-2)
		for i in range(acrossHand.size()-1):
			if acrossHand[i].tilenum > acrossHand[i+1].tilenum:
				var temp = acrossHand[i]
				acrossHand[i] = acrossHand[i+1]
				acrossHand[i+1] = temp
				i = max(0, i-2)

func showTiles():
#	sortTiles()
	for i in range(myHand.size()):
		var new_tile = myHand[i]
		new_tile.position.x = i*(610*widthScale) + screenWidth/18
		new_tile.position.y = screenHeight/5*3.9
		new_tile.scale.x = widthScale
		new_tile.scale.y = heightScale
		if new_tile.get_parent() != self:
			self.add_child(new_tile)
		createdTiles.append(new_tile)
#	newTile
	if is_instance_valid(newTile):
		newTile.position.x = (myHand.size() + 1)*(610*widthScale) + screenWidth/18
		newTile.position.y = screenHeight/5*3.9
		newTile.scale.x = widthScale
		newTile.scale.y = heightScale
		if newTile.get_parent() != self:
			self.add_child(newTile)
		createdTiles.append(newTile)
	for i in range(acrossHand.size()):
		var new_tile = acrossHand[i]
		new_tile.position.x = 4*screenWidth/5 - i*(610*widthScale/1.4) 
		new_tile.position.y = -700*widthScale/2
		new_tile.scale.x = widthScale/1.4
		new_tile.scale.y = heightScale/1.5
		#new_tile.rotation = deg_to_rad(180)
		if new_tile.get_parent() != self:
			self.add_child(new_tile)
		createdTiles.append(new_tile)
	for i in range(leftHand.size()):
		var new_tile = leftHand[i]
		new_tile.position.x = (11.3-i)*((610-450)*widthScale)
		new_tile.position.y = i*320*widthScale 
		new_tile.scale.x = widthScale
		new_tile.scale.y = heightScale
		new_tile.z_index = i
		#new_tile.rotation = deg_to_rad(90)
		if new_tile.get_parent() != self:
			self.add_child(new_tile)
		createdTiles.append(new_tile)
	for i in range(rightHand.size()):
		var new_tile = rightHand[i]
		new_tile.position.x = screenWidth - (i+3.5)*(610-450)*widthScale
		new_tile.position.y = (13-i)*320*widthScale + 30*background.scale.y
		new_tile.scale.x = widthScale
		new_tile.scale.y = heightScale
		new_tile.z_index = 13-i
		#new_tile.rotation = deg_to_rad(270)
		if new_tile.get_parent() != self:
			self.add_child(new_tile)
		createdTiles.append(new_tile)

func showPlayedTiles():
	var startw = 2.05*screenWidth/5
	var starth = 4.05*screenHeight/7
	for i in range(myPlayed.size()):
		myPlayed[i].scale.x = widthScale*0.58
		myPlayed[i].scale.y = heightScale*0.49
		myPlayed[i].position.x = (i%6)*(610*myPlayed[i].scale.x) + startw
		myPlayed[i].position.y = ((i/6)-1)*(800*myPlayed[i].scale.y) + starth
		myPlayed[i].z_index = i
	for i in range(rightPlayed.size()):
		rightPlayed[i].scale.x = widthScale*0.4
		rightPlayed[i].scale.y = heightScale*0.45
		rightPlayed[i].position.y = starth - 30 - (i%6)*(610*rightPlayed[i].scale.x)
		rightPlayed[i].position.x = (i/6)*(810*rightPlayed[i].scale.y) + (screenWidth-startw)/3.26 + startw - ((i%6)*70*widthScale)
		rightPlayed[i].z_index = rightPlayed.size()-i
		rightPlayed[i].rotation = deg_to_rad(270)
	for i in range(acrossPlayed.size()):
		acrossPlayed[i].scale.x = widthScale*0.41
		acrossPlayed[i].scale.y = heightScale*0.38
		acrossPlayed[i].position.x = (7.5 - i%6)*(610*acrossPlayed[i].scale.x) + startw
		acrossPlayed[i].position.y = starth - (i/6)*(800*acrossPlayed[i].scale.y) - 4*(screenHeight - starth)/7
		acrossPlayed[i].z_index = acrossPlayed.size()-i
		acrossPlayed[i].rotation = deg_to_rad(180)
	for i in range(leftPlayed.size()):
		leftPlayed[i].scale.x = widthScale*0.4
		leftPlayed[i].scale.y = heightScale*0.45
		leftPlayed[i].position.y = starth - 30 - (6 -(i%6))*(610*leftPlayed[i].scale.x)
		leftPlayed[i].position.x =  startw - (i/6)*(810*leftPlayed[i].scale.y) - 10 + ((6- i%6)*70*widthScale)
		leftPlayed[i].z_index = i
		leftPlayed[i].rotation = deg_to_rad(90)
		
func showValidTiles():
	for i in range(myValid.size()):
		myValid[i].scale.x = widthScale*0.63
		myValid[i].scale.y = heightScale*0.53
		myValid[i].position.x = (13-i)*(610*myValid[i].scale.x) + 9.7*screenWidth/18
		myValid[i].position.y = screenHeight/5*4.3
		myValid[i].rotation = 0
		myValid[i].player = 0
		if myValid[i].get_parent() != self:
			self.add_child(myValid[i])
		if not createdTiles.has(myValid[i]):
			createdTiles.append(myValid[i])
	for i in range(rightValid.size()):
		rightValid[i].scale.x = widthScale*0.4
		rightValid[i].scale.y = heightScale*0.45
		rightValid[i].position.y =  (i + 2.5)*(610*rightValid[i].scale.x)
		rightValid[i].position.x = (810*rightValid[i].scale.y) + 13*(screenWidth)/18 + (i*100*widthScale)
		rightValid[i].z_index = i
		rightValid[i].rotation = deg_to_rad(270)
		rightValid[i].player = 1
		if rightValid[i].get_parent() != self:
			self.add_child(rightValid[i])
		if not createdTiles.has(rightValid[i]):
			createdTiles.append(rightValid[i])
	for i in range(acrossValid.size()):
		acrossValid[i].scale.x = widthScale*0.41
		acrossValid[i].scale.y = heightScale*0.38
		acrossValid[i].position.x = 1.2*screenWidth/5 + (i)*(610*acrossValid[i].scale.x) 
		acrossValid[i].position.y = 1.5*(800*acrossValid[i].scale.y)
		acrossValid[i].z_index = acrossValid.size()-i
		acrossValid[i].rotation = deg_to_rad(180)
		acrossValid[i].player = 2
		if acrossValid[i].get_parent() != self:
			self.add_child(acrossValid[i])
		if not createdTiles.has(acrossValid[i]):
			createdTiles.append(acrossValid[i])
	for i in range(leftValid.size()):
		leftValid[i].scale.x = widthScale*0.4
		leftValid[i].scale.y = heightScale*0.45
		leftValid[i].position.y = 13.5*screenHeight/18 - (i)*(610*leftValid[i].scale.x)
		leftValid[i].position.x = (900*leftValid[i].scale.y) + ((i+1.8)*130*widthScale)
		leftValid[i].z_index = leftValid.size() - i
		leftValid[i].rotation = deg_to_rad(90)
		leftValid[i].player = 3
		if leftValid[i].get_parent() != self:
			self.add_child(leftValid[i])
		if not createdTiles.has(leftValid[i]):
			createdTiles.append(leftValid[i])

var lastViewWidth = screenWidth
var lastViewHeight = screenHeight
var oldwScale = widthScale
var oldhScale = heightScale
var oldBackgroundScaley = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var dim = get_viewport_rect().size
	if lastViewHeight != dim[1] or lastViewWidth != dim[0]:
		#print(get_viewport_rect().size)
		var change = dim[0]-lastViewWidth #neg if decreasing
		screenWidth = dim[0]
		screenHeight = dim[1]
		oldwScale = widthScale
		oldhScale = heightScale
		widthScale = 2*screenWidth/23790
		heightScale = 4*screenHeight/30000
		if 1.7 < screenWidth / screenHeight and  screenWidth / screenHeight < 2.2:
			background.scale.x = screenWidth/2000
			background.scale.y = screenHeight/1120
#			resizeTiles()
			showPlayedTiles()
			showTiles()
		lastViewWidth = screenWidth
		lastViewHeight = screenHeight
		oldBackgroundScaley = background.scale.y
	if currPlayer != int(String(background.animation)):
		var arr:Array[String] = ['0', '1','2','3']
		background.animation = arr[currPlayer]
#		giveTile(currPlayer)
#	if currPlayer != 0 and buttArray.is_empty():
#		var arr= [myHand, rightHand, acrossHand,leftHand]
#		bot(arr[currPlayer], currPlayer)
#		await get_tree().create_timer(3).timeout

func turn():
	var arr:Array[String] = ['0', '1','2','3']
	background.animation = arr[currPlayer]
	giveTile(currPlayer)

func resizeTiles(): #needs work
	if is_instance_valid(startbutt):
		startbutt.position.x = screenWidth/2
		startbutt.position.y = screenHeight/2
	for tile in createdTiles:
		if tile.player == 0:
			tile.position.x = (tile.position.x - lastViewWidth/18)/oldwScale*widthScale+screenWidth/18
			tile.position.y = tile.position.y/lastViewHeight*screenHeight
			tile.scale.x = widthScale
			tile.scale.y = heightScale
		elif tile.player == 1:
			tile.position.x = (tile.position.x - lastViewWidth)/oldwScale*widthScale+screenWidth
			tile.position.y = (tile.position.y-4*lastViewHeight/5)/oldhScale*heightScale + 4*screenHeight/5
			tile.scale.x = widthScale
			tile.scale.y = heightScale
		elif tile.player == 2:
			tile.position.x = (tile.position.x - 4*lastViewWidth/5)/oldwScale*widthScale + 4*screenWidth/5
			tile.position.y = tile.position.y/oldhScale*heightScale
			tile.scale.x = widthScale/1.4
			tile.scale.y = heightScale/1.5
		elif tile.player == 3:
			tile.position.x = tile.position.x/oldwScale*widthScale
			tile.position.y = (tile.position.y-30*oldBackgroundScaley)/oldhScale*heightScale + 30*background.scale.y
			tile.scale.x = widthScale
			tile.scale.y = heightScale

func _on_button_pressed(): #shuffle button
	clearTiles()
	dealTiles()
	sortTiles()
	showTiles()
	showValidTiles()
	start()
	#startbutt.queue_free()

func start():
	var button_parent = self # path to parent node
	for t in createdTiles:
		t.button.pressed.connect(_on_Tile_pressed.bind(t))
	background.play('0')


var currtile
var currPlayer:int = 0
func _on_Tile_pressed(tile):
	if tile.player == 0 and tile.played == 0 and validGame:
		if tile == newTile:
			myPlayed.append(tile)
			newTile = null
		elif tile.player == 0:
			myHand.erase(tile)
			myPlayed.append(tile)
			if is_instance_valid(newTile):
				myHand.append(newTile)
				newTile = null
			sortTiles()
		tile.played = 1
		currtile = tile
		currPlayer = (tile.player + 1)%4
#		giveTile(0)
		showPlayedTiles()
		showTiles()
#		showValidTiles() #can delete later
		showButtons(tile)
	#print ("Button " + str(tile.tilenum) + " was pressed.")
	if currPlayer != 0 and buttArray.is_empty():
		bot(getHand(currPlayer), currPlayer)

func playTile(tile, player):
	if tile.played == 0:
		getHand(player).erase(tile)
		getPlayed(player).append(tile)
		tile.played = 1
		currtile = tile
		showPlayedTiles()
		showTiles()
#		showValidTiles() #can delete later
		showButtons(tile)
	if currPlayer != 0 and buttArray.is_empty():
		currPlayer = (tile.player + 1)%4
		if currPlayer != 0:
			bot(getHand(currPlayer), currPlayer)
		else:
			giveTile(0)

func giveTile(player):
	if indices.is_empty():
		gameHuang()
	else:
		while indices[0] >= 136 : 
			var tile = createTile(files[indices[0]], indices[0], player, 0)
			getValid(player).insert(0, tile)
			indices.remove_at(0)
		var tile = createTile(files[indices[0]], indices[0], player, 0)
		if player == 0:
			newTile = tile
		else:
			getHand(player).append(tile)
		indices.remove_at(0)
		showTiles()
		tile.button.pressed.connect(_on_Tile_pressed.bind(tile))


func checkPeng(tile, player):
	if tile.player != player:
		var count = 0
		for i in range(4):
			if hasTile(getHand(player), tile.tilenum - tile.tilenum%4 + i):
				count += 1
		return count >= 2

func checkGang(tile, player): #need to add when youve penged and get that tile
	if tile.player != player:
		var count = 0
		for i in range(4):
			if hasTile(getHand(player), tile.tilenum - tile.tilenum%4 + i):
				count += 1
#		if player == 0 and count >= 3:
#			if not buttArray.has(gangbutt):
#				buttArray.append(gangbutt)
##				print("gangbutt added")
#				return true
#		else:
		return count >= 3

func checkChi(tile, player):
	if (tile.player + 1)%4  == player:
		var before = false
		var after = false
		var nextnext = false
		var prevprev = false
		for i in range(myHand.size()):
			if tile.tilenum/36 == getHand(player)[i].tilenum/36 and tile.tilenum < 108:
				if (getHand(player)[i].tilenum )/ 4 == (tile.tilenum )/4 - 1:
					before = true
				if (getHand(player)[i].tilenum)/ 4 == (tile.tilenum )/4 + 1:
					after = true
				if (getHand(player)[i].tilenum )/ 4 == (tile.tilenum )/4 - 2:
					prevprev = true
				if (getHand(player)[i].tilenum)/ 4 == (tile.tilenum )/4 + 2:
					nextnext = true
			if (before and after) or (prevprev and before) or (after and nextnext):
#				buttArray.append(chibutt)
#				break
				return true

func hasTile(array, tilenum):
	for i in range(array.size()):
		if is_instance_valid(array[i]):
			if array[i].tilenum == tilenum:
				return true
	return false
	
	
func showButtons(tile):
	clearButtons()
	for i in range(myHand.size()):
		if checkGang(myHand[i], 0):
			buttArray.append(gangbutt)
	if is_instance_valid(tile):
		if checkPeng(tile, 0):
			buttArray.append(pengbutt)
		if checkChi(tile, 0):
			buttArray.append(chibutt)
		for i in range(buttArray.size()):
			buttArray[i].visible = true
			buttArray[i].position.x = 2.3*screenWidth/3 + i*1000*widthScale
			buttArray[i].position.y = 1.9*screenHeight/3
			buttArray[i].scale.x = widthScale
			buttArray[i].scale.y = widthScale
		if not buttArray.is_empty():
			cancelbutt.visible = true
			cancelbutt.position.x = 2.3*screenWidth/3 + (buttArray.size()-.1)*1000*widthScale
			cancelbutt.position.y = 1.9*screenHeight/3 + (986/2)*widthScale
			cancelbutt.scale.x = widthScale*.8
			cancelbutt.scale.y = widthScale*.8
			buttArray.append(cancelbutt)

func clearButtons():
	for i in range(buttArray.size()):
		buttArray[i].visible = false
	buttArray.clear()

func clearTiles():
	myHand.clear()
	myPlayed.clear()
	myValid.clear()
	rightHand.clear()
	rightPlayed.clear()
	rightValid.clear()
	acrossHand.clear()
	acrossPlayed.clear()
	acrossValid.clear()
	leftHand.clear()
	leftPlayed.clear()
	leftValid.clear()
	currtile = null
	
	for tile in createdTiles:
		if is_instance_valid(tile):
			tile.queue_free()
	createdTiles.clear()


func _on_peng_pressed():
	var count = 2
#	var played:Array[Array] = [myPlayed, rightPlayed, acrossPlayed, leftPlayed]
#	played[currtile.player].erase(currtile)
	if currPlayer == 1:
		rightPlayed.erase(currtile)
	elif currPlayer == 2:
		acrossPlayed.erase(currtile)
	else:
		leftPlayed.erase(currtile)
	myValid.append(currtile)
	for i in range(myHand.size()-1, -1, -1):
		if myHand[i].tilenum - myHand[i].tilenum%4 == currtile.tilenum - currtile.tilenum%4:
			count -= 1
			myHand[i].played = 1
			myValid.append(myHand[i])
			myHand.erase(myHand[i])
		if count == 0:
			break
	showTiles()
	showPlayedTiles()
	showValidTiles()
	clearButtons()
	currPlayer = 0
	
func npcPeng(player):
	var count = 2
	var played = [myPlayed, rightPlayed, acrossPlayed, leftPlayed]
	played[currtile.player].erase(currtile)
	if currPlayer == 1:
		rightPlayed.erase(currtile)
	elif currPlayer == 2:
		acrossPlayed.erase(currtile)
	else:
		leftPlayed.erase(currtile)
	myValid.append(currtile)
	for i in range(myHand.size()-1, -1, -1):
		for x in range(4):
			if myHand[i].tilenum == currtile.tilenum - currtile.tilenum%4 + x and count != 0:
				count -= 1
				myHand[i].played = 1
				myValid.append(myHand[i])
				myHand.erase(myHand[i])
				x = 4
	showTiles()
	showPlayedTiles()
	showValidTiles()
	pengbutt.visible = false


func _on_chi_pressed():
	if currPlayer == 1:
		rightPlayed.erase(currtile)
	elif currPlayer == 2:
		acrossPlayed.erase(currtile)
	else:
		leftPlayed.erase(currtile)
	myValid.append(currtile)
	for i in range(myHand.size()):
		var before = false
		var after = false
		var nextnext = false
		var prevprev = false
		if currtile.tilenum/36 == myHand[i].tilenum/36 and currtile.tilenum < 108:
			if (myHand[i].tilenum )/ 4 == (currtile.tilenum )/4 - 1:
				before = true
			if (myHand[i].tilenum)/ 4 == (currtile.tilenum )/4 + 1:
				after = true
			if (myHand[i].tilenum )/ 4 == (currtile.tilenum )/4 - 2:
				prevprev = true
			if (myHand[i].tilenum)/ 4 == (currtile.tilenum )/4 + 2:
				nextnext = true
		if (before and after) or (prevprev and before) or (after and nextnext):
#				buttArray.append(chibutt)
#				break
				var button = TextureButton.new()
				if button.get_parent() != self:
					self.add_child(button)
#			myHand[i].played = 1
#			myValid.append(myHand[i])
#			myHand.erase(myHand[i])
	showTiles()
	showPlayedTiles()
	showValidTiles()
	clearButtons()
	currPlayer = 0
# create three arrays, if size == 2, then its valid
# show valid arrays (cant just change pos, need to create new objects, where the pair can be pressed
# the pair pressed gets sent to valid (sort the three)

func _on_gang_pressed():
	pass # Replace with function body.


func _on_hu_pressed():
	pass # Replace with function body.
	
func bot(hand, player):
	var chosen = randi()%hand.size()
	giveTile(player)
	await get_tree().create_timer(3).timeout
	if validGame:
		playTile(hand[chosen], player)
#	played[player].append(hand[chosen])
#	currtile = hand[chosen]
#	hand.erase(hand[chosen])
	#add if can peng, peng, if can chi, chi, if can hu, hu
	
#make a counter for turns, for the other players just use the above bot to choose for now
#gotta make a point checker to allow hu button
#gotta make the highlighter so it you want to chi and have multiple options, you can select


func _on_cancel_pressed():
	clearButtons()
	currPlayer = (currPlayer + 1)%4
	if currPlayer != 0:
		bot(getHand(currPlayer), currPlayer)
	else:
		giveTile(0)

var validGame:bool = true # so the loop stops running once tiles run out
var huang:bool = false
func gameHuang(): # show message of no one won, the next game will be worth double!
	validGame = false
