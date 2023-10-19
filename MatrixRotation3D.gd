extends Node2D

var gridv3 : Array
var gridv2 : Array
@export var gridsize : Vector2
@export var angle : int
@export var color : Color
@export var zoom : float
@export var zoom_mod : int
@export var rotation_degree : float
var pivot : Vector2
var old_mouse_pos : Vector2
var x_rotate := 0.0
var y_rotate := 0.0
var z_rotate := 0.0

func _ready() -> void:
	pivot.x = (gridsize.x - 1) / 2
	pivot.y = (gridsize.y - 1) / 2
	print(pivot)
	_init_v3_grid(gridv3, gridsize, pivot)
	_init_v2_grid(gridv2, gridsize)
#	_fit_zoom_to_window(gridv3, gridsize)
	print(zoom)
	update_projection(gridv2, gridv3)

func _process(delta: float) -> void:
#	y_rotate = -deg_to_rad(5)
#	for i in gridsize.y:
#		for j in gridsize.x:
#			gridv3[i][j] = rotate_y(gridv3[i][j], y_rotate)
#	z_rotate = -deg_to_rad(rotation_degree)
#	for i in gridsize.y:
#		for j in gridsize.x:
#			gridv3[i][j] = rotate_z(gridv3[i][j], z_rotate)
#	x_rotate = -deg_to_rad(rotation_degree)
#	for i in gridsize.y:
#		for j in gridsize.x:
#			gridv3[i][j] = rotate_x(gridv3[i][j], x_rotate)
	update_projection(gridv2, gridv3)
	queue_redraw()

func _draw() -> void:
	_draw_grid(gridv2, gridsize, color)

func _fit_zoom_to_window(_points: Array, _grid_size: Vector2):
	var smallest_point := 0
	var highest_point := 0
	var _point := 0

	for i in _grid_size.y:
		for j in _grid_size.x:
			_point = _points[i][j].z
			if _point < smallest_point:
				smallest_point = _point
			elif _point > highest_point:
				highest_point = _point
	zoom = DisplayServer.window_get_size().y / (_grid_size.y + highest_point - smallest_point)

func _init_v3_grid(_grid: Array, _size: Vector2, _offset: Vector2) -> void:
	for i in _size.y:
		_grid.append([])
		for j in _size.x:
			_grid[i].append(Vector3(j - _offset.x, i - _offset.y, 0))
	gridv3[0][0] = gridv3[0][0] + Vector3(0, 0, 1)
	gridv3[4][4] = gridv3[4][4] + Vector3(0, 0, -8)
	gridv3[4][5] = gridv3[4][5] + Vector3(0, 0, -8)
	gridv3[5][4] = gridv3[5][4] + Vector3(0, 0, -8)
	gridv3[5][5] = gridv3[5][5] + Vector3(0, 0, -8)
	gridv3[9][9] = gridv3[9][9] + Vector3(0, 0, 1)
#	print(_grid)

func _init_v2_grid(_grid: Array, _size: Vector2) -> void:
	for i in _size.y:
		_grid.append([])
		for j in _size.x:
			_grid[i].append(Vector2.ZERO)
#	print(_grid)

func _draw_grid(_grid: Array, _size: Vector2, _color: Color) -> void:
	var row = 0
	var column = 0
	while row < _size.y:
		column = 0
		while column < _size.x:
			if (row != _size.y - 1):
				draw_line(_grid[row][column], _grid[row + 1][column], _color)
			if (column != _size.x - 1):
				draw_line(_grid[row][column], _grid[row][column + 1], _color)
			column += 1
#		draw_line(_grid[row][column], _grid[row + 1][column], _color)
		row += 1

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("rotate_up"):
		y_rotate = -deg_to_rad(rotation_degree)
		for i in gridsize.y:
			for j in gridsize.x:
				gridv3[i][j] = rotate_y(gridv3[i][j], y_rotate)
	if event.is_action("rotate_down"):
		y_rotate = deg_to_rad(rotation_degree)
		for i in gridsize.y:
			for j in gridsize.x:
				gridv3[i][j] = rotate_y(gridv3[i][j], y_rotate)
	if event.is_action("rotate_right"):
		z_rotate = -deg_to_rad(rotation_degree)
		for i in gridsize.y:
			for j in gridsize.x:
				gridv3[i][j] = rotate_z(gridv3[i][j], z_rotate)
	if event.is_action("rotate_left"):
		z_rotate = deg_to_rad(rotation_degree)
		for i in gridsize.y:
			for j in gridsize.x:
				gridv3[i][j] = rotate_z(gridv3[i][j], z_rotate)
	if event.is_action_pressed("plus"):
		zoom *= zoom_mod
		print(zoom)
	if event.is_action_pressed("minus"):
		if zoom / zoom_mod >= 10:
			zoom /= zoom_mod
	if event.is_action_pressed("reset"):
		reset()
	update_projection(gridv2, gridv3)
	queue_redraw()
#		print("PEWPEWPEW")
#	print(z_rotate)

	

#func _project_orthogonal(_dst_grid: Array, _src_grid: Array, _size: Vector2, _angle: int, _zoom):
#	for row in _size.y:
#		for column in _size.x:
#			_dst_grid[row][column].x = (_src_grid[row][column].x - _size.x / 2) * _zoom
#			_dst_grid[row][column].y = (_src_grid[row][column].y - _size.y / 2 + (-_src_grid[row][column].z)) * _zoom
#	for i in _size.y:
#		print(_dst_grid[i])

func _project_iso(_point: Vector3) -> Vector2:
	var ret_vector := Vector2.ZERO

	ret_vector.x = (_point.x - _point.y) * cos(0.523599);
	ret_vector.y = -_point.z + (_point.x + _point.y) * sin(0.523599);
	return (ret_vector)

func rotate_x(_point: Vector3, rad: float) -> Vector3:
	var _old_y := _point.y;
	var _new_vector : Vector3
	
	_new_vector.y = _old_y * cos(rad) + _point.z * sin(rad)
	_new_vector.z = -_old_y * sin(rad) + _point.z * cos(rad)
	_new_vector.x = _point.x
	return (_new_vector)

func rotate_y(_point: Vector3, rad: float) -> Vector3:
	var _old_x := _point.x;
	var _new_vector : Vector3
	
	_new_vector.x = _old_x * cos(rad) + _point.z * sin(rad)
	_new_vector.z = -_old_x * sin(rad) + _point.z * cos(rad)
	_new_vector.y = _point.y
	return (_new_vector)

func rotate_z(_point: Vector3, rad: float) -> Vector3:
	var _old_x := _point.x;
	var _old_y := _point.y
	var _new_vector : Vector3
	
	_new_vector.x = _old_x * cos(rad) - _old_y * sin(rad)
	_new_vector.y = _old_x * sin(rad) + _old_y * cos(rad)
	_new_vector.z = _point.z
	return (_new_vector)

func update_projection(_dst_grid: Array, _src_grid: Array) -> void:
	for i in gridsize.y:
		for j in gridsize.x:
			_dst_grid[i][j] = _project_iso(_src_grid[i][j]) * zoom
#	print(zoom)

func reset() -> void:
	print("OEWOEOWOEWO")
