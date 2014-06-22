%% homework 3 
% GBM model:
r=load('rate.txt');
r_mean=mean(r);
r_var=var(r);
r_skewness=skewness(r);
r_kurtosis=kurtosis(r);

%单位根检验 ：ADF test
[h,pValue,stat,cValue,reg]= adftest(r,'alpha',[0.01,0.05,0.1]);

%自相关函数 ACF
[ACF,lags,bounds] = autocorr(r,15);
autocorr(r,15)

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


%%
% Vasicek
r_estimate_VAS=zeros(413,1);
n=100;
for n=100:512
initial_VAS=[0, 0, 0];
LLF_VAS=@(param2)(sum(0.5/param2(1)*((r(2:n)-(param2(2)+1)*r(1:n-1)-param2(3)).^2))...
                    +  0.5*log(param2(1)) +0.5*log(2*pi)  ); 
options=optimset('maxfunevals',580,'maxiter',7000);
[param2,fval]=fminsearch(LLF_VAS,initial_VAS,options);
result_VAS=[param2 fval];

e=randn;
r_estimate_VAS(n+1-100)=param2(3)+(1+param2(2))*r(n) ;
%+ param(1)^(0.5)*e;
end
%计算预测偏差的MSE
MSE_VAS=mean((r_estimate_VAS-r(101:end-1)).^2)

% plot the picture
figure

n=413;
x=1:n;
plot(x,r(101:513),'b-')
hold on 
plot(x,r_estimate_GBM,'r.')

hold on
plot(x,r_estimate_VAS,'g--')
legend('rate','GBM','VAS')

