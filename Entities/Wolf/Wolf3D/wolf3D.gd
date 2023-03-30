extends CharacterBody3D

var Target : Player
var speed = 4
var guardSpeed = 4
var seePlayer
var target_pos : Vector3 = Vector3(0,1,0)
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

enum states {IDLE, GUARD, AGGRO, ATTACK, BITE}

@export var State: states:
	set(val):
		State = val
		_on_state_changed(val)
	get : return State

@export var Stats : EntityStats

var viewportworkaround : ViewportTexture 
var workaroundDone : bool = false

#------------------------------------------------------------------------------- BASE METHODS

# Called when the node enters the scene tree for the first time.
func _ready():
	viewportworkaround = $SubViewport.get_texture()
	randomize()
	_on_state_changed(State)
	Stats = Stats.duplicate()
	Stats.connect("death", on_death)
	Stats.connect("update", on_life_update)
	Stats.update.emit()
	
	_hide()
	
	set_process(false)
	set_physics_process(false)

func _process(_delta):
	if not workaroundDone : 
		$Sprite3D.material.albedo_texture = viewportworkaround
		workaroundDone = true
	
	
func _physics_process(_delta):
	# Raycast vision of the AI
	if Target != null:
		$RayCast3D.enabled = true
		$RayCast3D.target_position = Target.global_position - $RayCast3D.global_position
		if $RayCast3D.is_colliding() and $RayCast3D.get_collider() is Player:
			seePlayer = true
		else:
			seePlayer = false
	else :
		$RayCast3D.enabled = false
	
	# Switch states
	match State :
		states.IDLE : _Idle()
		states.GUARD : _Guard()
		states.AGGRO : _Aggro()
		states.ATTACK : _Attack()
		states.BITE : _Bite()
	
	velocity.y -= gravity

	if velocity.x > 0:
		$SubViewport/Wolf.flip(true)
	else:
		$SubViewport/Wolf.flip(false)
	move_and_slide()

# ------------------------------------------------------------------------------ CUSTOM METHODS
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

func on_death():
	queue_free()

func on_life_update():
	$SubViewport/EntityStats.max_value = Stats.maxLife
	$SubViewport/EntityStats.value = Stats.life

#------------------------------------------------------------------------------- SIGNALS
func _on_state_changed(value):
	
	$AreaAttack/Zone1.set_deferred("disabled", true)
	$AreaAggro/Zone2.set_deferred("disabled", true)
	$AreaGuard/Zone3.set_deferred("disabled", true)
	
	match value :
		states.IDLE : 
			$AreaGuard/Zone3.set_deferred("disabled", false)
		states.GUARD : 
			$AreaGuard/Zone3.set_deferred("disabled", false)
			$AreaAggro/Zone2.set_deferred("disabled", false)
		states.AGGRO : 
			$AreaAggro/Zone2.set_deferred("disabled", false)
			$AreaAttack/Zone1.set_deferred("disabled", false)
		states.ATTACK : 
			$AreaAttack/Zone1.set_deferred("disabled", false)
	
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

func _hide():
	$Sprite3D.hide()
	$Label3D.hide()
func _show():
	$Label3D.show()
	$Sprite3D.show()
