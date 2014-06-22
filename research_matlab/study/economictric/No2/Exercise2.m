% for while 循环 
%自定义函数  
%时间序列的应用 去势 平稳性检验  

%% 自定义函数

t=tsar(100,0.8,0);% 输出多个结果。函数名和文件名一致。不要和自带的函数命名重复。

% 任务1：（暂时没想到好的例子。） 

%% 循环 

coef=zeros(1000,1);
for i=1:1000
    a=tsar(100,1,0);
    coef(i)=a(1:end-1)'*a(2:end)/(a(1:end-1)'*a(1:end-1));
end
coef=sort(coef);
[coef(50) coef(950)]

flag=0;
for i=1:10000
    y_1=sum(rand(50,1)>0.5);
    y_2=sum(rand(51,1)>0.5);
    if y_2>y_1
        flag=flag+1;
    end
 end
flag/10000;


sum_1=0;
i=1;
while sum_1<1000
    sum_1=i+sum_1;
    i=i+1;
end
i

%任务2：完成
%相关系数为p的X,Y的标准正态分布，X*Y大于0的概率q和相关系数p的关系，并作图展示。X=p*Y+sqrt(1-p^2)*rand();（课后有兴趣做）。
disp('assignment 2 p=0.6')
y=randn(10000,1);
z=randn(10000,1);
x=p.*y+sqrt(1-p^2).*z;
flag=sum(x.*y>0);

flag/10000

%% 时间序列
% 由price求return
% 去势 detrend
% 去季节性 deseason
% 单位根检验 adftest
% autocorr parcorr
price=1000:1500;
ret=log(price(2:end)./price(1:end-1));
ret2=price(2:end)./price(1:end-1)-1;

r=load('rate.txt');
r_mean=mean(r);
r_var=var(r);
r_skewness=skewness(r);
r_kurtosis=kurtosis(r);

n=length(r);
initial_GBM=[0.7731 -0.0051];
LLF_GBM=@(param)(sum(  0.5/param(1)*((r(2:n)-(param(2)+1)*r(1:n-1)).^2)./(r(1:n-1).^2)...
                    +  0.5*log(param(1))+  log(r(1:n-1))  +0.5*log(2*pi)  )); 
options=optimset('maxfunevals',580,'maxiter',7000);
[param,fval]=fminsearch(LLF_GBM,initial_GBM,options);
result_GBM=[param fval];

% 任务3：(现场)完成OLS以及MLE法的AR(p)的估计，并用AIC BIC定阶。
[b,bint,r,rint,stats]=regress(r(2:n),r(1:n-1));
r=load('rate.txt');
n=length(r);
p=2;
initial_ARp=[0.7731 -0.0051 0];
ARp=@(para)(sum((r(p+1:end)-para(2)*r(1:end-p)-para(3)*r(2:end-(p-1))-para(1)).^2));
options=optimset('maxfunevals',580,'maxiter',7000);
[para,fval]=fminsearch(ARp,initial_ARp,options);