function [sben scost AFP EPDVMedical]=fn_premium(gender,DEDUCT)
global simul
replicate(gender);

simul.N=10000;
simul.benefit=zeros(simul.N,simul.T);
simul.premium=zeros(simul.N,simul.T);
simul.sick_t=zeros(simul.N,simul.T);
simul.hstate=zeros(simul.N,simul.T);

% temp index for each in illness elimination
%现在改了，成为如果我病了去医院，每一次进去前三期保险公司不付钱第四期开始才付钱
eliminat_index=zeros(simul.N,1);


% simul.healthy_t=zeros(simul.N,1);
% simul.medcost=zeros(simul.N,simul.T);
% simul.benefit_all=zeros(simul.N,simul.T);
% simul.premium_all=zeros(simul.N,simul.T);
probmatrix=rand(simul.N,simul.T); 
% if gender==1 % male
%     probmatrix=rand(1:simul.N,simul.T); 
%     simul.B=simul.maleB;
%     simul.P=simul.maleP;
%     simul.M=simul.maleM;
%     simul.rfactor=simul.malerfactor;
%     simul.q=simul.qmi;
% elseif gender==0; %female
%     probmatrix=rand(1:simul.N,simul.T); 
%     simul.B=simul.femaleB;
%     simul.P=simul.femaleP;
%     simul.M=simul.femaleM;
%     simul.rfactor=simul.femalerfactor;
%     simul.q=simul.qfi;
% end;

for t=1:simul.T;
    if t==1;
        simul.hstate(:,t)=...
            1*(                                                                      probmatrix(:,t)<=simul.q(t,1)                                                                               )+...
            2*(probmatrix(:,t)>simul.q(t,1)                                         & probmatrix(:,t)<=simul.q(t,1)+simul.q(t,2)                                                                   )+...
            3*(probmatrix(:,t)>simul.q(t,1)+simul.q(t,2)                             & probmatrix(:,t)<=simul.q(t,1)+simul.q(t,2)+simul.q(t,3)                                                       )+...
            4*(probmatrix(:,t)>simul.q(t,1)+simul.q(t,2)+simul.q(t,3)                 & probmatrix(:,t)<=simul.q(t,1)+simul.q(t,2)+simul.q(t,3)+simul.q(t,4)                                           )+...
            5*(probmatrix(:,t)>simul.q(t,1)+simul.q(t,2)+simul.q(t,3)+simul.q(t,4)     & probmatrix(:,t)<=simul.q(t,1)+simul.q(t,2)+simul.q(t,3)+simul.q(t,4)+simul.q(t,5)                               );
        simul.sick_t(:,t)=(simul.hstate(:,t)==2)+(simul.hstate(:,t)==3)+ (simul.hstate(:,t)==4);
    elseif t>1;
        if( simul.hstate(:,t-1)==5)
            simul.hstate(:,t)=5;
        else
        simul.hstate(:,t)=...
            1*(                                                                      probmatrix(:,t)<=simul.q(t,1)                                                     ).*(simul.hstate(:,t-1)==1)+...
            2*(probmatrix(:,t)>simul.q(t,1)                                         & probmatrix(:,t)<=simul.q(t,1)+simul.q(t,2)                                         ).*(simul.hstate(:,t-1)==1)+...
            3*(probmatrix(:,t)>simul.q(t,1)+simul.q(t,2)                             & probmatrix(:,t)<=simul.q(t,1)+simul.q(t,2)+simul.q(t,3)                             ).*(simul.hstate(:,t-1)==1)+...
            4*(probmatrix(:,t)>simul.q(t,1)+simul.q(t,2)+simul.q(t,3)                 & probmatrix(:,t)<=simul.q(t,1)+simul.q(t,2)+simul.q(t,3)+simul.q(t,4)                 ).*(simul.hstate(:,t-1)==1)+...
            5*(probmatrix(:,t)>simul.q(t,1)+simul.q(t,2)+simul.q(t,3)+simul.q(t,4)     & probmatrix(:,t)<=simul.q(t,1)+simul.q(t,2)+simul.q(t,3)+simul.q(t,4)+simul.q(t,5)     ).*(simul.hstate(:,t-1)==1)+...
            1*(                                                                      probmatrix(:,t)<=simul.q(t,6)                                                     ).*(simul.hstate(:,t-1)==2)+...
            2*(probmatrix(:,t)>simul.q(t,6)                                         & probmatrix(:,t)<=simul.q(t,6)+simul.q(t,7)                                         ).*(simul.hstate(:,t-1)==2)+...
            3*(probmatrix(:,t)>simul.q(t,6)+simul.q(t,7)                             & probmatrix(:,t)<=simul.q(t,6)+simul.q(t,7)+simul.q(t,8)                             ).*(simul.hstate(:,t-1)==2)+...
            4*(probmatrix(:,t)>simul.q(t,6)+simul.q(t,7)+simul.q(t,8)                 & probmatrix(:,t)<=simul.q(t,6)+simul.q(t,7)+simul.q(t,8)+simul.q(t,9)                 ).*(simul.hstate(:,t-1)==2)+...
            5*(probmatrix(:,t)>simul.q(t,6)+simul.q(t,7)+simul.q(t,8)+simul.q(t,9)     & probmatrix(:,t)<=simul.q(t,6)+simul.q(t,7)+simul.q(t,8)+simul.q(t,9)+simul.q(t,10)    ).*(simul.hstate(:,t-1)==2)+...        
            1*(                                                                      probmatrix(:,t)<=simul.q(t,11)                                                    ).*(simul.hstate(:,t-1)==3)+...
            2*(probmatrix(:,t)>simul.q(t,11)                                        & probmatrix(:,t)<=simul.q(t,11)+simul.q(t,12)                                       ).*(simul.hstate(:,t-1)==3)+...
            3*(probmatrix(:,t)>simul.q(t,11)+simul.q(t,12)                           & probmatrix(:,t)<=simul.q(t,11)+simul.q(t,12)+simul.q(t,13)                          ).*(simul.hstate(:,t-1)==3)+...
            4*(probmatrix(:,t)>simul.q(t,11)+simul.q(t,12)+simul.q(t,13)              & probmatrix(:,t)<=simul.q(t,11)+simul.q(t,12)+simul.q(t,13)+simul.q(t,14)             ).*(simul.hstate(:,t-1)==3)+...
            5*(probmatrix(:,t)>simul.q(t,11)+simul.q(t,12)+simul.q(t,13)+simul.q(t,14) & probmatrix(:,t)<=simul.q(t,11)+simul.q(t,12)+simul.q(t,13)+simul.q(t,14)+simul.q(t,15)).*(simul.hstate(:,t-1)==3)+...         
            1*(                                                                      probmatrix(:,t)<=simul.q(t,16)                                                    ).*(simul.hstate(:,t-1)==4)+...
            2*(probmatrix(:,t)>simul.q(t,16)                                        & probmatrix(:,t)<=simul.q(t,16)+simul.q(t,17)                                       ).*(simul.hstate(:,t-1)==4)+...
            3*(probmatrix(:,t)>simul.q(t,16)+simul.q(t,17)                           & probmatrix(:,t)<=simul.q(t,16)+simul.q(t,17)+simul.q(t,18)                          ).*(simul.hstate(:,t-1)==4)+...
            4*(probmatrix(:,t)>simul.q(t,16)+simul.q(t,17)+simul.q(t,18)              & probmatrix(:,t)<=simul.q(t,16)+simul.q(t,17)+simul.q(t,18)+simul.q(t,19)             ).*(simul.hstate(:,t-1)==4)+...
            5*(probmatrix(:,t)>simul.q(t,16)+simul.q(t,17)+simul.q(t,18)+simul.q(t,19) & probmatrix(:,t)<=simul.q(t,16)+simul.q(t,17)+simul.q(t,18)+simul.q(t,19)+simul.q(t,20)).*(simul.hstate(:,t-1)==4)+...         
            1*(                                                                      probmatrix(:,t)<=simul.q(t,21)                                                    ).*(simul.hstate(:,t-1)==5)+...
            2*(probmatrix(:,t)>simul.q(t,21)                                        & probmatrix(:,t)<=simul.q(t,21)+simul.q(t,22)                                       ).*(simul.hstate(:,t-1)==5)+...
            3*(probmatrix(:,t)>simul.q(t,21)+simul.q(t,22)                           & probmatrix(:,t)<=simul.q(t,21)+simul.q(t,22)+simul.q(t,23)                          ).*(simul.hstate(:,t-1)==5)+...
            4*(probmatrix(:,t)>simul.q(t,21)+simul.q(t,22)+simul.q(t,23)              & probmatrix(:,t)<=simul.q(t,21)+simul.q(t,22)+simul.q(t,23)+simul.q(t,24)             ).*(simul.hstate(:,t-1)==5)+...
            5*(probmatrix(:,t)>simul.q(t,21)+simul.q(t,22)+simul.q(t,23)+simul.q(t,24) & probmatrix(:,t)<=simul.q(t,21)+simul.q(t,22)+simul.q(t,23)+simul.q(t,24)+simul.q(t,25)).*(simul.hstate(:,t-1)==5);  
         simul.sick_t(:,t)=(simul.hstate(:,t)==2)+(simul.hstate(:,t)==3)+ (simul.hstate(:,t)==4);
        end
    end;
end;


%simul.sick 是储存了各个时期的健康状态

% for t=1:simul.T;
% simul.sick_t(:,t)=(simul.hstate(:,t)==2)+(simul.hstate(:,t)==3)+ (simul.hstate(:,t)==4);
% end     
deductileflag=cumsum(simul.sick_t,2);   
%     [indN,t_per]=find(deductileflag<20,'first');
%     deductflag(indN)=t_per;
simul.sick_dec=simul.sick_t;
     simul.sick_dec((deductileflag<=DEDUCT))=0;
% simul.sick_dec((deductileflag<=DEDUCT))=0;

%      simul.sick_t((simul.sick_dec==0))=0;
% for t=1:simul.T
%     simul.benefit(:,t)=...
%         (simul.hstate(:,t)==2).*(deductileflag(:,t)>DEDUCT)*simul.B(t,2)/simul.rfactor(t,1)+...
%         (simul.hstate(:,t)==3).*(deductileflag(:,t)>DEDUCT)*simul.B(t,3)/simul.rfactor(t,1)+...
%         (simul.hstate(:,t)==4).*(deductileflag(:,t)>DEDUCT)*simul.B(t,4)/simul.rfactor(t,1);         
%     simul.premium(:,t)=...
%         (simul.hstate(:,t)==1).*simul.P(t,1)/simul.rfactor(t,1)...
%         +(simul.hstate(:,t)==2).*simul.P(t,1).*(deductileflag(:,t)<=DEDUCT)/simul.rfactor(t,1)...
%         +(simul.hstate(:,t)==3).*simul.P(t,1).*(deductileflag(:,t)<=DEDUCT)/simul.rfactor(t,1)...
%         +(simul.hstate(:,t)==4).*simul.P(t,1).*(deductileflag(:,t)<=DEDUCT)/simul.rfactor(t,1); % pay premium only if knowing the firm is going to cover at least one period of my medical cost.       
%  end;
 

 
 for t=1:simul.T
     
      eliminat_index(:,1)=eliminat_index(:,1)+1*(simul.hstate(:,t)>1);
      eliminat_index(:,1)=eliminat_index(:,1).*(simul.hstate(:,t)>1);
     % 这个是 记录每次进入elimination 的情况
  
 simul.benefit(:,1)=simul.benefit(:,1)+ ...
        ((simul.hstate(:,t)==2).*simul.B(t,2)./simul.rfactor(t,1)+...
         (simul.hstate(:,t)==3).*simul.B(t,3)./simul.rfactor(t,1)+...
         (simul.hstate(:,t)==4).*simul.B(t,4)./simul.rfactor(t,1)).*(eliminat_index(:,1)>DEDUCT);
 
simul.premium(:,1)=simul.premium(:,1)+...
        (simul.hstate(:,t)==1).*simul.P(t,1)/simul.rfactor(t,1)...
        +((simul.hstate(:,t)==2).*simul.P(t,1)./simul.rfactor(t,1)...
        +(simul.hstate(:,t)==3).*simul.P(t,1)./simul.rfactor(t,1)...
        +(simul.hstate(:,t)==4).*simul.P(t,1)./simul.rfactor(t,1)).*(eliminat_index(:,1)<=DEDUCT);  
 
 
 end
 
 
sben=sum(mean(simul.benefit(:,:)));
scost=sum(mean(simul.premium(:,:)));

AFP = (sben/scost)*simul.Prem;
% para.P=para.P*(AFP/para.insload);
% EPDVMedical=sum(mean(simul.medcost(:,:)));
% sben_all=sum(mean(simul.benefit_all(:,:)));
% scost_partner=sum(mean(simul.benefit_partner(:,:)));














