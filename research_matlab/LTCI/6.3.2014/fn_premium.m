function [sben scost]=fn_premium(para)

% load C:\Kuaipan\Research\LTCI\Partnership\simul
 load('simul.mat')
simul.N=10000;
simul.hstate=zeros(simul.N,para.T);
simul.sick_t=zeros(simul.N,1);
simul.benefit=zeros(simul.N,para.T);
simul.premium=zeros(simul.N,para.T);
simul.medcost_nominal=zeros(simul.N,1);
simul.Prem=150/1000;
% simul.healthy_t=zeros(simul.N,1);
% simul.medcost=zeros(simul.N,para.T);
% simul.benefit_all=zeros(simul.N,para.T);
% simul.premium_all=zeros(simul.N,para.T);

if para.singlem==1
    probmatrix=probmatrixm(1:simul.N,:); %#ok<NODEF>
elseif para.singlef==1;
    probmatrix=probmatrixf(1:simul.N,:); %#ok<NODEF>
end;

for t=1:para.T;
    if t==1;
        simul.hstate(:,t)=...
            1*(                                                                      probmatrix(:,t)<=para.q(t,1)                                                                               )+...
            2*(probmatrix(:,t)>para.q(t,1)                                         & probmatrix(:,t)<=para.q(t,1)+para.q(t,2)                                                                   )+...
            3*(probmatrix(:,t)>para.q(t,1)+para.q(t,2)                             & probmatrix(:,t)<=para.q(t,1)+para.q(t,2)+para.q(t,3)                                                       )+...
            4*(probmatrix(:,t)>para.q(t,1)+para.q(t,2)+para.q(t,3)                 & probmatrix(:,t)<=para.q(t,1)+para.q(t,2)+para.q(t,3)+para.q(t,4)                                           )+...
            5*(probmatrix(:,t)>para.q(t,1)+para.q(t,2)+para.q(t,3)+para.q(t,4)     & probmatrix(:,t)<=para.q(t,1)+para.q(t,2)+para.q(t,3)+para.q(t,4)+para.q(t,5)                               );
    elseif t>1;
        simul.hstate(:,t)=...
            1*(                                                                      probmatrix(:,t)<=para.q(t,1)                                                     ).*(simul.hstate(:,t-1)==1)+...
            2*(probmatrix(:,t)>para.q(t,1)                                         & probmatrix(:,t)<=para.q(t,1)+para.q(t,2)                                         ).*(simul.hstate(:,t-1)==1)+...
            3*(probmatrix(:,t)>para.q(t,1)+para.q(t,2)                             & probmatrix(:,t)<=para.q(t,1)+para.q(t,2)+para.q(t,3)                             ).*(simul.hstate(:,t-1)==1)+...
            4*(probmatrix(:,t)>para.q(t,1)+para.q(t,2)+para.q(t,3)                 & probmatrix(:,t)<=para.q(t,1)+para.q(t,2)+para.q(t,3)+para.q(t,4)                 ).*(simul.hstate(:,t-1)==1)+...
            5*(probmatrix(:,t)>para.q(t,1)+para.q(t,2)+para.q(t,3)+para.q(t,4)     & probmatrix(:,t)<=para.q(t,1)+para.q(t,2)+para.q(t,3)+para.q(t,4)+para.q(t,5)     ).*(simul.hstate(:,t-1)==1)+...
            1*(                                                                      probmatrix(:,t)<=para.q(t,6)                                                     ).*(simul.hstate(:,t-1)==2)+...
            2*(probmatrix(:,t)>para.q(t,6)                                         & probmatrix(:,t)<=para.q(t,6)+para.q(t,7)                                         ).*(simul.hstate(:,t-1)==2)+...
            3*(probmatrix(:,t)>para.q(t,6)+para.q(t,7)                             & probmatrix(:,t)<=para.q(t,6)+para.q(t,7)+para.q(t,8)                             ).*(simul.hstate(:,t-1)==2)+...
            4*(probmatrix(:,t)>para.q(t,6)+para.q(t,7)+para.q(t,8)                 & probmatrix(:,t)<=para.q(t,6)+para.q(t,7)+para.q(t,8)+para.q(t,9)                 ).*(simul.hstate(:,t-1)==2)+...
            5*(probmatrix(:,t)>para.q(t,6)+para.q(t,7)+para.q(t,8)+para.q(t,9)     & probmatrix(:,t)<=para.q(t,6)+para.q(t,7)+para.q(t,8)+para.q(t,9)+para.q(t,10)    ).*(simul.hstate(:,t-1)==2)+...        
            1*(                                                                      probmatrix(:,t)<=para.q(t,11)                                                    ).*(simul.hstate(:,t-1)==3)+...
            2*(probmatrix(:,t)>para.q(t,11)                                        & probmatrix(:,t)<=para.q(t,11)+para.q(t,12)                                       ).*(simul.hstate(:,t-1)==3)+...
            3*(probmatrix(:,t)>para.q(t,11)+para.q(t,12)                           & probmatrix(:,t)<=para.q(t,11)+para.q(t,12)+para.q(t,13)                          ).*(simul.hstate(:,t-1)==3)+...
            4*(probmatrix(:,t)>para.q(t,11)+para.q(t,12)+para.q(t,13)              & probmatrix(:,t)<=para.q(t,11)+para.q(t,12)+para.q(t,13)+para.q(t,14)             ).*(simul.hstate(:,t-1)==3)+...
            5*(probmatrix(:,t)>para.q(t,11)+para.q(t,12)+para.q(t,13)+para.q(t,14) & probmatrix(:,t)<=para.q(t,11)+para.q(t,12)+para.q(t,13)+para.q(t,14)+para.q(t,15)).*(simul.hstate(:,t-1)==3)+...         
            1*(                                                                      probmatrix(:,t)<=para.q(t,16)                                                    ).*(simul.hstate(:,t-1)==4)+...
            2*(probmatrix(:,t)>para.q(t,16)                                        & probmatrix(:,t)<=para.q(t,16)+para.q(t,17)                                       ).*(simul.hstate(:,t-1)==4)+...
            3*(probmatrix(:,t)>para.q(t,16)+para.q(t,17)                           & probmatrix(:,t)<=para.q(t,16)+para.q(t,17)+para.q(t,18)                          ).*(simul.hstate(:,t-1)==4)+...
            4*(probmatrix(:,t)>para.q(t,16)+para.q(t,17)+para.q(t,18)              & probmatrix(:,t)<=para.q(t,16)+para.q(t,17)+para.q(t,18)+para.q(t,19)             ).*(simul.hstate(:,t-1)==4)+...
            5*(probmatrix(:,t)>para.q(t,16)+para.q(t,17)+para.q(t,18)+para.q(t,19) & probmatrix(:,t)<=para.q(t,16)+para.q(t,17)+para.q(t,18)+para.q(t,19)+para.q(t,20)).*(simul.hstate(:,t-1)==4)+...         
            1*(                                                                      probmatrix(:,t)<=para.q(t,21)                                                    ).*(simul.hstate(:,t-1)==5)+...
            2*(probmatrix(:,t)>para.q(t,21)                                        & probmatrix(:,t)<=para.q(t,21)+para.q(t,22)                                       ).*(simul.hstate(:,t-1)==5)+...
            3*(probmatrix(:,t)>para.q(t,21)+para.q(t,22)                           & probmatrix(:,t)<=para.q(t,21)+para.q(t,22)+para.q(t,23)                          ).*(simul.hstate(:,t-1)==5)+...
            4*(probmatrix(:,t)>para.q(t,21)+para.q(t,22)+para.q(t,23)              & probmatrix(:,t)<=para.q(t,21)+para.q(t,22)+para.q(t,23)+para.q(t,24)             ).*(simul.hstate(:,t-1)==5)+...
            5*(probmatrix(:,t)>para.q(t,21)+para.q(t,22)+para.q(t,23)+para.q(t,24) & probmatrix(:,t)<=para.q(t,21)+para.q(t,22)+para.q(t,23)+para.q(t,24)+para.q(t,25)).*(simul.hstate(:,t-1)==5);  
    end;
end;

% When in elimiation period, pay permium based on Federal LTCI program.
for t=1:para.T;
    if para.defer==1;
        simul.sick_t(:,1)=simul.sick_t(:,1)+para.hcdaycount*(simul.hstate(:,t)==2)+(simul.hstate(:,t)==3)+(simul.hstate(:,t)==4);
        simul.benefit(:,t)= ...
            (simul.hstate(:,t)==2).*(simul.sick_t(:,1)>para.sick_T)*para.B(t,2)/para.rfactor(t,1)+ ...
            (simul.hstate(:,t)==3).*(simul.sick_t(:,1)>para.sick_T)*para.B(t,3)/para.rfactor(t,1)+ ...
            (simul.hstate(:,t)==4).*(simul.sick_t(:,1)>para.sick_T)*para.B(t,4)/para.rfactor(t,1);         
        simul.premium(:,t)= ...
            (simul.hstate(:,t)==1).*para.P(t,1)/para.rfactor(t,1)+ ...
            (simul.hstate(:,t)==2).*(simul.sick_t(:,1)<=para.sick_T)*para.P(t,1)/para.rfactor(t,1)+ ...
            (simul.hstate(:,t)==3).*(simul.sick_t(:,1)<=para.sick_T)*para.P(t,1)/para.rfactor(t,1)+ ...
            (simul.hstate(:,t)==4).*(simul.sick_t(:,1)<=para.sick_T)*para.P(t,1)/para.rfactor(t,1);
 
    elseif para.defer==2;
        
        simul.medcost_nominal(:,1)=simul.medcost_nominal(:,1) + ...
            (simul.hstate(:,t)==2).*para.M(t,2)*para.ifactor(t,1)+ ...
            (simul.hstate(:,t)==3).*para.M(t,3)*para.ifactor(t,1)+ ...
            (simul.hstate(:,t)==4).*para.M(t,4)*para.ifactor(t,1);            
        simul.benefit(:,t)= ...
            (simul.hstate(:,t)==2).*(simul.medcost_nominal(:,1)>para.sick_T)*para.B(t,2)/para.rfactor(t,1)+ ...
            (simul.hstate(:,t)==3).*(simul.medcost_nominal(:,1)>para.sick_T)*para.B(t,3)/para.rfactor(t,1)+ ...
            (simul.hstate(:,t)==4).*(simul.medcost_nominal(:,1)>para.sick_T)*para.B(t,4)/para.rfactor(t,1);  
        simul.premium(:,t)= ...
            (simul.hstate(:,t)==1).*para.P(t,1)/para.rfactor(t,1)+ ...
            (simul.hstate(:,t)==1).*(simul.medcost_nominal(:,1)<=para.sick_T)*para.P(t,1)/para.rfactor(t,1)+ ...
            (simul.hstate(:,t)==1).*(simul.medcost_nominal(:,1)<=para.sick_T)*para.P(t,1)/para.rfactor(t,1)+ ...
            (simul.hstate(:,t)==1).*(simul.medcost_nominal(:,1)<=para.sick_T)*para.P(t,1)/para.rfactor(t,1);
    elseif para.defer==3;
%         simul.medcost(:,t)=...
%             (simul.hstate(:,t)==2)*para.M(t,2)/para.rfactor(t,1)+...
%             (simul.hstate(:,t)==3)*para.M(t,3)/para.rfactor(t,1)+...
%             (simul.hstate(:,t)==4)*para.M(t,4)/para.rfactor(t,1);
    elseif para.defer>3;
    end;
end;
sben=sum(mean(simul.benefit(:,:)));
scost=sum(mean(simul.premium(:,:)));

% medcost=sum(mean(simul.medcost(:,:)));
% sben_all=sum(mean(simul.benefit_all(:,:)));
% scost_partner=sum(mean(simul.benefit_partner(:,:)));













