extends Node

var misc: ScrollContainer
var pitch: HSlider
var speed: HSlider

func _ready():
	get_tree().root.connect("child_entered_tree", self, "_hook_playerhud")

func _mouse_connect(node: Node):
	node.connect("mouse_entered", self, "_mouse_enter")
	node.connect("mouse_exited", self, "_mouse_exit")

# A ton of this could be a script mod instead of whatever nonsense is going on here.
func _hook_playerhud(node: Node):
	if node.name != "playerhud":
		return
	node.connect("tree_exiting", self, "_destroy")
	
	misc = node.get_node("main/menu/tabs/outfit/Panel4/tabs/misc")

	var voice_options : Node = misc.get_node("HBoxContainer/vbox/voice_options")
	pitch = voice_options.get_node("HBoxContainer/HSlider")
	speed = voice_options.get_node("HBoxContainer2/speed")

	pitch.allow_greater = true
	pitch.allow_lesser = true
	speed.allow_greater = true
	speed.allow_lesser = true

	voice_options.connect("ready", self, "_on_options_ready")

	_mouse_connect(pitch)
	_mouse_connect(speed)

func _on_options_ready():
	_adjust_bounds(pitch)
	_adjust_bounds(speed)

func _adjust_bounds(slider: Range):
	slider.min_value = 0.01
	slider.max_value = 100
	slider.allow_greater = false
	slider.allow_lesser = false

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

