class_name Hitbox extends Area2D

signal Damaged(hurtbox: Hurtbox)
signal Staggered(hitbox: Hitbox)

# Capture stagger event from Parrybox and emit Staggered Signal; captured by Player or Enemy
func Stagger(hitbox: Hitbox) -> void:
	Staggered.emit(hitbox)

func TakeDamage(hurtbox: Hurtbox) -> void:
	Damaged.emit(hurtbox)
