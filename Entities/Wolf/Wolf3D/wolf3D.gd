extends RigidBody3D

var Target : Player


var State:
	set(val):
		_on_state_changed(val)
	get : return State

enum states {IDLE, GUARD, AGGRO, ATTACK}
# Called when the node enters the scene tree for the first time.
func _ready():
	State = states.IDLE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	match State :
#		states.IDLE : print("IDLE")
#		states.GUARD : print("GUARD")
#		states.AGGRO : print("AGGRO")
#		states.ATTACK : print("ATTACK")
	pass

func _on_state_changed(value):
	match value :
		states.IDLE : $Label3D.text = "IDLE"
		states.GUARD : $Label3D.text = "GUARD"
		states.AGGRO : $Label3D.text = "AGGRO"
		states.ATTACK : $Label3D.text = "ATTACK"

func _Idle():
	pass
	
func _Guard():
	pass
	
func _Aggro():
	pass
	
func _Attack():
	pass



func _on_area_attack_body_entered(Player):
	State = states.ATTACK

func _on_area_aggro_body_entered(Player):
	State = states.AGGRO

func _on_area_guard_body_entered(Player):
	State = states.GUARD

func _on_area_guard_body_exited(Player):
	State = states.IDLE

func _on_area_aggro_body_exited(Player):
	State = states.GUARD

func _on_area_attack_body_exited(body):
	State = states.AGGRO
