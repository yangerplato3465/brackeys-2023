extends Camera2D

var shakeStrength = 0
var shakeDecay = 10.0
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	SignalManager.connect("screenShake", self, "applyShake")

func _process(delta):
	shakeStrength = lerp(shakeStrength, 0, shakeDecay * delta)
	offset = getRandomOffset()

func getRandomOffset():
	return Vector2(
		rng.randf_range(-shakeStrength, shakeStrength),
		rng.randf_range(-shakeStrength, shakeStrength)		
	)

func applyShake(strength):
	shakeStrength = strength
