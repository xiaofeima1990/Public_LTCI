%% fama french model 
% Maxium likelihood estimation
load fama_french

[T,N]=size(Z);
%LLF=@(param)(sum(  0.5/param(1)*((r(2:n)-(param(2)+1)*r(1:n-1)).^2)./(r(1:n-1).^2)...
%                    +  0.5*log(param(1))+  log(r(1:n-1))  +0.5*log(2*pi)  )); 

Ztest=ones(12,4);
Ztest(:,2:4)=Ztotal;
%%
% 
% <<fama_french MLE2.PNG>>
%%
% 
% <<fama_french MLE.PNG>>
% 
%% calculat the estimator 
%Z=alpha +Ztotal*beta+e
miu_Z=mean(Z);
de_Z=Z-ones(12,1)*miu_Z;

miu_Ztotal=mean(Ztotal);
de_Ztotal=Ztotal-ones(12,1)*miu_Ztotal;

% beta
beta=(de_Ztotal'*de_Z)'/(de_Ztotal'*de_Ztotal);

beta_star=(Ztotal'*Z)'/(Ztotal'*Ztotal);
% alpha
alpha=mean(Z)'-beta*mean(Ztotal)';

%sigma2
sigma2=(Z'-alpha*ones(1,12)-beta*Ztotal')*(Z'-alpha*ones(1,12)-beta*Ztotal')'./T;


%% single asset test 

stde=diag(sigma2);
stde=stde.^(0.5);
t_ratio=alpha./stde;
tlimit=tinv(0.95,T-4);

T_result=t_ratio>tlimit

%% joint asset test 
sigma0=(Z'-beta_star*Ztotal')*(Z'-beta_star*Ztotal')'./T;

J_LR= T*(log(det(sigma0))-log(det(sigma2)));

limit_chi = chi2inv(0.95,N);
chi_result=J_LR>limit_chi

%% chpter 6 
parameter=zeros(20,3);


