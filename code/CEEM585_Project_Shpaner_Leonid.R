################################################################################
################################ Part One ######################################
############################ Building A Model ##################################
################################################################################

# function for loading necessary libraries and installing them if they have not
# yet been installed

pack <- function(lib){

     new.lib <- lib[!(lib %in% 
                     installed.packages()[, 'Package'])]
   if (length(new.lib)) 
      install.packages(new.lib, dependencies = TRUE)
   sapply(lib, require, character.only = TRUE)

   }

packages <- c('partykit', 'e1071', 'caret', 'corrplot', 'MASS', 'car', 'DT', 
              'ggplot2', 'cowplot', 'ggpubr', 'rms', 'pander', 'ROCR', 'pROC')

pack(packages) # run function

# set working directory by concatenating long string
string1 <- 'C:/Users/lshpaner/OneDrive/Cornell University/Coursework'
string2 <- '/Data Science Certificate Program/CEEM585 '
string3 <- '- Supervised Learning Techniques'

# concatenate each string
working_dir = paste(string1, string2, string3, sep = '')

# set the working directory by calling function
setwd(working_dir) 

# confirm working directory
getwd() 

# In this part of the project, you will focus on building a model to 
# understand who might make a good product technician if hired using linear 
# discriminate analysis logit and ordered logit modeling. The data set you will 
# be using is in the file HRdata2groups.csv, contained in the RStudio instance.  

# 1.	The four performance scores in PerfScore have been mapped into two new 
# categories of Satisfactory and Unsatisfactory under the heading of 
# CollapseScore. Assume that levels 1 and 2 are unacceptable and levels 3 and 4 
# are acceptable. Build a linear discriminant analysis using regression with 
# these two categories as the dependent variable. The purpose of this question 
# is for you to examine the independent variables and conclude which one to 
# include in the regression model. Several are not useful. Remember that when we 
# do this, only the coefficients in the model are useful. You may use the 
# function lm() which has the syntax lm(dependent variable ~ independent 
# variable 1+ independent variable 2+…, data=frame).  This function is part of 
# the package caret: hence you will need to use the command library(caret).  

# Notice that you have a several variables that might be used as independent 
# variables.  You should pick the variables to include based on how effective 
# they are at explaining the variability in the dependent variable as well as 
# which variables might be available should you need to use this model to 
# determine if a candidate is likely to make a good employee. You may assume 
# that the verbal and mechanical scores will be available at the point where a 
# decision about hiring is to be made. In this question, please give us the 
# linear discriminate model you have developed.

# read in the data
hr_data <- read.csv('HRdata2groups.csv')

# Adding column based on other column:
# inspect first five rows of the dataset
datatable(hr_data) 

# cast categorical classes to Performance Score 
hr_data$CollapseScore <- ifelse(hr_data$PerfScoreID >= 3, 'Acceptable', 
                                                          'Unacceptable')
# numerically binarize these performance scores
hr_data$Score <- ifelse(hr_data$CollapseScore == 'Acceptable', 1, 0)
datatable(hr_data, options = list(scrollX = TRUE))

# extract meaningful data (i.e., remove categorical data types)
hr_data_numeric <- subset(hr_data, select = -c(EmpID, CollapseScore, Score))

# create function for plotting histograms to check for near-zero variance 
# in distributions where input `df` is a dataframe of interest
nearzerohist <- function(df, x, y) {
  
   # x rows by y columns & adjust margins
   par(mfrow = c(x, y), mar = c(4, 4, 4, 0)) 
   for (i in 1:ncol(df)){
     hist(df[, i], 
          xlab = names(df[i]), 
          main = paste(names(df[i]), ''), 
          col = 'gray18')
   }  
  
   # check for near zero variance predictors using if-else statement
   nearzero_names <- nearZeroVar(df)  
   if (length(nearzero_names) == 0) {
      print('There are no near-zero variance predictors.')
   } else {
     cat('The following near-zero variance predictors exist:', 
     print(nearzero_names))
   }
}

# call the `nearzerohist()` function
nearzerohist(hr_data_numeric, x = 2, y = 3) 


# function for generating class balance table and barplot
# inputs -->   feat: feature or column of interest
#              title: plot title
#                 x: x-axis label
#                 y: y-axis label

class_balance <- function(feat, title, x, y) {
  
   # check target column's class balance
   # parse target variable into table showcasing class distribution
   feat_table <- table(unname(feat)) # generate table for column
   
   # fix plot margins
   par(mar = c (2, 2, 2, 1)) 
      # plot the counts (values) of each respective class on barplot
   barplot(feat_table, main = title, space = c(0), horiz = FALSE,
           names.arg = c(x, y), 
           col = c('cornflowerblue', 'brown2'))
    
   return (feat_table)
    
}

class_balance(feat = hr_data$CollapseScore, title = 'HR by Class', 
                 x = 'Acceptable', y = 'Unacceptable')

# 2. Explain the variables you decided to use in the model 
# described above and why.    

# create function to plot correlation matrix and establish multicollinearity
# takes one input (df) to pass in dataframe of interest
multicollinearity <- function(df) {
  
      # Examine between predictor correlations/multicollinearity
      corr <- cor(df, use = 'pairwise.complete.obs')
      corrplot(corr, mar = c(0, 0, 0, 0), method = 'color', 
                     col = colorRampPalette(c('#FC0320', '#FFFFFF', 
                                              '#FF0000'))(100), 
                     addCoef.col = 'black', tl.srt = 45, tl.col = 'black', 
                     type = 'lower')
      
      # assign variable to count how many highly correlated
      # variables there exist based on 0.75 threshold
      highCorr <- findCorrelation(corr, cutoff = 0.75)
      
      # find correlated names
      highCorr_names <- findCorrelation(corr, cutoff = 0.75, names = TRUE)
      cat(' The following variables should be omitted:',  
      paste('\n', unlist(highCorr_names)))
    
}      

# determine multicollinearity
multicollinearity(hr_data[c(1:7)])

# use generalized linear model to determine confirm multicollinearity w/ VIF
model_all <- lm(Score ~ . - CollapseScore, data = hr_data) # remove CollapseScore 
                                                           # since it is target
# and we are only interested in comparing between-predictor relationships

# use car library to extract VIF and parse it into a pandoc table using the 
# linear model as a proxy for analysis
pandoc.table(vif(model_all), style = 'simple', split.table = Inf)

# create vector of VIF values for plotting
vif_values <- vif(model_all) 

par(mar = c(7.5, 2, 1, 1)) # fix plot margins
# create column chart to display each VIF value
barplot(vif_values, main = 'VIF Values', horiz = FALSE, col = 'steelblue', 
        las = 2) 

# add vertical line at 5 as after 5 there is severe correlation
abline(h = 5, lwd = 3, lty = 2)   

# create average score since result of both scores creates multicollinearity
hr_data$Aptitude <- rowMeans(hr_data[, c(6, 7)], na.rm = TRUE) 

# create a final dataframe with selected columns of interest for modeling
hr_data_final <- hr_data[, c(3, 5, 8, 9, 10)]

# Re-examine between predictor correlations/multicollinearity
highCorr <- findCorrelation(cor(hr_data_final[c(1, 2, 5)]), cutoff = 0.75, 
                            names = TRUE)
cat(' The following variables should be omitted:',   
paste('\n', unlist(highCorr)))

# create function for plotting correlations between variables  
# inputs: xvar: independent variable, yvar: dependent variable, 
#         title: plot title, xlab: x-axis label, ylab: y-axis label
correl_plot <- function(df, xvar, yvar, title, xlab, ylab) {
  
   ggplot(df, aes(x = xvar, y = yvar)) +
   ggtitle(title) +
   xlab(xlab) + ylab(ylab) +
   geom_point(pch = 1) + ylim(0, 1.25) +
   geom_smooth(method = 'lm', se = FALSE) +
   theme_classic() +
   stat_cor(method = 'pearson', label.x = 0.15, label.y = 0.20) # correl coeff. 
  
}

# create three correlation plots on same grid
plot1 <- correl_plot(hr_data_final, xvar = hr_data_final$EmpStatusID, 
                     yvar = hr_data_final$Score, title = 'Score vs. EmpStatusID', 
                     xlab = 'EmpStatusID', ylab = 'Score')

plot2 <- correl_plot(hr_data_final, xvar = hr_data_final$EmpSatisfaction, 
                     yvar = hr_data_final$Score, 
                     title = 'Score vs. EmpSatisfaction', 
                     xlab = 'EmpSatisfaction', ylab = 'Score')

plot3 <- correl_plot(hr_data_final, xvar = hr_data_final$Aptitude,
                     yvar = hr_data_final$Score, title = 'Score vs. Aptitude',
                     xlab = 'Aptitude', ylab = 'Score')

# plot all correlations together
plot_grid(plot1, plot2, plot3, labels = 'AUTO', ncol = 3, align = '')

par(mar = c(4, 2, 0, 0)) # fix plot margins
# Fit the Linear Discriminant Analysis (LDA) model
lda_fit <- lda(Score ~  EmpStatusID + EmpSatisfaction + Aptitude, 
               data = hr_data_final); lda_fit
plot(lda_fit) # plot the lda model

# 3. The regression model can be used to classify each of the individuals in the 
# dataset. As discussed in the videos, you will need to find the cutoff value 
# for the regression value that separates the unsatisfactory performers from the 
# satisfactory performers. Find this value and determine whether individual 5 is 
# predicted to be satisfactory or not.

# Fit a regression model
reg_model <- lm(Score ~ EmpStatusID + EmpSatisfaction + Aptitude, 
                data = hr_data_final)

# stores the predicted values from the regression function into the variable 
# pred when the regression model has been assigned to the variable reg_model  
pred <- predict(reg_model, hr_data_final) 

# find the mean value of the regression for all observations of unsatisfactory 
# and satisfactory employees
meanunsat <- mean(pred[hr_data_final$Score == 0]) 
meansat <- mean(pred[hr_data_final$Score == 1]) 
cat(' Mean of Satisfactory Results =', meansat, '\n', 
    'Mean of Unsatisfactory Results =', meanunsat, '\n')

# determine the cutoff value
cutoff <- 0.5*(meanunsat + meansat)
cat(' Cutoff Value =', cutoff)
cbind_hrdatafinal <- cbind(hr_data_final, pred)
datatable(cbind_hrdatafinal)

# 4.	Construct a logit model using the two performance groups. Compare this 
# model and the discriminant analysis done in step 1. To construct the logit 
# model, use the function `lrm()` in the library rms. 

# Construct a logit model using the two performance groups
logit <- lrm(Score ~ MechanicalApt + VerbalApt, data = hr_data); logit

# Build an ordered logit model for the full four categories for performance
ologit <- lrm(PerfScoreID ~ Termd + EmpStatusID + EmpSatisfaction, 
              data = hr_data)
ologit
# probability that individual two is in each of the four performance categories
pred_ologit <- predict(ologit, data = hr_data, type = 'fitted.ind')

# inspect the dataframe
pandoc.table(head(pred_ologit), style = 'grid', split.table = Inf, round = 4) 
# get predictions only for second individual
individual2 <- pred_ologit[2, ]; cat('\n') 
par(mar = c(4, 4, 1, 1)) # fix plot margins
plot(individual2, type = 'l', main = 'Predictions for Individual 2', 
     xlab = 'Category', ylab = 'Probability')
pandoc.table(individual2, style = 'simple', split.table = Inf, round = 4)

################################################################################
################################ Part Two ######################################
############## Using Naïve Bayes to Predict a Performance Score ################
################################################################################

# In this part of the project, you will use naïve Bayes to predict a performance 
# score. This part continues the scenario from Part One and uses the same 
# modified version of the human resources data set available on the Kaggle 
# website. The data set you will be using is in the file `NaiveBayesHW.csv` 
# file. Over the course of this project, your task is to gain insight into who 
# might be a “high” performer if hired.

# 1.	Using only the mechanical aptitude score, use naïve Bayes to predict the 
# performance score for each employee. Professor Nozick discretized the 
# mechanical scores into four classes. Notice only three of four classes have 
# observations. This discretization is in the data file `NaiveBayesHW.csv`. The 
# function to create the model is `naiveBayes()`. 

naive_df <- read.csv('NaiveBayesHW.csv') # read in the dataset

# inspect the dataset
datatable(naive_df) 

# assign the naivebayes function to a new variable
nbmodel <- naiveBayes(PerfScore ~ MechanicalApt, data = naive_df)
print(nbmodel)

# predict the naive bayes model
# type = raw' specifies that R should return the probability that a point is in 
# each risk group. Not specifying a type would print the most likely category 
# that each point would fall into. 

pred_bayes <- predict(nbmodel, naive_df, type = 'raw')  
head(pred_bayes, 20) # inspect the first 10 rows

# 2.	Using this modeling approach, what is your assessment of the probability 
# that individual 10 will evolve into each of the four probability classes if 
# hired? This can be done using the model created above and the `pred()` 
# function. The arguments for that function are the model name, data and for 
# type use “raw”. This question is parallel to the Practice using Naïve Bayes 
# activity you completed in R.

# table the probabilities of each respective class for the individual
# get the 10th row only
individual10 <- pred_bayes[10, ] 
# assign to a dataframe
individual10 <- data.frame(individual10) 
# rename the column
colnames(individual10) <- c('Probability') 
# show the table
individual10 

################################################################################
############################### Part Three #####################################
####################### Building Classification Trees ##########################
################################################################################

# In this part of the project, you will build classification trees. This part 
# continues the scenario from Parts One and Two, as it uses the same modified 
# version of the human resources data set available on the Kaggle website. Use 
# the `HRdata4groups.csv` data set to predict each individual's performance 
# (Performance Score ID) using classification trees. In the space below, you 
# will explain the model you have developed and describe how well it performs.

# 1.	In the space below, explain the model you developed. It is sufficient to 
# use the function `ctree()` in R to accomplish this in the style of the codio 
# exercise Practice: Building a Classification Tree in R—Small Example.

hrdata_groups <- read.csv('HRdata4groups.csv') # read in the dataset

# inspect the first five rows of the dataset
datatable(hrdata_groups, options = list(scrollX = TRUE)) 

str(hrdata_groups) # print out the structure of the dataframe

# Examine between predictor correlations/multicollinearity
highCorr <- findCorrelation(cor(hrdata_groups[c(-2)]), cutoff = 0.75, 
                            names = TRUE)
cat(' The following variables should be omitted: \n', paste(unlist(highCorr)))

# create aptitude from averaged MechanicalApt and VerbalApt scores
hrdata_groups$Aptitude <- rowMeans(hrdata_groups[, c(9, 10)], na.rm = TRUE)
# mechanical aptitude, and verbal aptitude are omitted
hrgroups_final <- hrdata_groups[, c(-9, -10)] # finalize dataframe for modeling

# Re-examine between predictor correlations/multicollinearity
highCorr <- findCorrelation(cor(hrgroups_final[, c(-2)]), cutoff = 0.75, 
                            names = TRUE)
cat(' The following variables should be omitted:', '\n',  
paste(unlist(highCorr)))

# build the classification tree
ctout <- ctree(PerfScoreID ~ ., data = hrgroups_final) 
ctout 

# predict the performance score based on all input features of final df
ctpred <- predict(ctout, hrgroups_final)

# Check the percentage of time that the classification tree correctly classifies 
# a data point
cat('Correct Classification of Data Point:', 
    mean(ctpred == hrgroups_final$PerfScoreID)) 
plot(ctout) # plot the classification tree

# 2. In the space below, describe how well your model performs. 

################################################################################
############################### Part Four ######################################
####################### Building Classification Trees ##########################
################################################################################

# In this part of the project, you will apply SVM to a data set. The RStudio 
# instance contains the file `acquisitionacceptanceSVM.csv`, which includes 
# information about whether or not homeowners accepted a government offer to 
# purchase their home. 

# 1.	Apply the tool SVM to the acquisition data set in the CSV file 
# `acquisitionacceptanceSVM.csv` to predict which homeowners will most likely 
# accept the government’s offer. What variables did you choose to use in your 
# analysis?

acquisition <- read.csv('acquisitionacceptanceSVM.csv') # read in the dataset

# inspect the dataframe
datatable(acquisition, options = list(scrollX = TRUE)) 

str(acquisition) # obtain the structure of the dataframe

nearzerohist(acquisition[c(-12)], x = 4, y = 3)

multicollinearity(acquisition)

acquisition$Accept <- as.factor(acquisition$Accept)
acquisition$Accept <- ifelse(acquisition$Accept == 1, 'Accept', 'Not Accept')
acquisition$Accept <- as.factor(acquisition$Accept) 

set.seed(222) # set seed for reproducibility

# Use 70% of dataset as training set and remaining 30% as testing set
sample <- sample(c(TRUE, FALSE), nrow(acquisition), replace = TRUE, 
                 prob = c(0.7, 0.3))
train_acquisition <- acquisition[sample, ] # training set
test_acquisition <- acquisition[!sample, ] # test set

cat(' Training Dimensions:', dim(train_acquisition),
    '\n Testing Dimensions:', dim(test_acquisition), '\n',
    '\n Training Dimensions Percentage:', round(nrow(train_acquisition) /
                                                nrow(acquisition), 2),
    '\n Testing Dimensions Percentage:', round(nrow(test_acquisition) /
                                               nrow(acquisition), 2))

predictors <- train_acquisition[, c(-12)] # extract ind. var. from train set
target <- train_acquisition[, c(12)] # extract dep. var. from train set
target <- as.factor(target) # cast target as factor

# Support Vector Machines via caret
model_svm  <- train(predictors, target, method = 'svmLinear', verbose = FALSE)

# plot the variable importance
svm_varimp <- varImp(object = model_svm)
ggplot2::ggplot(varImp(object = model_svm)) + 
  ggtitle('SVM - Variable Importance') + 
  scale_y_continuous(expand = c(0, 0)) +
  theme_classic() +
  theme(plot.margin = unit(c(1, 1, 0, 0), 'cm')) +
  theme(axis.text = element_text(color = 'black'),
        axis.title = element_text(color = 'black'))

train_df <- train_acquisition[, c(8, 11, 12)]
test_df <- test_acquisition[, c(8, 11, 12)]

# column names of df to confirm cols
pandoc.table(colnames(train_df), type = 'simple') 

# tune the support vector machine, optimizing the hyperparameters
# of gamma, cost, and epsilon
set.seed (222) # set seed for reproducibility
tune.out <- tune(svm, Accept ~ Price75 + Price125, data = train_df, 
                 ranges = list(cost = 10 ^ seq(-3, 3), 
                               kernel = c('linear', 'polynomial', 
                                          'radial')))

bestparam <- tune.out$best.parameters # best hyperparamaters
bestmod <- tune.out$best.model # best model based on tuning parameters
bestparam  # print out the best hyperparamaters
summary(tune.out)

# Construct Soft Margin SVM
acquisition_result <- svm(Accept ~ Price125 + Price75, kernel = 'linear', 
                          gamma = 0.001, cost = 0.01, epsilon = 0, 
                          data = train_df, decision.values = TRUE)
print(acquisition_result)

# Visualize the SVM decision boundary using only the training data using price75
# and price125 as features
plot(acquisition_result, data = train_df)

# create function for outputting a confusion matrix in a pandoc-style format
# where inputs --> df1: model df
#                  df2: dataset
#                  feat: target column
#                  x: H0  column (i.e., 'yes', 'accept' '1', etc.)
#                  y: H1  column (i.e., 'no', 'not accept', '0', etc.)
#                  custom_name: any string you want to pass into table name
      
conf_matrix <- function (df1, df2, feat, x, y, custom_name) {
  
    prediction <- predict(df1, newdata = df2)
    # Evaluate the model on the training data and inspect first six rows
    pred_table <- table(prediction, feat)
    # print out pander-grid-style table with performance results
    metrics <- c(x, y)
    h0 <- c(pred_table[1], pred_table[2])
    h1 <- c(pred_table[3], pred_table[4])
    # create table as dataframe from above variables
    table <- data.frame(metrics, h0, h1)
    # change column names of table
    colnames(table) <- c('\n', x, y)
    table %>% pander(style = 'simple', justify = c('center'),
                     caption = sprintf('Confusion Matrix for %s', 
                                                       custom_name))

}

conf_matrix(df1 = acquisition_result, df2 = train_df, feat = train_df$Accept, 
             x = 'Accept', y = 'Not Accept', custom_name = 'Train Set')

conf_matrix(df1 = acquisition_result, df2 = test_df, feat = test_df$Accept, 
             x = 'Accept', y = 'Not Accept', custom_name = 'Test Set')

# 
#
#
#
# create function for calculating model performance metrics that takes in the 
# following inputs --> df1: model df
#                      df2: dataset
#                      feat: target column
#                      custom_name: any string you want to pass into table name
#

perf_metrics <- function(df1, df2, feat, custom_name) {
  
   prediction <- predict(df1, newdata = df2)
   # Evaluate the model on the training data and inspect first six rows
   df <- table(prediction, feat)  
  
   tp <- df[1] # position of true positives
   tn <- df[4] # position of true negatives
   fp <- df[3] # position of false positives
   fn <- df[2] # position of false negatives
  
   # calculate model performance metrics
   accuracy <- round((tp + tn)/(tp + tn + fp + fn),2) # calculate accuracy
   spec <- round((tp) / (tp + fp),2) # calculate specificity (precision)
   sens <- round((tp) / (tp + fn),2) # calculate sensitivity (recall)
   f1 <- round((tp) / (tp+0.5*(fp+fn)),2) # calculate f1-score

   # print out pander-grid-style table with performance results
   metrics <- c('Accuracy', 'Specificity', 'Sensitivity', 'F1-Score')
   values <- c(accuracy, spec, sens, f1)
   table <- data.frame(Metric = metrics, Value = values)
   table %>% pander(style = 'simple', justify = c('center'),
                    caption = sprintf('Performance Metrics for %s', custom_name))
  
}

# call the `perf_metrics` function to establish performance metrics for train set
perf_metrics(df1 = acquisition_result, df2 = train_df, feat = train_df$Accept,
             custom_name = 'Training Set')

# call the `perf_metrics` function to establish performance metrics for test set
perf_metrics(df1 = acquisition_result, df2 = test_df, feat = test_df$Accept, 
             custom_name = 'Test Set')

# 2. How good was your model at correctly predicting who would and who would not
# accept the offer?

test_prob  <- predict(acquisition_result, test_df, type = 'decision')
pr <-prediction(as.numeric(test_prob), as.numeric(test_df$Accept))
prf <- performance(pr, measure = 'tpr', x.measure = 'fpr')
test_roc <- roc(test_df$Accept ~ as.numeric(test_prob), print.auc = TRUE)
auc <- round(as.numeric(test_roc$auc), 2); par(mar = c (4, 4, 2, 1)) 
plot(prf, main = 'SVM ROC Curve', col = 'red', xlab = 'False Positive Rate',
                                               ylab = 'True Positive Rate')
abline(0, 1, col = 'black', lty = 2, lwd = 1)
legend(0.73, 0.2, legend = paste('AUC =', rev(auc)), lty = c(1), col = c('red'))

# 3.	When building models, we often use part of the data to estimate the model 
# and use the remainder for prediction. Why do we do this? It is not necessary 
# to do this for each of the problems above. It is essential to realize that you
# will need to do this in practice.

