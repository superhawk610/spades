extends HBoxContainer


signal dropped


func _can_drop_data(at_position, data):
	return typeof(data) == TYPE_DICTIONARY and data.has('suit') and data.has('face_value')


func _drop_data(at_position, data):
	dropped.emit(data)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
