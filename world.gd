extends Node2D

@onready var tilemap = $TileMap
const MAP_SIZE = Vector2(512, 512)

func _ready():
	generate_world()

func generate_world():
	var spawn = tilemap.local_to_map(Vector2(0, 0))
	
	var moisture = FastNoiseLite.new()
	var temperature = FastNoiseLite.new()
	var altitude = FastNoiseLite.new()
	
	var cliff_cells = []
	
	moisture.seed = -686559431 #randi()
	temperature.seed = -175673643 #randi()
	altitude.seed = 778520879 #randi()
	altitude.frequency = 0.001
	
	for x in MAP_SIZE.x:
		for y in MAP_SIZE.y:
			var coords = Vector2i(spawn.x - MAP_SIZE.x / 2 + x, spawn.y - MAP_SIZE.y / 2 + y)
			var moist = moisture.get_noise_2d(coords.x, coords.y) * 10
			var temp = temperature.get_noise_2d(coords.x, coords.y) * 10
			var alt = altitude.get_noise_2d(coords.x, coords.y) * 150
			
			var atlas_coords = Vector2(3 if alt < 2 else round((moist + 10) / 5), round((temp + 10) / 5))
			
			tilemap.set_cell(0, coords, 1, atlas_coords, 0)
			
			if atlas_coords.x != 3:
				cliff_cells.append(coords)
	
	tilemap.set_cells_terrain_connect(1, cliff_cells, 0, 0)
	
