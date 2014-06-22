clear
clc
load('var_data.mat')
warning off all
Y=var_data(:,1:2);

load('var_data.mat')
% a 

count=1;
pflag=0;

flag=zeros(6,1);
AIC1=zeros(6,1);
BIC1=zeros(6,1);
for r=1:6 
    Spec20 = vgxset('n',2,'nAR',r,'Constant',true);
    [EstSpec20,EstStdErrors20,LLF20,W20]= vgxvarx(Spec20,Y(1+r+1:end,:),[],Y(1:1+r,:),'IgnoreMA','yes','CovarType','diagonal','StdErrType','all','MaxIter',800);
    flag(count,:)=r;
    [AIC1(count,1),BIC1(count,1)] = aicbic(LLF20,vgxcount(EstSpec20),length(Y(1+r+1:end,:)));
    count=count+1;
end

plot(1:6,AIC1,1:6,BIC1)
legend('AIC','BIC')

[~,lag]=min(BIC1); %  
Spec20 = vgxset('n',2,'nAR',flag(lag,1),'Constant',true);
[EstSpec20,EstStdErrors20,LLF20,W20]= vgxvarx(Spec20,Y(1+r+1:end,:),[],Y(1:1+r,:),'IgnoreMA','yes','CovarType','diagonal','StdErrType','all','MaxIter',800);
vgxdisp(EstSpec20, EstStdErrors20);


%% b 
AR1_t=zeros(2,2);
AR2_t=zeros(2,2);
AR3_t=zeros(2,2);

AR1_t=abs(EstSpec20.AR{1}./EstStdErrors20.AR{1});
AR1_test=EstSpec20.AR{1}.*(AR1_t>0.9);
AR1_fix=logical((AR1_t<0.9));
AR2_t=abs(EstSpec20.AR{2}./EstStdErrors20.AR{2});
AR2_test=EstSpec20.AR{2}.*(AR2_t>0.9);
AR2_fix=logical((AR2_t<0.9));
AR3_t=abs(EstSpec20.AR{3}./EstStdErrors20.AR{3});
AR3_test=double(EstSpec20.AR{2}.*(AR3_t>0.9));
AR3_fix=logical((AR3_t<0.9));
x=logical([1,1;0,1]);


a=EstSpec20.a;
Q=EstSpec20.Q;
Spec21 = vgxset('a',a,'AR',{AR1_test,AR2_test,AR3_test},'ARsolve',{x,x,x},'Q',Q);
[EstSpec21,EstStdErrors21,LLF21,W21]= vgxvarx(Spec21,Y,[],Y(1:4,:),'CovarType','diagonal','StdErrType','all','MaxIter',800);
vgxdisp(EstSpec21, EstStdErrors21);


[H_LR_VAR, pValue, Stat, CriticalValue] = lratiotest(LLF20, LLF21, 3, 0.05);

H_LR_VAR

vgxdisp(EstSpec21, EstStdErrors21);

%% c
SpecMA = vgxma(EstSpec21,6);

vgxdisp(EstSpec21, SpecMA)
