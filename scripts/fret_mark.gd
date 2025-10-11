class_name FretMark

extends Label


func set_fret_value(value: String) -> void:
    value = value.strip_escapes()
    text = value

func set_line_visible(value: bool) -> void:
    get_node("LineBetweenFrets").visible = value
