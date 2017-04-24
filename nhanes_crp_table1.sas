*libname dat 'H:\Personal\NHANES SES sleep CRP';
libname dat 'C:\Users\Audrey\Google Drive\CUNY SPH Coursework\EPID622 Applied Research- Data Management\NHANES SES sleep CRP';
options fmtsearch=(dat.formats);
proc contents data=dat.final; run;

/* one-way frequencies */
/*dmdeduc2 pir_cat short_sleep poor_sleep RIAGENDR RIDRETH1 birth_control */
/* cotinine_cat hrt obese sleep_med */
/* NEED TO FIGURE OUT AGE, CRP mean/SD */

ods output OneWay=oneway_dmdeduc2;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables DMDEDUC2; run;
ods output OneWay=oneway_pir_cat;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables pir_cat; run;
ods output OneWay=oneway_short_sleep;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables short_sleep; run;
ods output OneWay=oneway_poor_sleep;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables poor_sleep; run;
ods output OneWay=oneway_riagendr;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables riagendr; run;
ods output OneWay=oneway_ridreth1;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables ridreth1; run;
ods output OneWay=oneway_birth_control;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables  birth_control; run;
ods output OneWay=oneway_cotinine_cat;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables cotinine_cat; run;
ods output OneWay=oneway_hrt;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables hrt; run;
ods output OneWay=oneway_obese;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables obese; run;
ods output OneWay=oneway_sleep_med;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables sleep_med; run;
ods output OneWay=oneway_phys_act;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables phys_act; run;



/*dmdeduc2 pir_cat short_sleep poor_sleep RIAGENDR RIDRETH1 birth_control */
/* cotinine_cat hrt obese sleep_med */
data oneway_dmdeduc2(keep=table value frequency percent); set oneway_dmdeduc2;
        value= vvalue(dmdeduc2); run;
data oneway_pir_cat (keep=table value frequency percent); set oneway_pir_cat;
        value= vvalue(pir_cat); run;
data oneway_short_sleep(keep=table value frequency percent); set oneway_short_sleep;
        value= vvalue(short_sleep); run;
data oneway_poor_sleep(keep=table value frequency percent); set oneway_poor_sleep;
        value= vvalue(poor_sleep); run;
data oneway_RIAGENDR (keep=table value frequency percent); set oneway_RIAGENDR ;
        value= vvalue(RIAGENDR) ;  run;
data oneway_RIDRETH1 (keep=table value frequency percent); set oneway_RIDRETH1 ;
        value= vvalue(RIDRETH1) ; run;
data oneway_birth_control(keep=table value frequency percent); set oneway_birth_control;
        value= vvalue(birth_control); run;
data oneway_cotinine_cat(keep=table value frequency percent); set oneway_cotinine_cat;
        value= vvalue(cotinine_cat); run;
data oneway_hrt(keep=table value frequency percent); set oneway_hrt;
        value= vvalue(hrt); run;
data oneway_obese (keep=table value frequency percent); set oneway_obese ;
        value= vvalue(obese) ; run;
data oneway_sleep_med(keep=table value frequency percent); set oneway_sleep_med;
        value= vvalue(sleep_med); run;
data oneway_phys_act(keep=table value frequency percent); set oneway_phys_act;
        value= vvalue(phys_act); run;

data oneway;
        set oneway_dmdeduc2 oneway_pir_cat oneway_short_sleep oneway_poor_sleep
        oneway_RIAGENDR oneway_RIDRETH1 oneway_birth_control oneway_cotinine_cat
        oneway_hrt oneway_obese oneway_sleep_med oneway_phys_act;
        where percent < 100;
        percent = percent / 100;

        table= STRIP( TRANWRD(table, "Table ", "") );

run;



/* Two-way frequencies by poor sleep */
/*dmdeduc2 pir_cat short_sleep RIAGENDR RIDRETH1 birth_control */
/* cotinine_cat hrt obese sleep_med */
/* NEED TO FIGURE OUT AGE, CRP mean/SD */

ods output crosstabs=ps_DMDEDUC2;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables DMDEDUC2*poor_sleep; run;
ods output crosstabs=ps_pir_cat;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables pir_cat*poor_sleep; run;
ods output crosstabs=ps_short_sleep;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables short_sleep*poor_sleep; run;
ods output crosstabs=ps_riagendr;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables riagendr*poor_sleep; run;
ods output crosstabs=ps_ridreth1;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables ridreth1*poor_sleep; run;
ods output crosstabs=ps_birth_control;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables  birth_control*poor_sleep; run;
ods output crosstabs=ps_cotinine_cat;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables cotinine_cat*poor_sleep; run;
ods output crosstabs=ps_hrt;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables hrt*poor_sleep; run;
ods output crosstabs=ps_obese;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables obese*poor_sleep; run;
ods output crosstabs=ps_sleep_med;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables sleep_med*poor_sleep; run;
ods output crosstabs=ps_phys_act;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables phys_act*poor_sleep; run;

data ps_dmdeduc2 (keep=table value frequency percent); set ps_dmdeduc2;
        value=vvalue(dmdeduc2); table="DMDEDUC2"; where poor_sleep=1;  run;
data ps_pir_cat (keep=table value frequency percent); set ps_pir_cat;
        value= vvalue(pir_cat); table="pir_cat"; where poor_sleep = 1;  run;
data ps_short_sleep (keep=table value frequency percent); set ps_short_sleep;
        value=vvalue(short_sleep);table="short_sleep"; where poor_sleep=1;  run;
data ps_riagendr (keep=table value frequency percent); set ps_riagendr ;
        value=vvalue(riagendr ); table="RIAGENDR"; where poor_sleep=1;    run;
data ps_ridreth1(keep=table value frequency percent); set ps_ridreth1;
        value=vvalue(ridreth1); table="RIDRETH1"; where poor_sleep=1; run;
data ps_birth_control(keep=table value frequency percent); set ps_birth_control;
        value=vvalue(birth_control); table="birth_control"; where poor_sleep=1;  run;
data ps_cotinine_cat(keep=table value frequency percent); set ps_cotinine_cat;
        value=vvalue(cotinine_cat); table="cotinine_cat"; where poor_sleep=1; run;
data ps_hrt(keep=table value frequency percent); set ps_hrt;
        value=vvalue(hrt); table="hrt"; where poor_sleep=1; run;
data ps_obese(keep=table value frequency percent); set ps_obese;
        value=vvalue(obese); table="obese"; where poor_sleep=1; run;
data ps_sleep_med(keep=table value frequency percent); set ps_sleep_med;
        value=vvalue(sleep_med); table="sleep_med"; where poor_sleep=1; run;
data ps_phys_act(keep=table value frequency percent); set ps_phys_act;
        value=vvalue(phys_act); table="phys_act"; where poor_sleep=1; run;

data ps (keep=table value ps_freq ps_perc);
        set ps_dmdeduc2   ps_pir_cat  ps_short_sleep  ps_riagendr ps_hrt
        ps_ridreth1  ps_birth_control ps_cotinine_cat ps_obese ps_sleep_med ps_phys_act;
        where frequency < 7310;

        ps_freq = frequency;
        ps_perc = 1/percent;
run;

/* Two-way frequencies by short sleep */
/*dmdeduc2 pir_cat poor_sleep RIAGENDR RIDRETH1 birth_control */
/* cotinine_cat hrt obese sleep_med */
/* NEED TO FIGURE OUT AGE, CRP mean/SD */

ods output crosstabs=ss_DMDEDUC2;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables DMDEDUC2*short_sleep; run;
ods output crosstabs=ss_pir_cat;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables pir_cat*short_sleep; run;
ods output crosstabs=ss_poor_sleep;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables poor_sleep*short_sleep; run;
ods output crosstabs=ss_riagendr;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables riagendr*short_sleep; run;
ods output crosstabs=ss_ridreth1;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables ridreth1*short_sleep; run;
ods output crosstabs=ss_birth_control;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables  birth_control*short_sleep; run;
ods output crosstabs=ss_cotinine_cat;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables cotinine_cat*short_sleep; run;
ods output crosstabs=ss_hrt;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables hrt*short_sleep; run;
ods output crosstabs=ss_obese;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables obese*short_sleep; run;
ods output crosstabs=ss_sleep_med;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables sleep_med*short_sleep; run;
ods output crosstabs=ss_phys_act;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables phys_act*short_sleep; run;


data ss_dmdeduc2 (keep=table value frequency percent); set ss_dmdeduc2;
        value=vvalue(dmdeduc2); table="DMDEDUC2"; where short_sleep=1;  run;
data ss_pir_cat (keep=table value frequency percent); set ss_pir_cat;
        value= vvalue(pir_cat); table="pir_cat"; where short_sleep = 1;  run;
data ss_poor_sleep (keep=table value frequency percent); set ss_poor_sleep;
        value=vvalue(poor_sleep); table="poor_sleep"; where short_sleep=1;  run;
data ss_riagendr (keep=table value frequency percent); set ss_riagendr ;
        value=vvalue(riagendr ); table="RIAGENDR"; where short_sleep=1;    run;
data ss_ridreth1(keep=table value frequency percent); set ss_ridreth1;
        value=vvalue(ridreth1); table="RIDRETH1"; where short_sleep=1; run;
data ss_birth_control(keep=table value frequency percent); set ss_birth_control;
        value=vvalue(birth_control); table="birth_control"; where short_sleep=1;  run;
data ss_cotinine_cat(keep=table value frequency percent); set ss_cotinine_cat;
        value=vvalue(cotinine_cat); table="cotinine_cat"; where short_sleep=1; run;
data ss_hrt(keep=table value frequency percent); set ss_hrt;
        value=vvalue(hrt); table="hrt"; where short_sleep=1; run;
data ss_obese(keep=table value frequency percent); set ss_obese;
        value=vvalue(obese); table="obese"; where short_sleep=1; run;
data ss_sleep_med(keep=table value frequency percent); set ss_sleep_med;
        value=vvalue(sleep_med); table="sleep_med"; where short_sleep=1; run;
data ss_phys_act(keep=table value frequency percent); set ss_phys_act;
        value=vvalue(phys_act); table="phys_act"; where short_sleep=1; run;
data ss (keep = table value ss_freq ss_perc);
        set ss_dmdeduc2   ss_pir_cat  ss_poor_sleep  ss_riagendr ss_hrt
        ss_ridreth1  ss_birth_control ss_cotinine_cat ss_obese ss_sleep_med ss_phys_act;
        where frequency < 2588;

        ss_freq = frequency;
        ss_perc = 1/percent;
run;

/* combine all into table1 */
proc datasets lib=work nolist;
       save oneway ss ps;
run;

proc sort data=oneway; by table value; run;
proc sort data=ss; by table value; run;
proc sort data=ps; by table value; run;

data table1;
        merge oneway ss ps;
        by table value;
run;
proc export
  data=table1
  dbms=xlsx
  outfile="C:\Users\Audrey\Google Drive\CUNY SPH Coursework\EPID622 Applied Research- Data Management\NHANES SES sleep CRP\table1.xlsx"
  replace;
run;
