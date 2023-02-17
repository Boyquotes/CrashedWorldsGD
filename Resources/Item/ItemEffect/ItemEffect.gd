extends Resource
class_name ItemEffect

enum types {
	DAMAGE,
	HEAL,
	SPEEDBOST,
	JUMPBOOST,
	DIG
}

@export var type : types
@export var amount : float = 0.0

func _init(typeEffect : types = types.HEAL, amountEffect : float = 0.0):
	type = typeEffect
	amount = amountEffect
