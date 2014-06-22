% 5_23 ����
%ARMA(p,q): r_t=c+sum(ar(p))+sum(ma(q));
%GARCH(m,s): 
%a_t=simga_t*epsile_t
%sigma_t_2=K + sum(a_t_2)+sum(sigma_t_2)


% ���ν�����Ҫ���н�����matlab�Դ��������� GARCHģ���Լ�VARMAģ�͡�
% ��Ҫ����  garchset garchfit garchpred aicbic

%% Simulation
N=1600;
M=1;

specsim=garchset('AR',[0.3,0.2],'MA',0.3,'C',1,'ARCH',[0.2,0.1],'GARCH',0.3,'K',1,'Distribution','T','DoF',4);
% �����simulation ���� t�ֲ� T(4)
[i_sim,s_sim,y_sim] = garchsim(specsim,N,M);
%y_sim -> r_t
%s_sim -> sigma_t
%i_sim -> a_t


y_sim=y_sim(1:end-100);
figure(1);
plot(y_sim);
figure(2);
plot((y_sim-mean(y_sim)).^2);
figure(3);
autocorr(y_sim,50);
figure(4);
parcorr(y_sim,50);
h=adftest(y_sim);

%% Estimation and Parametric test

load('mgmsp5008.mat');
y=mgmsp5008(:,3);
spec1=garchset('R',2,'M',1,'P',2,'Q',1,'Distribution','T','Display','on');
[Coeff1,Errors1,LLF1,Innovations1,Sigmas1,Summary1] = garchfit(spec1,y);
garchdisp(Coeff1,Errors1);

[h1,pValue1,stat1,cValue1] = archtest(Innovations1);
[AIC1,BIC1] = aicbic(LLF1,garchcount(spec1),length(y));
[SigmaForecast1,MeanForecast1,SigmaTotal1,MeanRMSE1] = garchpred(Coeff1,y,5); %��TMD�Ǵ����һ������Ԥ���~~~ �Ժ������arima class��Ԥ����  
plot(SigmaForecast1);


% Likely ratio test 
fix_ar=[0,1];% ��1 �ı�ʾ�̶�ĳ�׵Ĳ��� 
ar=[-0.7,0.1];
spec3=garchset('C',0,'K',0.5,'AR',ar,'FixAR',fix_ar,'MA',0.2,'GARCH',[0.2,0.1],'ARCH',0.3,'Distribution','T','Dof',4,'Display','off','MaxIter',300);
[Coeff3,Errors3,LLF3,Innovations3,Sigmas3,Summary3] = garchfit(spec3,y);
garchdisp(Coeff3,Errors3);

spec4=garchset('C',0,'AR',ar,'FixAR',fix_ar,'MA',0.2,'P',2,'Q',1,'Distribution','T','Display','off','MaxIter',300);
[Coeff4,Errors4,LLF4,Innovations4,Sigmas4,Summary4] = garchfit(spec4,y);
garchdisp(Coeff4,Errors4);

fix_garch=[0,1];
spec5=garchset('K',0.5,'R',2,'M',1,'GARCH',[0.2,0],'FixGARCH',fix_garch,'ARCH',0.3,'Distribution','T','Dof',4,'Display','off','MaxIter',300);
[Coeff5,Errors5,LLF5,Innovations5,Sigmas5,Summary5] = garchfit(spec5,y);
garchdisp(Coeff5,Errors5);

[H, pValue, Stat, CriticalValue] = lratiotest(LLF1, LLF5, 1, 0.05);% lqbtest LLF1 û�жԲ��������κ����ƣ�LLF5��GARCH 2 �Ĳ�������������

%% Examples of garchset

spec6=garchset('VarianceModel','GJR','AR',0.5,'MA',[0.3,-0.1],'GARCH',[0.4,0.3],'ARCH',0.2,'Distribution','T','Leverage',0.1);

spec7=garchset('R',1,'M',1,'P',1,'Q',1,'VarianceModel','EGARCH','Distribution','T');

spec8=garchset('R',4,'M',1,'P',0,'Q',0,'VarianceModel','Constant','Distribution','T');

%% Simple AR model estimate
Order=10;               % number of alternative models
AIC=zeros(Order,1);

for i=1:Order
    AR=garchset('R',i);                   
    [~,~,LLF,~,~,~] = garchfit(AR,y);   
    AIC(i) = aicbic(LLF,i+2);             % caution!  the variance and the constant are also parameters
end

plot(AIC);
[~,lag]=min(AIC);                         
AR=garchset('R',lag);
[Coeff,Errors,LLF,Innovations,Sigmas,Summary] = garchfit(AR,y);  % estimate the coefficient and corresponding errors. 



%%  VARMAģ�͵Ĺ��ơ�
% ��Ҫ������ vgxset �Լ� vgxvarx

clear all
clc

%% vgxset

%����VARMA�ķ��� �������� simulate Data����
Spec20 = vgxset('a', [0.1; -0.1], ...
	'b', [1.1, 0.9], ...
	'AR', {[0.6, 0.3; -0.4, 0.7], [0.3, 0.1; 0.05, 0.2]}, ...
    'MA', [0.5, -0.1; 0.07, 0.2], ...
	'Q', [0.3, 0.04; 0.04, 0.06]);
% b������������ϵ����
% Q��Э����ľ���

a=[0.5;0.2;0.1];
AR1 = [.3 -.1 .05;.1 .2 .1;-.1 .2 .4];
AR2 = [.1 .05 .001;.001 .1 .01;-.01 -.01 .2];
MA1 = [.5 .2 .1;.1 .6 .2;0 .1 .4];
MA2 = [.2 .1 .1; .05 .1 .05;.02 .04 .2];
Q = eye(3);
Spec21 = vgxset('a',a,'AR',{AR1,AR2},'MA',{MA1,MA2},'Q',Q);

Y_initial = [100 50 20;110 52 22]; % starting values
% vgxsim ��������VARMA simulation���е�
Y = vgxsim(Spec21,1000,[],Y_initial);
%% vgxar

clear;
clc;
load Y.mat

%% 
% VARMA ��һ�����÷�������Ҫ��������ģ�͵Ĺ���
Spec22 = vgxset('n',3,'nAR',4,'nMA',2,'Constant',true);
% vgxvarx ֻ��esitmate VARģ�� �޷�����VARMA ����Ҫ���� 'IgnoreMA','yes'
[EstSpec22,EstStdErrors22,LLF22,W22]= vgxvarx(Spec22,Y(5:end,:),[],Y(1:4,:),'IgnoreMA','yes','CovarType','full','StdErrType','all','MaxIter',800);
% ������ʾ
vgxdisp(EstSpec22, EstStdErrors22);


% vgxar ��VARMAģ��ת����VARģ��
SpecAR3 = vgxar(Spec21,4,1:4);
% ������ʾ
vgxdisp(SpecAR3);
%ģ�͹��� ��VAR
[EstSpec3,EstStdErrors3,LLF3,W3]= vgxvarx(SpecAR3,Y(5:end,:),[],Y(1:4,:),'IgnoreMA','yes');
vgxdisp(EstSpec3);

%% Specification Structures with Selected Parameter Values
% Granger ������� �Լ�����ֽ�

AR1 = [.3 -.1 .05;.1 .2 .1;-.1 .2 .4];
AR2 = [.1 .05 .001;.001 .1 .01;-.01 -.01 .2];
Spec25 = vgxset('a',a,'AR',{AR1,AR2},'ARsolve',{logical(eye(3)),logical(eye(3))},'MA',{MA1,MA2},'Q',Q);
[EstSpec25,EstStdErrors25,LLF25,W25]= vgxvarx(Spec25,Y(5:end,:),[],Y(1:4,:),'IgnoreMA','yes');
vgxdisp(EstSpec25, EstStdErrors25);

roots([3,2,1])
%��ƽ��
%ά�ɹ���
%��λ������