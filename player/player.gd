extends CharacterBody2D

@export var player_camera: PackedScene
@export var camera_height = 130

@export var player_sprite: AnimatedSprite2D
@export var movement_speed = 300
@export var gravity = 30
@export var jump_strength = 600
@export var max_jumps = 1

@onready var initial_sprite_scale = player_sprite.scale

var jump_count = 0
var camera_instance

func _ready():
	set_up_camera()
	
func set_up_camera():
	camera_instance = player_camera.instantiate()
	camera_instance.global_position.y = camera_height
	get_tree().current_scene.add_child.call_deferred(camera_instance)
	
func _process(_delta):
	update_camera_pos()


func update_camera_pos():
		camera_instance.global_position.x = global_position.x

func face_movement_direction(horizontal_input):
	if not is_zero_approx(horizontal_input):
		if horizontal_input < 0:
			player_sprite.scale = Vector2(-initial_sprite_scale.x, initial_sprite_scale.y)
		else:
			player_sprite.scale = initial_sprite_scale
			
func handle_movement():
	var is_falling = velocity.y > 0.0 and not is_on_floor()
	var is_jumping = Input.is_action_just_pressed("jump") and is_on_floor()
	var is_double_jumping = Input.is_action_just_pressed("jump") and is_falling
	var is_jump_cancelled = Input.is_action_just_released("jump") and velocity.y < 0.0
	var is_idle = is_on_floor() and is_zero_approx(velocity.x)
	var is_walking = is_on_floor() and not is_zero_approx(velocity.x)
	
	
	if is_jumping:
		jump_count += 1
		velocity.y = -jump_strength
	elif is_double_jumping:
		jump_count += 1
		if jump_count <= max_jumps:
			velocity.y = -jump_strength
	elif is_jump_cancelled:
		velocity.y = 0.0
	elif is_on_floor():
		jump_count = 0
	
	if is_jumping:
		player_sprite.play("jump_start")
	elif is_double_jumping:
		player_sprite.play("double_jump_start")
	elif is_walking:
		player_sprite.play("walk")
	elif is_falling:
		player_sprite.play("fall")
	elif is_idle:
		player_sprite.play("idle")
	
	
func _physics_process(_delta):
	var horizontal_input = (Input.get_action_strength("move_right") 
	- Input.get_action_strength("move_left"))
	
	velocity.x = horizontal_input * movement_speed
	velocity.y += gravity
	
	
	
	move_and_slide()
	handle_movement()
	face_movement_direction(horizontal_input)


func _on_animated_sprite_2d_animation_finished():
	player_sprite.play("jump")
