class_name Tab
extends Control

var title: String:
    set(value):
        title = value
        get_node(^"Tab/Title").text = value

var signatures: Array:
    set(value):
        signatures = value
        get_node("Tab/Messages/Signatures").text = "\n".join(value)

var authors: Array:
    set(value):
        authors = value
        get_node("Tab/Messages/Authors").text = "\n".join(value)

var lines: Array = []