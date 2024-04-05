USE college_manager_sql_schema;

-- Make New Student With Random Courses
INSERT INTO students(students_name, students_email, studentsCourseOneID, studentsCourseTwoID, studentsCourseThreeID)
VALUES (
	'sample2', 
    'sample2@test.com', 
    FLOOR(RAND()*((SELECT MAX(courses_id) FROM courses)-1+1))+1, 
    FLOOR(RAND()*((SELECT MAX(courses_id) FROM courses)-1+1))+1, 
    FLOOR(RAND()*((SELECT MAX(courses_id) FROM courses)-1+1))+1
);

-- Get info for adding the grades
SELECT * FROM students WHERE students_name='sample2';
SELECT * FROM professors;

-- Add New Grades Into the System.
INSERT INTO grades(grades_students_id, grades_professors_id, grades_value, grades_courses_id)
VALUES (
	(SELECT students_id FROM students WHERE students_name = 'sample2' LIMIT 1),
    (SELECT professors_id FROM professors WHERE professors_name = ''),
    RAND()*100,
    (SELECT studentsCourseOneID FROM students WHERE students_name = 'sample2')
);

-- Make new Professors
INSERT INTO professors(professors_name, professors_email, professorsCourseOneID, professorsCourseTwoID, professorsCourseThreeID)
VALUES (
	'sampleProfessor1', 
    'sampleProfessor1@test.com', 
    FLOOR(RAND()*((SELECT MAX(courses_id) FROM courses)-1+1))+1, 
    FLOOR(RAND()*((SELECT MAX(courses_id) FROM courses)-1+1))+1, 
    FLOOR(RAND()*((SELECT MAX(courses_id) FROM courses)-1+1))+1
);

-- Make New Course
INSERT INTO courses(courses_name)
VALUES ('Chemistry');

-- Average Grade from Professor 
SELECT professors_name as 'Name', FLOOR(AVG(grades_value)) AS 'Average Grade Given'
FROM professors p
JOIN grades g
ON g.grades_professors_id = professors_id
GROUP BY professors_id;

-- Top Grades for Each Student 
SELECT students_name as 'Name', MAX(grades_value) AS Best_Grade
FROM students s
JOIN grades g
ON g.grades_students_id = students_id
GROUP BY students_id
ORDER BY Best_Grade DESC;

-- Sort Students by Courses
SELECT courses_name as 'Course', students_name as 'Student Name'
FROM students s
JOIN courses c
ON ( c.courses_id = s.studentsCourseOneID
	OR c.courses_id = s.studentsCourseTwoID
	OR c.courses_id = s.studentsCourseThreeID
)
ORDER BY c.courses_id;

-- Courses Summary
SELECT courses_name AS 'Course', FLOOR(AVG(grades_value)) AS 'Average Grade'
FROM courses c
JOIN grades g
ON g.grades_courses_id = courses_id
GROUP BY courses_id
ORDER BY FLOOR(AVG(grades_value)) ASC;

-- Student and Professor Common Courses 
SELECT students_name AS 'Student', professors_name AS 'Professor', COUNT(students_id) AS Shared_Classes
FROM courses c
JOIN students s
ON (s.studentsCourseOneID = c.courses_id
	OR s.studentsCourseTwoID = c.courses_id
    OR s.studentsCourseThreeID = c.courses_id
)
JOIN professors p
ON (p.professorsCourseOneID = c.courses_id
	OR p.professorsCourseTwoID = c.courses_id
    OR p.professorsCourseThreeID = c.courses_id
)
WHERE (p.professorsCourseOneID = s.studentsCourseOneID
	OR p.professorsCourseTwoID = s.studentsCourseTwoID
    OR p.professorsCourseThreeID = s.studentsCourseThreeID)
GROUP BY students_name, professors_name
ORDER BY Shared_Classes DESC LIMIT 1;

-- UPDATE grades
-- SET grades_courses_id = 5
-- WHERE grades_id = 7;

-- UPDATE students
-- SET studentsCourseOneID = 4, studentsCourseTwoID = 5 
-- WHERE students_id = 3;

-- UPDATE professors
-- SET professorsCourseTwoID = 5, professorsCourseThreeID = null
-- WHERE professors_id = 2;
 
-- UPDATE courses
-- SET courses_name = 'str'
-- WHERE courses_id = int


-- DUPLICATION ERROR EXAMPLE
-- SELECT *
-- FROM students s
-- JOIN courses c
-- ON s.studentsCourseOneID = c.courses_id
-- OR s.studentsCourseTwoID = c.courses_id
-- OR s.studentsCourseThreeID = c.courses_id
-- JOIN grades g
-- ON g.grades_students_id = s.students_id
-- ORDER BY c.courses_id;