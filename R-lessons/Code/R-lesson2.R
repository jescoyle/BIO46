

## Reading data tables into R

# Stop R from automatically converting text to categorical variables when reading in data
options(stringsAsFactors=F)

# YOUR TURN: Define the location of your working directory
working_dir = 'C:/Users/jrcoyle/Documents/Stanford/BIO46/GitHub/R-lessons/Data'

# Set the working directory for this session
setwd(working_dir)

# Read iButton data and save in a data frame names temp_data
temp_data = read.table('iButtons_Fall2016.csv', header=T, sep=',')

# Read tree data using the short-cut function, read.csv
tree_data = read.csv('JRTrees_Fall2016.csv')

# Look at the first few rows of tree_data
head(tree_data)

# Count the number of rows in tree_data
nrow(tree_data)

# Count the number of columns in tree_data
ncol(tree_data)

# Get the number of rows and columns together (e.g. the dimensions)
dim(tree_data)

# YOUR TURN: Print out the column names of `temp_data` as well as the number of observations.


## Summarizing data fields

# Count the number of observations from each tree
table(temp_data$TreeID)

# YOUR TURN: Make a vector named species_count that contains the number of trees measured for each tree species.

# What are the mean, minimum, and maximum temperature measured?
mean(temp_data$Temp)
min(temp_data$Temp)
max(temp_data$Temp)

# What is the range of temperature values?
range(temp_data$Temp)

# YOUR TURN: Calculate the temperature difference between the highest and lowest recorded temperatures.


## Subsetting data

# Find which rows of temp_data are from Tree 1
t1_rows = temp_data$TreeID == 'T1'
t1_rows

# How long is t1_rows?
length(t1_rows)

# How many rows are in temp_data?
nrow(temp_data)

# Is t1_rows the same length as temp_data?
length(t1_rows) == nrow(temp_data)

# Select rows from temp_data when t1_rows is TRUE (e.g. row corresponds to tree 1)
T1_data = subset(temp_data, t1_rows)

# Another way to subset:
T1_data = temp_data[t1_rows, ]

# Find observations when the recorded temperature was greater than 40 Celcius
high_temps = temp_data$Temp > 40

# How many temperature readings were greater than 40?
sum(high_temps)

# Which rows correspond to temperatures greater than 40?
which(high_temps)

# YOUR TURN:  
#  1. Make a dataframe called high_temp_data containing only observations where the temperature was greater than 40 C.
#  2. Count the number of observations from each tree that had temperatures greater than 40 C.

# Find all observations where the temperature was less than 5 Celcius
subset(temp_data, Temp < 5)

# If subseting using [], you must specify the actual column, not just its name:
temp_data[Temp < 5, ]
temp_data[temp_data$Temp < 5, ]

# Find observations from Tree 3 where the temperature was greater than 35 Celcius
high_t3 = temp_data$TreeID == 'T3' & temp_data$Temp > 35
which(high_t3)

# Subset to these data
subset(temp_data, high_t3)
subset(temp_data, TreeID == 'T3' & Temp > 35)

# Find observations where the temperature was greater than 40 or less than 5 Celcius
extreme_temps = temp_data$Temp > 40 | temp_data$Temp < 5

# Subset to these data
temp_data[extreme_temps, ]
temp_data[temp_data$Temp > 40 | temp_data$Temp < 5, ]

# YOUR TURN:
#  1. How many temperature records were greater than 40 C or less than 5 C?
#  2. Make a dataframe called low_t4 containing only observations from Tree 4 where the temperature was less than or equal to 10 C.
#  3. How many temperature observations from Tree 4 were less than 5 C?
#  4. Calculate the mean temperature from all data recorded at Tree 4. 


## Summarizing data with dplyr

# Load the package dplyr
library(dplyr)

# Find all observations where the temperature was less than 5 Celcius
filter(temp_data, Temp < 5)

# Find observations from Tree 3 where the temperature was greater than 35 Celcius
filter(temp_data, Temp > 35, TreeID=='T3')

# Count the number of observations in temp_data
summarise(temp_data, count=n())

# Calculate the average temperature 
summarise(temp_data, avgT = mean(Temp))

# Do both at once
summarise(temp_data, count = n(), avgT = mean(Temp))

# Also calculate the maximum temperature
summarise(temp_data, count = n(), avgT = mean(Temp), highT = max(Temp))

# YOUR TURN: Modify the last line of code so that `lowT` containing the minimum temperature is also printed.

# Create a grouped table of temp_data based on TreeID
temp_byTree = group_by(temp_data, TreeID)

# Summarize temperature data by tree
tree_summary = summarise(temp_byTree, count = n(), avgT = mean(Temp), highT = max(Temp)) 

# Which tree had the lowest mean temperature?
filter(tree_summary, avgT == min(avgT))


## Merging data tables

# Add the columns of tree_data onto temp_data based on TreeID
merged_data = merge(temp_data, tree_data, by='TreeID')

# Summarize temperature by region
temp_byReg = group_by(merged_data, Region)
reg_summary = summarise(temp_byReg, count = n(), avgT = mean(Temp), highT = max(Temp), lowT = min(Temp))
reg_summary

# YOUR TURN: Summarize temperature differences between the two tree species. Name this summary table `species_summary`.


## Visualizing data

# Make a boxplot of the temperature data from all trees
boxplot(temp_data$Temp)

# Make boxplots of temperature for each tree
boxplot(Temp ~ TreeID, data=temp_data)

# Make boxplots that include axis labels
boxplot(Temp ~ TreeID, data=temp_data, xlab='Tree', ylab=expression(Temperature~(degree*C)))

# Add red horizontal dashed line at the median of the entire data set
abline(h = median(temp_data$Temp), col='red', lty=2)

# YOUR TURN**: Make two boxplots to determine whether temperature differ between regions and between tree species. 
#  Be sure to include axis labels on your plots. Use the `?` to figure out how to change the group labels below the boxes.


## Let's Review

# YOUR TURN: For each of the following lines of code, write a comment above it describing (briefly) what it will do. 
# Then, run the line of code to check your answer. Modify your comment if necessary.

jrtrees = read.table('JRTrees_Fall2016.csv', header=T, sep=',')


dim(jrtrees)


table(jrtrees$Region)


jrtrees[jrtrees$Region == 'north', ]


sum(jrtrees$Species == 'Quercus_agrifolia' & jrtrees$Region == 'north')


filter(temp_data, Temp <= mean(Temp) )


tbt = group_by(temp_data, TreeID)
meds = summarise(tbt, med = median(Temp))


jr_merged = merge(jrtrees, meds, by='TreeID')


boxplot(med ~ Species, data=jr_merged)
