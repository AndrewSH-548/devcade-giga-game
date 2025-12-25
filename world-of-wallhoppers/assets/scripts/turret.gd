extends Node2D

@export var location: String = "ground"; ## The turret's location on a wall (ground, wall-left, wall-right, or ceiling)
@export var turret_type: String = "straight"; ## The type of the turret: laser, straight, arc-left, arc-right
@export var bullet_speed = 500; ## The speed of the bullet, (default: 500)
@export var attack_duration = 2; ## the duration of an attack
@export var cooldown_duration = 2; ## The cooldown between attacks
@export var turret_rotation: float = 0; ## The rotation of the turret (in degrees) (default: 0 degrees) TODO: Implement bullets being able to fire at different angles

@onready var turret: AnimatedSprite2D = $TurretHead
@onready var laser_beam: Sprite2D = $TurretHead/LaserBeam
@onready var laser_ball: Sprite2D = $TurretHead/LaserBall

@onready var attack_duration_timer: Timer = $AttackDurationTimer
@onready var cooldown_timer: Timer = $CooldownTimer

@onready var hurtbox: Obstacle = $TurretHead/LaserBeam/Area2D

const BULLET = preload("res://scenes/obstacles/projectiles/bullet.tscn");


var current_state;
var firing = false;
const LASERDURATION = 1; # how long (in seconds) the laser lasts
const LASERCOOLDOWNDURATION = 3;

enum State {
	AIMING,
	COOLDOWN,
	READY,
	FIRE,
}

var laserTween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT_IN);

func _ready() -> void:
	laser_ball.hide();
	laser_beam.hide();
	hurtbox.monitorable = false;
	change_state(State.READY);
	start_projectile_firing_cycle();

func _process(_delta: float) -> void:
	
	match location.to_lower(): # rotates the turret based on the provided location
		"ground":
			rotation_degrees = 0;
		"wall-left":
			rotation_degrees = 90;
		"wall-right":
			rotation_degrees = -90;
		"ceiling":
			rotation_degrees = 180;
		_:
			print_debug("Invalid location for turret" + str(location));
			location = "ground"; # go to ground for default.

	match current_state:
		State.COOLDOWN:
			turret.play("cooldown");
		State.READY:
			turret.play("ready");
		State.AIMING:
			pass;
		State.FIRE:
			if !firing: # only fires the laser if the laser is not already firing
				firing = true;
				fire_laser();

func start_projectile_firing_cycle() -> void: ## continuously fire the respective projectile
	while(true):
		match turret_type.to_lower(): # laser, straight, arc-left, arc-right
			"laser":
				fire_laser();
			"straight":
				fire_projectile_straight();
			"arc-left":
				turret.rotation_degrees = -45;
				fire_projectile_arc("left");
			"arc-right":
				turret.rotation_degrees = 45;
				fire_projectile_arc("right");
		await cooldown_timer.timeout;

func fire_laser() -> void: ## fire laser script
	if(!firing):
		firing = true;
		laser_ball.show();
		laser_ball.scale = Vector2(0, 0);
		if !laserTween.is_valid(): # re-creates tween if it's invalid.
			laserTween.kill();
			laserTween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT_IN);
		laserTween.tween_property(laser_ball, "scale", Vector2(1, 1), 0.5);
		await laserTween.finished; # charge finished
		hurtbox.monitorable = true;
		#SoundManager.laser_fire.play();
		#camera_shake();
		change_state(State.COOLDOWN);
		laser_beam.show();
		attack_duration_timer.start(attack_duration);
		await attack_duration_timer.timeout;
		hide_laser();
		hurtbox.monitorable = false;
		firing = false;
		cooldown_timer.start(cooldown_duration); # start cooldown timer

func fire_projectile_straight() -> void: ## fire a projectile in a straight line
	if(!firing):
		firing = true;
		var bullet = BULLET.instantiate();
		var bullet_position_offset = 40; ## offset the bullet so it looks like it is shooting from the cannon
		bullet.position.y -= bullet_position_offset; # offset the starting bullet position
		match location.to_lower(): # sets the direction of the bullet's movement
			"ground":
				bullet.velocity.y = -bullet_speed;
			"wall-left":
				bullet.velocity.x = bullet_speed;
			"wall-right":
				bullet.velocity.x = -bullet_speed;
			"ceiling":
				bullet.velocity.y = bullet_speed;
			_:
				print_debug("Invalid location for turret" + str(location));
		
		turret.add_child(bullet); # add the bullet as a child of the turret
		bullet.show();
		attack_duration_timer.start(attack_duration);
		change_state(State.COOLDOWN);
		await attack_duration_timer.timeout;
		firing = false;
		cooldown_timer.start(cooldown_duration); # start cooldown timer

func fire_projectile_arc(angle: String) -> void: ## fire a projectile in an arc
	if(!firing):
		firing = true;
		var bullet = BULLET.instantiate();
		var gravity = 9.8;
		bullet.enable_gravity(gravity);
		var bullet_position_offset_y = 60;
		bullet.position.y -= bullet_position_offset_y; # offset the starting bullet position
		match location.to_lower(): # sets the direction of the bullet's movement
			"ground":
				bullet.velocity.y = -bullet_speed;
				if(angle == "left"):
					bullet.velocity.x = -bullet_speed;
				elif(angle == "right"):
					bullet.velocity.x = bullet_speed
			"wall-left":
				if(angle == "left"):
					bullet.velocity.y = -bullet_speed;
				elif(angle == "right"):
					bullet.velocity.y = bullet_speed;
				bullet.velocity.x = bullet_speed;
			"wall-right":
				if(angle == "right"):
					bullet.velocity.y = -bullet_speed;
				elif(angle == "left"):
					bullet.velocity.y = bullet_speed;
				bullet.velocity.x = -bullet_speed;
			"ceiling":
				if(angle == "left"):
					bullet.velocity.x = bullet_speed;
					bullet.velocity.y = bullet_speed;
				elif(angle == "right"):
					bullet.velocity.x = -bullet_speed;
					bullet.velocity.y = bullet_speed;
			_:
				print_debug("Invalid location for turret" + str(location));
		
		turret.add_child(bullet); # add the bullet as a child of the turret
		bullet.show();
		attack_duration_timer.start(attack_duration);
		change_state(State.COOLDOWN);
		await attack_duration_timer.timeout;
		firing = false;
		cooldown_timer.start(cooldown_duration); # start cooldown timer

#func camera_shake() -> void: # shakes the camera
	#var camera = get_tree().get_root().get_node("Game").get_child(0); # get the camera node (using very sloppy code)
	#for i in 8: # move the camera 8 times to make it look like it's shaking.
		#camera.position += Vector2(randi_range(-10, 10), randi_range(-10, 10));
		#await get_tree().create_timer(0.1).timeout;
		#camera.global_position = Globals.ogCameraPosition; # set camera to the origional position
	#camera.global_position = Globals.ogCameraPosition;
	

func hide_laser() -> void: ## hide the laser
	laser_ball.hide();
	laser_beam.hide();
	hurtbox.monitorable = false;

func change_state(next_state) -> void: # changes the state
	current_state = next_state;
	#match current_state: # prints out the changed state
	#	State.READY:
	#		print("Changed Laser state to State.READY");
	#	State.COOLDOWN:
	#		print("Changed Laser state to State.COOLDOWN");
	#	State.AIMING:
	#		print("Changed Laser state to State.AIMING");
	#	State.FIRE:
	#		print("Changed Laser state to State.FIRE");

func set_aiming() -> void: ## if the turret is right clicked(button is masked to right click) in the READY state, then switch to AIMING.
	if (current_state == State.READY):
		change_state(State.AIMING);

func _on_cooldown_timer_timeout() -> void: ## change to READY state once cooldown is finished.
	change_state(State.READY);
