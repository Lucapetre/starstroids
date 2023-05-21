extends Area2D

@export var speed_limit = 400
@export var standard_acceleration = 200
@export var rotation_speed = 90 * (TAU / 180)

var velocity = Vector2.ZERO

var screen_size



# Called when the node enters the scene tree for the first time.
func _ready():
	
	screen_size = get_viewport_rect().size

	position.x = screen_size.x / 2
	position.y = screen_size.y / 2
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# velocity vector input
	if Input.is_action_pressed("accelerate"):
		velocity += Vector2.UP.rotated(rotation) * standard_acceleration * delta
	
	if Input.is_action_pressed("decelerate"):
		velocity += Vector2.DOWN.rotated(rotation) * standard_acceleration * delta
	
	# strafing is nerfed so as to not negate acceleration and decelaration
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
	

	# wrap around the screen
	
	if position.x < -75:
		position.x = screen_size.x + 50
	
	if position.y < -75:
		position.y = screen_size.y + 50
	
	if position.x > screen_size.x + 75:
		position.x = -50
	
	if position.y > screen_size.y + 75:
		position.y = -50
	
