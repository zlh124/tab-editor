extends Node2D

func _ready():
    var json_file := FileAccess.open("resources/simple1.json", FileAccess.READ)
    # print_debug(json_file.get_as_text())
    var data: Dictionary = JSON.parse_string(json_file.get_as_text())
    print_debug(data)
    var bars_data = data['bars'][0]
    var beat = DeserializeFactory.deserialize_bar(bars_data)
    add_child(beat)