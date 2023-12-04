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
#'{Result output table}
#'
#' @param prob.val Probability success in list format
#' @param output.format "OC" (default): Operating characteristics; "PP": Posterior probability
#' @return Inputs, Results (Probability of Go and Probability of No-Go or Posterior probability)
#' @export
#'

dataoutput = function(prob.val, output.format = "OC"){
  prob.combined = do.call(rbind, prob.val)
  data.output = data.frame(prob.combined)
  data.output$n.t = as.factor(data.output$n.t)
  data.output$mu.t = as.factor(unlist(data.output$mu.t))
  data.output$sd.t = as.factor(unlist(data.output$sd.t))
  data.output$threshold = as.factor(unlist(data.output$threshold))
  data.output$PP.cutoffGo  = as.factor(unlist(data.output$PP.cutoffGo))
  data.output$PP.cutoffNoGo  = as.factor(unlist(data.output$PP.cutoffNoGo))
  if(output.format == "OC"){
    data.output$probGo  = (unlist(data.output$probGo))
    data.output$probNoGo  = (unlist(data.output$probNoGo))
  }else if(output.format == "PP"){
    data.output$pp  = (unlist(data.output$pp))
  }else{
    print("Not available")
  }

  return(data.output)
}
