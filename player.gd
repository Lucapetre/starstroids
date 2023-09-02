extends Area2D

signal hit

@export var speed_limit = 400
@export var standard_acceleration = 200
@export var rotation_speed = 90 * (TAU / 180)

var velocity = Vector2.ZERO

var screen_size

var start_position

func start():
	
	position = start_position
	show()
	$CollisionPolygon2D.set_deferred("disabled",false)
	print($CollisionPolygon2D.disabled)

# Called when the node enters the scene tree for the first time.
func _ready():
	
	hide()
	screen_size = get_viewport_rect().size
	start_position = screen_size / 2
	

func movement(delta):
	# velocity vector input
	# forward is fastest
	if Input.is_action_pressed("accelerate"):
		velocity += Vector2.UP.rotated(rotation) * standard_acceleration * delta
	
	if Input.is_action_pressed("decelerate"):
		velocity += Vector2.DOWN.rotated(rotation) * standard_acceleration * delta / 1.5
	
	if Input.is_action_pressed("strafe_left"):
		velocity += Vector2.LEFT.rotated(rotation) * standard_acceleration * delta / 1.5
	
	if Input.is_action_pressed("strafe_right"):
		velocity += Vector2.RIGHT.rotated(rotation) * standard_acceleration * delta / 1.5
	
	velocity = velocity.normalized() * (max (velocity.length() - standard_acceleration * delta / 3, 0))
	
	if velocity.length() > speed_limit:
		velocity = velocity.normalized() * speed_limit
	
	# rotate left - right
	if Input.is_action_pressed("turn_left"):
		rotation -= rotation_speed * delta
	
	if Input.is_action_pressed("turn_right"):
		rotation += rotation_speed * delta
	
	# move the player
	position += velocity * delta

func wrap_if_out_of_screen(): # wrap around the screen
	
	var wrap_size = 115 * scale.x # distance from edge to wrap - x=y
	var wrap_delta = wrap_size - 5 # don't bring right at wrap_size so as to not create a loop
	
	if position.x < -wrap_size:
		position.x = screen_size.x + wrap_delta

	if position.y < -wrap_size:
		position.y = screen_size.y + wrap_delta

	if position.x > screen_size.x + wrap_size:
		position.x = -wrap_delta

	if position.y > screen_size.y + wrap_size:
		position.y = -wrap_delta

func _on_body_entered(body):
	print("eee")
	hide() # replace with health/damage system
	hit.emit()
	#$CollisionPolygon2D.set_deferred("disabled", true)
	
	body.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	movement(delta)
	wrap_if_out_of_screen()



