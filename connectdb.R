#install.packages("RMySQL")
library(RMySQL)


con <- dbConnect(RMySQL::MySQL(),
                 host = "tp19db.ck5zqe1er1df.ap-southeast-2.rds.amazonaws.com",
                 port = 3306,
                 dbname = "tp19db",
                 user = "admin",
                 password = "5120tp19")

dbSendQuery(con, "drop table possum;")


dbSendQuery(con,
            "create table possum(
            recordID varchar(100),
            vernacularName varchar(50),
            scientificName varchar(80),
            decimalLatitude float,
            decimalLongitude float,
            eventDate varchar(40),
            stateProvince varchar (15)
            )
            ")

dbSendQuery(con,
            "LOAD DATA LOCAL INFILE 'common_brushtail_clean.csv'
                  INTO TABLE possum
                  FIELDS TERMINATED by ','"
  
)

dbSendQuery(con,
            "LOAD DATA LOCAL INFILE 'common_ringtail_clean.csv'
                  INTO TABLE possum
                  FIELDS TERMINATED by ','"
            
)

dbSendQuery(con,"UPDATE possum SET recordID = REPLACE(recordID, '\"', '')"
            )
dbSendQuery(con,"UPDATE possum SET vernacularName = REPLACE(vernacularName, '\"', '')"
)

dbSendQuery(con,"UPDATE possum SET scientificName = REPLACE(scientificName, '\"', '')"
)

dbSendQuery(con,"UPDATE possum SET stateProvince = REPLACE(stateProvince, '\"', '')"
)




rcds <- dbGetQuery(con, "select * from possum;")




dbDisconnect(con)
