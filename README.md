## Supervised Learning Techniques Course Project

## Part One
### Building A Model

In this project, you will: 
- Use linear discriminant analysis.  
- Build a logit model and an ordered logit model.  
- Examine Naïve Bayes for classification.  
- Examine how to use support vector machines.  
- Develop the skills to use all these techniques in R.

In this part of the project, you will focus on building a model to understand who might make a good product technician if hired using linear discriminate analysis logit and ordered logit modeling. The data set you will be using is in the file `HRdata2groups.csv`, contained in the RStudio instance.  

<ol start="1">

<li> The four performance scores in `PerfScore` have been mapped into two new categories of Satisfactory and Unsatisfactory under the heading of `CollapseScore`. Assume that levels 1 and 2 are unacceptable and levels 3 and 4 are acceptable. Build a linear discriminant analysis using regression with these two categories as the dependent variable. The purpose of this question is for you to examine the independent variables and conclude which one to include in the regression model. Several are not useful. Remember that when we do this, only the coefficients in the model are useful. You may use the function `lm()` which has the syntax   This function is part of the package caret: hence you will need to use the command `library(caret)`.  

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
<br>

**The employee’s hiring status (`EmpStatusID`) in conjunction with the employee’s satisfaction (`EmpSatisfaction`) and average aptitude score are used in the model.** 

**Averaging the mechanical and verbal scores row over row creates a new (`Aptitude`) column with these values. Mechanical and verbal aptitude scores are omitted because of their high between-predictor relationships. `MechanicalApt` vs. `VerbalApt` yields an *r* = 0.96. Once the scores are averaged and passed into one column, the problem of multicollinearity is removed. `Termd` is also omitted because its correlation with EmpStatusID is *r* = 0.96.**

<p align = "center">
<img src = "https://github.com/lshpaner/CEEM585_Supervised_Learning_Techniques_in_R/blob/main/code/figs/unnamed-chunk-16-1.png" >
</p>


<li> The regression model can be used to classify each of the individuals in the dataset. As discussed in the videos, you will need to find the cutoff value for the regression value that separates the unsatisfactory performers from the satisfactory performers. Find this value and determine whether individual 5 is predicted to be satisfactory or not.   
     
In R you can use the predict command to use the regression function with the data associated with each individual in the dataset. For example:  `pred=predict(model, frame)` stores the predicted values from the regression function into the variable pred when the regression model has been assigned to the variable model as in this statement: `model <-lm(dependent variable ~ independent variable 1+ independent variable 2+…, data=frame).` 
    
You may then find the mean value of the regression for all observations of unsatisfactory employees using the command `meanunsat=mean(pred[frame$CollapseScore==0])`.  

The cutoff value is then computed in r as follows: `cutoff<-0.5(meanunsat+meansat)`.   
    
If you want to compare what your model says verses whether they were found to be satisfactory or unsatisfactory you may add the prediction to the data frame using `cbind(frame, pred)`. This will make the predictions part of the dataset. </li>
<br>

<table class="tg">
<thead>
  <tr>
    <th class="tg-3xi5" colspan="7">    <span style="color:#CB0000">  </span><span style="color:#3531FF">Mean of Satisfactory Results = 0.9340495</span><br><span style="color:#3531FF">                                  Mean of Unsatisfactory Results = 0.5401660                                </span><br><span style="color:#3531FF">                                Cutoff Value = 0.7371078</span></th>
  </tr>
</thead>
<tbody>
  <tr>
    <td class="tg-7g6k">Individual #</td>
    <td class="tg-tsde">EmpStatusID</td>
    <td class="tg-tsde">EmpSatisfaction</td>
    <td class="tg-tsde">CollapseScore</td>
    <td class="tg-tsde">Score</td>
    <td class="tg-tsde">Aptitude</td>
    <td class="tg-ytai">Preds</td>
  </tr>
  <tr>
    <td class="tg-3xi5">1</td>
    <td class="tg-3xi5">1</td>
    <td class="tg-3xi5">5</td>
    <td class="tg-3xi5">Acceptable</td>
    <td class="tg-3xi5">1</td>
    <td class="tg-3xi5">180.9</td>
    <td class="tg-5w3z">1.315</td>
  </tr>
  <tr>
    <td class="tg-3xi5">2</td>
    <td class="tg-3xi5">1</td>
    <td class="tg-3xi5">3</td>
    <td class="tg-3xi5">Acceptable</td>
    <td class="tg-3xi5">1</td>
    <td class="tg-3xi5">106.7</td>
    <td class="tg-5w3z">0.7863</td>
  </tr>
  <tr>
    <td class="tg-3xi5">3</td>
    <td class="tg-3xi5">5</td>
    <td class="tg-3xi5">4</td>
    <td class="tg-3xi5">Acceptable</td>
    <td class="tg-3xi5">1</td>
    <td class="tg-3xi5">152.3</td>
    <td class="tg-5w3z">1.104</td>
  </tr>
  <tr>
    <td class="tg-3xi5">4</td>
    <td class="tg-3xi5">1</td>
    <td class="tg-3xi5">2</td>
    <td class="tg-3xi5">Unacceptable</td>
    <td class="tg-3xi5">0</td>
    <td class="tg-3xi5">46.99</td>
    <td class="tg-5w3z">0.3852</td>
  </tr>
  <tr>
    <td class="tg-5w3z">5</td>
    <td class="tg-5w3z">1</td>
    <td class="tg-5w3z">5</td>
    <td class="tg-5w3z">Unacceptable</td>
    <td class="tg-5w3z">0</td>
    <td class="tg-5w3z">41.87</td>
    <td class="tg-qhnr">0.4715</td>
  </tr>
  <tr>
    <td class="tg-3xi5">6</td>
    <td class="tg-3xi5">1</td>
    <td class="tg-3xi5">4</td>
    <td class="tg-3xi5">Acceptable</td>
    <td class="tg-3xi5">1</td>
    <td class="tg-3xi5">131.6</td>
    <td class="tg-5w3z">0.9764</td>
  </tr>
</tbody>
</table>




