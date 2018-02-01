### Code for R Lesson 5 Supplement: Creating Ecoplate Data for Analysis
### BIO46  Winter 2017
### Stanford University

## Examining the data

### YOUR TURN: Modify the code below so that you can read the two data tables into your R work session.

## ------------------------------------------------------------------------
# Change the working directory
setwd('C:/Users/jrcoyle/Documents/Stanford/BIO46/GitHub/R-lessons/Data/')

# Read the data file carbon_utilization.csv into a dataframe named Cdata
Cdata = read.csv('carbon_utilization.csv')

# Read the data file bacteria_plates.csv into a dataframe named sample_info
sample_info = read.csv('bacteria_plates.csv')

# Read the data file ecoplates.csv into a dataframe named eco
eco = read.csv('ecoplates.csv')

## Data Wrangling

## ------------------------------------------------------------------------
# Cross-tabulate which plates were measured on which days
table(Cdata$EcoplateID, Cdata$DayNumber)

## ------------------------------------------------------------------------
# Make a vector of plate numbers that we will select
plate_1to4 = paste('Plate', 1:4, sep='-')

plate_1to4

## ------------------------------------------------------------------------
# Test whether each element of the Plate column in Cdata is in keep_plates 
# (i.e. equals Plate-1, Plate-2, Plate-3, or Plate-4)
keep_rows = Cdata$Plate %in% plate_1to4

keep_rows

## ------------------------------------------------------------------------
# Create a subset of the data
E1to4_data = subset(Cdata, keep_rows & DayNumber == 12)

# Check how many rows remain... there should be 3 samples * 4 plates * 8 groups = 96 rows
nrow(E1to4_data)


## ------------------------------------------------------------------------
# Make a vector of plate numbers that we will select
plate_5to8 = paste('Plate', 5:8, sep='-')
  
# Make a vector that tests whether each row is in plate_5to8
keep_rows = Cdata$Plate %in% plate_5to8
  
# Create a subset of the data 
E5to8_data = subset(Cdata, keep_rows & DayNumber == 11)

# Check whether there are the correct number of rows
nrow(E5to8_data)


## ------------------------------------------------------------------------
# Combine E1to4_data and E5to8_data
Cdata_last = rbind(E1to4_data, E5to8_data)

# Check the number of times each plate was measured using table()
table(Cdata_last$EcoplateID, Cdata_last$DayNumber)


## ------------------------------------------------------------------------
# Load the functions from the package you just installed
library(reshape2)

# Step 1: convert the eco dataframe into a format with three columns
eco_melted = melt(eco, id.vars='EcoplateID', measure.vars=c('Sample_1','Sample_2','Sample_3'))

# Re-name the columns to names that are the same as in sample_info and Cdata_last
names(eco_melted) = c('EcoplateID','Sample.ID','PlateID')

# Examine the first few lines of the new table
head(eco_melted)

# Step 2: Attache the PlateID column from eco_melted to Cdata_last
# The all.x = T tells the merge function to keep all of the rows in Cdata, even if there isn't a match
Cdata_last = merge(Cdata_last, eco_melted, all.x=T)

# Examine the first few lines of Cdata
head(Cdata_last)

# Notice that some samples did not have anything in them (PlateID = NONE)
# Remove these samples
Cdata_last = subset(Cdata_last, PlateID != 'NONE')

# Step 3: Combine the columns of Cdata_last and sample_info and rename as analysis_data
analysis_data = merge(Cdata_last, sample_info, all.x=T)

# How many rows in analysis_data?
nrow(analysis_data)


# Save data to a file
write.csv(analysis_data, file = 'merged_final_carbon_utilization_data.csv', row.names=F)


