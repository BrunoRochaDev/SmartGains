import csv # For handling the exercise data
import os # For paths

# Base location
BASE_PATH = "ExerciseData/"

def calculate_strength(age : int, bodyweight : int, exercise : str): 

    
    # By bodyweight
    with open(os.path.join(BASE_PATH, exercise + '_bw.csv'), 'r') as csvfile:
        # creating a csv reader object
        csvreader = csv.reader(csvfile)
        
        rows = []
        # Extracting each data row one by one
        for row in csvreader:
            rows.append(row)
    
        # get total number of rows
        print("Total no. of rows: %d"%(csvreader.line_num))
    
    # printing the field names
    print('Field names are:' + ', '.join(field for field in fields))
    
    # printing first 5 rows
    print('\nFirst 5 rows are:\n')
    for row in rows[:5]:
        # parsing each column of a row
        for col in row:
            print("%10s"%col,end=" "),
    print('\n')

calculate_strength('squat')