*libname dat 'H:\Personal\NHANES SES sleep CRP';
libname dat 'C:\Users\Audrey\documents\nhanes_ses_sleep_crp';
options fmtsearch=(dat.formats);

/*********************************/
/* Supplemental Table 1 **********/
/*********************************/

/* CHECKING IF EXPOSURE->MEDIATOR, MEDIATOR->OUTCOME */


/* EXPOSURE->MEDIATOR */

/* edu->short_sleep YES */
ods output type3=edu_ss;
proc surveylogistic data=dat.final order=INTERNAL;
        strata strata; cluster cluster; weight weight;
        class sleep_med DMDEDUC2 RIAGENDR RIDRETH1 birth_control cotinine_cat hrt obese;
        model short_sleep = DMDEDUC2  RIAGENDR RIDRETH1 RIDAGEYR  birth_control
                cotinine_cat hrt obese sleep_med;
run;
/* edu->poor_sleep NO */
ods output type3=edu_ps;
proc surveylogistic data=dat.final order=INTERNAL;
        strata strata; cluster cluster; weight weight;
        class sleep_med DMDEDUC2 RIAGENDR RIDRETH1 birth_control cotinine_cat hrt obese;
        model poor_sleep = DMDEDUC2  RIAGENDR RIDRETH1 RIDAGEYR  birth_control
                cotinine_cat hrt obese sleep_med;
run;
/* inc->short_sleep YES */
ods output type3=inc_ss;
proc surveylogistic data=dat.final order=INTERNAL;
        strata strata; cluster cluster; weight weight;
        class sleep_med pir_cat RIAGENDR RIDRETH1 birth_control cotinine_cat hrt obese;
        model short_sleep = pir_cat RIAGENDR RIDRETH1 RIDAGEYR  birth_control
                cotinine_cat hrt obese sleep_med;
run;
/* inc->poor_sleep YES */
ods output type3=inc_ps;
proc surveylogistic data=dat.final order=INTERNAL;
        strata strata; cluster cluster; weight weight;
        class sleep_med pir_cat RIAGENDR RIDRETH1 birth_control cotinine_cat hrt obese;
        model poor_sleep = pir_cat RIAGENDR RIDRETH1 RIDAGEYR  birth_control
                cotinine_cat hrt obese sleep_med;
run;
/* MEDIATOR->OUTCOME */

/* short_sleep->CRP YES */
ods output effects=ss_crp;
proc surveyreg data=dat.final order=INTERNAL;
        strata strata; cluster cluster; weight weight;
        class short_sleep sleep_med RIAGENDR RIDRETH1 birth_control cotinine_cat hrt obese;
        model crp_log = short_sleep RIAGENDR RIDRETH1 RIDAGEYR  birth_control
                cotinine_cat hrt obese sleep_med /solution CLPARM;
run;
/* poor_sleep->CRP */
ods output effects=ps_crp;
proc surveyreg data=dat.final order=INTERNAL;
        strata strata; cluster cluster; weight weight;
        class sleep_med poor_sleep RIAGENDR RIDRETH1 birth_control cotinine_cat hrt obese;
        model crp_log =  poor_sleep RIAGENDR RIDRETH1 RIDAGEYR  birth_control
                cotinine_cat hrt obese sleep_med /solution CLPARM;
run;

data edu_ps (keep=effect ps_x2 ps_df ps_p); set edu_ps;
        ps_x2 = waldchisq; ps_df=df; ps_p=probchisq;
        where effect="DMDEDUC2";
run;
data edu_ss (keep=effect ss_x2 ss_df ss_p); set edu_ss;
        ss_x2 = waldchisq; ss_df=df; ss_p=probchisq;
        where effect="DMDEDUC2";
run;
data inc_ps (keep=effect ps_x2 ps_df ps_p); set inc_ps;
        ps_x2 = waldchisq; ps_df=df; ps_p=probchisq;
        where effect="pir_cat";
run;
data inc_ss (keep=effect ss_x2 ss_df ss_p); set inc_ss;
        ss_x2 = waldchisq; ss_df=df; ss_p=probchisq;
        where effect="pir_cat";
run;
data ss_crp (keep=effect ss_x2 ss_df ss_p); set ss_crp;
        where effect="short_sleep";
        ss_x2=fvalue; ss_df=numdf; ss_p=probf;
run;
data ps_crp(keep=effect ps_x2 ps_df ps_p); set ps_crp;
        where effect="poor_sleep";
        ps_x2=fvalue; ps_df=numdf; ps_p=probf;
run;

data ps_crp; set ps_crp; effect="crp"; run;
data ss_crp; set ss_crp; effect="crp"; run;

data ss; set edu_ss inc_ss ss_crp; run;
data ps; set edu_ps inc_ps ps_crp; run;
proc sort data=ss; by effect; run;
proc sort data=ps; by effect; run;
data suppl_table1; merge ss ps; by effect; run;

proc export
  data=suppl_table1
  dbms=xlsx
  outfile="c:\users\audrey\documents\nhanes_ses_sleep_crp\suppl_table1.xlsx"
  replace;
run; quit;



proc contents data=edu_ps; run;
proc contents data=ss_crp; run;
