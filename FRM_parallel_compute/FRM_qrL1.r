
linear      = function(Qy, Qxx, Qp, Qi, Qj) {
  fit       = qrL1(Qxx, Qy, Qp, 50)
  isnum     = which(fit$Cgacv == min(fit$Cgacv))
  lambda    = (-fit$lambda[isnum])
  print(lambda)
  finalresults = list()
  finalresults$lambda.in = lambda
  return(finalresults)
}
