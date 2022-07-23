extends KinematicBody2D

var DAMAGE = 1

var hp = 0

var hitstun = 0
var hitstun_max = 40

var score_scene = preload("res://games/suffro_mania/Score.tscn")
var SCORE = 100

var explosion_scene = preload("res://games/suffro_mania/enemies/Enemy_explosion.tscn")
var boss_scene = preload("res://games/suffro_mania/enemies/Boss_explosion.tscn")

var powerup_scene = preload("res://games/suffro_mania/Powerup.tscn")

var rdm = RandomNumberGenerator.new()


var parent = null

func _ready() -> void:
	set_physics_process(false)
	visible = false
	
	yield(get_tree(), "idle_frame")
	parent = get_parent()


func hit(dmg) -> void:	
	hitstun = hitstun_max
	
	hp -= dmg
	
	var SFX = load("res://games/suffro_mania/SFX.tscn").instance()
	SFX.play("damageE")
	parent.add_child(SFX)
	
	if hp <= 0:
		if not is_in_group("BOSS"):
			var instance = score_scene.instance()
			instance.score = SCORE
			instance.get_child(0).rect_position = position
			parent.add_child(instance)
			
			instance = explosion_scene.instance()
			parent.add_child(instance)
			instance.position = position
			
			rdm.randomize()
			if rdm.randi_range(0,25) == 1:
				instance = powerup_scene.instance()
				instance.type = "ENERGY"
				parent.call_deferred("add_child", instance)
#				get_parent().add_child(instance)
				instance.position = position
			
			GameManager._current_main_scene.player.screen_shake(1.5)
		
		else:
			var instance = score_scene.instance()
			instance.score = SCORE
			instance.get_child(0).rect_position = position
			parent.add_child(instance)
			
			instance = boss_scene.instance()
			parent.add_child(instance)
			instance.position = position
		
		queue_free()
		


func _on_VisibilityNotifier2D_viewport_entered(_viewport: Viewport) -> void:
	if not is_in_group("BOSS"):
		visible = true
		set_physics_process(true)



func _on_VisibilityNotifier2D_viewport_exited(_viewport: Viewport) -> void:
	if not is_in_group("BOSS"):
		visible = false
		set_physics_process(false)
	

