extends Node

signal destroyGrid
signal placeGrid

func useItemType(item : Item, cam = null):
	match item.type :
		"Dig" : dig(cam)
		"Bloc" : placebloc(cam, item.itemName)

func dig(cam):
	var intersectionAndRay = await getIntersectionAndRay(cam)
	var intersection = intersectionAndRay[0]
	var ray_query = intersectionAndRay[1]

	if not intersection.is_empty():
		var pos = intersection.position
		var normalizedDir = (ray_query.to - ray_query.from).normalized() / 1000
		if floor(pos.y + normalizedDir.y) <= 0: return
		var posI = Vector3i(pos.x + normalizedDir.x, pos.y + normalizedDir.y, pos.z + normalizedDir.z)
		destroyGrid.emit(posI)

func placebloc(cam, itemName : String):
	var id
	match itemName :
		"Grass Bloc" : id = 0
		"Dirt Bloc" : id = 1
		"Stone Bloc" : id = 2
		"Grassy Stone Bloc" : id = 3
		"Sand Bloc" : id = 4

	var intersectionAndRay = await getIntersectionAndRay(cam)
	var intersection = intersectionAndRay[0]
	var ray_query = intersectionAndRay[1]

	if not intersection.is_empty():
		var pos = intersection.position
		var normalizedDir = (ray_query.from - ray_query.to).normalized() / 1000
		var posI = Vector3i(pos.x + normalizedDir.x, pos.y + normalizedDir.y, pos.z + normalizedDir.z)
		placeGrid.emit(posI,id)

func getIntersectionAndRay(cam) -> Array:
	var mousePosition = get_viewport().get_mouse_position()
	var rayOrigin = cam.project_ray_origin(mousePosition)
	var rayEnd = rayOrigin + cam.project_ray_normal(mousePosition) * 2000
	
	await get_tree().physics_frame
	var space = cam.get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = rayOrigin
	ray_query.to = rayEnd
	ray_query.collide_with_bodies = true
	var intersection = space.intersect_ray(ray_query)
	return [intersection, ray_query]
