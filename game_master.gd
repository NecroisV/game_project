extends Node

var enemies: Array = [Bob.new()]												#list af all enemies attacking the player
var enemies_stamina: Array = []													#list that stores enemies stamina for the purpouse of choosing the attacker

var previous_attacker = null													#stores information about which enemy attacked just before(may change to object reference)
var repeat_multiplier: float = 3												#determines how likely the enemy will attack in a row

var frame: int = 0																#tells game master what frame of attack the enemy is on
var elapsed_time: float = 0														#used to get the frame

var attack_in_progress: bool = false 											#used for parry/dodge check
var attack_just_started: bool = false											#used for frame counting and reseting action_performed at the start of each enemy attack
var current_attack: Attack														#tells game master what attack the enemy is performing

var action_performed = -1														#stores what you have done and prevents you from spamming parry/dodge

func count_array(array):
	var count = 0.0
	for i in array:
		count = count + i
	return count>0


func attack_player():															#based on enemy stamina levels determines which enemy will attack the player and what attack he will use
	previous_attacker = -1
	enemies_stamina.clear()
	for enemy in enemies:
		enemies_stamina.append(max(0, enemy.get_stamina()))
		
	var random = RandomNumberGenerator.new()
	while count_array(enemies_stamina):
		var attacker = enemies[random.rand_weighted(enemies_stamina)]
		var attack = attacker.calculate_points()
		current_attack = attack[1]
		
		var delay = attacker.get_base_delay() / attack[0].get("cost_modifier")
		await get_tree().create_timer(delay).timeout
		
		attack_in_progress = true
		attack_just_started = true
		
		await attacker.make_attack(attack[1], attack[0])
		await get_tree().create_timer(attack[1].get_length()*1.0/60).timeout	#later will be deleted possibly
		
		attack_in_progress = false
		
		if action_performed == -1:
			print("FAIL")
			action_performed = -2
		
		previous_attacker = attacker
		
		enemies_stamina.clear()
		for e in enemies:
			enemies_stamina.append(max(0, e.get_stamina()))
		if previous_attacker != null:
			enemies_stamina[enemies_stamina.find(previous_attacker)] *= repeat_multiplier
				
	print("NO STAMINA")


func reset_enemies():															#after the end of a turn all enemies that are alive are going to be reset(chances of an attack, stamina, posture(idk about this one))
	for enemy in enemies:
		await enemy.reset_state()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(2):
		await attack_player()
		await reset_enemies()
		print("===========")
		await get_tree().create_timer(5).timeout


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	elapsed_time += delta
	if attack_just_started:
		action_performed = -1
		frame = 0
		attack_just_started = false
		
	if Input.is_action_pressed("dodge") and action_performed== -1:
		print("You try to DODGE")
		if attack_in_progress:
			if current_attack.check_dodge(frame) == -1:
				print("FAIL")
				action_performed = 0
			elif current_attack.check_dodge(frame) == 0:
				print("NORMAL DODGE")
				action_performed = 1
			else:
				print("PERFECT DODGE")
				action_performed = 2
	
	if Input.is_action_pressed("parry") and action_performed== -1:
		print("You try to PARRY")
		if attack_in_progress:
			if current_attack.check_parry(frame) == -1:
				print("FAIL")
				action_performed = 0
			elif current_attack.check_parry(frame) == 0:
				print("NORMAL PARRY")
				action_performed = 3
			else:
				print("PERFECT PARRY")
				action_performed = 4
		
	if elapsed_time >= 1.0/60:
		elapsed_time = 0
		frame += 1


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_SPACE:
			print("SPACE")
