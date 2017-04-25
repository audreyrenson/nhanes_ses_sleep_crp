libname dat 'H:\Personal\NHANES SES sleep CRP';
*libname dat 'C:\Users\Audrey\Google Drive\CUNY SPH Coursework\EPID622 Applied Research- Data Management\NHANES SES sleep CRP';
options fmtsearch=(dat.formats);

/*Mean CRP (log) by each variable & f test */
ods output parameterestimates=p effects=e;
proc surveyreg data=dat.final; title "univariable crp=edu";
        strata strata; cluster cluster; weight weight;
        class DMDEDUC2;
        model crp_log = DMDEDUC2 /solution noint;
run;
data p; set p; effect='DMDEDUC2'; run; data e; set e; where not(effect='Model'); run;
data edu (keep=effect parameter estimate probF); merge e p; by effect; run;

ods output parameterestimates=p effects=e;
proc surveyreg data=dat.final; title "univariable crp=pir_cat";
        strata strata; cluster cluster; weight weight;
        class pir_cat;
        model crp_log = pir_cat /solution noint;
run;
data p; set p; effect='pir_cat'; run; data e; set e; where not(effect='Model'); run;
data pir (keep=effect parameter estimate probF); merge e p; by effect; run;

ods output parameterestimates=p effects=e;
proc surveyreg data=dat.final; title "univariable crp=activity";
        strata strata; cluster cluster; weight weight;
        class phys_act;
        model crp_log = phys_act/solution noint;
        lsmeans phys_act;
run;
data p; set p; effect='phys_act'; run; data e; set e; where not(effect='Model'); run;
data phys (keep=effect parameter estimate probF); merge e p; by effect; run;

ods output parameterestimates=p effects=e;
proc surveyreg data=dat.final; title "univariable crp=gender";
        strata strata; cluster cluster; weight weight;
        class RIAGENDR;
        model crp_log = RIAGENDR /solution noint;
run;
data p; set p; effect='RIAGENDR'; run; data e; set e; where not(effect='Model'); run;
data gender (keep=effect parameter estimate probF); merge e p; by effect; run;

ods output parameterestimates=p effects=e;
proc surveyreg data=dat.final; title "univariable crp=race";
        strata strata; cluster cluster; weight weight;
        class RIDRETH1;
        model crp_log = RIDRETH1 /solution noint;
run;
data p; set p; effect='RIDRETH1'; run; data e; set e; where not(effect='Model'); run;
data race(keep=effect parameter estimate probF); merge e p; by effect; run;

ods output parameterestimates=p effects=e;
proc surveyreg data=dat.final; title "univariable crp=age";
        strata strata; cluster cluster; weight weight;
        class agecat;
        model crp_log = agecat /solution noint;
run;
data p; set p; effect='agecat'; run; data e; set e; where not(effect='Model'); run;
data age (keep=effect parameter estimate probF); merge e p; by effect; run;

ods output parameterestimates=p effects=e;
proc surveyreg data=dat.final; title "univariable crp=birth control";
        strata strata; cluster cluster; weight weight;
        class birth_control;
        model crp_log = birth_control /solution noint;
run;
data p; set p; effect='birth_control'; run; data e; set e; where not(effect='Model'); run;
data birth (keep=effect parameter estimate probF); merge e p; by effect; run;

ods output parameterestimates=p effects=e;
proc surveyreg data=dat.final; title "univariable crp=cotinine";
        strata strata; cluster cluster; weight weight;
        class cotinine_cat;
        model crp_log = cotinine_cat /solution noint;
run;
data p; set p; effect='cotinine_cat'; run; data e; set e; where not(effect='Model'); run;
data cotinine (keep=effect parameter estimate probF); merge e p; by effect; run;

ods output parameterestimates=p effects=e;
proc surveyreg data=dat.final; title "univariable crp=hrt";
        strata strata; cluster cluster; weight weight;
        class hrt;
        model crp_log = hrt /solution noint;
run;
data p; set p; effect='hrt'; run; data e; set e; where not(effect='Model'); run;
data hrt (keep=effect parameter estimate probF); merge e p; by effect; run;

ods output parameterestimates=p effects=e;
proc surveyreg data=dat.final; title "univariable crp=obese";
        strata strata; cluster cluster; weight weight;
        class obese;
        model crp_log = obese /solution noint;
run;
data p; set p; effect='obese'; run; data e; set e; where not(effect='Model'); run;
data obese (keep=effect parameter estimate probF); merge e p; by effect; run;

ods output parameterestimates=p effects=e;
proc surveyreg data=dat.final; title "univariable crp=poor sleep";
        strata strata; cluster cluster; weight weight;
        class poor_sleep;
        model crp_log = poor_sleep /solution noint;
run;
data p; set p; effect='poor_sleep'; run; data e; set e; where not(effect='Model'); run;
data poor (keep=effect parameter estimate probF); merge e p; by effect; run;

ods output parameterestimates=p effects=e;
proc surveyreg data=dat.final; title "univariable crp=sleep duration";
        strata strata; cluster cluster; weight weight;
        class short_sleep;
        model crp_log = short_sleep /solution noint;
run;
data p; set p; effect='short_sleep'; run; data e; set e; where not(effect='Model'); run;
data short (keep=effect parameter estimate probF); merge e p; by effect; run;

ods output parameterestimates=p effects=e;
proc surveyreg data=dat.final; title "univariable crp=sleep meds";
        strata strata; cluster cluster; weight weight;
        class sleep_med;
        model crp_log = sleep_med /solution noint;
run;
data p; set p; effect='sleep_med'; run; data e; set e; where not(effect='Model'); run;
data sleep_med (keep=effect parameter estimate probF); merge e p; by effect; run;

/* combine into table 2 */
data table2 (keep=effect parameter estimate exp_estimate pval);
        set edu pir phys gender race age birth cotinine hrt obese poor short sleep_med;

		if probF < 0.0001 then pval = "<0.0001";
        else pval = input(probF, 1.4);

		parameter = STRIP( TRANWRD(parameter, effect, "") );

		exp_estimate = exp(estimate);
run;
*get total geometric mean crp;
ods output statistics=mean_crp_log; 
proc surveymeans data=dat.final;
	strata strata; cluster cluster; weight weight;
	var crp_log;
run;
data geom_mean_crp (keep=geom_mean); set mean_crp_log; 
	geom_mean = exp(mean);
run;
proc print data=geom_mean_crp; title 'Geometric mean CRP (total)'; run;

proc export
  data=table2
  dbms=xlsx
  outfile="h:\personal\NHANES SES sleep CRP\table2.xlsx"
  replace;
run;

/* Checking residuals
ods graphics on;
proc glm data=dat.final order=INTERNAL;
        class DMDEDUC2(ref='College Graduate or above') PAD200(ref='Yes') poor_sleep(ref='Yes')
                RIAGENDR(ref='Male') RIDRETH1(ref='Non-Hispanic White') agecat(ref='20-24')
                birth_control(ref='No') cotinine_cat(ref='<3 ng/mL') hrt(ref='No')
                obese(ref='No') sleep_med(ref='No');
        model crp_log = DMDEDUC2 poor_sleep PAD200 RIAGENDR RIDRETH1 agecat birth_control
                cotinine_cat hrt obese sleep_med;
        OUTPUT OUT = C
                predicted = fit residual = resid
                rstudent = studentized_resid;
run;
proc univariate data=c;
        var resid;
        histogram;
run;
proc plot data=c;
plot resid*fit studentized_resid*fit;
run;

*/
