extends Object
class_name Enemy

var original_stamina: float 	 													#max stamina of an enemy
var stamina = original_stamina 														#current stamina of an enemy

var base_delay: float	 															#base delay between attacks

var very_short_gap = {"preference": 70, "cost_modifier": 4, "name": "very fast"}	#every gap is defined by the enemy preference, modifier to the cost in stamina, name(optional) and modifier to the gap length
var short_gap = {"preference": 50, "cost_modifier": 2, "name": "fast"}
var normal_gap = {"preference": 40, "cost_modifier": 1, "name": "normal"}
var long_gap = {"preference": 35, "cost_modifier": 0.5, "name": "slow"}

var attack_gap_list: Array = [long_gap, normal_gap, short_gap, very_short_gap]		#list of every possible gap(in theory we could make it radom but for now it is like this)

var attack_list: Array																#list of every possible attack the enemy has

var previous_attack: Attack 														#stored last attack the enemy made


func calculate_points() -> Array:													#based on calculated cost and factors like current stamina, preference and chance to use an attack this will calculate how much points each attack will get, the one with the most points will become the attack enemy does
	var point_list = []
	var random = RandomNumberGenerator.new()
	
	for attack in attack_list:
		for gap in attack_gap_list:
			var cost = attack.calculate_cost(gap.get("cost_modifier"), previous_attack)
			var points = (attack.get("chance") * gap.get("preference") * (stamina - cost)) / (original_stamina * random.randf_range(0.4, 3))
			point_list.append([gap, attack, points])
				
	if point_list.is_empty():
		return []
		
	point_list.sort_custom(func(x, y): return x[2] > y[2])
	var best_attack = point_list[0]
	
	stamina -= best_attack[1].calculate_cost(best_attack[0].get("cost_modifier"), previous_attack)
	previous_attack = best_attack[1]
	
	best_attack[1].change_chance(-20)
	for other_attack in attack_list:
		if other_attack != best_attack[1]:
			other_attack.change_chance(25)
			
	return point_list[0]


func make_attack(attack_type, gap_length):											#this will come from the game master and will make the attacker attack
	print(gap_length.get("name"), " ", attack_type.get_name(), " | Remaining Stamina: ", stamina)



func reset_state():																	#at the end of the turn stamina and attack chances will be reset
	stamina = original_stamina
	previous_attack = null
	for attack in attack_list:
		attack.reset_chance()

func has_stamina(): return stamina > 0
	
func get_stamina(): return stamina
func get_base_delay(): return base_delay
func get_attack_gap_list(): return attack_gap_list
