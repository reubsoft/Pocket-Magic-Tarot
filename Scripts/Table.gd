extends Node2D


var maxCardSelected = 3
var amountCardSelected = 0

signal locked(value)

# Called when the node enters the scene tree for the first time.
func _ready():
	for card in get_tree().get_nodes_in_group("CARD"):
		card.connect("openCard", self, "_card_show") 
		card.connect("selectCard", self, "_selectCard")
		card.connect("closeCard", self, "_closeCard")
		self.connect("locked", card, "_locked")
	pass # Replace with function body.


func _card_show(info):
	$Frase.text = str(info["content"])
	$Frase.show()
	
func _selectCard():
	amountCardSelected +=1
	if (amountCardSelected >= maxCardSelected):
		emit_signal("locked", true)
	print(amountCardSelected)
	
func _closeCard():
	amountCardSelected -=1
	if (amountCardSelected <= maxCardSelected):
		emit_signal("locked", false)
	print(amountCardSelected)
