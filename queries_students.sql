-- Info about my computer science students from students database

-- 
-- 1 - First name, last name, and GPA of students with a 4.0 GPA:
SELECT first_name, last_name, gpa FROM students WHERE gpa = 4.0;

-- 2 - All course names whose first letter is before 'D' in the alphabet:
SELECT course FROM courses WHERE course < 'D';

-- 3 - First name, last name, and GPA of students whose last name begins with an 'R' or after and have a GPA greater than 3.8 or less than 2.0:
SELECT first_name, last_name, gpa FROM students WHERE last_name >= 'R' AND (gpa > 3.8 OR gpa < 2.0);

-- 4 - Last name of students whose last name contains a case insensitive 'sa' or have an 'r' as the second to last letter:
SELECT last_name FROM students WHERE last_name ILIKE '%sa%' OR last_name ILIKE '%r_';

-- 5 - First name, last name, and GPA of students who have not selected a major and either their first name begins with 'D' or they have a GPA greater than 3.0:
SELECT first_name, last_name, gpa FROM students WHERE major_id IS NULL AND (first_name LIKE 'D%' OR gpa > 3.0);

-- 6 - Course name of the first five courses, in reverse alphabetical order, that have an 'e' as the second letter or end with an 's':
SELECT course FROM courses WHERE course LIKE '_e%' OR course LIKE '%s' ORDER BY course DESC LIMIT 5;

-- 7 - Average GPA of all students rounded to two decimal places:
SELECT ROUND(AVG(gpa), 2) FROM students;

-- 8 - Major ID, total number of students in a column named 'number_of_students', and average GPA rounded to two decimal places in a column name 'average_gpa', for each major ID in the students table having a student count greater than 1:"
SELECT major_id, COUNT(*) AS number_of_students, ROUND(AVG(gpa), 2) AS average_gpa FROM students GROUP BY major_id HAVING COUNT(*) > 1;

-- 9 - List of majors, in alphabetical order, that either no student is taking or has a student whose first name contains a case insensitive 'ma':
SELECT major FROM students FULL JOIN majors ON students.major_id = majors.major_id WHERE major IS NOT NULL AND (student_id IS NULL OR first_name ILIKE '%ma%') ORDER BY major;

-- 10 - List of unique courses, in reverse alphabetical order, that no student or 'Obie Hilpert' is taking:
SELECT DISTINCT(course) FROM students FULL JOIN majors USING(major_id) FULL JOIN majors_courses USING(major_id) FULL JOIN courses USING(course_id) WHERE student_id IS NULL OR first_name='Obie' ORDER BY course DESC;

-- 11 - List of courses, in alphabetical order, with only one student enrolled:
SELECT course FROM students LEFT JOIN majors_courses USING(major_id) LEFT JOIN courses USING(course_id) GROUP BY course HAVING COUNT(*) = 1 ORDER BY course;
