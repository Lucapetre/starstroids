extends RigidBody2D

@export var type = 0
# asteroid type: 0 - normal asteroid
#                1 - special flame asteroid

# Called when the node enters the scene tree for the first time.
func _ready():
	scale *= randfn(1, 0.5)
	
	if (randf() < 0.1): # 10% of asteroids should be special asteroids
		type = 1
	
	if (type == 1): # if special asteroid
		rotation = 0
		$AnimatedSprite2D.play("FireAsteroid")
	
	
	if (type == 0): # if normal asteroid
		rotation = randf_range(0,TAU) # might not be needed
		var normal_animations = $AnimatedSprite2D.sprite_frames.get_animation_names()
		$AnimatedSprite2D.play(normal_animations[randi() % (normal_animations.size() - 1)])
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
