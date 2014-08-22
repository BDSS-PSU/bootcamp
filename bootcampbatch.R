#bootcampbatch.R

x <- 1:100
y <- x^2

deep.data <- data.frame(x,y)

save(deep.data, file = "bootcampRoutput.Rdata")
