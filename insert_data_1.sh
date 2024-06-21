#!/bin/bash

# Script to insert data from courses.csv and students.csv into students database

PSQL="psql -X --username=freecodecamp --dbname=students --no-align --tuples-only -c"
echo $($PSQL "TRUNCATE students, majors, courses, majors_courses")

cat courses.csv | while IFS="," read MAJOR COURSE
do
  if [[ $MAJOR != "major" ]] #evito la primera fila, que tiene los encabezados
  then
    # get major_id
    MAJOR_ID=$($PSQL "SELECT major_id FROM majors WHERE major='$MAJOR'")
    #comillas simples porque major es varchar

    # if not found
    if [[ -z $MAJOR_ID ]] #si no hay una major_id con esta major
    then
      # insert major
      INSERT_MAJOR_RESULT=$($PSQL "INSERT INTO majors(major) VALUES('$MAJOR')")
      if [[ $INSERT_MAJOR_RESULT == "INSERT 0 1" ]] #0 errores 1 insercion. Si fue exitosa la insercion entro
      then
        echo Inserted into majors, $MAJOR
      fi

      # get new major_id
      MAJOR_ID=$($PSQL "SELECT major_id FROM majors WHERE major='$MAJOR'") #obtengo la major_id asignada por SERIAL para esta major
    fi

    # get course_id
    COURSE_ID=$($PSQL "SELECT course_id FROM courses WHERE course='$COURSE'")

    # if not found
    if [[ -z $COURSE_ID ]]
    then
      # insert course
      INSERT_COURSE_RESULT=$($PSQL "INSERT INTO courses(course) VALUES('$COURSE')")
      if [[ $INSERT_COURSE_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into courses, $COURSE
      fi

      # get new course_id
      COURSE_ID=$($PSQL "SELECT course_id FROM courses WHERE course='$COURSE'") #obtengo la course_id asignada por SERIAL para este curso
    fi

    # insert into majors_courses. Uso la major_id y el course_id creados para el major y curso actual
    INSERT_MAJORS_COURSES_RESULT=$($PSQL "INSERT INTO majors_courses(major_id, course_id) VALUES($MAJOR_ID, $COURSE_ID)")
    #como son enteros, estas variables major_id course_id se ingresan sin comillas simples
    if [[ $INSERT_MAJORS_COURSES_RESULT == "INSERT 0 1" ]]
    then
      echo Inserted into majors_courses, $MAJOR : $COURSE
    fi
  fi
done
cat students.csv | while IFS="," read FIRST LAST MAJOR GPA
do
  if [[ $FIRST != "first_name" ]]
  then
    #get major_id
    MAJOR_ID=$($PSQL "SELECT major_id FROM majors WHERE major='$MAJOR'")
    #if not found
    if [[ -z $MAJOR_ID ]]
    then
      #set to null
      MAJOR_ID=null
    fi
    #insert student
    INSERT_STUDENT_RESULT=$($PSQL "INSERT INTO students(first_name, last_name, major_id, gpa) VALUES('$FIRST', '$LAST', $MAJOR_ID, $GPA)")
    #NOTA: Las variables que no son VARCHAR van sin comillas simples, como GPA, o MAJOR_ID, sean tanto creadas en el cat o como variables comunes
    if [[ $INSERT_STUDENT_RESULT == "INSERT 0 1" ]]
    then
      echo Inserted into students, $FIRST $LAST
    fi
  fi
done
