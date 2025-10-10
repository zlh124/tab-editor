extends Node2D

func _ready():
    var json_file := FileAccess.open("resources/simple1.json", FileAccess.READ)
    # print_debug(json_file.get_as_text())
    var data: Dictionary = JSON.parse_string(json_file.get_as_text())
    var tab: Tab = DeserializeFactory.deserialize_tab(data)
    # print_debug(data)
    # var bars_data = data['bars'][0]
    # var beat = DeserializeFactory.deserialize_bar(bars_data)
    add_child(tab)
    tab.position = Vector2(100, 100)
    tab.scale = Vector2(0.5, 0.5)
    json_file.close()
    # var chord_c := DeserializeFactory.deserialize_chord({"id": 1, "name": "C", "position": "1#1"})

    # add_child(chord_c)
    # chord_c.position = Vector2(200, 200)