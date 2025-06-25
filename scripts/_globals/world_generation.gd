class_name World extends Node

@export var world_seed : int = 0

var dungeon = DungeonGenerator.new()

func _ready() -> void:
	dungeon.set_seed_from_string("CorruptionSeed01")
	dungeon.generate_dungeon()

	# Print grid to console for fun
	#for row in dungeon.grid:
		#print(row.map(func(cell): return "." if cell else "#"))
