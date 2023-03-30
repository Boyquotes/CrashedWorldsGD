extends Area3D
class_name PhysicBubble

func enable_node(node : Node) -> void:
	node.set_process(true)
	node.set_physics_process(true)
	if node is CharacterBody3D : node._show()

func disable_node(node : Node) -> void:
	node.set_process(false)
	node.set_physics_process(false)
	if node is CharacterBody3D : node._hide()

func _on_body_entered(body):
	enable_node(body)

func _on_body_exited(body):
	disable_node(body)
