extends CharacterBody2D
var speed = 2000
var player
var health = 3
var is_destroyed = false
func _on_area_2d_body_entered(body: Node2D) -> void:
	player=body
	
func _physics_process(delta: float) -> void:
	if player:
		velocity = ((player.position - position).normalized()) * speed * delta
		move_and_slide()


func _on_area_2d_body_exited(_body: Node2D) -> void:
	player=null


func _on_collision_area_body_entered(_body: Node2D) -> void:
	destroy_drone()

func is_hit():
	health-=1
	if health<=0:
		is_destroyed = true
		destroy_drone()
	var tween = create_tween()
	tween.tween_property($AnimatedSprite2D.material,"shader_parameter/Progress",0.0,0.2)
	tween.tween_property($AnimatedSprite2D.material,"shader_parameter/Progress",1.0,0.2)

func destroy_drone():
	$AudioStreamPlayer2D.playing = true
	$AnimatedSprite2D.hide()
	$ExplosionSprite.show()
	$AnimationPlayer.play("explode")
	await $AnimationPlayer.animation_finished
	queue_free()

func chain_reaction():
	for drone in get_tree().get_nodes_in_group("Drones"):
		if "position" in drone and position.distance_to(drone.position) < 200:
			if not drone.is_destroyed and drone.visible:
				drone.destroy_drone()
