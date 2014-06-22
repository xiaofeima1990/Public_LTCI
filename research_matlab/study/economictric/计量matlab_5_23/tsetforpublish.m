warning off all
%%
% *bold test for me*

%%
% $x^2+e^{\pi i}$
%%
% |gogogog|
%%
simModel = arima('AR',{0.5,-0.3,0.4,-0.2},'MA',0.2,'Constant',0,'Variance',0.1);                
[y,a,v]=simulate(simModel,1000);


Order=10;               % number of alternative models
AIC=zeros(Order,1);

for i=1:Order
    AR=garchset('R',i,'Display','off');                   
    [~,~,LLF,~,~,~] = garchfit(AR,y);   
    AIC(i) = aicbic(LLF,i+2);             % caution!  the variance and the constant are also parameters
end
figure 
plot(AIC);
[~,lag]=min(AIC);                         
AR=garchset('R',lag,'Display','off');
[Coeff,Errors,LLF,Innovations,Sigmas,Summary] = garchfit(AR,y);  % estimate the coefficient and corresponding errors. 
garchdisp(Coeff,Errors);
%% test section
% 
%   for x = 1:10
%       disp(x)
%       x=1
%   end
% 
% this is a test
