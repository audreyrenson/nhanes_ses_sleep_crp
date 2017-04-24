libname dat 'H:\Personal\NHANES SES sleep CRP';
*libname dat 'C:\Users\Audrey\Google Drive\CUNY SPH Coursework\EPID622 Applied Research- Data Management\NHANES SES sleep CRP';
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
/**************************/
/* 0. CRUDE TOTAL EFFECTS */
/**************************/
/* income */
ods output parameterestimates=te_crude_pir;
proc surveyreg data=dat.final;
	strata strata; cluster cluster; weight weight;
		class pir_cat;
		model crp_log = pir_cat /solution CLPARM;
run; 
/* education */
ods output parameterestimates=te_crude_edu;
proc surveyreg data=dat.final;
	strata strata; cluster cluster; weight weight;
		class DMDEDUC2;
		model crp_log = DMDEDUC2 /solution CLPARM;
run; 
data te_crude (keep=param est_TE_crude lwr_TE_crude upr_TE_crude); set te_crude_edu te_crude_pir;
	param=parameter; est_TE_crude=estimate; lwr_TE_crude=LowerCL; upr_TE_crude=UpperCL;
run;


/**************************************************************/
/* 1. EXPOSURE=INCOME, MEDIATOR=POOR SLEEP (with interaction) */
/**************************************************************/
/*total effect*/

ods output parameterestimates=p;
proc surveyreg data=dat.final;
        strata strata; cluster cluster; weight weight;
        class sleep_med pir_cat RIAGENDR RIDRETH1 birth_control cotinine_cat hrt obese;
        model crp_log = pir_cat RIAGENDR RIDRETH1 RIDAGEYR  birth_control
                cotinine_cat hrt obese sleep_med /solution CLPARM;
run;
proc print data=p; run;
data total_effect_pir (keep=parameter estimate probt lowercl uppercl);
        set p (firstobs=2 obs=4);
run;


/*outcome regression*/
proc surveyreg data=outboot order=INTERNAL;* 1. outcome model;
        by replicate;
        strata strata; cluster cluster; weight weight;
        class poor_sleep sleep_med pir_cat
                RIAGENDR RIDRETH1
                birth_control cotinine_cat hrt obese;
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
proc surveyreg data=outboot order=INTERNAL;
        by replicate;
        strata strata; cluster cluster; weight weight;
        class poor_sleep sleep_med pir_cat
                RIAGENDR RIDRETH1
                birth_control cotinine_cat hrt obese;
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
data dat.result_income_poorsleep; set result_income_poorsleep; run;
proc print data=result_income_poorsleep;
        title "Indirect Effect Estimates for Income Mediated by Poor Sleep.";
        ods select all;
run;

/*************************************************************/
/* 2. EXPOSURE=INCOME, MEDIATOR=SHORT SLEEP (no interaction) */
/*************************************************************/


/*outcome regression*/
proc surveyreg data=outboot order=INTERNAL;* 1. outcome model;
        by replicate;
        strata strata; cluster cluster; weight weight;
        class short_sleep sleep_med pir_cat
                RIAGENDR RIDRETH1
                birth_control cotinine_cat hrt obese;
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
proc surveyreg data=outboot order=INTERNAL;
        by replicate;
        strata strata; cluster cluster; weight weight;
        class short_sleep sleep_med pir_cat
                RIAGENDR RIDRETH1
                birth_control cotinine_cat hrt obese;
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
data dat.result_income_shortsleep; set result_income_shortsleep; run;
proc print data=result_income_shortsleep;
        title "Indirect Effect Estimates for Income Mediated by Short Sleep.";
        ods select all;
run;

/****************************************************************/
/* 3. EXPOSURE=EDUCATION, MEDIATOR=SHORT SLEEP (no interaction) */
/****************************************************************/

/*total effect of education */

ods output parameterestimates=p;
proc surveyreg data=dat.final order=INTERNAL;
        strata strata; cluster cluster; weight weight;
        class sleep_med DMDEDUC2 RIAGENDR RIDRETH1 birth_control cotinine_cat hrt obese;
        model crp_log = DMDEDUC2  RIAGENDR RIDRETH1 RIDAGEYR  birth_control
                cotinine_cat hrt obese sleep_med /solution CLPARM;
run;
proc print data=p; run;
data total_effect (keep=parameter estimate probt lowercl uppercl est_exp lwr_exp upr_exp);
        set total_effect_pir p (firstobs=2 obs=6);
        est_exp = exp(estimate);
        lwr_exp = exp(lowercl);
        upr_exp = exp(uppercl);
run;
proc print data=total_effect; run;


/*outcome regression*/
proc surveyreg data=outboot order=INTERNAL;* 1. outcome model;
        by replicate;
        strata strata; cluster cluster; weight weight;
        class short_sleep sleep_med DMDEDUC2
                RIAGENDR RIDRETH1
                birth_control cotinine_cat hrt obese;
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
proc surveyreg data=outboot order=INTERNAL;* 1. outcome model;
        by replicate;
        strata strata; cluster cluster; weight weight;
        class short_sleep sleep_med DMDEDUC2
                RIAGENDR RIDRETH1
                birth_control cotinine_cat hrt obese;
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
data dat.result_edu_shortsleep; set result_edu_shortsleep; run;
proc print data=result_edu_shortsleep;
        title "Indirect Effect Estimates for Education Mediated by Short Sleep.";
        ods select all;
run;


/* COMBINING ALL THE RESULTS INTO TABLE 3 */
/* edu / ss */
data edu_9to11 (keep=param est_ss lwr_ss upr_ss); set dat.result_edu_shortsleep ;
        param="DMDEDUC2 9-11th Grade (Includes 12th grade w"; est_ss=est_from9to11; lwr_ss=from9to11_2_5; upr_ss=from9to11_97_5;
run;
data edu_hs (keep=param est_ss lwr_ss upr_ss); set dat.result_edu_shortsleep ;
        param="DMDEDUC2 High School Grad/GED or Equivalent"; est_ss=est_highschool; lwr_ss=highschool_2_5; upr_ss=highschool_97_5;
run;
data edu_les9 (keep=param est_ss lwr_ss upr_ss); set dat.result_edu_shortsleep ;
        param="DMDEDUC2 Less Than 9th Grade"; est_ss=est_lessthan9th; lwr_ss=lessthan9th_2_5; upr_ss=lessthan9th_97_5;
run;
data edu_some (keep=param est_ss lwr_ss upr_ss); set dat.result_edu_shortsleep ;
        param="DMDEDUC2 Some College or AA degree"; est_ss=est_SomeCollege; lwr_ss=SomeCollege_2_5; upr_ss=SomeCollege_97_5;
run;
data table3; set edu_9to11 edu_hs edu_les9 edu_some; run;

/* income / ss */
data pir100  (keep=param est_ss lwr_ss upr_ss); set dat.result_income_shortsleep;
        param="pir_cat 0-100%"; est_ss=estimate100; lwr_ss=p_100_2_5; upr_ss=p_100_97_5;
run;
data pir199 (keep=param est_ss lwr_ss upr_ss); set dat.result_income_shortsleep;
        param="pir_cat 100-199%"; est_ss=estimate199; lwr_ss=p_199_2_5; upr_ss=p_199_97_5;
run;
data table3; set table3 pir100 pir199; run;

/* income / ps */
data pir100_ps  (keep=param est_ps lwr_ps upr_ps ); set dat.result_income_poorsleep;
        param="pir_cat 0-100%"; est_ps =estimate100; lwr_ps =p_100_2_5; upr_ps =p_100_97_5;
run;
data pir199_ps (keep=param est_ps lwr_ps upr_ps ); set dat.result_income_poorsleep;
        param="pir_cat 100-199%"; est_ps =estimate199; lwr_ps =p_199_2_5; upr_ps =p_199_97_5;
run;
data ps; set pir100_ps pir199_ps; run;
proc sort data=ps; by param; run;
proc sort data=table3; by param; run;
data te (keep=param est_TE lwr_TE upr_TE); set total_effect;
        param=parameter; est_TE=estimate; lwr_TE=LowerCL; upr_TE=UpperCL;
run;
proc sort data=te; by param; run;
data table3; merge te table3 ps; by param; run;

proc export
  data=table3
  dbms=xlsx
  outfile="C:\Users\Audrey\Google Drive\CUNY SPH Coursework\EPID622 Applied Research- Data Management\NHANES SES sleep CRP\table3.xlsx"
  replace;
run;
