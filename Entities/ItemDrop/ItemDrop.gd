extends RigidBody3D

@export var item : ItemHolder

func _ready():
	if item:
		if item.item.itemName == null : queue_free() # empty shit
		$Sprite3D.texture = item.item.icon
	


func _on_detect_body_entered(body):
	if body is Player and item:
		set_collision_layer_value(1,false)
		set_collision_layer_value(3,false)
		if body.get_node("Inventory").add_item(item):
			var tween = create_tween().set_ease(Tween.EASE_OUT)
			tween.set_trans(Tween.TRANS_BACK)
			tween.tween_property(
				self, 
				"global_position", 
				Vector3(global_position.x,global_position.y + 0.5,global_position.z), 
				0.5)
			tween.tween_callback(queue_free)
