### Code for R Lesson 3: Summarizing and Visualizing Data Part 2
### BIO46  Winter 2017
### Stanford University


## Task 1: Plot variation in temperature at one tree during Fall 2016

## ------------------------------------------------------------------------
# Stop R from automatically converting text to categorical variables when reading in data
options(stringsAsFactors=F)

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


### YOUR TURN: Change the working directory in the code above so that the code will find the files you saved on your computer.

## ------------------------------------------------------------------------
# Look at the contents of the tree_data dataframe
tree_data

# Let's choose Tree 13 and subset the temperature data to just this tree
focal_tree = 'T13'
focal_tree_data = subset(temp_data, TreeID==focal_tree)

# Look at the first five rows of focal_tree_data
head(focal_tree_data)

# How many temperature observations are there?
nrow(focal_tree_data)

## ------------------------------------------------------------------------
# Display the type of data stored in the Date_time column of focal_tree_data
class(focal_tree_data$Date_time)

## ----strptime------------------------------------------------------------
# Make a vector of time points that corresponds to Date_time and is in a date format that R can understand
time_points = strptime(focal_tree_data$Date_time, format='%m/%d/%y %I:%M:%S %p %z')

# View these new times
time_points

# Display the type of data stored in the time_points vector - it is not 'character'
class(time_points)

## ----plot_time_series----------------------------------------------------
# Plot temperature versus time using method 1:
plot(time_points, focal_tree_data$Temp)

## ----better_time_series--------------------------------------------------
# Plot temperature vs time as a line and with axis labels
plot(time_points, focal_tree_data$Temp, type='l', xlab='Date', ylab='Temperature (C)', las=1)

## ------------------------------------------------------------------------
# Define the cut-off date to remove data
cutoff_date = strptime('2016-09-20 12:00:00 -0700', format='%Y-%m-%d %H:%M:%S %z')

# Which time_points are after the cutoff date?
time_points > cutoff_date

# Subset focal_tree_data to only observations after the cutoff date
analysis_data = subset(focal_tree_data, time_points > cutoff_date)

# How many observations remain for analysis?
nrow(analysis_data)


### YOUR TURN: Calculate the number of temperature observations that were dropped from the analysis because they 
#   occured prior to the cutoff date.


## Task 2: Summarize the temperature data at one tree

## ------------------------------------------------------------------------
# Make a new vector of time_points that corresponds to the times in analysis_data
analysis_times = strptime(analysis_data$Date_time, format='%m/%d/%y %I:%M:%S %p %z')


# Plot temperature vs time as a line and with axis labels
plot(analysis_times, analysis_data$Temp, type='l', xlab='Date', ylab='Temperature (C)', las=1)

# Add a red horizontal line at the maximum temperature measured
abline(h = max(analysis_data$Temp), col='red')

# Add a blue horizontal line at the minimum temperature measured
abline(h = min(analysis_data$Temp), col='blue')

### YOUR TURN: Add a purple horizontal line to the plot at the mean temperature value. 
#   Hint: the function for calculating the mean of a vector is mean().


## Task 3: Summarize daily temperature data at one tree

## ------------------------------------------------------------------------
# Make a vector that gives the date of each temperature measurement without the time.
analysis_dates = as.Date(analysis_times)

# Plot the temperature measurements by date
plot(analysis_dates, analysis_data$Temp, xlab='Date', ylab='Temperature (C)', las=1)

## ------------------------------------------------------------------------
# Load the package dplyr
library(dplyr)

## ------------------------------------------------------------------------
# Count the number of observations in analysis_data
summarise(analysis_data, Num_obs=n())

# Calculate the average temperature 
summarise(analysis_data, avgT = mean(Temp))

# Do both at once
summarise(analysis_data, Num_obs = n(), avgT = mean(Temp))

## ------------------------------------------------------------------------
# Add the dates as a column in the analysis_data dataframe
analysis_data$Date = analysis_dates

# Look at the first few rows to see that it was added
head(analysis_data)

# Create a table grouping temperature observations by date
grouped_data = group_by(analysis_data, Date)

# Summarize temperature by date and save as a new dataframe called daily_temp_summary
daily_temp_summary = summarise(grouped_data, Num_obs=n(), avgT=mean(Temp), maxT=max(Temp))

# View the summary data
daily_temp_summary


### YOUR TURN: Modify the code that creates the daily_temp_summary dataframe so that it includes a column 
#   called 'minT' containing the minimum temperature measured each day.

## ------------------------------------------------------------------------
# Calculate the mean daily high temperature at this tree
mean(daily_temp_summary$maxT)


### YOUR TURN: Calculate the mean daily low temperature at this tree.


## Task 4: Summarize daily temperature measurements at multiple trees


### YOUR TURN: Change the focal_tree at the beginning of this R script so that subsequent 
#   code will analyze data from Tree 17. What was the mean daily maximum temperature at Tree 17? 
#   (Write your answer, don't copy down all of the code again.)

## ------------------------------------------------------------------------
# Make a vector of time points that corresponds to Date_time and is in a date format that R can understand
time_points = strptime(temp_data$Date_time, format='%m/%d/%y %I:%M:%S %p %z')

# Subset temp_data to only observations occuring after the cutoff date
analysis_data = subset(temp_data, time_points > cutoff_date)

# Make a new vector of time_points that corresponds to the times in analysis_data
analysis_times = strptime(analysis_data$Date_time, format='%m/%d/%y %I:%M:%S %p %z')

# Extract the dates from analysis_times and add them as a new column in analysis_data
analysis_data$Date = as.Date(analysis_times)

# Group analysis_data by TreeID and by Date
grouped_data = group_by(analysis_data, TreeID, Date)

# Calculate the mean and max daily temperatures at each tree
temp_summary = summarise(grouped_data, avgT=mean(Temp), maxT=max(Temp))

# Display temp_summary
temp_summary

# Convert temp_summary to a regular dataframe so that all rows display
temp_summary_df = as.data.frame(temp_summary)
temp_summary_df

# View summary data from one tree
subset(temp_summary_df, TreeID=='T14')

# Calculate the average daily high temperature across all trees
mean(temp_summary_df$maxT)


### YOUR TURN: Calculate the average daily low temperature across all trees.

## ------------------------------------------------------------------------
## Let's Review

### YOUR TURN: For each line of code below, write a comment above it describing what it does.
#   You can assume that  temp_summary_df is the same dataframe we just created in the code above, 
#   containing average and maximum daily temperatures for each tree on each day.


plot(temp_summary_df$Date, temp_summary_df$maxT)


plot(temp_summary_df$avgT, temp_summary_df$maxT, xlab='Mean temp.', ylab='Max. temp.')


abline(h=mean(temp_summary_df$maxT))


subset(temp_summary_df, maxT > 40)


tree_groups = group_by(temp_summary_df, TreeID)


summarise(tree_groups, mean_high=mean(maxT))

