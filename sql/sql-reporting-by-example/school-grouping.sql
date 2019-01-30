-- Which teachers don't have a class during 1st period?
WITH free_teachers AS (
  SELECT TEACHERS.ID FROM TEACHERS
  WHERE TEACHERS.ID NOT IN (
    SELECT TEACHER_ID FROM CLASSES
    WHERE PERIOD_ID=1
  )
)
SELECT free_teachers.ID, CLASSES.PERIOD_ID, TEACHERS.* FROM free_teachers
JOIN CLASSES ON CLASSES.TEACHER_ID = free_teachers.ID
JOIN TEACHERS ON TEACHERS.ID = free_teachers.ID


-- Which elective teacher is the most popular (teaches the most students)?
SELECT TEACHERS.FIRST_NAME || " " || TEACHERS.LAST_NAME AS "Teacher"
-- ,CLASSES.TEACHER_ID
,COUNT(SCHEDULE.STUDENT_ID) AS "total students"
FROM SUBJECTS
JOIN CLASSES ON CLASSES.SUBJECT_ID = SUBJECTS.ID
JOIN TEACHERS ON TEACHERS.ID = CLASSES.TEACHER_ID
JOIN SCHEDULE ON CLASSES.ID = SCHEDULE.CLASS_ID
WHERE SUBJECTS.GRADE IS NULL
GROUP BY CLASSES.TEACHER_ID
ORDER BY "total students" DESC
LIMIT 1;






-- Which students have 5th period science and 7th period art?
WITH CTE AS (
  SELECT SUBJECTS.NAME
  , CLASSES.PERIOD_ID
  , SCHEDULE.STUDENT_ID
  FROM SUBJECTS
  JOIN CLASSES ON CLASSES.ID = SUBJECTS.CLASS_ID
  JOIN SCHEDULE ON SCHEDULE.CLASS_ID = CLASSES.ID
  JOIN STUDENTS ON STUDENTS.ID = SCHEDULE.STUDENT_ID
)
SELECT NAME, PERIOD_ID, STUDENT_ID
FROM CTE

  WHERE (PERIOD_ID = 5 AND LOWER(NAME) = 'science')
  OR (PERIOD_ID = 7 AND LOWER(NAME) = 'art')


SELECT NAME, PERIOD_ID
, FIRST_NAME, LAST_NAME
FROM SCHEDULE -- ASSOCIATIVE ENTITY
JOIN STUDENTS ON STUDENTS.ID = STUDENT_ID
JOIN CLASSES ON CLASSES.ID = CLASS_ID
JOIN SUBJECTS ON SUBJECTS.ID = SUBJECT_ID
WHERE (PERIOD_ID = 5 AND LOWER(NAME) = 'science')
OR (PERIOD_ID = 7 AND LOWER(NAME) = 'art')


-- Which students have 5th period science and 7th period art?
SELECT NAME, PERIOD_ID
-- , FIRST_NAME, LAST_NAME
, STUDENT_ID
FROM SCHEDULE -- ASSOCIATIVE ENTITY
JOIN CLASSES ON CLASSES.ID = CLASS_ID
JOIN SUBJECTS ON SUBJECTS.ID = SUBJECT_ID
WHERE (PERIOD_ID = 5 AND LOWER(NAME) = 'science')



-- Which subject is the least popular, and how many students are taking it?
SELECT SUBJECTS.NAME, COUNT(*) AS "Number_of_Students" FROM SUBJECTS
JOIN CLASSES ON SUBJECT_ID = SUBJECTS.ID
JOIN SCHEDULE ON CLASS_ID = CLASSES.ID
GROUP BY SUBJECT_ID ORDER BY "Number_of_Students" LIMIT 5;

-- CTE query: least popular subject
WITH CTE AS (
  SELECT NAME, COUNT(1) AS "CT" FROM SUBJECTS
  JOIN CLASSES ON SUBJECT_ID = SUBJECTS.ID
  JOIN SCHEDULE ON CLASS_ID = CLASSES.ID
  GROUP BY SUBJECT_ID
)
SELECT NAME, MIN("CT") FROM CTE;


-- What class does Janis Ambrose teach during each period? Be sure to include all 7 periods in your report!
WITH PERIOD_CLASS_SUBJECT_TEACHER AS (
  SELECT * FROM PERIODS
  LEFT OUTER JOIN CLASSES ON PERIOD_ID = PERIODS.ID
  LEFT OUTER JOIN SUBJECTS ON SUBJECT_ID = SUBJECTS.ID
  LEFT OUTER JOIN TEACHERS ON TEACHER_ID = TEACHERS.ID
  WHERE FIRST_NAME = "Janis" AND LAST_NAME = "Ambrose"
)
SELECT PERIODS.ID
, ROOM_ID, NAME AS "Subjects Janis Teaches"
FROM PERIODS
LEFT OUTER JOIN PERIOD_CLASS_SUBJECT_TEACHER
ON PERIODS.ID = PERIOD_ID;



-- Do any teachers teach multiple subjects? If so, which teachers?
SELECT DISTINCT FIRST_NAME, LAST_NAME, NAME FROM TEACHERS
JOIN CLASSES ON TEACHERS.ID = CLASSES.TEACHER_ID
JOIN SUBJECTS ON SUBJECTS.ID = CLASSES.SUBJECT_ID
WHERE TEACHERS.ID IN (
  SELECT TEACHER_ID FROM CLASSES
  GROUP BY TEACHER_ID HAVING COUNT(DISTINCT SUBJECT_ID) > 1
)

-- Who are the busiest teachers?
WITH CLASSES_TEACHERS AS (
  SELECT * FROM TEACHERS
  JOIN CLASSES ON TEACHERS.ID = CLASSES.TEACHER_ID
)
SELECT TEACHER_ID, COUNT(PERIOD_ID) AS NUM_PERIODS
FROM CLASSES_TEACHERS
GROUP BY TEACHER_ID
HAVING NUM_PERIODS = 7;