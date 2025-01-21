extends Node

const GAME: PackedScene = preload("res://Main.tscn")
const MENU: PackedScene = preload("res://scenes/menu/menu.tscn")



func load_game_scene() -> void:
	get_tree().change_scene_to_packed(GAME)


func load_menu_scene() -> void:
	get_tree().change_scene_to_packed(MENU)
