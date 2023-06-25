extends Node2D


var suits = [
	"spade",
	"heart",
	"diamond",
	"club"
]

var card_values = [
	"two",
	"three",
	"four",
	"five",
	"six",
	"seven",
	"eight",
	"nine",
	"ten",
	"jack",
	"queen",
	"king",
	"ace",
]

var deck = suits.reduce(func(acc, suit):
	acc.append_array(card_values.map(func(value):
		return { suit = suit, face_value = value }
	))
	return acc, [])

var s_card = preload("res://card.tscn")


@onready var c_hand = $PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/VBoxContainer/player_hand
@onready var c_player_left = $PanelContainer/MarginContainer/HBoxContainer/player_left
@onready var c_player_right = $PanelContainer/MarginContainer/HBoxContainer/player_right
@onready var c_player_top = $PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/player_top

# Called when the node enters the scene tree for the first time.
func _ready():
	deck.shuffle()
	
	var player_1 = Player.new(deck)
	for i in range(0, player_1.cards.size()):
		var card = s_card.instantiate()
		card.suit = player_1.cards[i].suit
		card.face_value = player_1.cards[i].face_value
		card.compact = i < 12
		card.connect("clicked", _on_card_clicked)
		c_hand.add_child(card)
	
	var card = s_card.instantiate()
	card.mouse_filter = Control.MouseFilter.MOUSE_FILTER_IGNORE
	card.flipped = true
	
	var player_top = Player.new(deck)
	for i in range(0, 13):
		var card_top = card.duplicate()
		card_top.variant = "top"
		c_player_top.add_child(card_top)
	
	var player_left = Player.new(deck)
	for i in range(0, 13):
		var card_left = card.duplicate()
		card_left.variant = "left"
		c_player_left.add_child(card_left)
	
	var player_right = Player.new(deck)
	for i in range(0, 13):
		var card_right = card.duplicate()
		card_right.variant = "right"
		c_player_right.add_child(card_right)
	
	assert(deck.size() == 0, "all cards have been dealt")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_card_clicked(card):
	print(card, card_values.find(card.face_value))
