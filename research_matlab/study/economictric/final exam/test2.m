
load('garch_data.mat')
warning off all

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
% garchdisp(Coeff1,Errors1);

flag(count,:)=[r,m,p,q];
%[h1,pValue1,stat1,cValue1] = archtest(Innovations1);
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

[H_LR, pValue, Stat, CriticalValue] = lratiotest(LLF_2c, LLF_2c_test, 2, 0.05);

disp('2.c result')
H_LR