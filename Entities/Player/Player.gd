extends CharacterBody3D

class_name Player

const SPEED = 6.0
const JUMP_VELOCITY = 4.5

signal useItem

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var Stats : EntityStats

var screen_x_size : float # Used to flip character based on mouse pos

func _ready():
	connect("useItem", UseEffect.useItemType)
	Stats.duplicate()
	Stats.connect("update", _on_life_changed)
	Stats.connect("death", _on_death)
	Stats.update.emit()

	screen_x_size = get_viewport().size.x


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		if $Inventory/Bag.visible:
			$Inventory/Bag.hide()
			#Node not found: "Inventory/ItemList".
			#$Inventory/ItemList.hide()
		else:
			$Inventory/Bag.show()

	# ITEM USAGE
	elif event.is_action_pressed("LMB"):
		if $Equiped.get_child_count() > 0:                     # If item is equiped
			$Equiped.get_child(0).use()                    # use it.
			useItem.emit($Equiped.get_child(0).item, $Camera3D)# pass the info to singleton
			if $Equiped.get_child(0).item.amount <= 0:         # if there is no more item after that
				$Equiped.get_child(0).queue_free()             # delete the item

	if event is InputEventMouseMotion:
		if event.position.x >= screen_x_size/2:
			$AnimatedSprite3D.flip_h = false
			$Equiped.position.x = 0.3
			$Equiped.scale.x = 1
		else:
			$AnimatedSprite3D.flip_h = true
			$Equiped.position.x = -0.3
			$Equiped.scale.x = -1

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	if velocity == Vector3.ZERO:
		$AnimatedSprite3D.play("Idle")
		$Camera3D.position.z = lerp($Camera3D.position.z, 3.75, 0.1)
	else:
		$Camera3D.position.z = lerp($Camera3D.position.z, 4.25, 0.1)
		$AnimatedSprite3D.play("Run")

	move_and_slide()

func equip(item):
	if $Equiped.get_child_count() > 0:
		for i in $Equiped.get_children():
			i.queue_free()
	if item :
		$Equiped.show()
		var inst
		if item.objectScenePath:
			inst = load(item.objectScenePath).instantiate()
			if inst.item == null:
				inst.item = item
		$Equiped.add_child(inst)

	else:
		$Equiped.hide()
		$Equiped.get_child(0).queue_free()

# ------------------------------------------------------------------------------ SIGNALS

func _on_life_changed():
	$Life/SubViewport/EntityStats.max_value = Stats.life
	$Life/SubViewport/EntityStats.value = Stats.maxLife

func _on_death():
	pass

func _hide(): $AnimatedSprite3D.hide()

func _show(): $AnimatedSprite3D.show()
