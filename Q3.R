# use this file to write R code for exam question 3
setwd("/mnt/c/Users/loreg/OneDrive/UCL/Statistical learning/term 2/final exam/ECON0127_statistical_learning_for_public_policy_term3_exam_materials_2022-23/data_for_exam")
rm(list = ls())
# import
library(tidyverse)
library(ggplot2)
library(mixtools)

# question 3.a
# import data
raw_trance <- read.csv(
    "./Q3/trance.csv",
    stringsAsFactors = FALSE
)
summary(raw_trance)


# Check for missing values per column
na_bycol <- raw_trance %>%
    summarise_all(funs(sum(is.na(.))))
na_bycol

total_counts <- colSums(raw_trance[, 6:10])
total <- sum(total_counts)
total_frequencies <- total_counts / total

total_likelihood <- 1
for (i in 1:5) {
    total_likelihood <- total_likelihood * (total_frequencies[i] ^ total_counts[i])
}
print(total_likelihood)

# =================== Question 3.C ====================
"
Estimate model
"
trance_matrix <- t(as.matrix(raw_trance[,6:10]))
set.seed(1234)
mm_model <- multmixEM(trance_matrix, k = 2, verb = TRUE)


"
Inspect thetas - the distributions over activities
"
## Extract thetas
thetas <- mm_model$theta

# Create a dataframe to analyse these different distributions
theta_df <- raw_trance
theta_df["type1"] <- thetas[1, ]
theta_df["type2"] <- thetas[2, ]

# =================== Question 3.D ====================
# Event type distributions
theta_df %>%
    group_by(age_group) %>%
    summarise(type1 = sum(type1), type2 = sum(type2)) %>%
    ggplot() +
    theme_bw() +
    geom_point(aes(y = age_group, x = type1, color = "Type 1"), size=5) +
    geom_point(aes(y = age_group, x = type2, color = "Type 2"), size=5) +
    labs(y = "Age group", x="") +
    scale_color_manual(values = c("Type 1" = "red", "Type 2" = "blue")) +
    theme(text = element_text(size = 25))
ggsave("../answer_sheets/age_group.png", width = 10, height = 10)
# by Gender
theta_df %>%
    group_by(Gender) %>%
    summarise(type1 = sum(type1), type2 = sum(type2)) %>%
    ggplot() +
    theme_bw() +
    geom_point(aes(y = Gender, x = type1, color = "Type 1"), size=5) +
    geom_point(aes(y = Gender, x = type2, color = "Type 2"), size=5) +
    labs(y = "Gender", x="") +
    scale_color_manual(values = c("Type 1" = "red", "Type 2" = "blue")) +
    theme(text = element_text(size = 25))
ggsave("../answer_sheets/Gender.png", width = 10, height = 10)

theta_df %>%
    group_by(city_or_village) %>%
    summarise(type1 = sum(type1), type2 = sum(type2)) %>%
    ggplot() +
    theme_bw() +
    geom_point(aes(y = city_or_village, x = type1, color = "Type 1"), size=5) +
    geom_point(aes(y = city_or_village, x = type2, color = "Type 2"), size=5) +
    labs(y = "city_or_village", x="") +
    scale_color_manual(values = c("Type 1" = "red", "Type 2" = "blue")) +
    theme(text = element_text(size = 25))
ggsave("../answer_sheets/city_or_village.png", width = 10, height = 10)

# =================== Question 3.E ====================
