from distutils.util import execute
import pandas as pd
import numpy as np
import holidays
import mysql.connector
import os
import random
from faker import Faker
from faker_education import SchoolProvider
import time

fake = Faker('pt_BR')
fake.add_provider(SchoolProvider)

def time_fetch(cnx, query):
    start = time.time()
    result = cnx.fetch(query)
    end = time.time()
    return end - start, result
class FakeData:

    def __init__(self, number_of_schools = 1):
        self.number_of_schools = number_of_schools
        self._dates = None
        self._schools = None
        self._school_subjects = None
        self._teachers = None
        self._class_types = None
        self._classrooms = None
        self._classes = None
        self._lessons = None

    @property
    def dates_df(self):
        if self._dates is None:
            DATES_START = '20000101'
            DATES_END = '20221231'
            date_dim_columns = ['date', 'year', 'month', 'day', 'weekday', 'day_of_year', 'is_holiday', 'is_weekend']
            date_dim_df = pd.DataFrame(columns=date_dim_columns)
            date_dim_df['date'] = pd.date_range(start=DATES_START, end=DATES_END)
            date_dim_df['year'] = date_dim_df['date'].dt.year
            date_dim_df['month'] = date_dim_df['date'].dt.month
            date_dim_df['day'] = date_dim_df['date'].dt.day
            date_dim_df['weekday'] = date_dim_df['date'].dt.weekday
            date_dim_df['day_of_year'] = date_dim_df['date'].dt.dayofyear
            date_dim_df['is_holiday'] = date_dim_df['date'].apply(lambda x: x in holidays.BR(state='SP', years=x.year))
            date_dim_df['is_weekend'] = date_dim_df['date'].dt.weekday.isin([5, 6])
            self._dates = date_dim_df
        return self._dates

    @property
    def schools_df(self):
        school_columns = ['school_name', 'school_district', 'school_level', 'school_state', 'max_students']
        if self._schools is None:
            school_dim_columns = ['school_name', 'school_district', 'school_level', 'school_state', 'max_students']
            school_dim_df = pd.DataFrame(columns=school_dim_columns)
            schools = [fake.school_object() for _ in range(self.number_of_schools)]
            school_dim_df['school_name'] = [school['school'] for school in schools]
            school_dim_df['max_students'] = [random.randint(10, 100) * 10 for _ in range(self.number_of_schools)]
            school_dim_df['school_district'] = [school['district'] for school in schools]
            school_dim_df['school_level'] = [random.choice(['Elementary', 'Middle', 'High']) for _ in schools]
            school_dim_df['school_state'] = [school['state'] for school in schools]    
            self._schools = school_dim_df      
        return self._schools[school_columns]

    @property
    def school_subjects_df(self):
        if self._school_subjects is None:
            school_subjects = [
                {'school_subject':'Math','code': 'MTH'},
                {'school_subject':'Science','code': 'SCI'},
                {'school_subject':'History','code': 'HIS'},
                {'school_subject':'English','code': 'ENG'},
                {'school_subject':'Art','code': 'ART'},
                {'school_subject':'Music','code': 'MUS'},
                {'school_subject':'PE','code': 'PE'},
                {'school_subject':'Social Studies','code': 'SOC'},
                {'school_subject':'Foreign Language','code': 'FL'},
                {'school_subject':'Technology','code': 'TEC'}
            ]
            self._school_subjects = pd.DataFrame(data=school_subjects)
        return self._school_subjects

    @property
    def class_types_df(self):
        if self._class_types is None:
            self._class_types = pd.DataFrame(data=[{'type': 'ONLINE'}, {'type': 'IN PERSON'}])
        return self._class_types

    @property
    def teachers_df(self):
        teacher_columns = ['teacher_name', 'sex', 'birthdate', 'email', 'start_year', 'end_year']
        if self._teachers is None:
            number_of_teachers = [random.randint(int(self.schools_df['max_students'][i]/10), int(self.schools_df['max_students'][i]/10)) for i in range(self.number_of_schools)]
            teachers = []
            for i in range(self.number_of_schools):
                for _ in range(number_of_teachers[i]):
                    profile = fake.profile()
                    teachers.append({
                                    'school_id': i + 1,
                                    'teacher_name': profile['name'],
                                    'sex': profile['sex'],
                                    'birthdate': profile['birthdate'],
                                    'email': profile['mail'],
                                    'start_year': random.randint(2000, 2019),
                                    'end_year': random.randint(2005, 2024)
                                    })
            self._teachers = pd.DataFrame(data=teachers)
        return self._teachers[teacher_columns]

    @property
    def classrooms_df(self):
        classroom_columns = ['classroom_code']
        if self._classrooms is None:
            classroom = []
            for i in range(self.number_of_schools):
                for j in range(self.schools_df['max_students'][i] // random.randint(30,50)):
                    classroom.append({
                                    'school_id': i + 1,
                                    'classroom_code': fake.unique.bothify(text='???###')
                                    })
            self._classrooms = pd.DataFrame(data=classroom)
        return self._classrooms[classroom_columns]

    @property
    def classes_df(self):
        class_columns = ['class_code', 'students', 'class_period', 'class_level']
        if self._classes is None:
            classes = []
            CLASS_LEVEL_OPTIONS = {
                'High': ['Elementary', 'Middle', 'High'],
                'Middle': ['Elementary', 'Middle'],
                'Elementary': ['Elementary']
            }
            for i in range(self.number_of_schools):
                for j in range(2000, 2023):
                    max_students = self.schools_df['max_students'][i]
                    number_of_classes = max_students // 50
                    for _ in range(number_of_classes):
                        classes.append({
                                        'school_id': i + 1,
                                        'year': j,
                                        'class_code': fake.unique.bothify(text='???###'),
                                        'students': random.randint(30, 50),
                                        'class_period': random.choice(['Morning', 'Afternoon', 'Evening']),
                                        'class_level': random.choice(CLASS_LEVEL_OPTIONS[self.schools_df['school_level'][i]])
                                        })
            self._classes = pd.DataFrame(data=classes)
        return self._classes[class_columns]

    @property
    def lessons_df(self):
        lesson_columns = ['school_id', 'class_id', 'date_id', 'school_subject_id', 'teacher_id', 'classroom_id', 'class_type_id', 'class_start', 'class_end', 'attendance']
        if self._lessons is None:
            (self.classes_df, self.teachers_df, self.classrooms_df)
            lessons = []
            timeslots = {
                'Morning': [8, 9, 10, 11],
                'Afternoon': [13, 14, 15, 16],
                'Evening': [18, 19, 20, 21]
            }
            subjects = [i+1 for i in range(len(self.school_subjects_df))]
            for i, class_row in self._classes.iterrows():
                dates = self.dates_df[(self.dates_df['year'] == class_row['year']) & (self.dates_df['is_holiday'] == False) & (self.dates_df['is_weekend'] == False)].index + 1
                available_classrooms = self._classrooms[self._classrooms['school_id'] == class_row['school_id']].index + 1
                available_teachers = self._teachers[self._teachers['school_id'] == class_row['school_id']].index + 1
                for j in dates:
                    for k in timeslots[class_row['class_period']]:
                        lessons.append({'school_id': class_row['school_id'],
                                        'class_id': i + 1,
                                        'date_id': j,
                                        'school_subject_id': random.choice(subjects),
                                        'teacher_id': random.choice(available_teachers),
                                        'classroom_id': random.choice(available_classrooms),
                                        'class_type_id': random.randint(1, 2),
                                        'class_start': k,
                                        'class_end': k + 1,
                                        'attendance': random.randint(class_row['students'] // 2, class_row['students'])
                                        })
            self._lessons = pd.DataFrame(data=lessons)
        return self._lessons[lesson_columns]
        


class MysqlConnector:
    def __init__(self):
        self.connection = mysql.connector.connect(user=os.environ['MYSQL_USER'],
                                    password='',
                                    host=os.environ['MYSQL_HOST'],
                                    database=os.environ['MYSQL_DATABASE'])

    def execute(self, query):
        cursor = self.connection.cursor()
        cursor.execute(query)
        self.connection.commit()
        cursor.close()

    def execute_many(self, query, values):
        cursor = self.connection.cursor()
        cursor.executemany(query, values)
        self.connection.commit()
        cursor.close()

    def fetch(self, query):
        cursor = self.connection.cursor()
        cursor.execute(query)
        result = cursor.fetchall()
        self.connection.commit()
        cursor.close()
        return result

    def batch_insert(self, table, columns, values):
        query = f'INSERT INTO {table} ({", ".join(columns)}) VALUES ({", ".join(["%s"] * len(columns))})'
        self.execute_many(query, values)


