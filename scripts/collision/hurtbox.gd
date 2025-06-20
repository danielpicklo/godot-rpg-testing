class_name Hurtbox extends Area2D

@export var damage : int = 1

func _ready():
	area_entered.connect(AreaEntered)
	pass

func AreaEntered(a: Area2D) -> void:
	if a is Hitbox:
		a.TakeDamage(damage)
	pass
