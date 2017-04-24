libname dat 'H:\Personal\NHANES SES sleep CRP';
options fmtsearch=(dat.formats);

/* selecting a sample of 5% to play with */
*proc surveyselect data=dat.final out=play
	seed=1
	method=urs
	samprate=.05 
	outhits;
*run;



/* creating a bootstrap sample of 300 replicates */
%let reps=300;
proc surveyselect data=dat.final out=outboot
	seed=1
	method=urs
	samprate=1 
	outhits
	rep=&reps;
run;
/**************************************************************/
/* 1. EXPOSURE=INCOME, MEDIATOR=POOR SLEEP (with interaction) */
/**************************************************************/

/*outcome regression*/
proc surveyreg data=outboot;* 1. outcome model;
	by replicate;
	strata strata; cluster cluster; weight weight;
	class poor_sleep(ref='No') sleep_med(ref='No') pir_cat(ref='200%+')
		RIAGENDR(ref='Male') RIDRETH1(ref='Non-Hispanic White') 
		birth_control(ref='No') cotinine_cat(ref='<3 ng/mL') hrt(ref='No') obese(ref='No');
	model crp_log = pir_cat poor_sleep pir_cat*poor_sleep RIAGENDR RIDRETH1 RIDAGEYR  birth_control 
		cotinine_cat hrt obese sleep_med /solution;
	ods select none;
	ods output ParameterEstimates = outcome_model;
run;
data poorsleep (keep = replicate poorsleep); set outcome_model;
	where parameter = 'poor_sleep Yes';
	poorsleep = estimate;
run;
data poorsleep_pir0100 (keep = replicate poorsleep_pir0100); set outcome_model;
	where parameter = 'poor_sleep*pir_cat Yes 0-100%';
	poorsleep_pir0100 = estimate;
run;
data poorsleep_pir199 (keep = replicate poorsleep_pir199); set outcome_model;
	where parameter = 'poor_sleep*pir_cat Yes 100-199%';
	poorsleep_pir199 = estimate;
run;
/*mediator regression */
proc surveyreg data=outboot;* 1. outcome model;
	by replicate;
	strata strata; cluster cluster; weight weight;
	class poor_sleep(ref='No') sleep_med(ref='No') pir_cat(ref='200%+')
		RIAGENDR(ref='Male') RIDRETH1(ref='Non-Hispanic White') 
		birth_control(ref='No') cotinine_cat(ref='<3 ng/mL') hrt(ref='No') obese(ref='No');
	model poor_sleep = pir_cat RIAGENDR RIDRETH1 RIDAGEYR  birth_control 
		cotinine_cat hrt obese sleep_med /solution;
	ods select none;
	ods output ParameterEstimates = mediator_model;
run;
data pir0100 (keep = replicate pir0100); set mediator_model;
	where parameter = 'pir_cat 0-100%';
	pir0100 = estimate;
run;
data pir199 (keep = replicate pir199); set mediator_model;
	where parameter = 'pir_cat 100-199%';
	pir199 = estimate;
run;
/* combine and calculate the indirect effect */
data combine;
	merge poorsleep poorsleep_pir0100 pir0100 poorsleep_pir199 pir199;
	by replicate;
	indirect_pir0100 = (pir0100*poorsleep) + (pir0100*poorsleep_pir0100);
	indirect_pir199 = (pir199*poorsleep) + (pir199*poorsleep_pir199);
run;
/* get confidence intervals from percentiles of the bootstrap estimates */
proc univariate data=combine noprint; 
	var indirect_pir199 indirect_pir0100;
	output out=result_income_poorsleep mean=estimate199 estimate100 pctlpre=P_199_ p_100_  pctlpts= 2.5, 97.5;
run;
proc print data=result_income_poorsleep;
	title "Indirect Effect Estimates for Income Mediated by Poor Sleep.";
	ods select all;
run;

/*************************************************************/
/* 2. EXPOSURE=INCOME, MEDIATOR=SHORT SLEEP (no interaction) */
/*************************************************************/

/*outcome regression*/
proc surveyreg data=outboot;* 1. outcome model;
	by replicate;
	strata strata; cluster cluster; weight weight;
	class short_sleep(ref='No') sleep_med(ref='No') pir_cat(ref='200%+')
		RIAGENDR(ref='Male') RIDRETH1(ref='Non-Hispanic White') 
		birth_control(ref='No') cotinine_cat(ref='<3 ng/mL') hrt(ref='No') obese(ref='No');
	model crp_log = pir_cat short_sleep RIAGENDR RIDRETH1 RIDAGEYR  birth_control 
		cotinine_cat hrt obese sleep_med /solution;
	ods select none;
	ods output ParameterEstimates = outcome_model;
run;
data short_sleep (keep = replicate short_sleep); set outcome_model;
	where parameter = 'short_sleep Yes';
	short_sleep = estimate;
run;

/*mediator regression */
proc surveyreg data=outboot;* 1. outcome model;
	by replicate;
	strata strata; cluster cluster; weight weight;
	class short_sleep(ref='No') sleep_med(ref='No') pir_cat(ref='200%+')
		RIAGENDR(ref='Male') RIDRETH1(ref='Non-Hispanic White') 
		birth_control(ref='No') cotinine_cat(ref='<3 ng/mL') hrt(ref='No') obese(ref='No');
	model short_sleep = pir_cat RIAGENDR RIDRETH1 RIDAGEYR  birth_control 
		cotinine_cat hrt obese sleep_med /solution;
	ods select none;
	ods output ParameterEstimates = mediator_model;
run;
data pir0100 (keep = replicate pir0100); set mediator_model;
	where parameter = 'pir_cat 0-100%';
	pir0100 = estimate;
run;
data pir199 (keep = replicate pir199); set mediator_model;
	where parameter = 'pir_cat 100-199%';
	pir199 = estimate;
run;
/* combine and calculate the indirect effect */
data combine;
	merge short_sleep pir0100 pir199;
	by replicate;
	indirect_pir0100 = (pir0100*short_sleep);
	indirect_pir199 = (pir199*short_sleep) ;
run;
/* get confidence intervals from percentiles of the bootstrap estimates */
proc univariate data=combine noprint; 
	var indirect_pir199 indirect_pir0100;
	output out=result_income_shortsleep mean=estimate199 estimate100 pctlpre=P_199_ p_100_  pctlpts= 2.5, 97.5;
run;
proc print data=result_income_shortsleep;
	title "Indirect Effect Estimates for Income Mediated by Short Sleep.";
	ods select all;
run;

/****************************************************************/
/* 3. EXPOSURE=EDUCATION, MEDIATOR=SHORT SLEEP (no interaction) */
/****************************************************************/

/*outcome regression*/
proc surveyreg data=outboot;* 1. outcome model;
	by replicate;
	strata strata; cluster cluster; weight weight;
	class short_sleep(ref='No') sleep_med(ref='No') DMDEDUC2(ref='College Graduate or above')
		RIAGENDR(ref='Male') RIDRETH1(ref='Non-Hispanic White') 
		birth_control(ref='No') cotinine_cat(ref='<3 ng/mL') hrt(ref='No') obese(ref='No');
	model crp_log = DMDEDUC2 short_sleep RIAGENDR RIDRETH1 RIDAGEYR  birth_control 
		cotinine_cat hrt obese sleep_med /solution;
	ods select none;
	ods output ParameterEstimates = outcome_model;
run;
data short_sleep (keep = replicate short_sleep); set outcome_model;
	where parameter = 'short_sleep Yes';
	short_sleep = estimate;
run;

/*mediator regression */
proc surveyreg data=outboot;* 1. outcome model;
	by replicate;
	strata strata; cluster cluster; weight weight;
	class short_sleep(ref='No') sleep_med(ref='No') DMDEDUC2(ref='College Graduate or above')
		RIAGENDR(ref='Male') RIDRETH1(ref='Non-Hispanic White') 
		birth_control(ref='No') cotinine_cat(ref='<3 ng/mL') hrt(ref='No') obese(ref='No');
	model short_sleep = DMDEDUC2 RIAGENDR RIDRETH1 RIDAGEYR  birth_control 
		cotinine_cat hrt obese sleep_med /solution;
	ods select none;
	ods output ParameterEstimates = mediator_model;
run;
data LessThan9th (keep = replicate LessThan9th); set mediator_model; where parameter = 'DMDEDUC2 Less Than 9th Grade';
LessThan9th = estimate; run;
data From9to11  (keep = replicate From9to11); set mediator_model; where parameter = 'DMDEDUC2 9-11th Grade (Includes 12th grade with no diploma)';
From9to11 = estimate; run;
data HighSchool (keep = replicate HighSchool); set mediator_model; where parameter = 'DMDEDUC2 High School Grad/GED or Equivalent';
HighSchool = estimate; run;
data SomeCollege (keep = replicate SomeCollege); set mediator_model; where parameter = 'DMDEDUC2 Some College or AA degree';
SomeCollege = estimate; run;
/* combine and calculate the indirect effect */
data combine;
	merge short_sleep LessThan9th From9to11 HighSchool SomeCollege;
	by replicate;
	indirect_LessThan9th = (LessThan9th*short_sleep);
	indirect_From9to11 = (From9to11*short_sleep);
	indirect_HighSchool = (HighSchool*short_sleep);
	indirect_SomeCollege = (SomeCollege*short_sleep);
run;
/* get confidence intervals from percentiles of the bootstrap estimates */
proc univariate data=combine noprint; 
	var indirect_LessThan9th indirect_From9to11 indirect_HighSchool indirect_SomeCollege; 
	output 
		out=result_edu_shortsleep 
		mean=est_LessThan9th est_From9to11 est_HighSchool est_SomeCollege 
		pctlpre=LessThan9th_  From9to11_ HighSchool_ SomeCollege_  
		pctlpts= 2.5, 97.5;
run;
proc print data=result_edu_shortsleep;
	title "Indirect Effect Estimates for Education Mediated by Short Sleep.";
	ods select all;
run;
