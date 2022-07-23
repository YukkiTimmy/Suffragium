extends Control


onready var fader = get_parent().get_node("Fader/Anim")
onready var credits = get_parent().get_node("Credits")

func _ready() -> void:
	visible = true
	get_tree().paused = true


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().paused = false
		var _err = GameManager._current_main_scene.get_node("BackgroundMusic")
		_err = fader.play("fadeOut")
		
		queue_free()
	
	
	if Input.is_action_just_pressed("W") and visible:
		credits.visible = !credits.visible
	
