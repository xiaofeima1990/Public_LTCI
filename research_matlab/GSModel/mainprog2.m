% /*---------------------------------------------------------------------------
% 			 MAINPROG
% 			 estimates parameters for model with variable time preference
%   ---------------------------------------------------------------------------*/
%去掉thread编辑
function mainprog2()
tic
clc
clear
%%%

AppName= 'GSModel';                                       %application name
AppTitle= 'Gustman-Steinmeier Retirement Model';          %caption for window
AboutTitle= 'GS Retirement Model';                        %name given in about box
AboutDate  = 'Sept 2012';                                 %date given in about box

global nthreads
nthreads =1;
global nparms
nparms=8;
global maxobs
maxobs =2500;
global ntcatlim
ntcatlim =6;
global nacatlim
nacatlim =40;
global necatlim
necatlim =17;
global nlcatlim
nlcatlim =10;
global npcatlim
npcatlim =4;
global nrcatlim
nrcatlim =17;
global nscatlim
nscatlim =4;

global nmoments
%  nmoments =sizeof(MOMENTSTRUCT) / sizeof(double);
nmoments =43;
%  typedef struct
PARM.sige=0;                   %%/* standard deviation of epsilon, husband */
PARM.erho=0;                   %%/* correlation of husband's epsilon after retirement */
PARM.beta0=0;                  %%/* beta vector: constant */
PARM.beta1=0;                  %%/* beta vector: age */
PARM.beta2=0;                  %%/* beta vector: own health */
PARM.gamma0=0;                 %%/* gamma vector for partial retirement: constant */
PARM.gamma1=0;                 %%/* gamma vector for partial retirement: age */
PARM.alpha=0;                  %%/* consumption parameter */

global MOBSSTRUCT
% typedef struct
MOBSSTRUCT.age=zeros(13,1);
MOBSSTRUCT.pr=zeros(5,1);
MOBSSTRUCT.lowinc=zeros(5,1);
MOBSSTRUCT.highinc=zeros(5,1);
MOBSSTRUCT.health=zeros(5,1);
MOBSSTRUCT.healthpr=zeros(5,1);
MOBSSTRUCT.reversal=zeros(5,1);

% typedef struct
global MOMENTSTRUCT
MOMENTSTRUCT.age=zeros(13,1);
MOMENTSTRUCT.pr=zeros(5,1);
MOMENTSTRUCT.lowinc=zeros(5,1);
MOMENTSTRUCT.highinc=zeros(5,1);
MOMENTSTRUCT.health=zeros(5,1);
MOMENTSTRUCT.healthpr=zeros(5,1);
MOMENTSTRUCT.reversal=zeros(5,1);

% typedef struct
CALCSTRUCT.mode=int32(0);
CALCSTRUCT.obs=int32(0);

CALCSTRUCT.sige=0;
CALCSTRUCT.erho=0;
CALCSTRUCT.beta0=0;
CALCSTRUCT.beta1=0;
CALCSTRUCT.beta2=0;
CALCSTRUCT.gamma0=0;
CALCSTRUCT.gamma1=0;
CALCSTRUCT.alpha=0;

%/* the following quantities are calculated in calcPrep */

CALCSTRUCT.birthyear=int32(0);
CALCSTRUCT.spbirthyear=int32(0);
%
CALCSTRUCT.firstage=int32(0);
CALCSTRUCT.lastage=int32(0);
%
CALCSTRUCT.earlypenage=int32(0);                  %%/* first age with immediate pension */
CALCSTRUCT.delayedpenage=int32(0);                %%/* age at which delayed pensions can be collected */
CALCSTRUCT.contribstartage=int32(0);              %%/* age at which pension contributions start */
CALCSTRUCT.penjobend=int32(0);                    %%/* age at potential last year of pension job */
CALCSTRUCT.sserage=int32(0);                      %%/* social security early entitlement age */
CALCSTRUCT.nrage=int32(0);                        %%/* social security normal retirement age */
CALCSTRUCT.spnrage=int32(0);                      %%/* social security normal retirement age for spouse */

CALCSTRUCT.realrate=zeros(75,1);                 %%/* actual returns 1926-2000 from ibbotson */
%
CALCSTRUCT.realrateg=0;                    %%/* geometric mean of real interest rate */
CALCSTRUCT.realratea=0;                    %%/* arithmatic mean of real interest rate */
CALCSTRUCT.realratesd=0;                   %%/* standard deviation of real interest rate */
CALCSTRUCT.inflrate=0;                     %%/* inflation rate */
CALCSTRUCT.penadjrate=0;                   %%/* fraction by which pensions are adjusted for inflation */
CALCSTRUCT.delayedret=0;                   %%/* social security delayed retirement rate */
CALCSTRUCT.spdelayedret=0;                 %%/* social security delayed retirement rate for spouse */

CALCSTRUCT.ntcats=int32(0);                       %%/* number of partial retirement categories */
CALCSTRUCT.nacats=int32(0);                       %%/* number of asset categories */
CALCSTRUCT.necats=int32(0);                       %%/* number of epsilon categories */
CALCSTRUCT.nlcats=int32(0);                       %%/* number of pension lump sum categories */
CALCSTRUCT.npcats=int32(0);                       %%/* number of pension value categories */
CALCSTRUCT.nrcats=int32(0);                       %%/* number of return categories */
CALCSTRUCT.nscats=int32(0);                       %%/* number of social security value categories */

CALCSTRUCT.tcats=zeros(ntcatlim,20);             %%/* utility of partial retirement categories, 50-69 */
CALCSTRUCT.acats=zeros(nacatlim,1);              %%/* asset categories */
CALCSTRUCT.ecats=zeros(necatlim,1);              %%/* leisure preference categories */
CALCSTRUCT.lcats=zeros(nlcatlim,1);              %%/* pension lump sum categories */
CALCSTRUCT.pcats=zeros(npcatlim,1);              %%/* pension annual benefit categories */

CALCSTRUCT.mainwage=zeros(45,1);                 %%/* 25-69 */
CALCSTRUCT.secwage=zeros(20,1);                  %%/* 50-69 */
CALCSTRUCT.prwage=zeros(20,1);                   %%/* 50-69 */
CALCSTRUCT.eowamount=zeros(21,1);                %%/* 50-70, early out window amount */

CALCSTRUCT.initialpcat=zeros(21,1);              %/* 50-70 */
CALCSTRUCT.initialscat=zeros(21,1);              %/* 50-70 */
CALCSTRUCT.dccontrib=zeros(45,1);                %/* 25-69 */

CALCSTRUCT.ssbenf=zeros(nscatlim);            %%/* full own benefits at scat ages */
CALCSTRUCT.ssbenm=zeros(45,2);               %%/* 25-69, surv states; main job */
CALCSTRUCT.ssbens=zeros(20,2,nscatlim);     %%/* 50-69, surv states; return to work */
CALCSTRUCT.ssbenp=zeros(20,2,nscatlim);     %%/* 50-69, surv states; partial retirement */
CALCSTRUCT.ssbenr=zeros(50,3,nscatlim);     %%/* 50-99, surv states; full retirement */
CALCSTRUCT.othincome=zeros(75,3);            %%/* 25-99, surv states */
%
CALCSTRUCT.benchanges=zeros(8,2,nscatlim);  %%/* 62-69, surv states; return to work */
CALCSTRUCT.benchangep=zeros(8,2,nscatlim);  %%/* 62-69, surv states; partial retirement */
%
CALCSTRUCT.srate=zeros(2,75);                 %%/* resp/spouse, 25-99 */
CALCSTRUCT.transrate=zeros(3,75);             %%/* surv states, 25-99 */
CALCSTRUCT.etrans=zeros(necatlim,necatlim);   %%/* necats, necats */
CALCSTRUCT.rprob=zeros(nrcatlim,1);              %%/* nrcats */
CALCSTRUCT.rtransa=zeros(nacatlim,nrcatlim);  %%/* nacats, nrcats */
%
CALCSTRUCT.rtransl=zeros(45,nlcatlim,nrcatlim);  %%/* 25-69 */
%
CALCSTRUCT.utilr=zeros(necatlim,20);          %%/* necats, 50-69 */
%
%   %%/* the following matrices are used in rhocalc and associated routines only */
%
CALCSTRUCT.income=zeros(3,75);                %%/* surv states, 25-99 */
CALCSTRUCT.cons=zeros(75,3,nacatlim);        %%/* 25-75, surv states */
%
%   %%/* the following matrices are used in calcModel only */
%
%          %%/* cons, mu & tu in following period */
CALCSTRUCT.marguf=zeros(3,2,npcatlim,nscatlim,nacatlim);  %%/* surv states, pendelay */
CALCSTRUCT.totuf=zeros(3,2,npcatlim,nscatlim,nacatlim);   %%/* surv states, pendelay */
%
%          %%/* current cons, mu & tu */
CALCSTRUCT.marguc=zeros(3,2,npcatlim,nscatlim,nacatlim);  %%/* surv states, pendelay */
CALCSTRUCT.totuc=zeros(3,2,npcatlim,nscatlim,nacatlim);   %%/* surv states, pendelay */
%
%          %%/* mu & tu in following period, given current main job */
CALCSTRUCT.margufw=zeros(2,nlcatlim,necatlim,nacatlim);    %%/* surv states */
CALCSTRUCT.totufw=zeros(2,nlcatlim,necatlim,nacatlim);     %/* surv states */
%
%          %/* mu & tu in following period, given not currently in main job */
CALCSTRUCT.margufr=zeros(3,2,npcatlim,nscatlim,necatlim,nacatlim);  %/* surv states, pendelay */
CALCSTRUCT.totufr=zeros(3,2,npcatlim,nscatlim,necatlim,nacatlim);   %/* surv states, pendelay */
%
%          %/* adjusted mu & tu in following period, given current main job */
CALCSTRUCT.cmatw=zeros(2,nlcatlim,necatlim,nacatlim);      %/* surv states */
CALCSTRUCT.tumatw=zeros(2,nlcatlim,necatlim,nacatlim);     %/* surv states */
%
%          %/* adjusted mu & tu in following period, given not currently in main job */
CALCSTRUCT.cmatr=zeros(3,2,npcatlim,nscatlim,necatlim,nacatlim);    %/* surv states, pendelay */
CALCSTRUCT.tumatr=zeros(3,2,npcatlim,nscatlim,necatlim,nacatlim);   %/* surv states, pendelay */
%
%          %/* current mu & tu if currently in main job */
CALCSTRUCT.margucw=zeros(2,nlcatlim,necatlim,nacatlim);    %/* surv states */
CALCSTRUCT.totucw=zeros(2,nlcatlim,necatlim,nacatlim);     %/* surv states */
%
%          %/* current mu & tu if currently not in main job */
CALCSTRUCT.margucr=zeros(3,3,2,npcatlim,nscatlim,necatlim,nacatlim);  %/* 0=secjob 1=pr 2=ret, surv states, pendelay */
CALCSTRUCT.totucr=zeros(3,3,2,npcatlim,nscatlim,necatlim,nacatlim);   %/* 0=secjob 1=pr 2=ret, surv states, pendelay */
%
%   %/* the following matrices are calculated in calcModel and passed to getMoments */
%
CALCSTRUCT.totuw=zeros(45,nlcatlim,necatlim,nacatlim);                   %/* 25-69 */
CALCSTRUCT.totud=zeros(20,3,2,npcatlim,nscatlim,necatlim,nacatlim);   %/* 50-69, 0=secjob 1=pr 2=ret, pendelay */
%
CALCSTRUCT.savw=zeros(45,nlcatlim,necatlim,nacatlim);                    %/* 25-69 */
CALCSTRUCT.savd=zeros(20,3,2,npcatlim,nscatlim,necatlim,nacatlim);    %/* 50-69, 0=secjob 1=pr 2=ret, pendelay */
CALCSTRUCT.savr=zeros(30,2,npcatlim,nscatlim,nacatlim);                 %/* 70-99, pendelay */
%
CALCSTRUCT.mjchoice(1:20,1:nlcatlim,1:necatlim,1:nacatlim)=int32(0);                %/* 50-69 */
CALCSTRUCT.retchoice(1:20,1:2,1:npcatlim,1:nscatlim,1:necatlim,1:nacatlim)=int32(0);  %/* 50-69, pendelay */
%
%   %/* the following variables and vectors are used only in getMoments */
%
CALCSTRUCT.everreturnft=0;
CALCSTRUCT.everreturnpt=0;
CALCSTRUCT.everreturn=0;
%
CALCSTRUCT.ret0vec=zeros(21,1);
CALCSTRUCT.ret1vec=zeros(21,1);
CALCSTRUCT.ret2vec=zeros(21,1);
CALCSTRUCT.returnft=zeros(21,1);
CALCSTRUCT.returnpt=zeros(21,1);
CALCSTRUCT.newpt=zeros(21,1);
CALCSTRUCT.reversal=zeros(5,1);
%   } CALCSTRUCT;

%
%typedef struct
DATA.origobs=int32(0);         %/* observation number in original data set            */
DATA.caseid=int32(0);          %/* caseid number in original data set                 */
DATA.birthyear=int32(0);       %/* year of birth                                      */
DATA.spbirthyear=int32(0);     %/* year of spouse's birth                             */
DATA.gender=int32(0);          %/* gender                                             */
DATA.age=zeros(6,1);          %/* age in each survey                                 */
DATA.ret=zeros(6,1);          %/* retirement status in each survey                   */
DATA.retv=zeros(20,1);        %/* retirement status vector for ages 50-69            */
DATA.spretage=int32(0);        %/* respondent age when spouse can collect ss benefits */
DATA.healthage=int32(0);       %/* initial age of health problem                      */
DATA.penjobend=int32(0);       %/* age at potential last year of pension job          */
%/* all amounts are in 1992$ */
DATA.totalwealth=int32(0);     %/* wealth in 1992                                     */
DATA.assetwealth=int32(0);     %/* land, business, financial & "other" wealth in 1992 */
DATA.ftwage=zeros(45,1);      %/* full-time wages at ages 25-69                      */
DATA.prwage=zeros(20,1);      %/* partial retirement wages at ages 50-69             */
DATA.secwage=zeros(20,1);     %/* full-time wages in reveral jobs at ages 50-69      */
DATA.spwage=zeros(45,1);      %/* wages of spouse at spouse ages 25-69               */
DATA.pensben=zeros(21,1);     %/* annual pension benefit for retirement at 50-70     */
DATA.penstart=zeros(21,1);    %/* starting age of pension for retirement at 50-70    */
DATA.plumpsum=zeros(21,1);    %/* lump-sum pension benefit for retirement at 50-70   */
DATA.eowamount=zeros(21,1);   %/* early out window lump sum amounts at 50-70         */
DATA.sppensben=int32(0);       %/* annual pension benefit for spouse                  */
DATA.sppenstart=int32(0);      %/* starting spouse age of pension                     */
DATA.spplumpsum=int32(0);      %/* amount of spouse pension lump sum;                 */
DATA.pia=zeros(21,1);         %/* pia at ages 50-69                                  */
DATA.ncpens=zeros(21,1);      %/* noncovered pensions for retirement at 50-70        */
DATA.sppia=zeros(21,1);       %/* spouse pia at spouse ages 50-70                    */
DATA.spncpens=zeros(21,1);    %/* noncovered spouse pens for spouse retirement 50-70 */
DATA.othincome=zeros(75,1);   %/* inheritances for ages 25-99                        */

DATA.inputobs=int32(0);        %/* observation number in the input file               */
DATA.inccat=int32(0);          %/* category of lifetime income (1=low, 2=med, 3=high) */
%   } DATA;

%
% typedef struct
ARGLIST.mode=int8(0);                    %/* 0: test; 1: iteration; 2: estimation; 3: simulation */
ARGLIST.newalpha=int32(0);                %/* new value of alpha */
ARGLIST.nmat(1:maxobs,1:nmoments)=int32(0);
ARGLIST.mvec=zeros(nthreads,nmoments);
ARGLIST.wmat=zeros(nthreads,nmoments * (nmoments + 1) / 2);
ARGLIST.rvec=zeros(maxobs,1);
ARGLIST.ret0mat=zeros(nthreads,21);
ARGLIST.ret1mat=zeros(nthreads,21);
ARGLIST.ret2mat=zeros(nthreads,21);
ARGLIST.returnft=zeros(nthreads,21);
ARGLIST.returnpt=zeros(nthreads,21);
ARGLIST.newpt=zeros(nthreads,21);
ARGLIST.everreturnft=zeros(nthreads,1);
ARGLIST.everreturnpt=zeros(nthreads,1);
ARGLIST.everreturn=zeros(nthreads,1);
%   } ARGLIST
%
%

%
global prntlevel
prntlevel = int32(0);           %/* flag for printing intermediate results */
%
global localthreadmin
localthreadmin=int32(0);
global localthreadmax
localthreadmax=int32(0);
global threadstate
threadstate(1:nthreads,1)=int32(0);
global threadobs
threadobs(1:nthreads,1)=int32(0);
%

% CALCSTRUCT *calcStructv; 指针声明用全局变量替代
global calcStructv
calcStructv=CALCSTRUCT;

global arglist
arglist=ARGLIST;

global datav
datav=DATA;
%DATA        datav[maxobs];


global parm
parm=PARM;

global gaussdevreset
gaussdevreset(1:nthreads,1)=int32(0);

%   FRAND routine
global randseed
randseed= zeros(48,1);
global randresetflag
randresetflag=ones(48,1) ;

global runmode
global threadno 


%%%
nobs=int32(0); threadno=int32(0); runmode=int32(0); count=int32(0);
startmonth=int32(0); startday=int32(0); starthour=int32(0); startmin=int32(0);

q=0;
surv=zeros(120,1);

persistent data

if isempty(data)
    data=DATA;
end


persistent threadindex

if isempty(threadindex)
    threadindex=[0,  1,  2,  3,  4,  5,  6,  7,  8,  9,...
        10, 11, 12, 13, 14, 15, 16, 17, 18, 19,...
        20, 21, 22, 23, 24, 25, 26, 27, 28, 29,...
        30, 31, 32, 33, 34, 35, 36, 37, 38, 39,...
        40, 41, 42, 43, 44, 45, 46, 47 ];
end

%
%    localthreadmin = -1;
%    localthreadmax = -1;
%
localthreadmin = 0;
localthreadmax = 0;

%    while (localthreadmin < 0 || localthreadmax < localthreadmin || nthreads <= localthreadmax)
%        disp('Input range of threads');
%          localthreadmin=input('Input range of threads firest one');
%          localthreadmax=input('Input range of threads second one');
%    end

runmode = 1;     %/* 0: test; 1: iterate; 2: estimate; 3: simulate */
if (runmode > 0 && localthreadmin == 0)
    %            inpt(nobs);
    nobs=createData;
    data=datav;
end

%   /* allocate buffer for calcStruct */
%
%   calcStructbuffer = malloc((localthreadmax - localthreadmin + 1) * sizeof(CALCSTRUCT));
%
%   if (calcStructbuffer == NULL)
%   error('calcStruct buffer allocation failed');
%
%   calcStructv = (CALCSTRUCT *) calcStructbuffer;
%


surv=getSurvivalRates(1950, 1,surv);




parm.sige   =   5.8700;  %/* sige / beta[1]: std dev of leisure preference random effect */
parm.erho   =   0.7100;  %/* erho: autocorrelation parameter for epsilon */
parm.beta0  =  -9.8000;  %/* beta[0]: constant term in utility fn */
parm.beta1  =   0.0670;  %/* beta[1]: coefficient of age - 62 */
parm.beta2  =   5.7000;  %/* beta[2] / beta[1]: coefficient of health variable */
parm.gamma0 =  -3.6200;  %/* gamma[0]: constant term in pr density function */
parm.gamma1 =   0.1600;  %/* gamma[1]: coefficient of age in pr density function */
parm.alpha  =  -0.1600;  %/* alpha: exponent of consumption */

%     if (localthreadmin == 0)
%     if(threadno <= localthreadmax)
%      threadstate(1)=1;
%
%      indivmodel(0);
%      end
%    end
%     threadstate(1)=0;


if (runmode == 0)
    %   {
    datav=DATA;
    test();
    %     }
else if (runmode == 1)
        q = iterate(nobs);
    else
        %   {
        if (runmode == 2)
            qmin(nobs);
        end
        Sim(nobs);
        %     }
    end
end

% for threadno = 0:1:nthreads
%     threadstate(threadno+1) = -1;
% end