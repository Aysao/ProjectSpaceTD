extends Node
class_name EnemyReference

enum EnemyRace {
	PIRATE,
	REPUBLIC,
	COVETER
}

const enemyType := {
	EnemyRace.PIRATE : {
		"BaseShip" : {
			"name" : "base_pirate_ship",
			"spawn_weight": 1.0,
			"danger_cost": 1,
			"reward" : 1,
			"min_wave" : 1,
			"scene" : "res://Scene/Enemies/pirateSpaceShip.tscn"
		},
	},
	EnemyRace.REPUBLIC : {
		
	},
	EnemyRace.COVETER : {
		
	}
}
