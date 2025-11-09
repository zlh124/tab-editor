# 音符
class_name Note

extends VBoxContainer

var note_no: int

# 时值
var value: int = 8

# 品格标记
@export
var fret_marks: Array[FretMark]

func toggle_note_stem_visible(_visible: bool):
    """设置符杆可见性"""
    get_node(^"AspectRatioContainer/NoteStem").visible = _visible


## 设置时值标记可见性 
func toggle_time_value_marks_visible(time_value: int, direction: String, _visible: bool) -> void:
    var note_mark = get_node("AspectRatioContainer/NoteStem/%dTimeValueMark%s" % [time_value, direction])
    if note_mark == null:
        return
    note_mark.visible = _visible

func set_min_width(width: float):
    custom_minimum_size.x = width

func set_note_alignment(_alignment: int):
    """2: left, 4: center, 8: right"""
    var children = get_children()
    for child in children:
        if "size_flags_horizontal" not in child:
            continue
        child.size_flags_horizontal = _alignment
