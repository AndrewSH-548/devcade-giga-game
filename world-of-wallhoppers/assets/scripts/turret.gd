extends Node2D

@export var location: String = "ground"; ## The turret's location on a wall (ground, wall-left, wall-right, or ceiling)
@export var turret_type: String = "straight"; ## The type of the turret: laser, straight, arc
@export_range(0.0, 360.0,  45.0) var turret_rotation: float = 0.1; ## The turret's rotation (in degrees) (if at default value [0.1], will rotate the turret in the direction it is located.
@export var bullet_speed = 500; ## The speed of the bullet, (default: 500)
@export var attack_duration = 2; ## the duration of an attack
@export var cooldown_duration = 2; ## The cooldown between attacks

@onready var turret: AnimatedSprite2D = $TurretHead
@onready var laser_beam: Sprite2D = $TurretHead/LaserBeam
@onready var laser_ball: Sprite2D = $TurretHead/LaserBall

@onready var rotation_circle: Sprite2D = $RotationCircle
@onready var attack_duration_timer: Timer = $AttackDurationTimer
@onready var cooldown_timer: Timer = $CooldownTimer

@onready var hurtbox: Obstacle = $TurretHead/LaserBeam/Area2D

const BULLET = preload("res://scenes/obstacles/projectiles/bullet.tscn");

const PROJECTILE_GRAVITY = 19.6; ## the gravity for projectiles

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

func _ready() -> void:
	rotation_circle.hide();
	laser_ball.hide();
	laser_beam.hide();
	hurtbox.monitorable = false;
	change_state(State.READY);
	
	match location.to_lower(): # rotates the turret based on the provided location
		"ground":
			rotation_degrees = 0;
			if(turret_rotation == 0.1):
				turret_rotation = 0.0;
			turret.rotation_degrees = turret_rotation;
		"wall-left":
			rotation_degrees = 90;
			if(turret_rotation == 0.1):
				turret_rotation = 90.0;
			turret.rotation_degrees = turret_rotation - 90;
		"wall-right":
			rotation_degrees = -90;
			if(turret_rotation == 0.1):
				turret_rotation = 270.0;
			turret.rotation_degrees = turret_rotation - 270;
		"ceiling":
			rotation_degrees = 180;
			if(turret_rotation == 0.1):
				turret_rotation = 180.0;
			turret.rotation_degrees = turret_rotation - 180;
		_:
			print_debug("Invalid location for turret" + str(location));
			location = "ground"; # go to ground for default.
	
	start_projectile_firing_cycle();

func _process(_delta: float) -> void:
	
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
			"arc":
				fire_projectile_arc();
		await cooldown_timer.timeout;

func fire_laser() -> void: ## fire laser script
	if(!firing):
		firing = true;
		laser_ball.show();
		laser_ball.scale = Vector2(0, 0);
		var laserTween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT_IN);
		laserTween.tween_property(laser_ball, "scale", Vector2(1, 1), 0.5);
		await laserTween.finished; # charge finished
		laserTween.kill();
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

func fire_projectile_straight() -> void: ## fire a projectile in a straight line TODO: Make it work at 45deg angles
	if(!firing):
		firing = true;
		var bullet = BULLET.instantiate();
		var bullet_position_offset = 40; ## offset the bullet so it looks like it is shooting from the cannon
		bullet.position.y -= bullet_position_offset; # offset the starting bullet position
		match turret_rotation: # sets the direction of the bullet
			0.0:
				bullet.velocity.y = -bullet_speed;
			45.0:
				bullet.velocity.y = -bullet_speed;
				bullet.velocity.x = bullet_speed
			90.0:
				bullet.velocity.x = bullet_speed;
			135.0:
				bullet.velocity.y = bullet_speed;
				bullet.velocity.x = bullet_speed;
			180.0:
				bullet.velocity.y = bullet_speed;
			225.0:
				bullet.velocity.y = bullet_speed;
				bullet.velocity.x = -bullet_speed;
			270.0:
				bullet.velocity.x = -bullet_speed;
			315.0:
				bullet.velocity.y = -bullet_speed;
				bullet.velocity.x = -bullet_speed;
			360.0:
				bullet.velocity.y = -bullet_speed;
			_:
				print_debug("Invalid rotation for turret" + str(turret_rotation));
		
		turret.add_child(bullet); # add the bullet as a child of the turret
		bullet.show();
		attack_duration_timer.start(attack_duration);
		change_state(State.COOLDOWN);
		await attack_duration_timer.timeout;
		firing = false;
		cooldown_timer.start(cooldown_duration); # start cooldown timer

func fire_projectile_arc() -> void: ## fire a projectile in an arc
	if(!firing):
		firing = true;
		var bullet = BULLET.instantiate();
		var gravity = PROJECTILE_GRAVITY;
		bullet.enable_gravity(gravity);
		var bullet_position_offset_y = 60;
		bullet.position.y -= bullet_position_offset_y; # offset the starting bullet position
		match turret_rotation: # sets the direction of the bullet
			0.0:
				bullet.velocity.y = -bullet_speed;
			45.0:
				bullet.velocity.y = -bullet_speed;
				bullet.velocity.x = bullet_speed
			90.0:
				bullet.velocity.x = bullet_speed;
			135.0:
				bullet.velocity.y = bullet_speed;
				bullet.velocity.x = bullet_speed;
			180.0:
				bullet.velocity.y = bullet_speed;
			225.0:
				bullet.velocity.y = bullet_speed;
				bullet.velocity.x = -bullet_speed;
			270.0:
				bullet.velocity.x = -bullet_speed;
			315.0:
				bullet.velocity.y = -bullet_speed;
				bullet.velocity.x = -bullet_speed;
			360.0:
				bullet.velocity.y = -bullet_speed;
			_:
				print_debug("Invalid rotation for turret" + str(turret_rotation));
		
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
