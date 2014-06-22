clear;
clc;

cd C:\Users\mayuqiang\Documents\MATLAB\周四matlab程序和数据

%% 数据的读取和存储

A=randn(10);% standard normal
filename = 'testdata.xlsx';
xlswrite(filename,A);
a=xlsread(filename); 
aa=importdata(filename,'Sheer1');
%aa.Sheet1

% 判断是否为空(isempty)和缺省(isnan)
load testdata.txt %手动导入数据。

[T,W]=find(isnan(testdata));
find(a>1.2,2,'first');
testdata(T,W)=100;

[X,Y]=find(testdata>=7);
testdata(X,Y)=200;

save a.mat A
load a.mat

whos
what


%% 矩阵的应用
b=eye(4);
b=eye(size(A));%单位阵

b=zeros(3,4);
b=ones(4,5);

b=1:3:16;
b=[1:3;2:4;5:7];
b=[1,2.5,4;2,5,7];

b=rand(3,4);%[0,1]均匀分布。
size(b);%维数

b_1=b(2:end,:);
b_1=b(2:end,2:3);
b_1=b(1:2:end,2:2:4);

b(2,:)=[];

B_1=rand(3);
B_2=rand(3);

B_3=B_1.*B_2;
B_3=B_1*B_2;

B_3=B_1.^3;
B_3=B_1^3;

B_1=[3,3,4;6,7,8;4,3,3];
det_B=det(B_1);%行列式
inv_B=inv(B_1);%逆矩阵
rank_B=rank(B_1);%秩

b_4=[1,2,3]';%转置
tic
b_5=inv(B_1)*b_4;
toc     %线性方程求解
tic
b_6=B_1\b_4;%线性方程求解
toc

b_7=mean(B_1);%均值
b_8=mean(mean(B_1));

b_9=sum(B_1);%和
b_10=sum(sum(B_1));

C=[1:9;2:2:18];
cov_C=cov(C);%协方差
varianc=var(C(1,:));%方差

%% 循环与判断

sum_1=0;
for i=1:120
    if (mod(i,4)~=0 || i==8) && i<100 % 判断 
        sum_1=sum_1+i;
    end
end
sum_1

% 求Normal(0,0.01)+Uniform(0.2,0.4)的0.1分位数。
n=100000;
%提前分配空间
tic
r=zeros(n,1);
for i=1:n
    r(i)=0.1*randn(1)+0.2*rand(1)+0.2;
end
r=sort(r);%排序
r_q=r(9*length(r)/10);
toc

tic
for i=1:n
    rr(i)=0.1*randn(1)+0.2*rand(1)+0.2;
end
rr=sort(rr);%排序
rr_q=rr(9*length(rr)/10);
toc

% rr=0.1*randn(n,1)+0.2*rand(n,1)+0.2;

flag=0;
for i=1:10000
    y_1=sum(rand(50,1)>0.5);
    y_2=sum(rand(51,1)>0.5);
    if y_2>y_1
        flag=flag+1;
    end
 end
flag/10000;


i=1;
while(i<10)
     if mod(i,3)==0
        sum_1=sum_1+i;
     end
    i=i+1;
end
sum_1;

%% 作图
x=-2*pi:pi/100:2*pi;
y=sin(x);
% subplot(2,1,1)
plot(x,y,'-r',x,y.^2,'-s')
% subplot(2,1,2)
legend('sin','sin^2');

figure
plot(x,-y,'--gs','LineWidth',2,'MarkerSize',4,'MarkerEdgeColor','b',...
    'MarkerFaceColor',[0.5,0.5,0.5]);%画的有点丑。

title('sin(x)');
xlabel('x');
ylabel('y');

xlim([-7,7]);
set(gca,'xtick',-7:1:7);

% set(gca)
% hist stem mesh surface

%% 个别函数介绍  fminsearch  portopt  find 

banana=@(x) 100*(x(2)-x(1)^2)^2+(1-x(1))^2;
[x,fval]=fminsearch(banana,[-1.2,1]);

% MLE method in GBM model

r=load('rate.txt');
n=length(r);
initial_GBM=[0.7731 -0.0051];
LLF_GBM=@(param)(sum(  0.5/param(1)*((r(2:n)-(param(2)+1)*r(1:n-1)).^2)./(r(1:n-1).^2)...
                    +  0.5*log(param(1))+  log(r(1:n-1))  +0.5*log(2*pi)  )); 
options=optimset('maxfunevals',580,'maxiter',7000);
[param,fval]=fminsearch(LLF_GBM,initial_GBM,options);
result_GBM=[param fval];

% risk-return efficient frontier 

ExpReturn = [0.1 0.2 0.15]; 
ExpCovariance = [0.005   -0.010    0.004 
                -0.010    0.040   -0.002 
                 0.004   -0.002    0.023];
NumPorts = 20;
portopt(ExpReturn, ExpCovariance, NumPorts)

% Constraints for a Portfolio of Asset Investments
ExpReturn = [0.1 0.2 0.15]; 

ExpCovariance = [0.005   -0.010    0.004 
                -0.010    0.040   -0.002 
                 0.004   -0.002    0.023];
NumAssets = 3;
PVal = 1; % Scale portfolio value to 1.
AssetMin = 0;
AssetMax = [0.5 0.9 0.8];  
ConSet = portcons('PortValue', PVal, NumAssets,'AssetLims',... 
AssetMin, AssetMax, NumAssets);
[PortRisk, PortReturn, PortWts] = portopt(ExpReturn,... 
ExpCovariance, [], [], ConSet);

portopt(ExpReturn,... 
ExpCovariance, [], [], ConSet);


% diff
syms x z
y=sin(x)^2+z^2;
d_f=[diff(y,x),diff(y,z)];
d_s=[diff(d_f,x);diff(d_f,z)];  % Jacob Matrix

%% 建立函数  函数名和文件名必须一致。

solveout(1,2,1);

%% 调试 F5 F9 F10 

