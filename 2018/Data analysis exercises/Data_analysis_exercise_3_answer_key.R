## Data analysis exercise 2
## BIO46, Winter 2018
## Name:


library(tidyr)
library(dplyr)
library(ggplot2)


# Read in the infection prevalence csv file to a dataframe
infection <- read.table("https://raw.githubusercontent.com/jescoyle/BIO46/master/2018/Data/infection_prevalence.csv", header = TRUE, sep = ",")

# Read in the lichens csv file to a dataframe
lichens <- read.csv("https://raw.githubusercontent.com/jescoyle/BIO46/master/2018/Data/lichens.csv")

########################
## Problem 1

# Read in the site locations csv file to a dataframe
sites <- read.csv("https://raw.githubusercontent.com/jescoyle/BIO46/master/2018/Data/BIO46_2018_sample_sites.csv")

########################

# Plot the locations of the BIO46 sites
ggplot(sites, aes(x = UTM_E, y = UTM_N)) +
  geom_point() +
  coord_fixed() 


# Calculate the proportion of infected lichens at each site
infection <- infection %>%
  mutate(Prop_infected = Num_infected / (Num_infected + Num_healthy))

# Join the site locations and the proportion of infected lichens into a single table
site_data <- left_join(sites, infection, by = "Site")


# Map the site locations colored by the proportion of infected lichens
ggplot(site_data, aes(x = UTM_E, y = UTM_N)) +
  geom_point(aes(color = Prop_infected)) +
  labs(color = "Proportion infected",
       x = "UTM East",
       y = "UTM North"
  ) +
  coord_fixed()


# Map the site locations colored by the proportion of infected lichens

ggplot(site_data, aes(x = UTM_E, y = UTM_N)) +
  geom_point(aes(color = Prop_infected)) +
  scale_color_gradient(low = "blue", high = "red") +
  labs(color = "Proportion infected",
       x = "UTM East",
       y = "UTM North"
  ) +
  coord_fixed()



########################
## Problem 2

# Create a map that shows the number of Evernia prunastri lichens at each site.

ggplot(site_data, aes(x = UTM_E, y = UTM_N)) +
  geom_point(aes(color = Num_Eprunastri)) +
  scale_color_gradient(low = "blue", high = "red") +
  labs(color = "Number of E. prunastri",
       x = "UTM East",
       y = "UTM North"
  ) +
  coord_fixed()

########################


# Add a column indicating whether infected lichens are present
infection <- infection %>%
  mutate(Infection_pres = Num_infected > 0)


# Fit a logistic regression model
mod_infpres <- glm(Infection_pres ~ Num_Eprunastri, 
                   data = infection, 
                   family = binomial(link = "logit")
)

# View the results
summary(mod_infpres)


# Exponentiate the coefficents to see effect on odds
exp(coef(mod_infpres))


# Fit a logistic regression model to the proportion of infected lichens
mod_infprob <- glm(cbind(Num_infected, Num_healthy) ~ Num_Eprunastri, 
                   data = infection, 
                   family = binomial(link = "logit")
)

# View the results
summary(mod_infprob)



########################
## Problem 3

# Write one line of code that shows how the odds of a lichen being infected change with E. prunastri abundance.

exp(coef(mod_infprob))

########################


# Plot the proportion of lichens that are infected along with the fitted model
ggplot(infection, aes(x = Num_Eprunastri, y = Prop_infected)) +
  geom_point() +
  geom_smooth(method = "glm", 
    method.args = list(family = "binomial"), 
    se = TRUE,
    level = 0.95) +
  labs(x = "Number of E. prunastri",
       y = "Proportion of lichens infected"
  )


# Add an Infected column to lichens that is TRUE when there are > 0 ascomata
lichens <- lichens %>%
  mutate(Infected = Ascomata > 0)

# Barplot of the number of infected/uninfected lichens on living/dead substrates
ggplot(lichens, aes(x = Substrate_status)) +
  geom_bar(aes(fill = Infected),
           position = "dodge"
  )

########################
## Challenge 1

# Use `group_by()` and `summarise()` to count the number of lichens that 
# are shown in each of the categories displayed by the bars.

lichens %>%
  group_by(Substrate_status, Infected) %>%
  summarise(Count = n())

########################


# Conduct a chi-square test 
inf_substrate_test = chisq.test(lichens$Substrate_status, lichens$Infected) 

# View the results of the test
inf_substrate_test

########################
## Problem 4

# Create a plot that shows the number of infected lichens found on shrubs versus trees
ggplot(lichens, aes(x = Infected)) +
  geom_bar(aes(fill = Substrate_type),
           position = "dodge"
  )

# Use an appropriate statistical test to determine whether infected lichens occur more frequently on trees versus shrubs.
chisq.test(lichens$Substrate_type, lichens$Infected)

#######################


########################
## Challenge 2. 

# Create a map that shows the average number of ascomata found on a lichen at each site.

# Step 1. Calculate the avergae number of ascomata at each site
lichens_bysite <- lichens %>%
  group_by(Site) %>%
  summarise(Ascomata = mean(Ascomata))

# Step 2. Merge lichens_bysite with site_data
site_data <- left_join(site_data, lichens_bysite)

# Step 3. Create a map with the points colored by Ascomata.
ggplot(site_data, aes(x = UTM_E, y = UTM_N)) +
  geom_point(aes(color = Ascomata)) +
  scale_color_gradient(low = "blue", high = "red") +
  labs(color = "Mean number of ascomata",
       x = "UTM East",
       y = "UTM North"
  ) +
  coord_fixed()

########################

