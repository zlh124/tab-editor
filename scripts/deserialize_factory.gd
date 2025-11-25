class_name DeserializeFactory

const fret_mark_res := preload("res://scenes/fret_mark.tscn")
const note_res := preload("res://scenes/note.tscn")
const beat_res := preload("res://scenes/beat.tscn")
const bar_res := preload("res://scenes/bar.tscn")
const chord_res := preload("res://scenes/chord.tscn")
const tab_res := preload("res://scenes/tab.tscn")

## 构建音符
static func deserialize_note(data: Dictionary) -> Note:
    """生成音符"""
    var note: Note = note_res.instantiate()
    note.note_no = data['no']
    note.value = data['value']

    var min_string := 5
    for i in len(data['frets']):
        var fret_value: String = data['frets'][i]
        var fret_mark: FretMark = note.fret_marks[i]
        if fret_value != "":
            min_string = min(i, min_string)
            fret_mark.toggle_line_visible(false)
        fret_mark.mark_value = fret_value

    # 比最小的小的全部设空，隐藏展位线
    for i in range(min_string):
        var fret_mark: FretMark = note.fret_marks[i]
        fret_mark.mark_value = ""
        fret_mark.toggle_line_visible(false)

    return note

## 构建拍
static func deserialize_beat(data: Dictionary) -> Beat:
    var beat: Beat = Beat.new()
    beat.beat_no = data["no"]
    var note_length = len(data['notes'])

    # 计算绘制哪些音符
    var which_stem_2_draw: Callable = func(note_idx: int, note_data: Array):
        var res: Array = []
        var note_time_value: int = note_data[note_idx]['value']
        for time_value in [32, 16, 8]:
            if note_time_value < time_value:
                continue
            for j in range(0, note_idx):
                if note_data[j]['value'] >= time_value:
                    res.append([time_value, 'Left'])
                    break
            for k in range(note_idx + 1, len(note_data)):
                if note_data[k]['value'] >= time_value:
                    res.append([time_value, 'Right'])
                    break
        return res


    for i in range(note_length):
        var note_data = data['notes'][i]
        var note: Note = deserialize_note(note_data)
        note.value = note_data['value']

        # 最左端左对齐，右端右对齐
        if i == 0:
            note.set_note_alignment(2)
        elif i == note_length - 1:
            note.set_note_alignment(8)

        # 如果时值大于4绘制符杆
        if note.value >= 4:
            note.toggle_note_stem_visible(true)

        for tmp in which_stem_2_draw.call(i, data['notes']):
            note.toggle_time_value_marks_visible(tmp[0], tmp[1], true)

        note.name = "Note#%d#%d" % [beat.beat_no, note.note_no]
        beat.notes.append(note)

    return beat

## 构建小节
static func deserialize_bar(data: Dictionary) -> Bar:
    var bar: Bar = bar_res.instantiate()
    bar.bar_no = data['no']
    bar.name = "Bar#%d" % [bar.bar_no]
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

## 构建和弦
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

## 构建tab
static func deserialize_tab(data: Dictionary) -> Tab:
    var tab: Tab = tab_res.instantiate() as Tab

    tab.title = data['title']
    tab.signatures = data['signatures']
    tab.authors = data['authors']

    for bars_data in data['bars']:
        var bar: Bar = deserialize_bar(bars_data)
        tab.get_node("Tab/MarginContainer/Bars").add_child(bar)
    return tab
