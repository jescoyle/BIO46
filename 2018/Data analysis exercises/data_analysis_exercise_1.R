## Data analysis exercise 1
## BIO46, Winter 2018
## Name:


# Add 5 and 4
5 + 4

# Install packages- only run once
install.packages("googlesheets")
install.packages("ggplot2")
 
# Load packages
library(googlesheets)
library(ggplot2)
 

# Authorize googlesheets to access you Google Drive
gs_auth()

# Register the lichens data table
lichens_gs <- gs_url("https://docs.google.com/spreadsheets/d/11d3-k-3OaIOfm8EfneUiNGiumfPBdMBHMViaTbVtzwY/edit?usp=sharing")

# View the information stored in the lichens_gs object
lichens_gs

# Read the lichens_gs googlesheet into R
lichens <- gs_read(lichens_gs)

########################
## Problem 1 

install.packages(    )
install.packages(    )
library(    )
library(    )

########################

# Subset lichens to only those used in the growth experiment. Make a new data
lichens_grw <- lichens %>%
  filter(Experiment == "growth")

# View the contents of lichens_grw
lichens_grw

# Create a histogram
lichens_grw %>%
  ggplot(aes(x = Mass_mg_init)) +
    geom_histogram(binwidth = 10) +
    labs(x = "Initial mass (mg)",
         y = "Number of lichens"
    )

########################
## Problem 2 



########################

########################
## Problem 3 



########################


# Create a scatterplot
lichens_grw %>%
  ggplot(aes(x = Mass_mg_init, y = Ascomata)) +
    geom_point() +
    labs(x = "Initial mass (mg)",
         y = "Number of ascomata"
    )

# Fit a linear regression model with Ascomata as the respose (y variable) and Mass_mg_init as the predictor (x variable). 
asco_vs_mass <- lm(Ascomata ~ Mass_mg_init, data = lichens_grw)

# View the results of the linear regression
summary(asco_vs_mass)

# Create a scatterplot
lichens_grw %>%
  ggplot(aes(x = Mass_mg_init, y = Ascomata)) +
    geom_point() +
    geom_smooth(method = "lm",
                se = TRUE,
                level = 0.95) +
    labs(x = "Initial mass (mg)",
         y = "Number of ascomata"
    )


########################
## Problem 4 



########################