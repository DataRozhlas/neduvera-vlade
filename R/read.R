library(tidyverse)

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
