# Load necessary libraries
library(dplyr)
library(tidyr)
library(caret)
library(e1071)

# Load movie rating dataset
movies <- read.csv("movies.csv")

# Split data into training and testing sets
set.seed(123)
split <- createDataPartition(movies$Genre, p = 0.8, list = FALSE)
train <- movies[split, ]
test <- movies[-split, ]

# Create a formula for our model
formula <- as.formula("Genre ~ .")

# Train the model using SVM
svmModel <- train(formula, data = train, method = "svmRadial", trControl = trainControl(method = "cv", number = 5), preProcess = c("center", "scale"))

# Predict movie genres for test data
predictions <- predict(svmModel, newdata = test)

# Evaluate the model using confusion matrix
confusionMatrix(predictions, test$Genre)