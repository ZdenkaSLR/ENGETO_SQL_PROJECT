-- Skripty k SQL projektu 2/7, Datová akademie 6. 12. 2023 
-- Zdeňka Sailerová | Discord zdenka_26904

-- Zadání: Jako dodatečný materiál připravte i tabulku s HDP, GINI koeficientem a populací dalších evropských států ve stejném období, jako primární přehled pro ČR.

-- Postup pro vytvoření sekundární tabulky:
    -- Spojuji Tabulky economies a countries pomocí JOIN přes společnou hodnotu country.
    -- Vybírám pouze požadované sloupce a období omezuji na roky 2006 až 2018, stejně tak omezuji výběr pouze na evropské státy.


CREATE OR REPLACE TABLE t_zdenka_sailerova_sekundarni AS
SELECT 
    c.country,
    e.year,
    c.population,
    e.GDP,
    e.gini
FROM countries c 
JOIN economies e
    ON c.country = e.country 
WHERE e.year BETWEEN 2006 AND 2018
AND c.continent = 'Europe'
ORDER BY `year`, country 