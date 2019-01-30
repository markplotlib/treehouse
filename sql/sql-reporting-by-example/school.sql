-- How many students are in each grade? And how many 6th graders do you think they'll have next year?
SELECT SUBJECTS.GRADE, CLASSES.ROOM_ID
, SUBJECTS.NAME
, ROOMS.CAPACITY
, SUM(ROOMS.CAPACITY)
FROM SUBJECTS
INNER JOIN CLASSES
ON CLASSES.SUBJECT_ID = SUBJECTS.ID
INNER JOIN ROOMS
ON CLASSES.ROOM_ID = ROOMS.ID
WHERE SUBJECTS.GRADE = 6
GROUP BY CLASSES.ROOM_ID


-- How many students are in each grade? And how many 6th graders do you think they'll have next year?
SELECT GRADE, COUNT(*) FROM STUDENTS
GROUP BY GRADE


-- How many students have Physical Education during first period?
WITH class_sizes AS (
  SELECT SCHEDULE.CLASS_ID, COUNT(CLASS_ID) AS "Students" FROM CLASSES
  INNER JOIN SCHEDULE ON CLASSES.ID = SCHEDULE.CLASS_ID GROUP BY CLASS_ID
)
SELECT * FROM class_sizes


SELECT SCHEDULE.CLASS_ID, COUNT(CLASS_ID) AS "Students"
FROM CLASSES
INNER JOIN SCHEDULE ON CLASSES.ID = SCHEDULE.CLASS_ID


WHERE CLASSES.PERIOD_ID = 1
AND CLASSES.SUBJECT_ID IN (
  SELECT ID FROM SUBJECTS WHERE SUBJECTS.NAME = "Physical Education"
)
GROUP BY CLASS_ID;


-- Which teachers teach elective subjects (subjects without grade levels)?
SELECT * FROM TEACHERS WHERE ID IN (
  SELECT TEACHER_ID FROM CLASSES WHERE SUBJECT_ID IN (
    SELECT ID FROM SUBJECTS WHERE GRADE IS NULL
  )
)

-- Which teacher teaches 7th grade science?
SELECT DISTINCT TEACHERS.ID, TEACHERS.* FROM TEACHERS
JOIN CLASSES
ON CLASSES.TEACHER_ID = TEACHERS.ID
JOIN SUBJECTS
ON SUBJECTS.ID = CLASSES.SUBJECT_ID
WHERE SUBJECTS.GRADE = 7
AND SUBJECTS.NAME = 'Science'


SELECT * FROM TEACHERS LIMIT 1;
SELECT * FROM CLASSES LIMIT 1;
SELECT * FROM SUBJECTS LIMIT 1;



-- Which teachers teach only 8th grade subjects?
SELECT DISTINCT TEACHERS.ID, TEACHERS.*, SUBJECTS.GRADE FROM TEACHERS
JOIN CLASSES ON CLASSES.TEACHER_ID = TEACHERS.ID
JOIN SUBJECTS ON SUBJECTS.ID = CLASSES.SUBJECT_ID
WHERE GRADE = 8

WITH grade8_subjects AS (
  SELECT ID, NAME
  , GRADE
  FROM SUBJECTS
  WHERE GRADE = 8
),
teacher_names AS (
  SELECT TEACHERS.FIRST_NAME, TEACHERS.LAST_NAME, CLASSES.SUBJECT_ID
  , CLASSES.TEACHER_ID
  FROM CLASSES
  JOIN TEACHERS
  ON TEACHERS.ID = CLASSES.TEACHER_ID
)
SELECT teacher_names.FIRST_NAME, teacher_names.LAST_NAME, CLASSES.TEACHER_ID, CLASSES.SUBJECT_ID
FROM CLASSES
JOIN grade8_subjects
ON grade8_subjects.ID = CLASSES.SUBJECT_ID
JOIN teacher_names
ON teacher_names.TEACHER_ID = CLASSES.TEACHER_ID


-- What's the total capacity of the school?
WITH subjects_in_largest_room AS (
  SELECT DISTINCT SUBJECT_ID FROM CLASSES
  WHERE ROOM_ID IN (
    SELECT ID FROM ROOMS
    WHERE CAPACITY = (
      SELECT MAX(CAPACITY) AS max_cap FROM ROOMS
    )
  )
)
SELECT NAME FROM SUBJECTS
INNER JOIN subjects_in_largest_room
ON SUBJECTS.ID = subjects_in_largest_room.SUBJECT_ID;