/*
 * ZEMRELI_2006_2022
 */


SELECT *
FROM zemreli

CREATE OR REPLACE TABLE zemreli_Praha
SELECT
	rok,
	hodnota AS pocet_umrti,
	pohlavi_kod,
	pohlavi_txt AS pohlavi,
	ps0_kod AS kategorie_nemoci_kod,
	ps_kod AS pricina_smrti_kod,
	ps0_txt AS kategorie_nemoci, 
	ps_txt AS nazev_nemoci,
	vuzemi_cis AS kod_ciselniku,
	vuzemi_kod AS kraj_kod,
	vuzemi_txt 
FROM zemreli
WHERE	1=1
		AND vuzemi_kod = 3018 -- Hlavní město Praha
		AND pohlavi_kod IS NOT NULL 
		AND hodnota != 0
		
		
SELECT *
FROM zemreli_praha zp

WHERE kategorie_nemoci_kod = ''
ORDER BY rok 

SELECT
	sum(pocet_umrti)
FROM zemreli_praha zp
WHERE kategorie_nemoci_kod = ''

-- UPDATE zemreli_praha  
-- SET kategorie_nemoci_kod = 'XIX', kategorie_nemoci = 'Poranění, otravy a některé jiné následky vnějších příčin', nazev_nemoci = 'Poranění, otravy a některé jiné následky vnějších příčin'
-- WHERE kategorie_nemoci_kod = '' AND pricina_smrti_kod = '';


-- zmena z kodu kraje na kod okresu
CREATE OR REPLACE TABLE zemreli_praha_
SELECT 
	rok,
	pocet_umrti,
	pohlavi,
	kategorie_nemoci,
	nazev_nemoci,
	CASE 
		WHEN kraj_kod = 3018 THEN 40924
	END AS okres_kod
FROM zemreli_praha

SELECT *
FROM zemreli_praha_ zp


-- zemreli v okres mimo Prahu
CREATE OR REPLACE TABLE zemreli_okresy
SELECT
	rok,
	hodnota AS pocet_umrti,
	pohlavi_txt AS pohlavi,
	ps0_txt AS kategorie_nemoci, 
	ps_txt AS nazev_nemoci,
	vuzemi_kod AS okres_kod
FROM zemreli
WHERE	1=1
		AND vuzemi_kod != '19' 
		AND vuzemi_kod != '3018'
		AND vuzemi_kod != '3026'
		AND vuzemi_kod != '3115'
		AND vuzemi_kod != '3140'
		AND vuzemi_kod != '3085'
		AND vuzemi_kod != '3069'
		AND vuzemi_kod != '3093'
		AND vuzemi_kod != '3107'
		AND vuzemi_kod != '3123'
		AND vuzemi_kod != '3051'
		AND vuzemi_kod != '3034'
		AND vuzemi_kod != '3042'
		AND vuzemi_kod != '3131'
		AND vuzemi_kod != '3077'
		AND pohlavi_kod IS NOT NULL 
		AND hodnota != 0

SELECT  *
FROM zemreli_okresy zo

SELECT
	sum(pocet_umrti)
FROM zemreli_okresy zo 
WHERE kategorie_nemoci_kod = ''

-- UPDATE zemreli_okresy 
-- SET kategorie_nemoci_kod = 'XIX', kategorie_nemoci = 'Poranění, otravy a některé jiné následky vnějších příčin', nazev_nemoci = 'Poranění, otravy a některé jiné následky vnějších příčin'
-- WHERE kategorie_nemoci_kod = '' AND pricina_smrti_kod = '';


-- spojeni zemreli Praha a zemreli v okresech		
CREATE OR REPLACE TABLE zemreli_2006_2022	
SELECT *
FROM 
	(SELECT * FROM zemreli_okresy zo 
	UNION ALL
	SELECT * FROM zemreli_praha_ zp) AS vse
ORDER BY rok

SELECT  *
FROM zemreli_2006_2022 z 
-- WHERE 1=1
--		AND nazev_nemoci = ''
--		AND kategorie_nemoci = ''

-- umrti bez podminky: 3 806 398, umrti s podminkou: 1 903 220
SELECT
	sum(pocet_umrti)
FROM zemreli_2006_2022 z
WHERE 1=1
		AND nazev_nemoci = ''
		AND kategorie_nemoci = ''

		
		
		
		
/*
 * STAT/KRAJ/OKRES
 */

-- kraje
CREATE TABLE `kraj` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID Kraje',
  `kod` varchar(7) COLLATE utf8_czech_ci NOT NULL COMMENT 'Kód kraje',
  `nazev` varchar(80) COLLATE utf8_czech_ci NOT NULL COMMENT 'Název kraje',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci COMMENT='Kraj';

INSERT INTO `kraj` (`id`, `kod`, `nazev`) VALUES
(1,	'CZ041',	'Karlovarský kraj'),
(2,	'CZ020',	'Středočeský kraj'),
(3,	'CZ031',	'Jihočeský kraj'),
(4,	'CZ064',	'Jihomoravský kraj'),
(5,	'CZ052',	'Královéhradecký kraj'),
(6,	'CZ053',	'Pardubický kraj'),
(7,	'CZ080',	'Moravskoslezský kraj'),
(8,	'CZ051',	'Liberecký kraj'),
(9,	'CZ071',	'Olomoucký kraj'),
(10,	'CZ063',	'Kraj Vysočina'),
(11,	'CZ042',	'Ústecký kraj'),
(12,	'CZ072',	'Zlínský kraj'),
(13,	'CZ032',	'Plzeňský kraj'),
(14,	'CZ010',	'Hlavní město Praha');		
		

-- okresy
CREATE TABLE `okres` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID okresu',
  `kraj_id` int(11) NOT NULL COMMENT 'Kraj',
  `kod` varchar(9) COLLATE utf8_czech_ci NOT NULL COMMENT 'Kód okresu',
  `nazev` varchar(80) COLLATE utf8_czech_ci NOT NULL COMMENT 'Název okresu',
  PRIMARY KEY (`id`),
  KEY `kraj_id` (`kraj_id`),
  CONSTRAINT `okres_ibfk_1` FOREIGN KEY (`kraj_id`) REFERENCES `kraj` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci COMMENT='Okres';

INSERT INTO `okres` (`id`, `kraj_id`, `kod`, `nazev`) VALUES
(1,	1,	'CZ0412',	'Karlovy Vary'),
(2,	2,	'CZ0205',	'Kutná Hora'),
(3,	3,	'CZ0311',	'České Budějovice'),
(4,	4,	'CZ0641',	'Blansko'),
(5,	5,	'CZ0523',	'Náchod'),
(6,	6,	'CZ0534',	'Ústí nad Orlicí'),
(7,	7,	'CZ0803',	'Karviná'),
(8,	5,	'CZ0524',	'Rychnov nad Kněžnou'),
(9,	3,	'CZ0314',	'Písek'),
(10,	8,	'CZ0512',	'Jablonec nad Nisou'),
(11,	7,	'CZ0804',	'Nový Jičín'),
(12,	9,	'CZ0713',	'Prostějov'),
(13,	7,	'CZ0801',	'Bruntál'),
(14,	4,	'CZ0645',	'Hodonín'),
(15,	10,	'CZ0633',	'Pelhřimov'),
(16,	10,	'CZ0632',	'Jihlava'),
(17,	11,	'CZ0421',	'Děčín'),
(18,	1,	'CZ0411',	'Cheb'),
(19,	3,	'CZ0315',	'Prachatice'),
(20,	2,	'CZ0209',	'Praha-východ'),
(21,	9,	'CZ0712',	'Olomouc'),
(22,	5,	'CZ0521',	'Hradec Králové'),
(23,	10,	'CZ0634',	'Třebíč'),
(24,	12,	'CZ0722',	'Uherské Hradiště'),
(25,	4,	'CZ0643',	'Brno-venkov'),
(26,	13,	'CZ0321',	'Domažlice'),
(27,	5,	'CZ0522',	'Jičín'),
(28,	10,	'CZ0631',	'Havlíčkův Brod'),
(29,	2,	'CZ0207',	'Mladá Boleslav'),
(30,	10,	'CZ0635',	'Žďár nad Sázavou'),
(31,	3,	'CZ0317',	'Tábor'),
(32,	6,	'CZ0533',	'Svitavy'),
(33,	3,	'CZ0313',	'Jindřichův Hradec'),
(34,	4,	'CZ0647',	'Znojmo'),
(35,	6,	'CZ0532',	'Pardubice'),
(36,	2,	'CZ0204',	'Kolín'),
(37,	12,	'CZ0721',	'Kroměříž'),
(38,	7,	'CZ0802',	'Frýdek-Místek'),
(39,	5,	'CZ0525',	'Trutnov'),
(40,	3,	'CZ0316',	'Strakonice'),
(41,	4,	'CZ0644',	'Břeclav'),
(42,	2,	'CZ0202',	'Beroun'),
(43,	13,	'CZ0325',	'Plzeň-sever'),
(44,	2,	'CZ020C',	'Rakovník'),
(45,	11,	'CZ0425',	'Most'),
(46,	13,	'CZ0322',	'Klatovy'),
(47,	11,	'CZ0423',	'Litoměřice'),
(48,	7,	'CZ0805',	'Opava'),
(49,	8,	'CZ0514',	'Semily'),
(50,	9,	'CZ0711',	'Jeseník'),
(51,	2,	'CZ0203',	'Kladno'),
(52,	9,	'CZ0714',	'Přerov'),
(53,	12,	'CZ0724',	'Zlín'),
(54,	2,	'CZ0201',	'Benešov'),
(55,	3,	'CZ0312',	'Český Krumlov'),
(56,	13,	'CZ0327',	'Tachov'),
(57,	2,	'CZ0208',	'Nymburk'),
(58,	6,	'CZ0531',	'Chrudim'),
(59,	13,	'CZ0326',	'Rokycany'),
(60,	2,	'CZ020B',	'Příbram'),
(61,	8,	'CZ0511',	'Česká Lípa'),
(62,	8,	'CZ0513',	'Liberec'),
(63,	11,	'CZ0422',	'Chomutov'),
(64,	11,	'CZ0426',	'Teplice'),
(65,	11,	'CZ0424',	'Louny'),
(66,	13,	'CZ0324',	'Plzeň-jih'),
(67,	9,	'CZ0715',	'Šumperk'),
(68,	4,	'CZ0646',	'Vyškov'),
(69,	2,	'CZ020A',	'Praha-západ'),
(70,	12,	'CZ0723',	'Vsetín'),
(71,	4,	'CZ0642',	'Brno-město'),
(72,	1,	'CZ0413',	'Sokolov'),
(73,	2,	'CZ0206',	'Mělník'),
(74,	7,	'CZ0806',	'Ostrava-město'),
(75,	11,	'CZ0427',	'Ústí nad Labem'),
(76,	13,	'CZ0323',	'Plzeň-město'),
(77,	14,	'CZ0100',	'Praha');

		
		

SELECT *
FROM okres


CREATE TABLE okresy_komplet
SELECT
	co.chodnota,
	co.cznuts,
	o.kraj_id,
	o.nazev
FROM okres o
JOIN ciselnik_okresu co
	ON co.cznuts = o.kod

SELECT *
FROM kraj k 
	
-- okresy kraje
CREATE OR REPLACE TABLE kraje_okresy_komplet
SELECT 
	ok.chodnota,
	ok.nazev, 
	ok.cznuts,
	ok.kraj_id,
	CASE 
		WHEN kraj_id = '1' THEN 'Karlovarský kraj'
		WHEN kraj_id = '2' THEN 'Středočeský kraj'
		WHEN kraj_id = '3' THEN 'Jihočeský kraj'
		WHEN kraj_id = '4' THEN 'Jihomoravský kraj'
		WHEN kraj_id = '5' THEN 'Královéhradecký kraj'
		WHEN kraj_id = '6' THEN 'Pardubický kraj'
		WHEN kraj_id = '7' THEN 'Moravskoslezský kraj'
		WHEN kraj_id = '8' THEN 'Liberecký kraj'
		WHEN kraj_id = '9' THEN 'Olomoucký kraj'
		WHEN kraj_id = '10' THEN 'Kraj Vysočina'
		WHEN kraj_id = '11' THEN 'Ústecký kraj'
		WHEN kraj_id = '12' THEN 'Zlínský kraj'
		WHEN kraj_id = '13' THEN 'Plzeňský kraj'
		WHEN kraj_id = '14' THEN 'Hlavní město Praha'
		ELSE 'nothing'
	END AS kraj
FROM okresy_komplet ok;

SELECT *
FROM kraje_okresy_komplet kok 


	
CREATE OR REPLACE TABLE stat_kraj_okres_komplet
SELECT 
	chodnota AS kod_okresu,
	nazev AS okres, 
	kraj_id,
	kraj,
	CASE 
		WHEN kraj_id = '1' THEN 'Česká republika'
		WHEN kraj_id = '2' THEN 'Česká republika'
		WHEN kraj_id = '3' THEN 'Česká republika'
		WHEN kraj_id = '4' THEN 'Česká republika'
		WHEN kraj_id = '5' THEN 'Česká republika'
		WHEN kraj_id = '6' THEN 'Česká republika'
		WHEN kraj_id = '7' THEN 'Česká republika'
		WHEN kraj_id = '8' THEN 'Česká republika'
		WHEN kraj_id = '9' THEN 'Česká republika'
		WHEN kraj_id = '10' THEN 'Česká republika'
		WHEN kraj_id = '11' THEN 'Česká republika'
		WHEN kraj_id = '12' THEN 'Česká republika'
		WHEN kraj_id = '13' THEN 'Česká republika'
		WHEN kraj_id = '14' THEN 'Česká republika'
		ELSE 'nothing'
	END AS stat
FROM kraje_okresy_komplet kok;	


CREATE OR REPLACE TABLE stat_kraj_okres
SELECT
	stat, kraj, okres, kod_okresu, kraj_id 
FROM stat_kraj_okres_komplet skok 


SELECT *
FROM stat_kraj_okres sko 
