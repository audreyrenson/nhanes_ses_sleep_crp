
libname dat 'H:\Personal\NHANES SES sleep CRP';
options fmtsearch=(dat.formats);

/* selecting a sample of 5% to play with */
proc surveyselect data=dat.final out=play
	seed=1
	method=urs
	samprate=.05 
	outhits;
run; 


data play;
	set play;
	low_inc = 0;
	if pir_cat = 2 then low_inc = 1;
	else if pir_cat = . then low_inc=.;
	format low_inc yesno.;
run;


/* step 3. construct a new dataset by repeating each observation twice and including A* = A or !A
and an indicator variable for subject */
data play; set play;
	id = _n_;
	low_inc_star = low_inc;
	format low_inc_star yesno.;
run;
data play2; set play;
	low_inc_star = ( -1*low_inc ) + 1;
run;
data play3; set play play2;
run;


/* Step 1: fit a model for the exposure conditional on the confounders */
/* starting with low income */
proc logistic data=play;
	class sleep_med(ref='No') low_inc(ref='No')
		RIAGENDR(ref='Male') RIDRETH1(ref='Non-Hispanic White') 
		birth_control(ref='No') cotinine_cat(ref='<3 ng/mL') hrt(ref='No') obese(ref='No');
	model low_inc = RIAGENDR RIDRETH1 RIDAGEYR  birth_control 
		cotinine_cat hrt obese sleep_med;
	score data=play3

run;

/*Step 2: Fit a model to the mediator conditional on exposure and confounders */
/* starting with poor sleep (IT SEEMS LIKE THIS IS ALL YOU NEED FOR THE STABILIZED WEIGHTS) */
proc logistic data=play;
	class poor_sleep(ref='No') sleep_med(ref='No') low_inc(ref='No')
		RIAGENDR(ref='Male') RIDRETH1(ref='Non-Hispanic White') 
		birth_control(ref='No') cotinine_cat(ref='<3 ng/mL') hrt(ref='No') obese(ref='No');
	model poor_sleep = low_inc RIAGENDR RIDRETH1 RIDAGEYR  birth_control 
		cotinine_cat hrt obese sleep_med ;
	score data=play3 out=factual;
run;
data counterfactual; *this is so that I can change the name of a* variable to a;
	set play3;
	low_inc = low_inc_star;
run;
/*fitting the model to the counterfactual data */
proc logistic data=play;
	class poor_sleep(ref='No') sleep_med(ref='No') low_inc(ref='No')
		RIAGENDR(ref='Male') RIDRETH1(ref='Non-Hispanic White') 
		birth_control(ref='No') cotinine_cat(ref='<3 ng/mL') hrt(ref='No') obese(ref='No');
	model poor_sleep = low_inc RIAGENDR RIDRETH1 RIDAGEYR  birth_control 
		cotinine_cat hrt obese sleep_med ;
	score data=counterfactual out=counterfactual;
run;
data counterfactual;
	set counterfactual;
	p_m_a_star = p_yes;
run;
data factual;
	set factual;
	p_m_a = p_yes;
run;
data full (drop=p_yes p_no);
	merge factual counterfactual;
run;
/* step 4 compute weights */	
data full; set full;
	weights = p_m_a_star / p_m_a;
run;

/*drop low_inc_star from dataset 'full' because it's just the factual*/
data full drop=low_inc_star; set full; run;
/*grab the low inc star from play3, which still has the opposite of the truth */
data full; merge full play3; run;
/* now 'full' is the full counterfactual dataset */
	
/* step 5 fit an outcome model with a and a* + interaction */
proc glm data=full;
	class low_inc(ref='No') low_inc_star(ref='No');
	model crp_log = low_inc low_inc_star low_inc*low_inc_star /solution;
	weight weights;
run;

proc freq data=dat.final;tables DMDEDUC2; run;
/* STEP 1. Is A associated with Y conditional on C? */
proc surveyreg data=dat.final; *income;
	strata strata; cluster cluster; weight weight;
	class sleep_med(ref='No') pir_cat(ref='200%+')
		RIAGENDR(ref='Male') RIDRETH1(ref='Non-Hispanic White') 
		birth_control(ref='No') cotinine_cat(ref='<3 ng/mL') hrt(ref='No') obese(ref='No');
	model crp_log = pir_cat RIAGENDR RIDRETH1 RIDAGEYR  birth_control 
		cotinine_cat hrt obese sleep_med /solution;
run;
proc surveyreg data=dat.final; *education;
	strata strata; cluster cluster; weight weight;
	class sleep_med(ref='No') DMDEDUC2(ref='College Graduate or above')
		RIAGENDR(ref='Male') RIDRETH1(ref='Non-Hispanic White') 
		birth_control(ref='No') cotinine_cat(ref='<3 ng/mL') hrt(ref='No') obese(ref='No');
	model crp_log = DMDEDUC2 RIAGENDR RIDRETH1 RIDAGEYR  birth_control 
		cotinine_cat hrt obese sleep_med /solution;
run;
/* STEP 2. Is Z associated with Y conditional on C? */
proc surveyreg data=dat.final; *sleep_dur;
	strata strata; cluster cluster; weight weight;
	class sleep_dur(ref='7') sleep_med(ref='No')
		RIAGENDR(ref='Male') RIDRETH1(ref='Non-Hispanic White') 
		birth_control(ref='No') cotinine_cat(ref='<3 ng/mL') hrt(ref='No') obese(ref='No');
	model crp_log =  sleep_dur RIAGENDR RIDRETH1 RIDAGEYR  birth_control 
		cotinine_cat hrt obese sleep_med /solution;
run;
proc surveyreg data=dat.final; *poor_sleep;
	strata strata; cluster cluster; weight weight;
	class poor_sleep(ref='No') sleep_med(ref='No')
		RIAGENDR(ref='Male') RIDRETH1(ref='Non-Hispanic White') 
		birth_control(ref='No') cotinine_cat(ref='<3 ng/mL') hrt(ref='No') obese(ref='No');
	model crp_log =  poor_sleep RIAGENDR RIDRETH1 RIDAGEYR  birth_control 
		cotinine_cat hrt obese sleep_med /solution;
run;
/*STEP 3. Is Z associated with A conditional on C? */
proc logistic data=dat.final; *sleep_dur ~ income -- YES;
	class sleep_dur(ref='7') sleep_med(ref='No') pir_cat(ref='200%+')
		RIAGENDR(ref='Male') RIDRETH1(ref='Non-Hispanic White') 
		birth_control(ref='No') cotinine_cat(ref='<3 ng/mL') hrt(ref='No') obese(ref='No');
	model sleep_dur = pir_cat RIAGENDR RIDRETH1 RIDAGEYR  birth_control 
		cotinine_cat hrt obese sleep_med /link=glogit;
run;
proc logistic data=dat.final; *sleep_dur ~ edu -- YES;
	class sleep_dur(ref='7') sleep_med(ref='No') pir_cat(ref='200%+') DMDEDUC2(ref='College Graduate or above')
		RIAGENDR(ref='Male') RIDRETH1(ref='Non-Hispanic White') 
		birth_control(ref='No') cotinine_cat(ref='<3 ng/mL') hrt(ref='No') obese(ref='No');
	model sleep_dur = DMDEDUC2 RIAGENDR RIDRETH1 RIDAGEYR  birth_control 
		cotinine_cat hrt obese sleep_med /link=glogit;
run;
proc surveylogistic data=dat.final; *poor_sleep ~ edu -- NO;
	strata strata; cluster cluster; weight weight;
	class poor_sleep(ref='No') sleep_med(ref='No') pir_cat(ref='200%+') DMDEDUC2(ref='College Graduate or above')
		RIAGENDR(ref='Male') RIDRETH1(ref='Non-Hispanic White') 
		birth_control(ref='No') cotinine_cat(ref='<3 ng/mL') hrt(ref='No') obese(ref='No');
	model poor_sleep = DMDEDUC2 RIAGENDR RIDRETH1 RIDAGEYR  birth_control 
		cotinine_cat hrt obese sleep_med /link=glogit;
run;
proc surveylogistic data=dat.final; *poor_sleep ~ pir_cat -- YES;
	strata strata; cluster cluster; weight weight;
	class poor_sleep(ref='No') sleep_med(ref='No') pir_cat(ref='200%+') DMDEDUC2(ref='College Graduate or above')
		RIAGENDR(ref='Male') RIDRETH1(ref='Non-Hispanic White') 
		birth_control(ref='No') cotinine_cat(ref='<3 ng/mL') hrt(ref='No') obese(ref='No');
	model poor_sleep = pir_cat RIAGENDR RIDRETH1 RIDAGEYR  birth_control 
		cotinine_cat hrt obese sleep_med /link=glogit;
run;
/*STEP 4. CHECKING FOR INTERACTION */
/* pir_cat*sleep_dur -- NO INTERACTION */
proc surveyreg data=dat.final;
	strata strata; cluster cluster; weight weight;
	class sleep_dur(ref='7') sleep_med(ref='No') pir_cat(ref='200%+')
		RIAGENDR(ref='Male') RIDRETH1(ref='Non-Hispanic White') 
		birth_control(ref='No') cotinine_cat(ref='<3 ng/mL') hrt(ref='No') obese(ref='No');
	model crp_log = pir_cat sleep_dur pir_cat*sleep_dur RIAGENDR RIDRETH1 RIDAGEYR  birth_control 
		cotinine_cat hrt obese sleep_med /solution;
run;
/* pir_cat*poor_sleep -- INTERACTION!!! */
proc surveyreg data=dat.final;
	strata strata; cluster cluster; weight weight;
	class poor_sleep(ref='No') sleep_med(ref='No') pir_cat(ref='200%+')
		RIAGENDR(ref='Male') RIDRETH1(ref='Non-Hispanic White') 
		birth_control(ref='No') cotinine_cat(ref='<3 ng/mL') hrt(ref='No') obese(ref='No');
	model crp_log = pir_cat poor_sleep pir_cat*poor_sleep RIAGENDR RIDRETH1 RIDAGEYR  birth_control 
		cotinine_cat hrt obese sleep_med /solution;
run;
/* DMDEDUC2*sleep_dur -- NO INTERACTION */
proc surveyreg data=dat.final;
	strata strata; cluster cluster; weight weight;
	class sleep_dur(ref='7') sleep_med(ref='No') DMDEDUC2(ref='College Graduate or above')
		RIAGENDR(ref='Male') RIDRETH1(ref='Non-Hispanic White') 
		birth_control(ref='No') cotinine_cat(ref='<3 ng/mL') hrt(ref='No') obese(ref='No');
	model crp_log = DMDEDUC2 sleep_dur DMDEDUC2*sleep_dur RIAGENDR RIDRETH1 RIDAGEYR  birth_control 
		cotinine_cat hrt obese sleep_med /solution;
run;
/* DMDEDUC2*poor_sleep -- NO INTERACTION */
proc surveyreg data=dat.final;
	strata strata; cluster cluster; weight weight;
	class poor_sleep(ref='No') sleep_med(ref='No') DMDEDUC2(ref='College Graduate or above')
		RIAGENDR(ref='Male') RIDRETH1(ref='Non-Hispanic White') 
		birth_control(ref='No') cotinine_cat(ref='<3 ng/mL') hrt(ref='No') obese(ref='No');
	model crp_log = DMDEDUC2 poor_sleep DMDEDUC2*poor_sleep RIAGENDR RIDRETH1 RIDAGEYR  birth_control 
		cotinine_cat hrt obese sleep_med /solution;
run;


/* STEP 5. Estimate the indirect effect according to VanderWheel 2016 */
/* Dropping poor sleep as a mediator of education */
/* pir_cat*poor_sleep -- INTERACTION */
proc surveyreg data=dat.final;* 1. outcome model;
	strata strata; cluster cluster; weight weight;
	class poor_sleep(ref='No') sleep_med(ref='No') pir_cat(ref='200%+')
		RIAGENDR(ref='Male') RIDRETH1(ref='Non-Hispanic White') 
		birth_control(ref='No') cotinine_cat(ref='<3 ng/mL') hrt(ref='No') obese(ref='No');
	model crp_log = pir_cat poor_sleep pir_cat*poor_sleep RIAGENDR RIDRETH1 RIDAGEYR  birth_control 
		cotinine_cat hrt obese sleep_med /solution;
	ods output ParameterEstimates = crp_poorsleep_pircat;
run;
proc surveyreg data=dat.final;* 2. mediator model;
	strata strata; cluster cluster; weight weight;
	class poor_sleep(ref='No') sleep_med(ref='No') pir_cat(ref='200%+')
		RIAGENDR(ref='Male') RIDRETH1(ref='Non-Hispanic White') 
		birth_control(ref='No') cotinine_cat(ref='<3 ng/mL') hrt(ref='No') obese(ref='No');
	model poor_sleep = pir_cat RIAGENDR RIDRETH1 RIDAGEYR  birth_control 
		cotinine_cat hrt obese sleep_med /solution;
	ods output parameterestimates = poorsleep_pircat;
run;

proc freq data=dat.final; 
	tables DMDEDUC2 birth_control cotinine_cat hrt obese phys_act pir_cat poor_sleep short_sleep*sleep_dur sleep_med; 
run;

