# http://theanalysisofdata.com/probability/3_5.html

theta = 0.5
x = 0:50
D = stack(list(`$r=1$` = dnbinom(x, 1, theta), 
               `$r=35$` = dnbinom(x,35, theta), 
               `$r=8$` = dnbinom(x, 8, theta)))
names(D) = c("mass", "r")
D$x = x
qplot(x, mass, data = D, geom = "point", stat = "identity",
      facets = r ~ ., xlab = "$x$", ylab = "$p_X(x)$",
      main = "Negative binomial pmf ($\\theta=0.5$)") +
  geom_linerange(aes(x = x, ymin = 0, ymax = mass))

# Good initial r = ppg