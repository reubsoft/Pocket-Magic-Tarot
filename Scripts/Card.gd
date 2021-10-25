extends Area2D

export(NodePath) var cardFront = null
export(NodePath) var cardBack  = null

var selected = false setget set_selected, is_selected
var info = {} setget set_info, get_info
var opening = false
var locked = false

signal openCard(info)
signal selectCard
signal closeCard

func _ready():
	if cardFront == null:
		testNode("cardFront")
	if cardBack == null:
		testNode("cardBack")
	info = {
		"num" : 35,
		"name" : "JUSTICE",
		"content" : "Para sua alma ficar confortável e segura, muita coisa ainda precisaria acontecer. Por enquanto, o que você tem disponível é a natureza dos vínculos que estão em formação na atualidade. Não é pouca coisa."
#		"content": "blá... blá... blá... blá... blá... blá... blá... \n blá... blá... blá... blá... blá..."
	}
	
	
# controller Touch
func _on_Card_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch:
		if event.pressed and !is_selected():
			if locked:
				return
			$AnimationPlayer.current_animation = "selected"
			emit_signal("selectCard")
		elif event.pressed and opening:
			emit_signal("openCard", info)

func is_selected():
	return selected

# flip selected, used in animation
func flip_selected():
	set_selected(is_selected())
	
func set_selected(value):
	selected = !value

func set_info(mensage: String):
	info = mensage
	
func get_info() -> String:
	return info

# controller visibility nodes
func flipCard():
	if is_selected():
		$Watermark.visible = !$Watermark.visible
		get_node(cardFront).visible = !get_node(cardFront).visible
		get_node(cardBack).visible = !get_node(cardBack).visible
		
func testNode(msg):
	print("ERROR: Não foi encontrado node ", msg)
	print(name)
	get_tree().quit()

func button_show():
	$Open.visible = !$Open.visible
	$Close.visible = !$Close.visible

# Signals
func _on_Close_button_down():
	emit_signal("closeCard")
	$AnimationPlayer.play_backwards("selected")
	
func _on_Open_button_down():
	opening = true
	button_show()
	flipCard()
	$Front/Name.text = str(info["name"])
	
	
	
func _locked(value):
	locked = value
