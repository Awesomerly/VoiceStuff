extends Node

var misc: ScrollContainer
var pitch: HSlider
var speed: HSlider

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().root.connect("child_entered_tree", self, "_hook_playerhud")

func _mouse_connect(node: Node):
	node.connect("mouse_entered", self, "_mouse_enter")
	node.connect("mouse_exited", self, "_mouse_exit")

func _hook_playerhud(node: Node):
	if node.name != "playerhud":
		return
	node.connect("tree_exiting", self, "_destroy")
	
	misc = node.get_node("main/menu/tabs/outfit/Panel4/tabs/misc")

	var voice_options : Node = misc.get_node("HBoxContainer/vbox/voice_options")
	pitch = voice_options.get_node("HBoxContainer/HSlider")
	speed = voice_options.get_node("HBoxContainer2/speed")

	voice_options.connect("ready", self, "_on_options_ready")

	_mouse_connect(pitch)
	_mouse_connect(speed)

func _on_options_ready():
	pitch.min_value = 0.01
	pitch.max_value = 100
	pitch.value = PlayerData.voice_pitch
	speed.min_value = -1
	speed.max_value = 100
	speed.value = PlayerData.voice_speed

func _destroy():
	misc = null
	pitch = null
	speed = null

func _mouse_enter():
	misc.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
	
func _mouse_exit():
	misc.set_mouse_filter(Control.MOUSE_FILTER_PASS)

func _input(input: InputEvent):
	if not misc:
		return
	if !(input is InputEventKey):
		return
	if input.is_action("move_sprint"):
		if input.is_pressed():
			pitch.step = 0.01
			speed.step = 0.1
		else:
			pitch.step = 0.1
			speed.step = 1

