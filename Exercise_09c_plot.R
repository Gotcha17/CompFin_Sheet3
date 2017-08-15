n=300
sigma=0.05
K=seq(from = 1, to = n-1)
Dt = c()
Et = c()

path = file.path(getwd(), paste("Exercise_o9c_plot", "png", sep = "."))
#pdf(file = path)
png(filename = path, width = 640, height = 480, units = "px", pointsize = 12,
    bg = "white", res = NA, family = "", restoreConsole = TRUE, type = "windows", antialias = "cleartype")
#setEPS()
#postscript(file = path, horizontal = F)
t=seq(from = 0, to = 1, length.out = n)
X=rnorm(n, mean = 0, sd = t)
Dt[1]=exp(sigma*X[1])
Et[1]=exp(-sigma*X[1])
for (i in K){
Dt[i+1]=Dt[i]*exp(sigma*X[i+1])
Et[i+1]=Et[i]*exp(-sigma*X[i+1])
}
plot(t, Dt, type = "l", ylim = c(0.4,1.6), col = "green", xlab = "t", ylab = "FX Rate", main = paste("For t from 0 to 1, with sigma = ", sigma), lwd = 1)
lines(t, Et, col = "blue", lwd = 1)
box()
dev.off()