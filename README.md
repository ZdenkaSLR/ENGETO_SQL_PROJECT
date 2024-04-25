# SQL PROJEKT KE KURZU DATOV� AKADEMIE (6. 12. 2023)


## ZAD�N�
C�lem je odpov�d�t na n�e uveden� v�zkumn� ot�zky zam��en� na dostupnost z�kladn�ch potravin �irok� ve�ejnosti. 
V�stupy zpracovan� analytick�m odd�len�m na�� nez�visl� spole�nosti budou poskytnuty tiskov�mu odd�len�, kter� je n�ledn� bude prezentovat na konferenci zam��en� na tuto oblast.


## ANAL�ZA
Pro zodpov�zen� v�zkum�ch ot�zek je pot�eba p�ipravit robustn� datov� podklady, ve kter�ch bude mo�n� vid�t porovn�n� dostupnosti potravin na z�klad� pr�m�rn�ch p��jm� za ur�it� �asov� obdob�.

Jako dodate�n� materi�l p�ipravuji i tabulku s HDP, GINI koeficientem a populac� dal��ch evropsk�ch st�t� ve stejn�m obdob�, jako prim�rn� p�ehled pro �R.


### Datov� sady, kter� jsem pou�ila pro z�sk�n� vhodn�ho datov�ho podkladu

**Prim�rn� tabulky:**
+ czechia_payroll � Informace o mzd�ch v r�zn�ch odv�tv�ch za n�kolikalet� obdob�. Datov� sada poch�z� z Port�lu otev�en�ch dat �R.
+ czechia_payroll_calculation � ��seln�k kalkulac� v tabulce mezd.
+ czechia_payroll_industry_branch � ��seln�k odv�tv� v tabulce mezd.
+ czechia_payroll_unit � ��seln�k jednotek hodnot v tabulce mezd.
+ czechia_payroll_value_type � ��seln�k typ� hodnot v tabulce mezd.
+ czechia_price � Informace o cen�ch vybran�ch potravin za n�kolikalet� obdob�. Datov� sada poch�z� z Port�lu otev�en�ch dat �R.
+ czechia_price_category � ��seln�k kategori� potravin, kter� se vyskytuj� v na�em p�ehledu.

**��seln�ky sd�len�ch informac� o �R:**
+ czechia_region � ��seln�k kraj� �esk� republiky dle normy CZ-NUTS 2.
+ czechia_district � ��seln�k okres� �esk� republiky dle normy LAU.

**Dodate�n� tabulky:**
+ countries - Informace o zem�ch na sv�t�, nap��klad hlavn� m�sto, m�na, n�rodn� j�dlo nebo pr�m�rn� v��ka populace.
+ economies - HDP, GINI, da�ov� z�t�, atd. pro dan� st�t a rok.


### V�zkumn� ot�zky
1. Rostou v pr�b�hu let mzdy ve v�ech odv�tv�ch, nebo v n�kter�ch klesaj�?
2. Kolik je mo�n� si koupit litr� ml�ka a kilogram� chleba za prvn� a posledn� srovnateln� obdob� v dostupn�ch datech cen a mezd?
3. Kter� kategorie potravin zdra�uje nejpomaleji (je u n� nejni��� percentu�ln� meziro�n� n�r�st)?
4. Existuje rok, ve kter�m byl meziro�n� n�r�st cen potravin v�razn� vy��� ne� r�st mezd (v�t�� ne� 10 %)?
5. M� v��ka HDP vliv na zm�ny ve mzd�ch a cen�ch potravin? Neboli, pokud HDP vzroste v�razn�ji v jednom roce, projev� se to na cen�ch potravin �i mzd�ch ve stejn�m nebo n�sduj�c�m roce v�razn�j��m r�stem?


## POSTUP

### Koment�� k vytvo�en� prim�rn� tabulky

Tvorbu prim�rn� tabulky jsem rozd�lila na 2 kroky:
- Nejd��ve jsem si vytvo�ila 2 tabulky t_zdenka_sailerova_primarni_food, kter� obsahuje informace o cen�ch potravin z tabulky czechia_price a t_zdenka_sailerova_primarni_wage, kter� obsahuje informace o pr�m�rn�ch mzd�ch z tabulky czechia_payroll. 
- Tyto jednotliv� tabulky _primarni_food a _primarni_wage obsahuj� i data z dal��ch k nim n�le�ej�c�ch tabulek - ��seln�k�. 
- Ceny (food_price) uveden� v tabulce _primarni_food jsou zpr�m�rovan� ceny dan� potraviny za rok nap��� kraji �R.
- Platy (industry_wage) uveden� v tabulce _primarni_wage jsou zpr�m�rovan� platy pro dan� rok v dan�m odv�tv�. V t�to tabulce omezuji data pouze na ty, kter� jsou ozna�en� k�dem 5958, tj. pr�m�rn� hrub� mzda na zam�stnance
- N�sledn� tyto dv� spojuji do tabulky t_zdenka_sailerova_primarni. Tabulky propojuji pomoc� INNER JOIN viz script p�es spole�n� sloupce. Tabulky omezuji rozsahem let 2006�2018, kter� je spole�n� pro ob� tabulky. 


### Koment�� k vytvo�en� sekund�rn� tabulky

- Sekund�rn� tabulka je vytvo�en� spojen�m tabulky economies a countries pomoc� JOIN p�es spole�nou hodnotu country. 
- N�sledn� vyb�r�m podle po�adavk� zad�n� sloupce HDP, GINI koeficient, populace st�tu a omezuji je pouze na Evropu.
- Obdob� omezuji na roky 2006-2018, tak, aby se shodovalo s obdob�m v prim�rn� tabulce. 


## V�SLEDKY


### Ot�zka 1: Rostou v pr�b�hu let mzdy ve v�ech odv�tv�ch, nebo v n�kter�ch klesaj�?

**Postup:**
- Tabulky spojuji pomoc� JOIN prim�rn� tabulky na prim�rn� tabulku posunutou o jeden rok, aby bylo mo�n� porovn�vat meziro�n� zm�ny.
- Flag v posledn�m sloupci ozna�uje p��pady, kdy do�lo k meziro�n�mu poklesu mezd. 

**Odpov��:**
- Ve sledovan�m obdob� let 2006�2018 do�lo ve 23 p��padech k meziro�n�mu poklesu mzdy v dan�m odv�tv�. 
- Nejv�ce tomu bylo roku 2012 (u 11 odv�tv�), naopak n�r�st byl zaznamen�n ve srovn�n� s n�sleduj�c�m rokem v letech 2006, 2007, 2011, 2016, 2017. 
- V odv�tv� T�ba a dob�v�n� do�lo ve sledovan�m obdob� k meziro�n�mu poklesu mzdy dokonce 4x.



### Ot�zka 2: Kolik je mo�n� si koupit litr� ml�ka a kilogram� chleba za prvn� a posledn� srovnateln� obdob� v dostupn�ch datech cen a mezd?

**Postup:**
- Pr�m�rnou cenu potravin v letech 2006 a 2018 porovn�v�m s m�s��n� mzdou, kter� je zpr�m�rovan� nap��� odv�tv�mi ve sledovan�m roce. 
- Pr�m�rn� mzda nap��� odv�tv�mi v roce 2006 byla 20 754 K�/m�s. V roce 2018 pr�m�rn� mzda byla 32 536 K�/m�s. 
- Cena v roce 2006 za Chl�b konzumn� km�nov� byla 16,12 K�/kg. V roce 2018 st�l chl�b 24,24 K�/kg.
- Cena v roce 2006 za Ml�ko polotu�n� pasterovan� byla 14,44 K�/l. V roce 2018 st�lo ml�ko 19,82 K�/l. 

**Odpov��:**
- V roce 2006 bylo mo�n� z pr�m�rn� m�s��n� mzdy koupit 1 287 kg chleba konzumn�ho km�nov�ho nebo 1 437 l ml�ka polotu�n�ho pasterovan�ho.
- V roce 2018 bylo mo�n� z pr�m�rn� m�s��n� mzdy koupit 1 342 kg chleba konzumn�ho km�nov�ho nebo 1 641 l ml�ka polotu�n�ho pasterovan�ho.



### Ot�zka 3: Kter� kategorie potravin zdra�uje nejpomaleji (je u n� nejni��� percentu�ln� meziro�n� n�r�st)?

**Postup:**
- Porovn�v�m zm�ny pr�m�rn�ch cen potravin v dan�m a n�sleduj�c�m roce, obdobn� jako v ot�zce 1. 
- Tabulky spojuji pomoc� JOIN prim�rn� tabulky na prim�rn� tabulku posunutou o jeden rok, aby bylo mo�n� porovn�vat meziro�n� zm�ny.

**Odpov��:**
- V porovn�n� se objevily 2 kategorie, kter� v rozmez� let 2006�2018 nezdra�uj�, ale dokonce zlev�uj�. 
- Jedn� se o Cukr krystalov�, kter� v pr�m�ru zlevnil o 1,92 %. 
- Druhou surovinou, kter� zlevnila v pr�m�ru o 0,74 % jsou Rajsk� jablka �erven� kulat�. 
- Naproti tomu nejvy��� n�r�st byl zaznamen�n u Papriky, kdy pr�m�rn� procentu�ln� n�r�st za rok v uveden�m obdob� byl 7,29%



### Ot�zka 4: Existuje rok, ve kter�m byl meziro�n� n�r�st cen potravin v�razn� vy��� ne� r�st mezd (v�t�� ne� 10 %)?

**Postup:**
- Porovn�v�m zm�ny pr�m�rn�ch cen potravin v dan�m a n�sleduj�c�m roce, obdobn� jako v ot�zce 1 a 3. 
- Tabulky spojuji pomoc� JOIN prim�rn� tabulky na prim�rn� tabulku posunutou o jeden rok, aby bylo mo�n� porovn�vat meziro�n� zm�ny. Prvn� skript je v�b�r sloupc�.
- V dal��m kroku vyb�r�m relevantn� sloupce, pr�m�ruji hodnoty za obdob� let 2006-2018 a vkl�d�m do vno�en�ho selectu.

**Odpov��:** 
- V n�kolika letech byl zaznamen�n meziro�n� pr�m�rn� n�r�st cen potravin vy���, ne� meziro�n� pr�m�rn� n�r�st mezd - dva nejvy��� byly v letech 2012 a 2011.
- Nicm�n� meziro�n� n�r�st cen potravin v�razn� vy��� ne� r�st mezd (vy��� ne� 10 %) ve sledovan�m obdob� let 2006-2018 zaznamenan� nebyl.



### Ot�zka 5: M� v��ka HDP vliv na zm�ny ve mzd�ch a cen�ch potravin? Neboli, pokud HDP vzroste v�razn�ji v jednom roce, projev� se to na cen�ch potravin �i mzd�ch ve stejn�m nebo n�sleduj�c�m roce v�razn�j��m r�stem?

**Postup:**
- V prvn�m kroku spojuji prim�rn� a sekund�rn� tabulku p�es spole�nou hodnotu - rok. Ceny potravin a platy jsou zpr�m�rovan� za dan� rok. K t�mto informac�m je je�t� p�idan� hodnota HDP (GDP) ze sekund�rn� tabulky. 
- V dal��m kroku napojuji na sebe stejn� tabulky posunut� o rok, ��m� z�sk�v�m i meziro�n� rozd�ly v procentech u HDP, pr�m�rn� ceny potravin a pr�m�rn�ho platu. Celkem se tedy spojuj� 4 tabulky. 
- V posledn�m kroku filtruji po�adovan� hodnoty. 

**Odpov��:**
- V zad�n� nen� specifikov�no, co je ch�pano jako v�razn�j�� n�r�st HDP. Pro tento p��pad si hranici stanov�m na n�r�st 5 % nebo vy���. Sleduji tedy p��pady, kdy se meziro�n� zv��ilo HDP min o 5 % a ceny potravin nebo platy se tak� meziro�n� zv��ily minim�ln� o 5 %. 
- V�sledek je rok 2006 v porovn�n� s rokem 2007 a 2016 v porovn�n� s rokem 2017, kdy rostly v�echny t�i hodnoty spole�n� - tedy HDP, ceny potravin i mzdy z�rove� o v�ce ne� 5%. 
- Meziro�n� n�r�st HDP o v�ce n� 5 % nastal tak� mezi roky 2014 a 2015, ale tento nebyl doprov�zen obdobn�m n�r�stem cen potravin a mezd, naopak v tomto p��pad� ceny potravin dokonce klesly. 
- Nejde tedy jednozna�n� ��ct, �e je zde souvislost mezi n�r�stem HDP a cenami potravin a mezd.

