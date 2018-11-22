library(tidyverse)
library(jsonlite)


# načíst poslance
download.file("https://www.psp.cz/eknih/cdrom/opendata/poslanci.zip", "poslanci.zip")
unzip("poslanci.zip")
osoby <- read_delim("osoby.unl", "|", locale = locale(encoding="windows-1250"), col_names = c("id_osoba", "pred", "jmeno", "prijmeni", "za", "narozeni", "pohlavi", "zmena", "umrti"))
poslanec <- read_delim("poslanec.unl", "|", locale = locale(encoding="windows-1250"), col_names = c("id_poslanec", "id_osoba", "id_kraj", "id_kandidatka", "id_obdobi", "web", "ulice", "obec", "psc", "email", "telefon", "fax", "psp_telefon", "facebook", "foto"))
organy <- read_delim("organy.unl", "|", locale = locale(encoding="windows-1250"), col_names = c("id_organ", "organ_id_organ", "id_typ_organu", "zkratka", "nazev_organu_cz", "nazev_organu_en", "od_organ", "do_organ", "priorita", "cl_organ_base"))
typ_organu <- read_delim("typ_organu.unl", "|", locale = locale(encoding="windows-1250"), col_names = c("id_typ_org", "typ_id_typ_org", "nazev_typ_org_cz", "nazev_typ_org_en", "typ_org_obecny", "priorita"))
zarazeni <- read_delim("zarazeni.unl", "|", locale = locale(encoding="windows-1250"), col_names = c("id_osoba", "id_of", "cl_funkce", "od_o", "do_o", "od_f", "do_f"))
file.remove(list.files(pattern="*.unl|*.zip"))

# načíst všechna hlasování
roky <- c(2002, 2006, 2010, 2013, 2017)

hlasovani <- data.frame() 
hlasovani_poslanci <- data.frame(id_poslanec=numeric(), id_hlasovani=numeric(), vyseledek=character())

spojHlasovani <- function(rok) {
  download.file(paste0("https://www.psp.cz/eknih/cdrom/opendata/hl-", rok, "ps.zip"), paste0("hl-", rok, "ps.zip"))
  unzip(paste0("hl-", rok, "ps.zip"))
  return(read_delim(paste0("hl", rok, "s.unl"), "|", locale = locale(encoding="windows-1250"), col_names = c("id_hlasovani", "id_organ", "schuze", "cislo", "bod", "datum", "cas", "pro", "proti", "zdrzel", "nehlasoval", "prihlaseno", "kvorum", "druh_hlasovani", "vysledek", "nazev_dlouhy", "nazev_kratky")))
  file.remove(list.files(pattern="*.unl|*.zip"))
}

spojHlasy <- function(rok) {
  download.file(paste0("https://www.psp.cz/eknih/cdrom/opendata/hl-", rok, "ps.zip"), paste0("hl-", rok, "ps.zip"))
  unzip(paste0("hl-", rok, "ps.zip"))
  soubory <- list.files(pattern="hl\\d{4}h\\d*.unl")
  result <- data.frame(id_poslanec=numeric(), id_hlasovani=numeric(), vyseledek=character())
  for (i in soubory) {
    result <- rbind(result, read_delim(i, "|", locale = locale(encoding="windows-1250"), col_names = c("id_poslanec", "id_hlasovani", "vysledek")))
  }
  file.remove(list.files(pattern="*.unl|*.zip"))
  return(result)
}

for (j in roky) {
  hlasovani_poslanci <- rbind(hlasovani_poslanci, spojHlasy(j))
}

for (j in roky) {
  hlasovani <- rbind(hlasovani, spojHlasovani(j))
}

hlasovani$datetime <- as.POSIXct(paste(hlasovani$datum, hlasovani$cas), format = "%d.%m.%Y %H:%M:%S")

rm(roky)

#id hlasování
vybrana_hlasovani <- c(32614, 38766, 45611, 46289, 47232, 47953, 49203, 53055, 53463, 55722, 56342, 57199, 60961)

# chybějící hlasování

ch2003 <- read_csv2("Jaroslav Zvěřina;A
                    Libor Ambrozek;B
                   Vlastislav Antolák;A
                   Vlastimil Aubrecht;B
                   Walter Bartoš;A
                   Marta Bayerová;A
                   František Beneš;A
                   Miroslav Beneš;A
                   Milan Bičík;A
                   Marian Bielesz;B
                   Jiří Bílý;A
                   Josef Bíža;A
                   Jarmila Boháčková;B
                   Robin Böhnisch;B
                   Petr Braný;A
                   Petr Bratský;A
                   Ludmila Brynychová;A
                   Petra Buzková;B
                   Ladislav Býček;A
                   Milan Cabrnoch;A
                   Vladimír Čada;B
                   Květoslava Čelišová;A
                   Alexander Černý;A
                   Karel Černý;B
                   Anna Čurdová;B
                   Vlastimil Dlab;A
                   Michal Doktor;A
                   Jiří Dolejš;A
                   Vladimír Doležal;A
                   Pavel Dostál;B
                   Kateřina Dostálová;A
                   Tomáš Dub;A
                   Eva Dundáčková;A
                   Milan Ekert;B
                   Milada Emmerová;B
                   Václav Exner;A
                   Hynek Fajmon;A
                   Jiřina Fialová;A
                   Vojtěch Filip;A
                   Taťána Fischerová;B
                   Václav Frank;A
                   Jaroslav Gongol;A
                   Miroslav Grebeníček;A
                   Stanislav Grospič;A
                   Stanislav Gross;B
                   Jitka Gruntová;A
                   Jan Grůza;B
                   Jiří Hanuš;B
                   Tomáš Hasil;A
                   Michal Hašek;B
                   Pavel Hojda;A
                   Josef Hojdar;C
                   Vilém Holáň;B
                   Pavel Hönig;B
                   Zdeňka Horníková;A
                   Ludvík Hovorka;B
                   Pavel Hrnčíř;A
                   Radim Chytka;A
                   Petr Ibl;B
                   Josef Janeček;B
                   Libor Ježek;A
                   Zdeněk Jičínský;B
                   Miloslav Kala;B
                   Miroslav Kalousek;B
                   Miroslav Kapoun;B
                   Jiří Karas;B
                   Svatopluk Karásek;B
                   Jan Kasal;B
                   Jan Kavan;B
                   Tomáš Kladívko;A
                   Jan Klas;A
                   Martin Kocourek;A
                   Jaromír Kohlíček;A
                   Kateřina Konečná;A
                   Vladimír Koníček;A
                   Robert Kopecký;B
                   Petr Kott;A
                   Zdeněk Koudelka;B
                   Pavel Kováčik;A
                   Miroslav Krajíček;A
                   Jaroslav Krákora;B
                   Michal Kraus;B
                   Petr Krill;A
                   Stanislav Křeček;B
                   Jozef Kubinyi;B
                   Miloslav Kučera;A
                   Karel Kühnl;B
                   Jitka Kupčová;B
                   Miloš Kužvart;B
                   Tomáš Kvapil;B
                   Petr Lachnit;B
                   Ivan Langer;A
                   Vladimír Laštůvka;B
                   Ivana Levá;A
                   Jaroslav Lobkowicz;B
                   Antonín Macháček;B
                   Helena Mallotová;A
                   Josef Mandík;M
                   Soňa Marková;A
                   Zdeněk Maršíček;A
                   Radko Martínek;B
                   Jiří Maštálka;A
                   Miloš Melčák;B
                   Václav Mencl;A
                   Alfréd Michalík;B
                   Josef Mikuta;B
                   Jan Mládek;B
                   Ladislav Mlčák;A
                   Václav Nájemník;A
                   Petr Nečas;A
                   Veronika Nedvědová;A
                   Miroslava Němcová;A
                   Oldřich Němec;B
                   Pavel Němec;B
                   Eva Nováková;B
                   Zbyněk Novotný;A
                   Miroslav Opálka;A
                   Hana Orgoníková;B
                   Vlastimil Ostrý;B
                   Miroslav Ouzký;A
                   Jaroslav Palas;B
                   Jiří Papež;A
                   Alena Páralová;A
                   Vlasta Parkanová;B
                   Miroslav Pátek;A
                   Miloš Patera;A
                   Jiří Patočka;A
                   František Pelc;B
                   Jaroslav Pešán;A
                   Jaroslav Plachý;A
                   Petr Pleva;A
                   Jiří Pospíšil;A
                   Petr Rafaj;B
                   Miloslav Ransdorf;A
                   Svatomír Recman;A
                   Libor Rouček;B
                   Aleš Rozehnal;A
                   Zuzka Bebarová Rujbrová;A
                   Marie Rusová;A
                   Vladimír Říha;B
                   Josef Řihák;B
                   Martin Říman;A
                   Antonín Seďa;B
                   Karel Sehoř;A
                   Pavel Severa;B
                   Jaromír Schling;B
                   Ladislav Skopal;B
                   Josef Smýkal;B
                   Evžen Snítilý;B
                   Bohuslav Sobotka;B
                   František Strnad;B
                   Pavel Suchánek;A
                   Lubomír Suk;A
                   Cyril Svoboda;B
                   Miroslav Svoboda;B
                   Pavel Svoboda;B
                   Antonín Sýkora;B
                   Hana Šedivá;B
                   Iva Šedivá;B
                   David Šeich;A
                   Josef Šenfeld;A
                   Jan Škopík;B
                   Zdeněk Škromach;B
                   Michaela Šojdrová;B
                   Vladimír Špidla;B
                   Karel Šplíchal;B
                   Petr Šulák;B
                   Ladislav Šustr;B
                   Jaromír Talíř;B
                   Lucie Talmanová;A
                   Tomáš Teplík;A
                   Miloš Titz;B
                   Vlastimil Tlustý;A
                   Rudolf Tomíček;B
                   Jiří Třešňák;B
                   Radim Turek;B
                   Ladislav Urban;A
                   Milan Urban;B
                   Jiří Václavek;B
                   Miroslav Váňa;B
                   Eduard Vávra;A
                   Jan Vidím;A
                   Josef Vícha;B
                   Miloslav Vlček;B
                   Miroslava Vlčková;A
                   Oldřich Vojíř;A
                   Jitka Vojtilová;B
                   Robert Vokáč;B
                   Miloslava Vostrá;A
                   Václav Votava;B
                   Tomáš Vrbík;B
                   Ivo Vykydal;B
                   Karel Vymětal;A
                   Jan Zahradil;A
                   Tom Zajíček;A
                   Lubomír Zaorálek;B
                   Bohuslav Záruba;A
                   Eduard Zeman;B
                   Petr Zgarba;B
                   Antonín Zralý;A", col_names = F)

ch2010 <- read_csv2("Ivan Ohlídal;A
                    Jiří Oliva;B
                    Miroslav Opálka;A
                    Hana Orgoníková;A
                    Viktor Paggio;B
                    Jan Pajer;B
                    Jiří Papež;B
                    Vlasta Parkanová;M
                    Jiří Paroubek;A
                    Karolína Peake;B
                    Martin Pecina;A
                    Gabriela Pecková;B
                    Miroslav Petráň;B
                    Jiří Petrů;A
                    Jaroslav Plachý;B
                    Pavel Ploc;A
                    Stanislav Polčák;B
                    Jiří Pospíšil;B
                    Anna Putnová;B
                    Aleš Rádl;B
                    David Rath;A
                    Aleš Roztočil;B
                    Jiří Rusnok;B
                    Marie Rusová;A
                    Adam Rykala;A
                    Ivana Řápková;B
                    Antonín Seďa;A
                    Marta Semelová;A
                    Jaroslava Schejbalová;B
                    Karel Schwarzenberg;B
                    František Sivera;B
                    Jiří Skalický;B
                    Roman Sklenák;A
                    Petr Skokan;B
                    Ladislav Skopal;A
                    Jan Smutný;B
                    Josef Smýkal;@
                    Bohuslav Sobotka;A
                    Pavel Staněk;B
                    Zbyněk Stanjura;B
                    Miroslava Strnadlová;A
                    Jana Suchá;B
                    Pavel Suchánek;B
                    Pavel Svoboda;B
                    Igor Svoják;B
                    Bořivoj Šarapatka;B
                    David Šeich;B
                    Josef Šenfeld;A
                    Karel Šidlo;A
                    Ladislav Šincl;A
                    Jaroslav Škárka;B
                    Jiří Šlégr;A
                    Marek Šnajdr;B
                    Boris Šťastný;B
                    Jiří Štětina;B
                    Milan Šťovíček;B
                    Jiří Šulc;B
                    Josef Tancoš;A
                    Jeroným Tejc;A
                    Petr Tluchoř;B
                    Tomáš Úlehla;B
                    Milan Urban;A
                    Martin Vacek;B
                    Dana Váhalová;A
                    Miroslav Váňa;A
                    Roman Váňa;A
                    Jaroslav Vandas;A
                    Ladislav Velebný;A
                    Jan Vidím;@
                    Vladislav Vilímec;B
                    David Vodrážka;B
                    Miloslava Vostrá;A
                    Václav Votava;A
                    Radim Vysloužil;B
                    Ivana Weberová;B
                    Jaroslava Wenigerová;B
                    Renáta Witoszová;B
                    Lubomír Zaorálek;A
                    Cyril Zapletal;A
                    Jiří Zemánek;A
                    Václav Zemek;A
                    Vojtěch Adam;A
                    Lenka Andrýsová;B
                    Pavel Antonín;A
                    Michal Babák;B
                    Jan Babor;A
                    Vít Bárta;B
                    Walter Bartoš;B
                    Václav Baštýř;B
                    Jan Bauer;B
                    Zuzka Bebarová Rujbrová;A
                    Pavel Bém;B
                    Marek Benda;B
                    Petr Bendl;B
                    Jiří Besser;B
                    Zdeněk Bezecný;B
                    Zdeněk Boháč;B
                    Vlasta Bohdalová;A
                    Robin Böhnisch;A
                    Petr Braný;A
                    Ludmila Bubeníková;B
                    František Bublan;A
                    Jan Bureš;B
                    Václav Cempírek;B
                    Josef Cogan;B
                    Jan Čechlovský;B
                    Jana Černochová;B
                    Alexander Černý;A
                    Karel Černý;A
                    František Dědič;B
                    Josef Dobeš;B
                    Michal Doktor;B
                    Jiří Dolejš;A
                    Richard Dolejš;A
                    Jaromír Drábek;B
                    Jana Drastichová;B
                    Pavel Drobil;B
                    Jaroslav Eček;B
                    Milada Emmerová;A
                    Jan Farský;B
                    Radim Fiala;B
                    Vojtěch Filip;A
                    Dana Filipi;B
                    Jana Fischerová;B
                    Jan Florián;B
                    Jaroslav Foldyna;A
                    Ivan Fuksa;B
                    Petr Gandalovič;B
                    Petr Gazdík;B
                    Miroslav Grebeníček;A
                    Martin Gregora;B
                    Stanislav Grospič;A
                    Milada Halíková;A
                    Jan Hamáček;A
                    Alena Hanáková;B
                    Michal Hašek;A
                    Leoš Heger;B
                    Pavel Hojda;A
                    Pavel Holík;A
                    Václav Horáček;B
                    Zdeňka Horníková;B
                    Gabriela Hubáčková;A
                    Petr Hulinský;A
                    Stanislav Huml;B
                    Jan Husák;B
                    Jitka Chalánková;B
                    Otto Chaloupka;B
                    Tomáš Chalupa;B
                    Rudolf Chlad;B
                    Jan Chvojka;A
                    Petr Jalowiczor;M
                    Vítězslav Jandák;A
                    Michal Janek;B
                    Miroslav Jeník;B
                    Luděk Jeništa;B
                    Ladislav Jirků;B
                    Radim Jirout;B
                    Radek John;B
                    David Kádner;M
                    Miroslav Kalousek;B
                    Jana Kaslová;M
                    Jan Klán;A
                    Kateřina Klasnová;B
                    Václav Klučka;A
                    Kristýna Kočí;B
                    Lenka Kohoutová;M
                    Kateřina Konečná;A
                    Vladimír Koníček;A
                    Daniel Korte;B
                    Jiří Koskuba;A
                    Rom Kostřica;B
                    Patricie Kotalíková;B
                    Pavel Kováčik;A
                    Jaroslav Krákora;A
                    Jiří Krátký;A
                    Jaroslav Krupka;B
                    Stanislav Křeček;A
                    Václav Kubata;B
                    Helena Langšádlová;B
                    Jan Látka;A
                    František Laudát;B
                    Vladimíra Lesenská;A
                    Ivana Levá;A
                    Jaroslav Lobkowicz;B
                    Pavol Lukša;B
                    Soňa Marková;A
                    Jaroslav Martinů;B
                    Květa Matušovská;A
                    Václav Mencl;B
                    Alfréd Michalík;A
                    Dagmar Navrátilová;B
                    Petr Nečas;B
                    Marie Nedvědová;A
                    Josef Nekl;A
                    Miroslava Němcová;B
                    Vít Němeček;B
                    Václav Neubauer;A
                    František Novosad;A
                    Josef Novotný;A
                    Josef Novotný st.;B", col_names = F)

odd <- function(x) x%%2 != 0 

ch2010 <- data.frame(p=unlist(str_split(ch2010$X1, pattern=" ", 2))[odd(1:400)], j=unlist(str_split(ch2010$X1, pattern=" ", 2))[!odd(1:400)], v2=as.character(ch2010$X2))
ch2003 <- data.frame(p=unlist(str_split(ch2003$X1, pattern=" ", 2))[odd(1:400)], j=unlist(str_split(ch2003$X1, pattern=" ", 2))[!odd(1:400)], v2=as.character(ch2003$X2))
ch2010$v2 <- as.character