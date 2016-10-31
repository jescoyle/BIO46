## Name:


### Getting Started

# Comments begin with a # and give you information about what the code does.
# For example, the next line is code that will print 'Hello' in the console.
print('Hello')

# YOUR TURN: Modify the code so that the console greets you by name.
print('Hello')



### Objects 

## Vectors

# This is a vector of numbers
c(1,2,3,4,5)

# This is a vector of characters
c('a','b','c','d','e')

# Vectors cannot contain elements with different types
c(1,2,3,'a','b')

# Make a vector called fingers
fingers = c(1,2,3,4,5)

# Print the contents of lichens
fingers

# Make and view a vector called lichen
lichen = c('ascomycete','algae','yeast','bacteria')
lichen

# YOUR TURN: Make a vector with the first 4 even numbers named 'evens'.



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

# YOUR TURN: Make a vector named 'trials' with the integers from 1 to 50 repeated 3 times.


## Matrices and Arrays

# Make a 3 x 4 matrix filled of 0s
matrix(0, 3, 4)

# Make a 3 x 3 matrix with the integers 1 - 9
matrix(1:9, 3, 3)

# Make a 3-D array filled with cats
array('cat', dim = c(2,3,4))

# Make a matrix with more animals
animals = c('cat','parrot','fly','squid','seastar')
my_zoo = matrix(animals, 3, 5)

# YOUR TURN: Make a matrix named trial_matrix with three columns, 
#            each of which contains the numbers 1 to 50 in increasing order.



## Lists and Dataframes

# Make some lists
list('My', 'dog', 'has', 10, 'fleas.')
list(c('My','dog','has'), 10, 'fleas.')
list(animals, my_zoo)
lichen_list = list('lichen', lichen)

# Make a dataframe
data.frame(1:4, lichen)
data.frame(part = 1:4, organism = lichen)

# YOUR TURN:
#   Add a vector containing the first four even numbers to the beginning of `lichen_list`.
#   Make a dataframe called 'hand' whose first column has the integers 1 to 5, 
#       second column contains finger names (starting with 'thumb'), 
#       and third column contains `animals`.
#   Name the columns 'number','name','animal'.



## Accessing elements in objects

# Print the third element of animals
animals[3]

# Change the third element of animals to 'spider'
animals[3] = 'spider'
animals

# Print the first element in lichen_list
lichen_list[[1]]

# Change the first element in `lichen_list` to odd numbers
lichen_list[[1]] = seq(1, 7, by=2)

# Get the first and last elements in lichen
lichen[c(1,4)]

# Display the elements of lichen in reverse the order
lichen[4:1]

# Which animal is in the 2nd row and 4th column of my_zoo?
my_zoo[2,4]

# Which animals are in the 3rd row of my_zoo?
my_zoo[3,]

# Which animals are in the 4th and 5th columns of my_zoo?
my_zoo[,c(4,5)]

# BONUS: Change the last two odd numbers in `lichen_list` back to even numbers.

# Name the rows and columns of a matrix
rownames(my_zoo) = c('A','B','C')
colnames(my_zoo) = c('blue','pink','red','yellow','green')
my_zoo

# Get the animals in the blue column in rows A and B
my_zoo[c('A','B'), 'blue']

# Create a data frame
my_data = data.frame(1:20, lichen, rep(1:5, each=4))

# Change the column names
names(my_data) = c('trial', 'organism', 'treatment')
names(my_data)
colnames(my_data)
my_data

# Name the elements in a vector
names(animals) = c('Felix', 'Polly', 'Charlotte', 'Kraken', 'Patrick')

# What type of animal is Patrick?
animals['Patrick']

# Name the elements in a list
names(lichen_list) = c('numbers','organisms')
lichen_list

# Access the elements of a list by name
lichen_list[['organisms']]
lichen_list[['organisms']][2]

# YOUR TURN: Extract the organisms associated with odd trial numbers in `my_data`.


# Display the treatment column of my_data
my_data$treatment

# Add a new column to my_data called temp
my_data$temp_C = rep(c(5,10,15,20,25), each=4)
my_data


### Functions

# Display the seq() function
seq

# Display the help file on seq()
?seq

# Make a sequence of numbers from 10 to 20 counting by 5
seq(10, 20, 5)

# Make a sequence of 6 numbers spread evenly between 10 and 20 
seq(10, 20, length.out=6)

# YOUR TURN: Display the help file on `matrix()`. Make a matrix named row_matrix that has 4 rows, 
#            each with the numbers 1 to 5, in order.



## Arithmetic

# Add two numbers
2+3

# Add the first two elements of fingers
fingers[1] + fingers[2]

# Subtraction
monkey = 6 - 2
monkey

# Division'
monkey / 2

# Multiplication
monkey*3

# Exponents
3^2

# Order of operations
5+2*4^2
(5+2)*4^2
5+(2*4)^2

# Create two vectors
troupe = rep(monkey, 7)
troupe
bananas = seq(-3,3)
bananas

# Arithmetic with vectors and scalars
bananas + 3
bananas * 2
bananas^2

# Vector arithmetic
troupe + bananas
troupe - bananas
troupe * bananas
troupe / bananas
troupe^bananas

# YOUR TURN: Add a column to `my_data` called `temp_F` which is the Fahrenheit equivalent of 
#            the Celcius temperature displayed in `temp_C`.



### Let's Review

# YOUR TURN: For each of the following lines of code, write a comment above it describing (briefly) 
#            what it will do. Then, run the line of code to check your answer. Modify your comment if necessary.


















