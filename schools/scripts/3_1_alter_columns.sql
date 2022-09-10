ALTER TABLE lessons
DROP CONSTRAINT lessons_school_id_fkey,
DROP CONSTRAINT lessons_teacher_id_fkey,
DROP CONSTRAINT lessons_class_id_fkey,
DROP CONSTRAINT lessons_date_id_fkey,
DROP CONSTRAINT lessons_school_subject_id_fkey,
DROP CONSTRAINT lessons_class_type_id_fkey,
DROP CONSTRAINT lessons_classroom_id_fkey;

ALTER TABLE dates
    MODIFY date_id INT UNSIGNED,
    MODIFY year SMALLINT UNSIGNED,
    MODIFY month TINYINT UNSIGNED,
    MODIFY day TINYINT UNSIGNED,
    MODIFY weekday TINYINT UNSIGNED,
    MODIFY day_of_year TINYINT UNSIGNED,
    MODIFY is_holiday TINYINT UNSIGNED(1),
    MODIFY is_weekend TINYINT UNSIGNED(1);

ALTER TABLE schools
    MODIFY school_id INT UNSIGNED,
    MODIFY school_name CHAR(50),
    MODIFY school_district CHAR(30),
    MODIFY school_level CHAR(20),
    MODIFY school_state CHAR(2),
    MODIFY max_students INT UNSIGNED;

ALTER TABLE school_subjects
    MODIFY school_subject_id INT UNSIGNED,
    MODIFY school_subject CHAR(30);

ALTER TABLE classrooms
    MODIFY classroom_id INT UNSIGNED;

ALTER TABLE class_types
    MODIFY class_type_id INT UNSIGNED;

ALTER TABLE teachers
    MODIFY teacher_id INT UNSIGNED,
    MODIFY teacher_name CHAR(50),   
    MODIFY start_year SMALLINT UNSIGNED,
    MODIFY end_year SMALLINT UNSIGNED;

ALTER TABLE classes
    MODIFY class_id INT UNSIGNED,
    MODIFY students SMALLINT UNSIGNED;

ALTER TABLE lessons   
    MODIFY lesson_id INT UNSIGNED,
    MODIFY school_id INT UNSIGNED,
    MODIFY class_id INT UNSIGNED,
    MODIFY date_id INT UNSIGNED,
    MODIFY school_subject_id INT UNSIGNED,
    MODIFY teacher_id INT UNSIGNED,
    MODIFY classroom_id INT UNSIGNED,
    MODIFY class_type_id INT UNSIGNED,
    MODIFY class_start TINYINT UNSIGNED,
    MODIFY class_end TINYINT UNSIGNED,
    MODIFY attendance SMALLINT UNSIGNED;

ALTER TABLE lessons
ADD CONSTRAINT lessons_school_id_fkey FOREIGN KEY (school_id) REFERENCES schools(school_id),
ADD CONSTRAINT lessons_teacher_id_fkey FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id),
ADD CONSTRAINT lessons_class_id_fkey FOREIGN KEY (class_id) REFERENCES classes(class_id),
ADD CONSTRAINT lessons_date_id_fkey FOREIGN KEY (date_id) REFERENCES dates(date_id),
ADD CONSTRAINT lessons_school_subject_id_fkey FOREIGN KEY (school_subject_id) REFERENCES school_subjects(school_subject_id),
ADD CONSTRAINT lessons_class_type_id_fkey FOREIGN KEY (class_type_id) REFERENCES class_types(class_type_id),
ADD CONSTRAINT lessons_classroom_id_fkey FOREIGN KEY (classroom_id) REFERENCES classrooms(classroom_id);