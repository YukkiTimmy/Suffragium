extends "Enemy.gd"

const SPEED := 50
const GRAVITY := 5
const FLOOR := Vector2(0,-1)

export (Vector2) var direction = Vector2.LEFT

var velocity := Vector2.ZERO


func _ready() -> void:
	hp = 3
	SCORE = 100


func _physics_process(_delta):
	if hitstun > 0:
		hitstun -= 1
		visible = hitstun % 3
		return
	
	elif visible == false:
		visible = true
	
	
	if direction == Vector2.LEFT:
		$AnimationPlayer.play("walk_left")
	elif direction == Vector2.RIGHT:
		$AnimationPlayer.play("walk_right")
	
	
	if direction == Vector2.LEFT and is_on_wall() or direction == Vector2.LEFT and not $Left.is_colliding():
		direction = Vector2.RIGHT
		
	elif direction == Vector2.RIGHT and is_on_wall() or direction == Vector2.RIGHT and not $Right.is_colliding():

		direction = Vector2.LEFT
	
	
	velocity.x = SPEED * direction.x
	
	velocity.y += GRAVITY
	
	velocity = move_and_slide_with_snap(velocity, Vector2(0,1), FLOOR)
	
	
