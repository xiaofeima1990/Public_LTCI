%% chapter 9 SDE 
%%Euler Scheme for  the Merton model jump-diffusion process 
%? = 0.04%, ¦Ò = 1%, ?J = ?0.5%, ¦ÒJ = 1%, ¦Ë = 0.25.

h=1/(6.5*60);
T=1;
n=T/h;
miu=0.04/100;
sigma=1/100;
miuJ=-0.5/100;
sigmaJ=1/100;
lamda=0.25;
Spath=zeros(n,1);

% step 1
St_1=100;
lgSt_1=log(St_1);

% step 2
Z=randn(1,n);
for i=1:n
    N=poissrnd(lamda*h);
    if N>=1
        J=normrnd(miuJ,sigmaJ,[1,N]);
        M=sum(J);
    lgSt=lgSt_1+miu*h+sigma*Z(i)*h^0.5+M;
    end
    if N==0
        M=0;
        lgSt=lgSt_1+miu*h+sigma*Z(i)*h^0.5+M;
    end
    lgSt_1=lgSt;
    Spath(i)=lgSt;
    
end
plot(exp(Spath))

%% ito lemma 
h=1/(6.5*60);
T=1;
n=T/h;
miu=0.04/100;
sigma=1/100;
miuJ=-0.5/100;
sigmaJ=1/100;
lamda=0.25;
Spath=zeros(n,1);

% step 1
St_1=100;
lgSt_1=log(St_1);

% step 2
Z=randn(1,n);
for i=1:n
    N=poissrnd(lamda*h);
    if N>=1
        J=normrnd(miuJ,sigmaJ,[1,N]);
        M=sum(J);
    lgSt=lgSt_1+(miu-lamda*miuJ-0.5*sigma^2)*h+sigma*Z(i)*h^0.5+M;
    end
    if N==0
        M=0;
        lgSt=lgSt_1+miu*h+sigma*Z(i)*h^0.5+M;
    end
    lgSt_1=lgSt;
    Spath(i)=lgSt;
    
end
plot(exp(Spath))
