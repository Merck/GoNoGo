# GoNoGo - Provide the posterior probability and operating characteristics of
#          Bayesian Go/No-Go decision-making based on specific model assumptions.
#
# Copyright © 2023 Merck & Co., Inc., Rahway, NJ, USA and its affiliates. All rights reserved.
#
# This file is part of GoNoGo.
#
#     GoNoGo is free software: you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation, either version 3 of the License, or
#     (at your option) any later version.
#
#     GoNoGo is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.
#
#     You should have received a copy of the GNU General Public License
#     along with GoNoGo.  If not, see <https://www.gnu.org/licenses/>.
#
#'{Posterior probability: Difference/ratio of means of two independent populations with normal distribution}
#'
#' @param n.t Sample size in treatment arm
#' @param mu.t True mean of the treatment arm
#' @param sd.t True standard deviation of the treatment arm
#' @param n.c Sample size in control arm
#' @param mu.c True mean of the control arm
#' @param sd.c True standard deviation of the control arm
#' @param measure "difference", "ratio"
#' @param hypothesis "greater than", "less than", "between"
#' @param threshold Target region cut-off
#' @param PP.cutoffGo Cut-off for probability of Go
#' @param PP.cutoffNoGo Cut-off for probability of No-Go
#' @param prior "informative" or "non-informative"
#' @param mu0t Prior mean for treatment hyper-parameter if prior = "informative"
#' @param nu0t Prior sample size for treatment hyper-parameter if prior = "informative"
#' @param kappa0t Prior degrees of treatment freedom for hyper-parameter if prior = "informative"
#' @param var0t Prior variance for treatment hyper-parameter if prior = "informative"
#' @param mu0c Prior mean for control hyper-parameter if prior = "informative"
#' @param nu0c Prior sample size for control hyper-parameter if prior = "informative"
#' @param kappa0c Prior degrees of control freedom for hyper-parameter if prior = "informative"
#' @param var0c Prior variance for control hyper-parameter if prior = "informative"
#' @param reps Number of repetition for samples from the posterior using simulation
#' @return Inputs, Probability of Go, and Probability of No-Go
#' @export
#'
#' @examples Normal2SamplePP(n.t = 6, mu.t = 70, sd.t = 15, n.c = 2, mu.c = 40, sd.c = 15, measure = "difference", threshold = 30) if prior = "non-informative"
#' @examples Normal2SamplePP(n.t = 6, mu.t = 70, sd.t = 15, n.c = 2, mu.c = 40, sd.c = 15, measure = "difference", threshold = 30, prior = "informative", mu0t = 70, nu0t = 8, kappa0t = 7, var0t = 1,  mu0c = 40, nu0c = 2, kappa0c = 2, var0c = 1) if prior = "informative"


Normal2SamplePP = function(n.t, mu.t, sd.t, n.c, mu.c, sd.c, measure,
                            hypothesis = "greater than", threshold,
                            PP.cutoffGo = 0.60, PP.cutoffNoGo  = 0.60,
                            prior = "non-informative",
                            mu0t, nu0t, kappa0t, var0t, mu0c, nu0c, kappa0c, var0c,
                           reps = 10000){

  if (!requireNamespace("metRology", quietly = TRUE)){
    warning("Please install package 'metRology'")
    return("Please install package 'metRology' ")
  }else{


    start.time = Sys.time()

    # Sample mean
    sampmean.t = mu.t
    sampmean.c = mu.c
    # Sample variance
    sampvar.t = sd.t^2
    sampvar.c = sd.c^2

    ################################
    # Generate mean from posterior #
    ################################

    if(prior == "non-informative"){

      ########################
      # NONINFORMATIVE PRIOR #
      ########################

      # Generate variances from posterior
      # (see appendix in Gelman et al. for scaled inverse chi square generation)
      sigma2t = rchisq(reps, (n.t-1), ncp = 0)
      sigma2.1t = ((n.t-1)*sampvar.t)/sigma2t

      sigma2c = rchisq(reps, (n.c-1), ncp = 0)
      sigma2.1c = ((n.c-1)*sampvar.c)/sigma2c

      prior.mut = sampmean.t
      prior.sdt = sqrt(sigma2.1t/n.t)
      prior.dft = n.t

      prior.muc = sampmean.c
      prior.sdc = sqrt(sigma2.1c/n.c)
      prior.dfc = n.c

    }else if(prior == "informative"){

      #####################
      # INFORMATIVE PRIOR #
      #####################

      var1t = (1/(nu0t + n.t))*(nu0t*var0t + (n.t-1)*sampvar.t + (kappa0t*n.t/(kappa0t + n.t))*(sampmean.t - mu0t)^2)
      var1c = (1/(nu0c + n.c))*(nu0c*var0c + (n.c-1)*sampvar.c + (kappa0c*n.c/(kappa0c + n.c))*(sampmean.c - mu0c)^2)

      prior.mut = (kappa0t*mu0t + n.t*sampmean.t)/(kappa0t + n.t)
      prior.sdt = sqrt(var1t/(kappa0t + n.t))
      prior.dft = nu0t + n.t

      prior.muc = (kappa0c*mu0c + n.c*sampmean.c)/(kappa0c + n.c)
      prior.sdc = sqrt(var1c/(kappa0c + n.c))
      prior.dfc = nu0c + n.c
    }

    mu1t = rnorm(reps, prior.mut, prior.sdt)
    mu1c = rnorm(reps, prior.muc, prior.sdc)

    if(measure == "difference"){
      mu1 = mu1t - mu1c
    }else if(measure == "ratio"){
      mu1 = mu1t/mu1c
    }else{
      print("Not available")
    }


    ###################################
    # Calculate posterior probability #
    ###################################

    if(hypothesis == "greater than"){
      pp = sum(as.numeric(mu1 >= threshold))/reps
    }else if(hypothesis == "less than"){
      pp = sum(as.numeric(mu1 <= threshold))/reps
    }else if(hypothesis == "between" & threshold[1] < threshold[2]){
      pp = sum(as.numeric(threshold[1] <= mu1 & mu1 <= threshold[2]))/reps
    }else{
      print("Please check the threshold")
    }

    threshold.val  = ifelse(length(threshold) == 1, threshold, paste("(", threshold[1], ",", threshold[2], ")") )
    threshold = threshold.val
    end.time =  Sys.time() - start.time

    if(prior == "informative"){
      mu0t = mu0t
      nu0t = nu0t
      kappa0t = kappa0t
      var0t = var0t
      mu0c = mu0c
      nu0c = nu0c
      kappa0c = kappa0c
      var0c = var0c
    }else if(prior == "non-informative"){
      mu0t = NA
      nu0t = NA
      kappa0t = NA
      var0t = NA
      mu0c = NA
      nu0c = NA
      kappa0c = NA
      var0c = NA
    }

    if(prior == "informative"){
      pos = list(n.t = n.t,
                 mu.t = mu.t,
                 sd.t = sd.t,
                 n.c = n.c,
                 mu.c = mu.c,
                 sd.c = sd.c,
                 measure = measure,
                 threshold = threshold,
                 PP.cutoffGo = PP.cutoffGo,
                 PP.cutoffNoGo = PP.cutoffNoGo,
                 hypothesis = hypothesis,
                 prior = prior,
                 mu0t = mu0t,
                 nu0t = nu0t,
                 kappa0t = kappa0t,
                 var0t = var0t,
                 mu0c = mu0c,
                 nu0c = nu0c,
                 kappa0c = kappa0c,
                 var0c = var0c,
                 reps = reps,
                 time = end.time,
                 pp = pp)
    }else if(prior == "non-informative"){
      pos = list(n.t = n.t,
                 mu.t = mu.t,
                 sd.t = sd.t,
                 n.c = n.c,
                 mu.c = mu.c,
                 sd.c = sd.c,
                 measure = measure,
                 threshold = threshold,
                 PP.cutoffGo = PP.cutoffGo,
                 PP.cutoffNoGo = PP.cutoffNoGo,
                 hypothesis = hypothesis,
                 prior = prior,
                 reps = reps,
                 time = end.time,
                 pp = pp)
    }

    return(pp = pp)
  }
}
