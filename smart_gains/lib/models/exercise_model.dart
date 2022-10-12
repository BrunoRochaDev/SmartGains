class Exercise {
  final int id;
  final String name;
  final String description;
  final String icon;
  final String instructions;

  Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.instructions,
  });
}

final Exercise deadLift = Exercise(
  id: 1,
  name: 'Deadlift',
  description: 'My name Jeff',
  icon: 'assets/icons/deadlift_icon.jpg',
  instructions: '',
);

final Exercise squat = Exercise(
  id: 1,
  name: 'Squat',
  description: 'My name Jeff',
  icon: 'assets/icons/squat_icon.png',
  instructions:
      "Here’s how to Squat with proper form, using a barbell:\n1. Stand with the bar on your upper-back, and your feet shoulder-width apart\n2. Squat down by pushing your knees to the side while moving hips back\n3. Break parallel by Squatting down until your hips are lower than your knees\n4. Squat back up while keeping your knees out and chest up\n 5.Stand with your hips and knees locked at the top\n",
);

final Exercise pushup = Exercise(
  id: 1,
  name: 'Pushup',
  description: 'My name Jeff',
  icon: 'assets/icons/pushup_icon.png',
  instructions: '',
);

final Exercise curl = Exercise(
  id: 1,
  name: 'Curl',
  description: 'My name Jeff',
  icon: 'assets/icons/curl_icon.png',
  instructions: '',
);

List<Exercise> exercises = [deadLift, squat, pushup, curl];
