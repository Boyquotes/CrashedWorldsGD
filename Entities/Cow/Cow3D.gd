extends CharacterBody3D

var Target : Player
var speed = 1
var walkSpeed = 0.25
var isFlee
#var seePlayer
var target_pos : Vector3 = Vector3(0,1,0)
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") * 2

enum states {IDLE, WALK, FLEE}

@export var State: states:
	set(val):
		State = val
		_on_state_changed(val)
	get : return State
#----------------------------------------------------------- BASE
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	isFlee = false
	_on_state_changed(State)

func _physics_process(delta) -> void:
	# Raycast vision of the AI
#	if Target != null:
#		$RayCast3D.target_position = Target.global_position - $RayCast3D.global_position
#		if $RayCast3D.is_colliding() and $RayCast3D.get_collider() is Player:
#			seePlayer = true
#		else:
#			seePlayer = false
	# Switch states
	match State :
		states.IDLE : _Idle()
		states.WALK : _Walk()
		states.FLEE : _Flee()

	if not is_on_floor():
		velocity.y -= gravity

	if velocity.x > 0:
		$SubViewport/Node2D.flip(true)
	else:
		$SubViewport/Node2D.flip(false)
	move_and_slide()

#----------------------------------------------------------- CUSTOM
func _Idle():
	
	$Label3D.text = "IDLE"
#	_on_timer_timeout()
	if $Timer.is_stopped():
		$Timer.wait_time = randf_range(1.0, 5.0)
		$Timer.start()
		await $Timer.timeout
		if State == states.IDLE:
			target_pos = Vector3(randf_range(-3.0, 3.0), 0.0, randf_range(-5.0, 5.0))
			target_pos += transform.origin
		else:
			pass
	
	if target_pos.distance_to(transform.origin) > 0.1:
		velocity = target_pos - transform.origin # distance
		velocity = velocity.normalized() * walkSpeed # vector towards the pos
		
		
		#INSERT ANIMATIONS
	else:
		velocity.x = 0.0
		velocity.z = 0.0
		print("TRUE")
		#INSERT ANIMATION
	velocity.y = 0

func _Walk():
	$Label3D.text = "GUARD"
	if Target:
		if isFlee == false:
			var movement = (Target.global_position - global_position).normalized() * walkSpeed
			velocity = -movement
			velocity.y = 0.0
			$isFleeing.wait_time = randf_range(2.0, 3.0)
			$isFleeing.start()
			isFlee = true
		else:
				await $isFleeing.timeout
				isFlee = false

		#INSERT ANIMATIONS
	

func _Flee():
	$Label3D.text = "AGGRO"
	if Target :
		var movement = (Target.global_position - global_position).normalized() * speed
		velocity = -movement
		velocity.y = 0.0
		#INSERT ANIMATIONS


#----------------------------------------------------------- SIGNAL
func _on_state_changed(value):
	match value :
		states.IDLE : _Idle()
		states.WALK : _Walk()
		states.FLEE : _Flee()

func _on_area_flee_body_entered(body):
	if body is Player:
		State = states.FLEE
		Target = body

func _on_area_walk_body_entered(body):
	if body is Player:
		State = states.WALK
		Target = body

func _on_area_walk_body_exited(body):
	if body is Player:
		State = states.IDLE
		Target = body

func _on_area_flee_body_exited(body):
	if body is Player:
		State = states.WALK
		Target = body
