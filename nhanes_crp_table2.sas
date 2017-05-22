*libname dat 'H:\Personal\NHANES SES sleep CRP';
libname dat 'C:\Users\Audrey\documents\NHANES_SES_sleep_CRP';
options fmtsearch=(dat.formats);

/**************************************/
/*  PAPER TABLE 2   *******************/
/**************************************/

/*Mean CRP (log) by each variable & f test */
ods output parameterestimates=p effects=e;
proc surveyreg data=dat.final; title "univariable crp=edu";
        strata strata; cluster cluster; weight weight;
        class DMDEDUC2;
        model crp_log = DMDEDUC2 /solution noint;
		domain include;
run;
data p; set p; effect='DMDEDUC2'; where include=1; run; data e; set e; where not(effect='Model') and include=1; run;
data edu (keep=effect parameter estimate probF); length effect $15; merge e p; by effect; run;

ods output parameterestimates=p effects=e;
proc surveyreg data=dat.final; title "univariable crp=pir_cat";
        strata strata; cluster cluster; weight weight;
        class pir_cat;
        model crp_log = pir_cat /solution noint;
		domain include;
run;
data p; set p; effect='pir_cat'; where include=1; run; data e; set e; where not(effect='Model') and include=1; run;
data pir (keep=effect parameter estimate probF); length effect $15; merge e p; by effect; run;

ods output parameterestimates=p effects=e;
proc surveyreg data=dat.final; title "univariable crp=activity";
        strata strata; cluster cluster; weight weight;
        class phys_act;
        model crp_log = phys_act/solution noint;
        lsmeans phys_act;
		domain include;
run;
data p; set p; effect='phys_act'; where include=1;run; data e; set e; where not(effect='Model') and include=1; run;
data phys (keep=effect parameter estimate probF); length effect $15; merge e p; by effect; run;

ods output parameterestimates=p effects=e;
proc surveyreg data=dat.final; title "univariable crp=gender";
        strata strata; cluster cluster; weight weight;
        class RIAGENDR;
        model crp_log = RIAGENDR /solution noint;
		domain include;
run;
data p; set p; effect='RIAGENDR';where include=1; run; data e; set e; where not(effect='Model') and include=1; run;
data gender (keep=effect parameter estimate probF); length effect $15; merge e p; by effect; run;

ods output parameterestimates=p effects=e;
proc surveyreg data=dat.final; title "univariable crp=race";
        strata strata; cluster cluster; weight weight;
        class RIDRETH1;
        model crp_log = RIDRETH1 /solution noint;
		domain include;
run;
data p; set p; effect='RIDRETH1';where include=1; run; data e; set e; where not(effect='Model') and include=1; run;
data race(keep=effect parameter estimate probF);length effect $15;  merge e p; by effect; run;

ods output parameterestimates=p effects=e;
proc surveyreg data=dat.final; title "univariable crp=age";
        strata strata; cluster cluster; weight weight;
        class agecat;
        model crp_log = agecat /solution noint;
		domain include;
run;
data p; set p; effect='agecat'; where include=1;run; data e; set e; where not(effect='Model') and include=1; run;
data age (keep=effect parameter estimate probF); length effect $15; merge e p; by effect; run;

ods output parameterestimates=p effects=e;
proc surveyreg data=dat.final; title "univariable crp=birth control";
        strata strata; cluster cluster; weight weight;
        class birth_control;
        model crp_log = birth_control /solution noint;
		domain include;
run;
data p; set p; effect='birth_control'; where include=1;run; data e; set e; where not(effect='Model') and include=1; run;
data birth (keep=effect parameter estimate probF);length effect $15;  merge e p; by effect; run;

ods output parameterestimates=p effects=e;
proc surveyreg data=dat.final; title "univariable crp=cotinine";
        strata strata; cluster cluster; weight weight;
        class cotinine_cat;
        model crp_log = cotinine_cat /solution noint;
		domain include;
run;
data p; set p; effect='cotinine_cat';where include=1; run; data e; set e; where not(effect='Model') and include=1; run;
data cotinine (keep=effect parameter estimate probF);length effect $15;  merge e p; by effect; run;
ods output parameterestimates=p effects=e;
proc surveyreg data=dat.final; title "univariable crp=hrt";
        strata strata; cluster cluster; weight weight;
        class hrt;
        model crp_log = hrt /solution noint;
		domain include;
run;
data p; set p; effect='hrt'; where include=1; run;  data e; set e; where not(effect='Model') and include=1; run;
data hrt (keep=effect parameter estimate probF); length effect $15; merge e p; by effect; run;

ods output parameterestimates=p effects=e;
proc surveyreg data=dat.final; title "univariable crp=obese";
        strata strata; cluster cluster; weight weight;
        class obese;
        model crp_log = obese /solution noint;
		domain include;
run;
data p; set p; effect='obese'; where include=1; run; data e; set e; where not(effect='Model') and include=1; run;
data obese (keep=effect parameter estimate probF); length effect $15; merge e p; by effect; run;

ods output parameterestimates=p effects=e;
proc surveyreg data=dat.final; title "univariable crp=poor sleep";
        strata strata; cluster cluster; weight weight;
        class poor_sleep;
        model crp_log = poor_sleep /solution noint;
		domain include;
run;
data p; set p; effect='poor_sleep';where include=1; run; data e; set e; where not(effect='Model') and include=1; run;
data poor (keep=effect parameter estimate probF);length effect $15;  merge e p; by effect; run;

ods output parameterestimates=p effects=e;
proc surveyreg data=dat.final; title "univariable crp=sleep duration";
        strata strata; cluster cluster; weight weight;
        class short_sleep;
        model crp_log = short_sleep /solution noint;
		domain include;
run;
data p; set p; effect='short_sleep';where include=1; run; data e; set e; where not(effect='Model') and include=1; run;
data short (keep=effect parameter estimate probF); length effect $15; merge e p; by effect; run;

ods output parameterestimates=p effects=e;
proc surveyreg data=dat.final; title "univariable crp=sleep meds";
        strata strata; cluster cluster; weight weight;
        class sleep_med;
        model crp_log = sleep_med /solution noint;
		domain include;
run;
data p; set p; effect='sleep_med'; where include=1; run; data e; set e; where not(effect='Model') and include=1; run;
data sleep_med (keep=effect parameter estimate probF); length effect $15; merge e p; by effect; run;

/* combine into table 2 */
data table2 (keep=effect parameter estimate exp_estimate pval);
        set edu pir phys gender race age birth cotinine hrt obese poor short sleep_med;

        if probF < 0.0001 then pval = "<0.0001";
        else pval = input(probF, 1.4);

                parameter = STRIP( TRANWRD(parameter, STRIP(effect), "") );

                exp_estimate = exp(estimate);
run;
*get total geometric mean crp;
ods trace off;
ods output domain=mean_crp_log;
proc surveymeans data=dat.final;
        strata strata; cluster cluster; weight weight;
        var crp_log;
		domain include;
run;
data geom_mean_crp (keep=geom_mean); set mean_crp_log;
        geom_mean = exp(mean);
		where include=1;
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
proc glm data=dat.final order=INTERNAL PLOTS=DIAGNOSTICS;
        class DMDEDUC2 phys_act poor_sleep
                RIAGENDR RIDRETH1 agecat
                birth_control cotinine_cat hrt
                obese sleep_med;
        model crp_log = DMDEDUC2 poor_sleep phys_act RIAGENDR RIDRETH1 agecat birth_control
                cotinine_cat hrt obese sleep_med;

run; quit;
*/

