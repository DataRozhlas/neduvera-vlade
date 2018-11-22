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

#dvě chybějící hlasování
vysledek[[2]] <- vysledek[[2]] %>% left_join(ch2003) %>% select(1,2,3,v=5)
vysledek[[16]] <- vysledek[[16]] %>% left_join(ch2010) %>% select(1,2,3,v=5)


vysledek[[1]]$datum <- "26.09.2003"
vysledek[[1]]$pro <- 98
vysledek[[1]]$proti <- 100
vysledek[[1]]$zdrzel <- 1

vysledek[[15]]$pro <- 80
vysledek[[15]]$proti <- 113
vysledek[[15]]$zdrzel <- 0

vysledek[[15]]


write_lines(toJSON(vysledek), "data.json")


