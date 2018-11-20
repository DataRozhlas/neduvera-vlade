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
roky <- c(2002, 2006, 2010, 2013, 2017)

hlasovani <- data.frame(id_poslanec=numeric(), id_hlasovani=numeric(), vyseledek=character())

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
  hlasovani <- rbind(hlasovani, spojHlasy(j))
}


