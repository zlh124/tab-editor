class_name Bar
extends CenterContainer
# 网格容器，直接存储音符

# 小节号
var bar_no: int
# TODO: 和弦
var harmonies: Array
# 拍
var beats: Array[Beat] = []
# 音符数
var note_count: int = 0

@onready var left_border: Line2D = $Frame/LeftBorder as Line2D
@onready var right_border: Line2D = $Frame/RightBorder as Line2D
@onready var frame: Node2D = $Frame as Node2D


func _process(_delta: float):
    # 自适应框线
    var first_note := get_node("BarContainer").get_child(note_count) as Note
    #var note_size := first_note.size

    frame.position = first_note.position

    var harf_cell := Constants.fret_mark_size/2.0
    left_border.points[0].y = harf_cell
    right_border.points[0].y = harf_cell

    left_border.points[1].y = harf_cell + Constants.fret_mark_size * 5
    right_border.points[1].y = harf_cell + Constants.fret_mark_size * 5

    right_border.points[0].x = size.x
    right_border.points[1].x = size.x

    for i in range(6):
        var line := get_node("Frame/Line%d" % (i + 1)) as Line2D
        line.points[0].y = harf_cell + i * Constants.fret_mark_size
        line.points[1].y = harf_cell + i * Constants.fret_mark_size
        line.points[1].x = size.x

func set_node_at(row: int, col: int, node: Node):
    if node == null:
        push_error("node going to set is null")
        return
    var bar_container := get_node("BarContainer") as GridContainer
    while bar_container.get_child_count() < note_count * (row + 1):
        for i in range(note_count):
            var container := Container.new()
            @warning_ignore("integer_division")
            var row_index = bar_container.get_child_count() / note_count
            container.name = "Container#%d#%d" % [row_index, i]
            bar_container.add_child(container)
    var old_node = bar_container.get_child(row * note_count + col)
    old_node.free()
    bar_container.add_child(node)
    bar_container.move_child(node, row * note_count + col)
