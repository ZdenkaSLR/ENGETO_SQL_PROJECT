-- Skripty k SQL projektu 1/7, Datová akademie 6. 12. 2023 
-- Zdeňka Sailerová | Discord zdenka_26904

-- Postup pro vytvoření primární tabulky:
--  Tvorbu primární tabulky jsem rozdělila na 2 kroky, _primarni_food, která obsahuje informace o cenách potravin a _primarni_wage, která obsahuje informace o průměrných mzdách. Následně tyto dvě spojuji do tabulky _primarni.
--  Tabulky propojuji pomocí INNER JOIN viz script přes společné sloupce. Tabulky omezuji rozsahem let 2006–2018, který je společný pro obě tabulky.  

-- Ceny (food_price) uvedené v tabulce _primarni_food jsou zprůměrované ceny dané potraviny za rok napříč kraji ČR.
-- Platy (industry_wage) uvedené v tabulce _primarni_wage jsou zprůměrované platy pro daný rok v daném odvětví.


-- Tabulka obsahující jednotkové ceny potravin v letech 2006-2018
CREATE OR REPLACE TABLE t_zdenka_sailerova_primarni_food AS 
SELECT 
    cpc.name AS food_category,
    round(avg(cp.value),2) AS food_price, 
    concat('Kč/', cpc.price_value, ' ', cpc.price_unit) AS food_unit,
    YEAR(cp.date_from) AS food_year 
FROM czechia_price cp 
INNER JOIN czechia_price_category cpc
    ON cp.category_code = cpc.code 
INNER JOIN czechia_region cr    
    ON cp.region_code = cr.code
GROUP BY food_category, food_year 
ORDER BY food_category, food_year;


-- Tabulka obsahující průměrné hrubé mzdy v odvětvích v letech 2006-2018
CREATE OR REPLACE TABLE t_zdenka_sailerova_primarni_wage AS 
SELECT
    cpib.name AS industry_category,
    round(avg(cp2.value)) AS industry_wage,
    concat(cpu.name, '/měs') AS wage_unit,  
    cp2.payroll_year AS wage_year
FROM czechia_payroll cp2 
INNER JOIN czechia_payroll_calculation cpc2
    ON cp2.calculation_code = cpc2.code
INNER JOIN czechia_payroll_industry_branch cpib 
    ON cp2.industry_branch_code = cpib.code 
INNER JOIN czechia_payroll_unit cpu 
    ON cp2.unit_code = cpu.code 
INNER JOIN czechia_payroll_value_type cpvt 
    ON cp2.value_type_code = cpvt.code
WHERE value_type_code = '5958' -- výběr hodnot týkajících se průměrné hrubé mzdy na zaměstnance
AND cp2.payroll_year BETWEEN 2006 AND 2018 
GROUP BY wage_year, industry_category 
ORDER BY industry_category, wage_year;


-- Primární tabulka propojuje ceny potravin a průměrné mzdy v období 2006-2018
CREATE OR REPLACE TABLE t_zdenka_sailerova_primarni
SELECT *
FROM t_zdenka_sailerova_primarni_food tzspf 
INNER JOIN t_zdenka_sailerova_primarni_wage tzspw
    ON tzspf.food_year = tzspw.wage_year
ORDER BY industry_category, wage_year, food_category, food_year; 

