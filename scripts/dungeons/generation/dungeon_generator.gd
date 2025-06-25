class_name DungeonGenerator extends Node

# === DUNGEON CONFIG === 
const MAP_WIDTH : int = 200
const MAP_HEIGHT : int = 100
const MIN_ROOM_SIZE : int = 6
const MAX_ROOM_SIZE : int = 15
const MAX_LEAF_SIZE : int = 20
const MAX_DEPTH : int = 6

# === SEED SUPPORT ===
var custom_seed: int = 0
var rng: RandomNumberGenerator

# === OUTPUT ===
var grid : Array = []
var rooms : Array = []

# === BSP Leaf Class ===
class Leaf:
	var rect: Rect2i
	var left: Leaf
	var right: Leaf
	var room: Rect2i

	func _init(rect: Rect2i):
		self.rect = rect

	func split(rng: RandomNumberGenerator) -> bool:
		if left or right:
			return false

		var split_h = rng.randf() > 0.5
		if rect.size.x > rect.size.y and rect.size.x / rect.size.y >= 1.25:
			split_h = false
		elif rect.size.y > rect.size.x and rect.size.y / rect.size.x >= 1.25:
			split_h = true

		var max_size = (rect.size.y if split_h else rect.size.x) - MIN_ROOM_SIZE
		if max_size <= MIN_ROOM_SIZE:
			return false

		var split = rng.randi_range(MIN_ROOM_SIZE, max_size)
		if split_h:
			left = Leaf.new(Rect2i(rect.position, Vector2i(rect.size.x, split)))
			right = Leaf.new(Rect2i(rect.position + Vector2i(0, split), Vector2i(rect.size.x, rect.size.y - split)))
		else:
			left = Leaf.new(Rect2i(rect.position, Vector2i(split, rect.size.y)))
			right = Leaf.new(Rect2i(rect.position + Vector2i(split, 0), Vector2i(rect.size.x - split, rect.size.y)))

		return true

# === MAIN GENERATION ENTRY ===
func generate_dungeon():
	# Set up RNG
	rng = RandomNumberGenerator.new()
	rng.seed = custom_seed if custom_seed != 0 else randi()

	# Init grid
	grid = []
	for y in range(MAP_HEIGHT):
		grid.append([])
		for x in range(MAP_WIDTH):
			grid[y].append(false)

	rooms.clear()

	# BSP generation
	var root = Leaf.new(Rect2i(0, 0, MAP_WIDTH, MAP_HEIGHT))
	var leaves = [root]

	var did_split = true
	while did_split:
		did_split = false
		for leaf in leaves.duplicate():
			if not leaf.left and not leaf.right:
				if leaf.rect.size.x > MAX_LEAF_SIZE or leaf.rect.size.y > MAX_LEAF_SIZE or rng.randf() > 0.75:
					if leaf.split(rng):
						leaves.append(leaf.left)
						leaves.append(leaf.right)
						did_split = true

	# Carve rooms
	for leaf in leaves:
		if not leaf.left and not leaf.right:
			var w = rng.randi_range(MIN_ROOM_SIZE, min(MAX_ROOM_SIZE, leaf.rect.size.x - 1))
			var h = rng.randi_range(MIN_ROOM_SIZE, min(MAX_ROOM_SIZE, leaf.rect.size.y - 1))
			var x = rng.randi_range(leaf.rect.position.x + 1, leaf.rect.position.x + leaf.rect.size.x - w - 1)
			var y = rng.randi_range(leaf.rect.position.y + 1, leaf.rect.position.y + leaf.rect.size.y - h - 1)
			leaf.room = Rect2i(x, y, w, h)
			rooms.append(leaf.room)
			fill_room(leaf.room)

	# Connect rooms
	for i in range(rooms.size() - 1):
		var room_a = rooms[i]
		var room_b = rooms[i + 1]
		var point_a = room_a.position + room_a.size / 2
		var point_b = room_b.position + room_b.size / 2

		if rng.randf() > 0.5:
			fill_h_corridor(point_a.x, point_b.x, point_a.y)
			fill_v_corridor(point_a.y, point_b.y, point_b.x)
		else:
			fill_v_corridor(point_a.y, point_b.y, point_a.x)
			fill_h_corridor(point_a.x, point_b.x, point_b.y)

# === ROOM/CORRIDOR CARVING HELPERS ===
func fill_room(room: Rect2i):
	for y in range(room.position.y, room.position.y + room.size.y):
		for x in range(room.position.x, room.position.x + room.size.x):
			grid[y][x] = true

func fill_h_corridor(x1: int, x2: int, y: int):
	for x in range(min(x1, x2), max(x1, x2) + 1):
		grid[y][x] = true

func fill_v_corridor(y1: int, y2: int, x: int):
	for y in range(min(y1, y2), max(y1, y2) + 1):
		grid[y][x] = true

# === STRING TO SEED HELPER ===
func set_seed_from_string(seed_string: String):
	custom_seed = seed_string.hash()
