extends Node

# --------------------- RESOURCES MANAGER --------------------- #

signal update_material(value_to_update : int);
signal update_galaxium(value_to_update : float);
signal update_galaxium_rate(value_to_update : float);


# -------------------------- HUD EVENT ------------------------ #

signal send_message(message : String)
signal close_display()
signal building_mode(is_building_mode: bool)


# ----------------------- ENEMY MANAGER ----------------------- #

signal relocate_enemy_closest_target()
signal spawn_enemie_group(enemie_list : Array, position: Vector3)
signal start_spawn(enemie_list : Array)
signal on_enemie_death(value)

# ------------------------- MENU MANGER ----------------------- #

signal back_to_menu()
signal end_of_run()
signal replay()

# ---------------------- PLACEMENT EVENT ---------------------- #

signal cancel_placement()
