%% GBM assignment
% syms beta sigma2
r=load('rate.txt');

n=length(r);
initial_GBM=[0.7731 -0.0051];
% likelyhood=0.5 .*((r(2:end)-r(1:end-1)-beta.*r(1:end-1)).^2 ./(sigma2.*r(1:end-1).^2)) ...
%             +0.5*log(sigma2)+log(r(1:end-1))+0.5*log(2*pi);
% (sum(  0.5/param(1)*((r(2:n)-(param(2)+1)*r(1:n-1)).^2)./(r(1:n-1).^2)...
%                     +  0.5*log(param(1))+  log(r(1:n-1))  +0.5*log(2*pi)        


fun=@(param)(sum(0.5/(param(1)) *((r(2:n)-r(1:n-1)-param(2)*r(1:n-1)).^2 ./(r(1:n-1).^2)) ...
            +0.5*log(param(2))+log(r(1:n-1))+0.5*log(2*pi)));        
% fun=@(beta, sigma2)(sum(likelyhood));
options=optimset('maxfunevals',580,'maxiter',7000);

[param,fval]=fminsearch(fun,initial_GBM,options);
