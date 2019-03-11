-- Which teachers don't have a class during 1st period?
WITH free_teachers AS
  (SELECT TEACHERS.ID
   FROM TEACHERS
   WHERE TEACHERS.ID NOT IN
       (SELECT TEACHER_ID
        FROM CLASSES
        WHERE PERIOD_ID=1 ) )
SELECT free_teachers.ID,
       CLASSES.PERIOD_ID,
       TEACHERS.*
FROM free_teachers
JOIN CLASSES ON CLASSES.TEACHER_ID = free_teachers.ID
JOIN TEACHERS ON TEACHERS.ID = free_teachers.ID



-- 5) Which elective teacher is the most popular (i.e., which teacher teaches the most students)?
SELECT TEACHERS.FIRST_NAME || " " || TEACHERS.LAST_NAME AS "Teacher",
       COUNT(SCHEDULE.STUDENT_ID) AS "Total_Student_Count"
FROM SUBJECTS
JOIN CLASSES ON CLASSES.SUBJECT_ID = SUBJECTS.ID
JOIN TEACHERS ON TEACHERS.ID = CLASSES.TEACHER_ID
JOIN SCHEDULE ON CLASSES.ID = SCHEDULE.CLASS_ID
WHERE SUBJECTS.GRADE IS NULL
GROUP BY CLASSES.TEACHER_ID
ORDER BY "Total_Student_Count" DESC
LIMIT 1;



-- 4) Which subject is the least popular, and how many students are taking it?
WITH CTE AS
  (SELECT NAME,
          COUNT(1) AS "STUDENT_COUNT"
   FROM SUBJECTS
   JOIN CLASSES ON SUBJECT_ID = SUBJECTS.ID
   JOIN SCHEDULE ON CLASS_ID = CLASSES.ID
   GROUP BY SUBJECT_ID)
SELECT NAME,
       MIN("STUDENT_COUNT")
FROM CTE;




-- 3) What class does Janis Ambrose teach during each period? Be sure to include all 7 periods in your report!
WITH PERIOD_CLASS_SUBJECT_TEACHER AS
  (SELECT *
   FROM PERIODS
   LEFT OUTER JOIN CLASSES ON PERIOD_ID = PERIODS.ID
   LEFT OUTER JOIN SUBJECTS ON SUBJECT_ID = SUBJECTS.ID
   LEFT OUTER JOIN TEACHERS ON TEACHER_ID = TEACHERS.ID
   WHERE FIRST_NAME = "Janis"
     AND LAST_NAME = "Ambrose" )
SELECT PERIODS.ID AS "Period No.",
       ROOM_ID,
       NAME AS "Subjects_Janis_Teaches"
FROM PERIODS
LEFT OUTER JOIN PERIOD_CLASS_SUBJECT_TEACHER ON PERIODS.ID = PERIOD_ID;




-- 2) Do any teachers teach multiple subjects? If so, which teachers?
SELECT DISTINCT FIRST_NAME,
                LAST_NAME,
                NAME AS "CLASS_NAME"
FROM TEACHERS
JOIN CLASSES ON TEACHERS.ID = CLASSES.TEACHER_ID
JOIN SUBJECTS ON SUBJECTS.ID = CLASSES.SUBJECT_ID
WHERE TEACHERS.ID IN
    (SELECT TEACHER_ID
     FROM CLASSES
     GROUP BY TEACHER_ID
     HAVING COUNT(DISTINCT SUBJECT_ID) > 1)


-- 1) Who are the busiest teachers?
WITH CLASSES_TEACHERS AS
  (SELECT *
   FROM TEACHERS
   JOIN CLASSES ON TEACHERS.ID = CLASSES.TEACHER_ID)
SELECT TEACHER_ID,
       COUNT(PERIOD_ID) AS NUM_PERIODS
FROM CLASSES_TEACHERS
GROUP BY TEACHER_ID
HAVING NUM_PERIODS = 7;
