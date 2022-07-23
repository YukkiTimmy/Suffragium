extends Node2D


var playerPos := Vector2.ZERO
var player = null


var score := 0.0
var healthScore := 0.0
var timeScore := 0.0
var finalScore := 0.0

var health = preload("res://games/suffro_mania/Health.tscn")

var rng = RandomNumberGenerator.new()

var time_start = 0

func _ready() -> void:
	time_start = OS.get_unix_time()
	
	GameManager._current_main_scene = self
	
	yield(get_tree(), "idle_frame")
	
	player = find_node("Player")
	
	for i in 20:
		var instance = health.instance()
		$UI/Health.add_child(instance)
		
		if i <= 9:
			instance.position.x = i * 9 + 5
		else:
			instance.position.x = (i - 10) * 9
			instance.position.y = 9
		
		instance.visible = false
	
	update_health()
	
	for room in $Rooms.get_children():
		room.visible = false
	

func _physics_process(_delta: float) -> void:
	if not $UI/EndScreen.visible:		
		update_timer()
		
		update_score()
		
		if rng.randi_range(0,500) == 1:
			var heart = $UI/Health.get_child(rng.randi_range(0,player.hp-1))
			heart.shine()
		
		if Input.is_action_just_pressed("ui_down"):
			$UI/EndScreen.visible = true
	
	

func hide_room(room) -> void:
	room[0].visible = false

func show_room(room) -> void:
	room[0].visible = true

		

func calc_score() -> void:
	finalScore = 0
	
	var highscore := score
	healthScore = floor(score * (float(player.hp)/float(player.max_hp)))
	
	if player.hp == player.max_hp:
		healthScore += 2500
	
	timeScore = 0
	var timer = OS.get_unix_time() - time_start
	
	if timer < 600:
		timeScore = floor((600 - timer) * 50)
	
	finalScore = highscore + healthScore + timeScore
	
	

func update_timer() -> void:	
	var timer = OS.get_unix_time() - time_start
	var secs = timer % 60 
	var mins = timer / 60
	
	if secs < 10:
		secs = str("0", secs)
	if mins < 10:
		mins = str("0", mins)
	
	$UI/Time.text = str("TIME: ", mins , ":", secs)


func update_health() -> void:
	if player.max_hp > $UI/Health.get_child_count():
		return
	
	for i in player.max_hp:
		$UI/Health.get_child(i).visible = true
		$UI/Health.get_child(i).frame = 7
	
	for i in player.hp:
		$UI/Health.get_child(i).visible = true
		$UI/Health.get_child(i).frame = 0


func update_score() -> void:
	$UI/Score.text = str("SCORE: ", score)

func get_player_pos() -> Vector2:
	if player:
		playerPos = player.global_position
		return playerPos
	
	return Vector2.ZERO


func _on_BossTrigger_body_entered(body: Node) -> void:
	if body.is_in_group("PLAYER"):
		$Enemies/Brain.set_physics_process(true)
		
		$Props/BossTrigger.queue_free()
