% ----------------------------------------------------------------------- %
% % This program replicates Gustman and Steinmeier (2008) C++ Model.    % %
% % It estimates preference parameters for a dynamic retirement model.  % %
% %                                                                     % %
% % Wei Sun                                                             % %
% % Renmin University of China                                          % %
% % Ver.0 6.28.2013                                                     % %
% ----------------------------------------------------------------------- %

% double check everything marked ???;
clear
clc
tic

% gv represents global variable;
% It is a structure variable enters and comes out of functions;
% Its values change in functions;
gv.nthreads = 1; % useless in Matlab, leave it here for now to adjust later;

% This program will do various jobs by calling different mode;
% Users could change value of runmode below to indicate which job to do.
% 0. test mode;
% 1. Iteration mode;
% 2. Esimtation mode;
mode = 0;

% User input variables;
gv.maxobs = 2500; % Max number of observations after treatment/to be evaluated using dynamic programs;
gv.nparms= 8; % Number of parameters to be estimated;
gv.nmoments = 43; % Number of moments to be matched;
gv.nacatlim = 40; % Grid size of asset;
gv.ntcatlim = 6; % Grid size of partial retirement preference;
gv.necatlim = 17; % Grid size of leisure preference epsilon; 
gv.nlcatlim = 10; % Grid size of DC pension lump-sum balance;
gv.npcatlim = 4; % Grid size of DB pension annual benefit;
gv.nrcatlim = 17; % Grid size of asset return;
gv.nscatlim = 4; % Grid size of Social Security annual benefit;
gv.nvcatlim = 3; % Grid size of marital status;
gv.ndcatlim = 2; % Grid size of whether delay claiming pension;
gv.t0 = 25;
gv.T = 99;

% Assign initial values for preference parameters which will be estimated;
gv.parm.alpha = -0.1600; % Consumption parameter, transform of CRRA coefficient;
% beta shows the weight for leisure; 
% h(t) = exp(beta*X(t) + epsilon(t));
% Individuals starts out with a value of epsilon drawn from a distribution with mean 0 and standard deviation sige;
% He keeps this value until retires career job;
% Then allow epsilon to change after retirement, but with a autocorrelation erho;
% epsilon(t) = erho * epsilon(t-1) + ???;
gv.parm.beta0 = -9.8000; % beta vector: constant;
gv.parm.beta1 = 0.0670; % beta vector: coefficient of (age-62);
gv.parm.beta2 = 5.7000; % beta vector: own health;
gv.parm.sige = 5.8700; % Standard deviation of leisure preference random effect, husband;
gv.parm.erho = 0.7100; % Autocorrelation of husband's epsilon after retirement;
% gamma shows the preference for leisure, similar with CRRA coefficient;
gv.parm.gamma0 = -3.6200; % gamma vector for partial retirement: constant;
gv.parm.gamma1 = 0.1600; % gamma vector for partial retirement: age;

% Lifetable comes from COH0015.95T, COH1655.95T and COH5690.95T, column l(x), showing how many of the original 100,000 individuals survive at the specific age;
% The format is as follows:
% survetable(birthyear, gender, age)
% birthyear position is 1 if born in 1900, 2 if born in 1901, and so on;
% gender position is 1 if male, 2 if female;
% age position is 1 indicating age 0 survival numbers, 2 indicating age 1 survival numbers, and so on;
load survtable
gv.survtable = survtable; 

gv.survtable=double(gv.survtable);
% Initialize gv.data;
% Husband's variables;
gv.data = struct([]);
for i = 1:gv.maxobs;
    gv.data(i,1).origobs = 0; % Order of observation in the original HRS dataset;
    gv.data(i,1).caseid = 0; % hhid in the original HRS dataset;
    gv.data(i,1).inputobs = 0; % Order of observation in the final input file;
    gv.data(i,1).birthyear = 0; % Husband's birthyear;
    gv.data(i,1).spbirthyear = 0; % Wife's birthyear;
    gv.data(i,1).gender = 0; % Gender;
    gv.data(i,1).healthage = 0; % Initial age of health problem;
    gv.data(i,1).penjobend = 0; % Age at potential last year of pension job;
    gv.data(i,1).age = zeros(6,1); % Age in each survey;
    gv.data(i,1).ret = zeros(6,1); % Retirement status in each survey;
    gv.data(i,1).retv = zeros(20,1); % Retirement status vector for ages 50-69; retv = 5 showing working full time; retv = 3 showing partial retired; retv = 1 showing completely retired;
    gv.data(i,1).spretage = 0; % Respondent age when spouse can collect SS benefits;

    % all amounts are in 1992$;
    gv.data(i,1).totalwealth = 0; % Wealth in 1992;
    gv.data(i,1).assetwealth = 0; % Land, business, financial & "other" wealth in 1992 (exclude housing);
    gv.data(i,1).ftwage = zeros(45,1); % Full-time wages at ages 25-69;
    gv.data(i,1).prwage = zeros(20,1); % Partial retirement wages at ages 50-69;
    gv.data(i,1).secwage = zeros(20,1); % Full-time wages in reveral jobs at ages 50-69;
    gv.data(i,1).spwage = zeros(45,1); % Wages of spouse at spouse ages 25-69;
    gv.data(i,1).pensben = zeros(21,1); % Annual pension benefit for retirement at 50-70;
    gv.data(i,1).penstart = zeros(21,1); % Starting age of pension for retirement at 50-70;
    gv.data(i,1).plumpsum = zeros(21,1); % Lump-sum pension benefit for retirement at 50-70;
    gv.data(i,1).eowamount = zeros(21,1); % Early out window lump sum amounts at 50-70;
    gv.data(i,1).sppensben = 0; % Annual pension benefit for spouse;
    gv.data(i,1).sppenstart = 0; % Starting spouse age of pension;
    gv.data(i,1).spplumpsum = 0; % Amount of spouse pension lump sum;
    gv.data(i,1).pia = zeros(21,1); % PIA at ages 50-69;
    gv.data(i,1).ncpens = zeros(21,1); % Noncovered pensions for retirement at 50-70;
    gv.data(i,1).sppia = zeros(21,1); % Spouse PIA at spouse ages 50-70;
    gv.data(i,1).spncpens = zeros(21,1); % Noncovered spouse pens for spouse retirement 50-70;
    gv.data(i,1).othincome = zeros(75,1); % Inheritances for ages 25-99;
    gv.data(i,1).inputobs = 0; % Order of observations in the original dataset before treatment;
    gv.data(i,1).inccat = 0; % Category of lifetime income (1 = low, 2 = med, 3 = high);
end;

% In test mode, this program will creat one hypothetical household to verify the validity of the program; In the other two modes, use function inpt to get HRS data;
if mode == 0;
    gv.data = setdata();
elseif mode == 1 || mode == 2;
    gv.data = inpt();
    gv.data = createData();
end;
gv.nobs = size(gv.data,1); % Number of valid observations after treatment;

% Observed moments from data; 
% A total of 43 moments, must equal to gv.nmoments defined above;
gv.obsmoment.age = zeros(13,1); % 13 moments of full retirement between 54 and 66;
gv.obsmoment.pr = zeros(5,1); % 5 moments of partial retirement at ages 55, 58, 60, 62 and 65;
gv.obsmoment.lowinc = zeros(5,1); % 5 moments of full retirement if in the lower third of lifetime income;
gv.obsmoment.highinc = zeros(5,1); % 5 moments of full retirement if in the upper third of lifetime income;
gv.obsmoment.health = zeros(5,1); % 5 moments of full retirement if in poor health;
gv.obsmoment.healthpr = zeros(5,1); % 5 moments of partial retirement if in poor health;
gv.obsmoment.reversal = zeros(5,1); % Frequency with which individuals return to full-time work in one survey, given they were fully/partially retired in the previous survey;
% Model simulated moments; 
% Again, a total of 43 moments, must equal to gv.nmoments defined above;
gv.simmoment.age = zeros(13,1); % Same as above;
gv.simmoment.pr = zeros(5,1); % Same as above;
gv.simmoment.lowinc = zeros(5,1); % Same as above;
gv.simmoment.highinc = zeros(5,1); % Same as above;
gv.simmoment.health = zeros(5,1); % Same as above;
gv.simmoment.healthpr = zeros(5,1); % Same as above;
gv.simmoment.reversal = zeros(5,1); % Same as above;

% Initialize ARGLIST structure variable;
gv.arglist.mode = mode; % program mode; 0: test; 1: iteration; 2:estimation;
gv.arglist.newalpha = 0; % New value of alpha;
gv.arglist.nmat = zeros(gv.maxobs,gv.nmoments); % moments of each observation in data;
gv.arglist.mvec = zeros(gv.nthreads,gv.nmoments); 
gv.arglist.wmat = zeros(gv.nthreads,gv.nmoments * (gv.nmoments + 1) / 2); % inverse weighting matrix;
gv.arglist.rvec = zeros(gv.maxobs,1); % 
gv.arglist.ret0mat = zeros(gv.nthreads,21); % Retirement rate from mainjob; ???
gv.arglist.ret1mat = zeros(gv.nthreads,21); % Cumulative percent of retiring from fulltime job to part time job or full retirement;
gv.arglist.ret2mat = zeros(gv.nthreads,21); % Cumultive percent from full time job to full retirement;
gv.arglist.returnft = zeros(gv.nthreads,21); % Percent newly return to full time work, previously retired;
gv.arglist.returnpt = zeros(gv.nthreads,21); % Percent newly return to part time work, previously retired;
gv.arglist.newpt = zeros(gv.nthreads,21); % Percent newly enter part time work;
gv.arglist.everreturnft = zeros(gv.nthreads,1); % Percent return to full time work after full or partial retirement;
gv.arglist.everreturnpt = zeros(gv.nthreads,1); % Percent return to part time work after full retirement;
gv.arglist.everreturn = zeros(gv.nthreads,1); % Percent return to full time work after full or partial retirement or returning to part time work after full retirement;

% Initialize calculation structure variable gv.calc;
for i = 1:gv.nobs;
    gv.calc(i,1).mode = 0; % Program mode;
    gv.calc(i,1).obs = 0; % Number of data observations;

    % Estimated parameters;
    gv.calc(i,1).sige = 0;
    gv.calc(i,1).erho = 0;
    gv.calc(i,1).beta0 = 0;
    gv.calc(i,1).beta1 = 0;
    gv.calc(i,1).beta2 = 0;
    gv.calc(i,1).gamma0 = 0;
    gv.calc(i,1).gamma1 = 0;
    gv.calc(i,1).alpha = 0;

    % The following quantities are calculated in calcprep;
    gv.calc(i,1).birthyear = 0; % Birth year;
    gv.calc(i,1).spbirthyear = 0; % Spouse birth year;

    gv.calc(i,1).firstage = 0; % age that individuals enter survey;
    gv.calc(i,1).lastage = 0; % age that individuals leave survey, or wave6 in 2002;

    gv.calc(i,1).earlypenage = 0; % First age with immediate pension;
    gv.calc(i,1).delayedpenage = 0; % Age at which delayed pensions can be collected;
    gv.calc(i,1).contribstartage = 0; % Age at which pension contributions start;
    gv.calc(i,1).penjobend = 0; % Age at potential last year of pension job;
    gv.calc(i,1).sserage = 0; % Social Security early entitlement age;
    gv.calc(i,1).nrage = 0; % Social Security normal retirement age;
    gv.calc(i,1).spnrage = 0; % social Security normal retirement age for spouse;

    gv.calc(i,1).delayedret = 0; % Social Security delayed retirement rate; Percent increase per year after NRA; 
    gv.calc(i,1).spdelayedret = 0; % Social Security delayed retirement rate for spouse;

    gv.calc(i,1).ntcats = 0; % number of partial retirement categories;
    gv.calc(i,1).nacats = 0; % number of asset categories;
    gv.calc(i,1).necats = 0; % number of epsilon categories;
    gv.calc(i,1).nlcats = 0; % number of pension lump sum categories;
    gv.calc(i,1).npcats = 0; % number of pension value categories;
    gv.calc(i,1).nrcats = 0; % number of return categories;
    gv.calc(i,1).nscats = 0; % number of social security value categories;

    gv.calc(i,1).tcats = zeros(gv.ntcatlim,20);    % utility of partial retirement categories, 50-69;
    gv.calc(i,1).acats = zeros(gv.nacatlim,1);     % asset categories;
    gv.calc(i,1).ecats = zeros(gv.necatlim,1);     % leisure preference categories;
    gv.calc(i,1).lcats = zeros(gv.nlcatlim,1);     % pension lump sum categories;
    gv.calc(i,1).pcats = zeros(gv.npcatlim,1);     % pension annual benefit categories;

    gv.calc(i,1).mainwage = zeros(45,1); % 25-69; Wage from career job;
    gv.calc(i,1).secwage = zeros(20,1); % 50-69; Wage of ???
    gv.calc(i,1).prwage = zeros(20,1); % 50-69; Wage of paritial retirement job; 
    gv.calc(i,1).eowamount = zeros(21,1); % 50-70, early out window amount;???

    gv.calc(i,1).initialpcat = zeros(21,1); % 50-70; ???
    gv.calc(i,1).initialscat = zeros(21,1); % 50-70;
    gv.calc(i,1).dccontrib = zeros(45,1); % DC pension annual contribution 25-69;

    gv.calc(i,1).ssbenf = zeros(gv.nscatlim,1); % Full SS own benefits at scat ages;
    gv.calc(i,1).ssbenm = zeros(45,2); % 25-69, surv states; main job;
    gv.calc(i,1).ssbens = zeros(20,2,gv.nscatlim); % 50-69, surv states; return to work;
    gv.calc(i,1).ssbenp = zeros(20,2,gv.nscatlim); % 50-69, surv states; partial retirement;
    gv.calc(i,1).ssbenr = zeros(50,3,gv.nscatlim); % 50-99, surv states; full retirement;
    gv.calc(i,1).othincome = zeros(75,3); % Inheritence 25-99 by survival states;

    gv.calc(i,1).benchanges = zeros(8,2,gv.nscatlim); % 62-69, surv states; return to work;
    gv.calc(i,1).benchangep = zeros(8,2,gv.nscatlim); % 62-69, surv states; partial retirement;

    gv.calc(i,1).srate = zeros(2,75); % resp/spouse, 25-99;
    gv.calc(i,1).transrate = zeros(3,75); % surv states, 25-99;
    gv.calc(i,1).etrans = zeros(gv.necatlim,gv.necatlim); % necats, necats;
    gv.calc(i,1).rprob = zeros(gv.nrcatlim,1); % nrcats;
    gv.calc(i,1).rtransa = zeros(gv.nacatlim,gv.nrcatlim); % nacats, nrcats;

    gv.calc(i,1).rtransl = zeros(45,gv.nlcatlim,gv.nrcatlim); % 25-69;

    gv.calc(i,1).utilr = zeros(gv.necatlim,20); % necats, 50-69;

    % The following matrices are used in rhocalc and associated routines only;
    gv.calc(i,1).income = zeros(3,75); % Income of 25-99 by survival states;
    gv.calc(i,1).cons = zeros(75,3,gv.nacatlim); % Optimal consumption of 25-99 by survival states and asset level;

    % The following matrices are used in calcModel only;
    % cons, mu & tu in following period;
    gv.calc(i,1).marguf = zeros(3,2,gv.npcatlim,gv.nscatlim,gv.nacatlim);  %%/* surv states, pendelay */ % Survival state, ???, Pension benefit, SS benefit, Wealth;
    gv.calc(i,1).totuf = zeros(3,2,gv.npcatlim,gv.nscatlim,gv.nacatlim);   %%/* surv states, pendelay */

    % Current cons, mu & tu;
    gv.calc(i,1).marguc = zeros(3,2,gv.npcatlim,gv.nscatlim,gv.nacatlim);  %%/* surv states, pendelay */
    gv.calc(i,1).totuc = zeros(3,2,gv.npcatlim,gv.nscatlim,gv.nacatlim);   %%/* surv states, pendelay */

    % mu & tu in following period, given current main job;
    gv.calc(i,1).margufw = zeros(2,gv.nlcatlim,gv.necatlim,gv.nacatlim); %%/* surv states */
    gv.calc(i,1).totufw = zeros(2,gv.nlcatlim,gv.necatlim,gv.nacatlim);  %/* surv states */

    % mu & tu in following period, given not currently in main job;
    gv.calc(i,1).margufr = zeros(3,2,gv.npcatlim,gv.nscatlim,gv.necatlim,gv.nacatlim);  %/* surv states, pendelay */
    gv.calc(i,1).totufr = zeros(3,2,gv.npcatlim,gv.nscatlim,gv.necatlim,gv.nacatlim);   %/* surv states, pendelay */

    % Adjusted mu & tu in following period, given current main job;
    gv.calc(i,1).cmatw = zeros(2,gv.nlcatlim,gv.necatlim,gv.nacatlim);   %/* surv states */
    gv.calc(i,1).tumatw = zeros(2,gv.nlcatlim,gv.necatlim,gv.nacatlim);  %/* surv states */

    % Adjusted mu & tu in following period, given not currently in main job;
    gv.calc(i,1).cmatr = zeros(3,2,gv.npcatlim,gv.nscatlim,gv.necatlim,gv.nacatlim); %/* surv states, pendelay */
    gv.calc(i,1).tumatr = zeros(3,2,gv.npcatlim,gv.nscatlim,gv.necatlim,gv.nacatlim);   %/* surv states, pendelay */

    % Current mu & tu if currently in main job;
    gv.calc(i,1).margucw = zeros(2,gv.nlcatlim,gv.necatlim,gv.nacatlim); %/* surv states */
    gv.calc(i,1).totucw = zeros(2,gv.nlcatlim,gv.necatlim,gv.nacatlim);  %/* surv states */

    % Current mu & tu if currently not in main job;
    gv.calc(i,1).margucr = zeros(3,3,2,gv.npcatlim,gv.nscatlim,gv.necatlim,gv.nacatlim);  %/* 0 = secjob 1 = pr 2 = ret, surv states, pendelay */
    gv.calc(i,1).totucr = zeros(3,3,2,gv.npcatlim,gv.nscatlim,gv.necatlim,gv.nacatlim);   %/* 0 = secjob 1 = pr 2 = ret, surv states, pendelay */

    % The following matrices are calculated in calcModel and passed to getMoments;
    gv.calc(i,1).totuw = zeros(45,gv.nlcatlim,gv.necatlim,gv.nacatlim); % 25-69;
    gv.calc(i,1).totud = zeros(20,3,2,gv.npcatlim,gv.nscatlim,gv.necatlim,gv.nacatlim); % 50-69, 0 = secjob 1 = pr 2 = ret, pendelay;

    gv.calc(i,1).savw = zeros(45,gv.nlcatlim,gv.necatlim,gv.nacatlim); % 25-69;
    gv.calc(i,1).savd = zeros(20,3,2,gv.npcatlim,gv.nscatlim,gv.necatlim,gv.nacatlim); % 50-69, 0 = secjob 1 = pr 2 = ret, pendelay;
    gv.calc(i,1).savr = zeros(30,2,gv.npcatlim,gv.nscatlim,gv.nacatlim); % 70-99, pendelay;

    gv.calc(i,1).mjchoice = zeros(20,gv.nlcatlim,gv.necatlim,gv.nacatlim); % 50-69;
    gv.calc(i,1).retchoice = zeros(20,2,gv.npcatlim,gv.nscatlim,gv.necatlim,gv.nacatlim); % 50-69, pendelay;

    % The following variables and vectors are used only in getMoments;
    gv.calc(i,1).ret0vec = zeros(21,1);
    gv.calc(i,1).ret1vec = zeros(21,1);
    gv.calc(i,1).ret2vec = zeros(21,1);
    gv.calc(i,1).returnft = zeros(21,1);
    gv.calc(i,1).returnpt = zeros(21,1);
    gv.calc(i,1).newpt = zeros(21,1);
    gv.calc(i,1).reversal = zeros(5,1);
    gv.calc(i,1).everreturnft = 0;
    gv.calc(i,1).everreturnpt = 0;
    gv.calc(i,1).everreturn = 0;
    gv.calc(i,1).inflrate = 0.040; % inflation rate;
    gv.calc(i,1).penadjrate = 0.38; % Fraction of inflation that is offset by pension increases;Fraction by which pensions are adjusted for inflation;
    gv.calc(i,1).realrateg  = 0.0474; % Geometric mean of real returns; (r1*r2*...*rn)^(1/n);
    gv.calc(i,1).realratea  = 0.0533; % Arithmatic mean of real returns; (r1+r2+...+rn)/n;
    gv.calc(i,1).realratesd = 0.1105; % standard deviation of real returns;
    % Actual return from 1926 to 2000;
    % Return data from file ibbotson.xls, ibbotson valuation edition yearbook 2001;
    gv.calc(i,1).realrate=[9.14;  22.65;  24.40;  -2.09;  -5.11; ...
        -11.90;   7.40;  26.62;  -2.23;  21.15;  16.17; -20.46;  18.58;   0.55;  -5.58; ...
        -15.45;   1.15;  10.04;   8.04;  16.60; -22.04;  -6.05;   0.56;  11.99;  10.61; ...
        6.64;   9.11;  -0.12;  27.52;  16.07;   1.29;  -6.65;  20.35;   5.72;   0.59; ...
        13.79;  -4.03;  11.22;   8.82;   6.13;  -6.05;  10.45;   3.17;  -7.59;   0.03; ...
        6.39;   8.08; -13.03; -21.60;  14.64;  10.18;  -8.06;  -2.54;   0.58;   8.75; ...
        -4.62;  13.45;  11.49;   4.36;  17.22;  12.01;   0.57;   7.31;  15.72;  -3.86; ...
        15.63;   2.89;   4.39;  -0.59;  20.15;  10.54;  18.09;  15.48;   9.57;  -4.31];        
end;

% The following variable is used in gaussdev subfunction; ???
gv.gaussdevreset = zeros(gv.nthreads,1);

% FRAND routine; ???
gv.randseed = zeros(48,1);
gv.randresetflag = ones(48,1) ;

% In test mode, this program will creat one hypothetical household to 
% verify the validity of the program;
% In the other two modes, use function inpt to get HRS data;
% data is a global variable and datav is the variable used in functions.
if gv.arglist.mode == 0;
    test(gv);
else
    if gv.arglist.mode == 1;
        q = iterate(gv.nobs);
    elseif gv.arglist.mode == 2;
        qmin(gv.nobs);
        Sim(gv.nobs);
    end;
end;





























