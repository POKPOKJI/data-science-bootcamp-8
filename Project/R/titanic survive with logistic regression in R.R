## titanic survive with logistic regression in R

## install library
library(tidyverse)
library(titanic)

## check data
head(titanic_train)

## clean data that have NA (Null)
(nrow(titanic_train))
titanic_clean <- na.omit(titanic_train)
(nrow(titanic_clean))

# check data which is cleaned that its still have NA
titanic_clean %>%
  summarise(sum(is.na(.)))

## before split data for test model
# I like to check variable that can affect survive
glimpse(titanic_clean)

## i will change Sex from string to factor
titanic_clean$Sex <- factor(titanic_clean$Sex ,
                            level = c("male","female"),
                            labels = c(0,1))


### Split data for test model
# use sample for sampling titanic passenger
# i use 75% for train model and 25% for test model
set.seed(10)
allrow <- nrow(titanic_clean)
titanic_random <- sample(allrow, size = allrow*0.75)
titanic_for_train <- titanic_clean[titanic_random,]
titanic_for_test <- titanic_clean[-titanic_random,]

## Use logistic regression for train model
# i will use pclass , sex , age , cabin
logis_model <- glm(Survived ~ Pclass + Sex + Age + Fare , data = titanic_for_train , family =  "binomial")
# check p-vlaues
summary(logis_model)
# change regression into probability
predic_train <- predict(logis_model,type = "response")
# set threshold for split between dead or alive
titanic_for_train$predict <- if_else(predic_train < 0.5 , 0 , 1)


## test model
predic_test  <- predict(logis_model , newdata = titanic_for_test, type = "response")
titanic_for_test$predict <- if_else(predic_test < 0.5 , 0 , 1)
df <- data.frame(train = mean(titanic_for_train$Survived == titanic_for_train$predict),
                 test = mean(titanic_for_test$Survived == titanic_for_test$predict))
df

## this model can predict unseen data

## use confusion matrix for explain this model

conM <- table(titanic_for_train$predict,titanic_for_train$Survived, 
              dnn = c("Predicted","Actual"))
conM
## Acc
Acc <- (conM[1,1] + conM[2,2]) / sum(conM)
cat("Accuracy is :", Acc)
## Precision
Precision <- conM[2,2]/ sum(conM[2,])
cat("Precision is :", Precision)
## Recall
Recall <- conM[2,2] / sum(conM[,2])
cat("Recall is :", Recall)
## f-1
f1 <- (2*(Precision*Recall)/(Precision+Recall))
cat("f1 is :", f1)

cat("Accuracy   :", Acc,
    "\nPrecision  :", Precision,
    "\nRecall     :", Recall,
    "\nf1         :", f1)


## summary 
# this trained model  has capility to predict titanic surived  which are trained by Pclass, Sex, Age, Fare variables within titanic dataset, upto around 76-80 % of confusion matrix.