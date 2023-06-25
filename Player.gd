class_name Player extends Object

var cards = []


func _init(deck: Array):
	while cards.size() < 13:
		cards.append(deck.pop_back())
