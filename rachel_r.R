bootcampdata <- read.csv("C:/Users/Rachel/Downloads/workshop.csv", header = T)
#listwise deletion
bootcampdata1<-na.omit(bootcampdata)

attach(bootcampdata1)

summary(bootcampdata)

#how to install a package and call it to use
install.packages("Hmisc")
library(Hmisc)

#---------------------------------------------------------------- 
# plots of agreeableness vs age
hist(AGREE)
hist(Age)
plot(AGREE, Age)


#simple centering and scaling
agec50D10 <-(Age-50)/10
Educ12D4 <- (EDU - 12)/4

#simple regression analysis
REG1 <- lm(AGREE ~ agec50D10) 
summary(REG1)
YHAT <- predict.lm(REG1)
plot(agec50D10,YHAT)
plot(YHAT,AGREE)
PRED.REG1 <- cor(YHAT,AGREE)**2
PRED.REG1


#multiple regression
REG2 <- lm(AGREE ~ agec50D10 + Educ12D4 + nchild)
summary(REG2)
YHAT.REG2 <- predict(REG2)
plot(agec50D10,YHAT.REG2)
plot(YHAT.REG2,AGREE)
PRED.REG2 <- cor(YHAT.REG2,AGREE)**2
PRED.REG2

