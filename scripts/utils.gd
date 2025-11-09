class_name Utils

static func enumerate(iter: Array) -> Array:
    var arr = []
    for i in len(iter):
        arr.append([i, iter[i]])
    
    return arr