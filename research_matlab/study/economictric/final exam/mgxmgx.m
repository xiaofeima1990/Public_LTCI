%% 1 ARMA model
clear
clc
load arma_data
warning off all
    %% a


    figure
    plot(arma_data);

    Data_mean=mean(arma_data);
    Data_variance=var(arma_data);
    Data_median=median(arma_data);
    Data_kurtosis=kurtosis(arma_data);
    Data_skewness=skewness(arma_data);


    figure
    parcorr(arma_data,15)


    h_1 = adftest(arma_data);

    Data_mean,Data_variance, Data_median, Data_kurtosis, Data_skewness,h_1


    %% b
    % find fitted AR model
    Order=10;               % number of alternative models
    AIC=zeros(Order+1,1);

    for ar=0:Order
        AR=garchset('R',ar,'Display','off');                   
        [~,~,LLF,~,~,~] = garchfit(AR,arma_data);   
        AIC(ar+1) = aicbic(LLF,ar+2);            
    end
    % fitted AR
    [~,lag]=min(AIC); 
    AR=garchset('R',lag-1,'Display','off');
    [Coeff_AR,Errors_AR,LLF,Innovations,Sigmas,Summary] = garchfit(AR,arma_data);
    % LB test
    [h_LB,pValue,stat,cValue]= lbqtest(Innovations);

    disp('the result of 1.b')
    garchdisp(Coeff_AR,Errors_AR);
    h_LB 
    disp('we fail to reject the null autocorrelation of the series')

    %% c
    NAR=4;
    NMA=4;
    % number of alternative models
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

    plot([0:length(AIC)],AIC)
    [~,lag]=min(AIC);

    AR=garchset('R',flag(lag,1),'M',flag(lag,2),'Display','off');
    [Coeff_ARMA,Errors_ARMA,LLF,Innovations_ARMA,Sigmas,Summary] = garchfit(AR,arma_data);
    

    % arch test
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

%% a
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
% garchdisp(Coeff1,Errors1);

flag(count,:)=[p,q];
%[h1,pValue1,stat1,cValue1] = archtest(Innovations1);
[AIC_garch(count,1),BIC_garch(count,1)] = aicbic(LLF,garchcount(GARCH),length(SP));

count=count+1;
p=pflag;
    end
end

[~,lag]=min(AIC_garch); %  
spec=garchset('VarianceModel','GARCH','P',flag(lag,1),'Q',flag(lag,2),'Display','off');
[Coeff_garch,Errors_garch,LLF2,~,~,~] = garchfit(spec,SP);

% *fit result*
garchdisp(Coeff_garch,Errors_garch);

% *forecast*
[SigmaForecast_garch,MeanForecast_garch,SigmaTotal2,MeanRMSE2] = garchpred(Coeff_garch,SP,4); 
plot(SigmaForecast_garch,MeanForecast_garch);
legend('volatility','return')

% 



