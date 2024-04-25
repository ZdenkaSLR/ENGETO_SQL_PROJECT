-- Skripty k SQL projektu 7/7, Datová akademie 6. 12. 2023 

-- Výzkumná otázka 5: Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

-- Postup:
-- V prvním kroku spojuji primární a sekundární tabulku přes společnou hodnotu - rok. Ceny potravin a platy jsou zprůměrované za daný rok. K těmto informacím je ještě přidaná hodnota HDP (GDP) ze sekundární tabulky. 
-- V dalším kroku napojuji na sebe stejné tabulky posunuté o rok, čímž získávám i meziroční rozdíly v procentech u HDP (jednotka v Kč), průměrné ceny potravin a průměrného platu. Celkem se tedy spojují 4 tabulky.
-- V posledním kroku filtruji požadované hodnoty. 

-- Odpověď:
-- V zadání není specifikováno, co je chápano jako výraznější nárůst HDP. Pro tento případ si hranici stanovím na nárůst 5 % nebo vyšší. 
-- Sleduji tedy případy, kdy se meziročně zvýšilo HDP min o 5 % a ceny potravin nebo platy se také meziročně zvýšily minimálně o 5 %. 
-- Výsledek je rok 2006 v porovnání s rokem 2007 a 2016 v porovnání s rokem 2017, kdy rostly všechny tři hodnoty společně - tedy HDP, ceny potravin i mzdy zároveň o více než 5%. 
-- Meziroční nárůst HDP o více něž 5 % nastal také mezi roky 2014 a 2015, ale tento nebyl doprovázen obdobným nárůstem cen potravin a mezd, naopak v tomto případě ceny potravin dokonce klesly. 
-- Nejde tedy jednoznačně říct, že je zde souvislost mezi nárůstem HDP a cenami potravin a mezd.


-- Výsledkem tohoto dotazu je přehled rok / HDP / avg.food_price / avg.wage_value
SELECT 
    food_year, 
    round(GDP, 0) AS GDP,
    round(avg(food_price), 2) AS avg_food_price, 
    round(avg(industry_wage), 0) AS avg_wage_value 
FROM t_zdenka_sailerova_primarni tzsp 
JOIN t_zdenka_sailerova_sekundarni tzss 
    ON tzsp.food_year = tzss.`year` 
WHERE tzss.country = 'Czech Republic'
GROUP BY tzss.YEAR;


-- Meziroční srovnání a dopočet rozdílů
SELECT 
    tzss.`year` AS `year`, 
    round(tzss.GDP,0) AS GDP,
    round(avg(tzsp.food_price), 2) AS avg_food_price, 
    tzsp.food_unit,
    round(avg(tzsp.industry_wage), 0) AS avg_wage_value, 
    tzsp.wage_unit,
    tzsp2.food_year AS next_year,
    round(tzss2.GDP,0) AS GDP_next_year, 
    round(avg(tzsp2.food_price), 2) AS avg_food_price_next_year, 
    round(avg(tzsp2.industry_wage), 0) AS avg_wage_value_next_year, 
    round((tzss2.GDP-tzss.GDP)/tzss.GDP*100, 2) AS difference_GDP_pct,
    round((avg(tzsp2.food_price)-avg(tzsp.food_price))/avg(tzsp.food_price)*100, 2) AS difference_food_price_pct, 
    round((avg(tzsp2.industry_wage)-avg(tzsp.industry_wage))/avg(tzsp.industry_wage)*100, 2) AS difference_monthly_wage_pct
FROM t_zdenka_sailerova_primarni tzsp 
JOIN t_zdenka_sailerova_sekundarni tzss 
    ON tzsp.food_year = tzss.`year` 
JOIN t_zdenka_sailerova_primarni tzsp2 
    ON tzsp.food_year = tzsp2.food_year-1
JOIN t_zdenka_sailerova_sekundarni tzss2 
    ON tzsp.food_year = tzss2.`year`-1
WHERE tzss.country = 'Czech Republic'
AND tzss2.country = 'Czech Republic'
GROUP BY tzss.YEAR;


-- Výběr hodnot, kde je rozdil HDP vetsi nez 5 procent
SELECT 
    sub.year, 
    sub.difference_GDP_pct,
    sub.difference_food_price_pct,
    sub.difference_monthly_wage_pct,
    selection
FROM (
    SELECT 
        tzss.`year` AS `year`, 
        round(tzss.GDP,0) AS GDP,
        round(avg(tzsp.food_price), 2) AS avg_food_price,
        round(avg(tzsp.industry_wage), 0) AS avg_wage_value, 
        tzsp2.food_year AS next_year,
        round(tzss2.GDP,0) AS GDP_next_year,
        round(avg(tzsp2.food_price), 2) AS avg_food_price_next_year, 
        round(avg(tzsp2.industry_wage), 0) AS avg_wage_value_next_year, 
        round((tzss2.GDP-tzss.GDP)/tzss.GDP*100, 2) AS difference_GDP_pct,
        round((avg(tzsp2.food_price)-avg(tzsp.food_price))/avg(tzsp.food_price)*100, 2) AS difference_food_price_pct, 
        round((avg(tzsp2.industry_wage)-avg(tzsp.industry_wage))/avg(tzsp.industry_wage)*100, 2) AS difference_monthly_wage_pct,
        CASE 
            WHEN round((tzss2.GDP-tzss.GDP)/tzss.GDP*100, 2) > 5 AND round((avg(tzsp2.food_price)-avg(tzsp.food_price))/avg(tzsp.food_price)*100, 2) > 5 AND round((avg(tzsp2.industry_wage)-avg(tzsp.industry_wage))/avg(tzsp.industry_wage)*100, 2) > 5 THEN 'výrazný nárůst HDP oproti minulému roku a současne výrazný nárůst cen potravin i mezd'
            WHEN round((tzss2.GDP-tzss.GDP)/tzss.GDP*100, 2) > 5 OR round((avg(tzsp2.food_price)-avg(tzsp.food_price))/avg(tzsp.food_price)*100, 2) > 5 OR round((avg(tzsp2.industry_wage)-avg(tzsp.industry_wage))/avg(tzsp.industry_wage)*100, 2)> 5 THEN 'výrazný nárůst HDP oproti minulému roku a současný výrazný nárůst cen potravin nebo mezd'
            ELSE 'nevýrazný nárůst HDP oproti minulému roku nebo pokles'
        END AS selection
    FROM t_zdenka_sailerova_primarni tzsp 
    JOIN t_zdenka_sailerova_sekundarni tzss 
        ON tzsp.food_year = tzss.`year` 
    JOIN t_zdenka_sailerova_primarni tzsp2 
        ON tzsp.food_year = tzsp2.food_year-1
    JOIN t_zdenka_sailerova_sekundarni tzss2 
        ON tzsp.food_year = tzss2.`year`-1
    WHERE tzss.country = 'Czech Republic'
    AND tzss2.country = 'Czech Republic'
    GROUP BY tzss.YEAR) AS sub
WHERE sub.difference_GDP_pct > '5';