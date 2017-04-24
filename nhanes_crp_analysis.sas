libname dat 'H:\Personal\NHANES SES sleep CRP';
options fmtsearch=(dat.formats);
proc contents data=dat.final; run;
proc freq data=dat.final; *raw frequencies;
	tables DMDEDUC2 PAD200 RIAGENDR RIDRETH1 agecat birth_control cotinine_cat 
	crp_bin hrt obese pir_cat poor_sleep sleep_dur sleep_med;
run;

proc freq data=dat.final; *frequencies by crp;
	title "frequencies by crp";
	tables DMDEDUC2*crp_bin PAD200*crp_bin RIAGENDR*crp_bin RIDRETH1*crp_bin 
		agecat*crp_bin birth_control*crp_bin cotinine_cat*crp_bin 
	 	hrt*crp_bin obese*crp_bin pir_cat*crp_bin poor_sleep*crp_bin 
		sleep_dur*crp_bin sleep_med*crp_bin;
run;

proc freq data=dat.final; *frequencies by poor sleep;
	title "frequencies by poor sleep";
	tables DMDEDUC2*poor_sleep PAD200*poor_sleep RIAGENDR*poor_sleep RIDRETH1*poor_sleep 
		agecat*poor_sleep birth_control*poor_sleep cotinine_cat*poor_sleep 
	 	hrt*poor_sleep obese*poor_sleep pir_cat*poor_sleep sleep_med*poor_sleep;
run;

proc freq data=dat.final; *frequencies by sleep duration;
	title "frequencies by sleep duration";
	tables DMDEDUC2*sleep_dur PAD200*sleep_dur RIAGENDR*sleep_dur RIDRETH1*sleep_dur 
		agecat*sleep_dur birth_control*sleep_dur cotinine_cat*sleep_dur 
	 	hrt*sleep_dur obese*sleep_dur pir_cat*sleep_dur sleep_med*sleep_dur;
run;



/* Check for normal distribution after log transform */
proc univariate data=dat.final;
	var crp_log;
	histogram;
run;

/* Check for linear association with age */
proc reg data=dat.final;
	model crp_log=RIDAGEYR;
run;


/*Mean CRP (not log) by each variable & t or f test */
proc surveyreg data=dat.final; title "univariable crp=edu"; 
	strata strata; cluster cluster; weight weight; 
	class DMDEDUC2(ref='College Graduate or above'); 
	model LBXCRP = DMDEDUC2 /solution noint; 
run;
proc surveyreg data=dat.final; title "univariable crp=pir_cat"; 
	strata strata; cluster cluster; weight weight;
	class pir_cat(ref='200%+'); 
	model LBXCRP = pir_cat /solution noint; 
run;
proc surveyreg data=dat.final; title "univariable crp=activity"; 
	strata strata; cluster cluster; weight weight;
	class PAD200(ref='Yes'); 
	model LBXCRP = PAD200/solution noint; 
run;
proc surveyreg data=dat.final; title "univariable crp=gender"; 
	strata strata; cluster cluster; weight weight;
	class RIAGENDR(ref='Male'); 
	model LBXCRP = RIAGENDR /solution noint; 
run;
proc surveyreg data=dat.final; title "univariable crp=race"; 
	strata strata; cluster cluster; weight weight;
	class RIDRETH1(ref='Non-Hispanic White'); 
	model LBXCRP = RIDRETH1 /solution noint; 
run;
proc surveyreg data=dat.final; title "univariable crp=age"; 
	strata strata; cluster cluster; weight weight;
	class agecat(ref='20-24'); 
	model LBXCRP = agecat /solution noint; 
run;
proc surveyreg data=dat.final; title "univariable crp=birth control"; 
	strata strata; cluster cluster; weight weight;
	class birth_control(ref='No'); 
	model LBXCRP = birth_control /solution noint; 
run;
proc surveyreg data=dat.final; title "univariable crp=cotinine"; 
	strata strata; cluster cluster; weight weight;
	class cotinine_cat(ref='<3 ng/mL'); 
	model LBXCRP = cotinine_cat /solution noint; 
run;
proc surveyreg data=dat.final; title "univariable crp=hrt"; 
	strata strata; cluster cluster; weight weight;
	class hrt(ref='No'); 
	model LBXCRP = hrt /solution noint;  
run;
proc surveyreg data=dat.final; title "univariable crp=obese"; 
	strata strata; cluster cluster; weight weight;
	class obese(ref='No'); 
	model LBXCRP = obese /solution noint; 
run;

proc surveyreg data=dat.final; title "univariable crp=poor sleep"; 
	strata strata; cluster cluster; weight weight;
	class poor_sleep(ref='No'); 
	model LBXCRP = poor_sleep /solution noint; 
run;
proc surveyreg data=dat.final; title "univariable crp=sleep duration"; 
	strata strata; cluster cluster; weight weight;
	class sleep_dur(ref='7'); 
	model LBXCRP = sleep_dur /solution noint; 
run;
proc surveyreg data=dat.final; title "univariable crp=sleep meds"; 
	strata strata; cluster cluster; weight weight;
	class sleep_med(ref='No'); 
	model LBXCRP = sleep_med /solution noint; 
run;

ods listing close;
ods output CrossTabs=poor_edu;
proc surveyfreq data=dat.final;
	strata strata; cluster cluster; weight weight;
	tables DMDEDUC2*poor_sleep;
run;
ods listing;

data poor_edu; (keep=; set poor_edu;

proc contents data=poor_sleep_by_all;
