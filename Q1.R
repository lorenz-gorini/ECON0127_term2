# use this file to write R code for exam question 1

rm(list = ls())
# import
library(tidyverse)
library(ggplot2)
library(tree)
library(randomForest)
library(glmnet)
library(progress)
library(xgboost)
library(Metrics)


# question 1.b
# import data
setwd("/mnt/c/Users/loreg/OneDrive/UCL/Statistical learning/term 2/final exam/ECON0127_statistical_learning_for_public_policy_term3_exam_materials_2022-23/data_for_exam")
raw_income <- read.csv(
    "./Q1/income_data.csv",
    stringsAsFactors = FALSE
)
# Turn the string columns into factors
raw_income <- raw_income %>%
    mutate_if(is.character, as.factor)
# Change boolean outcome variable [0,1] into factor
raw_income$income_group <- as.factor(raw_income$income_group)
# Find the 10 least represented values of native-country
least_represented_countries <- raw_income %>%
    group_by(native.country) %>%
    summarise(count = n()) %>%
    arrange(count) %>%
    head(10)

# remove the rows that have the 10 least represented values of native-country
income_df <- raw_income %>%
    filter(!(native.country %in% least_represented_countries$native.country))

# Lost rows
dim(raw_income)[1] - dim(income_df)[1]

# Data description
summary(income_df)
dim(income_df)
colnames(income_df)

# Count NA values for each column
na_bycol <- income_df %>%
    summarise_all(funs(sum(is.na(.))))
na_bycol

# count unique values for each categorical column
income_df %>%
    select_if(is.factor) %>%
    summarise_all(funs(length(unique(.))))

# =======================================

# Plot "capital-gain" continuous variable against "income_group" categorical variable
ggplot(filter(income_df, capital.gain != 0), aes(x = `income_group`, y = `capital.gain`)) +
    geom_boxplot() +
    geom_jitter(width = 0.2) +
    theme_bw() +
    # Increase size of the text
    theme(text = element_text(size = 20)) +
    # Add title and axis labels
    labs(x = "Income group", y = "Capital gain") +
    ggtitle("Capital gain by income group")

# save plot
ggsave("../answer_sheets/capital_gain.png", width = 10, height = 10)

# Plot "capital-loss" continuous variable against "income_group" categorical variable
ggplot(filter(income_df, capital.loss != 0), aes(x = `income_group`, y = `capital.loss`)) +
    geom_boxplot() +
    geom_jitter(width = 0.2) +
    theme_bw() +
    # Increase size of the text
    theme(text = element_text(size = 20)) +
    # Add title and axis labels
    labs(x = "Income group", y = "Capital loss") +
    ggtitle("Capital loss by income group")

# save plot
ggsave("../answer_sheets/capital_loss.png", width = 10, height = 10)


"
Define formula and a decision tree
"
regressors <- colnames(income_df)

# Remove the outcome variable and "education.num"
regressors <- regressors[!(regressors %in% c("income_group", "education.num"))]

# Define formula
income_formula <- formula(str_c("income_group ~ ", paste(regressors, collapse = "+")))

"
Function that computes R2 given observed y and predicted yhat
"
rsquared <- function(y, yhat) {
    R2 <- 1 - mean((y - yhat)^2) / var(y)
    return(R2)
}

# For some reason, I need to rerun the factor function on all columns
# in order to make the tree function computing the levels of factor columns
#  right and avoid error:
# "factor predictors must have at most 32 levels"

rerun_factor <- function(x) {
    if (is.factor(x)) {
        return(factor(x))
    }
    return(x)
}

# run on all columns of your data
income_df <- as.data.frame(lapply(income_df, rerun_factor))

# Fit a regression tree
income_tree <- tree(income_formula, income_df)
summary(income_tree)
# Evaluate the tree on the dataset
income_tree_pred <- predict(income_tree, income_df)

# Round predictions to 0 or 1
tree_pred_rounded <- round(income_tree_pred[, 2])
# Compute accuracy
tree_accuracy <- Metrics::accuracy(income_df$income_group, tree_pred_rounded)
tree_accuracy
# Compute AUC
tree_auc <- Metrics::auc(income_df$income_group, tree_pred_rounded)

# Plot the tree
plot(income_tree)
text(income_tree, pretty = 1, cex = 1.3)

# ================== Question 1.C =====================
# Split the data into training and test sets (80/20 ratio)
set.seed(123)
training_rows <- sample(1:nrow(income_df), 0.8 * nrow(income_df))
train_data <- income_df[training_rows, ]
test_data <- income_df[-training_rows, ]

# Fit a regression tree
income_tree_cv <- tree(income_formula, train_data)
summary(income_tree_cv)
# Evaluate the tree on the dataset
tree_pred_test <- predict(income_tree_cv, test_data)
# Round predictions to 0 or 1
rounded_pred_test <- round(tree_pred_test[, 2])
# Compute accuracy on test set
print(paste0(
    "Accuracy on test set: ",
    Metrics::accuracy(test_data$income_group, rounded_pred_test)
))
# Compute AUC
print(paste0(
    "AUC on test set: ", Metrics::auc(test_data$income_group, rounded_pred_test)
))

# ================== Question 1.D =====================

library(ipred)
# Fit a regression tree
income_bagg_cv <- bagging(
    income_formula,
    data = train_data, nbagg = 50, coob = FALSE
)
# Evaluate the tree on the dataset
bagg_pred_test <- predict(income_bagg_cv, test_data)
# Compute accuracy on test set
print(paste0(
    "Accuracy on test set: ",
    Metrics::accuracy(test_data$income_group, bagg_pred_test)
))
# Compute AUC
print(paste0(
    "AUC on test set: ", Metrics::auc(test_data$income_group, bagg_pred_test)
))

# ================== Question 1.E =====================

# Explain how you think the test-set performance of the bagging model will vary in the number of individual trees that are estimated.  Verify whether your intuition is validated in this example by recording the test set performance of the bagging model for a variety of choices for the number of trees.  Produce a plot that relates the number of trees on the x-axis to the test-set performance on the y-axis.
# record the test set performance of the bagging model for a variety of choices for the number of trees
# Produce a plot that relates the number of trees on the x-axis to the test-set performance on the y-axis.
# create empty arrays of size MAX_NUM_TREES to store accuracy and AUC
MAX_NUM_TREES <- 30
acc_per_num_trees <- vector(mode = "numeric", length = c(MAX_NUM_TREES))
auc_per_num_trees <- vector(mode = "numeric", length = MAX_NUM_TREES)

for (num_trees in 1:MAX_NUM_TREES) {
    # Fit a regression tree
    income_bagg_cv <- bagging(
        income_formula,
        data = train_data, nbagg = num_trees, coob = FALSE
    )
    # Evaluate the tree on the dataset
    bagg_pred_test <- predict(income_bagg_cv, test_data)
    # Compute accuracy on test set
    acc_per_num_trees[num_trees] <- Metrics::accuracy(
        test_data$income_group, bagg_pred_test
    )
    # Compute AUC
    auc_per_num_trees[num_trees] <- Metrics::auc(
        test_data$income_group, bagg_pred_test
    )
}
# Plot accuracy and auc series per number of trees
plot_df <- data.frame(num_trees = 1:MAX_NUM_TREES, acc = acc_per_num_trees, auc = auc_per_num_trees)
ggplot() +
    geom_line(data = plot_df, aes(x = num_trees, y = acc, color = "red"), linewidth = 2) +
    geom_line(data = plot_df, aes(x = num_trees, y = auc, color = "#1bf77e"), linewidth = 2) +
    theme_bw() +
    # Increase size of the text
    theme(text = element_text(size = 20)) +
    # Add title and axis labels
    labs(x = "Number of trees", y = "Accuracy/AUC", color = "Metric") +
    # show legend
    scale_color_manual(
        name = "Metric",
        values = c("red", "#1bf77e"),
        labels = c("Accuracy", "AUC")
    ) +
    ggtitle("Accuracy and AUC per number of trees") +
    # increase font size of the legend
    theme(text = element_text(size = 25), legend.position = "right", legend.title = element_text(size = 30), legend.text = element_text(size = 25))
    
ggsave("../answer_sheets/accuracy_auc_per_num_trees.png", width = 10, height = 10)
