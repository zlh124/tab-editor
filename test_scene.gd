extends ScrollContainer


func _ready():
    test_bar()
    # test_tab()

func init_data(json_path: String = 'resources/simple.json') -> Variant:
    var json_file := FileAccess.open(json_path, FileAccess.READ)
    var data = JSON.parse_string(json_file.get_as_text())
    json_file.close()
    return data


func test_tab():
    var data = init_data()
    var tab: Tab = DeserializeFactory.deserialize_tab(data)
    # print_debug(data)
    # var bars_data = data['bars'][0]
    # var beat = DeserializeFactory.deserialize_bar(bars_data)
    add_child(tab)

func test_bar():
    var data = init_data()
    var bar: Bar = DeserializeFactory.deserialize_bar(data['bars'][3])
    add_child(bar)