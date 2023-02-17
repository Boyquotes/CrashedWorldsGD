extends Node

signal destroyGrid

func useItemType(type : String, cam = null):
	match type :
		"Dig" :dig(cam)

func dig(cam):
	var mousePosition = get_viewport().get_mouse_position()
	var rayOrigin = cam.project_ray_origin(mousePosition)
	var rayEnd = rayOrigin + cam.project_ray_normal(mousePosition) * 2000
	var space = cam.get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = rayOrigin
	ray_query.to = rayEnd
	ray_query.collide_with_bodies = true
	var intersection = space.intersect_ray(ray_query)
	
	if not intersection.is_empty():
		var pos = intersection.position
		var posI = Vector3(pos.x, round(pos.y-0.000001), pos.z - 0.00001)
		destroyGrid.emit(posI)
