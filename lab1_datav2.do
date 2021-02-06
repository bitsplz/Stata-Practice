* Lab1: Intro
* This symbol * is to write a comment 
* Always organize your code
* Write lots of comments, you WILL forget what you did (promise) 
* Date: 
* Author: 
** Reading Laila's code
* Comment
** Note other than current task
*** STATA code not being used currently (and headings)
/* Assignment to do */ 
* ^ Thats also a cooment symbol 

                                 *** Task 1: open data ***
         
*clean everything up (not needed for this)
 clear all

*we will bring a dataset in from excel 
* First thing is to set the working directory
* (tell STATA where to find the file)
cd "C:\Users\mujta\Downloads\Stata-MP-16.0-20201020T175446Z-001\Stata-MP-16.0\files"

* Next, open up a log file
* Note that this is to save your work- you need to submit the log file for STATA assignments
 * Log fle combines both output window and do file commands 
 * The using thing is the name you want to give it
 * replace in case you already had it saved last time
 * the log file has a funny extension but can be converted to pdf as well
 log using Afzal_S1_Lab3, replace

*bring data from excel 
* We need to tell STATA first row is varibales
* Make sure your excel sheets are formatted this way 
import excel "lab1_datav2.xlsx",firstrow clear 


	**If your data is not in the same wd as above, you can tell STATA
	***import excel "/Users/lailafarooq/Documents/Fall2018/CRM/lab/lab1_data.xlsx", sheet("Sheet1") firstrow clear
	*8If your data is filed as a STATA file (.dta) you can just do 
	*** use lab1_data.dta
*Where is your data? Open browser to see it
*Notice it created an id var A
	**DO NOT WRITE IN THE BROWSER. That is dum- Do not be dum

/* Q1. improt data using dropdown as well */
*^ File -> import -> excel
                                 *** Task 2: making data easy t use ***

*This is to describe the data
describe

*notice the variables window on the right
*change the labels to something simpler 

label var vprotest "violent protests"

/* Q2. Do it for country and vprotests (violent protests) as well */
*You can copy variables from the properties tab below
*See the variables table now
*You can also see variables in variables manager 
*^ Data -> Variables Manager

*Wait- what is countryx? Lets rename this 

rename countryx country

/* Q3. Rename Total protests tprotests */
                                 *** Task 3: looking at one variable (descriptive)***
*I want to know some stuff about these variables
* frequencies 
*we are looking at center and variability 

             ****Categorical Var  
             **Frequencies**
tab country
**gives you frequency, relative freq and cumultive freq
*Do this for another categorical var:



* Graphical methods of depicting descriptive statistics:

* the histogram command, followed by the variable name 
*  will produce a histogram.  The words 
* after the comma represent additional
* options that you can add to the histogram.  The "discrete" 
* option tells Stata that the variable is categorical.  The 
* "percent" option tells Stata to 
* draw the histogram as a percentage rather than a frequency.  
**graph it
hist country, discrete
*oops ok
***MAKE IT HAPPEN
encode country, generate(country_num)
hist country_num, discrete percent 
*bla
***try another categorical var 



* You can also create a pie chart.  Put the categorical 
* variable that you're concerned with in the "over(varname)" 
* option.
graph pie, over(region)
graph pie, over(region) allcategories  plabel(_all name)

*but i dont want to make it numeric??
	*Ideally we should be able to use bar graph 
graph bar (count), over region
*BUT Stata makes life difficult 
*so we will use a user written package called catplot
*find and install
findit catplot
*it wil be the first link under Web resources from Stata and other users
*or 
*ssc install catplot
catplot region, percent
*
catplot region, percent recast(bar)
*Try country 


             ****Ordinal Var  
             **Frequencies**
*same as before- but we can now use hist 
*first step?


histogram polity2, discrete percent xlabel(-10(1)10, valuelabel angle(forty_five) labsize(small))
* Everything after xlabel determines how the x-axis is labeled. 
* The "xlabel -10(1)10" says that I want to label the x-axis from 
* -10  to 10 
* The rest of the options say that we want to put the labels 
* at a 45 degree position, with a small position.



              ***Continuous variables
*frequency 
*?
tab gdp_pcap
**lets do a hist
hist gdp_pcap 
hist gdp_pcap, freq 
mean gdp_pcap

	
sum gdp
sum gdp, detail
*what are mean and standard deviation? 

**lets look at means:
mean gdp_pcap 
sum gdp_pcap

			*** Task 4: Generating New variables ***
*I want to get the square of gdp 	

gen gdp_sq=gdp_pcap^2
list gdp_pcap gdp_sq

/* Q5.Do this for polity */

**if you mess it up, you can delete one var also
***drop gdp_sq

*I want to create a variable that is 1 for all coutnries that are democracies (polity => 6)
gen dem =. 
*is a missing vakue
replace dem = 1 if (polity2>=6) 
replace dem = 0 if (polity2<6)
sort polity2 dem
list polity2 dem

/* Q6.Generate a variable autoc which is 1 when polity =< -6 and 0 otherwise */
gen autoc =. 
*is a missing vakue
replace autoc = 1 if (polity2<=-6) 
replace autoc = 0 if (polity2>6)
sort polity2 autoc
list polity2 autoc

/* Q7.Generate a variable transit which is 1 when  -5<= polity =< 5 and 0 otherwise */
*hint: polity2>=-5 & polity2<=5


* why is this wrong? comman will be or 
gen transit =.
replace transit = 1 if (polity2>=-5 | polity2<=5)
replace transit = 0 if (polity2<-5 | polity2>5)
sort polity2 dem autoc transit
list polity2 dem autoc transit

*this is what you need:
drop transit 
gen transit =.
replace transit = 1 if (polity2>=-5 | polity2<=5)
replace transit = 0 if (polity2<-5 | polity2>5)
sort polity2 dem autoc transit
list polity2 dem autoc transit
sort polity2 dem autoc transit
list polity2 dem autoc transit



                                 *** Task 5: Close log and save work ***

*This is how to close the log
*save the do file manually
	**you can save the modified dataset using
	***save.lab2_data.dta
	**DO NOT OVERWRITE DATA- IF YOU HAVE TO ,SAVE WIHT DIFFERENT NAME
log close
*Check your folder and see saved stuff 

