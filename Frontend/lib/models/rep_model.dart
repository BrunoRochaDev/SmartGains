class Rep {
  final int id;
  String gif;
  final List<String> feedback;

  Rep({
    required this.id,
    required this.gif,
    required this.feedback,
  });
}

final Rep rep1 = Rep(id: 1, gif: "assets/good.gif", feedback: ["Good Rep!"]);

final Rep rep2 = Rep(
    id: 1,
    gif: "assets/bad_knee.gif",
    feedback: ["Don't bend your knees!", "Don't bend your body forward"]);

List<Rep> reps = [rep1, rep2];
