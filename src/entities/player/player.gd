extends KinematicBody2D

const ACCELERATION = 200
const MAX_SPEED = 100

var playerMotion = Vector2.ZERO

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var playerAxis = getPlayerAxis()
	getAnimationDirection(playerAxis)
	
	if (playerAxis == Vector2.ZERO):
		applyFloorFriction((ACCELERATION/2) * delta)
	else:
		applyPlayerMovement(playerAxis * ACCELERATION * delta)
	
	PlayerStateMachine.detectState(playerMotion, $".")

	playerMotion = move_and_slide(playerMotion)

func getPlayerAxis():
	var playerAxis = Vector2.ZERO
	playerAxis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	playerAxis.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	
	return playerAxis.normalized()

func getAnimationDirection(direction: Vector2):
	var normalizedDirection = direction.normalized()

	if (normalizedDirection.x <= -0.707):
		$sprite.flip_h = true
	elif (normalizedDirection.x > 0.707):
		$sprite.flip_h = false

func applyFloorFriction(frictionAmount):
	if (playerMotion.length() > frictionAmount):
		playerMotion -= playerMotion.normalized() * frictionAmount
	else:
		playerMotion = Vector2.ZERO

func applyPlayerMovement(acceleration):
	playerMotion += acceleration
	playerMotion = playerMotion.clamped(MAX_SPEED)
