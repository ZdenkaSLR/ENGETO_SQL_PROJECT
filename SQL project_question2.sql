-- Skripty k SQL projektu 4/7, Datová akademie 6. 12. 2023 
-- Zdeňka Sailerová | Discord zdenka_26904

-- Výzkumná otázka 2: Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

-- Postup:
-- Ceny potravin v letech 2006 a 2018 porovnávám s měsíční mzdou, která je zprůměrovaná napříč odvětvími ve sledovaném roce. 
-- Průměrná mzda napříč odvětvími v roce 2006 byla 20,754 Kč/měs. V roce 2018 průměrná mzda byla 32 536 Kč/měs. 
-- Cena v roce 2006 za Chléb konzumní kmínový byla 16,12 Kč/kg. V roce 2018 stál chléb 24,24 Kč/kg.
-- Cena v roce 2006 za Mléko polotučné pasterované byla 14,44 Kč/l. V roce 2018 stálo mléko 19,82 Kč/l. 

-- Odpověď: 
-- V roce 2006 bylo možné z průměrné měsíční mzdy koupit 1 287 kg chleba konzumního kmínového nebo 1 437 l mléka polotučného pasterovaného.
-- V roce 2018 bylo možné z průměrné měsíční mzdy koupit 1 342 kg chleba konzumního kmínového nebo 1 641 l mléka polotučného pasterovaného.


SELECT 
    food_year,
    food_category ,
    food_price,
    food_unit,
    round(avg(industry_wage),0) AS average_monthly_wage,
    wage_unit,
    floor((avg(industry_wage)/food_price)) AS how_much_food_from_avg_wage
FROM t_zdenka_sailerova_primarni 
WHERE food_category  IN ('Chléb konzumní kmínový', 'Mléko polotučné pasterované')
AND food_year IN (2006, 2018)
GROUP BY food_year, food_category 
ORDER BY food_year;
