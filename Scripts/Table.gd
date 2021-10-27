extends Node2D

export(int) var deckSize = 0

var maxCardSelected = 3
var amountCardSelected = 0
var deck = []

signal locked(value)
signal cards(number)

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
	for card in get_tree().get_nodes_in_group("CARD"):
		card.connect("openCard", self, "_card_show") 
		card.connect("selectCard", self, "_selectCard")
		card.connect("closeCard", self, "_closeCard")
		self.connect("locked", card, "_locked")
	
	
	for i in range(deckSize):
		deck.append(true)
		
	drawCards()
	
	$Amount.text = str(maxCardSelected)
	
func drawCards():
	for card in get_tree().get_nodes_in_group("CARD"):
		var num = randi() % deckSize
		while(!deck[num]):
			num = randi() % deckSize
		
		deck[num] = false
		card.pullCard(num+1)

func _card_show(info):
	$Frase.text = str(info["name"], " : ",info["prevision"])
	$Frase.show()
	
func _selectCard():
	amountCardSelected +=1
	if (amountCardSelected >= maxCardSelected):
		emit_signal("locked", true)
		
	$Amount.text = str(maxCardSelected - amountCardSelected)
	
func _closeCard():
	amountCardSelected -=1
	if (amountCardSelected <= maxCardSelected):
		emit_signal("locked", false)
		
	$Amount.text = str(maxCardSelected - amountCardSelected)
