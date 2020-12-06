extends Node
const VECTOR_ZERO = Vector2.ZERO

enum {
	STATE_IDLE,
	STATE_RUN
}

var state = STATE_IDLE

func _ready():
	pass

remote func detectState(velocity: Vector2, entity: KinematicBody2D):
	if (velocity == VECTOR_ZERO):
		state = STATE_IDLE
	if (velocity != VECTOR_ZERO):
		state = STATE_RUN
	
	stateMachine(entity)

func stateMachine(entity):
	match state:
		STATE_IDLE:
			idle(entity)
		STATE_RUN:
			run(entity)
			
func idle(entity):
	changeAnimation(entity, 'idle')

func run(entity):
	changeAnimation(entity, 'run')

func changeAnimation(entity, animation):
	var entitySprite = spriteOfEntity(entity)
	entitySprite.play(animation)

func spriteOfEntity(entity):
	return get_tree().get_root().get_node(entity.get_path()).get_node('sprite')
