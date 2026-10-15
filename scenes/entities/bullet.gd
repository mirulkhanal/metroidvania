extends Area2D
var direction:Vector2
var damage = 100
var speed = 500

func _ready() -> void:
	$AudioStreamPlayer2D.playing = true

func setup(pos,dir):
	position = pos + dir *16
	direction = dir

func animate():
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D,"scale",Vector2(1,1),0.5)

func _physics_process(delta: float) -> void:
	position+=direction*speed*delta
	animate()


func _on_body_entered(body: Node2D) -> void:
	if "is_hit" in body:
		body.is_hit()
	queue_free()
