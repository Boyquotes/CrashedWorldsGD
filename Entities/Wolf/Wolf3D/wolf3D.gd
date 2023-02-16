extends CharacterBody3D

var Target : Player
var speed = 3
var guardSpeed = 1
var seePlayer

var State:
	set(val):
		State = val
		_on_state_changed(val)
	get : return State
enum states {IDLE, GUARD, AGGRO, ATTACK}
#----------------------------------------------------------- BASE
# Called when the node enters the scene tree for the first time.
func _ready():
	State = states.IDLE

func _physics_process(delta) -> void:
	if Target != null:
		$RayCast3D.target_position = Target.global_position - $RayCast3D.global_position
		if $RayCast3D.is_colliding() and $RayCast3D.get_collider() is Player:
			seePlayer = true
		else:
			seePlayer = false

		if seePlayer == true:
			match State :
				states.IDLE : _Idle()
				states.GUARD : _Guard()
				states.AGGRO : _Aggro()
				states.ATTACK : _Attack()
	
	velocity.y -= 9.8
	if velocity.x > 0:
		$SubViewport/Node2D.flip(true)
	else:
		$SubViewport/Node2D.flip(false)
	move_and_slide()
	print(seePlayer)

#----------------------------------------------------------- SIGNAL
func _on_area_attack_body_entered(body):
	if body is Player:
		State = states.ATTACK
		Target = body

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
#----------------------------------------------------------- FUNCTION
func _on_state_changed(value):
	match value :
		states.IDLE : $Label3D.text = "IDLE"
		states.GUARD : _Guard()
		states.AGGRO : _Aggro()
		states.ATTACK : _Attack()

func _Idle():
	$Label3D.text = "IDLE"
	
func _Guard():
	$Label3D.text = "GUARD"
	if Target :
		var movement = (Target.global_position -  global_position).normalized() * guardSpeed
		velocity = movement
		

func _Aggro():
	if Target :
		var movement = (Target.global_position -  global_position).normalized() * speed
		velocity = movement

func _Attack():
	$Label3D.text = "ATTACK"
