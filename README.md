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

<ol start="1"> <li>   

The four performance scores in `PerfScore` have been mapped into two new categories of Satisfactory and Unsatisfactory under the heading of `CollapseScore`. Assume that levels 1 and 2 are unacceptable and levels 3 and 4 are acceptable. Build a linear discriminant analysis using regression with these two categories as the dependent variable. The purpose of this question is for you to examine the independent variables and conclude which one to include in the regression model. Several are not useful. Remember that when we do this, only the coefficients in the model are useful. You may use the function `lm()` which has the syntax `lm(dependent variable ~ independent variable 1+ independent variable 2+…, data=frame)`.  This function is part of the package caret: hence you will need to use the command `library(caret)`.  

Notice that you have a several variables that might be used as independent variables.  You should pick the variables to include based on how effective they are at explaining the variability in the dependent variable as well as which variables might be available should you need to use this model to determine if a candidate is likely to make a good employee. You may assume that the verbal and mechanical scores will be available at the point where a decision about hiring is to be made. In this question, please give us the linear discriminate model you have developed.  
</li> </li>

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
    <td class="tg-5w3z">0.786</td>
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
    <td class="tg-5w3z">0.385</td>
  </tr>
  <tr>
    <td class="tg-5w3z">5</td>
    <td class="tg-5w3z">1</td>
    <td class="tg-5w3z">5</td>
    <td class="tg-5w3z">Unacceptable</td>
    <td class="tg-5w3z">0</td>
    <td class="tg-5w3z">41.87</td>
    <td class="tg-qhnr">0.471</td>
  </tr>
  <tr>
    <td class="tg-3xi5">6</td>
    <td class="tg-3xi5">1</td>
    <td class="tg-3xi5">4</td>
    <td class="tg-3xi5">Acceptable</td>
    <td class="tg-3xi5">1</td>
    <td class="tg-3xi5">131.6</td>
    <td class="tg-5w3z">0.976</td>
  </tr>
</tbody>
</table>

**Individual 5 has unacceptable/unsatisfactory performance, and the model predicts the same with a probability of 0.471, which is below the cutoff of 0.737.**

<li>  

Construct a logit model using the two performance groups. Compare this model and the discriminant analysis done in step 1. To construct the logit model, use the function `lrm()` in the library rms. 

</li>

<center> 

<!-- HTML generated using hilite.me --><div style="background: #f8f8f8; overflow:auto;width:fit-content;border-width:.1em .1em .1em .8em;padding:.0em .0em;"><pre style="margin: 0; text-align: left; line-height: 125%"><span style="color: #000000">Logistic Regression Model</span>
<span style="color: #000000"> </span>
<span style="color: #000000"> lrm(formula = Score ~ MechanicalApt + VerbalApt, data = hr_data)</span>
<span style="color: #000000"> </span>
<span style="color: #000000">                        Model Likelihood     Discrimination    Rank Discrim.    </span>
<span style="color: #000000">                              Ratio Test            Indexes          Indexes    </span>
<span style="color: #000000"> Obs           193    LR chi2     109.40     R2       0.870    C       0.991    </span>
<span style="color: #000000">  0             21    d.f.             2     R2(2,193)0.427    Dxy     0.983    </span>
<span style="color: #000000">  1            172    Pr(&gt; chi2) &lt;0.0001    R2(2,56.1)0.852    gamma   0.983    </span>
<span style="color: #000000"> max |deriv| 3e-06                           Brier    0.017    tau-a   0.192    </span>
<span style="color: #000000"> </span>
<span style="color: #000000">               Coef     S.E.    Wald Z Pr(&gt;|Z|)</span>
<span style="color: #000000"> Intercept     -33.7121 11.5108 -2.93  0.0034  </span>
<span style="color: #000000"> MechanicalApt   0.4697  0.1689  2.78  0.0054  </span>
<span style="color: #000000"> VerbalApt      -0.0865  0.0743 -1.16  0.2443  </span>
</pre></div>

</center>

**The linear discriminant analysis model does not use mechanical aptitude and/or verbal aptitude as standalone independent variables. The scores are averaged to create one column for general aptitude.**  

<li>  

Build an ordered logit model for the full four categories for performance. When you call the function `lrm()` you will use the original categories `PerScoreID`. What is the probability that individual two is in each of the four performance categories? You can use the function `predict()` to do this. The form of the call is `predict(name of the model you used when you created the model, data=frame, type=”fitted.ind”)`.  

</li> 

<center>

<!-- HTML generated using hilite.me --><div style="background: #f8f8f8; overflow:auto;width:fit-content;border-width:.1em .1em .1em .8em;padding:.0em .0em;"><pre style="margin: 0; text-align: left; line-height: 125%"><span style="color: #000000">Logistic Regression Model</span>
<span style="color: #000000"> </span>
<span style="color: #000000"> lrm(formula = PerfScoreID ~ Termd + EmpStatusID + EmpSatisfaction, </span>
<span style="color: #000000">     data = hr_data)</span>
<span style="color: #000000"> </span>
<span style="color: #000000"> </span>
<span style="color: #000000"> Frequencies of Responses</span>
<span style="color: #000000"> </span>
<span style="color: #000000">   1   2   3   4 </span>
<span style="color: #000000">   8  13 148  24 </span>
<span style="color: #000000"> </span>
<span style="color: #000000">                       Model Likelihood      Discrimination    Rank Discrim.    </span>
<span style="color: #000000">                             Ratio Test             Indexes          Indexes    </span>
<span style="color: #000000"> Obs           193    LR chi2     12.13      R2       0.077    C       0.634    </span>
<span style="color: #000000"> max |deriv| 8e-09    d.f.            3      R2(3,193)0.046    Dxy     0.268    </span>
<span style="color: #000000">                      Pr(&gt; chi2) 0.0070    R2(3,105.5)0.083    gamma   0.298    </span>
<span style="color: #000000">                                             Brier    0.086    tau-a   0.105    </span>
<span style="color: #000000"> </span>
<span style="color: #000000">                 Coef    S.E.   Wald Z Pr(&gt;|Z|)</span>
<span style="color: #000000"> y&gt;=2             1.0880 0.9065  1.20  0.2300  </span>
<span style="color: #000000"> y&gt;=3            -0.0130 0.8869 -0.01  0.9883  </span>
<span style="color: #000000"> y&gt;=4            -4.3212 0.9741 -4.44  &lt;0.0001 </span>
<span style="color: #000000"> Termd           -1.2239 1.1992 -1.02  0.3075  </span>
<span style="color: #000000"> EmpStatusID      0.1560 0.3152  0.49  0.6208  </span>
<span style="color: #000000"> EmpSatisfaction  0.5872 0.2086  2.81  0.0049  </span>
</pre></div>

</center>

**The respective probabilities that individual two will be in each of the four performance categories are 0.0472, 0.0824, 0.7875, 0.0829.**

</ol>

## Part Two
### Using Naïve Bayes to Predict a Performance Score

In this part of the project, you will use Naïve Bayes to predict a performance score. This part continues the scenario from Part One and uses the same modified version of the human resources data set available on the Kaggle website. The data set you will be using is in the file `NaiveBayesHW.csv` file. Over the course of this project, your task is to gain insight into who might be a “high” performer if hired.

<ol start = "1">

<li>	

Using only the mechanical aptitude score, use Naïve Bayes to predict the performance score for each employee. Professor Nozick discretized the mechanical scores into four classes. Notice only three of four classes have observations. This discretization is in the data file `NaiveBayesHW.csv`. The function to create the model is `naiveBayes()`.  

</li>

<center>

<!-- HTML generated using hilite.me --><div style="background: #f8f8f8; overflow:auto;width:fit-content;border-width:.1em .1em .1em .8em;padding:.0em .0em;"><pre style="margin: 0; text-align: left; line-height: 125%"><span style="color: #000000">Naive Bayes Classifier for Discrete Predictors</span>

<span style="color: #000000">Call:</span>
<span style="color: #000000">naiveBayes.default(x = X, y = Y, laplace = laplace)</span>

<span style="color: #000000">A-priori probabilities:</span>
<span style="color: #000000">Y</span>
<span style="color: #000000">    Class1     Class2     Class3     Class4 </span>
<span style="color: #000000">0.04145078 0.06735751 0.76683938 0.12435233 </span>

<span style="color: #000000">Conditional probabilities:</span>
<span style="color: #000000">        MechanicalApt</span>
<span style="color: #000000">Y           Level1    Level3    Level4</span>
<span style="color: #000000">  Class1 1.0000000 0.0000000 0.0000000</span>
<span style="color: #000000">  Class2 0.0000000 0.0000000 1.0000000</span>
<span style="color: #000000">  Class3 0.0000000 0.6554054 0.3445946</span>
<span style="color: #000000">  Class4 0.0000000 0.3333333 0.0000007</span>

<span style="color: #000000">            Class1       Class2     Class3      Class4</span>
<span style="color: #000000"> [1,] 9.999000e-05 0.1624837516 0.63743626 0.199980002</span>
<span style="color: #000000"> [2,] 7.617524e-05 0.0001237848 0.92362480 0.076175241</span>
<span style="color: #000000"> [3,] 9.999000e-05 0.1624837516 0.63743626 0.199980002</span>
<span style="color: #000000"> [4,] 9.773977e-01 0.0015882712 0.01808186 0.002932193</span>
<span style="color: #000000"> [5,] 9.773977e-01 0.0015882712 0.01808186 0.002932193</span>
<span style="color: #000000"> [6,] 7.617524e-05 0.0001237848 0.92362480 0.076175241</span>
<span style="color: #000000"> [7,] 7.617524e-05 0.0001237848 0.92362480 0.076175241</span>
<span style="color: #000000"> [8,] 7.617524e-05 0.0001237848 0.92362480 0.076175241</span>
<span style="color: #000000"> [9,] 9.999000e-05 0.1624837516 0.63743626 0.199980002</span>
<span style="color: #000000">[10,] 9.999000e-05 0.1624837516 0.63743626 0.199980002</span>
<span style="color: #000000">[11,] 7.617524e-05 0.0001237848 0.92362480 0.076175241</span>
<span style="color: #000000">[12,] 7.617524e-05 0.0001237848 0.92362480 0.076175241</span>
<span style="color: #000000">[13,] 9.999000e-05 0.1624837516 0.63743626 0.199980002</span>
<span style="color: #000000">[14,] 7.617524e-05 0.0001237848 0.92362480 0.076175241</span>
<span style="color: #000000">[15,] 9.999000e-05 0.1624837516 0.63743626 0.199980002</span>
<span style="color: #000000">[16,] 9.999000e-05 0.1624837516 0.63743626 0.199980002</span>
<span style="color: #000000">[17,] 9.999000e-05 0.1624837516 0.63743626 0.199980002</span>
<span style="color: #000000">[18,] 9.999000e-05 0.1624837516 0.63743626 0.199980002</span>
<span style="color: #000000">[19,] 9.999000e-05 0.1624837516 0.63743626 0.199980002</span>
<span style="color: #000000">[20,] 9.999000e-05 0.1624837516 0.63743626 0.199980002</span>
</pre></div>

</center>

<li>	

Using this modeling approach, what is your assessment of the probability that individual 10 will evolve into each of the four probability classes if hired? This can be done using 
the model created above and the `pred()` function.  

The arguments for that function are the model name, data and for type use “raw”. This question is parallel to the Practice using Naïve Bayes activity you completed in R.  

</li>

**The probability that individual 10 will evolve into each of the four probability classes if hired is as follows:**  

<table class="tg">
<thead>
  <tr>
    <th class="tg-7g6k"></th>
    <th class="tg-7g6k">Class 1</th>
    <th class="tg-7g6k">Class 2</th>
    <th class="tg-7g6k">Class 3</th>
    <th class="tg-7g6k">Class 4</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td class="tg-7rxw">Probability</td>
    <td class="tg-af47">0.00009999</td>
    <td class="tg-x5q1">0.16248375</td>
    <td class="tg-x5q1">0.63743626</td>
    <td class="tg-x5q1">0.19998000</td>
  </tr>
</tbody>
</table>

</ol>

## Part Three
### Building Classification Trees

In this part of the project, you will build classification trees. This part continues the scenario from Parts One and Two, as it uses the same modified version of the human resources data set available on the Kaggle website. Use the `HRdata4groups.csv` data set to predict each individual's performance (Performance Score ID) using classification trees. In the space below, you will explain the model you have developed and describe how well it performs.

<ol start="1">

<li>  

In the space below, explain the model you developed. It is sufficient to use the function `ctree()` in R to accomplish this in the style of the codio exercise Practice: Building a Classification Tree in R—Small Example.  

</li>
