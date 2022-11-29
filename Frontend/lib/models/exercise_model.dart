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
    description: 'Vertical Pull',
    icon: 'assets/icons/deadlift_icon.jpg',
    instructions:
        '1. Stand with your mid-foot under the barbell\n\n2. Bend over and grab the bar with a shoulder-width grip\n\n3.Bend your knees until your shins touch the bar\n\n4. Lift your chest up and straighten your lower back\n\n5. Take a big breath, hold it, and stand up with the weight\n\n',
    instruction_image: 'assets/stronglifts-deadlift.webp',
    camera_positioning:
        '1. Position yourself in front of the camera\n\n2. Make sure your whole body is caught by the camera\n\n3. To start, perform the motion in the gif\n\n4. To stop, perform the motion again.',
    starter_pose: "assets/wakanda_forever.gif");

final Exercise squat = Exercise(
  id: 1,
  name: 'Squat',
  description: 'Hip Hinge',
  icon: 'assets/icons/squat_icon.png',
  instructions:
      "1. Stand with the bar on your upper-back, and your feet shoulder-width apart\n\n2. Squat down by pushing your knees to the side while moving hips back\n\n3. Break parallel by Squatting down until your hips are lower than your knees\n\n4. Squat back up while keeping your knees out and chest up\n\n 5.Stand with your hips and knees locked at the top\n\n",
  instruction_image: "assets/stronglifts-squat.webp",
  camera_positioning:
      '1. To start, perform the motion in the gif\n\n2. To do the exercise, position yourself perpendicularly to the camera\n\n2. Make sure your whole body is caught by the camera\n\n4. To stop, perform the motion in the gif again.',
  starter_pose: "assets/wakanda_forever.gif",
);

final Exercise pushup = Exercise(
  id: 1,
  name: 'Pushup',
  description: 'Horizontal Push',
  icon: 'assets/icons/pushup_icon.png',
  instructions:
      '1. Place your palms on the floor and ensure your thumbs are touching each other.\n\n2. Extend your legs backwards and make sure that only your toes are touching the floor.\n\n3. Maintain a straight body.\n\n4. Keep tension on your triceps by slightly bending your elbows.Lower your body as far as you can but don’t touch the ground.\n\n5. Ensure your body maintains a straight line.\n\n6. Pause and push back to the starting position without locking the elbows.',
  instruction_image: 'assets/gif_pushup.gif',
  camera_positioning:
      '1. To start the rep counter, perform the motion in the gif\n\n2. To do the exercise, position yourself perpendicularly to the camera\n\n2. Make sure your whole body is caught by the camera\n\n4. To stop, perform the motion in the gif again.',
  starter_pose: "assets/wakanda_forever.gif",
);

final Exercise curl = Exercise(
    id: 1,
    name: 'Curl',
    description: 'Bicep Isolation',
    icon: 'assets/icons/curl_icon.png',
    instructions:
        "1. Bend at the elbow, lifting the lower arms to pull the weights toward the shoulders.\n\n2. Your upper arms are stationary, and your wrists align with the forearms.\n\n3. Hold for one second at the top of the movement.\n\n4. Your thumbs will be close to the shoulders and palms facing toward the body's midline.\n\n5. Lower the weights to return to the starting position.",
    instruction_image: 'assets/bicep-curl.gif',
    camera_positioning:
        '1. To start, perform the motion in the gif\n\n2. To do the exercise, position yourself perpendicularly to the camera\n\n2. Make sure your whole body is caught by the camera\n\n4. To stop, perform the motion in the gif again.',
    starter_pose: "assets/wakanda_forever.gif");

List<Exercise> exercises = [deadLift, squat, pushup, curl];
