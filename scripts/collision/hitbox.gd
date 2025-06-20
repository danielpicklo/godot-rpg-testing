class_name Hitbox extends Area2D

signal Damaged(damage: int)

func TakeDamage(damage: int) -> void:
	print(damage)
	Damaged.emit(damage)
