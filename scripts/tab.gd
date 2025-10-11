class_name Tab
extends VBoxContainer

var title: String = ""
var signatures: Array = []
var authors: Array = []
var lines: Array = []

func set_title(_title: String):
    self.title = _title
    get_node("Title").text = _title

func set_signatures(_signatures: Array):
    self.signatures = _signatures
    get_node("Messages/Signatures").text = "\n".join(_signatures)

func set_authors(_authors: Array):
    self.authors = _authors
    get_node("Messages/Authors").text = "\n".join(_authors)
