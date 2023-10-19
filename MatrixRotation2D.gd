extends Node2D

var grid := []
var grid_modified := []

@export var	grid_width = 	50
@export var	grid_height = 	50
@export var	zoom = 50
@export var zoom_multiplier = 1.5
@export var rotation_speed = 360 # Degrees per second
@export var z_angle = 45
var	pos := Vector2i(0,0)
var angle := 0.0
var pivot := Vector2i(0, 0)

func _ready() -> void:
	pivot = Vector2i((grid_width - 1) / 2, (grid_height - 1) / 2) * -1
	for i in grid_width:
		grid.append([])
		grid_modified.append([])
		for j in grid_height:
			grid[i].append(Vector2i(i, j) + pivot)
			grid_modified[i].append(Vector2i(0, 0))
	grid[0][0].y -= 2



func _draw() -> void:
	draw_grid(grid_modified, pos)


func _process(delta: float) -> void:
	angle += rotation_speed * delta
	matrix_rotate(grid, grid_modified, angle, z_angle)
	queue_redraw()

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("ui_zoom_in")):
		zoom *= zoom_multiplier
	elif (event.is_action_pressed("ui_zoom_out")):
		if zoom > 1:
			zoom /= zoom_multiplier

func draw_grid(_grid: Array, _pos: Vector2i) -> void:
	for i in len(_grid):
		draw_line(_grid[i][0] + _pos, _grid[i][-1] + _pos, Color.WHITE)
	for i in len(_grid[0]):
		draw_line(_grid[0][i] + _pos, _grid[-1][i] + _pos, Color.WHITE)
#	for row in range(len(_grid)):
#		for column in range(len(_grid[row])):
#			if row != 0:
#				draw_line(_grid[row][column] + _pos, _grid[row - 1][column] + _pos, Color.WHITE)
#			if column != 0:
#				draw_line(_grid[row][column] + _pos, _grid[row][column - 1] + _pos, Color.WHITE)


#	[x'] [cos0 -sin0] [x]
#	[y'] [sin0  cos0] [y]

func matrix_rotate(_grid_src: Array, _grid_dst: Array, _angle: int, _z_angle: float) -> void:
	var rad	:= deg_to_rad(_angle)
	var z_rad := deg_to_rad(_z_angle)
	var rows := len(_grid_src)
	var columns :=  len(_grid_src[0])
	var _cos = cos(rad)
	var _sin = sin(rad)

	for i in rows:
		for j in columns:
			_grid_dst[i][j].x = (_grid_src[i][j].x * _cos - _grid_src[i][j].y * _sin) * zoom
			_grid_dst[i][j].y = ((_grid_src[i][j].x * _sin + _grid_src[i][j].y * _cos) * z_rad) * zoom


# CODE FOR 2D ROTATION MATRIX

#	for i in rows:
#		for j in columns:
#			old_x = _grid_src[i][j].x
#			old_y = _grid_src[i][j].y
#			new_x = old_x * cos(rad) - old_y * sin(rad)
#			new_y = old_x * sin(rad) + old_y * cos(rad)
#			_grid_dst[i][j].x = new_x
#			_grid_dst[i][j].y = new_y
#		print(grid[row])
