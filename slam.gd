extends Attack
class_name Slam

func _init() -> void:
	
	attack_name = "slam"
	damage = 20
	
	base_cost = 4
	repeat_cost = -2
	from_different_cost = 3
	
	base_chance = 100
	chance = base_chance
	
	length_of_attack = 45
	length_of_hitting = 25
	parry_timing = [0, 40]
	perfect_parry_timing = [23, 25]
	dodge_timing = [15, 32]
	perfect_dodge_timing = [21, 27]
