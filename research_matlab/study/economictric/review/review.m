%% 时间序列 数据预处理
% 去掉warning
% warning off all
% 由price求return
price=1000:1500; % 随机生成的一组price
ret=log(price(2:end)./price(1:end-1)); % 取log return
ret2=price(2:end)./price(1:end-1)-1;   % 取一般的return
% 去势 detrend -Remove linear trends
y=detrend(series);  
% 去季节性 deseason ->SeasonalFilters

% 单位根检验 adftest
[h,pValue,stat,cValue,reg]= adftest(series) %series must 是向量而不是矩阵
% autocorr（Y） parcorr（Y）

% 峰度 偏度
skewness 
kurtosis

%% Specification Testing
% Identify the parametric form of a model

[h1,pValue1,stat1,cValue1] = archtest(Innovations1);
% archtest     Engle test for residualheteroscedasticity
% autocorr     Sample autocorrelation
% crosscorr     Sample cross-correlation
% lbqtest       Ljung-Box Q-test forresidual autocorrelation
% parcorr       Sample partial autocorrelation
% 
% 
% 
% corrplot          Plot correlations between pairs of variables
% collintest        Belsley collinearity diagnostics
% 
% 
% 
% adftest           Augmented Dickey-Fuller test
% kpsstest          KPSS test for stationarity
% lmctest           Leybourne-McCabe stationarity test
% pptest            Phillips-Perron test for one unit root
% vratiotest        Variance ratio test for random walk
% i10test           Paired integration and stationarity tests
% 
% 
% 
% egcitest              Engle-Granger cointegrationtest
% jcitest           Johansen cointegrationtest
% jcontest          Johansen constrainttest


%% ARMA process
%using garchset model
simModel = arima('AR',{0.5,-0.3,0.4,-0.2},'MA',0.2,'Constant',0,'Variance',0.1);                
[y,a,v]=simulate(simModel,1000);


Order=10;               % number of alternative models
AIC=zeros(Order,1);

for i=1:Order
    AR=garchset('R',i);                   
    [~,~,LLF,~,~,~] = garchfit(AR,y);   
    AIC(i) = aicbic(LLF,i+2);             % caution!  the variance and the constant are also parameters
end
figure 
plot(AIC);
[~,lag]=min(AIC);                         
AR=garchset('R',lag);
[Coeff,Errors,LLF,Innovations,Sigmas,Summary] = garchfit(AR,y);  % estimate the coefficient and corresponding errors. 

%using arima
% 设置 constant 为 0 的 方法 ：model = arima(2,0,1); model.Constant = 0
Order=10;               % number of alternative models
AIC2=zeros(Order,1);
for i=1:Order
    AR=arima(i,0,0);                
    [fit,VarCov,LogL,info] = estimate(AR,y);   
    AIC2(i)=aicbic(LogL,i+2);           % caution!  the variance and the constant are also parameters
end
figure 
plot(AIC);
[~,lag]=min(AIC);   
 AR=arima(lag,0,0);                
 model = estimate(AR,y);
 
 
%% 协整检验
% egcitest
% 
% Engle-Granger cointegration test
% Engle-Granger tests assess the null hypothesis of no cointegrationamong the time series in Y. 
%The test regresses Y(:,1) on Y(:,2:end),then tests the residuals for a unit root
% 
% [h,pValue,stat,cValue,reg1,reg2] = egcitest(Y)
% [h,pValue,stat,cValue,reg1,reg2] = egcitest(Y,Name,Value)

load Data_Canada
Y = Data(:,3:end);
names = series(3:end);
plot(dates,Y)
legend(names,'location','NW')
grid on

[h,pValue,stat,cValue,reg] = egcitest(Y,'test',...
    {'t1','t2'});
% Y的第一列 分别于 Y的其余列进行协整分析


%Plot the estimated cointegratingrelation y1?Y2b?Xa:
%Y 一共有三组数据 Y1 Y2 Y3
a = reg(2).coeff(1);
b = reg(2).coeff(2:3); %
%a 是常数项 b是解释变量的系数 Y1=a+b1Y2+b2Y3
plot(dates,Y*[1;-b]-a)
grid on

%% GARCH ARMA
% how to simulate 
specsim=garchset('AR',[0.3,0.2],'MA',0.3,'C',1,'ARCH',[0.2,0.1],'GARCH',0.3,'K',1,'Distribution','T','DoF',4);
% 上面的simulation 服从 t分布 T(4)
[innovation_sim,sigma_sim,series_sim] = garchsim(specsim,N,M);
%innovation_sim-> innovation=epsion*sigma

% model setup:
% note: R-AR M-MA P-GARCH Q-ARCH  [R M P Q] only set up model's coefficient
% if we want to fix some specific parameter we need to use AR MA GARCH ARCH
% and [AR MA GARCH ARCH] need give initial value  

spec6=garchset('VarianceModel','GJR','AR',0.5,'MA',[0.3,-0.1],'GARCH',[0.4,0.3],'ARCH',0.2,'Distribution','T','Leverage',0.1);

spec7=garchset('R',1,'M',1,'P',1,'Q',1,'VarianceModel','EGARCH','Distribution','T');

spec8=garchset('R',4,'M',1,'P',0,'Q',0,'VarianceModel','Constant','Distribution','T');

% esitmation procedure 
spec1=garchset('R',2,'M',1,'P',2,'Q',1,'Distribution','T','Display','on');
[Coeff1,Errors1,LLF1,Innovations1,Sigmas1,Summary1] = garchfit(spec1,y);
%estimate 

garchdisp(Coeff1,Errors1);
%display

[h1,pValue1,stat1,cValue1] = archtest(Innovations1);
%test whether it is arch 
[AIC1,BIC1] = aicbic(LLF1,garchcount(spec1),length(y));
%information criteria
[SigmaForecast1,MeanForecast1,SigmaTotal1,MeanRMSE1] = garchpred(Coeff1,y,5); %这TMD是从最后一期往后预测的~~~ 以后就是用arima class做预测了  
%forecast
plot(SigmaForecast1);
%save function
save('garch.mat','Coeff1','Errors1','LLF1','AIC1','BIC1','SigmaForecast1'); 

%% LR ratio 
% lratiotest
% Likelihood ratio test of model specification
% 
% Syntax
% 
% [h,pValue,stat,cValue] = lratiotest(uLL,rLL,dof)
% [h,pValue,stat,cValue] = lratiotest(uLL,rLL,dof,alpha)

spec1=garchset('R',3,'M',1,'P',2,'Q',1,'Distribution','T','Display','off');
[Coeff1,Errors1,LLF1,Innovations1,Sigmas1,Summary1] = garchfit(spec1,y);
garchdisp(Coeff1,Errors1);


fix_garch=[0,1,0];
Fix_AR=[0,0,1];
spec5=garchset('C',0,'FixC',1,'AR',[0.2,0.3,0],'FixAR',Fix_AR,'MA',[0.2],'GARCH',[0.2,0],'ARCH',[0.2],'Distribution','T','Display','off','MaxIter',300);
[Coeff5,Errors5,LLF5,Innovations5,Sigmas5,Summary5] = garchfit(spec5,y);
garchdisp(Coeff5,Errors5);
% 受限制的参数设置

[H, pValue, Stat, CriticalValue] = lratiotest(LLF1, LLF5, 1, 0.05);
% lqbtest LLF1 没有对参数作出任何限制，LLF5对GARCH 2 的参数作出了限制

%% VAX
% this part is very very important!!!
% model set:
% 1 method 
% 2 dimension
Spec20 = vgxset('a', [0.1; -0.1], ...
	'b', [1.1, 0.9], ...
	'AR', {[0.6, 0.3; -0.4, 0.7], [0.3, 0.1; 0.05, 0.2]}, ...
    'MA', [0.5, -0.1; 0.07, 0.2], ...
	'Q', [0.3, 0.04; 0.04, 0.06]);

% 2 method 
%VARMA(2,2) 3-dimension
a=[0.5;0.2;0.1];
AR1 = [.3 -.1 .05;.1 .2 .1;-.1 .2 .4];
AR2 = [.1 .05 .001;.001 .1 .01;-.01 -.01 .2];
MA1 = [.5 .2 .1;.1 .6 .2;0 .1 .4];
MA2 = [.2 .1 .1; .05 .1 .05;.02 .04 .2];
Q = eye(3);
Spec21 = vgxset('a',a,'AR',{AR1,AR2},'MA',{MA1,MA2},'Q',Q);
Y_initial = [100 50 20;110 52 22]; 
%in method 2 we need to give initial value to estimate or simulate

Y = vgxsim(Spec21,1000,[],Y_initial);

%estimate vgxvarx
Spec22 = vgxset('n',3,'nAR',4,'nMA',2,'Constant',true);
% 'constant' 表面这个VAR是否带有截距项，默认是不带的 
[EstSpec22,EstStdErrors22,LLF22,W22]= vgxvarx(Spec22,Y(5:end,:),[],Y(1,:),'IgnoreMA','yes','CovarType','full','StdErrType','all','MaxIter',800);
%'IgnoreMA','yes', 必须加上，要不然运行不了
vgxdisp(EstSpec22, EstStdErrors22);

% matlab 无法估计MA VARMA 需要转化成VAR才行

%如何限制参数估计VAR :
load Data_VARMA22
[EstSpec, EstStdErrors] = vgxvarx(vgxar(Spec), Y, [], Y0);
vgxdisp(EstSpec, EstStdErrors);

EstW = vgxinfer(EstSpec, Y, [], Y0, W0);

subplot(2,1,1);
plot([ W(:,1), EstW(:,1) ]);
subplot(2,1,2);
plot([ W(:,2), EstW(:,2) ]);
legend('VARMA(2, 2)', 'VAR(2)');


SpecX = vgxset(vgxar(Spec),'AR',repmat({eye(2)},2,1), ...
	'ARsolve', repmat({ logical(eye(2)) }, 2, 1));

[EstSpecX, EstStdErrorsX] = vgxvarx(SpecX, Y, [], Y0);

% repmat Replicate and tile array setup the restrict element of coefficient
% matrix

%% rolling sample of GBM 
% 几何布朗运动的fminsearch
%rolling sample
r_estimate_GBM=zeros(413,1);
n=100;
for n=100:512
initial_GBM=[0.7731 -0.0051];
LLF_GBM=@(param)(sum(  0.5/param(1)*((r(2:n)-(param(2)+1)*r(1:n-1)).^2)./(r(1:n-1).^2)...
                    +  0.5*log(param(1))+  log(r(1:n-1))  +0.5*log(2*pi)  )); 
options=optimset('maxfunevals',580,'maxiter',7000);
[param,fval]=fminsearch(LLF_GBM,initial_GBM,options);
result_GBM=[param fval];

%estimate:
v=randn;
r_estimate_GBM(n+1-100)=(1+param(2))*r(n) ;
%+ param(1)^(0.5)*r(n)*v;
end
MSE_GBM=mean((r_estimate_GBM-r(101:end-1)).^2)




%% homework 3 for loop 定阶
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






