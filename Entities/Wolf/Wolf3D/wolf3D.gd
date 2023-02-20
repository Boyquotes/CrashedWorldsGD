extends CharacterBody3D

var Target : Player
var speed = 4
var guardSpeed = 2
var seePlayer
var target_pos : Vector3 = Vector3(0,1,0)
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") * 2

enum states {IDLE, GUARD, AGGRO, ATTACK, BITE}

@export var State: states:
	set(val):
		State = val
		_on_state_changed(val)
	get : return State
#----------------------------------------------------------- BASE
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	_on_state_changed(State)

func _physics_process(delta) -> void:
	# Raycast vision of the AI
	if Target != null:
		$RayCast3D.target_position = Target.global_position - $RayCast3D.global_position
		if $RayCast3D.is_colliding() and $RayCast3D.get_collider() is Player:
			seePlayer = true
		else:
			seePlayer = false
	# Switch states
	match State :
		states.IDLE : _Idle()
		states.GUARD : _Guard()
		states.AGGRO : _Aggro()
		states.ATTACK : _Attack()
		states.BITE : _Bite()
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
		velocity = velocity.normalized() * guardSpeed # vector towards the pos
		
		
		#INSERT ANIMATIONS
	else:
		velocity.x = 0.0
		velocity.z = 0.0
		#INSERT ANIMATION
	velocity.y = 0

func _Guard():
	$Label3D.text = "GUARD"
	if Target and seePlayer:
		var movement = (Target.global_position -  global_position).normalized() * guardSpeed
		velocity = movement
		velocity.y = 0.0
		#INSERT ANIMATIONS
	

func _Aggro():
	$Label3D.text = "AGGRO"
	if Target :
		var movement = (Target.global_position -  global_position).normalized() * speed
		velocity = movement
		velocity.y = 0.0
		#INSERT ANIMATIONS

func _Attack():
	$Label3D.text = "ATTACK"
	velocity = Vector3.ZERO
	
func _Bite():#C'est drôle hein
#	#INSERT ANIMATIONS
	pass

#----------------------------------------------------------- SIGNAL
func _on_state_changed(value):
	match value :
		states.IDLE : _Idle()
		states.GUARD : _Guard()
		states.AGGRO : _Aggro()
		states.ATTACK : _Attack()
	
func _on_animated_sprite_3d_animation_finished():
	var anim_finished = $AnimatedSprite3D.animation
	if anim_finished == "Bite": 
		State = states.IDLE
		$Detect.start()

func _on_detect_timeout():
		State = states.AGGRO

func _on_area_attack_body_entered(body):
	if body is Player:
		State = states.ATTACK
		Target = body
		$AttackPrep.start()

func _on_attack_prep_timeout():
	# BITE DASH GOES HERE
	target_pos = Target.transform.origin
	velocity =target_pos - transform.origin
	velocity = velocity.normalized()*speed * 2.0
	if is_on_floor():
		velocity.y = speed
		
	State = states.BITE

func _on_area_aggro_body_entered(body):
	if body is Player:
		State = states.AGGRO
		Target = body

func _on_area_guard_body_entered(body):
	if body is Player:
		State = states.GUARD
		Target = body

func _on_area_guard_body_exited(body):
	if body is Player:
		State = states.IDLE
		Target = body

func _on_area_aggro_body_exited(body):
	if body is Player:
		State = states.GUARD
		Target = body

func _on_area_attack_body_exited(body):
	if body is Player:
		State = states.AGGRO
		Target = body
