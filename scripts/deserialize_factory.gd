class_name DeserializeFactory

const fret_mark_res := preload("res://scenes/fret_mark.tscn")
const note_res := preload("res://scenes/note.tscn")
const beat_res := preload("res://scenes/beat.tscn")


static func deserialize_note(data: Dictionary) -> Note:
    var note: Note = note_res.instantiate()
    note.note_no = data['no']
    note.value = data['value']
    note.name = "Note#%d" % note.note_no

    for i in range(6):
        var fret_mark: FretMark = fret_mark_res.instantiate()
        fret_mark.name = "FretMarkString%d" % (i + 1)
        note.add_child(fret_mark)

    var min_string := 6
    for fret in data['frets']:
        min_string = min(fret["string"], min_string)
        var fret_mark: FretMark = note.get_node("FretMarkString%d" % fret['string'])
        fret_mark.set_line_visible(false)
        fret_mark.set_fret_value(fret["fret"])

    # 比最小的小的全部设空，隐藏展位线
    for i in range(1, min_string, 1):
        var fret_mark: FretMark = note.get_node("FretMarkString%d" % i)
        fret_mark.set_fret_value("")
        fret_mark.set_line_visible(false)

    return note

static func deserialize_beat(data: Dictionary) -> Beat:
    var beat: Beat = beat_res.instantiate()
    beat.beat_no = data["no"]
    for note_data in data['notes']:
        var note: Note = deserialize_note(note_data)
        beat.add_child(note)

    return beat