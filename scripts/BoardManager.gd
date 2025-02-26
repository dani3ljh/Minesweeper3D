extends Node3D

@onready var cells = $"../Cells"
@onready var player = $"../Player"

@export var startPosition: Vector3
@export var gap: float
@export var width: int
@export var height: int
@export var minePercentage: float

var board: Array[Array]

func _find_mesh_instance(node: Node3D) -> MeshInstance3D:
	for child in node.get_children():
		if child is MeshInstance3D:
			return child
		# Recursively search in the child's children
		var result = _find_mesh_instance(child)
		if result:
			return result
	return null

# Called when the node enters the scene tree for the first time.
func _ready():
	var cellScene = load("res://scenes/cell.tscn")
	
	for y in range(0, height):
		board.append([])
		for x in range(0, width):
			var instance = cellScene.instantiate()
			cells.add_child(instance)
			var meshSize = _find_mesh_instance(instance).get_aabb().size
			
			instance.position = startPosition
			instance.position.x += (meshSize.x / 2 + gap) * x
			instance.position.z += (meshSize.z / 2 + gap) * y
			
			instance.x = x
			instance.y = y
			instance.boardManager = self
			instance.isMine = false
			
			board[y].append(instance)
	
	_set_mines()
	
	# _print_board()

func _get_free_indicies() -> Array[Vector2i]:
	var freeIndicies: Array[Vector2i]
	
	for y in range(0, height):
		for x in range(0, width):
			if not board[y][x].isMine:
				freeIndicies.append(Vector2i(x, y))
	
	return freeIndicies

func _set_mines():
	var count = width * height * minePercentage / 100
	
	for _i in range(0, count):
		var freeIndicies = _get_free_indicies()
		var index = randi() % freeIndicies.size()
		
		var pos = freeIndicies[index]
		board[pos.y][pos.x].isMine = true

func _print_board():
	for y in range(0, height):
		var out = "["
		for x in range(0, width):
			if board[y][x].isMine:
				out += "x, "
			else:
				out += str(_get_neighbors(x, y)) + ", "
		out += "],"
		print(out)

const OFFSET_INDICIES = [
	Vector2i(-1, -1), Vector2i(-1, 0), Vector2i(-1, 1),
	Vector2i(0, -1), Vector2i(0, 1),
	Vector2i(1, -1), Vector2i(1, 0), Vector2i(1, 1)]

func _get_neighbors(x: int, y: int) -> int:
	var count: int = 0
	
	for offset in OFFSET_INDICIES:
		var newY = y + offset.y
		if newY < 0 or newY >= height:
			continue
		
		var newX = x + offset.x
		if newX < 0 or newX >= width:
			continue
		
		if board[newY][newX].isMine:
			count += 1
	
	return count

func _clear_neighbors(x: int, y:int):
	for offset in OFFSET_INDICIES:
		var newY = y + offset.y
		if newY < 0 or newY >= height:
			continue
		
		var newX = x + offset.x
		if newX < 0 or newX >= width:
			continue
		
		board[newY][newX]._mine()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
