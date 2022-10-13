import csv # For handling the exercise data
import os # For paths

from enum import Enum
 
class Classification(Enum):
    BEGINNER = 1
    NOVICE = 2
    INTERMEDIATE = 3
    ADVANCED = 4
    ELITE = 5

# Base location
BASE_PATH = "ExerciseData/"

def strength_classification(gender : str, age : int, bodyweight : int, weight : int, exercise : str) -> dict: 
    """Gets a strength classification in respect to age and bodyweight"""

    # By age
    age_classification = None
    with open(os.path.join(BASE_PATH, exercise + '_age_' + gender + '.csv'), 'r') as csv_file:
        csv_reader = csv.DictReader(csv_file)

        # Find the row
        selected_row = None
        for row in csv_reader:
            if selected_row == None:
                selected_row = row
            else:
                if int(row['Age']) <= age:
                    selected_row = row
                else:
                    break

        if int(selected_row['Advanced']) < weight:
            age_classification = Classification['ELITE']
            age_diff = weight/int(selected_row['Advanced'])

        elif int(selected_row['Intermediate']) < weight:
            age_classification = Classification['ADVANCED']
            age_diff = weight/int(selected_row['Intermediate'])

        elif int(selected_row['Novice']) < weight:
            age_classification = Classification['INTERMEDIATE']
            age_diff = weight/int(selected_row['Novice'])

        elif int(selected_row['Beginner']) < weight:
            age_classification = Classification['NOVICE']
            age_diff = weight/int(selected_row['Beginner'])

        else:
            age_classification = Classification['BEGINNER']
            age_diff = weight/int(selected_row['Beginner'])

    # By bodyweight
    bw_classification = None
    with open(os.path.join(BASE_PATH, exercise + '_bw_' + gender + '.csv'), 'r') as csv_file:
        csv_reader = csv.DictReader(csv_file)

        # Find the row
        selected_row = None
        for row in csv_reader:
            if selected_row == None:
                selected_row = row
            else:
                if int(row['Bodyweight']) <= bodyweight:
                    selected_row = row
                else:
                    break

        if int(selected_row['Advanced']) < weight:
            bw_classification = Classification['ELITE']
            bw_diff = weight/int(selected_row['Advanced'])

        elif int(selected_row['Intermediate']) < weight:
            bw_classification = Classification['ADVANCED']
            bw_diff = weight/int(selected_row['Intermediate'])

        elif int(selected_row['Novice']) < weight:
            bw_classification = Classification['INTERMEDIATE']
            bw_diff = weight/int(selected_row['Novice'])

        elif int(selected_row['Beginner']) < weight:
            bw_classification = Classification['NOVICE']
            bw_diff = weight/int(selected_row['Beginner'])

        else:
            bw_classification = Classification['BEGINNER']
            bw_diff = weight/int(selected_row['Beginner'])

    # Average out
    average = int(( bw_classification.value + age_classification.value )/2)
    general_classification = Classification( average )

    # Round diffs to 2 decimals
    bw_diff = round(bw_diff, 2)
    age_diff = round(age_diff, 2)

    return {"class" : general_classification.value, "age_diff" : age_diff, "bw_diff" : bw_diff}

print(strength_classification('m',22, 80, 100, 'squat'))