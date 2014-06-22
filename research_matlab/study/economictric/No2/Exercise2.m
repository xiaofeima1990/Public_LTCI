% for while ѭ�� 
%�Զ��庯��  
%ʱ�����е�Ӧ�� ȥ�� ƽ���Լ���  

%% �Զ��庯��

t=tsar(100,0.8,0);% ��������������������ļ���һ�¡���Ҫ���Դ��ĺ��������ظ���

% ����1������ʱû�뵽�õ����ӡ��� 

%% ѭ�� 

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

%����2�����
%���ϵ��Ϊp��X,Y�ı�׼��̬�ֲ���X*Y����0�ĸ���q�����ϵ��p�Ĺ�ϵ������ͼչʾ��X=p*Y+sqrt(1-p^2)*rand();���κ�����Ȥ������
disp('assignment 2 p=0.6')
y=randn(10000,1);
z=randn(10000,1);
x=p.*y+sqrt(1-p^2).*z;
flag=sum(x.*y>0);

flag/10000

%% ʱ������
% ��price��return
% ȥ�� detrend
% ȥ������ deseason
% ��λ������ adftest
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

% ����3��(�ֳ�)���OLS�Լ�MLE����AR(p)�Ĺ��ƣ�����AIC BIC���ס�
[b,bint,r,rint,stats]=regress(r(2:n),r(1:n-1));
r=load('rate.txt');
n=length(r);
p=2;
initial_ARp=[0.7731 -0.0051 0];
ARp=@(para)(sum((r(p+1:end)-para(2)*r(1:end-p)-para(3)*r(2:end-(p-1))-para(1)).^2));
options=optimset('maxfunevals',580,'maxiter',7000);
[para,fval]=fminsearch(ARp,initial_ARp,options);