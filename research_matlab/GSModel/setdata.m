% ----------------------------------------------------------------------- %
% % setdatav function                                                    % %
% % prepares datav structure for a hypothetical individual               % %
% ----------------------------------------------------------------------- %

function datav = setdata()

% Husband's variables;    
datav.origobs = 1; % Order of observation in the original HRS dataset;
datav.caseid = 10001; % hhid in the original HRS dataset;
datav.inputobs = 1; % Order of observation in the final input file;
datav.birthyear = 1931; % Year of birth;
datav.spbirthyear = 1933; % Year of spouse's birth;
datav.gender = 1; % Gender;
datav.healthage = 99; % Initial age of health problem;
datav.penjobend = 99; % Age at potential last year in pension job;

datav.age = [58; 60; 62; 64; 66; 68]; % Age at the surveyey dates;
datav.ret = [5; 5; 1; 1; 1; 1]; % Retirement status at survey dates;
datav.retv = [0; 0; 0; 0; 0; 0; 0; 5; 5; 5; 5; 0; 1; 1; 1; 1; 1; 1; 1; 0]; % Retirement status at ages 50-70;
datav.spretage = 0; % Respondent age when spouse can collect ss benefits;

datav.totalwealth = 10000; % Wealth in 1992;
datav.assetwealth = 10000; % Land, business, financial & "other" wealth in 1992 (excludes housing);
datav.ftwage = 30000*ones(45,1); % Full-time wages at ages 25-69
datav.prwage = 6000*ones(20,1); % Partial retirement wages at ages 50-69  
datav.secwage = 18000*ones(20,1); % Full-time wages in reversal jobs at ages 50-69
datav.spwage = [10000*ones(37,1); zeros(8,1)]; % Wages of spouse at spouse ages 25-69 full-time wages at ages 25-69

datav.pensben = (4000+200*((50:70)'-50))./exp([0.0248*(60-60)+0.05*(60-(50:59)'); zeros(11,1)]); % Annual pension benefit for retirement at 50-70;
datav.penstart = [60*ones(10,1); (60:70)']; % Starting age of pension for retirement at 50-70; 
datav.plumpsum = 500*((50:70)'-40); % Lump-sum pension benefit for retirement at 50-70;
datav.eowamount = zeros(21,1); % Early out window lump sum amounts at 50-70;

datav.sppensben = 700; % Annual pension benefit, wife;
datav.sppenstart = 62; % Starting age of pension, wife;
datav.spplumpsum = 0; % Lump-sum pension benefit, wife;

datav.pia = 10000+100*((50:70)'-65); % Husband's PIA at 50-69;
datav.ncpens = zeros(21,1); % Noncovered pensions for retirement at 50-70;
datav.sppia = 4000+25*((50:70)'-65); % Wife's PIA at 50-69;
datav.spncpens = zeros(21,1); % Noncovered pensions for retirement at 50-70, wife;
datav.othincome = zeros(75,1); % Inheritances for ages 25-99;
datav.inputobs = 0; % Order of observations in the original dataset before treatment;
datav.inccat = 0; % Category of lifetime income (1 = low, 2 = med, 3 = high);






 
 
 
 
 
 
 
 
 