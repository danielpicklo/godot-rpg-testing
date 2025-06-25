class_name Parrybox extends Area2D

signal Parry(hitbox: Hitbox)

func _ready():
	area_entered.connect(AreaEntered)
	pass

# If the area is entered and of type Hitbox
func AreaEntered(a: Area2D) -> void:
	if a is Hitbox:
		a.Stagger(a)
	pass

# Capture event from hurtbox and send out signal when we parry
func HandleParry(hitbox: Hitbox) -> void:
	Parry.emit(hitbox)
