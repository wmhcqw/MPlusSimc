extends Player

class_name Healer

func heal(obj: Player):
	obj.health = min(obj.health + 10, obj.MAX_HEALTH)
	print(obj.health)
	return true
	
func disple(obj: Player):
	obj.harmful = 0
	print(obj.harmful)
	return true

func attack(obj: Player):
	if obj.is_friend:
		return false # cast failed
	else:
		obj.health -= 1
		return true

func _ready():
	super._ready()
	spell_list = ["heal", "disple", "attack"]
	spell_cds = [0.5, 8, 0.5]
	role = "healer"
