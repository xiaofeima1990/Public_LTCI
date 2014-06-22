% r. cooper
% may 2006, may 2008, feb 2010 nov 2011

% simple asset pricing
% no optimization, just recursive state dependent pricing
% then there is a section on estimation of parameters

clear; % clears out any mess

% utility function is give by
% q(d) = u(d) + beta E q(d')

% Basic Parameters

% u(c)=c.^(1-sigma)/(1-sigma); % here c will be dividends
sigma=0; % for this code

beta=0.95; %impatience controlled here
betatruth=beta; % for estimation part below

% taste shocks
d=[.95 1.15]'; % space for dividends
neps=length(d); % length of dividend shocks used in loop below
ud= d.^(1-sigma)/(1-sigma);

% set up the transition matrix
pill=0.95;pihh=0.9;
% transition matrix where today's state is the row; order low high as in d
pi=[pill 1-pill;1-pihh pihh] ; 
%pierg=pi^100;
% first guess of the value function 
% initial guess on q is here: guess you will eat the dividend forever
Q=ud/(1-beta); 
%Q=[0;0]
Qguess=Q;

%keyboard; % to peek under the hood
% ===============================
% Iterations: using this first guess at V iterate 
% ===============================
%T=input('maximal number of iterations')
Tvfi=200;
% here we set our tolerance for convergence on % difference between V and v
% (defined below)
toler=.00001;

% now keep doing the code from above as we loop and loop and..

% here T is the number of iterations
val=[]; % empty matrix use this later just to see results
for j=1:Tvfi;
val=[val Q]; %fill it in as we go ...
q=ud+beta*pi*Q; % 

diff=abs((Q-q)./Q); % careful here in log case not to divide by zero
% test for diff significant difference

if diff <= toler
   break
else
% so here if the diff exceeds the tolerance, then do a replacement
% and go back to the top of the loop
     Q=q;
end
end
disp('number of iterations')
j

disp(' initial guess and final value')
[Qguess q]

disp(' value and utility')
[q ud]

% exercises: (i) play with Qguess, pi (ii) ergodic distribution of d (iii)
% change toler, (iv) change T (v0 plot the convergence

%  plot(val(1,:),'b'); hold on
% plot(val(2,:),'r')


% now get the shocks 


assetest=1; % to see how to estimate the model
if assetest==1

T=1000;

stuff=[T pihh pill];

% this is just to produce draws from a markov process
shckreal=func_simmarkov(stuff); % look at this code

% now use it to generate q(d) using the params above
%keyboard
qreal=q(shckreal); % computed from truth

% compute a moment from "true data"
disp('mean of the process')
mureal=mean(qreal)
truth=mureal; % this is the moment to use in the estimation below


% now we can estimate beta 
estloop=1;

if estloop==1

Beta=[.9:.01:0.99];
lenbet=length(Beta);
results=88*ones(lenbet,3); % initiaze results
for k=1:lenbet
beta=Beta(k);

Q=ud/(1-beta); 


%keyboard; % to peek under the hood
% ===============================
% Iterations: using this first guess at V iterate 
% ===============================
%T=input('maximal number of iterations')
% here we set our tolerance for convergence on % difference between V and v
% (defined below)
toler=.00001;

% now keep doing the code from above as we loop and loop and..

% here T is the number of iterations
for j=1:Tvfi;
q=ud+beta*pi*Q; % 
diff=abs((Q-q)./Q); % careful here in log case not to divide by zero
% test for diff significant difference
if diff <= toler
   break
else
% so here if the diff exceeds the tolerance, then do a replacement
% and go back to the top of the loop
     Q=q;
end
end; % loop over j ends

% now we have converged, compute the moments
qreal=q(shckreal);

% compute a moment
mureal=mean(qreal);
fit=(mureal-truth)^2;
results(k,:)=[beta mureal fit];
end; %loop over beta ends
disp('grid search results')
disp('     beta     mean      fit')
disp(results)

plot( results(1:7,1),results(1:7,3))
end
end; % est loop ends
