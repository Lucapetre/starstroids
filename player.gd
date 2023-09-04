extends Area2D

signal hit
signal dead
signal health_changed

@export var speed_limit = 400
@export var standard_acceleration = 200
@export var rotation_speed = 90 * (TAU / 180)
@export var max_health = 2000

var health = 2000

var velocity = Vector2.ZERO

var screen_size

var start_position

func start():
	
	position = start_position
	show()
	health = 2000
	health_changed.emit()
	$CollisionPolygon2D.set_deferred("disabled",false)


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


func player_hit():
	
	health -= randi_range(50,150)
	if (health <= 0):
		hide()
		health = 0
		health_changed.emit()
		dead.emit()
		return
	
	health_changed.emit()
	
	hit.emit()
	$CollisionPolygon2D.set_deferred("disabled", true)
	hide()
	
	$InvulnerabilityTimer.start()
	$ShowTimer.start()


func _on_invulnerability_timer_timeout():
	
	$HideTimer.stop()
	$ShowTimer.stop()
	show()
	$CollisionPolygon2D.set_deferred("disabled",false)

func _on_show_timer_timeout():
	show()
	$HideTimer.start()

func _on_hide_timer_timeout():
	hide()
	$ShowTimer.start()

func _on_body_entered(body):
	
	player_hit()
	body.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	movement(delta)
	wrap_if_out_of_screen()

