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

            # In Frame
            if type == "IN_FRAME":
                return InFrame(JSON["in_frame"])

            # Set State
            elif type == "SET_STATE":
                return SetState(JSON["state"])

            # Rep Count
            elif type == "REP_DONE":
                return RepDone(JSON["rep_count"]) 

            # Feedback
            elif type == "FEEDBACK":
                return Feedback(JSON["feedback_id"])

            # Gif
            elif type == "GIF":
                return Feedback(JSON["gif_base64"])            

        except:
            raise ValueError("Could not parse JSON to message.")

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
    def __init__(self, rep_count : int):
        self.type = "REP_DONE"
        self.count = rep_count

class Feedback(Message):
    """Message for passing feedback on the current rep"""
    def __init__(self, feedback_id):
        self.type = "FEEDBACK"
        self.feedback_id = feedback_id

class Gif(Message):
    """Message contating the gif of a repetition done."""
    def __init__(self, gif_base64):
        self.type = "GIF"
        self.gif_base64 = gif_base64