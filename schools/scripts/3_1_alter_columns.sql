ALTER TABLE dates
    MODIFY date_id UNSIGNED INT,
    MODIFY year UNSIGNED SMALLINT,
    MODIFY month UNSIGNED TINYINT,
    MODIFY day UNSIGNED TINYINT,
    MODIFY weekday UNSIGNED TINYINT,
    MODIFY day_of_year UNSIGNED TINYINT,
    MODIFY is_holiday UNSIGNED TINYINT(1),
    MODIFY is_weekend UNSIGNED TINYINT(1);

ALTER TABLE schools
    MODIFY school_id UNSIGNED INT,
    MODIFY school_name CHAR(50),
    MODIFY school_district CHAR(30),
    MODIFY school_level CHAR(20),
    MODIFY school_state CHAR(2),
    MODIFY max_students UNSIGNED INT;

ALTER TABLE school_subjects
    MODIFY school_subject_id UNSIGNED INT,
    MODIFY school_subject CHAR(30);

ALTER TABLE classrooms
    MODIFY classroom_id UNSIGNED INT;

ALTER TABLE class_types
    MODIFY class_type_id UNSIGNED INT;

ALTER TABLE teachers
    MODIFY teacher_id UNSIGNED INT,
    MODIFY teacher_name CHAR(50),   
    MODIFY start_year UNSIGNED SMALLINT,
    MODIFY end_year UNSIGNED SMALLINT;

ALTER TABLE classes
    MODIFY class_id UNSIGNED INT,
    MODIFY students UNSIGNED SMALLINT;

ALTER TABLE lessons   
    MODIFY lesson_id UNSIGNED INT,
    MODIFY school_id UNSIGNED INT,
    MODIFY class_id UNSIGNED INT,
    MODIFY date_id UNSIGNED INT,
    MODIFY school_subject_id UNSIGNED INT,
    MODIFY teacher_id UNSIGNED INT,
    MODIFY classroom_id UNSIGNED INT,
    MODIFY class_type_id UNSIGNED INT,
    MODIFY class_start UNSIGNED TINYINT,
    MODIFY class_end UNSIGNED TINYINT,
    MODIFY attendance UNSIGNED SMALLINT;