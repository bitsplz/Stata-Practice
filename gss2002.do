********CODE LAB (describing variables + CI)
**DOES the log file save figures? 
*(this is a very detialed code file- run on your own to make sure you get it)
***to run this code, you need the data to be fed in

**use gss2002.dta
clear all 
cd "C:\Users\mujta\Downloads\Stata-MP-16.0-20201020T175446Z-001\Stata-MP-16.0\files"
log using Afzal_S1_Lab4, replace
use "gss2002" /*why not import?*/
*This is survey data 

******* Descriptive Statistics:
*remember that qualitative and quantitative vars are handled differently

* We'll first examine how to get some descriptive statistics 
* for categorical variables. 
* We'll first produce a frequency distribution of the variable
* "zodiac" Do 1t: 
tab zodiac


* How would we find the mode of this 
* categorical variable? 
*Q. waht is the mode? 

* We can also look at ordinal variables 
* We'll look at two variables: abchoice, which is the number of times the respondent
* said yes when asked whether "it should be possible for a 
* pregnant woman to obtain a legal abortion" under each of 
* three choice-related circumstances:
* "the family has a very low income and cannot afford any more 
* children," "she is single and does not want to marry 
* the man", and "she is married
* and does not want any more children".  
* The second variable "abhealth" counts the number of yes responses to three 
* health-related circumstances: "a strong
* chance of serious defect in the baby," "the woman's own 
* health is seriously endangered by the pregnancy", and "she 
* becomes pregnant as a result of 
* rape".  

* What stat can you find for these variables?  What are they?

* What about cont. var like age? Skew?


***Confidence itnervals: mean
* Get standard error
* can you get it manually? How?
* the command for confidence itnervals is ci
ci mean age

***Confidence itnervals: proporiton

*for a BINARY variable
* what is the proportion of hispanic respondents 
proportion hispanic
* for more than two cateogirs
proportion zodiac
* check this - how? 



*****VISUALIZATION 

* Graphical methods of depicting descriptive statistics:

* For a categorical variable, we can use a histogram.
histogram zodiac, discrete percent 

* the histogram command, followed by the variable name 
* (in this case, "zodiac") will produce a histogram.  The words 
* after the comma represent additional
* options that you can add to the histogram.  The "discrete" 
* option tells Stata that the variable is categorical.  The 
* "percent" option tells Stata to 
* draw the histogram as a percentage rather than a frequency.  

histogram zodiac, discrete percent xlabel(1(1)12, valuelabel angle(forty_five) labsize(small))

* Everything after xlabel determines how the x-axis is labeled. 
* The "xlabel 1(1)12" says that I want to label the x-axis from 
* 1 (Aries) - 12 (Pisces).
* The rest of the options say that we want to put the labels 
* at a 45 degree position, with a small position.

* You can also create a pie chart.  Put the categorical 
* variable that you're concerned with in the "over(varname)" 
* option.
graph pie, over(zodiac)

* We can do the same for an ordinal variable, abchoice.  
* Remember that we put the "percent" option so that stata 
* reports the percentage of cases
* that occupy each bin (or, range of values).
histogram abchoice, discrete percent

* We would then need to describe what each of the values 
* represented in order to get a better understanding of the 
* histogram.  For example, a value 
* of 0 means that the respondent answered "no" to each one of 
* the questions.  

* For a continuous variable, age.  This variable is 
* right-skewed and doesn't appear to be very symmetrical.
histogram age, discrete percent

* We can change the number of bins with the "bin(#)" option.  
* To produce fewer bins, type "bin(10)"
histogram age, bin(10)

* To produce a kernel density plot, which is a way of looking 
* at a smoothed version of the histogram, use the "twoway 
* kdensity" command.
* is this a normally distributed variable? See the distribution
twoway kdensity age

* To add titles to the graph, we use the title(""), 
* xtitle(""), and ytitle("").  
twoway kdensity age, title("Kernel Density Plot of Age") xtitle("Age of Person") ytitle("Density")

* We can also examine the rank statistics with a box-whisker 
* plot.  The command for this is "graph box" and then the 
* variable name, "age".
* This tells us where the median, 25%, 75%, 1% and 99% 
* percentiles are.  Since there are no additional dots, there 
* are no values below the 1st and 99th.
* see the positive skew? The bigger 'whisker' on top
graph box age

* to produce multiple box-whisker plots on one graph 
* (for the different values of zodiac), use the over option.
graph box age, over(zodiac) 

* to rename a variable, use the "rename" command.  Let's say 
* the old variable name is zodiac and you want to change it to 
* "sign"
rename zodiac sign

* if you wanted to change the label of the variable, use the 
* "label var" command.  Simply put the "label var" then the 
* name of the variable,
* and then whatever you want to change the label to.  
label var age "Age of the Respondent"

****Looking at proportions
table sign, contents(semean age)



