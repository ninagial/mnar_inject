# Introduce NA's not at Random in a data.frame

This function takes a data.frame and injects missing values not-at-random, but according to a glm logit model. The `MNARData` object contains the coefficients and the predictor variables.

Note that the `data.frame` in the first argument should _only_ contain the variables that are to be injected.

This assumes no covariance between missingness for different variables.

Also note, this probably only works for binary categorical predictor variables.

	 mtcars_mnar_data = MNARData(
			     coef=matrix(c(2,-1,0, 1,0,2),3,2), 
			     data=as.matrix(cbind(rep(1, nrow(mtcars)), mtcars[c('vs','am')])))
	 mtcars_na = mnar_inject(mtcars[c('hp','mpg')], mtcars_mnar_data)
	 head(mtcars_na)


# Simulate a Likert data set with Missing Values and Misfitting Items

Misfitting items are for now loosely defined: They are just random responses without any structure.
A more sophisticated way will be to simulate items drawn from other structures (e.g. loading to more than one factors etc).

Return a list with the requested data.frames, by default a complete set and a MAR injected one. Additionally, a third element `mnar` is added to the list if requested with `mnar=TRUE`.
	
	foo_mnar_data = function(n_obs=500){
		MNARData(
		 coef = matrix(c(2,-1,0,0),2,2), 
		 data = cbind( 
			      category1 = c(rep(0,n_obs/2), rep(1,n_obs/2)),
			      category2 = c(rep(0,n_obs/2), rep(1,n_obs/2))))
	 }
	 foo = sim_likert(mnar=T, mnar_data=foo_mnar_data(), mnar_cols=c('Item1', 'Item2'))
	 str(foo)

