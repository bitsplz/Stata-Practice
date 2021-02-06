*Muhammad Mujtaba Afzal 14882 Slot1 
clear all
cd "C:\Users\mujta\Downloads\Stata-MP-16.0-20201020T175446Z-001\Stata-MP-16.0\files"
log using Afzal_S1_A4, replace
use "titanic"

*Q1 find if variables are related so we use chi test
tab class survived, chi row

*load second data set
use "hsb2"

*Q2 do box plot for both relationships
graph box math, over(race)
graph box read, over(race)

*Q4 generate a new variable that tells if asian or not. Then do a ttest.
gen Asian =" "
replace Asian="yes" if race=="asian"
replace Asian="no" if race!="asian"
ttest math, by(Asian)

*Q5 create a new varaible with numerical values do do regression.
gen boolAsian=.
replace boolAsian=1 if Asian=="yes"
replace boolAsian=0 if Asian!="yes"
regress math boolAsian
regress math boolAsian, level(90)

*Q6 use scatter plot and then fit a line to see relationship
twoway scatter math read
twoway (lfit math read) (scatter math read)

*Q7
corr read math
regress math read