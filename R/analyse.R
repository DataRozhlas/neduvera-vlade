getIdOsoby <- function(idp) {
  result <- poslanec %>% filter(id_poslanec==idp) %>% select(id_osoba)
  return(as.numeric(result[1,1]))
}

najdiPoslance <- function(ido) {
  osoby %>% filter(id_osoba==ido)
} 

najdiKlub <- function(ido, idh) {
  cas_hlasovani <- hlasovani %>% filter(id_hlasovani==idh) %>% select(datetime) 
  platna <- zarazeni %>% filter(id_osoba==ido) %>% filter(cl_funkce==0) %>% filter(od_o < cas_hlasovani[[1]]) %>% filter(do_o > cas_hlasovani[[1]])
  for (i in platna$id_of) {
    organ <- organy %>% filter(id_organ==i)
    if (organ$id_typ_organu==1) {return(organ[1,4][[1]])}
  }
}

prepareJSON <- function(idh) {
  result <- data.frame()
  posl_hlasy <- hlasovani_poslanci %>% filter(id_hlasovani==idh)
  for (i in 1:nrow(posl_hlasy)) {
    result <- rbind(result, data.frame(najdiPoslance(getIdOsoby(posl_hlasy[i,1][[1]])), klub=najdiKlub(getIdOsoby(posl_hlasy[i,1][[1]]), idh), vysledek=posl_hlasy[i,3] ))        
  }
  result <- result %>% select(j=jmeno, p=prijmeni, k=klub, v=vysledek)
  hlasovani_detail <- hlasovani %>% filter(id_hlasovani==idh)
  result <- list(hlasovani_detail[1,c(1:6, 8:18)], result)
  return(result)
}

vysledek  <-  list()

for (i in vybrana_hlasovani) {
  data <- prepareJSON(i)
  vysledek <- c(vysledek, data)
}

write_lines(toJSON(vysledek), "../js/data.json")
