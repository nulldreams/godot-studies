# Estudos

---

# Movimentação
<p align="center">
    <img src="./doc/movement.gif">
</p>

> src/entities/player/player.gd
```python
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
```

- `_physics_process`: Função nativa do Godot que é chamada a cada frame do jogo

- `getPlayerAxis`: Função para detectar o eixo do jogador

- `getAnimationDirection`: Função para modificar o sprite do jogador de acordo com o eixo.

- `applyFloorFriction`: Função para adicionar um toque de realidade no movimento do jogador. Ex: Se um carro está se movimentando a 30 km/h e nós começarmos a pressioanr o freio, o cara não vai simplesmente parar e ficar nos 0 km/h, ele vai reduzindo sua velocidade até chegar nos 0 km/h. Essa função basicamente faz isso, reduz a velocidade do jogador até 0 quando não estamos pressionando um botão de movimento.

- `applyPlayerMovement`: Função para adicionar a aceleração ao nosso jogador e simular um efeito real de inicio de movimento, onde começamos da velocidade 0 km/h até o limite máximo do nosso corpo ou veículo.
