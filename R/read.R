library(readr)
files <- c("")

# načíst poslance
download.file("https://www.psp.cz/eknih/cdrom/opendata/poslanci.zip", "poslanci.zip")
unzip("poslanci.zip")
osoby <- read_delim("osoby.unl", "|", locale = locale(encoding="windows-1250"), col_names = c("id_osoba", "pred", "jmeno", "prijmeni", "za", "narozeni", "pohlavi", "zmena", "umrti"))
organy <- read_delim("organy.unl", "|", locale = locale(encoding="windows-1250"), col_names = c("id_organ", "organ_id_organ", "id_typ_organu", "zkratka", "nazev_organu_cz", "nazev_organu_en", "od_organ", "do_organ", "priorita", "cl_organ_base"))
zarazeni <- read_delim("zarazeni.unl", "|", locale = locale(encoding="windows-1250"), col_names = c("id_osoba", "id_of", "cl_funkce", "od_o", "do_o", "od_f", "do_f"))
file.remove(list.files(pattern="*.unl|*.zip"))

# načíst všechna hlasování
zipfiles <- c("hl-2002ps.zip", "hl-2006ps.zip", "hl-2010ps.zip", "hl-2013ps.zip")

https://www.psp.cz/eknih/cdrom/opendata/


download.file("https://www.psp.cz/eknih/cdrom/opendata/hl-2002ps.zip", "hl-2002ps.zip")
unzip("hl-2002ps.zip")
