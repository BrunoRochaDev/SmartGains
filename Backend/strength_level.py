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

def calculate_strength(gender : str, age : int, bodyweight : int, weight : int, exercise : str): 

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
        elif int(selected_row['Intermediate']) < weight:
            age_classification = Classification['ADVANCED']
        elif int(selected_row['Novice']) < weight:
            age_classification = Classification['INTERMEDIATE']
        elif int(selected_row['Beginner']) < weight:
            age_classification = Classification['NOVICE']
        else:
            age_classification = Classification['BEGINNER']

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
        elif int(selected_row['Intermediate']) < weight:
            bw_classification = Classification['ADVANCED']
        elif int(selected_row['Novice']) < weight:
            bw_classification = Classification['INTERMEDIATE']
        elif int(selected_row['Beginner']) < weight:
            bw_classification = Classification['NOVICE']
        else:
            bw_classification = Classification['BEGINNER']

    # Average out
    average = int(( bw_classification.value + age_classification.value )/2)
    general_classification = Classification( average )

    print('age:', age_classification)
    print('bw:', bw_classification)
    print('avg', average)
    print('general:',general_classification)

calculate_strength('m',22, 100, 100, 'squat')