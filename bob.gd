extends Enemy
class_name Bob

func _init() -> void:
	original_stamina = 20
	stamina = original_stamina
	
	base_delay = 0.2
	
	attack_list = [Slash.new(), Slam.new(), Pierce.new()]
	
	previous_attack = null
