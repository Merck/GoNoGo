#######################################
# 1 sample - between - Noninformative #
#######################################

n.t = rep(8, 9) # Sample size in treatment arm
mu.t = rep(c(40, 45, 50), each = 3) # True mean of the treatment arm
sd.t = rep(15, 9) # True sd of the treatment arm
hypothesis = "between" # "greater than", "less than", "between"
threshold =  matrix(rep(c(35, 45), each = 9), ncol = 2) # k: Target region cut-off
PP.cutoffGo = rep(c(0.6, 0.7, 0.8), 3) # c1: Cut-off for probability of Go
PP.cutoffNoGo = rep(c(0.6, 0.7, 0.8), 3) # c2: Cut-off for probability of No-Go
prior = "non-informative" # Prior choice
reps = 1000 # Number of repetitions for samples from the posterior using simulation
nsim = 1000 # Number of simulations

set.seed(12345)
pos.val = vector("list", length(n.t))
for(i in 1:length(n.t)){
  pos.val[[i]] = Normal1SampleGNG(n.t = n.t[i], mu.t = mu.t[i], sd.t = sd.t[i],
                                  hypothesis = hypothesis, threshold = threshold[i,],
                                  PP.cutoffGo = PP.cutoffGo[i],
                                  PP.cutoffNoGo = PP.cutoffNoGo[i],
                                  nsim = nsim, reps = reps)$pos
}
data = dataoutput(pos.val = pos.val)
data$mu.t = unlist(data$mu.t)
data$PP.cutoffGo = unlist(data$ PP.cutoffGo)
data$mu.t = as.factor(data$mu.t)
data$PP.cutoffGo = as.factor(data$ PP.cutoffGo)
data


####################################
# 1 sample - between - Informative #
####################################

n.t = rep(8, 9) # Sample size in treatment arm
mu.t = rep(c(40, 45, 50), each = 3) # True mean of the treatment arm
sd.t = rep(15, 9) # True sd of the treatment arm
hypothesis = "between" # "greater than", "less than", "between"
threshold = matrix(rep(c(35, 45), each = 9), ncol = 2) # k: Target region cut-off
PP.cutoffGo = rep(c(0.6, 0.7, 0.8), 3) # c1: Cut-off for probability of Go
PP.cutoffNoGo = rep(c(0.6, 0.7, 0.8), 3) # c2: Cut-off for probability of No-Go
prior = "informative" # Prior choice
mu0t = 35 # Prior mean for treatment hyper-parameter
nu0t = 7 # Prior sample size for treatment hyper-parameter
kappa0t = 4 # Prior DF for treatment hyper-parameter
var0t = 1  # Prior variance for treatment hyper-parameter
reps = 1000 # Number of repetitions for samples from the posterior using simulation
nsim = 1000 # Number of simulations

set.seed(12345)
pos.val = vector("list", length(n.t))
for(i in 1:length(n.t)){
  pos.val[[i]] = Normal1SampleGNG(n.t = n.t[i], mu.t = mu.t[i], sd.t = sd.t[i],
                                  hypothesis = hypothesis, threshold = threshold[i,],
                                  PP.cutoffGo = PP.cutoffGo[i],
                                  PP.cutoffNoGo = PP.cutoffNoGo[i],
                                  prior = prior, mu0t = mu0t, nu0t = nu0t,
                                  kappa0t = kappa0t, var0t = var0t,
                                  nsim = nsim, reps = reps)$pos
}
data = dataoutput(pos.val = pos.val)
data$mu.t = unlist(data$mu.t)
data$PP.cutoffGo = unlist(data$ PP.cutoffGo)
data$mu.t = as.factor(data$mu.t)
data$PP.cutoffGo = as.factor(data$ PP.cutoffGo)
data


############################################
# 1 sample - greater than - Noninformative #
############################################

n.t = rep(8, 9) # Sample size in treatment arm
mu.t = rep(c(40, 45, 50), each = 3) # True mean of the treatment arm
sd.t = rep(15, 9) # True sd of the treatment arm
hypothesis = "greater than" # "greater than", "less than", "between"
threshold =  rep(35, 9) # k: Target region cut-off
PP.cutoffGo = rep(c(0.6, 0.7, 0.8), 3) # c1: Cut-off for probability of Go
PP.cutoffNoGo = rep(c(0.6, 0.7, 0.8), 3) # c2: Cut-off for probability of No-Go
prior = "non-informative" # Prior choice
reps = 1000 # Number of repetitions for samples from the posterior using simulation
nsim = 1000 # Number of simulations

set.seed(12345)
pos.val = vector("list", length(n.t))
for(i in 1:length(n.t)){
  pos.val[[i]] = Normal1SampleGNG(n.t = n.t[i], mu.t = mu.t[i], sd.t = sd.t[i],
                                  hypothesis = hypothesis, threshold = threshold[i],
                                  PP.cutoffGo = PP.cutoffGo[i],
                                  PP.cutoffNoGo = PP.cutoffNoGo[i],
                                  nsim = nsim, reps = reps)$pos
}
data = dataoutput(pos.val = pos.val)
data$mu.t = unlist(data$mu.t)
data$PP.cutoffGo = unlist(data$ PP.cutoffGo)
data$mu.t = as.factor(data$mu.t)
data$PP.cutoffGo = as.factor(data$ PP.cutoffGo)
data


#########################################
# 1 sample - greater than - Informative #
#########################################

n.t = rep(8, 9) # Sample size in treatment arm
mu.t = rep(c(40, 45, 50), each = 3) # True mean of the treatment arm
sd.t = rep(15, 9) # True sd of the treatment arm
hypothesis = "greater than" # "greater than", "less than", "between"
threshold =  rep(35, 9) # k: Target region cut-off
PP.cutoffGo = rep(c(0.6, 0.7, 0.8), 3) # c1: Cut-off for probability of Go
PP.cutoffNoGo = rep(c(0.6, 0.7, 0.8), 3) # c2: Cut-off for probability of No-Go
prior = "informative" # Prior choice
mu0t = 35 # Prior mean for treatment hyper-parameter
nu0t = 7 # Prior sample size for treatment hyper-parameter
kappa0t = 4 # Prior DF for treatment hyper-parameter
var0t = 1  # Prior variance for treatment hyper-parameter
reps = 1000 # Number of repetitions for samples from the posterior using simulation
nsim = 1000 # Number of simulations

set.seed(12345)
pos.val = vector("list", length(n.t))
for(i in 1:length(n.t)){
  pos.val[[i]] = Normal1SampleGNG(n.t = n.t[i], mu.t = mu.t[i], sd.t = sd.t[i],
                                  hypothesis = hypothesis, threshold = threshold[i],
                                  PP.cutoffGo = PP.cutoffGo[i],
                                  PP.cutoffNoGo = PP.cutoffNoGo[i],
                                  prior = prior, mu0t = mu0t, nu0t = nu0t,
                                  kappa0t = kappa0t, var0t = var0t,
                                  nsim = nsim, reps = reps)$pos
}
data = dataoutput(pos.val = pos.val)
data$mu.t = unlist(data$mu.t)
data$PP.cutoffGo = unlist(data$ PP.cutoffGo)
data$mu.t = as.factor(data$mu.t)
data$PP.cutoffGo = as.factor(data$ PP.cutoffGo)
data




#########################################
# 1 sample - less than - Noninformative #
#########################################

n.t = rep(8, 9) # Sample size in treatment arm
mu.t = rep(c(40, 45, 50), each = 3) # True mean of the treatment arm
sd.t = rep(15, 9) # True sd of the treatment arm
hypothesis = "less than" # "greater than", "less than", "between"
threshold =  rep(35, 9) # k: Target region cut-off
PP.cutoffGo = rep(c(0.6, 0.7, 0.8), 3) # c1: Cut-off for probability of Go
PP.cutoffNoGo = rep(c(0.6, 0.7, 0.8), 3) # c2: Cut-off for probability of No-Go
prior = "non-informative" # Prior choice
reps = 1000 # Number of repetitions for samples from the posterior using simulation
nsim = 1000 # Number of simulations

set.seed(12345)
pos.val = vector("list", length(n.t))
for(i in 1:length(n.t)){
  pos.val[[i]] = Normal1SampleGNG(n.t = n.t[i], mu.t = mu.t[i], sd.t = sd.t[i],
                                  hypothesis = hypothesis, threshold = threshold[i],
                                  PP.cutoffGo = PP.cutoffGo[i],
                                  PP.cutoffNoGo = PP.cutoffNoGo[i],
                                  nsim = nsim, reps = reps)$pos
}
data = dataoutput(pos.val = pos.val)
data$mu.t = unlist(data$mu.t)
data$PP.cutoffGo = unlist(data$ PP.cutoffGo)
data$mu.t = as.factor(data$mu.t)
data$PP.cutoffGo = as.factor(data$ PP.cutoffGo)
data


######################################
# 1 sample - less than - Informative #
######################################

n.t = rep(8, 9) # Sample size in treatment arm
mu.t = rep(c(40, 45, 50), each = 3) # True mean of the treatment arm
sd.t = rep(15, 9) # True sd of the treatment arm
hypothesis = "less than" # "greater than", "less than", "between"
threshold =  rep(35, 9) # k: Target region cut-off
PP.cutoffGo = rep(c(0.6, 0.7, 0.8), 3) # c1: Cut-off for probability of Go
PP.cutoffNoGo = rep(c(0.6, 0.7, 0.8), 3) # c2: Cut-off for probability of No-Go
prior = "informative" # Prior choice
mu0t = 35 # Prior mean for treatment hyper-parameter
nu0t = 7 # Prior sample size for treatment hyper-parameter
kappa0t = 4 # Prior DF for treatment hyper-parameter
var0t = 1  # Prior variance for treatment hyper-parameter
reps = 1000 # Number of repetitions for samples from the posterior using simulation
nsim = 1000 # Number of simulations

set.seed(12345)
pos.val = vector("list", length(n.t))
for(i in 1:length(n.t)){
  pos.val[[i]] = Normal1SampleGNG(n.t = n.t[i], mu.t = mu.t[i], sd.t = sd.t[i],
                                  hypothesis = hypothesis, threshold = threshold[i],
                                  PP.cutoffGo = PP.cutoffGo[i],
                                  PP.cutoffNoGo = PP.cutoffNoGo[i],
                                  prior = prior, mu0t = mu0t, nu0t = nu0t,
                                  kappa0t = kappa0t, var0t = var0t,
                                  nsim = nsim, reps = reps)$pos
}
data = dataoutput(pos.val = pos.val)
data$mu.t = unlist(data$mu.t)
data$PP.cutoffGo = unlist(data$ PP.cutoffGo)
data$mu.t = as.factor(data$mu.t)
data$PP.cutoffGo = as.factor(data$ PP.cutoffGo)
data

