# PowerBI_Project_ENGETO_Academy

# Zemřelí podle příčin smrti a pohlaví v ČR, krajích a okresech

Datová sada obsahuje časovou řadu statistických údajů o zemřelých podle příčin smrti a pohlaví za okresy, kraje i republiku od roku 2006 do roku 2022 včetně. 
Uvedeny jsou jak údaje za jednotlivá pohlaví (muži, ženy), tak údaje za obě pohlaví. Uvedeny jsou stejně tak jednotlivé příčiny smrti, ale také podle hierarchického začlenění do kapitol mezinárodní klasifikace (kategorie nemoci). 
Území krajů pokrývá území celé republiky beze zbytku. Území okresů pokrývá území republiky rovněž, Praha je pro tyto účely považována jako neoficiální okres.

## **Datové sady:**

**Zdrojem dat je Český statistický úřad.**

Zdroj: `https://www.czso.cz/csu/czso/zemreli-podle-pricin-smrti-a-pohlavi-v-cr-krajich-a-okresech`

Zdroj: `https://www.czso.cz/csu/stoletistatistiky/pocet-zive-narozenych-v-ceske-republice`

## **Číselníky sdílených informací o ČR::**

`Číselník okresů – kód číselníku ČSÚ 101`

CSV: https://apl.czso.cz/iSMS/do_cis_export?kodcis=101&typdat=0&cisjaz=203&format=2

`Číselník krajů – kód číselníku ČSÚ 100`

CSV: https://apl.czso.cz/iSMS/do_cis_export?kodcis=100&typdat=0&cisjaz=203&format=2


## **Postup zpracování**

Prvním krokem byla úprava dat pomocí jazyka SQL v databázi MariaDB. Byl vytvořen soubor `zemreli_2006_2022.csv`, který byl očištěn o nepotřebné sloupce, kraj Praha byl zařazen mezi okresy s kódem 40924.

Pomocí jazka SQL byl dále vytvořen soubor `stat_kraj_okres.csv`, kde je ke každému okresu přiřazen kraj.

V dalším kroku byly zdroje dat (`zemreli_2006_2022.csv`, `stat_kraj_okres.csv`, `Narozeni.xlsx`) nahrány do Power BI. 

V Query editoru byla data dále upravena následujícím způsobem: 

1. sloupci `rok` byl přiřazen datový typ Datum
2. sloučení dotazů: k jednotlivým položkám byla přiřazena informace o území (`zemreli` + `stat_kraj_okres` přes atribut `okres_kod`)
3. rozdělení sloupce oddělovačem (u sloupce `kategorie_nemoci` byl odebrán kód na konci řádku)
4. finální úprava: odebrání nepotřebných sloupců/přejmenování sloupců

Následovalo samotné zpracování reportu, report má dvě strany Přehled a Detail.

### Přehled
Na první straně reportu mají uživatelé možnost filtrovat přes výběr území a časový kontext. Proto jsou v pravé horní části umístěny 2 filtry. 

V levém rohu reportu je karta, kde je zobrazena **informace o celkovém úmrtí a průměrném ročním úmrtí mezi lety 2006 až 2022**, tato karta na filtry nereaguje. V pravém rohu reportu jsou umístěny dvě informace, a to **Počet úmtí a Úmrtí podle pohlaví**, tyto vizualizece reagují na oba filtry.

Powerbi dashboardu dominuje graf **`Trend úmrtí`**, který reaguje na oba filtry. Od roku 2020 je patrný zvýšený trend počtu úmrtí, proto je přidán graf **Skupiny vymezených příčin smrti v letech 2020 až 2022**, tento graf reaguje pouze na filtr území.

### Detail
Druhá strana reportu je zaměřena na detailnějsí informace, uživatelé mají možnost filtrovat přes výběr území, časový kontext, výběr příčiny smrti a výběr pohlaví. 

Dominantním prvkem je matice, která zobrazuje **`Počet zemřelých v jednotlivých okresech`**. V pravém rohu jsou pod sebou dva vizuály, kde je měřen **průměr úmrtí** a **počet úmrtí v procentech**, tyto vizuály reagují na všechny filtry.

Dále je v Powerbi dashboardu umístěn graf **Zemřelí podle příčin**, který reaguje na všechny filtry. Pro zajímavost je zobrazen graf **Srovnání počtu zemřelých a živě narozených v ČR za období 2006 až 2022**, tento graf na filtry nereaguje.

Poslední dvě vizualizace věnují pozornost **pěti nejčastějším příčinám smrti u mužů a u žen**. U těchto vizualizací mají uživatelé možnost filtrovat přes výběr území a časový kontext.
