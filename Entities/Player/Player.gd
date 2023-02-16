extends CharacterBody3D

class_name Player

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


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
	else:
		if velocity.x > 0:
			$AnimatedSprite3D.flip_h = false
			$Equiped.position.x = 0.3
			$Equiped.flip_h = false
			
		else:
			$AnimatedSprite3D.flip_h = true
			$Equiped.position.x = -0.3
			$Equiped.flip_h = true
			
		$AnimatedSprite3D.play("Run")
	
	move_and_slide()

func equip(item):
	if item : 
		$Equiped.show()
		$Equiped.texture = item.icon
	else:
		$Equiped.hide()
