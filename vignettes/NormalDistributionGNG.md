---
  title: "Bayesian Go/No-Go: Normal Distribution"
author: "Erina Paul"
output:
  pdf_document:
  keep_md: yes
number_sections: yes
toc: yes
toc_depth: 4
highlight: null
---

  <!-- README.md is generated from README.Rmd. Please edit that file -->



  # GoNoGo

  <!-- badges: start -->
  <!-- badges: end -->

  This `R` code implements Bayesian Go/No-Go decision for given model assumptions. It includes the normal mean, normal mean differences, and normal mean ratio with informative and non-informative priors. For technical details, see the `Details` section of this documentation.

## Dependencies
`GoNoGo` requires the following `R` package: `devtools` (for installation only). Please install it before installing `GoNoGo`, which can be done as follows (execute from within a fresh `R` session):

  ``` r
install.packages("devtools")
library(devtools)
```

## Installation

Once the dependencies are installed, `GoNoGo` can be loaded using the following command:

  ``` r
devtools::install_github("Merck/GoNoGo")
library(GoNoGo)
```

## Usage

In this description, we discuss

* Mean of single population with normal endpoint: Normal1SampleGNG(n.t, mu.t, sd.t, hypothesis, threshold, PP.cutoffGo, PP.cutoffNoGo, prior, mu0t, nu0t, kappa0t, var0t, nsim, reps)
* Difference of means of two independent population with normal endpoint: Normal2SampleDiffGNG(n.t, n.c, mu.t, mu.c, sd.t, sd.c, hypothesis, threshold, PP.cutoffGo, PP.cutoffNoGo, prior, mu0t, nu0t, kappa0t, var0t, mu0c, nu0c, kappa0c, var0c, nsim, reps)
* Ratio of means of two independent population with normal endpoint: Normal2SampleRatioGNG(n.t, n.c, mu.t, mu.c, sd.t, sd.c, hypothesis, threshold, PP.cutoffGo, PP.cutoffNoGo, prior, mu0t, nu0t, kappa0t, var0t, mu0c, nu0c, kappa0c, var0c, nsim, reps)

## Input

For mean of single population with normal endpoint, the inputs are:

  * n.t: Sample size in treatment arm.
* mu.t: True mean of the treatment arm.
* sd.t: True sd of the treatment arm.
* hypothesis: "greater than" (default: (PP(true mean>=k)>= c1 vs. PP(true mean>=k)< c2);
                              "less than": (PP(true mean<=k)>= c1 vs. PP(true mean<=k)< c2);
                              "between": (PP(k1<=true mean<=k2)>= c1 vs. PP(k1<=true mean<=k2)< c2).
                              * threshold: Target region cut-off; k is scaler for "greater than" and "less than" hypotheses; k is a vector of k1 and k2 for "between" hypothesis.
                              * PP.cutoffGo: Cut-off for probability of Go; Default is 0.60.
                              * PP.cutoffNoGo: Cut-off for probability of No-Go; Default is 0.60.
                              * prior: Prior choices: "non-informative" (Default), "informative".
                              * mu0t: Prior mean for treatment hyper-parameter if prior = "informative".
                              * nu0t: Prior sample size for treatment hyper-parameter if prior = "informative".
                              * kappa0t: Prior degrees of freedom for treatment hyper-parameter if prior = "informative".
                              * var0t: Prior variance for treatment hyper-parameter if prior = "informative".
                              * nsim: Number of simulated data sets; Default is 10000.
                              * reps: Number of repetition for samples from the posterior using simulation; Default is 10000.

                              In addition to the previous input variables, the calculation for difference or ratio of means of two independent population with normal endpoint includes

                              * n.c: Sample size in control arm.
                              * mu.c: True mean of the control arm.
                              * sd.c: True sd of the control arm.
                              * mu0c: Prior mean for control hyper-parameter if prior = "informative".
                              * nu0c: Sample size for control hyper-parameter if prior = "informative".
                              * kappa0c: Degrees of freedom for control hyper-parameter if prior = "informative".
                              * var0c: Prior variance for control hyper-parameter if prior = "informative".

                              ## Output

                              A list containing the following components is returned:

                                * pos
                              + Input variables
                              + probGo: Probability of Go
                              + probNoGo: Probability of No-Go
                              * pp: Posterior probabilities

                              ## Details

                              To calculate the posterior probabilities with probabilities of Go and No-Go, the code follows the steps as below:

                                * Generate $n.t$ data from Normal($mu.t, sd.t^2$)
                              * Calculate sample mean $(\bar{y})$ and sample variance $(s_y^2)$
                                * Then draw samples from the posterior distribution using simulation
                              + Generate variances from posterior
                              - Non-informative prior (See Appendix in Gelman et al. for scaled inverse chi square generation)
                              * $s^2 \sim \chi^2(df = (n.t-1), ncp = 0)$
                                * $\sigma^2 = \frac{(n.t-1)*s_y^2}{s^2}$
                                * $prior.mu = \bar{y}$
                                * $prior.sd = \sqrt\frac{\sigma^2}{n.t}$
                                * $prior.df = n.t$
                                - Informative prior
                              * $\mu_{0t}, \nu_{0t}, \kappa_{0t}, var0t$: Prior mean, sample size, degrees of freedom, variance for hyper-parameter
                              * $var1 = (\frac{1}{(\nu_{0t} + n.t)}*(\nu_{0t}*var{0t} + (n.t-1)*s_y^2 + (\frac{\kappa_{0t}*n.t}{\kappa_{0t} + n.t}*(\bar{y} - \mu_{0t})^2)$
                                                                       * $prior.mu = \frac{\kappa_{0t}*\mu_{0t} + n.t*\bar{y}}{\kappa_{0t} + n.t}$
                                                                       * $prior.sd = \sqrt\frac{var1}{\kappa_{0t} + n.t}$
                                                                       * $prior.df = \nu_{0t} + n.t$
                                                                       + Generate mean from posterior using normal distribution with mean = prior.mu and sd = prior.sd
                                                                     * Calculate the posterior probabilities
                                                                     * Now, based on `nsim` iterations, calculate the probabilities of Go and No-Go using the pre-defined posterior probability cut-offs.

                                                                     For difference and ratio of means of two independent population with normal endpoint, we have used the same formulation for control arm and calculated posterior probability using mean difference or mean ratio or treatment versus control arm followed by calculating the probabilities of Go and No-Go using the pre-defined posterior probability cut-offs based on `nsim` iterations.

                                                                     # Illustration of `GoNoGo`

                                                                     In this document, we describe the following

                                                                     * Mean of single population with normal endpoint using non-informative prior with hypothesis = "between"
                                                                     * Mean of single population with normal endpoint using informative prior with hypothesis = "between"
                                                                     * Difference of means of two independent population with normal endpoint using non-informative prior with hypothesis = "less than"
                                                                     * Difference of means of two independent population with normal endpoint using informative prior with hypothesis = "less than"
                                                                     * Ratio of means of two independent population with normal endpoint using non-informative prior with hypothesis = "greater than"
                                                                     * Ratio of means of two independent population with normal endpoint using informative prior with hypothesis = "greater than"


                                                                     ## Mean of single population with normal endpoint using non-informative prior with hypothesis = "between"

                                                                     This is a basic example which shows how to solve the single mean with normal endpoint and non-informative prior.


                                                                     ```r
                                                                     ##################
                                                                     # Load libraries #
                                                                     ##################

                                                                     library(GoNoGo)
                                                                     library(ggplot2)
                                                                     library(gridExtra)
                                                                     library(grid)
                                                                     ```


                                                                     ```r
                                                                     #################
                                                                     # Assign inputs #
                                                                     #################

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
                                                                     ```

                                                                     Let's apply normal with single mean and calculate the probabilities of Go and No-Go. Just to note that if the hypothesis is `between`, use this format for threshold, e.g.,  `matrix(rep(c(35, 45), 9), ncol = 2)` and in the `Normal1SampleGNG` function use  `threshold = threshold[i,]`. Whereas, if the hypothesis is `greater than` or `less than`, use this format for threshold, e.g.,  `rep(45, 9)` and in the `Normal1SampleGNG` function use  `threshold = threshold[i]`.


```r
###################################
# Normal-noninformative: 1 sample #
###################################

set.seed(1234)
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
#>   n.t mu.t sd.t   threshold PP.cutoffGo PP.cutoffNoGo hypothesis
#> 1   8   40   15 ( 35 , 45 )         0.6           0.6    between
#> 2   8   40   15 ( 35 , 45 )         0.7           0.7    between
#> 3   8   40   15 ( 35 , 45 )         0.8           0.8    between
#> 4   8   45   15 ( 35 , 45 )         0.6           0.6    between
#> 5   8   45   15 ( 35 , 45 )         0.7           0.7    between
#> 6   8   45   15 ( 35 , 45 )         0.8           0.8    between
#> 7   8   50   15 ( 35 , 45 )         0.6           0.6    between
#> 8   8   50   15 ( 35 , 45 )         0.7           0.7    between
#> 9   8   50   15 ( 35 , 45 )         0.8           0.8    between
#>             prior nsim reps      time probGo probNoGo
#> 1 non-informative 1000 1000 0.5737128   28.0     72.0
#> 2 non-informative 1000 1000  0.515099   10.9     89.1
#> 3 non-informative 1000 1000  0.707485    3.1     96.9
#> 4 non-informative 1000 1000 0.7467229   19.4     80.6
#> 5 non-informative 1000 1000 0.7568791    8.2     91.8
#> 6 non-informative 1000 1000 0.5558679    2.0     98.0
#> 7 non-informative 1000 1000 0.5498002    5.7     94.3
#> 8 non-informative 1000 1000 0.5042839    1.9     98.1
#> 9 non-informative 1000 1000  0.447772    0.7     99.3
```

Now, let's get the output for different scenarios using two visualizations: (1) by true means with different posterior probability cut-offs for Go decision using bars; (2) by posterior probability cut-offs for Go decision with different true means using bars.


```r
p1 = GNGplot(data = data, x.var = data$mu.t,
             fill.var = data$PP.cutoffGo,
             hypothesis = data$hypothesis,
             x.lab = "mu.t",
             title.text =  paste("PP(True mean is", hypothesis,
                                 "threshold) >= PP cutoff"),
             legend.title.text = "PP.cutoffGo")

p2 = GNGplot(data = data, x.var = data$PP.cutoffGo,
             fill.var = data$mu.t,
             hypothesis = data$hypothesis,
             x.lab = "PP.cutoffGo",
             title.text =  paste("PP(True mean is", hypothesis,
                                 "threshold) >= PP cutoff"),
             legend.title.text = "mu.t" )

grid.arrange(p1, p2, nrow = 1)
```



\begin{center}\includegraphics[width=0.9\linewidth]{man/figures/README-normal1NIplot1-1} \end{center}


## Mean of single population with normal endpoint using informative prior with hypothesis = "between"

This example shows how to solve the single mean with normal endpoint and informative prior:


  ```r
#################
# Assign inputs #
#################

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
```

Let's apply normal with single mean and calculate the probabilities of Go and No-Go for informative prior.


```r
################################
# Normal-informative: 1 sample #
################################

set.seed(1234)
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
#>   n.t mu.t sd.t   threshold PP.cutoffGo PP.cutoffNoGo hypothesis       prior
#> 1   8   40   15 ( 35 , 45 )         0.6           0.6    between informative
#> 2   8   40   15 ( 35 , 45 )         0.7           0.7    between informative
#> 3   8   40   15 ( 35 , 45 )         0.8           0.8    between informative
#> 4   8   45   15 ( 35 , 45 )         0.6           0.6    between informative
#> 5   8   45   15 ( 35 , 45 )         0.7           0.7    between informative
#> 6   8   45   15 ( 35 , 45 )         0.8           0.8    between informative
#> 7   8   50   15 ( 35 , 45 )         0.6           0.6    between informative
#> 8   8   50   15 ( 35 , 45 )         0.7           0.7    between informative
#> 9   8   50   15 ( 35 , 45 )         0.8           0.8    between informative
#>   mu0t nu0t kappa0t var0t nsim reps      time probGo probNoGo
#> 1   35    7       4     1 1000 1000 0.2470689   72.4     27.6
#> 2   35    7       4     1 1000 1000 0.2579141   61.0     39.0
#> 3   35    7       4     1 1000 1000    0.2591   40.8     59.2
#> 4   35    7       4     1 1000 1000 0.2579601   71.4     28.6
#> 5   35    7       4     1 1000 1000 0.2340789   58.3     41.7
#> 6   35    7       4     1 1000 1000 0.2378461   38.8     61.2
#> 7   35    7       4     1 1000 1000 0.2826409   40.2     59.8
#> 8   35    7       4     1 1000 1000 0.2269499   26.7     73.3
#> 9   35    7       4     1 1000 1000 0.2499201   19.0     81.0
```

Now, let's get the output for different scenarios using two visualizations: (1) by true means with different posterior probability cut-offs for Go decision using bars; (2) by posterior probability cut-offs for Go decision with different true means using bars.


```r
p1 = GNGplot(data = data, x.var = data$mu.t,
             fill.var = data$PP.cutoffGo,
             hypothesis = data$hypothesis,
             x.lab = "mu.t",
             title.text =  paste("PP(True mean is", hypothesis,
                                 "threshold) >= PP cutoff"),
             legend.title.text = "PP.cutoffGo")

p2 = GNGplot(data = data, x.var = data$PP.cutoffGo,
             fill.var = data$mu.t,
             hypothesis = data$hypothesis,
             x.lab = "PP.cutoffGo",
             title.text =  paste("PP(True mean is", hypothesis,
                                 "threshold) >= PP cutoff"),
             legend.title.text = "mu.t" )

grid.arrange(p1, p2, nrow = 1)
```



\begin{center}\includegraphics[width=0.9\linewidth]{man/figures/README-normal1Iplot1-1} \end{center}


## Difference of means of two independent population with normal endpoint using non-informative prior with hypothesis = "less than"

This example shows how to solve the difference of means of two independent population with normal endpoint using non-informative prior.


```r
#################
# Assign inputs #
#################

n.t = rep(9, 9) # Sample size in treatment arm
mu.t = rep(70, each = 9) # True mean of the treatment arm
sd.t = rep(10, 9) # True sd of the treatment arm
n.c = rep(3, 9) # Sample size in control arm
mu.c = rep(c(40, 45, 50), each = 3) # True mean of the control arm
sd.c = rep(15, 9) # True sd of the control arm
measure = "difference" # "difference" or "ratio" of normal means
hypothesis = "less than" # "greater than", "less than", "between"
threshold = rep(30, 9) # k: Target region cut-off
PP.cutoffGo = rep(c(0.6, 0.7, 0.8), 3) # c1: Cut-off for probability of Go
PP.cutoffNoGo = rep(c(0.6, 0.7, 0.8), 3) # c2: Cut-off for probability of No-Go
prior = "non-informative" # Prior choice
reps = 1000 # Number of repetitions for samples from the posterior using simulation
nsim = 1000 # Number of simulations
```

Let's apply normal mean difference and calculate the probabilities of Go and No-Go.


```r
##############################################
# Normal-noninformative: 2 sample difference #
##############################################

set.seed(1234)
pos.val = vector("list", length(n.t))
for(i in 1:length(n.t)){
  pos.val[[i]] = Normal2SampleGNG(n.t = n.t[i], mu.t = mu.t[i], sd.t = sd.t[i],
                                  n.c = n.c[i], mu.c = mu.c[i], sd.c = sd.c[i],
                                  measure = "difference",
                                  hypothesis = hypothesis, threshold = threshold[i],
                                  prior = prior, PP.cutoffGo = PP.cutoffGo[i],
                                  PP.cutoffNoGo = PP.cutoffNoGo[i],
                                  nsim = nsim, reps = reps)$pos
}
data = dataoutput(pos.val = pos.val)
data$mu.c = unlist(data$mu.c)
data$PP.cutoffGo = unlist(data$ PP.cutoffGo)

data$mu.c = as.factor(data$mu.c)
data$PP.cutoffGo = as.factor(data$ PP.cutoffGo)

data
#>   n.t mu.t sd.t n.c mu.c sd.c    measure threshold PP.cutoffGo PP.cutoffNoGo
#> 1   9   70   10   3   40   15 difference        30         0.6           0.6
#> 2   9   70   10   3   40   15 difference        30         0.7           0.7
#> 3   9   70   10   3   40   15 difference        30         0.8           0.8
#> 4   9   70   10   3   45   15 difference        30         0.6           0.6
#> 5   9   70   10   3   45   15 difference        30         0.7           0.7
#> 6   9   70   10   3   45   15 difference        30         0.8           0.8
#> 7   9   70   10   3   50   15 difference        30         0.6           0.6
#> 8   9   70   10   3   50   15 difference        30         0.7           0.7
#> 9   9   70   10   3   50   15 difference        30         0.8           0.8
#>   hypothesis           prior nsim reps      time probGo probNoGo
#> 1  less than non-informative 1000 1000  1.024278   40.2     59.8
#> 2  less than non-informative 1000 1000 0.9634361   29.4     70.6
#> 3  less than non-informative 1000 1000 0.9482031   17.1     82.9
#> 4  less than non-informative 1000 1000  1.003273   60.9     39.1
#> 5  less than non-informative 1000 1000 0.8237021   49.6     50.4
#> 6  less than non-informative 1000 1000 0.7823019   34.8     65.2
#> 7  less than non-informative 1000 1000  0.761503   78.5     21.5
#> 8  less than non-informative 1000 1000 0.7767742   68.9     31.1
#> 9  less than non-informative 1000 1000 0.6989319   54.5     45.5
```

Let's check two visualizations: (1) by true means with different posterior probability cut-offs for Go decision using bars; (2) by posterior probability cut-offs for Go decision with different true means using bars.


```r
p1 = GNGplot(data = data, x.var = data$mu.c,
             fill.var = data$PP.cutoffGo,
             hypothesis = data$hypothesis,
             x.lab = "mu.c",
             title.text =  paste("PP(True mean is", hypothesis,
                                 "threshold) >= PP cutoff"),
             legend.title.text = "PP.cutoffGo")

p2 = GNGplot(data = data, x.var = data$PP.cutoffGo,
             fill.var =  data$mu.c,
             hypothesis = data$hypothesis,
             x.lab = "mu.c",
             title.text =  paste("PP(True mean is", hypothesis,
                                 "threshold) >= PP cutoff"),
             legend.title.text = "PP.cutoffGo")

grid.arrange(p1, p2, nrow = 1)
```



\begin{center}\includegraphics[width=0.9\linewidth]{man/figures/README-normal2diffNIplot1-1} \end{center}


## Difference of means of two independent population with normal endpoint using informative prior with hypothesis = "less than"

This example shows how to solve the difference of means of two independent population with normal endpoint and informative prior:


  ```r
#################
# Assign inputs #
#################

n.t = rep(9, 9) # Sample size in treatment arm
mu.t = rep(70, each = 9) # True mean of the treatment arm
sd.t = rep(10, 9) # True sd of the treatment arm
n.c = rep(3, 9) # Sample size in control arm
mu.c = rep(c(40, 45, 50), each = 3) # True mean of the control arm
sd.c = rep(15, 9) # True sd of the control arm
measure = "difference" # "difference" or "ratio" of normal means
hypothesis = "less than" # "greater than", "less than", "between"
threshold = rep(30, 9) # k: Target region cut-off
PP.cutoffGo = rep(c(0.6, 0.7, 0.8), 3) # c1: Cut-off for probability of Go
PP.cutoffNoGo = rep(c(0.6, 0.7, 0.8), 3) # c2: Cut-off for probability of No-Go
prior = "informative" # Prior choice
mu0t = 70 # Prior mean for treatment hyper-parameter
nu0t = 7 # Prior sample size for treatment hyper-parameter
kappa0t = 4 # Prior DF for treatment hyper-parameter
var0t = 1  # Prior variance for treatment hyper-parameter
mu0c = 40 # Prior mean for control hyper-parameter
nu0c = 2 # Prior sample size for control hyper-parameter
kappa0c = 2 # Prior DF for control hyper-parameter
var0c = 1  # Prior variance for control hyper-parameter
reps = 1000 # Number of repetitions for samples from the posterior using simulation
nsim = 1000 # Number of simulations
```

Let's apply normal with mean difference and calculate the probabilities of Go and No-Go for informative prior.


```r
###########################################
# Normal-informative: 2 sample difference #
###########################################

set.seed(1234)
pos.val = vector("list", length(n.t))
for(i in 1:length(n.t)){
  pos.val[[i]] = Normal2SampleGNG(n.t = n.t[i], mu.t = mu.t[i], sd.t = sd.t[i],
                                  n.c = n.c[i], mu.c = mu.c[i], sd.c = sd.c[i],
                                  measure = "difference",
                                  hypothesis = hypothesis, threshold = threshold[i],
                                  PP.cutoffGo = PP.cutoffGo[i],
                                  PP.cutoffNoGo = PP.cutoffNoGo[i],
                                  prior = prior, mu0t = mu0t, nu0t = nu0t,
                                  kappa0t = kappa0t, var0t = var0t,
                                  mu0c = mu0c, nu0c = nu0c,
                                  kappa0c = kappa0c, var0c = var0c,
                                  nsim = nsim, reps = reps)$pos
}
data = dataoutput(pos.val = pos.val)
data$mu.c = unlist(data$mu.c)
data$PP.cutoffGo = unlist(data$ PP.cutoffGo)

data$mu.c = as.factor(data$mu.c)
data$PP.cutoffGo = as.factor(data$ PP.cutoffGo)

data
#>   n.t mu.t sd.t n.c mu.c sd.c    measure threshold PP.cutoffGo PP.cutoffNoGo
#> 1   9   70   10   3   40   15 difference        30         0.6           0.6
#> 2   9   70   10   3   40   15 difference        30         0.7           0.7
#> 3   9   70   10   3   40   15 difference        30         0.8           0.8
#> 4   9   70   10   3   45   15 difference        30         0.6           0.6
#> 5   9   70   10   3   45   15 difference        30         0.7           0.7
#> 6   9   70   10   3   45   15 difference        30         0.8           0.8
#> 7   9   70   10   3   50   15 difference        30         0.6           0.6
#> 8   9   70   10   3   50   15 difference        30         0.7           0.7
#> 9   9   70   10   3   50   15 difference        30         0.8           0.8
#>   hypothesis       prior mu0t nu0t kappa0t var0t mu0c nu0c kappa0c var0c nsim
#> 1  less than informative   70    7       4     1   40    2       2     1 1000
#> 2  less than informative   70    7       4     1   40    2       2     1 1000
#> 3  less than informative   70    7       4     1   40    2       2     1 1000
#> 4  less than informative   70    7       4     1   40    2       2     1 1000
#> 5  less than informative   70    7       4     1   40    2       2     1 1000
#> 6  less than informative   70    7       4     1   40    2       2     1 1000
#> 7  less than informative   70    7       4     1   40    2       2     1 1000
#> 8  less than informative   70    7       4     1   40    2       2     1 1000
#> 9  less than informative   70    7       4     1   40    2       2     1 1000
#>   reps      time probGo probNoGo
#> 1 1000 0.3582282   40.7     59.3
#> 2 1000 0.3621268   37.9     62.1
#> 3 1000  0.347815   27.1     72.9
#> 4 1000  0.345546   63.4     36.6
#> 5 1000  0.403039   56.3     43.7
#> 6 1000 0.3341799   43.9     56.1
#> 7 1000 0.3115141   82.5     17.5
#> 8 1000 0.2843568   74.0     26.0
#> 9 1000  0.270787   64.8     35.2
```

Let's check two visualizations: (1) by true means with different posterior probability cut-offs for Go decision using bars; (2) by posterior probability cut-offs for Go decision with different true means using bars.


```r
p1 = GNGplot(data = data, x.var = data$mu.c,
             fill.var = data$PP.cutoffGo,
             hypothesis = data$hypothesis,
             x.lab = "mu.c",
             title.text =  paste("PP(True mean is", hypothesis,
                                 "threshold) >= PP cutoff"),
             legend.title.text = "PP.cutoffGo")

p2 = GNGplot(data = data, x.var = data$PP.cutoffGo,
             fill.var =  data$mu.c,
             hypothesis = data$hypothesis,
             x.lab = "mu.c",
             title.text =  paste("PP(True mean is", hypothesis,
                                 "threshold) >= PP cutoff"),
             legend.title.text = "PP.cutoffGo")

grid.arrange(p1, p2, nrow = 1)
```



\begin{center}\includegraphics[width=0.9\linewidth]{man/figures/README-normal2diffIplot1-1} \end{center}


## Ratio of means of two independent population with normal endpoint and non-informative prior with hypothesis = "greater than"

This example shows how to solve the ratio of means of two independent population with normal endpoint and non-informative prior.


```r
#################
# Assign inputs #
#################

n.t = rep(9, 9) # Sample size in treatment arm
mu.t = rep(70, each = 9) # True mean of the treatment arm
sd.t = rep(10, 9) # True sd of the treatment arm
n.c = rep(3, 9) # Sample size in control arm
mu.c = rep(c(40, 45, 50), each = 3) # True mean of the control arm
sd.c = rep(15, 9) # True sd of the control arm
measure = "ratio" # "difference" or "ratio" of normal means
hypothesis = "greater than" # "greater than", "less than", "between"
threshold = rep(1, 9) # k: Target region cut-off
PP.cutoffGo = rep(c(0.6, 0.7, 0.8), 3) # c1: Cut-off for probability of Go
PP.cutoffNoGo = rep(c(0.6, 0.7, 0.8), 3) # c2: Cut-off for probability of No-Go
prior = "non-informative" # Prior choice
reps = 1000 # Number of repetitions for samples from the posterior using simulation
nsim = 1000 # Number of simulations
```

Let's apply normal with two sample mean ratio and calculate the probabilities of Go and No-Go.


```r
#########################################
# Normal-noninformative: 2 sample ratio #
#########################################

set.seed(1234)
pos.val = vector("list", length(n.t))
for(i in 1:length(n.t)){
  pos.val[[i]] = Normal2SampleGNG(n.t = n.t[i], mu.t = mu.t[i], sd.t = sd.t[i],
                                  n.c = n.c[i], mu.c = mu.c[i], sd.c = sd.c[i],
                                  measure = "ratio",
                                  hypothesis = hypothesis, threshold = threshold[i],
                                  prior = prior, PP.cutoffGo = PP.cutoffGo[i],
                                  PP.cutoffNoGo = PP.cutoffNoGo[i],
                                  nsim = nsim, reps = reps)$pos
}
data = dataoutput(pos.val = pos.val)
data$mu.c = unlist(data$mu.c)
data$PP.cutoffGo = unlist(data$ PP.cutoffGo)

data$mu.c = as.factor(data$mu.c)
data$PP.cutoffGo = as.factor(data$ PP.cutoffGo)

data
#>   n.t mu.t sd.t n.c mu.c sd.c measure threshold PP.cutoffGo PP.cutoffNoGo
#> 1   9   70   10   3   40   15   ratio         1         0.6           0.6
#> 2   9   70   10   3   40   15   ratio         1         0.7           0.7
#> 3   9   70   10   3   40   15   ratio         1         0.8           0.8
#> 4   9   70   10   3   45   15   ratio         1         0.6           0.6
#> 5   9   70   10   3   45   15   ratio         1         0.7           0.7
#> 6   9   70   10   3   45   15   ratio         1         0.8           0.8
#> 7   9   70   10   3   50   15   ratio         1         0.6           0.6
#> 8   9   70   10   3   50   15   ratio         1         0.7           0.7
#> 9   9   70   10   3   50   15   ratio         1         0.8           0.8
#>     hypothesis           prior nsim reps      time probGo probNoGo
#> 1 greater than non-informative 1000 1000 0.7978721   99.8      0.2
#> 2 greater than non-informative 1000 1000 0.8939641   99.4      0.6
#> 3 greater than non-informative 1000 1000 0.8164949   95.5      4.5
#> 4 greater than non-informative 1000 1000  1.012688   99.2      0.8
#> 5 greater than non-informative 1000 1000 0.7103839   98.5      1.5
#> 6 greater than non-informative 1000 1000 0.6827219   91.1      8.9
#> 7 greater than non-informative 1000 1000 0.6382771   97.3      2.7
#> 8 greater than non-informative 1000 1000 0.6598461   91.9      8.1
#> 9 greater than non-informative 1000 1000  0.652195   81.6     18.4
```

Let's check two visualizations: (1) by true means with different posterior probability cut-offs for Go decision using bars; (2) by posterior probability cut-offs for Go decision with different true means using bars.


```r
p1 = GNGplot(data = data, x.var = data$mu.c,
             fill.var = data$PP.cutoffGo,
             hypothesis = data$hypothesis,
             x.lab = "mu.c",
             title.text =  paste("PP(True mean is", hypothesis,
                                 "threshold) >= PP cutoff"),
             legend.title.text = "PP.cutoffGo")

p2 = GNGplot(data = data, x.var = data$PP.cutoffGo,
             fill.var =  data$mu.c,
             hypothesis = data$hypothesis,
             x.lab = "mu.c",
             title.text =  paste("PP(True mean is", hypothesis,
                                 "threshold) >= PP cutoff"),
             legend.title.text = "PP.cutoffGo")

grid.arrange(p1, p2, nrow = 1)
```



\begin{center}\includegraphics[width=0.9\linewidth]{man/figures/README-normal2ratioNIplot1-1} \end{center}


## Ratio of means of two independent population with normal endpoint and informative prior with hypothesis = "greater than"

This example shows how to solve the ratio of means of two independent population with normal endpoint and informative prior:


  ```r
#################
# Assign inputs #
#################

n.t = rep(9, 9) # Sample size in treatment arm
mu.t = rep(70, each = 9) # True mean of the treatment arm
sd.t = rep(10, 9) # True sd of the treatment arm
n.c = rep(3, 9) # Sample size in control arm
mu.c = rep(c(40, 45, 50), each = 3) # True mean of the control arm
sd.c = rep(15, 9) # True sd of the control arm
measure = "ratio" # "difference" or "ratio" of normal means
hypothesis = "greater than" # "greater than", "less than", "between"
threshold = rep(1, 9) # k: Target region cut-off
PP.cutoffGo = rep(c(0.6, 0.7, 0.8), 3) # c1: Cut-off for probability of Go
PP.cutoffNoGo = rep(c(0.6, 0.7, 0.8), 3) # c2: Cut-off for probability of No-Go
prior = "informative" # Prior choice
mu0t = 70 # Prior mean for treatment hyper-parameter
nu0t = 5 # Prior mean for treatment hyper-parameter
kappa0t = 8 # Prior DF for treatment hyper-parameter
var0t = 1  # Prior variance for treatment hyper-parameter
mu0c = 45 # Prior mean for control hyper-parameter
nu0c = 2 # Prior mean for control hyper-parameter
kappa0c = 2 # Prior DF for control hyper-parameter
var0c = 1  # Prior variance for control hyper-parameter
reps = 1000 # Number of repetitions for samples from the posterior using simulation
nsim = 1000 # Number of simulations
```

Let's apply normal with mean ratio and calculate the probabilities of Go and No-Go for informative prior.


```r
######################################
# Normal-informative: 2 sample ratio #
######################################

set.seed(1234)
pos.val = vector("list", length(n.t))
for(i in 1:length(n.t)){
  pos.val[[i]] = Normal2SampleGNG(n.t = n.t[i], mu.t = mu.t[i], sd.t = sd.t[i],
                                      n.c = n.c[i], mu.c = mu.c[i], sd.c = sd.c[i],
                                      measure = "ratio",
                                      hypothesis = hypothesis, threshold = threshold[i],
                                      PP.cutoffGo = PP.cutoffGo[i],
                                      PP.cutoffNoGo = PP.cutoffNoGo[i],
                                      prior = prior, mu0t = mu0t, nu0t = nu0t,
                                      kappa0t = kappa0t, var0t = var0t,
                                      mu0c = mu0c, nu0c = nu0c,
                                      kappa0c = kappa0c, var0c = var0c,
                                      nsim = nsim, reps = reps)$pos
}
data = dataoutput(pos.val = pos.val)
data$mu.c = unlist(data$mu.c)
data$PP.cutoffGo = unlist(data$ PP.cutoffGo)

data$mu.c = as.factor(data$mu.c)
data$PP.cutoffGo = as.factor(data$ PP.cutoffGo)

data
#>   n.t mu.t sd.t n.c mu.c sd.c measure threshold PP.cutoffGo PP.cutoffNoGo
#> 1   9   70   10   3   40   15   ratio         1         0.6           0.6
#> 2   9   70   10   3   40   15   ratio         1         0.7           0.7
#> 3   9   70   10   3   40   15   ratio         1         0.8           0.8
#> 4   9   70   10   3   45   15   ratio         1         0.6           0.6
#> 5   9   70   10   3   45   15   ratio         1         0.7           0.7
#> 6   9   70   10   3   45   15   ratio         1         0.8           0.8
#> 7   9   70   10   3   50   15   ratio         1         0.6           0.6
#> 8   9   70   10   3   50   15   ratio         1         0.7           0.7
#> 9   9   70   10   3   50   15   ratio         1         0.8           0.8
#>     hypothesis       prior mu0t nu0t kappa0t var0t mu0c nu0c kappa0c var0c nsim
#> 1 greater than informative   70    5       8     1   45    2       2     1 1000
#> 2 greater than informative   70    5       8     1   45    2       2     1 1000
#> 3 greater than informative   70    5       8     1   45    2       2     1 1000
#> 4 greater than informative   70    5       8     1   45    2       2     1 1000
#> 5 greater than informative   70    5       8     1   45    2       2     1 1000
#> 6 greater than informative   70    5       8     1   45    2       2     1 1000
#> 7 greater than informative   70    5       8     1   45    2       2     1 1000
#> 8 greater than informative   70    5       8     1   45    2       2     1 1000
#> 9 greater than informative   70    5       8     1   45    2       2     1 1000
#>   reps      time probGo probNoGo
#> 1 1000 0.3952849  100.0      0.0
#> 2 1000 0.3640192  100.0      0.0
#> 3 1000 0.3572369  100.0      0.0
#> 4 1000 0.4090312  100.0      0.0
#> 5 1000 0.4753041   99.9      0.1
#> 6 1000 0.3896489  100.0      0.0
#> 7 1000 0.4231491  100.0      0.0
#> 8 1000  0.369935   99.9      0.1
#> 9 1000 0.4039359   99.7      0.3
```

Let's check two visualizations: (1) by true means with different posterior probability cut-offs for Go decision using bars; (2) by posterior probability cut-offs for Go decision with different true means using bars.


```r
p1 = GNGplot(data = data, x.var = data$mu.c,
             fill.var = data$PP.cutoffGo,
             hypothesis = data$hypothesis,
             x.lab = "mu.c",
             title.text =  paste("PP(True mean is", hypothesis,
                                 "threshold) >= PP cutoff"),
             legend.title.text = "PP.cutoffGo")

p2 = GNGplot(data = data, x.var = data$PP.cutoffGo,
             fill.var =  data$mu.c,
             hypothesis = data$hypothesis,
             x.lab = "mu.c",
             title.text =  paste("PP(True mean is", hypothesis,
                                 "threshold) >= PP cutoff"),
             legend.title.text = "PP.cutoffGo")

grid.arrange(p1, p2, nrow = 1)
```



\begin{center}\includegraphics[width=0.9\linewidth]{man/figures/README-normal2ratioIplot1-1} \end{center}
