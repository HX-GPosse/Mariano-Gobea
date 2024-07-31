/*
SELECT * FROM `mariano-gobea.Mariano_Gobea_MELI.Netflix` LIMIT 1000;

-- En este archivo vamos a estar realizando las consultas solicitadas en el Challenge Técnico

SELECT DISTINCT show_id FROM `Mariano_Gobea_MELI.Netflix`;

1) Top 10 países con más títulos en Netflix:
-- Completar con la consulta adecuada para obtener los 10 países con más títulos en Netflix
*/

SELECT country, COUNT(*) AS Total_Titulos
FROM `mariano-gobea.Mariano_Gobea_MELI.Netflix`
GROUP BY country
ORDER BY 2 DESC
LIMIT 10;
-- Esta consulta nos arrojá el TOP 10 Países con más films hechos, pero algo que note es que hay varios registros que cuentan con varios países en la columna Country.
-- Por ejemplo, "United Kingdom, United States" aparece 75 veces, entonces debemos hacer algunos ajustes en este Query.

WITH countries AS (
    SELECT
        title,
        type,
        director,
        `cast`,               -- Debemos poner asi esta columna porque cast es una función reservada en Google BigQuery
        date_added,
        release_year,
        rating,
        duration,
        listed_in,
        description,
        TRIM(country) AS country
    FROM
        `mariano-gobea.Mariano_Gobea_MELI.Netflix`,
        UNNEST(SPLIT(country, ',')) AS country
)
SELECT
    country,
    COUNT(*) AS total_titles
FROM
    countries
WHERE 
    country <> 'Sin Data'
GROUP BY
    country
ORDER BY
    total_titles DESC
LIMIT 10;

-- Ahora la query nos muestra los resultados del TOP 10 Paises y tambien excluimos a aquellos registros que no tenian datos en su interior
-- Si recordamos el EDA nos mostraba que eran un 9.43 % de los datos



/*
2) Géneros más populares:
-- Completar con la consulta adecuada para obtener los géneros más populares en Netflix
En esta consulta vamos a tener el inconveniente principal de que la columna listed_in es un array con varios Generos en su interior, entonces primero debemos separar estos valores y luego sacar el conteo 
*/

WITH genres AS (
    SELECT
        title,
        country,
        release_year,
        rating,
        date_added,
        duration,
        description,
        genre
    FROM
        `mariano-gobea.Mariano_Gobea_MELI.Netflix`,
        UNNEST(SPLIT(listed_in, ',')) AS genre           
)
SELECT
    genre AS genre_name,
    COUNT(*) AS total_titles
FROM
    genres
GROUP BY
    genre_name
ORDER BY
    total_titles DESC;

/* 
En este query hicimos uso de dos funciones, SPLIT y UNNEST para poder separar los datos dentro de la columna listed_in que contenia arrays de los distintos generos a los cuales pertenecen los diferentes titulos
La función SPLIT lo que hace es tomar la columna listed_in y separar los valores en una lista por coma
La funcion UNNEST va a tomar esta lista, separada por SPLIT, y crea una nueva fila para cada genero
Y luego se hace un conteo d lo que arroja esta lista
*/

-- Si quisieramos podriamos ignorar el hecho de que en la columna listed_in los datos estan en arrays y hacer el conteo de generos 

SELECT listed_in, COUNT(*) AS Total_Generos
FROM `mariano-gobea.Mariano_Gobea_MELI.Netflix`
GROUP BY listed_in
ORDER BY 2 DESC
;
-- Los resultados serian completamente otros y no serían correctos


/*
3) Cantidad de títulos lanzados por año:
-- Completar con la consulta adecuada para obtener la cantidad de títulos lanzados por año en Netflix

En esta query podemos tomar dos caminos diferentes ya que tenemos dos campos de fecha, date_added y release_year, pero sabemos que existe una diferencia entre estos dos campos
date_added contiene la fecha en que se añadio el titulo a la plataforma de Netflix
release_year es el año en el cual el titulo se estreno

La consulta nos esta preguntando por cuando fueron lanzados en la plataforma de Netflix, pero igual voy a hacer ambas consultas ya que no difieren mucho
*/


SELECT
    EXTRACT(YEAR FROM PARSE_DATE('%Y-%m-%d', date_added)) AS year,
    COUNT(*) AS total_titulos
FROM
    `mariano-gobea.Mariano_Gobea_MELI.Netflix`
GROUP BY
    year
ORDER BY
    total_titulos DESC;

/*
Para poder realizar la consulta tuvimos que convertir el campo date_added a tipo DATE, esta en STRING en la estructura de la tabla
Utilizamos la funcion PARSE_DATE para convertir este campo, date_added, a tipo DATE y poder extraer el YEAR.
Como mencione antes, esta consulta debemos hacerla con el campo date_added ya que hace mencion a cuando se lanzo en la plataforma de Netflix y no sobre cuando se estreno el titulo

Pero como el código es bastante fácil tambien lo dejo a continuacion pensando que la consulta dijera " Cantidad de titulos estrenados por año"
*/

SELECT release_year, 
      COUNT(*) AS total_titulos
FROM `mariano-gobea.Mariano_Gobea_MELI.Netflix`
GROUP BY release_year
ORDER BY total_titulos DESC;

