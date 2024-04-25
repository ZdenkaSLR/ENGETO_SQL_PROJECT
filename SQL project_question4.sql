-- Skripty k SQL projektu 6/7, Datová akademie 6. 12. 2023 
-- Zdeňka Sailerová | Discord zdenka_26904

-- Výzkumná otázka 4: Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

-- Postup:
-- Porovnávám změny cen potravin v daném a následujícím roce, obdobně jako v otázce 1 a 3. 
-- Tabulky spojuji pomocí JOIN primární tabulky na primární tabulku posunutou o jeden rok, aby bylo možné porovnávat meziroční změny. První skript je výběr sloupců.
-- V dalším kroku vybírám relevantní sloupce, průměruji hodnoty za období let 2006-2018 a vkládám do vnořeného selectu.

-- Odpověď: 
-- V několika letech byl zaznamenán meziroční průměrný nárůst cen potravin vyšší, než meziroční průměrný nárůst mezd - dva nejvyšší byly v letech 2012 a 2011.
-- Nicméně meziroční nárůst cen potravin výrazně vyšší než růst mezd (vyšší než 10 %) zaznamenaný nebyl.


SELECT
    A.wage_year AS wage_current_year,
    A.food_category, 
    A.food_price, 
    B.wage_year AS wage_next_year, 
    B.food_price AS food_price_next_year,
    round(((B.food_price-A.food_price)/A.food_price*100),2) AS difference_food_price_pct,
    A.industry_category, 
    A.industry_wage,
    B.industry_wage AS industry_wage_next_year,
    (B.industry_wage-A.industry_wage)/A.industry_wage*100 AS difference_industry_wage_pct
FROM t_zdenka_sailerova_primarni A
JOIN t_zdenka_sailerova_primarni B
    ON A.wage_year = B.wage_year-1
    AND A.industry_category = B.industry_category 
    AND A.food_category = B.food_category 
GROUP BY wage_current_year, wage_next_year, food_category;

  
SELECT wage_current_year, 
    round(avg(DATA.difference_food_price_pct),2) AS difference_food_price_pct,
    round(avg(DATA.difference_industry_wage_pct),2) AS difference_industry_wage_pct
FROM (
    SELECT
        A.wage_year AS wage_current_year, 
        A.food_category, 
        A.food_price, 
        B.wage_year AS wage_year_next_year, 
        B.food_price AS food_price_next_year,
        round(((B.food_price-A.food_price)/A.food_price*100),2) AS difference_food_price_pct,
        A.industry_category, 
        A.industry_wage, 
        B.industry_wage AS industry_wage_next_year,
        (B.industry_wage-A.industry_wage)/A.industry_wage*100 AS difference_industry_wage_pct
    FROM t_zdenka_sailerova_primarni A
JOIN t_zdenka_sailerova_primarni B
    ON A.wage_year = B.wage_year-1
    AND A.industry_category = B.industry_category
    AND A.food_category = B.food_category
) AS DATA
GROUP BY wage_current_year;