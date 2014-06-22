%% 1 ARMA model
clear
clc
load arma_data
warning off all
    %% 1.a

    % plot the eries
    figure
    plot(arma_data);
    title('arma_data')

    % mean variance kurtosis median ...
    Data_mean=mean(arma_data);
    Data_variance=var(arma_data);
    Data_median=median(arma_data);
    Data_kurtosis=kurtosis(arma_data);
    Data_skewness=skewness(arma_data);

    % PACF with 15 lag
    figure
    parcorr(arma_data,15)

    % unit root test
    h_adf = adftest(arma_data);

    disp('the result of 1.a')
    Data_mean,Data_variance, Data_median, Data_kurtosis, Data_skewness,h_adf


    %% 1.b
    clc
    % find fitted AR model
    Order=10;               % number of alternative models
    AIC=zeros(Order+1,1);

    for ar=0:Order
        AR=garchset('R',ar,'Display','off');                   
        [~,~,LLF,~,~,~] = garchfit(AR,arma_data);   
        AIC(ar+1) = aicbic(LLF,ar+2);            
    end
    % Fitted AR
    [~,lag]=min(AIC); 
    AR=garchset('R',lag-1,'Display','off');
    [Coeff_AR,Errors_AR,LLF,Innovations,Sigmas,Summary] = garchfit(AR,arma_data);
    
    [h_LB,pValue,stat,cValue]= lbqtest(Innovations);

    disp('the result of 1.b')
    garchdisp(Coeff_AR,Errors_AR);
    h_LB 
    disp('we fail to reject the null autocorrelation of the series')

    %% 1.c
    clc
    NAR=4;
    NMA=4;
    AIC=zeros(5*5,1);
    flag=zeros(5*5,2);
    count=1;

    for ar=0:NAR
        for ma=0:NMA
        ARMA=garchset('R',ar,'M',ma,'Display','off');                   
        [~,~,LLF,~,~,~] = garchfit(ARMA,arma_data);
        flag(count,:)=[ar ma];
        AIC(count) = aicbic(LLF,ar+ma+2);
        count=count+1;
        end
    end

    plot([0:length(AIC)-1],AIC)
    [~,lag]=min(AIC);

    AR=garchset('R',flag(lag,1),'M',flag(lag,2),'Display','off');
    [Coeff_ARMA,Errors_ARMA,LLF,Innovations_ARMA,Sigmas,Summary] = garchfit(AR,arma_data);
    

    [h_arch,pValue1,stat1,cValue1] = archtest(Innovations_ARMA);
    
    disp('the result of 1.c')
    garchdisp(Coeff_ARMA,Errors_ARMA);
    h_arch
    disp('fail to reject null of no arch effect')

%% GARCH model
clear
clc

load('garch_data.mat')
warning off all

SP=garch_data(:,3);
GM=garch_data(:,2);

%% 2.a
count=1;
pflag=0;
nP=2;
nQ=2;

flag=zeros((2+1)^2,2);
AIC_garch=zeros((2+1)^2,1);
BIC_garch=zeros((2+1)^2,1);

for q=0:nQ
    for p=0:nP
        if(q==0)
            pflag=p;
            p=0;
        end
GARCH=garchset('VarianceModel','GARCH','P',p,'Q',q,'Display','off');
[~,~,LLF,~,~,~] = garchfit(GARCH,SP);


flag(count,:)=[p,q];

[AIC_garch(count,1),BIC_garch(count,1)] = aicbic(LLF,garchcount(GARCH),length(SP));

count=count+1;
if(q==0)
p=pflag;
end
    end
end

[~,lag]=min(AIC_garch); %  
spec=garchset('VarianceModel','GARCH','P',flag(lag,1),'Q',flag(lag,2),'Display','off');
[Coeff_garch,Errors_garch,LLF2,~,~,~] = garchfit(spec,SP);


garchdisp(Coeff_garch,Errors_garch);

[SigmaForecast_garch,MeanForecast_garch,SigmaTotal2,MeanRMSE2] = garchpred(Coeff_garch,SP,4); 
figure 
plot(1:4,SigmaForecast_garch,'-b');
title('forecast volatility')
legend('volatility')
figure
plot(1:4,MeanForecast_garch,'--r');
title('forecast return')
legend('return')

%% 2.b
% ar5 garch(1,1)
lgSP=log(SP+1);

ar=[0,0,0.2,0,0.1];
fix_ar=[1,1,0,1,0];
garch=0.1;
arch=0.1;
spec2=garchset('VarianceModel','GARCH','C',0,'FixC',1,'AR',ar,'FixAR',logical(fix_ar),...
'GARCH',garch,'ARCH',arch,'Distribution','T','DoF',8,'Display','off','MaxIter',600);
[Coeff_2b,Error_2b,LLF,~,~,~] = garchfit(spec2,lgSP);
% result of 2.b
disp('2.b')
garchdisp(Coeff_2b,Error_2b);

%% 2.c

SP=garch_data(:,3);
GM=garch_data(:,2);
count=1;


flag=zeros(3*3*3*2,4);
AIC1=zeros(3*3*3*2,1);
BIC1=zeros(3*3*3*2,1);
for r=0:2
    for m=0:2
        for q=1:2
            for p=0:2
ar=zeros(r,1);
ma=zeros(m,1);
garch=zeros(p,1);
arch=zeros(q,1);
spec2=garchset('AR',ar,'MA',ma,'GARCH',[],'arch',arch,'Distribution','Gaussian','Display','off','VarianceModel','EGARCH','Leverage',arch);
[Coeff2,Error2,LLF,~,~,~] = garchfit(spec2,GM);

flag(count,:)=[r,m,p,q];
[AIC1(count,1),BIC1(count,1)] = aicbic(LLF,garchcount(spec2),length(GM));
count=count+1;

            end
        end
    end
end

[~,lag]=min(AIC1); %  
spec=garchset('VarianceModel','EGARCH','AR',zeros(flag(lag,1),1),'MA',zeros(flag(lag,2),1),'GARCH',zeros(flag(lag,3),1),...
'ARCH',zeros(flag(lag,4),1),'Leverage',zeros(flag(lag,4),1),'Distribution','Gaussian','Display','off');
[Coeff_2c,Errors_2c,LLF_2c,~,~,~] = garchfit(spec,GM);

garchdisp(Coeff_2c,Errors_2c);


ar=Coeff_2c.AR;
arch=Coeff_2c.ARCH;
leverage=[0,0];
fix_leverage=logical([1,1]);
% lr test for leverage effect
spec=garchset('C',-0.00060919,'AR',ar,'K', -6.8767,...
'ARCH',Coeff_2c.ARCH,'Leverage',[0,0],'FixLeverage',fix_leverage,'Display','off','VarianceModel','EGARCH','Distribution','Gaussian');
[Coeff_2c_test,Errors_2c_test,LLF_2c_test,~,~,~] = garchfit(spec,GM);
garchdisp(Coeff_2c_test,Errors_2c_test);

[H_LR_2C, pValue, Stat, CriticalValue] = lratiotest(LLF_2c, LLF_2c_test, 2, 0.05);

% 2.c result
H_LR_2C
% leverage effect is not significant at the 5% level


%% VAR model
clear
clc
load('var_data.mat')
warning off all
Y=var_data(:,1:2);

%% 3.a 
count=1;
pflag=0;

flag=zeros(6,1);
AIC_var=zeros(6,1);
BIC_var=zeros(6,1);
for r=1:6 
    Spec20 = vgxset('n',2,'nAR',r,'Constant',true);
    [EstSpec20,~,LLF20,~]= vgxvarx(Spec20,Y(1+r+1:end,:),[],Y(1:1+r,:),'IgnoreMA','yes','CovarType','diagonal','StdErrType','all','MaxIter',800);
    flag(count,:)=r;
    [AIC_var(count,1),BIC_var(count,1)] = aicbic(LLF20,vgxcount(EstSpec20),length(Y(1+r+1:end,:)));
    count=count+1;
end

plot(1:6,AIC_var,1:6,BIC_var)
title('AIC BIC')
legend('AIC','BIC')

[~,lag]=min(BIC_var); %  
Spec20 = vgxset('n',2,'nAR',flag(lag,1),'Constant',true);
[EstSpec20,EstStdErrors20,LLF20,W20]= vgxvarx(Spec20,Y(1+r+1:end,:),[],Y(1:1+r,:),'IgnoreMA','yes','CovarType','diagonal','StdErrType','all','MaxIter',800);
% result of fitted VAR model
vgxdisp(EstSpec20, EstStdErrors20);


%% 3.b 
AR1_t=zeros(2,2);
AR2_t=zeros(2,2);
AR3_t=zeros(2,2);

%for the t ratio
AR1_t=abs(EstSpec20.AR{1}./EstStdErrors20.AR{1});
AR1_test=EstSpec20.AR{1}.*(AR1_t>0.9);
AR2_t=abs(EstSpec20.AR{2}./EstStdErrors20.AR{2});
AR2_test=EstSpec20.AR{2}.*(AR2_t>0.9);
AR3_t=abs(EstSpec20.AR{3}./EstStdErrors20.AR{3});
AR3_test=double(EstSpec20.AR{2}.*(AR3_t>0.9));
x=logical([1,1;0,1]);


a=EstSpec20.a;
Q=EstSpec20.Q;
Spec21 = vgxset('a',a,'AR',{AR1_test,AR2_test,AR3_test},'ARsolve',{x,x,x},'Q',Q);
[EstSpec21,EstStdErrors21,LLF21,W21]= vgxvarx(Spec21,Y,[],Y(1:4,:),'CovarType','diagonal','StdErrType','all','MaxIter',800);
vgxdisp(EstSpec21, EstStdErrors21);


[H_LR_VAR, pValue, Stat, CriticalValue] = lratiotest(LLF20, LLF21, 3, 0.05);
% result of LR test
H_LR_VAR
% coefficient is not significant
disp('the modified model')
% result of modified model
vgxdisp(EstSpec21, EstStdErrors21);


%% 3.c
% change to MA
SpecMA = vgxma(EstSpec21,6);
% result of impulse repsonse function
vgxdisp(SpecMA)

