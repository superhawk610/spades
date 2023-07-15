extends Node2D


var game := Game.new()
var player : Player
var players = {
	left  = null,
	top   = null,
	right = null,
}

var s_card = preload("res://card.tscn")

signal card_clicked

@onready var c_bid = $PanelContainer/MarginContainer/CenterContainer/bid
@onready var c_hand = $PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/VBoxContainer/player_hand
@onready var c_player_left = $PanelContainer/MarginContainer/HBoxContainer/player_left
@onready var c_player_right = $PanelContainer/MarginContainer/HBoxContainer/player_right
@onready var c_player_top = $PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/player_top
@onready var c_card_drop = $PanelContainer/MarginContainer/CenterContainer/MarginContainer/HBoxContainer
@onready var c_play_you = $PanelContainer/MarginContainer/CenterContainer/MarginContainer/HBoxContainer/center/card_bottom
@onready var c_play_left = $PanelContainer/MarginContainer/CenterContainer/MarginContainer/HBoxContainer/left/card
@onready var c_play_top = $PanelContainer/MarginContainer/CenterContainer/MarginContainer/HBoxContainer/center/card_top
@onready var c_play_right = $PanelContainer/MarginContainer/CenterContainer/MarginContainer/HBoxContainer/right/card


# Called when the node enters the scene tree for the first time.
func _ready():
	c_card_drop.connect("dropped", func(c): card_clicked.emit(c))
	
	deal()
	bid()
	play_round()


func deal():
	game.shuffle()
	
	# order matters here since this will establish turn order
	player = game.deal_player("You", "hand")
	players.left = game.deal_player("Mike", "left")
	players.top = game.deal_player("Bill", "top")
	players.right = game.deal_player("Lisa", "right")
	
	c_player_left.get_node("player_icon/Label").text = players.left.name
	c_player_top.get_node("player_icon/Label").text = players.top.name
	c_player_right.get_node("player_icon/Label").text = players.right.name
	
	for i in range(0, player.cards.size()):
		var card = s_card.instantiate()
		card.suit = player.cards[i].suit
		card.face_value = player.cards[i].face_value
		card.compact = i < 12
		card.connect("clicked", func(c): card_clicked.emit(c))
		c_hand.add_child(card)
	
	var card = s_card.instantiate()
	card.mouse_filter = Control.MouseFilter.MOUSE_FILTER_IGNORE
	card.flipped = true
	
	for name in players:
		var p = players[name]
		for _c in p.cards:
			var c = card.duplicate()
			c.variant = p.variant
			c_player_hand(p).add_child(c)
	
	assert(game.deck.size() == 0, "all cards have been dealt")


func bid():
	var bid = await c_bid.bid_placed
	c_bid.hide()
	c_player_hand(player).get_node("player_icon/Label").text = '%s (%s)' % [player.name, bid]


func play_round():
	while player.cards.size() > 0:
		for name in game.players:
			var player = game.players[name]
			var c_preview = c_player_preview(player)
			var c_hand = c_player_hand(player)
			var card
			if player.is_ai():
				c_hand.remove_child(c_hand.get_children()[-1])
				card = player.cards.pop_back()
			else:
				card = await card_clicked
				var i = player.draw_card(card)
				# child index + 1 to account for player_icon
				c_hand.remove_child(c_hand.get_child(i + 1))
			c_preview.suit = card.suit
			c_preview.face_value = card.face_value
			c_preview.flipped = false
			await get_tree().create_timer(1).timeout


func c_player_hand(player: Player):
	match player.variant:
		"left":
			return c_player_left
		"top":
			return c_player_top
		"right":
			return c_player_right
		"hand":
			return c_hand


func c_player_preview(player: Player):
	match player.variant:
		"left":
			return c_play_left
		"top":
			return c_play_top
		"right":
			return c_play_right
		"hand":
			return c_play_you

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
