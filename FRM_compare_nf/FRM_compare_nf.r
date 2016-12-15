rm(list = ls())
graphics.off()
# set the working directory setwd('C:/...')

##################### plot FRM with 100 firm and 200 firms ############
data = read.csv("FRM_comparison.csv")
FRM200 = as.vector(read.csv("FRM_comparison.csv")[, 3])
FRM100 = as.matrix(read.csv("FRM_comparison.csv")[, 4])
FRM100 = (FRM100 - min(FRM100))/(max(FRM100) - min(FRM100))
FRM200 = (FRM200 - min(FRM200))/(max(FRM200) - min(FRM200))
dt = as.Date(data[, 1], format = "%d/%m/%Y")
plot(dt, FRM100, type = "l", lwd = 3, xlab = "", ylab = "", cex.axis = 2, font.axis = 2)
lines(dt, FRM200, col = "grey", lwd = 3)

##################### correlation of FRM with 100 firm and 200 firms ##
cor(FRM100,FRM200)