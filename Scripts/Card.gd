extends Area2D

export(NodePath) var cardFront = null
export(NodePath) var cardBack  = null
export(String) var url = "http://127.0.0.1:3333/show/"
var selected = false setget set_selected, is_selected
var info = {} setget set_info, get_info
var opening = false
var locked = false

var numRom = ["",'I', "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X", "XI", "XII", "XIII", "XIV", "XV",
"XVI", "XVII", "XVIII", "XIX", "XX", "XXI", "XXII"]

signal openCard(info)
signal selectCard
signal closeCard



func _ready():
	if cardFront == null:
		testNode("cardFront")
	if cardBack == null:
		testNode("cardBack")
		
	info = {
		"num" : 0,
		"name" : "",
		"prevision": ""
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

func set_info(mensage):
	info = mensage
	
func get_info():
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

# Url request server
func pullCard(num):
	print(num)
	$HTTPRequest.request(url + str(num))

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	var tmp = json.result.card

	info.prevision = tmp.prevision
	info.num = str(tmp.deck_id)
	info.name = tmp['deck'].name
	
	$Front/num.text = numRom[int(info.num)]
	$Front/Name.text = info.name
