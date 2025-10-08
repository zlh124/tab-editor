# 拍
class_name Beat

extends HBoxContainer

# 音符
var notes: Array[Note]

var beat_no: int

# 1~6弦的纵坐标，创建时由父类传入

# 第一个音符的横坐标，创建时由父类传入
var first_note_y_axis: int
