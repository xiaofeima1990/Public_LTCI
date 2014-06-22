% simulating markov process
% 2 state process

% take pi
pill=0.5;pihh=0.9;
sc=[pill;pihh];
% transition matrix where today's state is the row; order low high as in d
pi=[pill 1-pill;1-pihh pihh] ; 

% length of simulated data
T=1000;
%draw shocks from uniform [0,1];

epsi=rand(T,1);
% initialize vector
shckreal=ones(T,1);
% initial condition
shckreal(1)=1;
for j=2:T
    if shckreal(j-1)==1
    if epsi(j)<=sc(shckreal(j-1))
    shckreal(j)=shckreal(j-1);
    else
        shckreal(j)=2;
    end
    end
    % now other case
    if shckreal(j-1)==2
    if epsi(j)<=sc(shckreal(j-1))
    shckreal(j)=shckreal(j-1);
    else
        shckreal(j)=1;
    end
    end
end

% now do some counts of the results
shckrealcur=shckreal(2:end);
shckreallag=shckreal(1:end-1);
tranlh=find(shckrealcur==2 & shckreallag==1);
lowfreq=find(shckreallag==1);
disp('frequency of switches from low to high')
length(tranlh)/length(lowfreq)
disp('sc of low state')
sc(1)

tranhl=find(shckrealcur==1 & shckreallag==2);
highfreq=find(shckreallag==2);

disp('frequency of switches from high to low')
length(tranhl)/length(highfreq)
disp('sc of high state')
sc(2)
% why does the fraction of transitions keep changing?
% how does T influence the results?
