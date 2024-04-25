-- Skripty k SQL projektu 3/7, Datová akademie 6. 12. 2023 

-- Výzkumná otázka 1: Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

-- Postup:
-- Tabulky spojuji pomocí JOIN primární tabulky na primární tabulku posunutou o jeden rok, aby bylo možné porovnávat meziroční změny
-- Flag v posledním sloupci označuje případy, kdy došlo k meziročnímu poklesu mezd. 

-- Odpověď: 
-- Ve sledovaném období let 2006–2018 došlo ve 23 případech k meziročnímu poklesu mzdy v daném odvětví. 
-- Nejvíce tomu bylo roku 2012 (u 11 odvětví), naopak nárůst byl zaznamenán ve srovnání s následujícím rokem v letech 2006, 2007, 2011, 2016, 2017. 
-- V odvětví Těžba a dobývání došlo ve sledovaném období k meziročnímu poklesu mzdy dokonce 4x.


SELECT
    A.wage_year AS wage_current_year,
    A.industry_category AS industry_category,
    A.industry_wage AS industry_wage_current_year,
    B.wage_year AS wage_next_year,
    B.industry_wage AS industry_wage_next_year,
    (B.industry_wage-A.industry_wage) AS wage_difference,
    CASE WHEN (B.industry_wage-A.industry_wage) > 0 THEN 0 
       ELSE 1
    END as flag_wage_decrease   
    FROM t_zdenka_sailerova_primarni A
JOIN t_zdenka_sailerova_primarni B
    ON A.wage_year = B.wage_year-1
    AND A.industry_category = B.industry_category 
    AND (B.industry_wage-A.industry_wage) < 0 
GROUP BY wage_current_year, wage_next_year, industry_category
-- ORDER BY industry_category
;
