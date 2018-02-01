### Code for R Lesson 2: Summarizing and Visualizing Data Part 1
### BIO46  Winter 2017
### Stanford University

## Reading data tables into R

## -----------------------------------------------------------------------
# Stop R from automatically converting text to categorical variables when reading in data
options(stringsAsFactors=F)

### YOUR TURN: Change the working directory below so that you can read in the data tables from your 'R-lessons/Data' directory.

# Define the location of your working directory
working_dir = 'C:/Users/jrcoyle/Documents/Stanford/BIO46/GitHub/R-lessons/Data' # Windows

# Set the working directory for this session
setwd(working_dir)

# Read iButton data and save in a data frame names temp_data
# header = TRUE is used for data where the first row gives the column names
# sep =',' tells the function that columns are separated by commas
temp_data = read.table('iButtons_Fall2016.csv', header=TRUE, sep=',')

# Read tree data using the short-cut function, read.csv()
# By default this function assumes that column names are in the first row and that the columns are separated by commas
tree_data = read.csv('JRTrees_Fall2016.csv')

## ------------------------------------------------------------------------
# Look at the first few rows of tree_data
head(tree_data)

# Print out just the column names of tree_data
names(tree_data)

# Count the number of rows in tree_data
nrow(tree_data)

# Count the number of columns in tree_data
ncol(tree_data)

# Get the number of rows and columns together (e.g. the dimensions)
dim(tree_data)

### YOUR TURN: Print out the column names of temp_data as well as the number of observations
#   (each observation is stored in a row).


## Summarizing data fields

## ------------------------------------------------------------------------

# Display the TreeID column of temp_data
temp_data$TreeID

# Count the number of observations from each tree
table(temp_data$TreeID)

### YOUR TURN: Make a vector named species_count that contains the number of trees measured for each tree species.

## ------------------------------------------------------------------------
# What are the mean, minimum, and maximum temperature measured?
mean(temp_data$Temp)
min(temp_data$Temp)
max(temp_data$Temp)

# What is the range of temperature values?
range(temp_data$Temp)


## Arithmetic

## ------------------------------------------------------------------------
# Addition 
2 + 3 + 10

# Subtraction
6 - 2

# Division'
20 / 2

# Multiplication
10 * 3 * 2
10*3*2

# Exponents
3 ^ 2
3^2

# Order of operations
5 + 2 * 4^2
(5 + 2) * 4^2
5 + (2 * 4)^2

# Save the value of a calculation as an object named the_answer
the_answer = (12 / 2) * (10 - 3)

# Print the_answer
the_answer


## -----------------------------------------------------------------------
# Select the first and last five temperature observations and save them as two vectors
first5 = temp_data[1:5, 'Temp']
last5_rows = (nrow(temp_data)-4):nrow(temp_data) # figure out which row numbers are the last 5 rows
last5 = temp_data[last5_rows, 'Temp']

# View them, then add them together
first5
last5
first5 + last5

# More arithmatic with vectors
last5 - 2
3 * last5^2

### YOUR TURN: Add a column to temp_data called temp_F which is the Fahrenheit equivalent of the Celcius temperature 
#   displayed in temp_C. Recall that you can use temp_data$new_column_name = to add on a 
#   column called 'new_column_name' to a dataframe.


## Subsetting data

## ------------------------------------------------------------------------
# Find which rows of temp_data are from Tree 1
t1_rows = temp_data$TreeID == 'T1'
t1_rows

# How long is t1_rows?
length(t1_rows)

# How many rows are in temp_data?
nrow(temp_data)

# Is t1_rows the same length as temp_data?
length(t1_rows) == nrow(temp_data)

# Use the subset() function to select only rows from temp_data that correspond to when t1_rows is TRUE 
# e.g. the row is from tree 1
T1_data = subset(temp_data, t1_rows)

# Or, subset the data using square braces
T1_data = temp_data[t1_rows, ]

# Print out the dataframe to look at it
T1_data


## ------------------------------------------------------------------------
# Find observations when the recorded temperature was greater than 40 Celcius
high_temps = temp_data$Temp > 40

# How many temperature readings were greater than 40? (How many TRUES in high_temps?)
sum(high_temps)

# Which rows correspond to temperatures greater than 40? (Which elements in high_temps are TRUE?)
which(high_temps)

### YOUR TURN: 
#   1. Make a dataframe called high_temp_data containing only observations where the temperature was greater than 40 C.
#   2. Use the table() function to count the number of observations from each tree that had temperatures greater than 40 C.


## ------------------------------------------------------------------------
# Find all observations where the temperature was less than 5 Celcius
# When using the subset function you can just use the name of the column
subset(temp_data, Temp < 5)

# If subseting using [], you must specify the actual column, not just its name:
temp_data[Temp < 5, ] # doesn't work because Temp doesn't exist as its own object
temp_data[temp_data$Temp < 5, ]


## ------------------------------------------------------------------------
# Find observations from Tree 3 where the temperature was greater than 35 Celcius
high_t3 = temp_data$TreeID == 'T3' & temp_data$Temp > 35
which(high_t3)

# Subset to these data using the logical vector high_t3
subset(temp_data, high_t3)

# Subset to these data without using a saved vector
subset(temp_data, TreeID == 'T3' & Temp > 35)

# Find observations where the temperature was greater than 40 or less than 5 Celcius
extreme_temps = temp_data$Temp > 40 | temp_data$Temp < 5


# Subset to these data (using the two different methods)
temp_data[extreme_temps, ] # method 1
temp_data[temp_data$Temp > 40 | temp_data$Temp < 5, ] # method 2


### YOUR TURN:
#   1. How many temperature records were greater than 40 C or less than 5 C?
#   2. Make a dataframe called low_t4 containing only observations from Tree 4 where the temperature was less than or equal to 10 C.
#   3. How many temperature observations from Tree 4 were less than 5 C?
#   4. Calculate the mean temperature from all data recorded at Tree 4. 


## Merging data tables

## ------------------------------------------------------------------------
# Add the columns of tree_data onto temp_data based on TreeID
merged_data = merge(temp_data, tree_data, by='TreeID')

# Look at the first few rows of the new merged data
# Notice that all of the columns from tree_data have been added on to temp_data
head(merged_data)

# Calculate the mean temperature in the north and south regions
north_temps = subset(merged_data, Region == 'north')$Temp
mean(north_temps)

south_temps = subset(merged_data, Region == 'south')$Temp
mean(south_temps)


## Visualizing data with boxplots

## ------------------------------------------------------------------------
# Make a boxplot of the temperature data from all trees
boxplot(temp_data$Temp)


## ------------------------------------------------------------------------
# Make boxplots of temperature for each tree
boxplot(Temp ~ TreeID, data=temp_data)

## ------------------------------------------------------------------------
# Make boxplots that include axis labels
boxplot(Temp ~ TreeID, data=temp_data, xlab='Tree', ylab=expression(Temperature~(degree*C)))

## ------------------------------------------------------------------------
# Add red horizontal dashed line at the median of the entire data set
abline(h = median(temp_data$Temp), col='red', lty=2)

### YOUR TURN: Make two boxplots to compare how temperature differs (1) between regions and (2) between tree species. 
#  Be sure to include axis labels on your plots. Hint: you may want to use the `merged_data` dataframe that we created earlier.
#  BONUS: Use the `?` to figure out how to change the group labels below the boxes.

## ------------------------------------------------------------------------
## Let's Review

### YOUR TURN: For each of the following lines of code, write a comment above it describing (briefly) what it will do. 
#   Then, run the line of code to check your answer. Modify your comment if necessary.

jrtrees = read.table('JRTrees_Fall2016.csv', header=T, sep=',')


dim(jrtrees)


table(jrtrees$Region)


jrtrees[jrtrees$Region == 'north', ]


sum(jrtrees$Species == 'Quercus_agrifolia' & jrtrees$Region == 'north')


