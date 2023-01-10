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

<center>
<!-- HTML generated using hilite.me --><div style="background: #f8f8f8; overflow:auto;width:fit-content;border-width:.1em .1em .1em .8em;padding:.0em .0em;"><pre style="margin: 0; text-align: left; line-height: 125%"><span style="color: #000000">Call:</span>
<span style="color: #000000">lda(Score ~ EmpStatusID + EmpSatisfaction + Aptitude, data = hr_data_final)</span>

<span style="color: #000000">Prior probabilities of groups:</span>
<span style="color: #000000">        0         1 </span>
<span style="color: #000000">0.1088083 0.8911917 </span>

<span style="color: #000000">Group means:</span>
<span style="color: #000000">  EmpStatusID EmpSatisfaction  Aptitude</span>
<span style="color: #000000">0    3.095238        3.238095  64.41122</span>
<span style="color: #000000">1    2.691860        3.970930 124.64620</span>

<span style="color: #000000">Coefficients of linear discriminants:</span>
<span style="color: #000000">                       LD1</span>
<span style="color: #000000">EmpStatusID     0.00271593</span>
<span style="color: #000000">EmpSatisfaction 0.25572719</span>
<span style="color: #000000">Aptitude        0.03966111</span>
</pre></div>

</center>  
<br>

<li> Explain the variables you decided to use in the model described above and why.  </li>

**The employee’s hiring status (`EmpStatusID`) in conjunction with the employee’s satisfaction (`EmpSatisfaction`) and average aptitude score are used in the model.** 

**Averaging the mechanical and verbal scores row over row creates a new (`Aptitude`) column with these values. Mechanical and verbal aptitude scores are omitted because of their high between-predictor relationships. `MechanicalApt` vs. `VerbalApt` yields an *r* = 0.96. Once the scores are averaged and passed into one column, the problem of multicollinearity is removed. `Termd` is also omitted because its correlation with EmpStatusID is *r* = 0.96.**

<img src = "https://github.com/lshpaner/CEEM585_Supervised_Learning_Techniques_in_R/blob/main/code/figs/unnamed-chunk-16-1.png" >








