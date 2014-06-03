function getMoments( threadno,tcat)
%   int    threadno,            %/* thread number */
%   int    tcat)                %/* utility of partial retirement category */
%
% {

global ntcatlim
global nacatlim
global necatlim
global nlcatlim
global npcatlim
global nrcatlim
global nscatlim

global MOMENTSTRUCT
global calcStructv
global localthreadmin
global datav
global arglist
global nmoments

% int
k=int32(0); l=int32(0); l1=int32(0); l2=int32(0);
obs=int32(0); mode=int32(0); survey=int32(0);
simcount=int32(0); nsims=int32(0); llim=int32(0); ulim=int32(0);
firstage=int32(0); lastage=int32(0);
sserage=int32(0); nrage=int32(0); nragew=int32(0);
year=int32(0); birthyear=int32(0);
age=int32(0); age0=int32(0); age1=int32(0);
ret=int32(0); ret0=int32(0); ret1=int32(0);
delayedpen=int32(0); earlypenage=int32(0); delayedpenage=int32(0);
contribstartage=int32(0); penjobend=int32(0);
nacats=int32(0); necats=int32(0); nlcats=int32(0); npcats=int32(0); nscats=int32(0); ntcats=int32(0);
acat=int32(0); dcat=int32(0); ecat=int32(0); lcat=int32(0); lacat=int32(0); pcat=int32(0); scat=int32(0);
acati=int32(0); ecati=int32(0); lcati=int32(0); pcati=int32(0); scati=int32(0);
job=int32(0); mainjob=int32(0); priorret=int32(0);
choice=int32(0); choicecount=int32(0);
epscat=int32(0); epscatlim=int32(0);
simeverreturnft=int32(0); simeverreturnpt=int32(0); simeverreturn=int32(0);
erho=0;
eps=0; epsilon=0; epschange=0;
fa=0; fe=0; fl=0; fla=0; fp=0; fs=0; m1=0; m2=0;
changesdev=0; saving=0; wealth=0; dcwealth=0; rgmean=0; eowamt=0;
fepscat=0; fecat=0; fscat=0;
temp=0; pwealth=0; sbenf=0; totutil=0; totalutil=0;
%
%   int    retv(21), jobchoice(4);
retv(1:21,1)=int32(0);jobchoice(1:4,1)=int32(0);
%   double templ(2), tempp(2), temps(2);
templ=zeros(2,1); tempp=zeros(2,1); temps=zeros(2,1);
%   double epsilonvec(10 * necatlim + 1);
epsilonvec=zeros(10 * necatlim + 1,1);
%   double wealthvec(10 * necatlim + 1), dcwealthvec(10 * necatlim + 1);
wealthvec=zeros(10 * necatlim + 1,1); dcwealthvec=zeros(10 * necatlim + 1,1);
%指针
%   char   *mobs;
%   double *mvec, *wmat;
%   double *cumret0mat, *cumret1mat, *cumret2mat;
%   double *cumreturnft, *cumreturnpt, *cumnewpt;
%   double *everreturnft, *everreturnpt, *everreturn;
%   double *cumeverreturnft, *cumeverreturnpt, *cumeverreturn;
%   double *acats, *ecats, *lcats;
%   double *initialpcat, *initialscat, *ssbenf;
%   double *savvec;
%   double *ret0vec, *ret1vec, *ret2vec, *reversal;
%   double *returnft, *returnpt, *newpt;
%   double *realrate, *dccontrib, *eowamount;
%   double (*tuea)(nacatlim);
%   double (*savlea)(necatlim)(nacatlim);
%   double (*savea)(nacatlim);
%   double (*benchanges)(2)(nscatlim);
%   double (*benchangep)(2)(nscatlim);
%   double (*totuw)(nlcatlim)(necatlim)(nacatlim);
%   double (*totud)(3)(2)(npcatlim)(nscatlim)(necatlim)(nacatlim);
%   double (*savw)(nlcatlim)(necatlim)(nacatlim);
%   double (*savd)(3)(2)(npcatlim)(nscatlim)(necatlim)(nacatlim);
%   double (*savr)(2)(npcatlim)(nscatlim)(nacatlim);
%
%   int    (*mjchoice)(nlcatlim)(necatlim)(nacatlim);
%   int    (*retchoice)(2)(npcatlim)(nscatlim)(necatlim)(nacatlim);

mobs='';
mvec=0; wmat=0;
cumret0mat=0; cumret1mat=0; cumret2mat=0;
cumreturnft=0; cumreturnpt=0; cumnewpt=0;
everreturnft=0; everreturnpt=0; everreturn=0;
cumeverreturnft=0; cumeverreturnpt=0; cumeverreturn=0;
acats=0; ecats=0; lcats=0;
initialpcat=0; initialscat=0; ssbenf=0;
savvec=0;
ret0vec=0; ret1vec=0; ret2vec=0; reversal=0;
returnft=0; returnpt=0; newpt=0;
realrate=0; dccontrib=0; eowamount=0;
tuea=zeros(nacatlim,1);
savlea=zeros(necatlim,nacatlim);
savea=zeros(nacatlim,1);
benchanges=zeros(2,nscatlim);
benchangep=zeros(2,nscatlim);
totuw=zeros(nlcatlim,necatlim,nacatlim);
totud=zeros(3,2,npcatlim,nscatlim,necatlim,nacatlim);
savw=zeros(nlcatlim,necatlim,nacatlim);
savd=zeros(3,2,npcatlim,nscatlim,necatlim,nacatlim);
savr=zeros(2,npcatlim,nscatlim,nacatlim);

mjchoice(1:nlcatlim,1:necatlim,1:nacatlim)=int32(0);
retchoice(1:2,1:npcatlim,1:nscatlim,1:necatlim,1:nacatlim)=int32(0);



%   DATA *data;
%   CALCSTRUCT *calcStruct;
%   MOMENTSTRUCT moments;
%   MOMENTSTRUCT *momentStruct;
%   double *momentvec;
calcStruct = calcStructv(threadno - localthreadmin+1);
obs = calcStruct.obs;
data = datav(obs+1);
%
erho = calcStruct.erho;

firstage = calcStruct.firstage;
lastage  = calcStruct.lastage;

rgmean = calcStruct.realrateg;
realrate = calcStruct.realrate;

earlypenage     = calcStruct.earlypenage;
delayedpenage   = calcStruct.delayedpenage;
contribstartage = calcStruct.contribstartage;
penjobend       = calcStruct.penjobend;
sserage         = calcStruct.sserage;
nrage           = calcStruct.nrage;
nragew          = calcStruct.spnrage;
eowamount       = calcStruct.eowamount;

nacats = calcStruct.nacats;
necats = calcStruct.necats;
nlcats = calcStruct.nlcats;
npcats = calcStruct.npcats;
nscats = calcStruct.nscats;
ntcats = calcStruct.ntcats;

acats = calcStruct.acats;
ecats = calcStruct.ecats;
lcats = calcStruct.lcats;

totuw = calcStruct.totuw;
totud = calcStruct.totud;

savw = calcStruct.savw;
savd = calcStruct.savd;
savr = calcStruct.savr;

mjchoice  = calcStruct.mjchoice;
retchoice = calcStruct.retchoice;

initialpcat = calcStruct.initialpcat;
initialscat = calcStruct.initialscat;
dccontrib = calcStruct.dccontrib;

ssbenf = calcStruct.ssbenf;

benchanges  = calcStruct.benchanges;
benchangep  = calcStruct.benchangep;

ret0vec      = calcStruct.ret0vec;
ret1vec      = calcStruct.ret1vec;
ret2vec      = calcStruct.ret2vec;
returnft     = calcStruct.returnft;
returnpt     = calcStruct.returnpt;
newpt        = calcStruct.newpt;

everreturnft = calcStruct.everreturnft;
everreturnpt = calcStruct.everreturnpt;
everreturn   = calcStruct.everreturn;

reversal = calcStruct.reversal;

mode = calcStruct.mode;

if (mode == 1 || mode == 2)
    %   {
    mobs     = arglist.nmat(obs+1,:);             %/* indicator of observed moments */
    mvec     = arglist.mvec(threadno+1,:);        %/* cumulative momemt vector */
    wmat     = arglist.wmat(threadno+1,:);        %/* cumulative w matrix */
    %     }
end

if (mode ~= 2)
    %   {
    cumret0mat      = arglist.ret0mat(threadno+1,:);
    cumret1mat      = arglist.ret1mat(threadno+1,:);
    cumret2mat      = arglist.ret2mat(threadno+1,:);
    cumreturnft     = arglist.returnft(threadno+1,:);
    cumreturnpt     = arglist.returnpt(threadno+1,:);
    cumnewpt        = arglist.newpt(threadno+1,:);
    
    cumeverreturnft = arglist.everreturnft(threadno+1);
    cumeverreturnpt = arglist.everreturnpt(threadno+1);
    cumeverreturn   = arglist.everreturn(threadno+1);
    %     }
end
nsims = 10000;
wealth = 0;


%   %/* do calculations of wealth at firstage as functions of epsilon */
%
birthyear = data.birthyear;
%
epscatlim = 10 * (necats - 1);
%
for epscat = 0:1: epscatlim  %(<=)
    %   {
    eps = ((epscatlim - epscat) * ecats(0+1) + epscat * ecats(necats - 1+1)) / epscatlim;
    
    ecat = floor(epscat / 10);   %(ecat 是int 类型的)
    fe = double(mod(epscat,10) / 10.0);
    
    wealth = 0;
    dcwealth = 0;
    
    for age = 25:1: firstage-1
        %     {
        year = age + birthyear;
        %
        if (1926 < year && year <= 2001)
            %       {
            wealth = (1 + 0.01 * realrate((year - 1) - 1926+1)) * wealth;
            dcwealth = (1 + 0.01 * realrate((year - 1) - 1926+1)) * dcwealth;
            %         }
        else
            %       {
            wealth = (1 + rgmean) * wealth;
            dcwealth = (1 + rgmean) * dcwealth;
            %         }
        end
        
        acat = 0;
        
        while (acat < nacats - 1 && wealth > acats(acat+1))
            acat = acat + 1;
        end
        %
        if (acat > 0)
            acat = acat - 1;
        end
        
        fa = (wealth - acats(acat+1)) / (acats(acat + 1+1) - acats(acat+1));
        %
        if (nlcats > 1 && penjobend >= age && age > contribstartage)
            %       {
            lcat = 0;
            %
            while (lcat < nlcats - 1 && dcwealth > lcats(lcat+1))
                lcat = lcat + 1;
            end
            
            if (lcat > 0)
                lcat = lcat - 1;
            end
            
            fl = (dcwealth - lcats(lcat+1)) / (lcats(lcat + 1+1) - lcats(lcat+1));
            %         }
        else
            %       {
            lcat = 0;
            fl = 0;
            %         }
        end
        
        %       %/* choose savings level */
        %
        for lcati = lcat:1: lcat + 1  %(<=)
            if (lcati == lcat || fl ~= 0)
                %       {
                if (fe ~= 0)
                    temp  = (1 - fe) * ((1 - fa) * savw(age - 25+1,lcati+1,ecat+1,acat+1)...
                        +  fa     * savw(age - 25+1,lcati+1,ecat+1,acat + 1+1))...
                        +  fe     * ((1 - fa) * savw(age - 25+1,lcati+1,ecat + 1+1,acat+1)...
                        +  fa     * savw(age - 25+1,lcati+1,ecat + 1+1,acat + 1+1));
                else temp =         (1 - fa) * savw(age - 25+1,lcati+1,ecat+1,acat+1   )...
                        +  fa     * savw(age - 25+1,lcati+1,ecat+1,acat + 1+1);
                end
                
                if (lcati == lcat)
                    templ(1) = temp;
                else templ(2) = temp;
                end
                %         }
            end
        end
        
        if (fl ~= 0)
            saving = (1 - fl) * templ(1) + fl * templ(2);
        else saving = templ(1);
        end
        
        if (penjobend == age)
            saving = saving + dcwealth + dccontrib(age - 25+1);
        end
        
        wealth = wealth + saving;
        %
        if (penjobend > age && age >= contribstartage)
            dcwealth = dcwealth + dccontrib(age - 25+1);
        else dcwealth = 0;
        end
        %       }
    end
    epsilonvec(epscat+1) = eps;
    wealthvec(epscat+1) = wealth;
    dcwealthvec(epscat+1) = dcwealth;
    %     }
end

changesdev = sqrt(1 - erho * erho);
%
if (tcat == 0)
    %   {
    
    ret0vec=zeros(21,1);
    ret1vec=zeros(21,1);
    ret2vec=zeros(21,1);
    returnft=zeros(21,1);
    returnpt=zeros(21,1);
    newpt=zeros(21,1);
    reversal=zeros(5,1);
    %
    %     *everreturnft = 0;
    %     *everreturnpt = 0;
    %     *everreturn   = 0;
    %指针的初始化
    everreturnft = 0;
    everreturnpt = 0;
    everreturn   = 0;
    
end
%     }

switch(tcat)
    %   {
    case  0
        llim = ( 0 * nsims) / 100;    ulim = ( 10 * nsims) / 100;
    case  1
        llim = (10 * nsims) / 100;    ulim = ( 30 * nsims) / 100;
    case  2
        llim = (30 * nsims) / 100;    ulim = ( 50 * nsims) / 100;
    case  3
        llim = (50 * nsims) / 100;    ulim = ( 70 * nsims) / 100;
    case  4
        llim = (70 * nsims) / 100;    ulim = ( 90 * nsims) / 100;
    case  5
        llim = (90 * nsims) / 100;    ulim = (100 * nsims) / 100;
        %     }
end

% if (tcat == 0)
%     randreset(threadno, obs);
% end

for simcount = llim:1: ulim-1
    %   {
    if (mod(simcount, 100) == 0)
        %     checkMessages();
    end
    
    %     %/* get epsilon and wealth at firstage */
    
    epsilon = gaussdev(threadno);
    
    if (epsilon < ecats(1))
        epsilon = ecats(1);
    else if (epsilon > ecats(necats - 1+1))
            epsilon = ecats(necats - 1+1);
        end
    end
    
    if (epsilon < ecats(necats - 1+1))
        fepscat = 10 * (epsilon - ecats(1)) / (ecats(1+1) - ecats(1));
    else fepscat = 10 * (necats - 1);
    end
    
    epscat = floor( fepscat);
    fe = fepscat - epscat;
    
    if (fe ~= 0)
        %     {
        wealth   = (1 - fe) * wealthvec(epscat+1)   + fe * wealthvec(epscat + 1);
        dcwealth = (1 - fe) * dcwealthvec(epscat+1) + fe * dcwealthvec(epscat + 1);
        %       }
    else
        %     {
        wealth   = wealthvec(epscat+1);
        dcwealth = dcwealthvec(epscat+1);
        %       }
    end
    mainjob = 1;
    
    acat = 0;
    lcat = 0;
    %
    if (firstage < earlypenage && earlypenage < delayedpenage)
        delayedpen = 1;
    else delayedpen = 0;
    end
    
    fecat = (epsilon - ecats(1)) / (ecats(2) - ecats(1));
    
    if (fecat < necats - 1)
        %     {
        ecat = floor( fecat);
        fe = fecat - ecat;
        %       }
    else
        %     {
        ecat = necats - 1;
        fe = 0;
        %       }
    end
    
    pcat = floor( initialpcat(firstage - 50+1));
    scat = floor(initialscat(firstage - 50+1));
    
    fp = initialpcat(firstage - 50+1) - pcat;
    fs = initialscat(firstage - 50+1) - scat;
    
    for age = firstage:1:lastage %(<=)
        %     {
        year = age + birthyear;
        
        if (1926 < year && year <= 2001)
            wealth = (1 + 0.01 * realrate((year - 1) - 1926+1)) * wealth;
        else wealth = (1 + rgmean) * wealth;
        end
        
        if (mainjob == 1)
            %       {
            if (1926 < year && year <= 2001)
                dcwealth = (1 + 0.01 * realrate((year - 1) - 1926+1)) * dcwealth;
            else dcwealth = (1 + rgmean) * dcwealth;
            end
            %         }
        end
        
        if (delayedpen == 1 && earlypenage <= age && age < delayedpenage)
            dcat = 1;
        else dcat = 0;
        end
        
        %       %/* get categories and offsets for eps, wealth, and dcwealth */
        
        if (mainjob == 0)
            %       {
            fecat = (epsilon - ecats(1)) / (ecats(2) - ecats(1));
            %
            ecat = floor( fecat);
            fe = fecat - ecat;
            %         }
        end
        
        if (wealth > acats(acat+1))
            %       {
            acat = acat + 1;
            
            while (acat < nacats - 1 && wealth > acats(acat+1))
                acat = acat + 1;
            end
            %
            if (acat > 0)
                acat = acat - 1;
            end
            %         }
        else
            %       {
            while (acat > 0 && wealth < acats(acat+1))
                acat = acat - 1;
            end
            %         }
        end
        fa = (wealth - acats(acat+1)) / (acats(acat + 2) - acats(acat+1));
        
        eowamt = eowamount(age - 50+1);
        
        if (mainjob == 1 && (nlcats > 1 && penjobend + 1 > age && age > contribstartage))
            %       {
            if (dcwealth > lcats(lcat+1))
                %         {
                lcat = lcat + 1;
                %
                while (lcat < nlcats - 1 && dcwealth > lcats(lcat+1))
                    lcat = lcat + 1;
                end
                
                if (lcat > 0)
                    lcat = lcat - 1;
                end
                %           }
            else
                %         {
                while (lcat > 0 && dcwealth < lcats(lcat+1))
                    lcat = lcat - 1;
                end
                %           }
            end
            
            fl = (dcwealth - lcats(lcat+1)) / (lcats(lcat + 1+1) - lcats(lcat+1));
            %         }
        else
            %       {
            lcat = 0;
            fl = 0;
            %         }
        end
        
        if (mainjob == 1 && ((nlcats > 1 && penjobend + 1 > age && age > contribstartage)...
                || eowamt > 0))
            %       {
            pwealth = wealth + dcwealth + eowamt;
            
            lacat = acat + 1;
            
            while (lacat < nacats - 1 && pwealth > acats(lacat+1))
                lacat = lacat + 1;
            end
            
            lacat = lacat - 1;
            fla = (pwealth - acats(lacat+1)) / (acats(lacat + 1+1) - acats(lacat+1));
            
            %         }
        else
            %       {
            lacat = acat;
            fla = fa;
            %         }
        end
        %       %/* need to decide whether to work or retire */
        
        %       for choice = 0:1: 4-1
        jobchoice(1:4) = 0;
        %       end
        
        choicecount = 0;
        
        if (mainjob == 1)
            %       {
            for lcati = lcat:1: lcat + 1 %(<=)
                if (lcati == lcat || fl ~= 0)
                    %         {
                    for ecati = ecat:1: ecat + 1 %(<=)
                        if (ecati == ecat || fe ~= 0)
                            %           {
                            for acati = acat:1:acat + 1 %(<=)
                                %             {
                                choice = mjchoice(age - 50+1,lcati+1,ecati+1,acati+1);
                                %
                                if (jobchoice(choice+1) == 0)
                                    %               {
                                    choicecount = choicecount + 1;
                                    jobchoice(choice+1) = 1;
                                    %                 }
                                end
                                %               }
                            end
                            
                        end
                    end
                end
            end
            
            %             }
            %           }
            %         }
        else
            %       {
            for pcati = pcat:1:pcat + 1 %(<=)
                if (pcati == pcat || fp ~= 0)
                    %         {
                    for ecati = ecat:1: min(ecat + 1, necats - 1) %(<=)
                        if (ecati == ecat || fe ~= 0)
                            %           {
                            for acati = acat:1: acat + 1
                                for scati = scat:1: scat + 1
                                    if (scati == scat || fs ~= 0)
                                        %             {
                                        choice = retchoice(age - 50+1,dcat+1,pcati+1,scati+1,ecati+1,acati+1);
                                        %
                                        if (jobchoice(choice+1) == 0)
                                            %               {
                                            choicecount = choicecount + 1;
                                            jobchoice(choice+1) = 1;
                                            %                 }
                                        end
                                        %               }
                                    end
                                end
                            end
                            %             }
                        end
                    end
                    %           }
                end
            end
            %         }
        end
        job = -1;
        %
        if (choicecount > 1)
            %       {
            for choice = 0:1: 4-1
                if (jobchoice(choice+1) == 1)
                    %         {
                    if (choice == 0)
                        %           {
                        for lcati = lcat:1:lcat + 1 %(<=)
                            if (lcati == lcat || fl ~= 0)
                                %             {
                                if (fe ~= 0)
                                    temp  = (1 - fe) * ((1 - fa) * totuw(age - 25+1,lcati+1,ecat+1,acat+1    )...
                                        +  fa     * totuw(age - 25+1,lcati+1,ecat+1,acat + 1+1))...
                                        +  fe     * ((1 - fa) * totuw(age - 25+1,lcati+1,ecat + 1+1,acat+1    )...
                                        +  fa     * totuw(age - 25+1,lcati+1,ecat + 1+1,acat + 1+1));
                                else temp =         (1 - fa) * totuw(age - 25+1,lcati+1,ecat+1,acat+1    )...
                                        +  fa     * totuw(age - 25+1,lcati+1,ecat+1,acat + 1+1);
                                end
                                
                                if (lcati == lcat)
                                    templ(1) = temp;
                                else templ(2) = temp;
                                end
                                %               }
                            end
                        end
                        
                        if (fl ~= 0)
                            totutil = (1 - fl) * templ(1) + fl * templ(2);
                        else totutil = templ(1);
                        end
                        %             }
                    else
                        %           {
                        for pcati = pcat:1: pcat + 1 %(<=)
                            if (pcati == pcat || fp ~= 0)
                                %             {
                                for scati = scat:1: scat + 1 %(<=)
                                    if (scati == scat || fs ~= 0)
                                        %               {
                                        tuea(1:necats,1:nacats) = totud(age - 50+1,choice - 1+1,dcat+1,pcati+1,scati+1,1:necats,1:nacats);
                                        %
                                        if (fe ~= 0)
                                            temp  = (1 - fe) * ((1 - fla) * tuea(ecat+1,lacat+1 )...
                                                +  fla     * tuea(ecat+1,lacat + 2))...
                                                +  fe     * ((1 - fla) * tuea(ecat + 2,lacat+1)...
                                                +  fla     * tuea(ecat + 2,lacat + 2));
                                        else temp =         (1 - fla) * tuea(ecat+1,lacat+1    )...
                                                +  fla     * tuea(ecat+1,lacat + 2);
                                        end
                                        
                                        %
                                        if (scati == scat)
                                            temps(1) = temp;
                                        else temps(2) = temp;
                                        end
                                        %                 }
                                    end
                                end
                                
                                if (fs ~= 0)
                                    temp = (1 - fs) * temps(1) + fs * temps(2);
                                else temp = temps(1);
                                end
                                
                                if (pcati == pcat)
                                    tempp(1) = temp;
                                else tempp(2) = temp;
                                end
                                %               }
                            end
                        end
                        
                        if (fp ~= 0)
                            totutil = (1 - fp) * tempp(1) + fp * tempp(2);
                        else totutil = tempp(1);
                        end
                        %             }
                    end
                    
                    
                    
                    if (job < 0)
                        %           {
                        job = choice;
                        totalutil = totutil;
                        %             }
                    else if (totutil > totalutil)
                            %           {
                            job = choice;
                            totalutil = totutil;
                            %             }
                        end
                        %           }
                    end
                    
                end
            end
            %         }
        else
            %       {
            for choice = 0:1: 4-1
                if (jobchoice(choice+1) == 1)
                    job = choice;
                end
            end
            %         }
        end
        
        %       %/* calculate savings, depending on retirement */
        %
        if (job == 0)
            %       {
            savlea(1:nlcats,1:necats,1:nacats) = savw(age - 25+1,1:nlcats,1:necats,1:nacats);
            %
            for lcati = lcat:1:lcat + 1 %(<=)
                if (lcati == lcat || fl ~= 0)
                    %         {
                    if (fe ~= 0)
                        temp  = (1 - fe) * ((1 - fa) * savw(age - 25+1,lcati+1,ecat+1,acat+1)...
                            +  fa     * savw(age - 25+1,lcati+1,ecat +1,acat + 2))...
                            +  fe     * ((1 - fa) * savw(age - 25+1,lcati+1,ecat + 2,acat+1    )...
                            +  fa     * savw(age - 25+1,lcati+1,ecat + 2,acat + 2));
                    else temp =         (1 - fa) * savw(age - 25+1,lcati+1,ecat+1,acat+1  )...
                            +  fa     * savw(age - 25+1,lcati+1,ecat+1,acat + 2);
                    end
                    
                    if (lcati == lcat)
                        templ(1) = temp;
                    else templ(2) = temp;
                    end
                    %           }
                end
            end
            
            if (fl ~= 0)
                saving = (1 - fl) * templ(1) + fl * templ(2);
            else saving = templ(1);
            end
            
            if (penjobend == age)
                saving = saving + dcwealth + dccontrib(age - 25+1);
            end
            %         %/* assign values for dcat, pcat, scat, and fp */
            
            if (age + 1 < earlypenage && earlypenage < delayedpenage)
                delayedpen = 1;
            else delayedpen = 0;
            end
            
            pcat = floor( initialpcat((age + 1) - 50+1));
            scat = floor(initialscat((age + 1) - 50+1));
            
            fp = initialpcat((age + 1) - 50+1) - pcat;
            fs = initialscat((age + 1) - 50+1) - scat;
            %         }
        else
            %       {
            for pcati = pcat:1: pcat + 1
                if (pcati == pcat || fp ~= 0)
                    %         {
                    for scati = scat:1: scat + 1 %(<=)
                        if (scati == scat || fs ~= 0)
                            %           {
                            savea(1:necats,1:nacats) = savd(age - 50+1,job - 1+1,dcat+1,pcati+1,scati+1,1:necats,1:nacats);
                            
                            if (fe ~= 0)
                                temp = (1 - fe) * ((1 - fla) * savea(ecat+1,lacat+1 )...
                                    +  fla     * savea(ecat+1,lacat + 2))...
                                    +  fe     * ((1 - fla) * savea(ecat + 2,lacat+1)...
                                    +  fla     * savea(ecat + 2,lacat + 2));
                            else temp =        (1 - fla) * savea(ecat+1,lacat+1 )...
                                    +  fla     * savea(ecat+1,lacat + 2);
                            end
                            
                            if (scati == scat)
                                temps(1) = temp;
                            else temps(2) = temp;
                            end
                            %             }
                        end
                    end
                    
                    if (fs ~= 0)
                        temp = (1 - fs) * temps(1) + fs * temps(2);
                    else temp = temps(1);
                    end
                    
                    if (pcati == pcat)
                        tempp(1) = temp;
                    else tempp(2) = temp;
                    end
                    
                    %           }
                end
            end
            
            
            if (fp ~= 0)
                saving = (1 - fp) * tempp(1) + fp * tempp(2);
            else saving = tempp(1);
            end
            
            if (mainjob == 1)
                %         {
                
                if (penjobend + 1 > age && age > contribstartage)
                    saving = saving + dcwealth;
                end
                
                saving = saving + eowamt;
                
                mainjob = 0;
                %           }
            end
            
        end  %if job==0
        %         }
        
        retv(age - 50+1) = job;
        
        %       %/* get epsilon for next period */
        
        epschange = gaussdev(threadno);
        
        if (mainjob == 0)
            %       {
            epsilon = erho * epsilon + epschange * changesdev;
            
            if (epsilon < ecats(1))
                epsilon = ecats(1);
            else if (epsilon > ecats(necats - 1+1))
                    epsilon = ecats(necats - 1+1);
                end
            end
            %         }
        end
        %       %/* update wealth, including dc wealth */
        
        wealth = wealth + saving;
        
        if (job == 0)
            %       {
            if (penjobend > age && age >= contribstartage)
                dcwealth = dcwealth + dccontrib(age - 25+1);
            else dcwealth = 0;
            end
            %         }
        end
        
        if (sserage <= age && age < 70)
            if (job == 1 || job == 2)
                %       {
                if (job == 1)
                    %         {
                    if (fs ~= 0)
                        sbenf = (1 - fs) * (ssbenf(scat+1) + benchanges(age - 62+1,1,scat+1 ))...
                            +  fs     * (ssbenf(scat + 2) + benchanges(age - 62+1,1,scat + 2));
                    else sbenf = ssbenf(scat+1) + benchanges(age - 62+1,1,scat+1);
                    end
                    %           }
                else
                    %         {
                    if (fs ~= 0)
                        sbenf = (1 - fs) * (ssbenf(scat+1) + benchangep(age - 62+1,1,scat+1))...
                            +  fs     * (ssbenf(scat + 2) + benchangep(age - 62+1,1,scat + 2));
                    else sbenf = ssbenf(scat+1) + benchangep(age - 62+1,1,scat+1);
                    end
                    %           }
                end
                
                
                
                fscat = -1;
                
                for scati = scat + 1:1: nscats-1
                    %         {
                    if (fscat == -1 && sbenf < ssbenf(scati+1))
                        fscat = (scati - 1) + (sbenf - ssbenf(scati - 1+1))...
                            / (ssbenf(scati+1) - ssbenf(scati - 1+1));
                    end
                    %           }
                end
                
                if (fscat == -1)
                    fscat = (scati - 2) + 0.99;
                end
                
                scat = floor( fscat);
                fs = fscat - scat;
                %         }
            end
        end
        %       }
    end
    
    priorret = 0;
    simeverreturnft = 0;
    simeverreturnpt = 0;
    simeverreturn = 0;
    
    for age = firstage:1:lastage %(<=)
        %     {
        job = retv(age - 50+1);
        %
        if ( job == 1 && priorret == 1)         %/* returned to ft work */
            %       {
            ret0vec(age - 50+1) = ret0vec(age - 50+1) + 1;
            
            if (age > firstage)
                if (retv((age - 1) - 50+1) >= 2)
                    %         {
                    returnft(age - 50+1) = returnft(age - 50+1) + 1;
                    simeverreturnft = 1;
                    simeverreturn = 1;
                    %           }
                end
            end
            %         }
        else if (job == 2)                     %/* partially retired */
                %       {
                ret0vec(age - 50+1) = ret0vec(age - 50+1) + 1;
                ret1vec(age - 50+1) = ret1vec(age - 50+1) + 1;
                %
                if (age > firstage)
                    %         {
                    if (retv((age - 1) - 50+1) == 3)
                        %           {
                        returnpt(age - 50+1) = returnpt(age - 50+1) + 1;
                        simeverreturnpt = 1;
                        simeverreturn = 1;
                        %             }
                    end
                    
                    if (retv((age - 1) - 50+1) ~= 2)
                        newpt(age - 50+1) = newpt(age - 50+1) + 1;
                    end
                    %           }
                end
                
                priorret = 1;
                %         }
            else if (job == 3)                     %/* retired */
                    %       {
                    ret0vec(age - 50+1) = ret0vec(age - 50+1) + 1;
                    ret1vec(age - 50+1) = ret1vec(age - 50+1) + 1;
                    ret2vec(age - 50+1) = ret2vec(age - 50+1) + 1;
                    %
                    priorret = 1;
                    %         }
                end
            end
        end
    end
    %       }
    %
    %这是指针引用所以未来还要改！！！
    everreturnft = everreturnft + simeverreturnft;
    everreturnpt = everreturnpt + simeverreturnpt;
    everreturn   = everreturn + simeverreturn;
    % 指针的回存
    calcStruct.everreturnft=everreturnft;
    calcStruct.everreturnpt=everreturnpt;
    calcStruct.everreturn=everreturn;
    
    
    
    
    %
    for survey = 0:1: 5-1
        %     {
        age0 = data.age(survey+1);
        ret0 = data.ret(survey+1);
        age1 = data.age(survey + 2);
        ret1 = data.ret(survey + 2);
        
        if (54 <= age0 && age0 <= 66 && 1 <= ret0 && ret0 <= 5 ...
                && 54 <= age1 && age1 <= 66 && 1 <= ret1 && ret1 <= 5 ...
                && age1 <= lastage)
            
            if (retv(age0 - 50+1) >= 2 && retv(age1 - 50+1) <= 1)
                reversal(survey+1) = reversal(survey+1) + 1;
            end
        end
        %       }
    end
    %     %/* calculate wealth patterns after lastage if necessary */
    %
    if (mainjob == 1)
        wealth = wealth + dcwealth + eowamount(lastage + 1 - 50+1);
    end
    
    for age = lastage + 1:1: 99 %(<=)
        %     {
        year = age + birthyear;
        
        if (1926 < year && year <= 2001)
            wealth = (1 + 0.01 * realrate((year - 1) - 1926+1)) * wealth;
        else wealth = (1 + rgmean) * wealth;
        end
        
        if (delayedpen == 1 && earlypenage <= age && age < delayedpenage)
            dcat = 1;
        else dcat = 0;
        end
        %
        %       %/* get categories and offsets for eps and wealth */
        %
        if (wealth > acats(acat+1))
            %       {
            acat = acat + 1;
            
            while (acat < nacats - 1 && wealth > acats(acat+1))
                acat = acat + 1;
            end
            
            if (acat > 0)
                acat = acat - 1;
            end
            %         }
        else
            %       {
            while (acat > 0 && wealth < acats(acat+1))
                acat = acat - 1;
            end
            %         }
        end
        
        fa = (wealth - acats(acat+1)) / (acats(acat + 1+1) - acats(acat+1));
        %
        for pcati = pcat:1: pcat + 1 %(<=)
            if (pcati == pcat || fp ~= 0)
                %       {
                for scati = scat:1: scat + 1 %(<=)
                    if (scati == scat || fs ~= 0)
                        %         {
                        if (age < 70)
                            savvec(1:nacats) = savd(age - 50+1,3,dcat+1,pcati+1,scati+1,1,1:nacats);
                        else savvec(1:nacats) = savr(age - 70+1,dcat+1,pcati+1,scati+1,1:nacats);
                        end
                        
                        temp = (1 - fa) * savvec(acat+1) +  fa  * savvec(acat + 1+1);
                        %
                        if (scati == scat)
                            temps(1) = temp;
                        else temps(2) = temp;
                        end
                        %           }
                    end
                end
                
                if (fs ~= 0)
                    temp = (1 - fs) * temps(1) + fs * temps(2);
                else temp = temps(1);
                end
                
                if (pcati == pcat)
                    tempp(1) = temp;
                else tempp(2) = temp;
                end
                
                %         }
            end
        end
        
        if (tempp(2)==tempp(1))
            saving=tempp(1);
        else
            if (fp ~= 0)
                saving = (1 - fp) * tempp(1) + fp * tempp(2);
            else saving = tempp(1);
            end
        end
        wealth = wealth + saving;
        %       }
    end
    
    %     %/* end of computations after lastage */
    %     }
end

%   %/* return if not at last tcat category */
%
if (tcat < ntcats - 1)
    %需要对calcStruct返回赋值
    calcStructv.ret0vec=ret0vec;
    calcStructv.ret1vec=ret1vec;
    calcStructv.ret2vec=ret2vec;
    calcStructv.returnft=returnft;
    calcStructv.returnpt=returnpt;
    calcStructv.newpt=newpt;
    
    calcStructv.everreturnft=calcStruct.everreturnft ;
    calcStructv.everreturnpt=calcStruct.everreturnpt ;
    calcStructv.everreturn=calcStruct.everreturn;
    
    calcStructv.reversal=reversal;
    if (mode == 1 || mode == 2)
        %   {
        arglist.nmat(obs+1,:)=mobs;             %/* indicator of observed moments */
        arglist.mvec(threadno+1,:)=mvec;        %/* cumulative momemt vector */
        arglist.wmat(threadno+1,:)=wmat;        %/* cumulative w matrix */
        %     }
    end
    
    if (mode ~= 2)
        %   {
        arglist.ret0mat(threadno+1,:)=cumret0mat;
        arglist.ret1mat(threadno+1,:)=cumret1mat;
        arglist.ret2mat(threadno+1,:)=cumret2mat;
        arglist.returnft(threadno+1,:)=cumreturnft;
        arglist.returnpt(threadno+1,:)=cumreturnpt;
        arglist.newpt(threadno+1,:)=cumnewpt;
        
        arglist.cumeverreturnft(threadno+1)=cumeverreturnft;
        arglist.cumeverreturnpt(threadno+1)=cumeverreturnpt;
        arglist.cumeverreturn (threadno+1)=cumeverreturn ;
        %     }
    end
    
    return;
end

%   for(age = 50; age <= lastage; age++)
%   {
ret0vec(1:end)= ret0vec(1:end) ./ nsims;
ret1vec(1:end) = ret1vec(1:end) ./ nsims;
ret2vec(1:end) = ret2vec(1:end) ./ nsims;
%     }


if (mode == 1 || mode == 2)
    %   { %/* calculate and update the moments for this respondent */
    %
    %     for (survey = 0; survey < 5; survey++)
    reversal(1:5) = reversal(1:5) ./ nsims;
    %调试
    moments=MOMENTSTRUCT;
    momentStruct= moments;
    %
    for survey = 0:1:6-1
        %     {
        age = data.age(survey+1);
        ret = data.ret(survey+1);
        
        if (54 <= age && age <= 66 && (1 <= ret && ret <= 5))
            %       {
            if (ret == 1 || ret == 3)
                m1 = 1 - ret1vec(age - 50+1);
            else m1 = - ret1vec(age - 50+1);
            end
            
            if (ret == 1)
                m2 = 1 - ret2vec(age - 50+1);
            else m2 = - ret2vec(age - 50+1);
            end
            
            momentStruct.age(age - 54+1) = m1;
            
            if (age == 55)
                k =  0;
            else if (age == 58)
                    k =  1;
                else if (age == 60)
                        k =  2;
                    else if (age == 62)
                            k =  3;
                        else if (age == 65)
                                k =  4;
                            else                     k = -1;
                            end
                        end
                    end
                end
            end
            
            if (k >= 0)
                %         {
                momentStruct.pr(k+1)       = m2;
                if (data.inccat == 1)       momentStruct.lowinc(k+1)   = m1; end
                if (data.inccat == 3)       momentStruct.highinc(k+1)  = m1; end
                if (data.healthage <= age)  momentStruct.health(k+1)   = m1; end
                if (data.healthage <= age)  momentStruct.healthpr(k+1) = m2; end
                %           }
            end
            %         }
        end
        %       }
    end
    
    for survey = 0:1: 5-1
        %     {
        age0 = data.age(survey+1);
        ret0 = data.ret(survey+1);
        age1 = data.age(survey + 2);
        ret1 = data.ret(survey + 2);
        
        if (54 <= age0 && age0 <= 66 && 1 <= ret0 && ret0 <= 5 ...
                && 54 <= age1 && age1 <= 66 && 1 <= ret1 && ret1 <= 5 ...
                && age1 <= lastage)
            %       {
            if ((ret0 == 1 || ret0 == 3) && ret1 == 5)
                momentStruct.reversal(survey+1) = 1 - reversal(survey+1);
            else momentStruct.reversal(survey+1) = - reversal(survey+1);
            end
            %         }
        end
        %       }
    end
    %     %/* update moment matrices */
    %重新把momentStruct数组转换成double类型的数组
    moments=momentStruct;
    
    for imoments=1:13
        momentvec(imoments)=moments.age(imoments);
    end
    for imoments=1:5
        momentvec(13+imoments)=moments.pr(imoments);
    end
    for imoments=1:5
        momentvec(18+imoments)=moments.lowinc(imoments);
    end
    for imoments=1:5
        momentvec(23+imoments)=moments.highinc(imoments);
    end
    for imoments=1:5
        momentvec(28+imoments)=moments.health(imoments);
    end
    for imoments=1:5
        momentvec(33+imoments)=moments.healthpr(imoments);
    end
    for imoments=1:5
        momentvec(38+imoments)=moments.reversal(imoments);
    end
    
    %
    for l = 0:1: nmoments-1
        if (mobs(l+1) > 0)
            mvec(l+1) = mvec(l+1) + momentvec(l+1);
        end
    end
    %     %/* update w matrix */
    
    for l1 = 0:1:nmoments-1
        if (mobs(l1+1) > 0)
            %     {
            for l2 = 0:1: l1  %(<=)
                if (mobs(l2+1) > 0)
                    %       {
                    l = l1 * (l1 + 1) / 2 + l2;
                    %
                    wmat(l+1) = wmat(l+1) + momentvec(l1+1) * momentvec(l2+1);
                    %         }
                end
            end
            %       }
        end
    end
    %     }
end

if (mode ~= 2)
    %   { %/* update tabs for this respondent */
    
    for age = 50:1: 69  %(<=)
        %     {
        cumret0mat(age - 50+1)  = cumret0mat(age - 50+1) + ret0vec(age - 50+1);
        cumret1mat(age - 50+1)  = cumret1mat(age - 50+1) + ret1vec(age - 50+1);
        cumret2mat(age - 50+1)  = cumret2mat(age - 50+1) + ret2vec(age - 50+1);
        cumreturnft(age - 50+1) = cumreturnft(age - 50+1) + returnft(age - 50+1) / nsims;
        cumreturnpt(age - 50+1) = cumreturnpt(age - 50+1) + returnpt(age - 50+1) / nsims;
        cumnewpt(age - 50+1)    = cumnewpt(age - 50+1) + newpt(age - 50+1) / nsims;
        %       }
    end
    
    cumeverreturnft = cumeverreturnft + everreturnft / nsims;
    cumeverreturnpt = cumeverreturnpt + everreturnpt / nsims;
    cumeverreturn   = cumeverreturn + everreturn / nsims;
    
    %     }
end
%   }

%——————————————————————————————
%返回赋值部分
%——————————————————————————————

if (mode == 1 || mode == 2)
    %   {
    arglist.nmat(obs+1,:)=mobs ;             %/* indicator of observed moments */
    arglist.mvec(threadno+1,:)= mvec;        %/* cumulative momemt vector */
    arglist.wmat(threadno+1,:)=wmat;        %/* cumulative w matrix */
    %     }
end

if (mode ~= 2)
    %   {
    arglist.ret0mat(threadno+1,:)=cumret0mat;
    arglist.ret1mat(threadno+1,:)=cumret1mat;
    arglist.ret2mat(threadno+1,:)=cumret2mat;
    arglist.returnft(threadno+1,:)=cumreturnft;
    arglist.returnpt(threadno+1,:)=cumreturnpt;
    arglist.newpt(threadno+1,:)=cumnewpt;
    
    arglist.everreturnft(threadno+1)=cumeverreturnft;
    arglist.everreturnpt(threadno+1)=cumeverreturnpt;
    arglist.everreturn(threadno+1)=cumeverreturn   ;
    %     }
end

calcStructv.everreturnft=everreturnft;
calcStructv.everreturnpt=everreturnpt;
calcStructv.everreturn=everreturn;

calcStructv.ret0vec=ret0vec;
calcStructv.ret1vec=ret1vec ;
calcStructv.ret2vec=ret2vec      ;
calcStructv.returnft=returnft    ;
calcStructv.returnpt=returnpt    ;
calcStructv.newpt=newpt;
calcStructv.reversal=reversal;