extends CharacterBody2D

const MAX_SPEED : float = 80
const ACCELARATION : float = 16.5
const FRICTION : float = 8.5

const DASH_RELOAD_COST : float = 0.5
const DASH_SPEED : float = 180
const DASH_TIME : float = 0.12
var can_dash : bool = true
var dash_timer : float = 0
var dash_dir : Vector2 = Vector2.ZERO
var dash_reload_timer : float = 0


func _physics_process(delta: float) -> void:
	if dash_timer == 0:
		var input : Vector2 = Vector2(Input.get_action_strength("right") - Input.get_action_strength("left"), 
		Input.get_action_strength("down") - Input.get_action_strength("up")).normalized()
		
		var velocity_weight_x : float = 1 - exp( -(ACCELARATION if input.x else FRICTION) * delta)
		velocity.x = lerp(velocity.x, input.x * MAX_SPEED, velocity_weight_x)
		
		var velocity_weight_y : float = 1 - exp( -(ACCELARATION if input.y else FRICTION) * delta)
		velocity.y = lerp(velocity.y, input.y * MAX_SPEED, velocity_weight_y)
	
	dash_logic(delta)
	move_and_slide()

func dash_logic(delta: float) -> void:
	if can_dash and Input.is_action_just_pressed("dash"):
		can_dash = false
		dash_timer = DASH_TIME
		dash_reload_timer = DASH_RELOAD_COST
		
		dash_dir = global_position.direction_to(get_global_mouse_position())
		velocity = dash_dir * DASH_SPEED
	
	if dash_timer > 0:
		dash_timer = max(0, dash_timer - delta)
	else:
		can_dash = true
