## Homework 2 - create database on Postgresql => create a few table about pizza restaurants

#ลองดึง table เก่าจาก db นึงไปสู่ db นึง
library(RSQLite)
# 1. connect db
con1 <- dbConnect(SQLite(),"source/res.db")

# 2. check db
dbListTables(con1)
# 3. list field (cols)
dbListFields(con1,"menus")

# 4. get data
customers <- dbGetQuery(con1,"select * from customer")
employees <- dbGetQuery(con1,"select * from employees")
ingredient <- dbGetQuery(con1,"select * from ingredient")
menus_ingre <- dbGetQuery(con1,"select * from menus_ingre")

# 5. close db
dbDisconnect(con1)

### อัปโหลดขึ้น db อันใหม่
# 0.use library 
library(RPostgreSQL)
library(tidyverse)


# 1. connect db
con <- dbConnect(PostgreSQL(),
                 host = "floppy.db.elephantsql.com",
                 port = 5432,
                 user = "selfweoz",
                 password = "XY2Jy00k-MrnPDzCyDs3LcHTdAPaXoqq",
                 dbname = "selfweoz")
# 2. check db
dbListTables(con)

# 3. dis db
dbDisconnect(con)

# 4. write table or export table
dbWriteTable(con,"customers",customers)
dbWriteTable(con,"employees",employees)
dbWriteTable(con,"ingredient",ingredient)
dbWriteTable(con,"menus_ingre",menus_ingre)

# 5. close db
dbDisconnect(con)

