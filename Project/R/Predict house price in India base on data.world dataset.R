## Homework for ML live day 1
### predict house price in India base on data.world dataset 
### Have to get 3-5 variables for predict

# install essential library
library(tidyverse)
library(caret)
library(readxl)
# 0. step 0 before train ml model
# import data set

house_price_2016 <- read_excel("House Price India.xlsx",col_names = TRUE,sheet = "House 2016")
house_price_2017 <- read_excel("House Price India.xlsx",col_names = TRUE,sheet = "House 2017")
# if dataset has many row , its should keep in list before bind_rows or comerge
house <- list(house_price_2016,house_price_2017)
full_house <- bind_rows(house)
# cheack na and modify for easy to transforms 
glimpse(full_house)
nrow(full_house)
full_house %>%
  complete.cases() %>%
  mean()
# if mean after complete.cases == 1 it's mean this dataset is no NA

full_house
# to fix name colums after imported and appear ' ' 
names(full_house) <- gsub(" ", "_", names(full_house))
# change all name columns to lower letter
names(full_house) <- tolower(names(full_house))



## hit check histgram of price for checking Normal distribution
hist(full_house$price)
# use log to fix data
full_house$price <- log(full_house$price)
hist(full_house$price)

## select 3-5 variables for predict
full_house_select <- full_house %>%
                        select(number_of_bedrooms,
                               number_of_bathrooms,
                               living_area,
                               condition_of_the_house,
                               grade_of_the_house,
                               renovation_year,
                               price)                      

# 1. step 1 split data before train ml model
split_data <- function(df){
  nrow(df)
  n <- nrow(df)
  train_id <- sample(1:n,size = n*0.8,replace = FALSE)
  train_set <- df[train_id,]
  test_set <- df[-train_id,]
  return(list(train_set,test_set))
}

train_test_set <- split_data(full_house_select)
train_set <- train_test_set[[1]]
test_set <- train_test_set[[2]]

# 2. train model we use linear regression to predict
train_model <- train(price ~ . ,
                     data = train_set,
                     method = "lm")
train_model
# 3. score model (predict)
predicted <- predict(train_model,newdata = test_set)

# 4. evaluate model
## mean absolute error
(mae = mean(abs(predicted - test_set$price)))
## root mean square error
(rmse = sqrt(mean((predicted - test_set$price)**2)))
