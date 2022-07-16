tool
extends PanelContainer

signal got_input(input_type)

export(StyleBoxFlat) var get_input_style
export(bool) var get_input setget set_get_input, get_get_input
export(bool) var display setget set_display, get_display

var _control_scheme_name = ""
var _control_scheme_detail = ""
var _display = false
var _get_input = false

onready var _player_text = $CenterContainer/VBoxContainer/PlayerText
onready var _description_text = $CenterContainer/VBoxContainer/DescriptionText
onready var _controll_detail_text = $CenterContainer/VBoxContainer/ControllText


func set_display(do_display: bool):
	if do_display:
		self.add_stylebox_override("panel", null)
		$CenterContainer.show()
	else:
		self.add_stylebox_override("panel", StyleBoxEmpty.new())
		$CenterContainer.hide()
	_display = do_display


func get_display() -> bool:
	return _display


func set_get_input(do_get_input: bool):
	if do_get_input:
		set_process_input(true)
		self.add_stylebox_override("panel", get_input_style)
		_description_text.text = "Press button to add"
		_controll_detail_text.text = ""
	else:
		set_process_input(false)
		self.add_stylebox_override("panel", null)
		_description_text.text = _control_scheme_name
		_controll_detail_text.text = _control_scheme_detail
	_get_input = do_get_input


func get_get_input() -> bool:
	return _get_input


func _ready():
	_player_text.text = name


func _input(event):
	var input_map = $"../../../../../..".input_map as Dictionary
	if event is InputEventKey:
		if not event.pressed:
			var keyboard_input_type = null
			# Try to find a control scheme, that contains the released button
			for input_type in input_map.keys():
				match typeof(input_type):
					SortItRoot.InputType.JOY:
						pass
					_:
						var actions = input_map[input_type]["actions"] as Dictionary
						for action_key in actions.values():
							if action_key == event.scancode:
								keyboard_input_type = input_type
			if keyboard_input_type == null:
				return
			_control_scheme_name = "Keyboard: " + input_map[keyboard_input_type]["name"]
			_control_scheme_detail = input_map[keyboard_input_type]["control_detail"]
			emit_signal("got_input", [keyboard_input_type, -1])
	if event is InputEventJoypadButton:
		if not event.pressed:
			_control_scheme_name = (
				input_map[SortItRoot.InputType.JOY]["name"]
				+ " "
				+ str(event.device)
			)
			_control_scheme_detail = input_map[SortItRoot.InputType.JOY]["control_detail"]
			emit_signal("got_input", [SortItRoot.InputType.JOY, event.device])
