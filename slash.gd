extends Attack
class_name Slash

func _init() -> void:
	
	attack_name = "slash"
	damage = 10
	
	base_cost = 2
	repeat_cost = 0
	from_different_cost = 1
	
	base_chance = 55
	chance = base_chance
	
	length_of_attack = 30
	length_of_hitting = 15
	parry_timing = [0, 25]
	perfect_parry_timing = [14, 15]
	dodge_timing = [10, 20]
	perfect_dodge_timing = [13, 17]
