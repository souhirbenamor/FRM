rm(list = ls())
graphics.off()
# set the working directory setwd('C:/...')

##################### plot one firm's lambda and FRM ####
data = read.csv("FRM_VIX_SRISK_GT.csv")
dt = as.Date(data[, 1], format = "%d/%m/%Y")
FRM = as.matrix(data[, 2])
FRM = (FRM - min(FRM))/(max(FRM) - min(FRM))

# read the lambda series of Wells Farg (WFC) #####
of = read.csv("lambdas_100firms2.csv")[13:2398, 2]
of = (of - min(of))/(max(of) - min(of))
plot(dt, of, col = "grey", type = "l", lwd = 3, xlab = "", ylab = "", cex.axis = 2, 
    font.axis = 2)
lines(dt, FRM, col = "black", lwd = 3)
