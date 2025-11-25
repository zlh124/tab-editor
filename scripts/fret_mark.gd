class_name FretMark

extends Label

#################################
#  default a line in the middle #
#  numbers and X for frets      #
#################################


var mark_value: String:
    set(value):
        mark_value = value.strip_escapes().left(4)
        text = value

func toggle_line_visible(_visible: bool) -> void:
    get_node("LineBetweenFrets").visible = _visible
