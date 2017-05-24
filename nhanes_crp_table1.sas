libname dat 'H:\Personal\NHANES SES sleep CRP';
*libname dat 'C:\Users\Audrey\Google Drive\CUNY SPH Coursework\EPID622 Applied Research- Data Management\NHANES SES sleep CRP';
options fmtsearch=(dat.formats);

/**********************************/
/*   PAPER TABLE 1                */
/**********************************/

/* One-way frequencies */
ods output crosstabs=oneway_dmdeduc2 summary=summary;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables include*DMDEDUC2 /row; run;
ods output crosstabs=oneway_pir_cat;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables include*pir_cat/row; run;
ods output crosstabs=oneway_short_sleep;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables include*short_sleep/row; run;
ods output crosstabs=oneway_poor_sleep;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables include*poor_sleep/row; run;
ods output crosstabs=oneway_riagendr;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables include*riagendr/row; run;
ods output crosstabs=oneway_ridreth1;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables include*ridreth1/row; run;
ods output crosstabs=oneway_birth_control;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables  include*birth_control/row; run;
ods output crosstabs=oneway_cotinine_cat;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables include*cotinine_cat/row; run;
ods output crosstabs=oneway_hrt;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables include*hrt/row; run;
ods output crosstabs=oneway_obese;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables include*obese/row; run;
ods output crosstabs=oneway_sleep_med;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables include*sleep_med/row; run;
ods output crosstabs=oneway_phys_act;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables include*phys_act/row; run;



/*dmdeduc2 pir_cat short_sleep poor_sleep RIAGENDR RIDRETH1 birth_control */
/* cotinine_cat hrt obese sleep_med */
data oneway_dmdeduc2(keep=table value frequency percent); set oneway_dmdeduc2;
        value= vvalue(dmdeduc2); percent=rowpercent; where include=1; run;
data oneway_pir_cat (keep=table value frequency percent); set oneway_pir_cat;
        value= vvalue(pir_cat);  percent=rowpercent; where include=1;run;
data oneway_short_sleep(keep=table value frequency percent); set oneway_short_sleep;
        value= vvalue(short_sleep); percent=rowpercent; where include=1; run;
data oneway_poor_sleep(keep=table value frequency percent); set oneway_poor_sleep;
        value= vvalue(poor_sleep); percent=rowpercent; where include=1; run;
data oneway_RIAGENDR (keep=table value frequency percent); set oneway_RIAGENDR ;
        value= vvalue(RIAGENDR) ;  percent=rowpercent; where include=1; run;
data oneway_RIDRETH1 (keep=table value frequency percent); set oneway_RIDRETH1 ;
        value= vvalue(RIDRETH1) ; percent=rowpercent; where include=1; run;
data oneway_birth_control(keep=table value frequency percent); set oneway_birth_control;
        value= vvalue(birth_control); percent=rowpercent; where include=1; run;
data oneway_cotinine_cat(keep=table value frequency percent); set oneway_cotinine_cat;
        value= vvalue(cotinine_cat); percent=rowpercent; where include=1; run;
data oneway_hrt(keep=table value frequency percent); set oneway_hrt;
        value= vvalue(hrt);  percent=rowpercent; where include=1;run;
data oneway_obese (keep=table value frequency percent); set oneway_obese ;
        value= vvalue(obese) ;  percent=rowpercent; where include=1;run;
data oneway_sleep_med(keep=table value frequency percent); set oneway_sleep_med;
        value= vvalue(sleep_med);  percent=rowpercent; where include=1;run;
data oneway_phys_act(keep=table value frequency percent); set oneway_phys_act;
        value= vvalue(phys_act); percent=rowpercent;  where include=1;run;

data oneway;
        set oneway_dmdeduc2 oneway_pir_cat oneway_short_sleep oneway_poor_sleep
        oneway_RIAGENDR oneway_RIDRETH1 oneway_birth_control oneway_cotinine_cat
        oneway_hrt oneway_obese oneway_sleep_med oneway_phys_act;
        where percent < 100;
        percent = percent / 100;

        table= STRIP( TRANWRD(table, "Table include * ", "") );

run;



/* Two-way frequencies by poor sleep */
/*dmdeduc2 pir_cat short_sleep RIAGENDR RIDRETH1 birth_control */
/* cotinine_cat hrt obese sleep_med */
/* NEED TO FIGURE OUT AGE, CRP mean/SD */

ods output crosstabs=ps_DMDEDUC2 chisq=ps_DMDEDUC2_ch;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables include*DMDEDUC2*poor_sleep /row chisq; run;
ods output crosstabs=ps_pir_cat chisq=ps_pir_cat_ch;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables include*pir_cat*poor_sleep /row chisq; run;
ods output crosstabs=ps_short_sleep chisq=ps_short_sleep_ch;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables include*short_sleep*poor_sleep /row chisq; run;
ods output crosstabs=ps_riagendr chisq=ps_riagendr_ch;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables include*riagendr*poor_sleep /row chisq; run;
ods output crosstabs=ps_ridreth1 chisq=ps_ridreth1_ch;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables include*ridreth1*poor_sleep /row chisq; run;
ods output crosstabs=ps_birth_control chisq=ps_birth_control_ch;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables  include*birth_control*poor_sleep /row chisq; run;
ods output crosstabs=ps_cotinine_cat chisq=ps_cotinine_cat_ch;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables include*cotinine_cat*poor_sleep /row chisq; run;
ods output crosstabs=ps_hrt chisq=ps_hrt_ch;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables include*hrt*poor_sleep /row chisq; run;
ods output crosstabs=ps_obese chisq=ps_obese_ch;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables include*obese*poor_sleep /row chisq; run;
ods output crosstabs=ps_sleep_med chisq=ps_sleep_med_ch;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables include*sleep_med*poor_sleep /row chisq; run;
ods output crosstabs=ps_phys_act chisq=ps_phys_act_ch;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables include*phys_act*poor_sleep /row chisq; run;

*chi-sq p-values;
data ps_dmdeduc2_ch (keep=table cvalue1); set ps_dmdeduc2_ch;
		where substr(table, 1, 7) = "Table 2" AND label1="Pr > ChiSq"; table="DMDEDUC2"; run;
data ps_pir_cat_ch (keep=table cvalue1); set ps_pir_cat_ch;
        where substr(table, 1, 7) = "Table 2" AND label1="Pr > ChiSq"; table="pir_cat"; run;
data ps_short_sleep_ch (keep=table cvalue1); set ps_short_sleep_ch;
        where substr(table, 1, 7) = "Table 2" AND label1="Pr > ChiSq"; table="short_sleep"; run;
data ps_riagendr_ch (keep=table cvalue1); set ps_riagendr_ch ;
        where substr(table, 1, 7) = "Table 2" AND label1="Pr > ChiSq"; table="RIAGENDR"; run;
data ps_ridreth1_ch (keep=table cvalue1); set ps_ridreth1_ch;
        where substr(table, 1, 7) = "Table 2" AND label1="Pr > ChiSq"; table="RIDRETH1"; run;
data ps_birth_control_ch (keep=table cvalue1); set ps_birth_control_ch;
        where substr(table, 1, 7) = "Table 2" AND label1="Pr > ChiSq"; table="birth_control";  run;
data ps_cotinine_cat_ch (keep=table cvalue1); set ps_cotinine_cat_ch;
        where substr(table, 1, 7) = "Table 2" AND label1="Pr > ChiSq"; table="cotinine_cat"; run;
data ps_hrt_ch (keep=table cvalue1); set ps_hrt_ch;
        where substr(table, 1, 7) = "Table 2" AND label1="Pr > ChiSq"; table="hrt"; run;
data ps_obese_ch (keep=table cvalue1); set ps_obese_ch;
        where substr(table, 1, 7) = "Table 2" AND label1="Pr > ChiSq"; table="obese"; run;
data ps_sleep_med_ch (keep=table cvalue1); set ps_sleep_med_ch;
        where substr(table, 1, 7) = "Table 2" AND label1="Pr > ChiSq"; table="sleep_med"; run;
data ps_phys_act_ch (keep=table cvalue1); set ps_phys_act_ch;
        where substr(table, 1, 7) = "Table 2" AND label1="Pr > ChiSq"; table="phys_act"; run;


*frequencies;
data ps_dmdeduc2 (keep=table value frequency percent); set ps_dmdeduc2;
        value=vvalue(dmdeduc2); percent=rowpercent;  table="DMDEDUC2"; where poor_sleep=1 and include=1;  run;

data ps_pir_cat (keep=table value frequency percent); set ps_pir_cat;
        value= vvalue(pir_cat); percent=rowpercent;table="pir_cat"; where poor_sleep = 1 and include=1;  run;
data ps_short_sleep (keep=table value frequency percent); set ps_short_sleep;
        value=vvalue(short_sleep);percent=rowpercent;table="short_sleep"; where poor_sleep=1 and include=1;  run;
data ps_riagendr (keep=table value frequency percent); set ps_riagendr ;
        value=vvalue(riagendr ); percent=rowpercent;table="RIAGENDR"; where poor_sleep=1 and include=1;    run;
data ps_ridreth1(keep=table value frequency percent); set ps_ridreth1;
        value=vvalue(ridreth1); percent=rowpercent;table="RIDRETH1"; where poor_sleep=1 and include=1; run;
data ps_birth_control(keep=table value frequency percent); set ps_birth_control;
        value=vvalue(birth_control);percent=rowpercent; table="birth_control"; where poor_sleep=1 and include=1;  run;
data ps_cotinine_cat(keep=table value frequency percent); set ps_cotinine_cat;
        value=vvalue(cotinine_cat); percent=rowpercent;table="cotinine_cat"; where poor_sleep=1 and include=1; run;
data ps_hrt(keep=table value frequency percent); set ps_hrt;
        value=vvalue(hrt);percent=rowpercent; table="hrt"; where poor_sleep=1 and include=1; run;
data ps_obese(keep=table value frequency percent); set ps_obese;
        value=vvalue(obese);percent=rowpercent; table="obese"; where poor_sleep=1 and include=1; run;
data ps_sleep_med(keep=table value frequency percent); set ps_sleep_med;
        value=vvalue(sleep_med); percent=rowpercent;table="sleep_med"; where poor_sleep=1 and include=1; run;
data ps_phys_act(keep=table value frequency percent); set ps_phys_act;
        value=vvalue(phys_act); percent=rowpercent; table="phys_act"; where poor_sleep=1 and include=1; run;

*merge p-values with frequences;

data ps_dmdeduc2; merge ps_dmdeduc2 ps_dmdeduc2_ch; by table; run;
data ps_pir_cat; merge ps_pir_cat ps_pir_cat_ch; by table; run;
data ps_short_sleep; merge ps_short_sleep ps_short_sleep_ch; by table; run;
data ps_riagendr ; merge ps_riagendr ps_riagendr_ch; by table; run;
data ps_ridreth1; merge ps_ridreth1 ps_ridreth1_ch; by table; run;
data ps_birth_control; merge ps_birth_control ps_birth_control_ch; by table; run;
data ps_cotinine_cat; merge ps_cotinine_cat ps_cotinine_cat_ch; by table; run;
data ps_hrt; merge ps_hrt ps_hrt_ch; by table; run;
data ps_obese; merge ps_obese ps_obese_ch; by table; run;
data ps_sleep_med; merge ps_sleep_med ps_sleep_med_ch; by table; run;
data ps_phys_act; merge ps_phys_act ps_phys_act_ch; by table; run;
	
data ps (keep=table value ps_freq ps_perc ps_p);
        set ps_dmdeduc2   ps_pir_cat  ps_short_sleep  ps_riagendr ps_hrt
        ps_ridreth1  ps_birth_control ps_cotinine_cat ps_obese ps_sleep_med ps_phys_act;
		where frequency < 7310;

        ps_freq = frequency;
        ps_perc = percent * 0.01;
		ps_p = cvalue1;
run;

/* Two-way frequencies by short sleep */
/*dmdeduc2 pir_cat poor_sleep RIAGENDR RIDRETH1 birth_control */
/* cotinine_cat hrt obese sleep_med */


ods output crosstabs=ss_DMDEDUC2 chisq=ss_DMDEDUC2_ch;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables include*DMDEDUC2*short_sleep/row chisq; run;
ods output crosstabs=ss_pir_cat chisq=ss_pir_cat_ch;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables include*pir_cat*short_sleep/row chisq; run;
ods output crosstabs=ss_poor_sleep chisq=ss_poor_sleep_ch;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables include*poor_sleep*short_sleep/row chisq; run;
ods output crosstabs=ss_riagendr chisq=ss_riagendr_ch;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables include*riagendr*short_sleep/row chisq; run;
ods output crosstabs=ss_ridreth1 chisq=ss_ridreth1_ch;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables include*ridreth1*short_sleep/row chisq; run;
ods output crosstabs=ss_birth_control chisq=ss_birth_control_ch;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables  include*birth_control*short_sleep/row chisq; run;
ods output crosstabs=ss_cotinine_cat  chisq=ss_cotinine_cat_ch;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables include*cotinine_cat*short_sleep/row chisq; run;
ods output crosstabs=ss_hrt chisq=ss_hrt_ch;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables include*hrt*short_sleep/row chisq; run;
ods output crosstabs=ss_obese chisq=ss_obese_ch;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables include*obese*short_sleep/row chisq; run;
ods output crosstabs=ss_sleep_med chisq=ss_sleep_med_ch;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables include*sleep_med*short_sleep/row chisq; run;
ods output crosstabs=ss_phys_act chisq=ss_phys_act_ch;
proc surveyfreq data=dat.final; strata strata; cluster cluster; weight weight; tables include*phys_act*short_sleep/row chisq; run;

*chi sq p-values;
data ss_dmdeduc2_ch (keep=table cvalue1); set ss_dmdeduc2_ch;
		where substr(table, 1, 7) = "Table 2" AND label1="Pr > ChiSq"; table="DMDEDUC2"; run;
data ss_pir_cat_ch (keep=table cvalue1); set ss_pir_cat_ch;
        where substr(table, 1, 7) = "Table 2" AND label1="Pr > ChiSq"; table="pir_cat"; run;
data ss_poor_sleep_ch (keep=table cvalue1); set ss_poor_sleep_ch;
        where substr(table, 1, 7) = "Table 2" AND label1="Pr > ChiSq"; table="poor_sleep"; run;
data ss_riagendr_ch (keep=table cvalue1); set ss_riagendr_ch ;
        where substr(table, 1, 7) = "Table 2" AND label1="Pr > ChiSq"; table="RIAGENDR"; run;
data ss_ridreth1_ch (keep=table cvalue1); set ss_ridreth1_ch;
        where substr(table, 1, 7) = "Table 2" AND label1="Pr > ChiSq"; table="RIDRETH1"; run;
data ss_birth_control_ch (keep=table cvalue1); set ss_birth_control_ch;
        where substr(table, 1, 7) = "Table 2" AND label1="Pr > ChiSq"; table="birth_control";  run;
data ss_cotinine_cat_ch (keep=table cvalue1); set ss_cotinine_cat_ch;
        where substr(table, 1, 7) = "Table 2" AND label1="Pr > ChiSq"; table="cotinine_cat"; run;
data ss_hrt_ch (keep=table cvalue1); set ss_hrt_ch;
        where substr(table, 1, 7) = "Table 2" AND label1="Pr > ChiSq"; table="hrt"; run;
data ss_obese_ch (keep=table cvalue1); set ss_obese_ch;
        where substr(table, 1, 7) = "Table 2" AND label1="Pr > ChiSq"; table="obese"; run;
data ss_sleep_med_ch (keep=table cvalue1); set ss_sleep_med_ch;
        where substr(table, 1, 7) = "Table 2" AND label1="Pr > ChiSq"; table="sleep_med"; run;
data ss_phys_act_ch (keep=table cvalue1); set ss_phys_act_ch;
        where substr(table, 1, 7) = "Table 2" AND label1="Pr > ChiSq"; table="phys_act"; run;


*frequencies;
data ss_dmdeduc2 (keep=table value frequency percent); set ss_dmdeduc2;
        value=vvalue(dmdeduc2); percent=rowpercent; table="DMDEDUC2"; where short_sleep=1 and include=1;  run;
data ss_pir_cat (keep=table value frequency percent); set ss_pir_cat;
        value= vvalue(pir_cat);percent=rowpercent;  table="pir_cat"; where short_sleep = 1 and include=1;  run;
data ss_poor_sleep (keep=table value frequency percent); set ss_poor_sleep;
        value=vvalue(poor_sleep); percent=rowpercent; table="poor_sleep"; where short_sleep=1 and include=1;  run;
data ss_riagendr (keep=table value frequency percent); set ss_riagendr ;
        value=vvalue(riagendr );percent=rowpercent;  table="RIAGENDR"; where short_sleep=1 and include=1;    run;
data ss_ridreth1(keep=table value frequency percent); set ss_ridreth1;
        value=vvalue(ridreth1); percent=rowpercent; table="RIDRETH1"; where short_sleep=1 and include=1; run;
data ss_birth_control(keep=table value frequency percent); set ss_birth_control;
        value=vvalue(birth_control); percent=rowpercent; table="birth_control"; where short_sleep=1 and include=1;  run;
data ss_cotinine_cat(keep=table value frequency percent); set ss_cotinine_cat;
        value=vvalue(cotinine_cat); percent=rowpercent; table="cotinine_cat"; where short_sleep=1 and include=1; run;
data ss_hrt(keep=table value frequency percent); set ss_hrt;
        value=vvalue(hrt); percent=rowpercent; table="hrt"; where short_sleep=1 and include=1; run;
data ss_obese(keep=table value frequency percent); set ss_obese;
        value=vvalue(obese); percent=rowpercent; table="obese"; where short_sleep=1 and include=1; run;
data ss_sleep_med(keep=table value frequency percent); set ss_sleep_med;
        value=vvalue(sleep_med); percent=rowpercent; table="sleep_med"; where short_sleep=1 and include=1; run;
data ss_phys_act(keep=table value frequency percent); set ss_phys_act;
        value=vvalue(phys_act); percent=rowpercent; table="phys_act"; where short_sleep=1 and include=1; run;

*merge chi-sq with frequencies;
data ss_dmdeduc2; merge ss_dmdeduc2 ss_dmdeduc2_ch; by table; run;
data ss_pir_cat; merge ss_pir_cat ss_pir_cat_ch; by table; run;
data ss_poor_sleep; merge ss_poor_sleep ss_poor_sleep_ch; by table; run;
data ss_riagendr ; merge ss_riagendr ss_riagendr_ch; by table; run;
data ss_ridreth1; merge ss_ridreth1 ss_ridreth1_ch; by table; run;
data ss_birth_control; merge ss_birth_control ss_birth_control_ch; by table; run;
data ss_cotinine_cat; merge ss_cotinine_cat ss_cotinine_cat_ch; by table; run;
data ss_hrt; merge ss_hrt ss_hrt_ch; by table; run;
data ss_obese; merge ss_obese ss_obese_ch; by table; run;
data ss_sleep_med; merge ss_sleep_med ss_sleep_med_ch; by table; run;
data ss_phys_act; merge ss_phys_act ss_phys_act_ch; by table; run;

data ss (keep = table value ss_freq ss_perc ss_p);
        set ss_dmdeduc2   ss_pir_cat  ss_poor_sleep  ss_riagendr ss_hrt
        ss_ridreth1  ss_birth_control ss_cotinine_cat ss_obese ss_sleep_med ss_phys_act;
        where frequency < 2588;

        ss_freq = frequency;
        ss_perc = percent * 0.01;
		ss_p = cvalue1;
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
  outfile="h:\personal\NHANES SES sleep CRP\table1.xlsx"
  replace;
run;
