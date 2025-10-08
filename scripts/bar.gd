class_name Bar
extends Node2D


# 小节号
var bar_no: int
# TODO: 和弦
var harmonies: Array
# 拍
var beats: Array[Beat]

@onready var left_border: Line2D = $Frame/LeftBorder
@onready var right_border: Line2D = $Frame/RightBorder

@onready var container: HBoxContainer = $HBoxContainer

func _process(_delta: float):
    right_border.points[0].x = container.size.x
    right_border.points[1].x = container.size.x
    for i in range(6):
        var line = get_node("Frame/Line%d" % (i + 1))
        line.points[1].x = container.size.x