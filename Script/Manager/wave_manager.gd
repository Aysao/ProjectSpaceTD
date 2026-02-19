extends Node3D

@export var current_wave := 0
@export var group_count := 0
@export var current_wave_enemies_count := 0
@export var max_groupe := 5
@export var current_enemies_on_field := 0
var current_groupe_index := 0
var is_wave_waiting_group := false

@export var boss_cycle := 10
@export var overflow_multiplier := 0.6
@export var time_between_wave := 5.0

var current_budget := 0.0
var max_enemy := 0
var min_cost := 999.0
var overflow_budget := 0
var stats_boost_multiplier := 1.0
var current_enemy_race := EnemyReference.EnemyRace.PIRATE
var ennemy_available := []
var current_wave_ennemy := []
var current_wave_group_enemy := []
var timer_on := false
var last_second := 0
var message_next_wave := "NEXT WAVE %d \n%d Seconde remaining"

var random_cooldown_between_group := 0.0

@onready var enemiesSpawnMarker := $"../EnemiesSpawnMarker"
@onready var wave_timer := $Timer

func _process(delta: float) -> void:
	if timer_on and last_second > int(wave_timer.time_left):
		last_second = int(wave_timer.time_left)
		EventBus.send_message.emit(message_next_wave % [current_wave,last_second])
	if random_cooldown_between_group > 0.0:
		random_cooldown_between_group -= delta
	if random_cooldown_between_group < 0.0 and is_wave_waiting_group : 
		group_spawn()

func next_wave():
	current_wave += 1
	reset_wave_state()
	print("current_wave_ennemy count : %d " % current_wave_ennemy.size())
	if current_wave % boss_cycle > 0:
		max_enemy = 5+current_wave*1.2
		current_budget = pow(current_wave,1.2)
		ennemy_preparation()
		define_current_ennemy_wave()
		overflow_budget_calc()
		get_enemies_in_group()
	else :
		max_enemy = 1
		current_budget = pow(current_wave,1.8)
		ennemy_preparation()
		define_current_ennemy_wave()
		overflow_budget_calc()
		
	timer_on = true
	last_second = time_between_wave
	wave_timer.start(time_between_wave)
	EventBus.send_message.emit(message_next_wave.replace("{timer}",str(last_second)))

func launch_wave():
	next_wave()

func ennemy_preparation():
	var enemy_from_race_list = EnemyReference.enemyType[current_enemy_race]
	for key in enemy_from_race_list:
		var enemy = enemy_from_race_list[key]
		if enemy["min_wave"] <= current_wave and enemy["danger_cost"] <= current_budget:
			if min_cost > enemy["danger_cost"]:
				min_cost = enemy["danger_cost"]
			ennemy_available.append(enemy)
		

func define_current_ennemy_wave():
	var budget_count = current_budget
	var enemy_count = 0
	while budget_count >= min_cost and enemy_count < max_enemy:
		var random_enemy = get_random_enemy()
		budget_count -= random_enemy["danger_cost"]
		enemy_count += 1
		current_wave_ennemy.append(random_enemy)
	overflow_budget = budget_count
	current_wave_enemies_count = current_wave_ennemy.size()
		
func overflow_budget_calc():
	if overflow_budget > 0:
		stats_boost_multiplier = 1.0 + pow(overflow_budget / current_budget, overflow_multiplier)
		

func get_enemies_in_group():
	group_count = randi_range(1,clamp(current_wave_enemies_count,1,5))
	var amount_per_group := ceili(float(current_wave_ennemy.size())/group_count)
	
	var min_index := 0
	var max_index := amount_per_group
	
	if amount_per_group < current_wave_ennemy.size():
		for i in range(group_count):
			current_wave_group_enemy.append(current_wave_ennemy.slice(min_index, max_index))
			print(" ------------ GROUPE ENNEMY %d ---------------" % i)
			print(" Enemy count for this group : %d " % current_wave_group_enemy[i].size())
			print(current_wave_group_enemy[i])
			min_index = max_index
			if current_wave_ennemy.size() - 1 - max_index + amount_per_group > amount_per_group:
				max_index = clamp(max_index+amount_per_group, min_index, current_wave_ennemy.size() )
			else :
				max_index = current_wave_ennemy.size()
				print("index max : %d / %d on %d iteration" % [max_index,current_wave_ennemy.size(), i])
	else :
		current_wave_group_enemy.append(current_wave_ennemy)

	print(" ------------ ALL ENNEMY ---------------")
	print(current_wave_ennemy)

func get_random_enemy() -> Dictionary: 
	var in_random_enemy = []
	var result = 0.0
	for enemy in ennemy_available:
		if enemy["danger_cost"] <= current_budget:
			in_random_enemy.append(enemy)
			result += enemy["spawn_weight"]
	
	var spawn_weight = randf() * result
	for enemy in in_random_enemy:
		spawn_weight -= enemy["spawn_weight"]
		
		if spawn_weight <= 0:
			return enemy
	
	return in_random_enemy[-1]
	


func set_enemy_race(enemyRace):
	current_enemy_race = enemyRace

func setup_wave_manager():
	EventBus.on_enemie_death.connect(current_wave_enemies_calculation)

func reset_wave_state():
	group_count = 0
	current_wave_enemies_count = 0
	current_enemies_on_field = 0
	current_groupe_index = 0
	random_cooldown_between_group = 0.0
	is_wave_waiting_group = false
	current_wave_ennemy.clear()
	current_wave_group_enemy.clear()

func current_wave_enemies_calculation(value):
	if value > 0:
		EventBus.update_material.emit(value)
	current_enemies_on_field -= 1
	current_wave_enemies_count -= 1
	
	print('---------------- %d ENEMY REMAINING TO END THIS WAVE ' % current_wave_enemies_count)
	if(current_wave_enemies_count < 1):
		next_wave()

func group_spawn():
	EventBus.start_spawn.emit(current_wave_group_enemy[current_groupe_index])
	current_enemies_on_field += current_wave_group_enemy[current_groupe_index].size()
	current_groupe_index = clamp(current_groupe_index + 1, 0 , group_count+1)
	if current_groupe_index < group_count:
		is_wave_waiting_group = true
		random_cooldown_between_group = randf_range(1.0,10.0)
	else: 
		is_wave_waiting_group = false

func _on_timer_timeout() -> void:
	timer_on = false
	EventBus.close_display.emit()
	group_spawn()
	pass # Replace with function body.
