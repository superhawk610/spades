class_name Game extends Object


var suits = [
	"spade",
	"heart",
	"diamond",
	"club"
]

var card_ranking = [
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

var deck : Array
var players = {}
var points = {}
var trick = []


func shuffle():
	deck = suits.reduce(func(acc, suit):
		acc.append_array(card_ranking.map(func(value):
			return { suit = suit, face_value = value }
		))
		return acc, [])
	deck.shuffle()


func deal_player(name: String, variant: String):
	var player : Player = players.get(name)
	if player:
		player.deal(deck)
	else:
		player = Player.new(name, variant, deck)
		players[name] = player
	return player


func place_bid(name: String, bid: int):
	var player : Player = players.get(name)
	if not player:
		assert(false, "attempted to place bid for missing player %s" % name)
	player.place_bid(bid)


func can_play_card(card):
	return true


func play_card(card):
	trick.append(card)


func score_trick():
	pass


func score_round(team: String, bid: int, tricks: int):
	pass
