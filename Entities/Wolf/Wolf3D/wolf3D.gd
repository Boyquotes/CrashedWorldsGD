extends RigidBody3D

var Target : Player
@onready var nav_agent = $navigationAgent3D
var speed = 3
var State:
	set(val):
		_on_state_changed(val)
	get : return State
enum states {IDLE, GUARD, AGGRO, ATTACK}
#----------------------------------------------------------- BASE
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

func _physics_process(delta):
	#Appliquer force vers Target Player * speed
		pass

#----------------------------------------------------------- SIGNAL
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
#----------------------------------------------------------- FUNCTION
func _on_state_changed(value):
	match value :
		states.IDLE : _Idle()
		states.GUARD : _Guard()
		states.AGGRO : _Aggro()
		states.ATTACK : _Attack()

func _Idle():
	$Label3D.text = "IDLE"
	
func _Guard():
	$Label3D.text = "GUARD"
	
func _Aggro():
	$Label3D.text = "AGGRO"
	
func _Attack():
	$Label3D.text = "ATTACK"

