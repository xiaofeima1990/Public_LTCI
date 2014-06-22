%% homework notation
%(a)	Build a GARCH model with Gaussian innovations for the log returns of GM stock. Write down the fitted model.
%(b)	Build a GARCH model with Student-t distribution for the log returns of GM stock, including estimation of the degrees of freedom. Write down the fitted model. Let v be the degrees of freedom of the Student-t distribution. Test the hypothesis H0 : v = 6 versus Ha : v ¡Ù6, using the 5% significance level (considering both the likely ratio method and the general t test. ).
%(c)	Build an EGARCH model for the log returns of GM stock. What is the fitted model?
%(d)	Build a GARCH model for the log returns of GM stock with Student-t whose distribution of degree of freedom is 6.5 and no intercept in mean equation. Write down the fitted model.
%(e)	Obtain 1-step- to 6-step-ahead volatility forecasts for all the models obtained. Plot the forecasts.


%% Build a GARCH model with Gaussian innovations for the log returns of GM stock. Write down the fitted model.
clear
clc
load('mgmsp5008.mat');
GM=mgmsp5008(:,2);
GM=log(GM+1);

count=1;
pflag=0;
flag=zeros(256,4);
AIC1=zeros(256,1);
BIC1=zeros(256,1);
for r=0:3
    for m=0:3
        for q=0:3
            for p=0:3
            if(q==0)
                pflag=p;
                p=0;
            end       
spec1=garchset('R',r,'M',m,'P',p,'Q',q,'Distribution','Gaussian','Display','off');
[~,~,LLF,~,~,~] = garchfit(spec1,GM);
% garchdisp(Coeff1,Errors1);

flag(count,:)=[r,m,p,q];
%[h1,pValue1,stat1,cValue1] = archtest(Innovations1);
[AIC1(count,1),BIC1(count,1)] = aicbic(LLF,garchcount(spec1),length(GM));
count=count+1;
p=pflag;
            end
        end
    end
end

[~,lag]=min(AIC1); % AR 2 MA 3 P 3 Q 3 
spec=garchset('R',flag(lag,1),'M',flag(lag,2),'P',flag(lag,3),'Q',flag(lag,4),'Distribution','Gaussian','Display','off');
[Coeff1,Errors1,LLF1,Innovations1,Sigmas1,Summary1] = garchfit(spec,GM);

% *fit result*
garchdisp(Coeff1,Errors1);


% *6 step forecast  *
[SigmaForecast1,MeanForecast1,SigmaTotal1,MeanRMSE1] = garchpred(Coeff1,GM,6); 
plot(SigmaForecast1);
save('part1.mat','Coeff1','Errors1','GM','LLF1','SigmaForecast1'); 


%%	Build a GARCH model with Student-t distribution for the log returns of GM stock, 
% including estimation of the degrees of freedom. Write down the fitted model. 
% Let v be the degrees of freedom of the Student-t distribution. 
% Test the hypothesis H0 : v = 6 versus Ha : v ¡Ù6, 
% using the 5% significance level (considering both the likely ratio method and the general t test. ).

clear
clc
load('mgmsp5008.mat');
GM=mgmsp5008(:,2);
GM=log(GM+1);
temp=inf;
count=1;
pflag=0;

flag=zeros(256,4);
AIC1=zeros(256,1);
BIC1=zeros(256,1);
for r=0:3
    for m=0:3
        for q=0:3
            for p=0:3
            if(q==0)
                pflag=p;
                p=0;
            end       
spec2=garchset('VarianceModel','GARCH','R',r,'M',m,'P',p,'Q',q,'Distribution','T','DoF',(r+m+p+q+3),'Display','off','MaxIter',500);
[Coeff2,Error2,LLF,~,~,~] = garchfit(spec2,GM);
% garchdisp(Coeff1,Errors1);

flag(count,:)=[r,m,p,q];
%[h1,pValue1,stat1,cValue1] = archtest(Innovations1);
[AIC1(count,1),BIC1(count,1)] = aicbic(LLF,garchcount(spec2),length(GM));
[AIC,BIC] = aicbic(LLF,garchcount(spec2),length(GM));
if AIC<temp
    coeff=Coeff2;
    error=Error2;
    temp=AIC;
end

count=count+1;
p=pflag;
            end
        end
    end
end

[~,lag]=min(AIC1); %  
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

 save('part2.mat','Coeff2','Errors2','Errors2_test','Coeff2_test','LLF2','H_LR','H_t','SigmaForecast2'); 


%% Build an EGARCH model for the log returns of GM stock. What is the fitted model? 
clear
clc
load('mgmsp5008.mat');
GM=mgmsp5008(:,2);
GM=log(GM+1);
temp=inf;
count=1;
pflag=0;
flag=zeros(256,4);
AIC1=zeros(256,1);
BIC1=zeros(256,1);
for r=0:2
    for m=0:2
        for q=1:2
            for p=0:2
     
spec3=garchset('VarianceModel', 'EGARCH','R',r,'M',m,'P',p,'Q',q,'Distribution','Gaussian','Display','off');
[Coeff3,~,LLF,~,~,~] = garchfit(spec3,GM);
% garchdisp(Coeff1,Errors1);

flag(count,:)=[r,m,p,q];
%[h1,pValue1,stat1,cValue1] = archtest(Innovations1);
[AIC1(count,1),BIC1(count,1)] = aicbic(LLF,garchcount(spec3),length(GM));

count=count+1;

            end
        end
    end
end

[~,lag]=min(AIC1); %  
spec=garchset('VarianceModel', 'EGARCH','R',flag(lag,1),'M',flag(lag,2),'P',flag(lag,3),'Q',flag(lag,4),'Distribution','Gaussian','Display','off');
[Coeff3,Errors3,LLF3,~,~,~] = garchfit(spec,GM);
% *fit result*
garchdisp(Coeff3,Errors3);
% *forecast*
[SigmaForecast3,MeanForecast1,SigmaTotal1,MeanRMSE1] = garchpred(Coeff3,GM,6);
plot(SigmaForecast3);

%  save('part3.mat','Coeff3','Errors3','LLF3','SigmaForecast3'); 



%% Build a GARCH model for the log returns of GM stock with Student-t whose distribution of degree of freedom is 6.5 
% and no intercept in mean equation. Write down the fitted model.
clear
clc
load('mgmsp5008.mat');
GM=mgmsp5008(:,2);
GM=log(GM+1);

count=1;
pflag=0;
flag=zeros(256,4);
AIC1=zeros(256,1);
BIC1=zeros(256,1);
for r=0:3
    for m=0:3
        for q=0:3
            for p=0:3
            if(q==0)
                pflag=p;
                p=0;
            end       
spec4=garchset('VarianceModel', 'GARCH','C',0,'FixC',1,'AR',zeros(1,r),'MA',zeros(1,m),'GARCH',zeros(1,p),'ARCH',zeros(1,q),'Distribution','T','DoF',6.5,'FixDoF',1,'Display','off');
[~,~,LLF,~,~,~] = garchfit(spec4,GM);
% garchdisp(Coeff1,Errors1);

flag(count,:)=[r,m,p,q];
%[h1,pValue1,stat1,cValue1] = archtest(Innovations1);
[AIC1(count,1),BIC1(count,1)] = aicbic(LLF,garchcount(spec4),length(GM));
count=count+1;
p=pflag;
            end
        end
    end
end

[~,lag]=min(AIC1); %  
spec=garchset('VarianceModel', 'EGARCH','C',0,'FixC',1,'AR',zeros(1,flag(lag,1)),'MA',zeros(1,flag(lag,2)),'GARCH',zeros(1,flag(lag,3)),'ARCH',zeros(1,flag(lag,4)),'Distribution','T','DoF',6.5,'FixDoF',1,'Display','off');
[Coeff4,Errors4,LLF4,~,~,~] = garchfit(spec,GM);
% *fit result*
garchdisp(Coeff4,Errors4);
% *forecast*
[SigmaForecast4,MeanForecast1,SigmaTotal1,MeanRMSE1] = garchpred(Coeff4,GM,6); 
plot(SigmaForecast4);
 save('part4.mat','Coeff4','Errors4','LLF4','SigmaForecast4'); 



