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

# Save the model
save(svmModel, file = "movie_genre_model.RData")

# Load the model
load("movie_genre_model.RData")

# Print the accuracy of the model
print(paste("Accuracy of the model:", round(100*sum(predictions == test$Genre)/length(predictions), 2), "%"))

# Save the model plot
png("svm_model_plot.png")
plot(svmModel)
dev.off()

# Load the model plot
svmPlot <- readPNG("svm_model_plot.png")

# Show the model plot
library(grid)
grid.raster(svmPlot, interpolate=TRUE)
