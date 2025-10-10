class_name Bar
extends GridContainer
# 网格容器，直接存储音符

# 小节号
var bar_no: int
# TODO: 和弦
var harmonies: Array
# 拍
var beats: Array[Beat] = []
# 音符数
var note_count: int = 0

@onready var left_border: Line2D = $Frame/LeftBorder
@onready var right_border: Line2D = $Frame/RightBorder
@onready var frame: Node2D = $Frame


func _process(_delta: float):
    # 自适应框线
    var first_note: Note = get_child(note_count)
    
    frame.position = first_note.position

    right_border.points[0].x = size.x
    right_border.points[1].x = size.x
    for i in range(6):
        var line = get_node("Frame/Line%d" % (i + 1))
        line.points[1].x = size.x
