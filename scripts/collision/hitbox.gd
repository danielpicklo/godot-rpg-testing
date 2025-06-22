class_name Hitbox extends Area2D

signal Damaged(hurtbox: Hurtbox)

func TakeDamage(hurtbox: Hurtbox) -> void:
	Damaged.emit(hurtbox)
