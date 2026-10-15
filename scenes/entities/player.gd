extends CharacterBody2D

@export var SPEED = 50
@export var gravity :=10
@export var jump_height := 10

signal shoot(position: Vector2, direction:Vector2)
var direction_x :float

const gun_direction = {
	Vector2i(1,0):0,
	Vector2i(1,1):1,
	Vector2i(0,1):2,
	Vector2i(-1,1):3,
	Vector2i(-1,0):4,
	Vector2i(-1,-1):5,
	Vector2i(0,-1):6,
	Vector2i(1,-1):7
}

func get_input():
	direction_x = Input.get_axis("left","right")
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_height
	if Input.is_action_just_pressed("shoot") and $Timer.time_left==0:
		shoot.emit(position, get_local_mouse_position().normalized())
		$Timer.start()
		var tween = get_tree().create_tween()
		tween.tween_property($Crosshair,"scale",Vector2(0.1,0.1),0.2)
		tween.tween_property($Crosshair,"scale",Vector2(0.2,0.2),0.2)

func apply_gravity(delta):
	velocity.y += gravity * delta

func update_crosshair():
	$Crosshair.position = get_local_mouse_position().normalized() *40
func animate():
	$Legs.flip_h = direction_x <0
	if is_on_floor():
		$AnimationPlayer.current_animation = "run" if direction_x  else "idle"
	else:
		$AnimationPlayer.current_animation = "jump"
	
	var mouse_pos = get_local_mouse_position().normalized()
	var rounded_pos = Vector2i(round(mouse_pos.x),round(mouse_pos.y))
	$Torso.frame = gun_direction[rounded_pos]

#func animate_torso():
	#var current_frame = 0
	#var mouse_angle := get_local_mouse_position().angle()
	#print (mouse_angle)
	#if  mouse_angle > 0.2:
		#current_frame = 1
	#if  mouse_angle > 1.1:
		#current_frame = 2
	#if  mouse_angle > 2.2:
		#current_frame = 3
	#if  mouse_angle > 3:
		#current_frame = 4
	#if mouse_angle <0.0:
		#current_frame = 7
	#if mouse_angle < -1.4:
		#current_frame = 6
	#if mouse_angle < -2.3:
		#current_frame = 5
	#$Torso.frame = current_frame
	
func _physics_process(delta: float) -> void:
	get_input()
	velocity.x = direction_x * SPEED
	apply_gravity(delta)
	move_and_slide()
	animate()
	update_crosshair()
	#animate_torso()
