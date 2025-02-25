extends Node3D

const MINED_CELL_MATERIAL = preload("res://materials/minedCell.tres")

@onready var flag = $flag
@onready var mesh = $dirt_4k/Plane
@onready var label = $Label3D
@onready var audio_stream_player_3d = $AudioStreamPlayer3D

@export var isMine = false
@export var isFlagged = false

var boardManager
var x: int
var y: int
var hasBeenMined = false

func _ready():
	flag.visible = false
	label.visible = false

func _mine():
	if isFlagged or hasBeenMined:
		return
	
	if isMine:
		audio_stream_player_3d.play()
		boardManager.player.isPlaying = false
	else:
		hasBeenMined = true
		
		var neighbors = boardManager._get_neighbors(x, y)
		if neighbors == 0:
			boardManager._clear_neighbors(x, y)
		
		label.text = str(neighbors)
		label.visible = true
		
		mesh.set_surface_override_material(0, MINED_CELL_MATERIAL)

func _toggle_flag():
	if hasBeenMined:
		return
	
	isFlagged = not isFlagged
	if isFlagged:
		flag.visible = true
	else:
		flag.visible = false

func _on_area_entered(area):
	if area.is_in_group("miner"):
		_mine()
		return
	
	if area.is_in_group("flagger"):
		_toggle_flag()
		return
