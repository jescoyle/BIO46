### Code for R Lesson 4: Analyzing Categorical Data
### BIO46  Winter 2017
### Stanford University


## Examining the data

## ------------------------------------------------------------------------
# Change the working directory
setwd()

# Read the data file fungi_example_data.csv into a dataframe named fungi
fungi = read.csv('  ')

# Print the contents of fungi
fungi


## Categorical predictor and categorical response

## ------------------------------------------------------------------------
# Count the number of fungal isolates of each morphotype that came from each location
morph_tab = table(fungi$Loc, fungi$Morph)

# Print the table
morph_tab

## ------------------------------------------------------------------------
# Make a barplot from a table
barplot(morph_tab)

# Place the bars beside one another
barplot(morph_tab, beside=T)

# Make the plot prettier by rotating labels and adding axis labels.
barplot(morph_tab, beside=T, ylab='Num. isolates', xlab='Morphotype', las=1)


## ------------------------------------------------------------------------
# Conduct a chi-square test on the contingency table
loc_morph_test = chisq.test(morph_tab)

# View the results of the test
loc_morph_test

# View the expected frequencies under the null hypothesis
loc_morph_test$expected


## Categorical predictor and continuous response

### YOUR TURN: Make a boxplot comparing growth rates of fungal isolates from bases versus tips.

## ------------------------------------------------------------------------
# Load functions from the dplyr package
library(dplyr)

# Create a grouped dataframe
fungi_byLoc = group_by(fungi, Loc)

# Calculate mean growth rate and the standard devaition in growth rates by location
summarise(fungi_byLoc, mean_growth = mean(Growth), std_growth = sqrt(var(Growth)))


## ------------------------------------------------------------------------
# Fit a linear regression model with location as the predictor and growth rate as the response.
mod_grw_loc = lm(Growth ~ Loc, data = fungi)

# View the results of the linear model
summary(mod_grw_loc)


## ------------------------------------------------------------------------
# Calculate an ANOVA table for the linear model
anova(mod_grw_loc)


## ------------------------------------------------------------------------
# Make a boxplot comparing growth rates among morphotypes
boxplot(Growth ~ Morph, data=fungi, xlab='Morphotype', ylab='Growth rate (mm / day)', las=1)

### YOUR TURN: 
#   1. Fit a linear model that tests whether growth rates differ between morphotypes. 
#   2. Calculate an ANOVA table for the model in step 1.

## ------------------------------------------------------------------------
# Fit the anova model using the aov function. (Because TukeyHSD() doesn't work with lm objects)
mod_morph = aov(Growth ~ Morph, data = fungi)

# Calculate all pair-wise comparisons between morphotypes
TukeyHSD(mod_morph)

## ------------------------------------------------------------------------
# Create a new data frame for playing with contrasts (so as not to mess up the original data)
fungi2 = fungi

# Define a contrast that tests whether M1 differs from other morphotypes
cM1 = c(3, -1, -1, -1)

# Assign this contrast to the Morph column in fungi2
contrasts(fungi2$Morph) = cM1

# Check how this changed the contrasts matrix
# Notice that only the first contrast (1st column) corresponds to the hypothesis we are testing.
contrasts(fungi2$Morph)

# Fit a linear model with these new contrasts
mod_M1 = lm(Growth ~ Morph, data = fungi2)

# Examine the estimated effect of the contrast we are testing.
summary(mod_M1)

# Calculate the F-statistic for the contrast we are testing
summary.aov(mod_M1, split = list( Morph = list('M1' = 1)))


## ------------------------------------------------------------------------
# Make a contrast vector comparing M4 to M3 and M2
cM4 = c(0, -1, -1, 2)

# Calculate the cross product
cM1*cM4
sum(cM1*cM4)

# Make a contrast vector comparing M4 to all other morphotypes
cM4all = c(-1, -1, -1, 3)

# Calculate the cross product
cM1*cM4all
sum(cM1*cM4all)


## ------------------------------------------------------------------------
## Let's Review

### YOUR TURN: For each line of code below, write a comment above it describing what it does. 
#   Your comments should be preceeded by a # and occur above the line of code.

new_fungi = subset(fungi, Morph != 'M4')


loc_tab = table(new_fungi$Loc, new_fungi$Morph)


loc_tab = loc_tab[,-4]


chisq.test(loc_tab)


barplot(loc_tab, beside=T)


fungi$Growth_cm = fungi$Growth/10


mod_cm = lm(Growth_cm ~ Loc, data=fungi)


summary(mod_cm)


