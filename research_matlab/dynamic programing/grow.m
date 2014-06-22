% r cooper 
% January 1997, modified 5/21/2001, 10/29/02, may 08, june 2011
% value function iteration for
% simple non-stochastic growth model

% here grow.out is a diary which records aspects of the program
clear ;% this clears variables from the workspace
%clf; % this clears the figures

%!del grow.out
%diary grow.out;  % this records the output to the screen


% Section 1: Functional Forms

% the model is the simple growth model  
% preferences: u(c)=c to the power of (1-sigma) over (1-sigma)
% beta is the discount factor
% delta is the rate of capital depreciation
% the production function is: k to the power of alpha

% Section 2

% Basic Parameters

% here you have a choice of using the built in choices or others

% this input command is used to input data from the keyboard
% you can change the baseline here or even get rid of this input by commenting it out using 
% a "%" at the start of the line.

%parms=input('do you want the baseline? no=0, y=1 ');
parms=1;
if parms==1;
     sigma=0;
     beta=.9;
     alpha=.75;
     delta=0.3;
else

% utility parameters
sigma=input('what is the value of u curvature? (1 is log)');
beta= input('what is the value of the discount rate?');

% technology

alpha=input('what is alpha (xikk in kpr)?(.3)');
delta=input('what is the rate of depreciation?');

end


% Section 3: Spaces

% here you need to specify the space that the capital stock lives in
% you must make an educated guess here so that the capital stock space
% includes the steady state



% input the size of the state space
% this will be the number of points in the grid

%N=input('what is the size of the state space for capital?(100)');

N=500;

% determine the steady state capital stock 
% so here Kstar is something we solved for analytically

Kstar=(((1/(alpha*beta))-((1-delta)/alpha)))^(1/(alpha-1));

% put in bounds here for the capital stock space
% you may want to adjust these bounds 

Klo=Kstar*.9;
%Klo=0.3*Kstar;
Khi=Kstar*1.1;
step=(Khi-Klo)/N;

% now construct the state space using the step starting with Klo and
% ending with Khi.  by construction, the state space includes Kstar

% now create the state space as a row vector
% look up this stuff in matlab so you know how to create vectors, matrices etc.
K=Klo:step:Khi;

% n is the true length of the state space

n=length(K);


% Section 4: VALUE FUNCTION ITERATION
% this section has two parts. first we obtain an initial guess of the value
% function from the single period problem. 


% Second we start the value function iteration routine.


% some initial matrices

% From the production function, Kalpha is the vector of output levels
Kalpha=K.^alpha;

% ytot is then total output available
ytot=Kalpha+(1-delta)*K;

% create a column of n ones 
colones=ones(n,1);

% create an nxn matrix here
s = colones*ytot;

% now take the transpose
S=s';

% each column of S is ytot
% we created all of this so we can work with matrices and avoid loops

% first guess of the value function

% here describe the level of utility associated with each element of the
% matrix S.  we use this below as our first guess for the dynamic programming
% problem.

% that is this is our initial guess on V

if sigma==1
V=log(S);
else
V=S.^(1-sigma)/(1-sigma);
end

% calculate investment here; I plays the role of the future capital stock
% this isn't great notation so be careful here....

rowones= colones';
% so I here is matrix where each column is K
I = K'*rowones;
% here J is a matrix where each row is K
J= colones*K;

% consumption: the flow of output plus undepreciated capital less investment
% you may want to work this out to see that it is correct using the matrices

C = (J.^alpha)-I +(1-delta)*J;

% current utility, current state as cols, future capital as rows
if sigma==1
U=log(C);
else
U=(C.^(1-sigma))/(1-sigma);
end
negc=find(C<0);
U(negc)=-1e50;

% create the first iterate of the payoffs to the dynamic problem
% using the U just constructed and V as described above

r = U + beta*V;

%keyboard
% this returns the max over the rows for each column so that we are 
% effectively choosing next periods capital (row) 
% for each value of today's capital (column)

V=max(r);


% Iterations: using this first guess at V iterate 

%T=input('maximal number of iterations (100)');
T=100;
% here we set our tolerance for convergence; 
%play with this to see how the results depend on tolerance

toler=.001;

% now keep doing the code from above as we loop and loop and..

% here T is the maximal number of iterations
tic
for j=1:T;
    
% use the last iteration to create a matrix of future values
% where the future capital stock is a row

% work carefully through these matrices!

% use the guess on V here to construct the matrix of payoffs
w=ones(n,1)*V;
q=w';


% consumption
%C = (J.^alpha)-I+(1-delta)*J; % you don't need this since this is set above; 
% it is here just to help you keep track 

% current utility, current state as cols, future capital as rows, given A
% if sigma==1
% U=log(C);
% else
% U=(C.^(1-sigma))/(1-sigma);
% end

% this is where q which came from w which came from V comes back in
r = U + beta*q;

v=max(r);


%  now calculate the difference between the last (V) and current (v)
% guesses of the value functions

diff=(V-v)./V;

% test for diff significant difference

if abs(diff) <= toler
   break
else
% so here if the diff exceeds the tolerance, then do a replacement
% and go back to the top of the loop
     V=v;
end
end
j
toc
% now that the program has converged.  You will have 
% the vector of values explicity: this is v.
% in addition, you want to know the policy vector


% use the max operator (check the Matlab book) to figure out which row was chosen for each
% level of the capital stock
[R,m]=max(r);

% now build a vector for future capital using the m-vector.
Kprime=[];

% now loop through the m-vector using the I matrix

for i=1:n
inv=I(m(i),i);
Kprime=[Kprime inv];
end

doplot=1;
if doplot==1
% here we plot the policy function against the 45 degree line
figure(1)
plot(K,Kprime,'r-');
hold on;
plot(K,K,'k:');% so now we have a nice 45 degree line
xlabel('current capital')
ylabel('capital')
legend('policy function','current capital',0)

% use this plot to look for steady state and investment patterns
figure(2)
plot(K,Kprime-K)
xlabel('current capital')
ylabel('net investment' )
% this command will plot the index of the policy function
%plot(m); % 
end
% simulation of transition dynamics
%transon=input('do you want to simulate the transition dynamics?y=1,n=0');
transon=0;
if transon==1
   P=100; % arbitrary length for transition path
   capind=ones(1,P)*8;
   captran=ones(1,P)*7;
   capind(1)=(3); % arbitrary starting point in terms of the index
   captran(1)= K(capind(1));
   for t=2:P
   capind(t)=(m(capind(t-1)));% so follow evolution in index space   
   captran(t)=K(capind(t)); % follow evoluation in capital space
	end
end
%olson=input('do you want to do ols of V(K)?y=1, n=0')
olson=0;
if olson==1
constant=ones(length(K),1);
data=[V' constant K'];
ols4(data,3)
end
disp('the program has now ended')
