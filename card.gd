@tool
extends Control


var suits = {
	spade   = preload("res://images/spade.png"),
	club    = preload("res://images/club.png"),
	heart   = preload("res://images/heart.png"),
	diamond = preload("res://images/diamond.png"),
}

var face_values = {
	ace   = preload("res://images/a.png"),
	king  = preload("res://images/k.png"),
	queen = preload("res://images/q.png"),
	jack  = preload("res://images/j.png"),
	ten   = preload("res://images/10.png"),
	nine  = preload("res://images/9.png"),
	eight = preload("res://images/8.png"),
	seven = preload("res://images/7.png"),
	six   = preload("res://images/6.png"),
	five  = preload("res://images/5.png"),
	four  = preload("res://images/4.png"),
	three = preload("res://images/3.png"),
	two   = preload("res://images/2.png"),
	one   = preload("res://images/1.png"),
}

var backgrounds = {
	front = preload("res://images/card-frame.png"),
	back  = preload("res://images/card-back.png"),
}

enum Width {
	Compact = 78,
	Full    = 128,
}


@onready var c_suit = $offset/PanelContainer/CenterContainer/VBoxContainer/suit
@onready var c_face_value = $offset/PanelContainer/CenterContainer/VBoxContainer/face_value
@onready var c_container = $offset/PanelContainer/CenterContainer
@onready var c_background = $offset/PanelContainer/background
@onready var c_offset = $offset

signal clicked

@export_enum("spade", "club", "heart", "diamond")
var suit : String = "spade":
	set(new_suit):
		suit = new_suit
		if c_suit:
			c_suit.set_texture(suits[suit])

@export_enum("ace", "king", "queen", "jack", "ten", "nine", "eight", "seven", "six", "five", "four", "three", "two", "one")
var face_value : String = "ace":
	set(new_value):
		face_value = new_value
		if c_face_value:
			c_face_value.set_texture(face_values[face_value])

@export var flipped : bool = false:
	set(new_value):
		flipped = new_value
		if c_background:
			if flipped:
				c_background.set_texture(backgrounds.back)
				c_container.visible = false
			else:
				c_background.set_texture(backgrounds.front)
				c_container.visible = true

@export_enum("left", "top", "right", "hand")
var variant : String = "hand":
	set(new_value):
		variant = new_value
		if ready:
			c_offset = $offset
			apply_variant()

@export var compact : bool = false:
	set(new_value):
		compact = new_value
		if c_container:
			c_container.custom_minimum_size.x = Width.Compact if compact else Width.Full


# Called when the node enters the scene tree for the first time.
func _ready():
	c_suit.set_texture(suits[suit])
	c_face_value.set_texture(face_values[face_value])
	if flipped:
		c_background.set_texture(backgrounds.back)
		c_container.visible = false
	else:
		c_background.set_texture(backgrounds.front)
		c_container.visible = true
	c_container.custom_minimum_size.x = Width.Compact if compact else Width.Full
	apply_variant()


func apply_variant():
	if variant == "left":
		c_offset.scale = Vector2(0.5, 0.5)
		c_offset.rotation_degrees = 90
		c_offset.position = Vector2(96, 0)
		custom_minimum_size = Vector2(96, 64)
	elif variant == "top":
		c_offset.scale = Vector2(0.5, 0.5)
		c_offset.rotation_degrees = 0
		c_offset.position = Vector2.ZERO
		custom_minimum_size = Vector2(64, 96)
	elif variant == "right":
		c_offset.scale = Vector2(0.5, 0.5)
		c_offset.rotation_degrees = 270
		c_offset.position = Vector2(0, 64)
		custom_minimum_size = Vector2(96, 64)
	else:
		c_offset.scale = Vector2(0.8, 0.8)
		c_offset.rotation_degrees = 0
		c_offset.position = Vector2.ZERO
		custom_minimum_size = Vector2(128, 192) * c_offset.scale


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_mouse_entered():
	$AnimationPlayer.play("card_hover")


func _on_mouse_exited():
	$AnimationPlayer.play_backwards("card_hover")


func _get_drag_data(at_position):
	var preview_card := duplicate()
	preview_card.compact = false
	var preview = Node2D.new()
	preview.transform.origin = Vector2(-64, -86)
	preview.add_child(preview_card)
	var c_preview = Control.new()
	c_preview.add_child(preview)
	set_drag_preview(c_preview)

	return { suit = suit, face_value = face_value }


func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MouseButton.MOUSE_BUTTON_LEFT and !event.pressed:
			clicked.emit({ suit = suit, face_value = face_value })
