class_name Parrybox extends Area2D

signal Parry(hitbox: Hitbox)

func _ready():
	area_entered.connect(AreaEntered)
	pass

func AreaEntered(a: Area2D) -> void:
	if a is Hitbox:
		a.Stagger(a)
	pass

func HandleParry(hitbox: Hitbox) -> void:
	Parry.emit(hitbox)
