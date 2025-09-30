class_name Bar
extends Node2D

@export
var line_height: int = 64 * 5
# 应该由音符计算得出
var line_length: int

# 小节号
var bar_no: int
# TODO: 和弦
var harmonies: Array
# 拍
var beats: Array[Beat]

    
func _ready():
    const beat_data = {
                    "no": 1,
                    "notes": [
                        {
                            "no": 1,
                            "value": 16,
                            "frets": [
                                {
                                    "string": 5,
                                    "fret": "<12>"
                                }
                            ]
                        },
                        {
                            "no": 2,
                            "fret": - 1,
                            "value": 16,
                            "frets": [
                                {
                                    "string": 4,
                                    "fret": "(15)"
                                }
                            ]
                        },
                        {
                            "no": 3,
                            "fret": - 1,
                            "value": 16,
                            "frets": [
                                {
                                    "string": 3,
                                    "fret": "X"
                                }
                            ]
                        },
                        {
                            "no": 4,
                            "fret": - 1,
                            "value": 16,
                            "frets": [
                                {
                                    "string": 5,
                                    "fret": "X"
                                }
                            ]
                        }
                    ]
                }
    
    var beat = DeserializeFactory.deserialize_beat(beat_data)
    add_child(beat)