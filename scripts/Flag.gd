extends Node

@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("plant"):
		animation_player.play("plant");

func _on_animation_player_animation_finished(anim_name):
	if anim_name != "plant":
		return
	animation_player.play("RESET")
