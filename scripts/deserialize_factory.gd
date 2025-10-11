class_name DeserializeFactory

const fret_mark_res := preload("res://scenes/fret_mark.tscn")
const note_res := preload("res://scenes/note.tscn")
const beat_res := preload("res://scenes/beat.tscn")
const bar_res := preload("res://scenes/bar.tscn")
const chord_res := preload("res://scenes/chord.tscn")
const tab_res := preload("res://scenes/tab.tscn")

static func deserialize_note(data: Dictionary) -> Note:
    var note: Note = note_res.instantiate()
    note.note_no = data['no']
    note.value = data['value']

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
    var beat: Beat = Beat.new()
    beat.beat_no = data["no"]
    var note_length = len(data['notes'])
    var has_less_time_value_note_right = func(time_value: int, curr_index: int, notes: Array):
        for i in range(curr_index + 1, len(notes)):
            if notes[i]['value'] >= time_value:
                return true
        return false

    var has_less_time_value_note_left = func(time_value: int, curr_index: int, notes: Array):
        for i in range(0, curr_index):
            if notes[i]['value'] >= time_value:
                return true
        return false

    for i in range(note_length):
        var note_data = data['notes'][i]
        var note: Note = deserialize_note(note_data)
        note.value = note_data['value']
        # 如果时值大于4绘制符杆
        if note.value >= 4:
            note.set_note_stem_visibility(true)
        if note.value <= 8:
            note.set_min_width(Constants.fret_mark_size * 2)
        # 如果右侧由与比当前时值更低的绘制右侧
        for limit in [8, 16, 32]:
            if note.value >= limit:
                if has_less_time_value_note_right.call(note.value, i, data['notes']):
                # note.set_note_marks_visibility(limit, "Left", true)
                    note.set_note_marks_visibility(limit, "Right", true)
                if has_less_time_value_note_left.call(note.value, i, data['notes']):
                    note.set_note_marks_visibility(limit, "Left", true)

        note.name = "Note#%d#%d" % [beat.beat_no, note.note_no]
        beat.notes.append(note)

    return beat

static func deserialize_bar(data: Dictionary) -> Bar:
    var bar: Bar = bar_res.instantiate()
    bar.bar_no = data['no']
    # 添加小节
    for beat_data in data["beats"]:
        var beat: Beat = deserialize_beat(beat_data)
        bar.beats.append(beat)
        bar.note_count += len(beat.notes)

    # 设置bar的列数
    bar.get_node("BarContainer").columns = bar.note_count

    # 添加和弦
    var chords: Dictionary = {}
    for chord_data in data["chords"]:
        var chord: Chord = deserialize_chord(chord_data)

        chords[chord_data['position']] = chord


    # 添加音符
    var beat_index = 0
    for i in range(len(bar.beats)):
        var beat: Beat = bar.beats[i]
        for j in range(len(beat.notes)):
            var note: Note = beat.notes[j]
            bar.set_node_at(1, beat_index, note)
            var pos = "%d#%d" % [i + 1, j + 1]
            if chords.has(pos):
                var chord: Chord = chords[pos]
                bar.set_node_at(0, beat_index, chord)
            beat_index += 1

    return bar

static func deserialize_chord(data: Dictionary) -> Chord:
    var chord: Chord = chord_res.instantiate()
    chord.name = data['name'] + "At%s" % data['position']

    var chords_file = FileAccess.open("res://resources/chords.json", FileAccess.READ)
    var chords_data: Array = JSON.parse_string(chords_file.get_as_text())
    chords_file.close()

    var target_chord_data = null

    for chord_data in chords_data:
        if chord_data['id'] == data['id']:
            target_chord_data = chord_data
            break

    if target_chord_data == null:
        # 和弦定义被删除了
        push_error("chord %s undefined" % data['name'])
        return null

    # 绘制和弦
    chord.get_node("Name").text = target_chord_data['name']
    var start_fret = target_chord_data['startFret']
    chord.get_node("StartFret").text = "" if start_fret == 0 else String(start_fret)
    for i in range(len(target_chord_data['outOfChordToneMark'])):
        if target_chord_data['outOfChordToneMark'][i] == '1':
            chord.get_node("OutOfChordTonesMarks/OutOfChordTonesMark#%d" % i).text = '✕'
    for finger_marks_pos in target_chord_data['fingerMarks']:
        var finger_mark: TextureRect = chord.get_node("FingerMarks/FingerMark#%s" % finger_marks_pos)
        finger_mark.self_modulate = Color.BLACK

    return chord

static func deserialize_tab(data: Dictionary) -> Tab:
    var tab: Tab = tab_res.instantiate() as Tab

    tab.set_title(data['title'])
    tab.set_signatures(data['signatures'])
    tab.set_authors(data['authors'])

    for bars_data in data['bars']:
        var bar: Bar = deserialize_bar(bars_data)
        tab.get_node("MarginContainer/Bars").add_child(bar)
    return tab
