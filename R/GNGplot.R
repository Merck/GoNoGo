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
#'{Plot of probability of successes}
#'
#' @param data Output from the model
#' @param x.var Variable for x-axis
#' @param fill.var Variable for fill
#' @param hypothesis Hypothesis
#' @param x.lab label of x-axis
#' @param title.text Title of the figure
#' @param legend.title.text Legend title of the figure
#' @return Probability of success
#' @export
#'
#' @examples GNGplot(data = pos.val, x.var = pos.val$mu.t, fill.var = pos.val$PP.cutoffGo, hypothesis = pos.val$hypothesis, x.lab = "mu.t", title.text =  paste("PP(True mean is", hypothesis, "threshold) >= ", PP.cutoffGo*100, "%"), legend.title.text = "PP.cutoffGo")


GNGplot = function(data = data, x.var = mu.t,
                   fill.var = PP.cutoffGo,
                   hypothesis = hypothesis,
                   x.lab = "mu.t",
                   title.text =  paste("PP(True mean is", hypothesis, "threshold) >= PP cutoff"),
                   legend.title.text = "PP.cutoffGo"){

  ggplot(data = data, aes(x = x.var, y = probGo, fill = fill.var)) +
    geom_bar(stat = "identity", color = "black", position = position_dodge())+
    labs(title = title.text, y = "Probabiliy of success", x = x.lab)+
    theme_bw()+
    geom_hline(yintercept = c(60, 80), color = "grey")+
    guides(fill = guide_legend(title=legend.title.text ))+
    geom_text(aes(label = probGo), position = position_dodge(width = 0.9), vjust = -0.25)
}
