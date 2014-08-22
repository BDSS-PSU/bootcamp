# install.packages(c("foreach","doSNOW"))
library(foreach);library(doSNOW);
# Register clusters
cluster <- makeCluster(5, type = "SOCK")
registerDoSNOW(cluster)

##############################
## .combine options
##############################
x <- foreach(i = 1:3) %dopar% sqrt(i); x
x <- foreach(i = 1:3, .combine = "c") %dopar% sqrt(i); x
x <- foreach(i = 1:3, .combine = "cbind") %dopar% sqrt(i); x
x <- foreach(i = 1:3, .combine = "rbind") %dopar% sqrt(i); x

x <- foreach(i = 1:3, .combine = "+") %dopar% sqrt(i); x
x <- foreach(i = 1:3, .combine = "*") %dopar% sqrt(i); x

userFun <- function(a, b) NULL
x <- foreach(i = 1:3, .combine = userFun) %dopar% sqrt(i); x

##############################
## Just like a for loop
##############################

x <- foreach(seed=1:5, .combine = "rbind") %dopar% {
	set.seed(seed)
	a <- rnorm(10)
	b <- rnorm(10)
	c(a, b)
}

##############################
# Test its performance
##############################
library(MASS)

dim = 100
n = 200
A <- diag(1, dim)
S <- 0.6^abs(row(A) - col(A))

################################
time0 <- proc.time()
mvn <- foreach(seed = 1:n, .combine = "rbind", .packages = "MASS") %dopar% {
	set.seed(seed)
	mvrnorm(1, rep(0, dim), S)
}
proc.time() - time0

################################
time0 <- proc.time()
mvn <- rbind()
for(seed in 1:n){
	set.seed(seed)
	mvn <- rbind(mvn, mvrnorm(1, rep(0, dim), S))
}
proc.time() - time0


################################
#### Application: LooCV ###
################################

bootcampdata <- read.csv("/Users/dqchuwh/Documents/Penn_State/Summer 2014/IGERT Bootcamp/workshop.csv", header = T)
bootcampdata1<-na.omit(bootcampdata)

agec50D10 <-(Age-50)/10
Educ12D4 <- (EDU - 12)/4
REG2 <- lm(AGREE ~ agec50D10 + Educ12D4 + nchild)

AGREE <- bootcampdata1[,"AGREE"]
nchild <- bootcampdata1[,"nchild"]

time0 <- proc.time()
result <- foreach(i=1:nrow(bootcampdata1), .combine = "c") %dopar% {
	Y <- AGREE[-i]
	X1 <- agec50D10[-i]
	X2 <- Educ12D4[-i]
	X3 <- nchild[-i]
	REG <- lm(Y ~ X1 + X2 + X3)
	new <- data.frame(X1 = agec50D10[i], X2 = Educ12D4[i], X3 =nchild[i])
	predict(object = REG, newdata = new)
}
proc.time() - time0


time0 <- proc.time()
result <- c()
for(i in 1:nrow(bootcampdata1)){
	Y <- AGREE[-i]
	X1 <- agec50D10[-i]
	X2 <- Educ12D4[-i]
	X3 <- nchild[-i]
	REG <- lm(Y ~ X1 + X2 + X3)
	new <- data.frame(X1 = agec50D10[i], X2 = Educ12D4[i], X3 =nchild[i])
	result[i] <- predict(object = REG, newdata = new)
}
proc.time() - time0


