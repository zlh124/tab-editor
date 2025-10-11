# 音符
class_name Note

extends VBoxContainer

var note_no: int

# 时值
var value: int = 8

# 品格标记
var fret_marks: Array[FretMark]

func set_note_stem_visibility(val: bool):
    get_node(^"AspectRatioContainer/NoteStem").visible = val

func set_note_marks_visibility(mark_no: int, direction: String, val: bool) -> void:
    var note_mark = get_node("AspectRatioContainer/NoteStem/%dNoteMark%s" % [mark_no, direction])
    if note_mark == null:
        return
    note_mark.visible = val

func set_min_width(width: float):
    custom_minimum_size.x = width
