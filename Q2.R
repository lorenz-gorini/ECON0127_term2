# use this file to write R code for exam question 2
rm(list = ls())

# Random data generation
x <- runif(500, -5, 5)
y <- x - 0.3 * x^2 + 6 * x^3 - 0.4 * x^5

library(ggplot2)
ggplot(data.frame(x = x, y = y), aes(x, y)) +
    geom_line()

# KERAS
library(keras)

model <- keras_model_sequential() %>%
    layer_dense(5, activation = "relu", input_shape = 1) %>%
    layer_dense(1)

summary(model)

model2 <- keras_model_sequential() %>%
    layer_dense(1, activation = "sigmoid", input_shape = 1)
summary(model2)

model2 %>% compile(
    optimizer = "rmsprop",
    loss = "mse", # mean squared error
    metrics = "mae" # mean absolute error
)

history <- model2 %>% fit(x, y, epochs = 1000, batch_size = 50)
plot(history)
# Compare the model predictions to the true values
y_pred_2 <- model2 %>% predict(x)
ggplot(data.frame(x = x, y = y, y_pred = y_pred_2), aes(x, y)) +
    geom_line() +
    geom_line(aes(y = y_pred_2), color = "red") +
    # increase font size
    theme(text = element_text(size = 35))
ggsave("../answer_sheets/one_layer_preds.png", width = 10, height = 10)


model3 <- keras_model_sequential() %>%
    layer_dense(
        50000, activation = "relu", input_shape = 1
    ) %>%
    layer_dense(1)

summary(model3)

model3 %>% compile(
    optimizer = "rmsprop",
    loss = "mse", # mean squared error
    metrics = "mae" # mean absolute error
)

history <- model3 %>% fit(x, y, epochs = 700, batch_size = 50)
plot(history)

# Compare the model predictions to the true values
y_pred_3 <- model3 %>% predict(x)
ggplot(data.frame(x = x, y = y, y_pred = y_pred_3), aes(x, y)) +
    geom_line() +
    geom_line(aes(y = y_pred_3), color = "red") +
    # increase font size
    theme(text = element_text(size = 35))
ggsave("../answer_sheets/nn_preds.png", width = 10, height = 10)
