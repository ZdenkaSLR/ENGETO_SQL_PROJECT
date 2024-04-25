# SQL PROJEKT KE KURZU DATOVÁ AKADEMIE (6. 12. 2023)


## ZADÁNÍ
Cílem je odpovìdìt na níže uvedené výzkumné otázky zamìøené na dostupnost základních potravin široké veøejnosti. 
Výstupy zpracované analytickým oddìlením naší nezávislé spoleènosti budou poskytnuty tiskovému oddìlení, které je nálednì bude prezentovat na konferenci zamìøené na tuto oblast.


## ANALÝZA
Pro zodpovìzení výzkumých otázek je potøeba pøipravit robustní datové podklady, ve kterých bude možné vidìt porovnání dostupnosti potravin na základì prùmìrných pøíjmù za urèité èasové období.

Jako dodateèný materiál pøipravuji i tabulku s HDP, GINI koeficientem a populací dalších evropských státù ve stejném období, jako primární pøehled pro ÈR.


### Datové sady, které jsem použila pro získání vhodného datového podkladu

**Primární tabulky:**
+ czechia_payroll – Informace o mzdách v rùzných odvìtvích za nìkolikaleté období. Datová sada pochází z Portálu otevøených dat ÈR.
+ czechia_payroll_calculation – Èíselník kalkulací v tabulce mezd.
+ czechia_payroll_industry_branch – Èíselník odvìtví v tabulce mezd.
+ czechia_payroll_unit – Èíselník jednotek hodnot v tabulce mezd.
+ czechia_payroll_value_type – Èíselník typù hodnot v tabulce mezd.
+ czechia_price – Informace o cenách vybraných potravin za nìkolikaleté období. Datová sada pochází z Portálu otevøených dat ÈR.
+ czechia_price_category – Èíselník kategorií potravin, které se vyskytují v našem pøehledu.

**Èíselníky sdílených informací o ÈR:**
+ czechia_region – Èíselník krajù Èeské republiky dle normy CZ-NUTS 2.
+ czechia_district – Èíselník okresù Èeské republiky dle normy LAU.

**Dodateèné tabulky:**
+ countries - Informace o zemích na svìtì, napøíklad hlavní mìsto, mìna, národní jídlo nebo prùmìrná výška populace.
+ economies - HDP, GINI, daòová zátìž, atd. pro daný stát a rok.


### Výzkumné otázky
1. Rostou v prùbìhu let mzdy ve všech odvìtvích, nebo v nìkterých klesají?
2. Kolik je možné si koupit litrù mléka a kilogramù chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroèní nárùst)?
4. Existuje rok, ve kterém byl meziroèní nárùst cen potravin výraznì vyšší než rùst mezd (vìtší než 10 %)?
5. Má výška HDP vliv na zmìny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výraznìji v jednom roce, projeví se to na cenách potravin èi mzdách ve stejném nebo násdujícím roce výraznìjším rùstem?


## POSTUP

### Komentáø k vytvoøení primární tabulky

Tvorbu primární tabulky jsem rozdìlila na 2 kroky:
- Nejdøíve jsem si vytvoøila 2 tabulky t_zdenka_sailerova_primarni_food, která obsahuje informace o cenách potravin z tabulky czechia_price a t_zdenka_sailerova_primarni_wage, která obsahuje informace o prùmìrných mzdách z tabulky czechia_payroll. 
- Tyto jednotlivé tabulky _primarni_food a _primarni_wage obsahují i data z dalších k nim náležejících tabulek - èíselníkù. 
- Ceny (food_price) uvedené v tabulce _primarni_food jsou zprùmìrované ceny dané potraviny za rok napøíè kraji ÈR.
- Platy (industry_wage) uvedené v tabulce _primarni_wage jsou zprùmìrované platy pro daný rok v daném odvìtví. V této tabulce omezuji data pouze na ty, která jsou oznaèená kódem 5958, tj. prùmìrná hrubá mzda na zamìstnance
- Následnì tyto dvì spojuji do tabulky t_zdenka_sailerova_primarni. Tabulky propojuji pomocí INNER JOIN viz script pøes spoleèné sloupce. Tabulky omezuji rozsahem let 2006–2018, který je spoleèný pro obì tabulky. 


### Komentáø k vytvoøení sekundární tabulky

- Sekundární tabulka je vytvoøená spojením tabulky economies a countries pomocí JOIN pøes spoleènou hodnotu country. 
- Následnì vybírám podle požadavkù zadání sloupce HDP, GINI koeficient, populace státu a omezuji je pouze na Evropu.
- Období omezuji na roky 2006-2018, tak, aby se shodovalo s obdobím v primární tabulce. 


## VÝSLEDKY


### Otázka 1: Rostou v prùbìhu let mzdy ve všech odvìtvích, nebo v nìkterých klesají?

**Postup:**
- Tabulky spojuji pomocí JOIN primární tabulky na primární tabulku posunutou o jeden rok, aby bylo možné porovnávat meziroèní zmìny.
- Flag v posledním sloupci oznaèuje pøípady, kdy došlo k meziroènímu poklesu mezd. 

**Odpovìï:**
- Ve sledovaném období let 2006–2018 došlo ve 23 pøípadech k meziroènímu poklesu mzdy v daném odvìtví. 
- Nejvíce tomu bylo roku 2012 (u 11 odvìtví), naopak nárùst byl zaznamenán ve srovnání s následujícím rokem v letech 2006, 2007, 2011, 2016, 2017. 
- V odvìtví Tìžba a dobývání došlo ve sledovaném období k meziroènímu poklesu mzdy dokonce 4x.



### Otázka 2: Kolik je možné si koupit litrù mléka a kilogramù chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

**Postup:**
- Prùmìrnou cenu potravin v letech 2006 a 2018 porovnávám s mìsíèní mzdou, která je zprùmìrovaná napøíè odvìtvími ve sledovaném roce. 
- Prùmìrná mzda napøíè odvìtvími v roce 2006 byla 20 754 Kè/mìs. V roce 2018 prùmìrná mzda byla 32 536 Kè/mìs. 
- Cena v roce 2006 za Chléb konzumní kmínový byla 16,12 Kè/kg. V roce 2018 stál chléb 24,24 Kè/kg.
- Cena v roce 2006 za Mléko polotuèné pasterované byla 14,44 Kè/l. V roce 2018 stálo mléko 19,82 Kè/l. 

**Odpovìï:**
- V roce 2006 bylo možné z prùmìrné mìsíèní mzdy koupit 1 287 kg chleba konzumního kmínového nebo 1 437 l mléka polotuèného pasterovaného.
- V roce 2018 bylo možné z prùmìrné mìsíèní mzdy koupit 1 342 kg chleba konzumního kmínového nebo 1 641 l mléka polotuèného pasterovaného.



### Otázka 3: Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroèní nárùst)?

**Postup:**
- Porovnávám zmìny prùmìrných cen potravin v daném a následujícím roce, obdobnì jako v otázce 1. 
- Tabulky spojuji pomocí JOIN primární tabulky na primární tabulku posunutou o jeden rok, aby bylo možné porovnávat meziroèní zmìny.

**Odpovìï:**
- V porovnání se objevily 2 kategorie, které v rozmezí let 2006–2018 nezdražují, ale dokonce zlevòují. 
- Jedná se o Cukr krystalový, který v prùmìru zlevnil o 1,92 %. 
- Druhou surovinou, která zlevnila v prùmìru o 0,74 % jsou Rajská jablka èervená kulatá. 
- Naproti tomu nejvyšší nárùst byl zaznamenán u Papriky, kdy prùmìrný procentuální nárùst za rok v uvedeném období byl 7,29%



### Otázka 4: Existuje rok, ve kterém byl meziroèní nárùst cen potravin výraznì vyšší než rùst mezd (vìtší než 10 %)?

**Postup:**
- Porovnávám zmìny prùmìrných cen potravin v daném a následujícím roce, obdobnì jako v otázce 1 a 3. 
- Tabulky spojuji pomocí JOIN primární tabulky na primární tabulku posunutou o jeden rok, aby bylo možné porovnávat meziroèní zmìny. První skript je výbìr sloupcù.
- V dalším kroku vybírám relevantní sloupce, prùmìruji hodnoty za období let 2006-2018 a vkládám do vnoøeného selectu.

**Odpovìï:** 
- V nìkolika letech byl zaznamenán meziroèní prùmìrný nárùst cen potravin vyšší, než meziroèní prùmìrný nárùst mezd - dva nejvyšší byly v letech 2012 a 2011.
- Nicménì meziroèní nárùst cen potravin výraznì vyšší než rùst mezd (vyšší než 10 %) ve sledovaném období let 2006-2018 zaznamenaný nebyl.



### Otázka 5: Má výška HDP vliv na zmìny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výraznìji v jednom roce, projeví se to na cenách potravin èi mzdách ve stejném nebo následujícím roce výraznìjším rùstem?

**Postup:**
- V prvním kroku spojuji primární a sekundární tabulku pøes spoleènou hodnotu - rok. Ceny potravin a platy jsou zprùmìrované za daný rok. K tìmto informacím je ještì pøidaná hodnota HDP (GDP) ze sekundární tabulky. 
- V dalším kroku napojuji na sebe stejné tabulky posunuté o rok, èímž získávám i meziroèní rozdíly v procentech u HDP, prùmìrné ceny potravin a prùmìrného platu. Celkem se tedy spojují 4 tabulky. 
- V posledním kroku filtruji požadované hodnoty. 

**Odpovìï:**
- V zadání není specifikováno, co je chápano jako výraznìjší nárùst HDP. Pro tento pøípad si hranici stanovím na nárùst 5 % nebo vyšší. Sleduji tedy pøípady, kdy se meziroènì zvýšilo HDP min o 5 % a ceny potravin nebo platy se také meziroènì zvýšily minimálnì o 5 %. 
- Výsledek je rok 2006 v porovnání s rokem 2007 a 2016 v porovnání s rokem 2017, kdy rostly všechny tøi hodnoty spoleènì - tedy HDP, ceny potravin i mzdy zároveò o více než 5%. 
- Meziroèní nárùst HDP o více nìž 5 % nastal také mezi roky 2014 a 2015, ale tento nebyl doprovázen obdobným nárùstem cen potravin a mezd, naopak v tomto pøípadì ceny potravin dokonce klesly. 
- Nejde tedy jednoznaènì øíct, že je zde souvislost mezi nárùstem HDP a cenami potravin a mezd.

