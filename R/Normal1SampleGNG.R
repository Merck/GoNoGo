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
#'{Mean of single population with normal endpoint}
#'
#' @param n.t Sample size in treatment arm
#' @param mu.t True mean of the treatment arm
#' @param sd.t True standard deviation of the treatment arm
#' @param hypothesis "greater than", "less than", "between"
#' @param threshold Target region cut-off
#' @param PP.cutoffGo Cut-off for probability of Go
#' @param PP.cutoffNoGo Cut-off for probability of No-Go
#' @param prior "informative" or "non-informative"
#' @param mu0t Prior mean for treatment hyper-parameter if prior = "informative"
#' @param nu0t Prior sample size for treatment hyper-parameter if prior = "informative"
#' @param kappa0t Prior degrees of freedom treatment for hyper-parameter if prior = "informative"
#' @param var0t Prior variance for treatment hyper-parameter if prior = "informative"
#' @param nsim Number of simulated data sets
#' @param reps Number of repetition for samples from the posterior using simulation
#' @return Inputs, Probability of Go, and Probability of No-Go
#' @export
#'
#' @examples Normal1SampleGNG(n.t = 8, mu.t = 40, sd.t = 15, threshold = 35) if prior = "non-informative"
#' @examples Normal1SampleGNG(n.t = 8, mu.t = 40, sd.t = 15, threshold = 35, prior = "informative", mu0t = 45, nu0t = 4, kappa0t = 7, var0t = 1) if prior = "informative"


Normal1SampleGNG = function(n.t, mu.t, sd.t, hypothesis = "greater than", threshold,
                            PP.cutoffGo = 0.60, PP.cutoffNoGo  = 0.60,
                            prior = "non-informative", mu0t, nu0t, kappa0t, var0t,
                            nsim = 10000, reps = 10000){

  if (!requireNamespace("metRology", quietly = TRUE)){
    warning("Please install package 'metRology'")
    return("Please install package 'metRology' ")
  }else{
    pp = rep(NA, nsim)
    valGo = rep(NA, nsim)
    valNoGo = rep(NA, nsim)

    start.time = Sys.time()
    for(i in 1:nsim){

      if(i %% 10000==0) {
        # Print on the screen some message
        cat(paste0("Iteration: ", i, "\n"))
      }

      # Data generation
      data.gen = rnorm(n.t, mu.t, sd.t)
      # Sample mean
      sampmean.t = mean(data.gen)
      # Sample variance
      sampvar.t = var(data.gen)

      ################################
      # Generate mean from posterior #
      ################################

      if(prior == "non-informative"){

        ########################
        # NONINFORMATIVE PRIOR #
        ########################

        # Generate variances from posterior
        # (see appendix in Gelman et al. for scaled inverse chi square generation)
        sigma2 = rchisq(reps, (n.t-1), ncp = 0)
        sigma2.1 = ((n.t-1)*sampvar.t)/sigma2

        prior.mu = sampmean.t
        prior.sd = sqrt(sigma2.1/n.t)
        prior.df = n.t

      }else if(prior == "informative"){

        #####################
        # INFORMATIVE PRIOR #
        #####################

        var1 = (1/(nu0t + n.t))*(nu0t*var0t + (n.t-1)*sampvar.t + (kappa0t*n.t/(kappa0t + n.t))*(sampmean.t - mu0t)^2)

        prior.mu = (kappa0t*mu0t + n.t*sampmean.t)/(kappa0t + n.t)
        prior.sd = sqrt(var1/(kappa0t + n.t))
        prior.df = nu0t + n.t
      }

      mu1 = rnorm(reps, prior.mu, prior.sd)

      ###################################
      # Calculate posterior probability #
      ###################################

      if(hypothesis == "greater than"){
        pp[i] = sum(as.numeric(mu1 >= threshold))/reps
      }else if(hypothesis == "less than"){
        pp[i] = sum(as.numeric(mu1 <= threshold))/reps
      }else if(hypothesis == "between" & threshold[1] < threshold[2]){
        pp[i] = sum(as.numeric(threshold[1] <= mu1 & mu1 <= threshold[2]))/reps
      }else{
        print("Please check the threshold")
      }


      valGo[i] = sum(pp[i] >= PP.cutoffGo)
      valNoGo[i] = sum(pp[i] < PP.cutoffNoGo)
    }


    probGo = (sum(valGo)/nsim)*100
    probNoGo = (sum(valNoGo)/nsim)*100

    threshold.val  = ifelse(length(threshold) == 1, threshold, paste("(", threshold[1], ",", threshold[2], ")") )
    threshold = threshold.val


    end.time =  Sys.time() - start.time

    if(prior == "informative"){
      mu0t = mu0t
      nu0t = nu0t
      kappa0t = kappa0t
      var0t = var0t
    }else if(prior == "non-informative"){
      mu0t = NA
      nu0t = NA
      kappa0t = NA
      var0t = NA
    }

    if(prior == "informative"){
      pos = list(n.t = n.t,
                 mu.t = mu.t,
                 sd.t = sd.t,
                 threshold = threshold,
                 PP.cutoffGo = PP.cutoffGo,
                 PP.cutoffNoGo = PP.cutoffNoGo,
                 hypothesis = hypothesis,
                 prior = prior,
                 mu0t = mu0t,
                 nu0t = nu0t,
                 kappa0t = kappa0t,
                 var0t = var0t,
                 nsim = nsim,
                 reps = reps,
                 time = end.time,
                 probGo = probGo,
                 probNoGo = probNoGo)
    }else if(prior == "non-informative"){
      pos = list(n.t = n.t,
                 mu.t = mu.t,
                 sd.t = sd.t,
                 threshold = threshold,
                 PP.cutoffGo = PP.cutoffGo,
                 PP.cutoffNoGo = PP.cutoffNoGo,
                 hypothesis = hypothesis,
                 prior = prior,
                 nsim = nsim,
                 reps = reps,
                 time = end.time,
                 probGo = probGo,
                 probNoGo = probNoGo)
    }

    return(list(pos = pos, pp = pp))
  }
}
