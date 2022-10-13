class Exercise {
  final int id;
  final String name;
  final String description;
  final String icon;
  final String instructions;
  final String instruction_image;
  final String camera_positioning;
  final String starter_pose;

  Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.instructions,
    required this.instruction_image,
    required this.camera_positioning,
    required this.starter_pose,
  });
}

final Exercise deadLift = Exercise(
    id: 1,
    name: 'Deadlift',
    description: 'My name Jeff',
    icon: 'assets/icons/deadlift_icon.jpg',
    instructions:
        '1. Stand with your mid-foot under the barbell\n2. Bend over and grab the bar with a shoulder-width grip\n3.Bend your knees until your shins touch the bar\n4. Lift your chest up and straighten your lower back\n5. Take a big breath, hold it, and stand up with the weight\n',
    instruction_image: 'assets/stronglifts-deadlift.webp',
    camera_positioning:
        '1. Position yourself in front of the camera\n2. Make sure your whole body is catched by the camera\n3. To start, perform the motion in the gif\n4. To stop, perform the motion again.',
    starter_pose: "assets/wakanda_forever.gif");

final Exercise squat = Exercise(
  id: 1,
  name: 'Squat',
  description: 'My name Jeff',
  icon: 'assets/icons/squat_icon.png',
  instructions:
      "1. Stand with the bar on your upper-back, and your feet shoulder-width apart\n2. Squat down by pushing your knees to the side while moving hips back\n3. Break parallel by Squatting down until your hips are lower than your knees\n4. Squat back up while keeping your knees out and chest up\n 5.Stand with your hips and knees locked at the top\n",
  instruction_image: "assets/stronglifts-squat.webp",
  camera_positioning:
      '1. To start, perform the motion in the gif\n2. To do the exercise, position yourself perpendicularly to the camera\n2. Make sure your whole body is catched by the camera\n4. To stop, perform the motion in the gif again.',
  starter_pose: "assets/wakanda_forever.gif",
);

final Exercise pushup = Exercise(
  id: 1,
  name: 'Pushup',
  description: 'My name Jeff',
  icon: 'assets/icons/pushup_icon.png',
  instructions:
      '1. Place your palms on the floor and ensure your thumbs are touching each other.\n 2. Extend your legs backwards and make sure that only your toes are touching the floor.\n 3. Maintain a straight body.\n 4. Keep tension on your triceps by slightly bending your elbows.Lower your body as far as you can but don’t touch the ground.\n 5. Ensure your body maintains a straight line.\n 6. Pause and push back to the starting position without locking the elbows.',
  instruction_image: 'assets/gif_pushup.gif',
  camera_positioning:
      '1. To start the rep counter, perform the motion in the gif\n2. To do the exercise, position yourself perpendicularly to the camera\n2. Make sure your whole body is catched by the camera\n4. To stop, perform the motion in the gif again.',
  starter_pose: "assets/wakanda_forever.gif",
);

final Exercise curl = Exercise(
    id: 1,
    name: 'Curl',
    description: 'My name Jeff',
    icon: 'assets/icons/curl_icon.png',
    instructions:
        "1. Bend at the elbow, lifting the lower arms to pull the weights toward the shoulders.\n 2. Your upper arms are stationary, and your wrists align with the forearms.\n 3. Hold for one second at the top of the movement.\n 4. Your thumbs will be close to the shoulders and palms facing toward the body's midline.\n 5. Lower the weights to return to the starting position.",
    instruction_image: 'assets/bicep-curl.gif',
    camera_positioning:
        '1. To start, perform the motion in the gif\n2. To do the exercise, position yourself perpendicularly to the camera\n2. Make sure your whole body is catched by the camera\n4. To stop, perform the motion in the gif again.',
    starter_pose: "assets/wakanda_forever.gif");

List<Exercise> exercises = [deadLift, squat, pushup, curl];
