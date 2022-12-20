import csv # For handling the exercise data
import os # For paths
import requests
import json

from enum import Enum
 
class Classification(Enum):
    Beginner = 1
    Novice = 2
    Intermediate = 3
    Advanced = 4
    Elite = 5

# Base location
BASE_PATH = "ExerciseData/"

def strength_classification(gender : str, age : int, bodyweight : int, one_rep_max : int, exercise : str) -> dict: 
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

        if int(selected_row['Advanced']) < one_rep_max:
            age_classification = Classification['Elite']
            age_diff = one_rep_max/int(selected_row['Advanced'])

        elif int(selected_row['Intermediate']) < one_rep_max:
            age_classification = Classification['Advanced']
            age_diff = one_rep_max/int(selected_row['Intermediate'])

        elif int(selected_row['Novice']) < one_rep_max:
            age_classification = Classification['Intermediate']
            age_diff = one_rep_max/int(selected_row['Novice'])

        elif int(selected_row['Beginner']) < one_rep_max:
            age_classification = Classification['Novice']
            age_diff = one_rep_max/int(selected_row['Beginner'])

        else:
            age_classification = Classification['Beginner']
            age_diff = one_rep_max/int(selected_row['Beginner'])

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

        if int(selected_row['Advanced']) < one_rep_max:
            bw_classification = Classification['Elite']
            bw_diff = one_rep_max/int(selected_row['Advanced'])

        elif int(selected_row['Intermediate']) < one_rep_max:
            bw_classification = Classification['Advanced']
            bw_diff = one_rep_max/int(selected_row['Intermediate'])

        elif int(selected_row['Novice']) < one_rep_max:
            bw_classification = Classification['Intermediate']
            bw_diff = one_rep_max/int(selected_row['Novice'])

        elif int(selected_row['Beginner']) < one_rep_max:
            bw_classification = Classification['Novice']
            bw_diff = one_rep_max/int(selected_row['Beginner'])

        else:
            bw_classification = Classification['Beginner']
            bw_diff = one_rep_max/int(selected_row['Beginner'])

    # Average out
    average = int(( bw_classification.value + age_classification.value )/2)
    general_classification = Classification( average )

    # Round diffs to 2 decimals
    bw_diff = round(bw_diff, 2)
    age_diff = round(age_diff, 2)

    # How good are ya
    rate = 'N/A' 
    with open(os.path.join(BASE_PATH, exercise + '_rates_' + gender + '.csv'), 'r') as csv_file:
        csv_reader = csv.DictReader(csv_file)

        # Find the row
        selected_row = None
        for row in csv_reader:
            rate = row[general_classification.name]

    return {"class" : general_classification.value, "rate" : rate}
    

def write_data(exercise : str):
    try:
        user_data= requests.get("http://192.168.10.150/user?username=filipe").json()[0]

        gender = 'm' if user_data['gender'] == 'male' else 'f'
        age = 22 # Fix later
        bodyweight = user_data['weight']

        one_rep_max = user_data[exercise]

        result = (strength_classification(gender,age, int(bodyweight), int(one_rep_max), exercise))
        result['user'] = 'filipe'
        result['exercise'] = exercise

        requests.put("http://192.168.10.150/potencial", data=result)

    except:
        pass

    pass

write_data('curl')