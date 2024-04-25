-- Skripty k SQL projektu 5/7, Datová akademie 6. 12. 2023 
-- Zdeňka Sailerová | Discord zdenka_26904

-- Výzkumná otázka 3: Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

-- Postup:
-- Porovnávám změny cen potravin v daném a následujícím roce, obdobně jako v otázce 1. 
-- Tabulky spojuji pomocí JOIN primární tabulky na primární tabulku posunutou o jeden rok, aby bylo možné porovnávat meziroční změny

-- Odpověď: 
-- V porovnání se objevily 2 kategorie, které v rozmezí let 2006–2018 nezdražují, ale dokonce zlevňují. 
-- Jedná se o Cukr krystalový, který v průměru zlevnil o 1,92 %. 
-- Druhou surovinou, která zlevnila v průměru o 0,74 % jsou Rajská jablka červená kulatá. 


SELECT *
FROM (
    SELECT 
        avr.food_category,
        round(avg(avr.difference_in_pct),2) AS avr_final_in_pct
    FROM (
        SELECT
            A.food_category,
            A.food_year AS current_year,
            A.food_price AS food_price_current_year,
            B.food_year AS next_year,
            B.food_price AS food_price_next_year,
            A.food_unit,
            (B.food_price-A.food_price)/A.food_price*100 AS difference_in_pct 
        FROM t_zdenka_sailerova_primarni A
        JOIN t_zdenka_sailerova_primarni B
            ON A.food_year = B.food_year-1
            AND A.food_category = B.food_category 
        GROUP BY food_category, current_year, next_year        
        ) AS avr
    GROUP BY avr.food_category
) AS sub
ORDER BY sub.avr_final_in_pct;
