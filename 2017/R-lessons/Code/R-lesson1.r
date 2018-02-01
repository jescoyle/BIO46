### Code for R Lesson 1: Introduction to R
### BIO46  Winter 2017
### Stanford University

## Getting Started

## ------------------------------------------------------------------------
# Comments begin with a # and give you information about what the code does.
# For example, the next line is code that will print 'Hello' in the console.
print('Hello')

### YOUR TURN: Modify the code so that the console greets you by name.


## Objects

## ------------------------------------------------------------------------
# This is a vector of numbers
c(1,2,3,4,5)

# This is a vector of characters
c('a','b','c','d','e')

# Vectors cannot contain elements with different types
c(1,2,3,'a','b')

## ------------------------------------------------------------------------
# Make a vector called fingers
fingers = c(1,2,3,4,5)

# Print the contents of lichens
fingers

# Make and view a vector called lichen
lichen = c('ascomycete','algae','yeast','bacteria')
lichen

# Make a vector called animals
animals = c('cat','parrot','fly','squid','seastar')


## ------------------------------------------------------------------------
# How many elements are in lichen?
length(lichen)

### YOUR TURN: Make a vector with the first 4 even numbers named "evens".

## ------------------------------------------------------------------------
# Repeat something multiple times
rep('a', 5)
rep(evens, 2)
rep(evens, each=2)

# Make a sequence
1:10
20:15
seq(10)
seq(0, 10, by=2)
seq(0, 1, length.out=11)
seq(-10, 3, 0.5)

### YOUR TURN: Make a vector named "trials" with integers from 1 to 50 repeated 3 times.


## ------------------------------------------------------------------------

# Make some lists
list('My', 'dog', 'has', 10, 'fleas.')
list(c('My','dog','has'), 10, 'fleas.')
lichen_list = list('lichen', lichen)

# How many elements in lichen_list?
length(lichen_list)

# Make a dataframe
data.frame(1:4, lichen)
data.frame(part = 1:4, organism = lichen)

### YOUR TURN: 
#   Make a list containing two elements: a vector of the first four even numbers and the vector lichen.
#   Make a dataframe called 'hand' whose first column has the integers 1 to 5, 
#       second column contains finger names (starting with 'thumb'), 
#       and third column contains `animals`.
#   Name the columns 'number','name','animal'.

## ------------------------------------------------------------------------
# Print the third element of animals
animals[3]

# Change the third element of animals to 'spider'
animals[3] = 'spider'
animals


## ------------------------------------------------------------------------
# Print the first element in lichen_list
lichen_list[[1]]

# Change the first element in `lichen_list` to odd numbers
lichen_list[[1]] = seq(1, 7, by=2)
lichen_list


## ------------------------------------------------------------------------
# Get the first and last elements in lichen
lichen[c(1,4)]

# Display the elements of lichen in reverse the order
lichen[4:1]

### YOUR TURN: Create a vector names "little_zoo" containing only parots, squids, seastars 
#   and algae without typing the names of any of these organisms.


## ------------------------------------------------------------------------
# What is in the 2nd row and 3rd column of hand?
hand[2,3]

# What is in the 3rd row of hand?
hand[3,]

# What is the 5th animal and finger name?
hand[5, c(3,2)]


## ------------------------------------------------------------------------
# Create a data frame
my_data = data.frame(1:20, lichen, rep(1:5, each=4))

# View the dataframe column names given by default
names(my_data)

# Change the column names
names(my_data) = c('trial', 'organism', 'treatment')
names(my_data)
my_data

# Elements in a vector are not assigned names by default
names(animals)

# Name the elements in a vector
names(animals) = c('Felix', 'Polly', 'Charlotte', 'Kraken', 'Patrick')
animals

# What type of animal is Patrick?
animals['Patrick']

# Name the elements in a list
names(lichen_list) = c('numbers','organisms')
lichen_list

# Access the elements of a list by name
lichen_list[['organisms']]
lichen_list[['organisms']][2]

### YOUR TURN: Extract the organisms associated with off trial numbers in my_data


## ------------------------------------------------------------------------
# Display the treatment column of my_data
my_data$treatment

# Add a new column to my_data called temp
my_data$temp_C = rep(c(5,10,15,20,25), each=4)
my_data


## Functions

## ------------------------------------------------------------------------
# Display a function
seq

## ------------------------------------------------------------------------
# Display the help file on seq()
?seq


## ------------------------------------------------------------------------
# Make a sequence of numbers from 10 to 20 counting by 5
seq(10, 20, 5)

# Make a sequence of 6 numbers spread evenly between 10 and 20 
seq(10, 20, length.out=6)

# Make a sequence of the first 5 numbers divisible by 3
seq(3, length.out=5, by=3)

### YOUR TURN: Display the help file on matrix().
#   Make a matrix named row_matrix that has 4 rows, each with the numbers 1 to 5 in order.

## ------------------------------------------------------------------------
## Let's Review

### YOUR TURN: For each of the following lines of code, write a comment above it describing
#   (briefly) what it will do. Then, run the line of code to check your answer.
#   Modify your answer if necessary.


fox = 2:8


c(fox, 2)


rep(fox, 3)


seq(0, 10, 2)


list('myfox', fox)


fox_data = data.frame(fox, rep('hare', 7))


names(fox_data)[2] = 'prey'


