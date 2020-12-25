#' Coefficients and Predictors for Introducing MNAR
#'
#' @param coef a matrix of coefficients for a logit model for missingness
#' @param data predictor values for said logit model
#' 
#' @examples 
#' # Only the first variable playes a role in missingness 
#' # Include the intercept column 
#' d <- MNARData(coef=matrix(c(2,-1,0), byrow=T), data=cbind(rep(1,5), replicate(2, rnorm(5))))
MNARData <- setClass('MNARData', slots = c(coef='matrix', data='matrix'))

