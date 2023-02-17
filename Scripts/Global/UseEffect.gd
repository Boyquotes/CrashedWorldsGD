extends Node

func use(itemEffect : ItemEffect):
	
	match itemEffect:
		ItemEffect.types.DAMAGE:
			return itemEffect.amount

