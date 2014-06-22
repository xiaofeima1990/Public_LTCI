% r cooper 


% revised dec. 2005, march 2006, may 08 nov 2011
% dec. 2004

% this is a discrete stochastic cake eating problem.
% the agent chooses to either eat the cake or not.
% for simplicity the cake does not change size.
% there are taste shocks which follow a markov process



clear all


% Basic Parameters

% preferences

% u(c)=c.^(1-sigma)/(1-sigma);
sigma=1; % 1 turns on the log utility case
quadd=0; % turns on quad spec of utility
beta=0.97; %impatience controlled here

% cake space
W=100; % cake size but policy function should be independent of W
n=length(W); % will be one in this model

% taste shocks
epsi=[0.75 1.0 1.25]; % space for taste shock
pi=[.90 .05 0.05;0.05 0.9 0.05;.05 0.05 .9] ; % transition matrix where today's state is the row
%pi=[.95 .05;.1 .9] ; % transition matrix where today's state is the row
neps=length(epsi); % length of taste shocks used in loop below


% value function iteration
% V(W,eps)=max(VE(W,eps),VW(W,eps))
% value = max( value of eating, value of waiting)

% VE comes from eating the cake and so is static
VE=ones(neps,n); % create a matrix here and then fill it in below
for i=1:neps
   
    if sigma==1
        VE(i,:)=epsi(i)*log(W); % VE(i,:) refers to all cols in row i, this would work even if W was a vector
    elseif quadd==1
       VE(i,:)=epsi(i)*W+.5*W.^2;

    else
    VE(i,:)=epsi(i)*W.^(1-sigma)/(1-sigma);
    end
end

% first guess of the value function 
% initial guess on VW is here: guess you will eat the cake next period
VW=beta*pi*VE; 
%VW=zeros(2,1);
V=max(VE,VW); % take a max to get an initial V  based on this guess of VW

%V=VW; % try this instead just to play with the initial guess to see it doesn't matter
%keyboard; % to peek under the hood
% ===============================
% Iterations: using this first guess at V iterate 
% ===============================
%T=input('maximal number of iterations')
T=200;
% here we set our tolerance for convergence on % difference between V and v
% (defined below)
toler=.00001;

% now keep doing the code from above as we loop and loop and..

% here T is the number of iterations

for j=1:T;
VW=beta*pi*V; % 
v=max(VE,VW); % make discrete choice here

diff=abs((V-v)./V); % careful here in log case not to divide by zero
% test for diff significant difference

if diff <= toler
   break
else
% so here if the diff exceeds the tolerance, then do a replacement
% and go back to the top of the loop
     V=v; % update your guess..
end
end
disp('number of iterations')
j

Z=(VE>VW); % so Z==1 iff VE>VW
disp('   shock         Z       v        VE        VW')
res=[epsi' Z v VE VW];
disp(res)









