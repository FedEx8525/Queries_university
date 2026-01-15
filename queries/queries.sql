-- 1. Retorna un llistat amb el primer cognom, segon cognom i el nom de tots els/les alumnes. El llistat haurà d'estar ordenat alfabèticament de menor a major pel primer cognom, segon cognom i nom.
SELECT p.apellido1, p.apellido2, p.nombre
    FROM persona p
    WHERE p.tipo = 'alumno'
    ORDER BY p.apellido1 ASC, p.apellido2 ASC, p.nombre ASC;

-- 2. Esbrina el nom i els dos cognoms dels alumnes que no han donat d'alta el seu número de telèfon en la base de dades. (nombre, apellido1, apellido2)
SELECT p.nombre, p.apellido1, p.apellido2
    FROM persona p
    WHERE p.tipo = 'alumno' AND p.telefono IS NULL;

-- 3. Retorna el llistat dels alumnes que van néixer en 1999. (id, nombre, apellido1, apellido2, fecha_nacimiento)
SELECT p.id, p.nombre, p.apellido1, p.apellido2, p.fecha_nacimiento
    FROM persona p
    WHERE p.tipo = 'alumno' AND YEAR(p.fecha_nacimiento) = 1999;


-- 4. Retorna el llistat de professors/es que no han donat d'alta el seu número de telèfon en la base de dades i a més el seu NIF acaba en K. (nombre, apellido1, apellido2, nif)
SELECT p.nombre, p.apellido1, p.apellido2, p.nif
    FROM persona p
    WHERE p.tipo = 'profesor' AND p.nif LIKE '%K';

-- 5. Retorna el llistat de les assignatures que s'imparteixen en el primer quadrimestre, en el tercer curs del grau que té l'identificador 7. (id, nombre, cuatrimestre, curso, id_grado)
SELECT a.id , a.nombre, a.cuatrimestre, a.curso, a.id_grado
    FROM asignatura a
    WHERE a.cuatrimestre = 1 AND a.curso = 3 AND a.id_grado = 7;

-- 6. Retorna un llistat dels professors/es juntament amb el nom del departament al qual estan vinculats. El llistat ha de retornar quatre columnes, primer cognom, segon cognom, nom i nom del departament. El resultat estarà ordenat alfabèticament de menor a major pels cognoms i el nom. (apellido1, apellido2, nombre, departamento)
SELECT p.apellido1, p.apellido2, p.nombre, d.nombre AS departamento
    FROM persona p
    INNER JOIN profesor p2
    ON p.id = p2.id_profesor
    INNER JOIN departamento d
  ON p2.id_departamento = d.id
    ORDER BY p.apellido1 ASC, p.apellido2 ASC, p.nombre ASC;

-- 7. Retorna un llistat amb el nom de les assignatures, any d'inici i any de fi del curs escolar de l'alumne/a amb NIF 26902806M. (nombre, anyo_inicio, anyo_fin)
SELECT a.nombre, c.anyo_inicio, c.anyo_fin
    FROM asignatura a
    INNER JOIN alumno_se_matricula_asignatura a_s_m_a
    ON a.id = a_s_m_a.id_asignatura
    INNER JOIN persona p
    ON a_s_m_a.id_alumno = p.id
    INNER JOIN curso_escolar c
    ON a_s_m_a.id_curso_escolar = c.id
    WHERE p.nif = '26902806M';

-- 8. Retorna un llistat amb el nom de tots els departaments que tenen professors/es que imparteixen alguna assignatura en el Grau en Enginyeria Informàtica (Pla 2015). (nombre)
SELECT DISTINCT d.nombre
    FROM profesor p
    INNER JOIN departamento d
    ON  p.id_departamento = d.id
    INNER JOIN asignatura a
    ON p.id_profesor = a.id_profesor
    INNER JOIN grado g
    ON a.id_grado = g.id
    WHERE g.nombre = 'Grado en Ingeniería Informática (Plan 2015)';

-- 9. Retorna un llistat amb tots els alumnes que s'han matriculat en alguna assignatura durant el curs escolar 2018/2019. (nombre, apellido1, apellido2)
SELECT DISTINCT p.nombre, p.apellido1, p.apellido2
    FROM persona p
    INNER JOIN alumno_se_matricula_asignatura a_s_m_a
    ON p.id = a_s_m_a.id_alumno
    INNER JOIN curso_escolar c_e
    ON a_s_m_a.id_curso_escolar = c_e.id
    WHERE c_e.anyo_inicio = 2018;

-- Resol les 6 següents consultes utilitzant les clàusules LEFT JOIN i RIGHT JOIN.
-- 10. Retorna un llistat amb els noms de tots els professors/es i els departaments que tenen vinculats. El llistat també ha de mostrar aquells professors/es que no tenen cap departament associat. El llistat ha de retornar quatre columnes, nom del departament, primer cognom, segon cognom i nom del professor/a. El resultat estarà ordenat alfabèticament de menor a major pel nom del departament, cognoms i el nom. (departamento, apellido1, apellido2, nombre)
SELECT d.nombre AS departamento, p2.apellido1, p2.apellido2, p2.nombre
    FROM profesor p
    INNER JOIN persona p2
        ON p.id_profesor = p2.id
    LEFT JOIN departamento d
        ON p.id_departamento = d.id
    ORDER BY d.nombre ASC, p2.apellido1 ASC, p2.apellido2 ASC, p2.nombre ASC;

-- 11. Retorna un llistat amb els professors/es que no estan associats a un departament. (apellido1, apellido2, nombre)
 SELECT p2.apellido1, p2.apellido2, p2.nombre
    FROM profesor p
    INNER JOIN persona p2
        ON p.id_profesor = p2.id
    LEFT JOIN departamento d
        ON p.id_departamento = d.id
    WHERE d.id IS NULL;

-- 12. Retorna un llistat amb els departaments que no tenen professors/es associats. (nombre)
 SELECT d.nombre
    FROM departamento d
    LEFT JOIN profesor p
    ON d.id = p.id_departamento
    WHERE p.id_departamento IS NULL;

-- 13. Retorna un llistat amb els professors/es que no imparteixen cap assignatura. (apellido1, apellido2, nombre)
SELECT p2.apellido1, p2.apellido2, p2.nombre
    FROM asignatura a
    RIGHT JOIN profesor p
    ON p.id_profesor = a.id_profesor
    INNER JOIN persona p2
        ON p.id_profesor = p2.id
    WHERE a.id IS NULL;

-- 14. Retorna un llistat amb les assignatures que no tenen un professor/a assignat. (id, nombre)
 SELECT a.id, a.nombre
    FROM profesor p
    RIGHT JOIN asignatura a
    ON p.id_profesor = a.id_profesor
    WHERE p.id_profesor IS NULL;

-- 15. Retorna un llistat amb tots els departaments que no han impartit assignatures en cap curs escolar. (nombre)
SELECT d.nombre FROM departamento d LEFT JOIN ( SELECT DISTINCT prof.id_departamento FROM profesor prof INNER JOIN asignatura a ON prof.id_profesor = a.id_profesor) AS departamento_con_asignatura ON d.id = departamento_con_asignatura.id_departamento WHERE departamento_con_asignatura.id_departamento IS NULL;


-- 16. Retorna el nombre total d'alumnes que hi ha. (total)
SELECT COUNT(*) AS total
    FROM persona
    WHERE tipo = 'alumno';

-- 17. Calcula quants alumnes van néixer en 1999. (total)
 SELECT COUNT(*) AS total
    FROM persona
    WHERE tipo = 'alumno' AND YEAR(fecha_nacimiento) = 1999;


-- 18. Calcula quants professors/es hi ha en cada departament. El resultat només ha de mostrar dues columnes, una amb el nom del departament i una altra amb el nombre de professors/es que hi ha en aquest departament. El resultat només ha d'incloure els departaments que tenen professors/es associats i haurà d'estar ordenat de major a menor pel nombre de professors/es. (departamento, total)
SELECT d.nombre AS departamento, COUNT(p.id_profesor) AS total
    FROM profesor p
    JOIN departamento d
    ON p.id_departamento = d.id
    GROUP BY d.nombre
    ORDER BY total DESC;

-- 19. Retorna un llistat amb tots els departaments i el nombre de professors/es que hi ha en cadascun d'ells. Tingui en compte que poden existir departaments que no tenen professors/es associats. Aquests departaments també han d'aparèixer en el llistat. (departamento, total)
 SELECT d.nombre AS departamento, COUNT(p.id_profesor) AS total
    FROM profesor p
    JOIN departamento d
    ON p.id_departamento = d.id
    GROUP BY d.nombre
    ORDER BY total DESC;

-- 20. Retorna un llistat amb el nom de tots els graus existents en la base de dades i el nombre d'assignatures que té cadascun. Tingues en compte que poden existir graus que no tenen assignatures associades. Aquests graus també han d'aparèixer en el llistat. El resultat haurà d'estar ordenat de major a menor pel nombre d'assignatures. (grau, total)
SELECT g.nombre AS grau, COUNT(a.id_grado) AS total
    FROM asignatura a
    RIGHT JOIN grado g
    ON a.id_grado = g.id
    GROUP BY g.nombre
    ORDER BY total DESC;

-- 21. Retorna un llistat amb el nom de tots els graus existents en la base de dades i el nombre d'assignatures que té cadascun, dels graus que tinguin més de 40 assignatures associades. (grau, total)
SELECT g.nombre AS grau, COUNT(a.id_grado) AS total
    FROM asignatura a
    RIGHT JOIN grado g
    ON a.id_grado = g.id
    GROUP BY g.nombre
    HAVING total > 40
    ORDER BY total DESC;

-- 22. Retorna un llistat que mostri el nom dels graus i la suma del nombre total de crèdits que hi ha per a cada tipus d'assignatura. El resultat ha de tenir tres columnes: nom del grau, tipus d'assignatura i la suma dels crèdits de totes les assignatures que hi ha d'aquest tipus. (grau, tipus, total_creditos)
SELECT g.nombre AS grau, a.tipo, SUM(a.creditos) AS total_creditos
    FROM grado g
    INNER JOIN asignatura a
    ON g.id = a.id_grado
    GROUP BY g.nombre, a.tipo;

-- 23. Retorna un llistat que mostri quants alumnes s'han matriculat d'alguna assignatura en cadascun dels cursos escolars. El resultat haurà de mostrar dues columnes, una columna amb l'any d'inici del curs escolar i una altra amb el nombre d'alumnes matriculats. (anyo_inicio, total)
SELECT c_e.anyo_inicio, COUNT(DISTINCT a_s_m_a.id_alumno) AS total
    FROM curso_escolar c_e
    INNER JOIN alumno_se_matricula_asignatura a_s_m_a
    ON c_e.id = a_s_m_a.id_curso_escolar
    GROUP BY c_e.anyo_inicio;

-- 24. Retorna un llistat amb el nombre d'assignatures que imparteix cada professor/a. El llistat ha de tenir en compte aquells professors/es que no imparteixen cap assignatura. El resultat mostrarà cinc columnes: id, nom, primer cognom, segon cognom i nombre d'assignatures. El resultat estarà ordenat de major a menor pel nombre d'assignatures. (id, nombre, apellido1, apellido2, total)
 SELECT p.id, p. nombre, p.apellido1, p.apellido2, COUNT(a.id) AS total
    FROM persona p
    INNER JOIN profesor p2
    ON p.id = p2.id_profesor
    LEFT JOIN asignatura a
    ON p2.id_profesor = a.id_profesor
    GROUP BY p.id, p. nombre, p.apellido1, p.apellido2
    ORDER BY total DESC;

-- 25. Retorna totes les dades de l'alumne/a més jove. (*)
SELECT *
    FROM persona
    WHERE tipo = 'alumno'
    ORDER BY fecha_nacimiento DESC LIMIT 1;

-- 26. Retorna un llistat amb els professors/es que tenen un departament associat i que no imparteixen cap assignatura. (apellido1, apellido2, nombre)
SELECT p2.apellido1, p2.apellido2, p2.nombre
    FROM profesor p
    INNER JOIN persona p2
    ON p.id_profesor = p2.id
    LEFT JOIN asignatura a
    ON p.id_profesor = a.id_profesor
    WHERE p.id_departamento IS NOT NULL AND a.id IS NULL;
