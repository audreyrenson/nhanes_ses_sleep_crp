libname dat 'H:\Personal\NHANES SES sleep CRP';
*libname dat 'C:\Users\Audrey\Google Drive\CUNY SPH Coursework\EPID622 Applied Research- Data Management\NHANES SES sleep CRP';
options fmtsearch=(dat.formats);

/************************************/
/* ADDITIONAL RESULTS NOT IN TABLES */
/************************************/

/* POOR SLEEP ~ INCOME */
*crude;
proc surveyreg data=dat.final;
	strata strata; cluster cluster; weight weight;
		class pir_cat;
		model poor_sleep_reg = pir_cat /solution CLPARM;
		domain include;
run;  
*adjusted;
proc surveyreg data=dat.final;
        strata strata; cluster cluster; weight weight;
        class sleep_med pir_cat RIAGENDR RIDRETH1 birth_control cotinine_cat hrt obese;
        model poor_sleep_reg = pir_cat RIAGENDR RIDRETH1 RIDAGEYR  birth_control
                cotinine_cat hrt obese sleep_med /solution CLPARM;
		domain include;
run;
/* SHORT SLEEP ~ INCOME */
*crude;
proc surveyreg data=dat.final;
	strata strata; cluster cluster; weight weight;
		class pir_cat;
		model short_sleep_reg = pir_cat /solution CLPARM;
		domain include;
run; 
*adjusted;
proc surveyreg data=dat.final;
        strata strata; cluster cluster; weight weight;
        class sleep_med pir_cat RIAGENDR RIDRETH1 birth_control cotinine_cat hrt obese;
        model short_sleep_reg = pir_cat RIAGENDR RIDRETH1 RIDAGEYR  birth_control
                cotinine_cat hrt obese sleep_med /solution CLPARM;
		domain include;
run;
/* POOR SLEEP ~ EDUCATION */
*crude;
proc surveyreg data=dat.final;
strata strata; cluster cluster; weight weight;
		class DMDEDUC2;
		model poor_sleep_reg = DMDEDUC2 /solution CLPARM;
		domain include;
run; 
*adjusted;
proc surveyreg data=dat.final;
        strata strata; cluster cluster; weight weight;
        class sleep_med DMDEDUC2 RIAGENDR RIDRETH1 birth_control cotinine_cat hrt obese;
        model poor_sleep_reg = DMDEDUC2 RIAGENDR RIDRETH1 RIDAGEYR  birth_control
                cotinine_cat hrt obese sleep_med /solution CLPARM;
		domain include;
run;

/* SHORT SLEEP ~ EDUCATION */
*crude;
proc surveyreg data=dat.final;
strata strata; cluster cluster; weight weight;
		class DMDEDUC2;
		model short_sleep_reg = DMDEDUC2 /solution CLPARM;
		domain include;
run; 
*adjusted;
proc surveyreg data=dat.final;
        strata strata; cluster cluster; weight weight;
        class sleep_med DMDEDUC2 RIAGENDR RIDRETH1 birth_control cotinine_cat hrt obese;
        model short_sleep_reg = DMDEDUC2 RIAGENDR RIDRETH1 RIDAGEYR  birth_control
                cotinine_cat hrt obese sleep_med /solution CLPARM;
		domain include;
run;
/* CRP ~ poor sleep */
*crude;
proc surveyreg data=dat.final;
strata strata; cluster cluster; weight weight;
		class poor_sleep;
		model crp_log = poor_sleep /solution CLPARM;
		domain include;
run; 
*adjusted;
proc surveyreg data=dat.final;
        strata strata; cluster cluster; weight weight;
        class poor_sleep sleep_med RIAGENDR RIDRETH1 birth_control cotinine_cat hrt obese;
        model crp_log = poor_sleep RIAGENDR RIDRETH1 RIDAGEYR  birth_control
                cotinine_cat hrt obese sleep_med /solution CLPARM;
		domain include;
run;

/* CRP ~ short sleep */
*crude;
proc surveyreg data=dat.final;
strata strata; cluster cluster; weight weight;
		class short_sleep;
		model crp_log = short_sleep /solution CLPARM;
		domain include;
run; 
*adjusted;
proc surveyreg data=dat.final;
        strata strata; cluster cluster; weight weight;
        class short_sleep sleep_med RIAGENDR RIDRETH1 birth_control cotinine_cat hrt obese;
        model crp_log = short_sleep RIAGENDR RIDRETH1 RIDAGEYR  birth_control
                cotinine_cat hrt obese sleep_med /solution CLPARM;
		domain include;
run;
