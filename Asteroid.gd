extends RigidBody2D

@export var type = 0
# asteroid type: 0 - normal asteroid
#                1 - special flame asteroid

func set_new_scale (new_scale: Vector2):
	$CollisionShape2D.scale = new_scale
	$AnimatedSprite2D.scale = new_scale


# Called when the node enters the scene tree for the first time.
func _ready():
	
	var new_scale_length = randf_range(0.5, 1.25)
	set_new_scale(Vector2(new_scale_length, new_scale_length))
	
	if (randf() < 0.1): # 10% of asteroids should be special asteroids
		type = 1
	
	if (type == 1): # if special asteroid
		rotation = linear_velocity.angle() + PI/2
		$AnimatedSprite2D.play("FireAsteroid")
	
	
	if (type == 0): # if normal asteroid
		rotation = randf_range(0,TAU)
		var animations = $AnimatedSprite2D.sprite_frames.get_animation_names()
		$AnimatedSprite2D.play(animations[randi() % (animations.size() - 1)]) # just the normal ones
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
