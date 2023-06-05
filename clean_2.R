library('tidyverse')

#library('naniar')
library('readr')
# dt1 <- read_csv('common_brushtail.csv')
# dt2 <- read_csv('common_ringtail.csv')
# 
# 
# dt11 <- dt1[ , colSums(is.na(dt1))<=0.2*nrow(dt1)]
# dt21 <- dt2[ , colSums(is.na(dt2))<=0.2*nrow(dt2)]
# 
# summary(dt1)
# 
# cols <- c('eventDate', 'stateProvince', 'decimalLatitude', 'decimalLongitude','recordID', 'scientificName', 'vernacularName')
# 
# dt12 <- dt11[, cols]
# dt22 <- dt21[, cols]
# 
# 
# 
# dt13 <-dt12[rowSums(is.na(dt12)) == 0, ]
# dt23 <-dt22[rowSums(is.na(dt22)) == 0, ]
# 
# 
# dt14 <- dt13[which(format(dt13$eventDate,"%Y")>=1980 & format(dt13$eventDate,"%Y")<=2023),]
# dt24 <- dt23[which(format(dt23$eventDate,"%Y")>=1980 & format(dt23$eventDate,"%Y")<=2023),]
# 
# 
# states <- unique(dt24$stateProvince)
# 
# 
# dt14$year <- format(dt14$eventDate,"%Y")
# dt24$year <- format(dt24$eventDate,"%Y")



cols <- c("recordID","vernacularName", "scientificName", "decimalLatitude",
          "decimalLongitude","eventDate","stateProvince")

cleandt <- function(file){
  dt <- read_csv(paste0(file,".csv"))
  dt <- dt[, cols]
  dt <- dt[rowSums(is.na(dt)) == 0, ]
  dt <- dt[which(format(dt$eventDate,"%Y")>=1980 & format(dt$eventDate,"%Y")<=format(Sys.Date(), "%Y")),]
  dt$year <- format(dt$eventDate,"%Y")
  dt
  write.table(dt, paste0(file,"_clean.csv"),sep = "," ,row.names = FALSE, col.names = FALSE)
}

cleandt("common_brushtail")

cleandt("common_ringtail")

