class_name Bar
extends VBoxContainer


# 小节号
var bar_no: int
# TODO: 和弦
var harmonies: Array
# 拍
var beats: Array[Beat]

var note_count: int = 0

@onready var left_border: Line2D = $Frame/LeftBorder
@onready var right_border: Line2D = $Frame/RightBorder
@onready var frame: Node2D = $Frame

@onready var beat_container: HBoxContainer = $BeatContainer


func _process(_delta: float):
    # 自适应框线
    frame.position = beat_container.position

    right_border.points[0].x = beat_container.size.x
    right_border.points[1].x = beat_container.size.x
    for i in range(6):
        var line = get_node("Frame/Line%d" % (i + 1))
        line.points[1].x = beat_container.size.x
