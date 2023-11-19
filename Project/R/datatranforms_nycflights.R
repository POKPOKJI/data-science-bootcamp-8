## HW01 - 5 questions ask about flights dataset
library(tidyverse)
library(nycflights13)

#1.สายการบินไหนบินนานที่สุดต่อ 1 เที่ยวบิน
names(flights)
glimpse(flights)
flights %>%
  group_by(carrier) %>%
  summarise(air_time_total = max(air_time,na.rm = T)) %>%
  arrange(-air_time_total) %>%
  left_join(airlines,by = "carrier") %>%
  select(carrier,name,air_time_total)


#2.สนามบินไหนมีเครื่องมาลงบ่อยที่สุด
flights %>%
  count(dest) %>%
  arrange(-n) %>%
  left_join(airports, by = c("dest" = "faa")) %>% ##เชื่อมแบบชื่อ pri fore key ไม่เหมือนกัน 
  select(dest,name,n)

#3.สายการบินไหน arr_delay บ่อยที่สุด
flights %>%
  filter(arr_delay > 0) %>%
  group_by(carrier) %>%
  summarise(n = n()) %>%
  arrange(-n) %>%
  head(5)
#แบบ count
flights %>%
  filter(arr_delay > 0) %>%
  count(carrier) %>%
  arrange(-n) %>%
  head(5)


#4.ถ้าอยากบินตอนเช้า เวลา 6โมง ที่ EWR ไปลง MIA มีสายการบินไหนบ้าง ขอแบบไม่ดีเลย์
flights %>%
  filter(dep_time >= 600 & origin == "EWR" & dest == "MIA" & is.na(arr_time) != TRUE & dep_delay <= 0) %>%
  distinct(carrier)  ## เป็น fucntion แสดงค่าที่ไม่ซ่้ำ เหมือน unique ใน google sheet แต่  unique ใช้ในนี้ไม่ได้
  
unique(flights$carrier)

#5.สายการบินไหนบินไกลสุดเทียบกับเวลาบิน
flights %>%
  group_by(carrier) %>%
  arrange(-distance,-air_time) %>%
  left_join(airlines,by = "carrier") %>%
  select(carrier,name,distance,air_time) 
  
