-- 1- ORDER BY
-- Se puede obtener el resultado de la query ordenado en forma ascendente o descendente
SELECT * FROM students ORDER BY gpa DESC;

-- 2- multiples condiciones para el ORDER BY
-- Una vez se ordena de una forma, se puede 'subordenar' los subconjuntos que fueron ordenados de cierta forma y que 'empatan' en el primer criterio
SELECT * FROM students ORDER BY gpa DESC, first_name ASC;

-- Aqui, si hay alumnos con el mismo gpa, se van a ordenar por nombre de manera ascendente, una vez fueron ordenados por GPA

-- 3- LIMIT
-- Poda el resultado de la query hasta cierta cantidad de registros. Se pone al final de la query
SELECT * FROM students ORDER BY gpa DESC, first_name ASC LIMIT 10;

-- 4- Order by, where, limit todos juntos
-- No se puede poner el ORDER BY antes del WHERE.
-- No se puede poner el LIMIT antes del ORDER BY o el WHERE, siempre debe estar al final.
SELECT * FROM students WHERE gpa IS NOT NULL ORDER BY gpa DESC, first_name LIMIT 10;

-- 4- MIN MAX
-- Las columnas que tienen tipo NUMERIC tienen operaciones matematicas especiales
SELECT MIN(gpa) FROM students;
SELECT MAX(gpa) FROM students;
SELECT SUM(gpa) FROM students;
SELECT AVG(gpa) FROM students;
SELECT CEIL(AVG(gpa)) FROM students; -- Redondea para arriba
SELECT ROUND(AVG(gpa)) FROM students; -- Redondea para abajo
SELECT ROUND(AVG(gpa), 5) FROM students; -- Redondea para abajo desde el 5to decimal

-- 5- COUNT: cuenta la cantidad de registros
SELECT COUNT(*) FROM majors; -- Esto cuenta tambien las cosas que son NULL
SELECT COUNT(major_id) FROM majors; -- Esto cuenta las cosas que tienen cosas NO NULL en la columna major_id

-- 6- DISTINCT: Da las cosas que no se repiten
SELECT DISTINCT(major_id) FROM students;

-- 7- GROUP BY: Da subconjuntos agrupados segun cierta condicion. 
-- Si no haces nada con el resultado del group by, es como un distinct, agrupa segun las cosas que tienen en comun la columna major_id
SELECT major_id FROM students GROUP BY major_id;

-- Generalmente se quieren hacer cuentas con las columnas que se estan agrupando en base a las cosas que tienen en comun las cosas segun major_id.

-- Por ejemplo, podria obtener la cantidad de estudiantes que caen en los subconjuntos de cada major_id
SELECT major_id, COUNT(major_id) FROM students GROUP BY major_id;
-- Si hay 6 estudiantes que estan para la major que tiene major_id = 42, esto me lo dira. No solo eso, la columna que se crea para el result set tiene el nombre de COUNT.
-- Le puedo poner el nombre que yo quiera con AS:
SELECT major_id, COUNT(major_id) AS cant_estudiantes FROM students GROUP BY major_id;

-- El problema con la query anterior es que si hay NULLS, gente que no tiene major_id, no los va a considerar. Es necesario usar *:
SELECT major_id, COUNT(*) FROM students GROUP BY major_id;

/*
La idea del GROUP BY no es darme cada uno de los nombres de los estudiantes que se agrupan bajo esa major_id, pues para eso esta el WHERE.
La idea es crear un result set que tenga esa info compactada, y hacer operaciones numericas con esos grupos, como contar cuantos elementos tiene
cada subconjunto, o calcular el promedio de gpa de los estudiantes que forman parte de cada subconjunto, que estudian esa carrera (si esa data esta en la tabla, sino se puede obtener de otra con un JOIN)
*/

SELECT major_id, AVG(gpa) AS avg_gpa_major FROM students GROUP BY major_id;

-- Por ejemplo, si quisiera obtener cual es el alumno con el mejor promedio en cada carrera:
SELECT major_id, MAX(gpa) AS mejor_promedio FROM students GROUP BY major_id;

-- 8- HAVING
-- Se usa para agregar condiciones sobre los subconjuntos que estamos armando con el GROUP BY.
-- Es como un WHERE que se aplica sobre subconjuntos, en vez de todo el dataset.

-- Por ejemplo, podria agrupar a los estudiantes por la carrera que cursan (major_id) y quedarme con el subconjunto solo si mas de 4 estudiantes cursan la carrera:

SELECT major_id, COUNT(*) FROM students GROUP BY major_id HAVING COUNT(*) > 4;

-- La condicion la ponemos sobre el subconjunto en su totalidad, no sobre los individuos que forman parte del subconjunto. Para eso uso el WHERE con mas condiciones.
-- Es como un check grupal de DnD. O bien todo el grupo en su conjunto tiene exito, o todo el grupo falla, y ni aparece en el set result, el resultado de la query.

-- Por ejemplo, puedo poner como condicion que el grupo tenga al menos una persona que supere los 3.5 de gpa. Si es asi, el subconjunto aparece en el resultado
-- de la query, y vamos a ver esa major_id:
SELECT major_id, MAX(gpa) FROM students GROUP BY major_id HAVING MAX(gpa) > 3.5;

-- La cantidad de personas que forman parte de estos grupos no se ve afectada por la restriccion del gpa, ya que la condicion no se aplica a individuos del subconjunto,
-- sino al subconjunto en su totalidad. Si el subconjunto pasa la prueba, todos pasan la prueba. Podemos ver que todos los miembros del subconjunto siguen alli, no
-- importa que tengan bajo gpa. El nerd de la carrera los salvo:
SELECT major_id, COUNT(*), MAX(gpa) FROM students GROUP BY major_id HAVING MAX(gpa) > 3.5;

