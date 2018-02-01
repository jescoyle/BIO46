### Code for R Lesson 5: Linear Models and Community Similarity
### BIO46  Winter 2017
### Stanford University


### YOUR TURN: Modify the code below so that you can read the two data tables into your R work session.

## ------------------------------------------------------------------------
# Change the working directory
setwd(  )

# Read the data file merged_final_carbon_utilization_data.csv into a dataframe named analysis_data
analysis_data = read.csv(  )


## Linear Regression

## ------------------------------------------------------------------------
# Make an x-y plot of the amount of mannitol used vs. mass of lichen
plot(D.Mannitol ~ Lichen_mass_mg, data = analysis_data)

## ------------------------------------------------------------------------
# Fit a linear model to mannitol with a single linear predictor, lichen_mass_mg
man_mass_mod = lm(D.Mannitol ~ Lichen_mass_mg, data=analysis_data)

# View the fitted model
summary(man_mass_mod)

## ------------------------------------------------------------------------
# Add the estimated line of best fit to the figure
abline(man_mass_mod, col='red')

### YOUR TURN: Evaluate whether the amount of mannitol utilized is related to bacterial abundance (measured as CFUs per mg thallus tissue).
#   1. Use your notes from class to calculate CFUs per mg of lichen thallus based on the following columns in `analysis_data`: `Lichen_mass_mg`, `Frac_extract`, `Init_vol_ml `, `Dilution_factor`, `Plate_vol_ml`. Add this variable as a new column in `analysis_data` nameed `CFU_mg`.
#   2. Make an x-y plot showing the relationship between CFUs and mannitol utilization.
#   3. Fit a linear regression testing whether this relationship is statistically significant.
#   4. Add the estimated line of best fit to the x-y plot.


## Generalized Linear Models

## ------------------------------------------------------------------------
# Make a new dataframe that is the same as analysis_data, but will have binary data on substrate utilization
binary_data = analysis_data

# Select only columns corresponding to carbon substrates
substrate_cols = 9:39

# Go through each column of the substrates
for(i in substrate_cols){
  
  # Select the data in this column
  this_col = binary_data[,i]
  
  # Find the value below which 50% of the data occur
  # na.rm = T tells the function to ignore NA values
  cutoff = quantile(this_col, 0.5, na.rm = T)
  
  # Assign TRUE to all values above the cutoff and FALSE to values below it
  new_vals = this_col > cutoff
  
  # Assign FALSE to all values that are NA because these also did not have any substrate utilized
  new_vals[is.na(new_vals)] = FALSE
  
  # Put these new values back into the binary_data
  binary_data[,i] = new_vals
}

# Examine the binary_data column for mannitol
binary_data$D.Mannitol


### YOUR TURN: Fill in the code below to plot the relationship between lichen mass and whether mannitol was utilized.

## ------------------------------------------------------------------------
# Plot mannitol usage vs. lichen mass
plot( ~  , data = )


## ------------------------------------------------------------------------
# Fit a logistic regression model
man_glm = glm(D.Mannitol ~ Lichen_mass_mg, data = binary_data, family = binomial(link=logit))

# View the estimated model
summary(man_glm)


## ------------------------------------------------------------------------
# Exponentiate the coefficents to see effect on odds
exp(coef(man_glm))


## ------------------------------------------------------------------------
# Make a vector of x values (lichen masses) at which you want to estimate the probability
mass_range = range(analysis_data$Lichen_mass_mg, na.rm = T) # Find min and max masses
x_vals = seq(mass_range[1], mass_range[2], length.out = 100) # Make sequence of 100 values between min and max masses

# Predict probability using fitted model at each x value
new_data = data.frame(Lichen_mass_mg = x_vals) # Make a dataframe with the same predictors that are in the model
y_vals = predict(man_glm, new_data, type='response') # type = 'response' tells the function to predict probabilities rather than log odds

# Add predicted points to graph as a red line
lines(x_vals, y_vals, col='red')


## ------------------------------------------------------------------------
# Count the number of TRUES in each row for columns corresponding to carbon substrates
rowSums(binary_data[ , substrate_cols])

# Assign this count to a new column names in binary_data
binary_data$Num_substrates = rowSums(binary_data[ , substrate_cols])

# How many samples used 0, 1, 2, ... etc substrates?
substrate_counts = table(binary_data$Num_substrates)
plot(substrate_counts, xlab='Num. substrates', ylab='Num. samples')

## ------------------------------------------------------------------------
# Plot number of substrates utilized vs. lichen mass
plot(Num_substrates ~ Lichen_mass_mg, data = binary_data)

# Fit a GLM with Poisson errors
subs_glm = glm(Num_substrates ~ Lichen_mass_mg, data = binary_data, family = poisson(link = 'log'))

# View the model results
summary(subs_glm)

# Predict the number of substrates utilized using fitted model at each x value
y_vals = predict(subs_glm, new_data, type='response')

# Add a red line with the predicted values
lines(x_vals, y_vals, col='red')


## ------------------------------------------------------------------------
# Make table of how many internal vs. external samples mannitol was utilized in
table(binary_data$Thallus_location, binary_data$D.Mannitol)

# Fit a GLM testing whether location affects the odds that mannitol will be utilized
man_loc_mod = glm(D.Mannitol ~ Thallus_location, data = binary_data, family = binomial(link = 'logit'))

# View the model results
summary(man_loc_mod)

# View the effect on the odds (rather than log odds)
exp(coef(man_loc_mod))

## ------------------------------------------------------------------------
# Make table of how many internal vs. external samples mannitol was utilized in
table(binary_data$Thallus_location, binary_data$D.Mannitol)

odds_external = 20/22
odds_internal = 8/91
odds_internal / odds_external

### YOUR TURN: Evaluate whether the probability of *any* substrate being utilized is affected by the mass of lichen from which the microbial community was extracted.
#   1. Make a variable that indicates whether any substrate was utilized. Add this variable as a new column in `binary_data` called `C_used`.
#   2. Make an x-y plot visualizing the relationship between lichen mass and whether any substrate was used.
#   3. Fit a GLM modeling this relationship.
#   4. Add a red line showing the model prediction.


## Measuring Community Similarity

## ------------------------------------------------------------------------
# Load the functions in the vegan package
library(vegan)

# Display the help file on vegdist to veiw the different dissimilarity measures that are available
?vegdist


## ------------------------------------------------------------------------
# Make a subset of the data corresponding to only data from Tree 1
tree1_rows = grep('W17-T1-', analysis_data$PlateID)
tree1_data = analysis_data[tree1_rows, ]

# Notice that the last two rows correspond to L4, which was Ramalina menziesii, so let's remove those
tree1_data = tree1_data[1:6,]

# Make a new dataframe that only includes the columns used for comparing community composition
comm_data = tree1_data[,substrate_cols]

# Add row names that show which sample each row is from
rownames(comm_data) = tree1_data$PlateID

# Replace NA values with 0
comm_data[is.na(comm_data)] = 0

# Calculate bray-curtis dissimilarity between all pairs of samples
bc_dist = vegdist(comm_data, method = 'bray')

# The warning said that some samples don't have any substrates utilized
# Let's see which sample this was: it was L3-P2
rowSums(comm_data)

# Examine the dissimilarities: notice that all samples are maximally dissimilar to L3-P2 (value = 1)
bc_dist

## ------------------------------------------------------------------------
# Make a distance matrix comparing whether samples come from the same (0) or different (1) thallus locations
loc_dist = dist(as.numeric(tree1_data$Thallus_location))
loc_dist

# Sort the dissimilarities into categories based on loc_dist
plot(loc_dist, bc_dist)

## ------------------------------------------------------------------------
# Conduct an analysis of variance on distance matrices
adonis(bc_dist ~ Thallus_location, data=tree1_data)

## ------------------------------------------------------------------------
## Let's Review

### YOUR TURN: For each function below, write a comment describing what it does.

lm()


glm()


rowSums()



predict()


vegdist()



