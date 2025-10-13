extends Sprite2D

@onready var mouse_pos : Vector2 = get_viewport().get_mouse_position()

const CURSOR_SPEED : float = 100
const DEADZONE : float = 0.2

func _physics_process(delta: float) -> void:
	var move = Vector2(
		Input.get_joy_axis(0, JOY_AXIS_RIGHT_X),
		Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
	)
	
	if move.length() < DEADZONE:
		move = Vector2.ZERO
	else: 
		move.normalized()
		
	mouse_pos += move * CURSOR_SPEED * delta
	Input.warp_mouse(mouse_pos)
	
	var old_pos = global_position
	global_position += move * CURSOR_SPEED * delta
	
	if global_position != old_pos:
		var motion_event : InputEventMouseMotion = InputEventMouseMotion.new()
		motion_event.position = get_cursor_screen_pos()
		get_viewport().push_input(motion_event)
		
func get_cursor_screen_pos() -> Vector2:
	var final_pos : Vector2 = global_position
	var level_cam : Camera2D = get_viewport().get_camera_2d()
	if level_cam:
		final_pos -= level_cam.global_position
		if level_cam.anchor_mode == Camera2D.ANCHOR_MODE_DRAG_CENTER:
			final_pos += get_viewport_rect().size / 2
	return get_viewport().get_screen_transform().basis_xform(final_pos)
