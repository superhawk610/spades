class_name Player extends Object

var name : String
var variant : String
var cards = []
var points = 0
var bid = null
var tricks = 0


func _init(name: String, variant: String, deck: Array):
	self.name = name
	self.variant = variant
	deal(deck)


func is_ai():
	return name != "You"


func deal(deck: Array):
	while cards.size() < 13:
		cards.append(deck.pop_back())


func draw_card(card):
	for i in range(0, cards.size()):
		var c = cards[i]
		if c.suit == card.suit and c.face_value == card.face_value:
			cards.pop_at(i)
			return i
	
	assert(false, "attempted to draw card %s:%s not in hand" % [card.suit, card.face_value])


func place_bid(new_bid):
	bid = new_bid


func take_trick():
	tricks += 1


func score_points(add_points):
	points += add_points
