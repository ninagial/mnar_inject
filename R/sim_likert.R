#' Simulate a Likert data set with Missing Values and Misfitting Items
#'
#' Misfitting items are for now loosely defined: They are just random responses without any structure.
#' A more sophisticated way will be to simulate items drawn from other structures (e.g. loading to more than one factors etc).
#'
#' @param n_obs number of rows in the resultinf data.frame
#' @param n_var number of variables in the resulting data.frame (excluding misfiting items, see below
#' @param lowest value for item response ? 
#' @param highest value for item response ?
#' @param n_misf number of misfiting items
#' @param perc_miss percentage missing (for missing at-random)
#' @param mnar should missing not-at-random be injected (results in a separate DF)
#' @param mnar_data a MNARData object contains model definition for injecting MNARs
#' @param mnar_cols character vector of column names of the columns (obligatory)
#'
#' @return A list with the requested data.frames
#' @example
#' foo_mnar_data = function(n_obs=500){
#' 	MNARData(
#' 	 coef = matrix(c(2,-1,0,0),2,2), 
#' 	 data = cbind( 
#' 		      category1 = c(rep(0,n_obs/2), rep(1,n_obs/2)),
#' 		      category1 = c(rep(0,n_obs/2), rep(1,n_obs/2))))
#' }
#' foo = sim_likert(mnar=T, mnar_data=foo_mnar_data(), mnar_cols=c('Item1', 'Item2'))
#' str(foo)
sim_likert <- function(n_obs=500, n_var=5, low=1, high=5, n_misf=2, perc_miss=.1, mnar = F, mnar_data, mnar_cols){

	require(psych)
	simulation = psych::sim.poly.npl(nvar=n_var, n=n_obs, low=low, high=high)

	# Simulate Misfitting Items
	mis1 <- replicate(n_misf, sample(1:5, n_obs, repl=T))

	df1 <- data.frame(cbind(simulation$items + 1, mis1))
	colnames(df1) <- sprintf("Item%d", 1:ncol(df1))

	total_cells = prod(dim(df1))

	# Introduce Missing Values at Random
	df1_na <- as.matrix(df1)
	# I think this method gives less biased results than `sample` does
	missing_ix = head(sample(floor(runif(1e3,1,n_var))), perc_miss*total_cells)
	df1_na[missing_ix] <- NA
	out_data=list(complete=df1, mar=df1_na)

	# Introduce Missing Values NOT at Random
	if (mnar){
		if (class(mnar_data) != 'MNARData'){
			stop("Define the coefficients and predictors for MNAR in a MNARData object. See help(MNARData)")}
		if (class(mnar_cols) != "character" || length(mnar_cols) == 0){
			stop("Column names for the variables to be MNAR injected is required.")
		}
		df2_na <- mnar_inject(df1[mnar_cols],mnar_data)
		df2_na <- cbind(df1[!(colnames(df1) %in% mnar_cols)], df2_na)
		df2_na <- data.frame(df2_na)
		out_data$mnar = df2_na
	}

	# Value
	list(sim=simulation, data=out_data)
        }


