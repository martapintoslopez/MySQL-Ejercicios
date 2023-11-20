USE `sakila`; 

/* 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.*/
SELECT DISTINCT `title`
	FROM `film`;

/* 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".*/
SELECT `title`
	FROM `film`
    WHERE `rating` = "PG-13";

/* 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.*/
SELECT `title`, `description`
	FROM `film`
    WHERE `description`LIKE '%amazing%';

/* 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.*/
SELECT `title`
	FROM `film`
    WHERE `length` > 120; -- La tabla film tiene el tiempo ya en minutos por lo que no hay que convertirlo ni nada.

/* 5. Recupera los nombres de todos los actores.*/
SELECT `first_name`, `last_name`
	FROM `actor`;

SELECT `first_name` -- Así solo nos devolverá el nombre de los actores
	FROM `actor`;

/* 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.*/
SELECT `first_name`, `last_name`
	FROM `actor`
    WHERE `last_name` = 'Gibson'; 
    
SELECT `first_name`, `last_name`
	FROM `actor`
    WHERE `last_name` LIKE '%Gibson%';
-- He probado ambas opciones por si alguno tenía un apellido compuesto con 'Gibson'. No lo hay. Solo hay un actor con dicho apellido.

/* 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.*/
SELECT `first_name`, `last_name`
	FROM `actor`
    WHERE `actor_id` BETWEEN 10 AND 20;

SELECT `first_name` -- Así solo nos devolvería el nombre de los actores
	FROM `actor`
    WHERE `actor_id` BETWEEN 10 AND 20;

/* 8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.*/
SELECT `title`
	FROM `film`
    WHERE `rating` <> "PG-13" AND `rating` <> "R";

/* 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.*/
SELECT COUNT(`title`) AS `cantidad_peliculas_por_clasificacion`, `rating`
	FROM `film`
    GROUP BY `rating`;

/* 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad 
de películas alquiladas.
- Tabla rental: rental_id, customer_id
- Tabla customer: customer_id, first_name, last_name*/
SELECT `c`.`customer_id`, `first_name`, `last_name`, COUNT(`rental_id`) AS `numero_peliculas_alquiladas`
	FROM `rental` AS `r`
    INNER JOIN `customer` AS `c`
    ON `c`.`customer_id` = `r`.`customer_id`
    GROUP BY `r`.`customer_id`;

/* 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.
- Tabla rental: rental_id, inventory_id
- Tabla inventory: inventory_id, film_id
- Tabla film: film_id    
- Tabla film_category: film_id, category_id
- Tabla category: category_id, name*/
SELECT COUNT(`r`.`rental_id`) AS `cantidad_peliculas_categoria`, `cat`.`name`
	FROM `rental` AS `r`
INNER JOIN `inventory` AS `i`
	ON `r`.`inventory_id` = `i`.`inventory_id`
INNER JOIN `film` AS `f` 
	ON `i`.`film_id` = `f`.`film_id`
INNER JOIN `film_category` AS `fcat`
	ON `f`.`film_id` = `fcat`.`film_id`
INNER JOIN `category` AS `cat`
	ON `fcat`.`category_id` = `cat`.`category_id`
	GROUP BY `cat`.`name`;


/* 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.*/
SELECT AVG(`f`.`length`) AS `duración_media_peliculas_clasificacion`, `rating`
	FROM `film` AS `f` 
    GROUP BY `rating`;

/* 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".
- Tabla actor: actor_id, first_name, last_name
- Tabla film_actor: actor_id, film_id
- Tabla film: film_id, title = "Indian Love"*/
SELECT `first_name`, `last_name`
	FROM `actor` AS `a`
INNER JOIN `film_actor` AS `fac`
	ON `a`.`actor_id` = `fac`.`actor_id`
INNER JOIN `film` AS `f`
	ON `fac`.`film_id` = `f`.`film_id`
    WHERE `title` = "Indian Love";

/* 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.*/
SELECT `title`
	FROM `film`
    WHERE LOWER(`description`) LIKE '% dog %' OR LOWER(`description`) LIKE '% cat %' OR -- palabras en medio de texto
			LOWER(`description`) LIKE 'dog %' OR LOWER(`description`) LIKE 'cat %' OR -- primera palabra
            LOWER(`description`) LIKE '% dog' OR LOWER(`description`) LIKE '% cat'; -- última palabra

/* 15. Hay algún actor que no aparecen en ninguna película en la tabla film_actor.*/
SELECT `a`.`first_name`, `a`.`last_name` 
	FROM `actor` AS `a`
LEFT JOIN `film_actor` AS `fac`
	ON `fac`.`actor_id` = `a`.`actor_id`
    GROUP BY `a`.`actor_id`, `fac`.`actor_id` 
	HAVING COUNT(`fac`.`actor_id`) = 0; -- No hay ningún actor que no aparezca en ambas tablas. 
    
/* 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.*/
SELECT `title`
	FROM `film`
    WHERE `release_year` between 2005 and 2010;

/* 17. Encuentra el título de todas las películas que son de la misma categoría que "Family".
- Tabla film: title, film_id
- Tabla film_category: film_id, category_id
- Tabla category: category_id, name*/
SELECT `title`
	FROM `film` AS `f`
INNER JOIN `film_category` AS `fcat`
	ON `f`.`film_id` = `fcat`.`film_id`
INNER JOIN `category` AS `cat`
	ON `fcat`.`category_id` = `cat`.`category_id`
	WHERE `cat`.`name` = "Family";

/* 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.
- Tabla actor: actor_id, first_name, last_name
- Tabla film_actor: actor_id, COUNT film_id > 10*/ 
SELECT `first_name`, `last_name`
	FROM `actor` AS `a`
INNER JOIN `film_actor` AS `fac`
	ON `a`.`actor_id` = `fac`.`actor_id`
    GROUP BY `a`.`actor_id`
    HAVING COUNT(`film_id`) > 10; 

/* 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.*/
SELECT `title`
	FROM `film`
    WHERE `rating` = "R" AND `length` > (2*60); -- Convertimos 2 horas en minutos

/* 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de 
duración.
- Tabla film: title, film_id
- Tabla film_category: film_id, category_id
- Tabla category: category_id, name*/
SELECT `cat`.`name`, AVG(`f`.`length`)
	FROM `film` AS `f`
INNER JOIN `film_category` AS `fcat`
	ON `f`.`film_id` = `fcat`.`film_id`
INNER JOIN `category` AS `cat`
	ON `fcat`.`category_id` = `cat`.`category_id`
    GROUP BY `cat`.`name`
    HAVING AVG(`f`.`length`) > 120; -- Son: Drama, Foreign, Games, Sports

/* 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.*/
SELECT `first_name`, COUNT(`film_id`) AS `numero_peliculas_del_actor` -- Yo incluiría el apellido pero para ceñirme al enunciado solo pongo el nombre
	FROM `actor` AS `a`
INNER JOIN `film_actor` AS `fac`
	ON `a`.`actor_id` = `fac`.`actor_id`
    GROUP BY `first_name`, `last_name`
    HAVING COUNT(`film_id`) > 5;  -- En esta base de datos todos los actores han actuado en más de 5 películas, por lo que esta query nos los devuelve a todos.

/* 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. 
Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes.
- Tabla rental: rental_date, return_date, rental_id, inventory_id
- Tabla inventory: film_id, inventory_id 
- Tabla film: film_id, title*/
SELECT COUNT(`rental_id`), `return_date`
	FROM `rental`
    GROUP BY `return_date`
    HAVING `return_date` IS NULL; -- Tenemos varias filas sin valor en la fecha de devolución. Como puede ser debido a una falta de dato, no los vamos a tener en cuenta
    
SELECT `f`.`title`
	FROM `film` AS `f`
INNER JOIN `inventory` AS `i`
	ON `f`.`film_id` = `i`.`film_id`
INNER JOIN (SELECT `rental_id`, `inventory_id`  -- Aquí sacamos los rental_id como nos pide el título aunque realmente no los utilizo después ya que uno por el inventory_id
				FROM `rental`
				WHERE DATEDIFF(`return_date`, `rental_date`) > 5) AS `alquiler_mas_de_5dias` /*Había puesto "AND DATEDIFF(return_date, rental_date) IS NOT NULL" pero me he dado cuenta de que es redundante*/
	ON `alquiler_mas_de_5dias`.`inventory_id` = `i`.`inventory_id`
    GROUP BY `f`.`title`; 

/* 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". Utiliza una subconsulta para encontrar los 
actores que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.
- actor: actor_id,first_name, last_name
- film_actor: actor_id, film_id
- film: film_id
- film_category: film_id, category_id
- category: category_id, name = 'Horror'*/
SELECT `first_name`, `last_name`
	FROM `actor` AS `a`
LEFT JOIN `film_actor` AS `fac`
	ON `a`.`actor_id` = `fac`.`actor_id`
LEFT JOIN `film` AS `f`
	ON `fac`.`film_id` = `f`.`film_id`
LEFT JOIN `film_category` AS `fcat`
	ON `f`.`film_id` = `fcat`.`film_id`
LEFT JOIN `category` AS `cat`
	ON `fcat`.`category_id` = `cat`.`category_id`
    WHERE `a`.`actor_id` NOT IN (SELECT DISTINCT `a`.`actor_id`
								FROM `actor` AS `a`
							INNER JOIN `film_actor` AS `fac`
								ON `a`.`actor_id` = `fac`.`actor_id`
							INNER JOIN `film` AS `f`
								ON `fac`.`film_id` = `f`.`film_id`
							INNER JOIN `film_category` AS `fcat`
								ON `f`.`film_id` = `fcat`.`film_id`
							INNER JOIN `category` AS `cat`
								ON `fcat`.`category_id` = `cat`.`category_id`
								WHERE `cat`.`name` = 'Horror')
	GROUP BY `a`.`actor_id`;

/* 24. BONUS: Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film.
- film: film_id, title
- film_category: film_id, category_id
- category: category_id, name = 'Horror'*/
SELECT `f`.`title`
	FROM `film` AS `f`
INNER JOIN `film_category` AS `fcat`
	ON `f`.`film_id` = `fcat`.`film_id`
INNER JOIN `category` AS `cat`
	ON `fcat`.`category_id` = `cat`.`category_id`
    WHERE `cat`.`category_id` = (SELECT `category_id`
								FROM `category`
								WHERE LOWER(`name`) = 'comedy')
			AND `length` > 180;

/* 25. BONUS: Encuentra todos los actores que han actuado juntos en al menos una película. La consulta debe mostrar el nombre y apellido de 
los actores y el número de películas en las que han actuado juntos.
- actor: actor_id, first_name, last_name
- film_actor: actor_id, film_id*/
SELECT CONCAT(`a1`.`first_name`, " ", `a1`.`last_name`) AS `actor1`, 
        CONCAT(`a2`.`first_name`, " ", `a2`.`last_name`) AS `actor2`,
        COUNT(DISTINCT `fac1`.`film_id`) AS `numero_peliculas_juntos`
	FROM `film_actor` AS `fac1`
INNER JOIN `actor` AS `a1` 
	ON `fac1`.`actor_id` = `a1`.`actor_id`
INNER JOIN `film_actor` AS `fac2`
	ON `fac1`.`film_id` = `fac2`.`film_id` AND `fac1`.`actor_id` < `fac2`.`actor_id` -- Ponemos mayor para que solo se le cuente una vez a cada uno
INNER JOIN `actor` AS `a2` 
	ON `fac2`.`actor_id` = `a2`.`actor_id`
GROUP BY `a1`.`actor_id`, `a2`.`actor_id`
HAVING `numero_peliculas_juntos` >= 1;