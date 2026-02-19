extends Node
class_name BulletPool

var bulletScene := preload("res://Scene/bullet.tscn")
var enemieBulletPoolAmount := 100
var enemieBulletPool := []
var playerBulletPoolAmount := 100
var playerBulletPool := []





func generateEnemieBulletPool():
	for i in range(enemieBulletPoolAmount):
		var bulletInstance = bulletScene.instantiate()
		self.add_child(bulletInstance)
		bulletInstance.visible = false
		bulletInstance.releaseBullet.connect(release_ennemie_bullet)
		bulletInstance.process_mode = Node.PROCESS_MODE_DISABLED
		bulletInstance.global_position = Vector3(0, -5000, 0)
		enemieBulletPool.append(bulletInstance)
		

func get_enemie_bullet() -> Node3D:
	var bullet = enemieBulletPool.pop_back()
	bullet.visible = true
	bullet.activated = true
	bullet.process_mode = Node.PROCESS_MODE_INHERIT
	return bullet
	
func generatePlayerBulletPool():
	for i in range(playerBulletPoolAmount):
		var bulletInstance = bulletScene.instantiate()
		bulletInstance.visible = false
		bulletInstance.releaseBullet.connect(release_player_bullet)
		bulletInstance.process_mode = Node.PROCESS_MODE_DISABLED
		self.add_child(bulletInstance)
		playerBulletPool.append(bulletInstance)
		

func get_player_bullet() -> Node3D:
	for i in range(playerBulletPool.size() - 1, -1, -1):
		var bullet = playerBulletPool[i]
		if not bullet.activated:
			playerBulletPool.remove_at(i)
			bullet.visible = true
			bullet.collision.disabled = false
			bullet.activated = true
			bullet.process_mode = Node.PROCESS_MODE_INHERIT
			return bullet
	# Si aucune bullet dispo
	return null
		
	
func release_ennemie_bullet(bullet):
	call_deferred("deactivate_enemie_bullet", bullet)
	enemieBulletPool.append(bullet)
	
func release_player_bullet(bullet):
	call_deferred("deactivate_player_bullet", bullet)
	playerBulletPool.append(bullet)
	
func deactivate_enemie_bullet(bullet):	
	bullet.visible = false
	bullet.collision.disabled = false
	bullet.activated = false
	bullet.process_mode = Node.PROCESS_MODE_DISABLED
	
func deactivate_player_bullet(bullet):
	bullet.visible = false
	bullet.activated = false
	bullet.collision.disabled = true
	bullet.target_node = null
	bullet.parent_node = null
	bullet.process_mode = Node.PROCESS_MODE_DISABLED
