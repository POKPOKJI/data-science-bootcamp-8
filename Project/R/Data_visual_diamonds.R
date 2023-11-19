#Use diamonds dataset (or other datasets) to create 5 charts 
library(patchwork)
library(tidyverse)
library(tinytex)
tinytex::install_tinytex()
set.seed(20)
sample_diamonds <- sample_frac(diamonds,0.1)
{r setup, include=FALSE}
knitr::opts_chunk$set(warning = FALSE, message = FALSE)

#1.เกรดการตัดเพชรในตลาดภาพรวมเป็นยังไง 
sample_diamonds %>%
  ggplot(aes(cut,fill = color)) +
  geom_bar(position = "dodge") +
  labs(title = "Cut quality in Market",
       x = "Cut grade") +
  theme_minimal()

#2.ราคาต่อการัต จัดกลุ่มโดยcut
sample_diamonds %>%
  ggplot(aes(carat,price,col = cut)) +
  geom_point(alpha = 0.2) +
  geom_smooth() +
  scale_color_manual(values = c("red","green","blue","black","orange"))+
  labs(title = "Relationship between Carat and Price by cut",) +
  theme_minimal()

#3.ราคาต่อการัต จัดกลุ่มโดย color
a1 <- sample_diamonds %>%
  ggplot(aes(carat,price,col = color)) +
  geom_point(alpha = 0.5) +
  geom_smooth(fill = "lightgray",alpha =0.1) +
  labs(title = "Relationship between Carat and Price by color") +
  theme_minimal()

a2 <- sample_diamonds %>%
  ggplot(aes(color,price,fill = color)) +
  geom_boxplot() +
  labs(title = " Distribution of color and price") +
  theme_minimal()

a3 <- sample_diamonds %>%
  ggplot(aes(color,fill = color)) +
  geom_bar() +
  labs(title = "Number of diamond  color in Market") +
  theme_minimal()

a1 / (a2+a3)
#4 เทียบclarity กับ color

a4 <- sample_diamonds %>%
  ggplot(aes(carat,price,col = price)) +
  geom_point() +
  geom_smooth(col = "red") +
  facet_grid(color~clarity) +
  theme_minimal() +
  scale_color_gradient(low = "black",high = "green")
a4

#5.เราทราบไปถึงการลงทุนไปแล้ว ถ้าอยากได้ราคาที่เหมาะสมและสมเหตุสมผลหละ
#ต้องเอาตารางเทียบทั้งหมดมารวมกันเพื่อวิเคราะห์ โดยอิงจาก cut ก่อน
#เราเลือกจากที่มีมากสุดในตลาด ใน spec ที่ดีที่สุด ทำให้ราคาน่าจะสมเหตุสมผลสุด
a5 <- sample_diamonds %>%
  count(cut,clarity) %>%
  ggplot(aes(cut,clarity, color = n)) +
  geom_count() +
  labs(title = "The relationship between cut and clarity of diamonds") +
  theme_minimal() +
  scale_color_gradient(low = "black",high = "gold")

a6 <- sample_diamonds %>%
  count(cut,color) %>%
  ggplot(aes(cut,color, color = n)) +
  geom_count() +
  labs(title = "The relationship between cut and color of diamonds") +
  theme_minimal() +
  scale_color_gradient(low = "black",high = "red")
# และกราฟ ข้อ 4

(a5 + a6) / a4

sample_diamonds %>%
  count(cut,clarity) %>%
  ggplot(aes(cut,clarity,col = n)) +
  geom_point(size = 10) +
  labs(title = "The relationship between cut and clarity of diamonds") +
  theme_minimal() +
  scale_color_gradient(low = "black",high = "gold")
  
