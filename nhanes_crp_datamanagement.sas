*libname dat 'H:\Personal\NHANES SES-sleep-CRP\data\';
libname dat 'H:\Personal\NHANES SES sleep CRP';
*Create libraries for each xpt file;
libname bmx_d Xport 'H:\Personal\NHANES SES sleep CRP\data\bmx_d.xpt';
libname bmx_e Xport 'H:\Personal\NHANES SES sleep CRP\data\bmx_e.xpt';
libname bmx_f Xport 'H:\Personal\NHANES SES sleep CRP\data\bmx_f.xpt';
libname crp_d Xport 'H:\Personal\NHANES SES sleep CRP\data\crp_d.xpt';
libname crp_e Xport 'H:\Personal\NHANES SES sleep CRP\data\crp_e.xpt';
libname crp_f Xport 'H:\Personal\NHANES SES sleep CRP\data\crp_f.xpt';
libname demo_d Xport 'H:\Personal\NHANES SES sleep CRP\data\demo_d.xpt';
libname demo_e Xport 'H:\Personal\NHANES SES sleep CRP\data\demo_e.xpt';
libname demo_f Xport 'H:\Personal\NHANES SES sleep CRP\data\demo_f.xpt';
libname slq_d Xport 'H:\Personal\NHANES SES sleep CRP\data\slq_d.xpt';
libname slq_e Xport 'H:\Personal\NHANES SES sleep CRP\data\slq_e.xpt';
libname slq_f Xport 'H:\Personal\NHANES SES sleep CRP\data\slq_f.xpt';
libname RHQ_D Xport 'H:\Personal\NHANES SES sleep CRP\data\rhq_d.xpt';
libname RHQ_e Xport 'H:\Personal\NHANES SES sleep CRP\data\rhq_e.xpt';
libname RHQ_f Xport 'H:\Personal\NHANES SES sleep CRP\data\rhq_f.xpt';
libname cot_d Xport 'H:\Personal\NHANES SES sleep CRP\data\cot_d.xpt';
libname cotnal_e Xport 'H:\Personal\NHANES SES sleep CRP\data\cotnal_e.xpt';
libname cotnal_f Xport 'H:\Personal\NHANES SES sleep CRP\data\cotnal_f.xpt';
libname paq_d Xport 'H:\Personal\NHANES SES sleep CRP\data\paq_d.xpt';
libname paq_e Xport 'H:\Personal\NHANES SES sleep CRP\data\paq_e.xpt';
libname paq_f Xport 'H:\Personal\NHANES SES sleep CRP\data\paq_f.xpt';
*vertically merge years for each dataset;
data bmx; set bmx_d.bmx_d bmx_e.bmx_e bmx_f.bmx_f; run;
data crp; set crp_d.crp_d crp_e.crp_e crp_f.crp_f; run;
data demo; set demo_d.demo_d demo_e.demo_e demo_f.demo_f; run;
data slq; set slq_d.slq_d slq_e.slq_e slq_f.slq_f; run;
data rhq; set rhq_d.rhq_d rhq_e.rhq_e rhq_f.rhq_f; run;
data cot; set cot_d.cot_d cotnal_e.cotnal_e cotnal_f.cotnal_f; run;
data paq; set paq_d.paq_d paq_e.paq_e paq_f.paq_f; run;
data dat.nhanes; *horizontally merge datasets and create 6-year weights, save physical file;
	merge bmx crp demo slq cot rhq paq;
	by seqn;

	WTMEC6YR = 1/3 * WTMEC2YR;
	label WTMEC6YR = "Full Sample 6 Year MEC Exam Weight";

	WTINT6YR = 1/3 * WTINT2YR;
	label WTINT6YR = "Full Sample 6 Year Interview Weight";

run;
proc contents data=dat.nhanes;
run;


proc format library=dat; * all formats;
	value yesno 0="No" 1="Yes" 2="Missing";
	value crpbin 0="<3" 1="3 to 10" 2=">10";
	value sleepdur 0="7" 1="6" 2="<6" 3="8" 4=">8";
	value pir 0="200%+" 1="100-199%" 2="0-100%";
	value edu 1="Less Than 9th Grade" 2="9-11th Grade (Includes 12th grade with no diploma)"
			3="High School Grad/GED or Equivalent" 4="Some College or AA degree"
			5="College Graduate or above";
	value age_5yr 0="20-24" 1="25-29" 2="30-34"
			3="35-39" 4="40-44" 5="45-49" 6="50-54" 7="55-59"
			8="60-64" 9="65-69" 10="70-74" 11="75-79" 12="80+";
	value cot 0="<3 ng/mL" 1="3+ ng/mL";
	value gender 1="Male" 2="Female";
	value race 1="Mexican American" 2="Other Hispanic" 3="Non-Hispanic White" 
				4="Non-Hispanic Black" 5="Other Race - Including Multi-Racial";
	value phys_act 1="Yes" 0="No" 2="Missing";
	value hrt 1="Yes" 0="No" 3="N/A (Male)" 4="Missing";
run;
options fmtsearch=(dat.formats);
data nhanes; * grab from physical file, coding exposures, outcomes, mediators;
	set dat.nhanes;

	crp_bin = .;
	if LBXCRP < 3 then crp_bin = 0;
	else if 3 <= LBXCRP < 10 then crp_bin = 1;
	else if LBXCRP >= 10 then crp_bin = 2;
	format crp_bin crpbin.;

	crp_log = log(LBXCRP);

	sleep_dur = .;
	if SLD010H > 12 then sleep_dur = .; *deleting 77 and 99, these are missing;
	else if SLD010H = 7 then sleep_dur = 0;
	else if SLD010H = 6 then sleep_dur = 1;
	else if SLD010H < 6 then sleep_dur = 2;
	else if SLD010H = 8 then sleep_dur = 3;
	else if SLD010H > 8 then sleep_dur = 4;
	format sleep_dur sleepdur.;
	label sleep_dur="How much sleep do you get (hours)?";

	short_sleep = 0;
	if sleep_dur = 2 then short_sleep = 1;
	else if sleep_dur = . then short_sleep = .;
	format short_sleep yesno.;
	label short_sleep="Short Sleep (<6 hours per night)";


	poor_sleep = .;
	if 2 le SLQ080 le 4 then poor_sleep = 1;
	else if 2 le SLQ090 le 4 then poor_sleep = 1;
	else if 2 le SLQ100 le 4  then poor_sleep = 1;
	else if 2 le SLQ110 le 4  then poor_sleep = 1;
	else if 2 le SLQ120 le 4  then poor_sleep = 1;
	else if SLQ080 < 2 and SLQ090 < 2 and SLQ100 < 2 and SLQ110 < 2 and SLQ120 < 2 then poor_sleep = 0;
	format poor_sleep yesno.;
	label poor_sleep="5 or more: wake up during the night, wake up too early in the morning, feel unrested during the day, feel overly sleepy during the day.";

	pir_cat = .;
	if INDFMPIR > 2 then pir_cat = 0;
	else if INDFMPIR > 1 then pir_cat = 1;
	else if INDFMPIR <= 1 then pir_cat = 2;
	format pir_cat pir.;
	label pir_cat="Poverty income ratio";

	format DMDEDUC2 edu.;
	if DMDEDUC2 > 6 then DMDEDUC2 = .;

run;
proc freq data=nhanes; *check for correct coding of exposures, outcomes, and mediators;
	tables LBXCRP*crp_bin SLD010H*sleep_dur
			SLQ080*poor_sleep
			SLQ090*poor_sleep
			SLQ100*poor_sleep
			SLQ110*poor_sleep
			SLQ120*poor_sleep
			INDFMPIR*pir_cat;
run;
data nhanes; *Coding age;
	set nhanes;

	agecat = .;
	if RIDAGEYR < 20 then delete;
	else if RIDAGEYR <25 then agecat = 0;
	else if RIDAGEYR <30 then agecat = 1;
	else if RIDAGEYR <35 then agecat = 2;
	else if RIDAGEYR <40 then agecat = 3;
	else if RIDAGEYR <45 then agecat = 4;
	else if RIDAGEYR <50 then agecat = 5;
	else if RIDAGEYR <55 then agecat = 6;
	else if RIDAGEYR <60 then agecat = 7;
	else if RIDAGEYR <65 then agecat = 8;
	else if RIDAGEYR <70 then agecat = 9;
	else if RIDAGEYR <75 then agecat = 10;
	else if RIDAGEYR <80 then agecat = 11;
	else agecat = 12;
	format agecat age_5yr.;
	label agecat = "Age (5yr categories)";



run;
proc freq data=nhanes; *check for correct coding of age;
	tables RIDAGEYR*agecat; 
run;
data nhanes; *Coding cotinine;
	set nhanes;

	cotinine_cat = .;
	if LBXCOT < 3 then cotinine_cat = 0;
	else if LBXCOT >= 3 then cotinine_cat = 1;
	format cotinine_cat cot.;
	label cotinine_cat = "Cotinine level, two categories";
run;
proc freq data=nhanes; tables LBXCOT*cotinine_cat; run; *Checking for correct cotinine coding;
proc freq data=nhanes; *hrt missingness?;
  tables RHQ558 RHQ566 RHQ574 RHQ584 RHQ600;
run;
data nhanes; *coding other covariates;
	set nhanes;

	hrt = 4;
	if RIAGENDR = 1 then hrt = 3;
	else if RHQ540 = 2 then hrt = 0;
	else if RHQ558 = 1 or RHQ566 = 1 or RHQ574 = 1 or RHQ584 = 1 or RHQ600 = 1 then hrt = 1;
	else if RHQ558 = 2 or RHQ566 = 2 or RHQ574 = 2 or RHQ584 = 2 or RHQ600 = 2 then hrt = 0;
	format hrt hrt.;
	label hrt = "Using any HRT now (y/n)";

	obese = .;
	if BMXBMI ge 30 then obese=1;
	else if BMXBMI lt 30 then obese=0;
	format obese yesno.;
	label obese = "BMI 30+ (y/n)";

	sleep_med = 2;
	if SLQ140=2 or SLQ140=3 then sleep_med = 1;
	else if SLQ140 le 2 then sleep_med = 0;
	format sleep_med yesno.;
	label sleep_med = "Used sleep medications 5 or more times in the last 30 days";

	birth_control = 4;
	if RIAGENDR = 1 then birth_control = 3;
	else if RHD442 = 1 or RHQ520 = 1 then birth_control = 1;
	else if RHQ420 = 2 or RHQ510 = 2 then birth_control = 0;
	else if RHD442 = 2 or RHQ520 = 2 then birth_control = 0;
	format birth_control hrt.;

	phys_act = 0;
	if PAQ605 = 1 
		OR PAQ620 = 1 
		OR PAQ635 = 1 
		OR PAQ650 = 1 
		OR PAQ665 = 1
		then phys_act = 1;
	else if (PAQ605 ge 7 or PAQ605 = . ) 
		AND (PAQ620 ge 7 or PAQ620 = . )  
		AND (PAQ635 ge 7 or PAQ635 = . )  
		AND (PAQ650 ge 7 or PAQ650 = . )  
		AND (PAQ665 ge 7 or PAQ665 = . )
		then phys_act = 2;
	format phys_act phys_act.;
	label phys_act="Vigorous or moderate work, recreational, or transportation activity at least once per week.";


	format RIAGENDR gender. RIDRETH1 race.; 
run;
proc freq data=nhanes; *check for correct coding of HRT, obese, sleepmed, birthcontrol;
	tables hrt*RHQ558 hrt*RHQ566 hrt*RHQ574 hrt*RHQ584 hrt*RHQ600
		BMXBMI*obese SLQ140*sleep_med RHD442*birth_control;
run;

data nhanes; *dropping 22 observations due to crp >10;
	set nhanes;	
	if crp_bin = 2 then delete;
run;
proc freq data=nhanes; tables RHD143*RIDEXPRG; run; *check for pregnancies;
data nhanes; *dropping 456 observations due to currently pregnant (at exam);
	set nhanes;
	if RIDEXPRG = 1 then delete;
run;
data nhanes; *renaming survey design variables;
	set nhanes;
	weight=WTMEC6YR;
	strata=SDMVSTRA;
	cluster=SDMVPSU;
run;
*save full dataset;
data dat.nhanes;
	set nhanes;
run;

*save final dataset with only relevant variables;
data dat.final (keep=SEQN weight strata cluster LBXCRP crp_bin crp_log sleep_dur short_sleep poor_sleep pir_cat DMDEDUC2 agecat RIDAGEYR 
					cotinine_cat LBXCOT hrt obese sleep_med birth_control phys_act RIAGENDR RIDRETH1 PAD200); 
	set nhanes;
run;
proc contents data=dat.final;
run;


