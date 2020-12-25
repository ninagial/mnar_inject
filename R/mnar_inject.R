#' Introduce NA's not at Random in a data.frame
#'
#' This function takes a data.frame and injects missing values not-at-random, but
#' according to a glm logit model. The \code{MNARData} object contains the coefficients and the predictor variables.
#' Note that the `data.frame` in the first argument should \emph{only} contain the variables that are to be injected.
#' This assumes no covariance between missingness for different variables.
#' Also note, this probably only works for binary categorical predictor variables.
#'
#' @param df data.frame, containing only the columns to be injected
#' @param mnar_data, MNARData object, containing the coefficients and predictors for the logit model
#' mtcars_mnar_data = MNARData(
#' 		     coef=matrix(c(2,-1,0, 1,0,2),3,2), 
#' 		     data=as.matrix(cbind(rep(1, nrow(mtcars)), mtcars[c('vs','am')])))
#' mtcars_na = mnar_inject(mtcars[c('hp','mpg')], mtcars_mnar_data)
#' head(mtcars_na)

mnar_inject <- function(df, mnar_data){
	p_miss = 1/(1+exp(-(mnar_data@data %*% mnar_data@coef)))
	cat(sprintf("P MISS DIMENSIONS ARE %d x %d\n", nrow(p_miss), ncol(p_miss)))
        out=data.frame(lapply(1:ncol(mnar_data@coef), 
	       function(i){
		      df_temp = df
		      df_temp[as.logical(1-rbinom(nrow(df),size=1,p=p_miss[,i])),i] <- NA
		      df_temp[,i]
	       }))
	names(out) <- names(df)
	out
}
