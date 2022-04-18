extends Control

var count := {
	"life": {"0": 30, "1": 0},
	"rock": {"0": 0, "1": 0},
	"fire": {"0": 0, "1": 0}
}


func _ready():
	update()

func update():
	$HBox/VBoxLife/CollectionItem.ammount = count["life"]["0"]
	$HBox/VBoxLife/CollectionItem.update()
	$HBox/VBoxLife/CollectionItem2.ammount = count["life"]["1"]
	$HBox/VBoxLife/CollectionItem2.update()
	$HBox/VBoxRock/CollectionItem.ammount = count["rock"]["0"]
	$HBox/VBoxRock/CollectionItem.update()
	$HBox/VBoxRock/CollectionItem2.ammount = count["rock"]["1"]
	$HBox/VBoxRock/CollectionItem2.update()
