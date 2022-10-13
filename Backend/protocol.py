import json

# Exercises
from curl import Curl
from squat import Squat
from pushup import Pushup
from deadlift import Deadlift

class Message:
    """Base message. Other messages should extend this."""

    def encode(self):
        """Serializes to JSON"""
        return json.dumps(self, default=lambda o: o.__dict__, sort_keys=False)

    @classmethod
    def decode(cls, msg : dict):
        """Static method for parsing a JSON dict to a message."""
        try:
            
            JSON = json.loads(msg)
            type = JSON["type"]

            # Select Exercise
            if type == "EXERCISE":
                return SetExercise(JSON["exercise"])

            # In Frame
            elif type == "IN_FRAME":
                return InFrame(JSON["in_frame"])

            # Set State
            elif type == "SET_STATE":
                return SetState(JSON["state"])

            # Rep Count
            elif type == "REP_DONE":
                return RepDone(JSON["rep_count"],JSON["feedback_list"])

            # Gif
            elif type == "GIF":
                return Gif(JSON["count"], JSON["gif_base64"])            

            # Statistics
            elif type == "STATS":
                return Statistics(JSON["data"])

        except:
            raise ValueError("Could not parse JSON to message.")

class SetExercise(Message):
    """Message sent by the frontend to change the exercise"""
    def __init__(self, exercise_id : str):
        self.type = "EXERCISE"
        self.exercise = exercise_id

    def create_object(self):
        """Creates the exercise object"""
        if self.exercise == "Squat":
            return Squat()
        elif self.exercise == "Curl":
            return Curl()
        elif self.exercise == "Pushup":
            return Pushup()
        elif self.exercise == "Deadlift":
            return Deadlift()

class InFrame(Message):
    """Message informing whether the user is in frame or not."""
    def __init__(self, in_frame):
        self.type = "IN_FRAME"
        self.in_frame = in_frame

class SetState(Message):
    """Message informing that a set has started / ended."""
    def __init__(self, state):
        self.type = "SET_STATE"
        self.state = state

class RepDone(Message):
    """Message informing that a repetition was detected. Also includes the count."""
    def __init__(self, rep_count : int, feedback_list : list):
        self.type = "REP_DONE"
        self.count = rep_count
        if len(feedback_list) > 0:
            self.feedback_list = feedback_list
        else:
            self.feedback_list = ["Good rep!"]

class Gif(Message):
    """Message contating the gif of a repetition done."""
    def __init__(self, count : int, gif_base64 : str):
        self.type = "GIF"
        self.count = count
        self.gif_base64 = gif_base64

class Statistics(Message):
    """Message for statistic idk"""
    def __init__(self, data):
        self.type = "STATS"
        self.data = data