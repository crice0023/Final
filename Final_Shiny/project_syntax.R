

# Set-up  -----------------------------------------------------------------

# load packages
library(tidyverse)
library(haven)


# link to data:
# https://search.gesis.org/research_data/ZA7500

# link to quiestionnaire:
# https://dbk.gesis.org/dbksearch/download.asp?id=66252




# Import data ------------------------------------------------------------

getwd()

data_raw <- read_dta("C:/Users/ricecakes/Desktop/Git1/Final/Final/ZA7500_v5-0-0.dta")



# make codebook -----------------------------------------------------------


data_labels <- map(data_raw, function(x) attributes(x)$label)

codebook <- tibble(var = names(data_labels),
       label = unlist(data_labels))


# check variables of interest ---------------------------------------------


# v72 - child suffers with working mother (Q25A)
count(data_raw, v72)

# v80 - jobs are scarce: giving...(nation) priority (Q26A)
count(data_raw, v80)


# controls
# id_cocas, country, v225, age, v243_r


# clean data --------------------------------------------------------------


# make lookup table to recode country variable:

cntry_labs <- attributes(data_raw$country)$labels

lookup <- names(cntry_labs)
names(lookup) <- unname(cntry_labs)

# clean all variables of interest
data_clean <- data_raw %>%
  mutate(child_suffer = ifelse(v72 < 0, NA, v72), # code missing
         child_suffer = 4 - child_suffer, # reverse code
         job_national = ifelse(v80 < 0, NA, v80), # code missing
         job_national = 5 - job_national, # reverse code
         cntry = lookup[as.character(data_raw$country)] %>% unname(), # string
         sex = factor(v225, levels = 1:2, labels = c("Male", "Female")), # fct
         age = ifelse(age < 18, NA, age), # code missing
         edu = factor(v243_r, levels = 1:3, # make factor
                      labels = c("Lower", "Medium", "Higher"))) %>%
  select(id_cocas, cntry, child_suffer, job_national, sex, age, edu)



# save data ---------------------------------------------------------------

write_rds(data_clean, "C:/Users/ricecakes/Desktop/Git1/Final/Final/Final_Shiny/data_clean.rds")


# run dynamic report ------------------------------------------------------
# Sample data creation
plot_data <- data.frame(
  age = sample(20:70, 100, replace = TRUE),  # Random ages between 20 and 70
  child_suffer = sample(1:5, 100, replace = TRUE),  # Random scores for child_suffer outcome
  job_national = sample(1:5, 100, replace = TRUE)   # Random scores for job_national outcome
)

# Simulate input from Shiny for testing purpose
input_outcome <- "child_suffer"  # Change this to "job_national" to test the other outcome


library(ggplot2)

# ggplot code adapted for direct execution in RStudio
ggplot(plot_data, aes_string(x = "age", y = input_outcome)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", color = "blue", se = FALSE) +
  labs(title = paste("Exploration of", input_outcome, "by Age"), 
       x = "Age", 
       y = "Level of Agreement") +
  theme_minimal()

summary(data_clean)
data_clean <- na.omit(data_clean)

#shiny code? 
ggplot(plot_data, aes_string(x = "age", y = input$outcome)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", color = "blue", se = FALSE) +
  labs(title = "Exploration of Outcome by Age", x = "Age", y = "Level of Agreement") +
  theme_minimal()
#######################  Testing Section ###########################
data <- readRDS("C:/Users/ricecakes/Desktop/Git1/Final/Final/data_clean.rds")
summary(data)
table(data$cntry)

print(str(data))
print(summary(data))

# Just plot the points
ggplot(data, aes(x = age, y = child_suffer)) + geom_point()

# Just attempt to add the smooth line
ggplot(data, aes(x = age, y = child_suffer)) + geom_smooth(method = "lm")


library(ggplot2)
ggplot(data, aes(x = age, y = child_suffer)) + 
  geom_point() + 
  geom_smooth(method = "lm")

summary(lm(child_suffer ~ age, data = data))



output$outcomePlot <- renderPlot({
  req(input$outcome, input$country)  # Ensure these inputs are not NULL
  plot_data <- filteredData()  # Assuming filteredData is reactive and correct
  print(head(plot_data))  # Debugging line to see the data being used
  if (nrow(plot_data) > 0) {  # Check if the data is not empty
    ggplot(plot_data, aes(x = age, y = !!sym(input$outcome))) +
      geom_point(alpha = 0.6) +
      geom_smooth(method = "lm", color = "blue", se = FALSE)
  }
})


#update.packages(ask = FALSE)
############

library(dplyr)
library(ggplot2)
data_clean <- data_clean %>%
  mutate(job_national = as.factor(job_national))
data_clean <- data_clean %>%
  mutate(child_suffer = as.factor(child_suffer))

ggplot(data_clean, aes(x = job_national, y = age)) +
  geom_boxplot() +
  labs(title = "Age Distribution by job_national Response",
       x = "job_national Response",
       y = "Age") +
  theme_minimal()

ggplot(data_clean, aes(x = job_national, y = age)) +
  geom_violin(trim = FALSE) +
  geom_boxplot(width = 0.1, fill = "white") +  # Adding a narrow boxplot inside for median/quartiles
  labs(title = "Age Distribution by job_national Response",
       x = "job_national Response",
       y = "Age") +
  theme_minimal()
#############################################

#############################################

# deploy things to work in session app
library(rsconnect)
rsconnect::deployApp('Final_Shiny')





#######################
sessionInfo()
