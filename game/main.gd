extends Node2D

@export var dad_scene: PackedScene



var keys = ["w", "a", "s", "d" ]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var dad = dad_scene.instantiate();
	dad.position = Vector2(200,200)
	dad.up = get_button()
	dad.down = get_button()
	dad.left = get_button()
	dad.right = get_button()
	add_child(dad)
	
func get_button() -> String:
	var key;
	var keys_index = randi_range(0, keys.size() - 1);
	key = keys[keys_index]
	keys.remove_at(keys_index)
	return key;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
