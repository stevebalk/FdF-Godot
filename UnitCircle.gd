extends Node2D

@export var circle_radius := 200.0
@export var points := 8
@export_range(0, 360, 1) var angle
@export var line_width := 4
@export var circle_color: Color
@export var cos_color: Color
@export var sin_color: Color
@export var arc_color: Color
@export var arc_length := 50


func _draw() -> void:
	_draw_unit_circle(points, circle_radius, circle_color)
	_draw_follow_line(circle_radius, line_width)
	_draw_filled_arc(arc_length, arc_color, 32)

func _process(delta: float) -> void:
	queue_redraw()

func _draw_unit_circle(_points: int, radius: int, _color: Color) -> void:
	var angle_rad = TAU / _points
	var point  : Vector2
	var next_point : Vector2
	if _points > 2:
		for i in _points - 1:
			point.x = cos(angle_rad * i) * radius
			point.y = sin(angle_rad * i) * radius
			next_point.x = cos(angle_rad * (i + 1)) * radius
			next_point.y = sin(angle_rad * (i + 1)) * radius
			draw_line(point, next_point, _color, 4)
		draw_line(next_point, Vector2(cos(0) * radius, sin(0) * radius), _color, 4)
	# Draw x and y line
	draw_line(Vector2(-250, 0), Vector2(250, 0), circle_color, line_width)
	draw_line(Vector2(0, -250), Vector2(0, 250), circle_color, line_width)

func _draw_follow_line(_radius: float, _line_width: float) -> void:
	var _mouse_pos = get_local_mouse_position().normalized() * _radius
	draw_line(Vector2(0, 0), _mouse_pos, Color.WHITE, 4)
	draw_line(Vector2.ZERO, Vector2(_mouse_pos.x, 0), Color.GREEN, _line_width)
	draw_line(Vector2.ZERO, Vector2(0, _mouse_pos.y), Color.RED, _line_width)
	draw_line(_mouse_pos, Vector2(_mouse_pos.x, 0), Color.RED, _line_width)
	draw_line(_mouse_pos, Vector2(0, _mouse_pos.y), Color.GREEN, _line_width)


func _draw_filled_arc(_radius: float, _color: Color, _resolution: int) -> void:
	var _points_arc : PackedVector2Array
	var _angle_degree := Vector2.ZERO.angle_to_point(get_local_mouse_position())
	if (_angle_degree < 0):
		_angle_degree += TAU
	var _angle_step := _angle_degree / _resolution
	_points_arc.push_back(Vector2.ZERO)
	
	for i in range(_resolution + 1):
		var point = Vector2(cos(i * _angle_step), sin(i * _angle_step))* _radius
		_points_arc.push_back(point)
	draw_polygon(_points_arc, [_color])
	
	
