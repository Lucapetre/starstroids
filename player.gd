extends Area2D

var speed_limit = 400
var velocity = 0
var rotation_vector

# Called when the node enters the scene tree for the first time.
func _ready():
	position.x = 640
	position.y = 360




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	rotation_vector = Vector2.UP.rotated(rotation)
	position += velocity * rotation_vector * delta
	
	
