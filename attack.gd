extends Object
class_name Attack

var attack_name: String			 	#name of an attack

var damage							#damage of an attack

var base_cost: int  				#base cost of an attack
var repeat_cost: int 	 			#additional cost when attacking after the same attack
var from_different_cost: int 	 	#additional cost when attacking after a different attack

var base_chance: int 	 			#chance for an enemy to use the attack this one is stays the same the whole time
var chance: int = base_chance 		#chance for an enemy to use the attack this one is going to be modified

var attack_gap_list: Array = [] 	#specified by the attacker

var length_of_attack: int			#how many frames will the attack take
var length_of_hitting: int			#in how many frames the attack will colide with the player character
var parry_timing: Array				#frames when you can perform a parry
var perfect_parry_timing: Array 	#frames when you can perform a perfect parry
var dodge_timing: Array 			#frames when you can perform a dodge
var perfect_dodge_timing: Array 	#frames when you can perform a perfect dodge
var block_timing: Array 			#frames when you will perform a block insted of parry(may delete in the future in favor of letting this be calculated based on parry/perfect parry timing)


func calculate_cost(gap_length_modifier: float, previous_attack: Attack) -> float: 						#function to calculate the cost of an attack in stamina
	if previous_attack == null:
		return base_cost * gap_length_modifier
	elif previous_attack.get_script() == self.get_script():
		return (base_cost + repeat_cost) * gap_length_modifier
	else:
		return (base_cost + from_different_cost) * gap_length_modifier		

func check_dodge(frame: int) -> int:																	#function to check if you succesfully dodged the attack
	if frame>=perfect_dodge_timing[0] and frame<=perfect_dodge_timing[1]: return 1
	elif frame>=dodge_timing[0] and frame<=dodge_timing[1]: return 0
	else: return -1
	
func check_parry(frame: int) -> int:																	#function to check if you succesfullt parried the attack
	if frame>=perfect_parry_timing[0] and frame<=perfect_parry_timing[1]: return 1
	elif frame>=parry_timing[0] and frame<=parry_timing[1]: return 0
	else: return -1

func change_chance(amount: float) -> void: 																#the enemy will change the chances of an attack during his turn
	chance += amount

func reset_chance() -> void: 																			#the reset for the chance
	chance = base_chance

func get_chance(): return chance
func get_name(): return attack_name
func get_length(): return length_of_attack
