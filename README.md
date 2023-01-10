## Supervised Learning Techniques Course Project

## Part One
### Building A Model

In this project, you will: 
- Use linear discriminant analysis.  
- Build a logit model and an ordered logit model.  
- Examine naïve Bayes for classification.  
- Examine how to use support vector machines.  
- Develop the skills to use all these techniques in R.

In this part of the project, you will focus on building a model to understand who might make a good product technician if hired using linear discriminate analysis logit and ordered logit modeling. The data set you will be using is in the file `HRdata2groups.csv`, contained in the RStudio instance.  

<ol start="1">

<li> The four performance scores in `PerfScore` have been mapped into two new categories of Satisfactory and Unsatisfactory under the heading of `CollapseScore`. Assume that levels 1 and 2 are unacceptable and levels 3 and 4 are acceptable. Build a linear discriminant analysis using regression with these two categories as the dependent variable. The purpose of this question is for you to examine the independent variables and conclude which one to include in the regression model. Several are not useful. Remember that when we do this, only the coefficients in the model are useful. You may use the function `lm()` which has the syntax `lm(dependent variable ~ independent variable 1+ independent variable 2+…, data=frame)`.  This function is part of the package caret: hence you will need to use the command `library(caret)`. 

Notice that you have a several variables that might be used as independent variables.  You should pick the variables to include based on how effective they are at explaining the variability in the dependent variable as well as which variables might be available should you need to use this model to determine if a candidate is likely to make a good employee. You may assume that the verbal and mechanical scores will be available at the point where a decision about hiring is to be made. In this question, please give us the linear discriminate model you have developed. </li>

**The dataset is inspected and the categorical classes of <font color="black"> ``Acceptable`` </font> and <font color="black"> ``Unacceptable`` </font> are cast to the Performance Score (<font color="black"> ``PerfScoreID`` </font>) in a new column named <font color="black"> ``CollapseScore`` </font>. However, since supervised learning models need to learn from a numerical, though, binarized target column, a new column of <font color="black"> ``Score`` </font> is thus created. Extraneous or otherwise not useful columns like <font color="black"> ``Employee ID`` </font>, <font color="black"> ``CollapseScore`` </font>, and <font color="black"> ``Score`` </font> are removed such that a numerical only dataframe is created for subsequent distribution analysis. </font>**

**The histogram distributions below do not yield or uncover any near-zero-variance predictors, but it is worth noting that <font color="black"> ``Termd`` </font>  has only two class labels. <font color="black"> ``MechanicalApt`` </font> and <font color="black"> ``VerbalApt`` </font>  exhibit normality; other variables approach the same trend. </font>**