class_name Plant extends Node2D

func _ready():
	$Hitbox.Damaged.connect(TakeDamage)
	pass

func TakeDamage(_hurtbox: Hurtbox) -> void:
	queue_free()
