class DrawInfo:

    def __init__(self):
        self.points = {}
        self.segments = []

    def add_point(id : str, x : int, y : int):
        self.points[id] = [x,y]

    def add_segment(start_point : str, end_point : str, correct : bool):
        self.segments.append([start_point, end_point, correct])