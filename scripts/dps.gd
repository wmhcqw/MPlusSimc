extends Player

class_name DPS
	

func attack(obj: Player):
	if obj.is_friend:
		return false # cast failed
	else:
		obj.health -= 1
		return true

func stun(obj: Player):
	obj.harmful = 0
	print(obj.harmful)
	return true
	
func kick(obj: Player):
	return true

func _ready():
	spell_list = ["attack", "stun", "kick"]
	spell_cds = [0.5, 30, 15]
	role = "dps"

