extends ColorRect


var angleX = 0
var angleY = 0

var rotate_speed = 2
var speed = 1

var time = 0

var cam = Vector3(0, 0, 0)

func _physics_process(delta):
	var dir = Vector3(0, 0, 0)
	
	if Input.is_key_pressed(KEY_LEFT):
		angleY -= rotate_speed
	if Input.is_key_pressed(KEY_RIGHT):
		angleY += rotate_speed
	if Input.is_key_pressed(KEY_UP):
		angleX -= rotate_speed
	if Input.is_key_pressed(KEY_DOWN):
		angleX += rotate_speed
	
	if Input.is_key_pressed(KEY_W):
		dir.z = speed
	if Input.is_key_pressed(KEY_S):
		dir.z = -speed
	if Input.is_key_pressed(KEY_A):
		dir.x = -speed
	if Input.is_key_pressed(KEY_D):
		dir.x = speed
	
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
	
	dir = dir.rotated(Vector3(0, 1, 0), deg2rad(angleY))
	
	cam += dir
	
	material.set_shader_param('angleY', deg2rad(angleY))
	material.set_shader_param('angleX', deg2rad(angleX))
	material.set_shader_param('cam', cam)
	material.set_shader_param('time', time)
	
	time += delta
