DROP TABLE IF EXISTS lessons;

DROP TABLE IF EXISTS dates;

DROP TABLE IF EXISTS schools;

DROP TABLE IF EXISTS school_subjects;

DROP TABLE IF EXISTS teachers;

DROP TABLE IF EXISTS class_types;

DROP TABLE IF EXISTS classrooms;

DROP TABLE IF EXISTS classes;

CREATE TABLE dates (
    date_id INT AUTO_INCREMENT PRIMARY KEY,
    date DATE,
    year INT,
    month INT,
    day INT,
    weekday INT,
    day_of_year INT,
    is_holiday BOOLEAN,
    is_weekend BOOLEAN
);

CREATE TABLE schools (
    school_id INT AUTO_INCREMENT PRIMARY KEY,
    school_name VARCHAR(255),
    school_district VARCHAR(255),
    school_level VARCHAR(255),
    school_state VARCHAR(255),
    max_students INT
);

CREATE TABLE school_subjects (
    school_subject_id INT AUTO_INCREMENT PRIMARY KEY,
    school_subject VARCHAR(255),
    code CHAR(3)
);

CREATE TABLE teachers (
    teacher_id INT AUTO_INCREMENT PRIMARY KEY,
    teacher_name VARCHAR(255),
    sex CHAR(1),
    birthdate DATE,
    email VARCHAR(255),
    start_year INT,
    end_year INT
);

CREATE TABLE class_types (
    class_type_id INT AUTO_INCREMENT PRIMARY KEY,
    type CHAR(20)
);

CREATE TABLE classrooms (
    classroom_id INT AUTO_INCREMENT PRIMARY KEY,
    classroom_code CHAR(6)
);

CREATE TABLE classes (
    class_id INT AUTO_INCREMENT PRIMARY KEY,
    class_code CHAR(6),
    students INT,
    class_period CHAR(20),
    class_level CHAR(20)
);

CREATE TABLE lessons (
    lesson_id INT AUTO_INCREMENT PRIMARY KEY,
    school_id INT,
    class_id INT,
    date_id INT,
    school_subject_id INT,
    teacher_id INT,
    classroom_id INT,
    class_type_id INT,
    class_start INT,
    class_end INT,
    attendance INT,
    FOREIGN KEY (school_id) REFERENCES schools(school_id),
    FOREIGN KEY (class_id) REFERENCES classes(class_id),
    FOREIGN KEY (date_id) REFERENCES dates(date_id),
    FOREIGN KEY (school_subject_id) REFERENCES school_subjects(school_subject_id),
    FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id),
    FOREIGN KEY (classroom_id) REFERENCES classrooms(classroom_id),
    FOREIGN KEY (class_type_id) REFERENCES class_types(class_type_id)
);