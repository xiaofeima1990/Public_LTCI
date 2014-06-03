% % /*---------------------------------------------------------------------------
% 			 CALC PREP routine
% 			 calculates utility, savings, and job choices for the model
%   ---------------------------------------------------------------------------*/
%
function [gv calc] = calcprep(gv,calc,data)

plumpsum = gv.data.plumpsum;

% calc = gv.calc(gv.arglist.obs,1);
% data = gv.data(gv.arglist.obs,1);

obs = calc.obs;
firstage = calc.firstage;
lastage  = calc.lastage;
tcats = calc.tcats;
acats = calc.acats; % Asset grid;
ecats = calc.ecats;
lcats = calc.lcats;
pcats = calc.pcats;
mainwage = calc.mainwage;
secwage  = calc.secwage;
prwage   = calc.prwage;
initialpcat = calc.initialpcat;
dccontrib = calc.dccontrib;
eowamount = calc.eowamount;
srate = calc.srate;
transrate = calc.transrate;
etrans = calc.etrans;
rprob = calc.rprob;
rtransa = calc.rtransa;
rtransl = calc.rtransl;
realrate = calc.realrate;
othincome = calc.othincome;
utilr = calc.utilr;
inflrate   = calc.inflrate;
penadjrate = calc.penadjrate;
ramean = calc.realratea;
rgmean = calc.realrateg;
rstddev = calc.realratesd;

calc.ntcats = gv.ntcatlim;
calc.nacats = gv.nacatlim;
calc.necats = gv.necatlim;
calc.nlcats = gv.nlcatlim;
calc.npcats = gv.npcatlim;
calc.nrcats = gv.nrcatlim;
calc.nscats = gv.nscatlim;

pensben = data.pensben;
penstart = data.penstart;
        
% Get survival rates and transition rates */
calc.birthyear = data.birthyear;
calc.spbirthyear = data.spbirthyear;
surv=squeeze(gv.survtable(calc.birthyear-1900+1,1,:))';
spsurv=squeeze(gv.survtable(calc.spbirthyear-1900+1,2,:))';

% Treat survival as certain until age 62;
surv(1,1:62) = surv(1,63)*ones(1,62);
% surv = surv(1,2:120)./surv(1,1:119);
spsurv(1,1:62) = spsurv(1,63)*ones(1,62);
% spsurv = spsurv(1,2:120)./spsurv(1,1:119);

srate(1,:) = 0.001*(surv(1,26:100)==0 | surv(1,27:101)==0) + ...
    surv(1,27:101)./surv(1,26:100).*(surv(1,26:100)>0 & surv(1,27:101)>0);
% >??????? 0.9683414=surv(1,72)/surv(1,71)=57473/59352=0.968341420676641 ?????
srate(2,:) = 1*((25:99)+data.birthyear-data.spbirthyear<1) + ...
    0.001*((25:99)+data.birthyear-data.spbirthyear>=119) + ...
    0.001*(spsurv(1,(26:100)+data.birthyear-data.spbirthyear)==0 | spsurv(1,(27:101)+data.birthyear-data.spbirthyear)==0) + ...
    spsurv(1,(27:101)+data.birthyear-data.spbirthyear)./spsurv(1,(26:100)+data.birthyear-data.spbirthyear).* ...
    (spsurv(1,(26:100)+data.birthyear-data.spbirthyear)>0 & spsurv(1,(27:101)+data.birthyear-data.spbirthyear)>0);

transrate(1,:) = srate(1,:).*srate(2,:);
transrate(2,:) = srate(1,:).*(1-srate(2,:));
transrate(3,:) = (1-srate(1,:)).*srate(2,:);
calc.srate = srate;
calc.transrate = transrate;

% copy earnings amounts to calcStruct;
calc.mainwage=data.ftwage;
calc.secwage=data.secwage;
calc.prwage=data.prwage;

% set up categories for assets;
% without claim pension?
earnings = 0;
for age = 25:min(69, 1992 - data.birthyear);
    earnings = earnings * (1 + rgmean);
    earnings = earnings + calc.mainwage(age - 25+1,1) + data.othincome(age - 25+1,1);
    if data.spbirthyear > 0;
        spage = age + data.birthyear - data.spbirthyear;
        if spage >= 25 && spage < 70;
            earnings = earnings + data.spwage(spage - 25+1,1);
        end
        if spage == data.sppenstart;
            earnings = earnings + data.spplumpsum;
        end
    end
end
totearnings = earnings;

earnings = data.plumpsum(70 - 50 + 1,1);
for age = 70:-1: max(25, 1992 - data.birthyear)+1;
    earnings = earnings / (1 + rgmean);
    if age == 70;
        earnings = earnings + data.prwage(20,1) + data.othincome(age - 25+1,1);
    else
        earnings = earnings + data.ftwage(age - 25 + 1,1) + data.othincome(age - 25+1,1);
    end
    if data.spbirthyear > 0;
        spage = age + data.birthyear - data.spbirthyear;
        if spage >= 25 && spage < 70;
            earnings = earnings + data.spwage(spage - 25+1);
        end
        if spage == data.sppenstart;
            earnings = earnings + data.spplumpsum;
        end
    end
end
acats(calc.nacats,1) = max(totearnings, earnings);
for i = calc.nacats: -1: 5;
    acats(i-1,1) = acats(i,1) / 1.25;
end
for i = 4:-1: 1;
    acats(i,1) = (i-1) * acats(5) / 4;
end
calc.acats=acats;

% set up categories for epsilon;
ecats(1,1) = -3;
ecats(calc.necats,1) = 3;
ecats(2:calc.necats-1,1) = ecats(1,1) + (1:calc.necats-2)' .* (ecats(calc.necats,1) - ecats(1,1))/(calc.necats - 1);
% calculate transition probabilities for epsilon categories; 
erho = calc.erho;
stddev = sqrt(1 - erho * erho);
for i = 1:gv.necatlim;
    etrans(i,1) = 0;
    condmean = erho * ecats(i,1);
    for j = 1:gv.necatlim-1;
        etrans(i,j+1) = ...
            normcdf((((ecats(j+1,1) + ecats(j,1)) / 2) - condmean) / stddev, 0, 1);
        etrans(i,j) = etrans(i,j+1) - etrans(i,j);
    end
    etrans(i,gv.necatlim) = 1 - etrans(i,gv.necatlim);
end
calc.ecats=ecats;
calc.etrans=etrans;

% set up normalized values for rates of return;
rnorm(1,1) = -2;
rnorm(calc.nrcats,1) =  2;
rnorm(2:calc.nrcats-1,1) = rnorm(1,1) + (1:calc.nrcats-2)' .* (rnorm(calc.nrcats,1) - rnorm(1,1))/(calc.nrcats - 1);
% calculate probabilities for rates of return;
rprob(1,1) = 0;
for rcat = 1:gv.nrcatlim-1
    rprob(rcat+1,1) = normcdf((rnorm(rcat+1,1) + rnorm(rcat,1)) / 2,0,1);
    rprob(rcat,1) = rprob(rcat+1,1) - rprob(rcat,1);
end
rprob(gv.nrcatlim,1) = 1 - rprob(gv.nrcatlim,1);
calc.rnorm=rnorm;
calc.rprob=rprob;

% calculate asset transitions for rates of return; % from certain category to another category;
rtransa = (acats*ones(1,gv.nrcatlim)).*(1 + ramean + rnorm*ones(1,gv.nacatlim) * rstddev)';
rtransa = interp1(acats,(1:gv.nacatlim)',rtransa,'linear','extrap')-1;
rtransa(1,:) = zeros(1,gv.nrcatlim);
calc.rtransa=rtransa;

% find out if eligible for pensions;
somepens = 0;
if sum(data.pensben(firstage-50+1:lastage+1-50+1,1)>0) > 0; % from 50 to 70;
    somepens = 1;
end;

% adjust pensions if necessary;
if somepens > 0;
    earlypenage = 0;   % find first age pension can be immediately collected;   
    for age = firstage:lastage+1;
        if earlypenage == 0 && age == penstart(age - 50+1,1);
            earlypenage = age;
        end;
    end;
    if earlypenage == 0;
        earlypenage = lastage + 2;
    end;
    if earlypenage > firstage
        delayedpenage = 99;    % find earliest age deferred vested benefits can be collected;
        for age = firstage:earlypenage-1;
            if penstart(age - 50+1,1) < delayedpenage;
                delayedpenage = penstart(age - 50+1,1);
            end
        end
        if delayedpenage < earlypenage || delayedpenage == 99;
            delayedpenage = earlypenage;
        end
    else
        delayedpenage = earlypenage;
    end
    for age = firstage:1:earlypenage-1; % adjust deferred vested benefits to delayedpenage;
        if (penstart(age - 50+1,1) ~= delayedpenage)
            pensben(age - 50+1,1) = pensben(age - 50+1,1) * adjben(penstart(age - 50+1,1), delayedpenage, calc);
        end
        
        for age = earlypenage:lastage+1; % adjust if not currently collectable;
            if penstart(age - 50+1,1) ~= age;
                pensben(age - 50+1,1) = pensben(age - 50+1,1) * adjben(penstart(age-50+1,1), age, calc);
            end
            % actualrially adjusts pension benefits to a new starting age;
        end
    end
elseif somepens == 0
    earlypenage = 99;
    delayedpenage = 99;
end
calc.earlypenage = earlypenage;
calc.delayedpenage = delayedpenage;


% set up categories for pensions;

% The pensions associated with the pcats categories are assumed to decline
% by the rate inflrate * (1 - penadj) every year to reflect that pensions
% are incompletely indexed.  The 0 and 3 categories are the lowest and
% highest pensions available.  The amounts of pcats(0) and pcats(3) are
% as of age 50, as if the individual could collect them at that age;

if somepens == 0;
    calc.npcats = 1;
    pcats(1,1) = 0;
    initialpcat = zeros(lastage+1-firstage,1);
elseif somepens == 1;
    maxpen = 0;
    minpen = 0;
    for age = firstage:lastage + 1;
        if (pensben(age - 50+1,1) > 0)
            adjpen = pensben(age - 50+1,1) * exp(inflrate * (1 - penadjrate) * (penstart(age - 50+1,1) - 50));
            if (minpen == 0 || adjpen < minpen)
                minpen = adjpen;
            end
            if (adjpen > maxpen)
                maxpen = adjpen;
            end;
        end;
    end;
    if somepens == 0; % impossible to appear?
        pcats(1,1) = 0;
        pcats(2,1) = 0.99 * minpen;
        pcats(calc.npcats) = 1.01 * maxpen;
        for pcat = 3:calc.npcats - 1;
            pcats(pcat,1) = pcats(2,1) * (pcats(calc.npcats,1) / pcats(2))^((pcat-2) / (calc.npcats - 2));
        end;
    elseif somepens == 1;
        pcats(1,1) = 0.99 * minpen;
        pcats(calc.npcats,1) = 1.01 * maxpen;
        for pcat = 2:calc.npcats - 1;
            pcats(pcat,1) = pcats(1,1) * ((pcats(calc.npcats,1) / pcats(1)))^(pcat-1 / (calc.npcats-2));
        end;
    end;
    
    for age = firstage:1:lastage + 1;
        if pensben(age - 50+1,1) > 0;
            adjpen = pensben(age - 50+1,1) * exp(inflrate * (1 - penadjrate) * (penstart(age - 50+1,1) - 50));
            
            pcat = 0;
            while pcat < calc.npcats - 1 && adjpen > pcats(pcat+1);
                pcat = pcat + 1;
            end;
            if pcat > 0;
                pcat = pcat - 1;
            end;
            initialpcat(age - 50+1,1) = pcat + (adjpen - pcats(pcat+1,1)) / (pcats(pcat + 1+1,1) - pcats(pcat+1,1));

            if (initialpcat(age - 50+1,1) > calc.npcats - 1)
                initialpcat(age - 50+1,1) = calc.npcats - 1;
            end;
        else
            initialpcat(age - 50+1,1) = 0;
        end;
    end;
end;
calc.pcats=pcats;
calc.initialpcat=initialpcat;

% calculate vector of dc contributions;
dccontrib=zeros(45,1);
contribstartage = 99;

for age = 50:1:70-1
    dccontrib(age - 25+1,1) = plumpsum((age + 1) - 50+1,1) / 1.022 - plumpsum(age - 50+1,1);
    if dccontrib(age - 25+1,1) < 0;
        dccontrib(age - 25+1,1) = 0;
    end;
    if dccontrib(age - 25+1,1) > 0 && age < contribstartage;
        contribstartage = age;
    end;
end

if plumpsum(50 - 50+1,1) > 0
    contribrate = 0;
    for age = 50:70-1;
        if contribrate == 0 && dccontrib(age - 25+1,1) > 0 && mainwage(age - 25+1,1) > 0;
            contribrate = dccontrib(age - 25+1,1) / mainwage(age - 25+1,1);
        end
    end
    
    if contribrate > 0;
        accum = plumpsum(50 - 50+1,1) / 1.022;
        adjfactor = 0;
        for age = 49:-1: 25;
            if accum > 0;
                if mainwage(age - 25+1,1) > 0
                    if accum > contribrate * mainwage(age - 25+1,1);
                        dccontrib(age - 25+1,1) = contribrate * mainwage(age - 25+1,1);
                        accum = (accum - dccontrib(age - 25+1,1)) / 1.022;
                    else
                        dccontrib(age - 25+1,1) = accum;
                        accum = 0;
                    end
                    contribstartage = age;
                else
                    adjfactor = 1 + (accum * 1.022^(50 - age)) / plumpsum(50 - 50+1,1);
                    accum = 0;
                end
            end
        end
        
        if adjfactor > 0
            for age = 25:50-1
                dccontrib(age - 25+1,1) = dccontrib(age - 25+1,1) * adjfactor;
                if dccontrib(age - 25+1,1) > 0.25 * mainwage(age - 25+1,1);
                    dccontrib(age - 25+1,1) = 0.25 * mainwage(age - 25+1,1);
                end
            end
        end
    end
end
calc.penjobend = data.penjobend;
calc.contribstartage = contribstartage;
calc.dccontrib=dccontrib;


% set up categories for dc accumulations and transition matrices;
if contribstartage < 99
    maxaccum = 0;
    for age = 25:lastage-1
        if dccontrib(age - 25+1) > 0;
            maxaccum = maxaccum + dccontrib(age - 25+1,1) * (1 + ramean + 2.5 * rstddev)^sqrt(lastage - age);
        end;
    end;
    lcats(calc.nlcats,1) = maxaccum;
    for lcat = calc.nlcats-1:-1: 5;
        lcats(lcat,1) = lcats(lcat+1) / 1.4;
    end
    for lcat = 4:-1:1 
        lcats(lcat,1) = (lcat-1) * lcats(5,1) / 4;
    end
    calc.lcats=lcats;
    
    % set up transitions among dc accumulation categories;
    for age = contribstartage+1: lastage;
        for lcat = 0: 1:calc.nlcats-1
            for rcat = 0:1 :calc.nrcats-1
                accum = (lcats(lcat+1) + dccontrib((age - 1) - 25+1)) * (1 + ramean + rnorm(rcat+1) * rstddev);
                
                tcat = 0;
                while tcat < calc.nlcats - 1 && accum > lcats(tcat+1,1);
                    tcat = tcat + 1;
                end
                if tcat > 0;
                    tcat = tcat - 1;
                end
                rtransl(age - 25+1,lcat+1,rcat+1) = tcat + (accum - lcats(tcat+1)) / (lcats(tcat + 1+1) - lcats(tcat+1));
            end
        end
    end
elseif contribstartage == 99;
    calc.nlcats = 1;
    lcats = 0;
    for age = contribstartage+1:lastage;
        for lcat = 0:1: calc.nlcats;
            for rcat = 0:1: calc.nrcats;
                rtransl(age - 25+1,lcat+1,rcat+1) = lcats;
            end
        end
    end
end
calc.rtransl=rtransl;

% early out window amounts;
calc.eowamount=data.eowamount;

% set up categories and benefit amounts for social security;
% Calculates social security categories and benefit amounts
calc=sscalc(gv,calc,data);

% calculate spouse earnings, pension, and other income;
othincome=zeros(75,3);
if calc.spbirthyear > 0;
    for age = 25:1: 100-1;
        spage = age + calc.birthyear - calc.spbirthyear;
        if spage >= 25&& spage < 70
            othincome(age - 25+1,1) = othincome(age - 25+1,1) + data.spwage(spage - 25+1);
            othincome(age - 25+1,3) = othincome(age - 25+1,3) + data.spwage(spage - 25+1);
        end
        
        if data.sppenstart < 99;
            if spage == data.sppenstart;
                sppensben = data.sppensben;
            end
            
            if spage >= data.sppenstart && spage < 100;
                othincome(age - 25+1,1) = othincome(age - 25+1,1) + sppensben;
                othincome(age - 25+1,3) = othincome(age - 25+1,3) + sppensben;
            end;
            sppensben = 0;
            sppensben = sppensben / (1 + inflrate * (1 - penadjrate));
            
            if spage == data.sppenstart;
                othincome(age - 25+1,1) = othincome(age - 25+1,1) + data.spplumpsum;
                othincome(age - 25+1,3) = othincome(age - 25+1,3) + data.spplumpsum;
            end
        end
    end
end

for age = 25:1:100-1;
    for vcat = 1: 3;
        othincome(age - 25+1,vcat) = othincome(age - 25+1,vcat) + data.othincome(age - 25+1);
    end
end

calc.othincome=othincome;

% calculate utility of retirement;
beta0 = calc.beta0;
beta1 = calc.beta1;
beta2 = calc.beta2;
sige  = calc.sige;
for age = 50:1:70-1
    bX = beta0 + beta1 * (age - 62);
    if age >= data.healthage;
        bX = bX + beta2;
    end
    for ecat = 1:gv.necatlim;
        utilr(ecat,age - 50+1) = exp(bX + sige * ecats(ecat,1));
    end
end
calc.utilr=utilr;

% calculate relative utility of partial retirement;
gamma0 = calc.gamma0;
gamma1 = calc.gamma1;
for tcat = 1:gv.ntcatlim;
    if tcat ==  1;
            percentile =  5;
    elseif tcat ==  2;
            percentile = 20;
    elseif tcat == 3;
            percentile = 40;
    elseif tcat == 4;
            percentile = 60;
    elseif tcat == 5;
            percentile = 80;
    elseif tcat == 6;
            percentile = 95;
    end;
    for age = 50:70-1;
        exponent = gamma0 + gamma1 * (age - 65);
        
        delta = log((percentile / 100) * (exp(exponent) - 1) + 1) / exponent;
        
        if (data.gender == 1 && data.healthage <= age)
            delta = 0;
        end
        tcats(tcat,age - 50+1) = 0.5 + 0.5 * delta;
    end
end
calc.tcats=tcats;

