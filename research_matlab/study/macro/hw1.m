%% first question
clear
%true value of y*
%syms y beta
 beta=0.9;
 apple=@(y)-(log(2-y)+beta*log(y));
 [y,fval]=fminsearch(apple,0,optimset('TolX',1e-8));;
disp('fminsearch result');
[y,fval]


%solve method
syms y beta
banana=log(2-y)+beta*log(y);
fd=diff(banana,sym('y'));
result2=solve(fd,y)
beta=0.9;

%max
yy=0:0.01:1;
b=.9;
ff=(log(2-yy)+b*log(yy));
[result3,flag]=max(ff')
yy(flag)

%% question 2 
n=41;
grid=0.01;
% for i=1:n
%     k(i)=0.8+(i-1)*0.01;
% end
k=0.8+ones(n,1).*grid.*((1:n)'-1);

kk=zeros(n,1);
%k_t=cumsum(ones(n,1)*0.01);
for i=1:n
    k_t(i)=0.05+(i-1)*0.01;
end
k_t=k_t';
V=zeros(n,1);
eps=10^-5;
dif=1;
a=0.25;b=0.9;r=-2;
A=(1-b)/(a*b);

tic
while (dif>eps)
    for i=1:n
        c=A.*k(i).^a - k_t;
        c(c<0)=-9999999;
        VV=(c).^(1+r) ./(1+r) + b.*V;
        [Vmax(i),kk(i)]=max(VV);
    end
    
    dif=max(abs(Vmax'-V));
    V=Vmax';
end
    
toc
V
plot()


