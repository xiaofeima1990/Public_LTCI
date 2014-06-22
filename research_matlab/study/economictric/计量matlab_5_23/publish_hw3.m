


%% part1
clear
clc
load('mgmsp5008.mat');
GM=mgmsp5008(:,2);
GM=log(GM+1);
load 'part1.mat'
lag =1;
flag=modelsetup1;
spec=garchset('R',flag(lag,1),'M',flag(lag,2),'P',flag(lag,3),'Q',flag(lag,4),'Distribution','Gaussian','Display','off');
[Coeff1,Errors1,LLF1,Innovations1,Sigmas1,Summary1] = garchfit(spec,GM);

% *fit result*
garchdisp(Coeff1,Errors1);


% *6 step forecast  *
[SigmaForecast1,MeanForecast1,SigmaTotal1,MeanRMSE1] = garchpred(Coeff1,GM,6); 
plot(SigmaForecast1);




%% part2
clear
clc
load('mgmsp5008.mat');
GM=mgmsp5008(:,2);
GM=log(GM+1);
load 'part2.mat'
lag =1;
flag=modelsetup2;
spec=garchset('VarianceModel','GARCH','R',flag(lag,1),'M',flag(lag,2),'P',flag(lag,3),'Q',flag(lag,4),'Distribution','T','DoF',(sum(flag(lag,:))+3),'Display','off','MaxIter',500);
[Coeff2,Errors2,LLF2,~,~,~] = garchfit(spec,GM);

% *fit result*
garchdisp(Coeff2,Errors2);

% *forecast*
[SigmaForecast2,MeanForecast2,SigmaTotal2,MeanRMSE2] = garchpred(Coeff2,GM,6); 
plot(SigmaForecast2);

% *test*
% HO: v=6
% _1:reject ; 0 : can not reject_
t_test=(Coeff2.DoF-6)/Errors2.DoF;
H_t=t_test > tinv(0.95,garchcount(spec));
H_t

% H0 : v=6   likelihood ratio test
spec_test=garchset('AR',zeros(1,flag(lag,1)),'MA',zeros(1,flag(lag,2)),'GARCH',zeros(1,flag(lag,3)),'ARCH',zeros(1,flag(lag,4)),'Distribution','T','DoF',6,'FixDoF',1,'Display','off');
[Coeff2_test,Errors2_test,LLF2_test,~,~,~] = garchfit(spec_test,GM);
garchdisp(Coeff2_test,Errors2_test);

% _1:reject ; 0 : can not reject_
[H_LR, pValue, Stat, CriticalValue] = lratiotest(LLF2, LLF2_test, 1, 0.05);

H_LR




%% part3
clear
clc
load('mgmsp5008.mat');
GM=mgmsp5008(:,2);
GM=log(GM+1);
load 'part3.mat'
lag =1;
flag=modelsetup3;
spec=garchset('VarianceModel', 'EGARCH','R',flag(lag,1),'M',flag(lag,2),'P',flag(lag,3),'Q',flag(lag,4),'Distribution','Gaussian','Display','off');
[Coeff3,Errors3,LLF3,~,~,~] = garchfit(spec,GM);
% *fit result*
garchdisp(Coeff3,Errors3);
% *forecast*
[SigmaForecast3,MeanForecast1,SigmaTotal1,MeanRMSE1] = garchpred(Coeff3,GM,6);
plot(SigmaForecast3);


%% part4
clear
clc
load('mgmsp5008.mat');
GM=mgmsp5008(:,2);
GM=log(GM+1);
load 'part4.mat'
lag =1;
flag=modelsetup4;
spec=garchset('VarianceModel', 'EGARCH','C',0,'FixC',1,'AR',zeros(1,flag(lag,1)),'MA',zeros(1,flag(lag,2)),'GARCH',zeros(1,flag(lag,3)),'ARCH',zeros(1,flag(lag,4)),'Distribution','T','DoF',6.5,'FixDoF',1,'Display','off');
[Coeff4,Errors4,LLF4,~,~,~] = garchfit(spec,GM);
% *fit result*
garchdisp(Coeff4,Errors4);
% *forecast*
[SigmaForecast4,MeanForecast1,SigmaTotal1,MeanRMSE1] = garchpred(Coeff4,GM,6); 
plot(SigmaForecast4);
