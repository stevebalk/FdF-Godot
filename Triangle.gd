extends Node2D

@export var angle = 90
@export var length = 50
@export var rotation_speed = 90.0
@export var angle_to_draw_circle = 360
@onready var cos_text := $Cos
var end := Vector2()
var points : Array
var hit_end := false

func _ready() -> void:
	cos_text.position = Vector2(length, length)

func _draw() -> void:
	_draw_triangle()

func _process(delta: float) -> void:
#	position.x += 50 * delta
	var text = "Cos: %.2f\nSin: %.2f"
	text = text % [cos(deg_to_rad(angle)), sin(deg_to_rad(angle))]
	angle += rotation_speed * delta
	cos_text.text = text
#	rotation_speed += 10 * delta
#	length += 10 * delta
#	print(len(points))
	queue_redraw()


func _draw_triangle() -> void:
	if len(points) > 1:
		for i in len(points):
			if i < len(points) - 1:
				draw_line(points[i], points[i + 1], Color.WHITE)
	end.x = cos(deg_to_rad(angle)) * length
	end.y = sin(deg_to_rad(angle)) * length
#			print("Angle: " + str(rad_to_deg(end.angle_to_point(points[-1]))))
	if angle <= angle_to_draw_circle:
		points.append(end)
#	print("Cos: " + str(cos(deg_to_rad(angle))) + " " + "Sin: " + str(sin(deg_to_rad(angle))))
	draw_line(Vector2(0, 0), end, Color.WHITE)
	draw_line(Vector2(0, 0), Vector2(end.x, 0), Color.WHITE)
	draw_line(Vector2(end.x, 0), end, Color.WHITE)
	draw_circle(end, 5.0, Color.SKY_BLUE)

#func _draw_circle() -> void:
	
