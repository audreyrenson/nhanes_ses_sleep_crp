libname dat 'H:\Personal\NHANES SES sleep CRP';
options fmtsearch=(dat.formats);
data final;
	set dat.final;
run;
*bootstrapping the mean from the entire sample with 1000 replicates;
proc surveyselect data=final out=outboot 
	seed=30459584 
	method=urs 
	samprate=1 
	outhits 
	rep=1000; 
 run;
 proc contents data=outboot; run;
 proc freq data=outboot; tables replicate; run;
 proc univariate data=outboot; 
 	var LBXCRP;
	by replicate;
	output out=outall mean=mean;
run;

ods output modes=modal;
proc univariate data=outboot modes;
	var LBXCRP;
	by replicate;
run;
ods output close;
proc univariate data=outall;
	var mean;
run;
