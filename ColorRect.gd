extends ColorRect


var angleX = 0
var angleY = 0

var cam = Vector3(0, 0, 0)

func _physics_process(delta):
	var dir = Vector3(0, 0, 0)
