extends Node2D

var bulletScene:= preload("res://scenes/entities/bullet.tscn")

func _on_player_shoot(pos: Vector2, dir: Vector2) -> void:
	var bullet:=bulletScene.instantiate()
	bullet.setup(pos,dir)
	$Bullets.add_child(bullet)
