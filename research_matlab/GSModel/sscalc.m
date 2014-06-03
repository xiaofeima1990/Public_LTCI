% /*---------------------------------------------------------------------------
% 			 SS CALC routine
% 			 Calculates social security categories and benefit amounts
%   ---------------------------------------------------------------------------*/
%
function [calc] = sscalc(gv,calc,data)

fbenefit=zeros(21,1);
adjownv=zeros(4,1); adjspv=zeros(4,1); spadjownv=zeros(4,1); spadjspv=zeros(4,1);
adjownm=zeros(21,4); adjspm=zeros(21,4); spadjownm=zeros(21,4); spadjspm=zeros(21,4);
nscats = calc.nscats;
mainwage = calc.mainwage;
secwage  = calc.secwage;
prwage   = calc.prwage;
initialscat = calc.initialscat;
ssbenf = calc.ssbenf;
ssbenm = calc.ssbenm;
ssbens = calc.ssbens;
ssbenp = calc.ssbenp;
ssbenr = calc.ssbenr;
benchanges  = calc.benchanges;
benchangep  = calc.benchangep;
birthyear = data.birthyear;
spbirthyear = data.spbirthyear;
sserage = 62;

% SS calculation is not as accurate as ours;
if birthyear <= 1939;
    nrage = 65;
elseif birthyear > 1939 && birthyear <= 1956
    nrage = 66;
elseif birthyear > 1956;
    nrage = 67;
end;

if birthyear <= 1924;
    delayedret = 0.03;
elseif birthyear > 1924 && birthyear <= 1942;
    delayedret = 0.03 + 0.005 * ((birthyear - 1923) / 2);
elseif birthyear > 1942;
    delayedret = 0.08;
end;

if spbirthyear > 0;
    if spbirthyear <= 1939;
        spnrage = 65;
    elseif spbirthyear > 1939 && spbirthyear <= 1956;
            spnrage = 66;
    elseif spbirthyear > 1956;
        spnrage = 67;
    end;
    
    if spbirthyear <= 1924
        spdelayedret = 0.03;
    elseif spbirthyear > 1924 && spbirthyear <= 1942;
        spdelayedret = 0.03 + 0.005 * ((spbirthyear - 1923) / 2);
    elseif spbirthyear > 1942;
        spdelayedret = 0.08;        
    end;
elseif spbirthyear == 0;
    spnrage = 65;
    spdelayedret = 0.08;
end

calc.sserage = sserage;
calc.nrage   = nrage;
calc.spnrage = spnrage;
calc.delayedret   = delayedret;
calc.spdelayedret = spdelayedret;

% calculate current benefits if working in main job;
adjown = 1 - (0.2 / 3) * min(nrage - sserage, 3) - 0.05 * max(nrage - sserage - 3, 0); % Given ERA is 62: If NRA is 65, adjown is 0.8; If NRA is 66, adjown is 0.75; If NRA is 67, adjown is 0.7;
adjsp  = 1 - (0.25 / 3) * min(nrage - sserage, 3) - 0.05 * max(nrage - sserage - 3, 0); % Given ERA is 62: If NRA is 65, adjsp is 0.75; If NRA is 66, adjown is 0.7; If NRA is 67, adjown is 0.65;
spadjown = 1 - (0.2 / 3) * min(spnrage - sserage, 3) - 0.05 * max(spnrage - sserage - 3, 0);
spadjsp  = 1 - (0.25 / 3) * min(spnrage - sserage, 3) - 0.05 * max(spnrage - sserage - 3, 0);

for age = 25:70-1;
    year = age + birthyear;
    spage = year - spbirthyear;
    
    if age <= 50;
        pia    = data.pia(50-50+1,1);
        ncpens = data.ncpens(50-50+1,1);
    elseif age > 50;
        pia    = data.pia(age- 50+1,1);
        ncpens = data.ncpens(age-50+1,1); % Non-covered pension;
    end;
    if age >= 50;
        fbenefit(age-50+1,1) = adjown * pia;
    end;
    if age >= sserage || spage >= sserage;
        if spage < 50;
            sppia    = data.sppia(50-50+1, 1);
            spncpens = data.spncpens(50-50+1, 1);
        elseif spage >= 50 && spage <= 69;
            sppia = data.sppia(spage-50+1, 1);
            spncpens = data.spncpens(spage-50+1, 1);
        elseif spage > 69;
            sppia = data.sppia(70-50+1, 1);
            spncpens = data.spncpens(70-50+1, 1);
        end;
        if age >= sserage;
            ownben = adjown * pia;
        elseif age < sserage;
            ownben = 0;
        end;
        if spage >= sserage;
            spownben = spadjown * sppia;
        elseif spage < sserage;
            spownben = 0;
        end;
        if age >= sserage && spage >= sserage; % ???
            benefitsp = max(adjsp * (0.5 * sppia - pia) - ncpens, 0);
            spbenefitsp = max(spadjsp * (0.5 * pia - sppia) - spncpens, 0);
        else
            benefitsp = 0;
            spbenefitsp = 0 ;
        end;
        
        adjfactor = 1.01^( year - 1992);
        if age < nrage || (age < 70 && year < 2001); % ??? earning's test looks odd;
            earntest = 1;
            if age < nrage;
                earningstest = 7440 * adjfactor;
                rednrate = 0.5;
            else
                earningstest = 10200 * adjfactor;
                rednrate = 0.333333;
            end
        else
            earntest = 0;
        end;
        if spage < spnrage || (spage < 70 && year < 2001);
            spearntest = 1;
            if spage < spnrage;
                spearningstest = 7440 * adjfactor;
                sprednrate = 0.5;
            else
                spearningstest = 10200 * adjfactor;
                sprednrate = 0.333333;
            end
        else
            spearntest = 0;
        end;
        earnings = mainwage(age-25+1, 1);
        
        if spage >= 25 && spage < 70;
            spearnings = data.spwage(spage-25+1,1);
        else
            spearnings = 0;
        end;
        
        % both spouses survive (vcat == 1);
        if earntest == 1; % husband collecting own benefit;
            if ownben + spbenefitsp > 0;
                pctlost = rednrate * (earnings - earningstest) / (ownben + spbenefitsp);
                if pctlost < 0;
                    pctlost = 0;
                elseif pctlost > 1;
                    pctlost = 1;
                end;
            else
                pctlost = 1;
            end;
        else
            pctlost = 0;
        end;
        if spearntest == 1; % wife collecting own benefits;
            if spownben + benefitsp > 0
                sppctlost = sprednrate * (spearnings - spearningstest) / (spownben + benefitsp);
                if sppctlost < 0;
                    sppctlost = 0;
                elseif sppctlost > 1;
                    sppctlost = 1;
                end;
            else
                sppctlost = 1;
            end;
        else
            sppctlost = 0;
        end;
        if benefitsp > 0; % husband collecting spouse benefits;
            if sppctlost < pctlost; %  additional loss of spouse benefits;
                sppctlost = sppctlost - (pctlost - sppctlost) * benefitsp / spownben;
                pctlostsp = pctlost;
                if sppctlost < 0;
                    sppctlost = 0;
                end
            else
                pctlostsp = sppctlost;
            end;
        else
            pctlostsp = 1;
        end;
        if spbenefitsp > 0; % wife collecting spouse benefits;
            if pctlost < sppctlost; % additional loss of spouse benefits;
                pctlost = pctlost - (sppctlost - pctlost) * spbenefitsp / ownben;
                sppctlostsp = sppctlost;
                if pctlost < 0;
                    pctlost = 0;
                end
            else
                sppctlostsp = pctlost;
            end;
        else
            sppctlostsp = 1;
        end;
        ssbenm(age-25+1, 1) = (1 - pctlost) * ownben + (1 - pctlostsp) * benefitsp + ...
            (1 - sppctlost) * spownben + (1 - sppctlostsp) * spbenefitsp; % sum up all four kinds of benefits;
        
        % only husband survives (vcat = 2); ??? No survivor benefit considered? no wife only case???
        if age >= sserage;
            survben = max(ownben, sppia * max(0.825, spadjown));
            if survben > 0;
                if earntest == 1;
                    survpctlost = rednrate * (earnings - earningstest) / survben;
                    if survpctlost < 0;
                        survpctlost = 0;
                    elseif survpctlost > 1
                        survpctlost = 1;
                    end;
                else
                    survpctlost = 0;
                end;
                ssben = (1 - survpctlost) * survben;
            else
                ssben = 0;
            end;
        else
            ssben = 0;
        end;
        ssbenm(age-25+1, 2) = ssben;
        
        % update adjustment factors;
        if age >= sserage && age < 70;
            if age < nrage - 3;
                pctchange = 0.05 * pctlost;
                pctchangesp = 0.05 * pctlostsp;
            elseif age >= nrage - 3 && age < nrage;
                pctchange = (0.2 / 3) * pctlost;
                pctchangesp = (0.25 / 3) * pctlostsp;
            elseif age >= nrage;
                pctchange = delayedret * pctlost;
                pctchangesp = 0;
            end;
        else
            pctchange = 0;
            pctchangesp = 0;
        end;
        if spage >= sserage && spage < 70;
            if spage < spnrage - 3;
                sppctchange = 0.05 * sppctlost;
                sppctchangesp = 0.05 * sppctlostsp;
            elseif spage < spnrage;
                sppctchange = (0.2 / 3) * sppctlost;
                sppctchangesp = (0.25 / 3) * sppctlostsp;
            elseif spage >= spnrage;
                sppctchange = spdelayedret * sppctlost;
                sppctchangesp = 0;
            end;
        else
            sppctchange = 0;
            sppctchangesp = 0;
        end;
        adjown = adjown + pctchange;
        adjsp = adjsp + pctchangesp;
        spadjown = spadjown + sppctchange;
        spadjsp = spadjsp + sppctchangesp;
        
        if age == 69;
            fbenefit(70-50+1, 1) = adjown * data.pia(70-50+1, 1);
        end;
    else
        ssbenm(age - 25+1, 1) = 0;
        ssbenm(age - 25+1, 2) = 0;
    end;
    
    % collect adjustment factors at ages corresponding to scat categories;
    if age + 1 == 50;
        scati = 0;
    elseif age + 1 == sserage;
        scati = 1;
    elseif age + 1 == nrage;
        scati = 2;
    elseif age + 1 == 70;
        scati = 3;
    else
        scati = -1;
    end;
    if scati >= 0;
        adjownv(scati+1, 1) = adjown;
        adjspv(scati+1, 1) = adjsp;
        spadjownv(scati+1, 1) = spadjown;
        spadjspv(scati+1, 1) = spadjsp;
    end;
end;

% calculate benefits if retired at age corresponding to scat categories;
for scat = 0:nscats-1;
    switch(scat)
        case  0
            retage = 50;
        case  1
            retage = sserage;
        case  2
            retage = nrage;
        case  3
            retage = 70;
    end;
    pia    = data.pia(retage - 50+1, 1);
    ncpens = data.ncpens(retage - 50+1, 1);

    for age = 50:99;
        year = age + birthyear;
        spage = year - spbirthyear;
        if age < retage;
            adjown = adjownv(scat+1) - (adjownm(retage - 50+1,scat - 1+1) - adjownm(age - 50+1,scat - 1+1));
            adjsp = adjspv(scat+1) - (adjspm(retage - 50+1,scat - 1+1) - adjspm(age - 50+1,scat - 1+1));
            spadjown = spadjownv(scat+1) - (spadjownm(retage - 50+1,scat - 1+1) - spadjownm(age - 50+1,scat - 1+1));
            spadjsp = spadjspv(scat+1) - (spadjspm(retage - 50+1,scat - 1+1) - spadjspm(age - 50+1,scat - 1+1));
        elseif age == retage;
            adjown   = adjownv(scat+1);
            adjsp    = adjspv(scat+1);
            spadjown = spadjownv(scat+1);
            spadjsp  = spadjspv(scat+1);
        end;
        
        if age <= 70;
            adjownm(age-50+1, scat+1) = adjown;
            adjspm(age-50+1, scat+1) = adjsp;
            spadjownm(age-50+1, scat+1) = spadjown;
            spadjspm(age-50+1, scat+1) = spadjsp;
        end
        
        if age >= sserage || spage >= sserage;
            if spage < 50;
                sppia = data.sppia(50-50+1, 1);
                spncpens = data.spncpens(50-50+1, 1);
            elseif spage >= 50 && spage < 70;
                sppia = data.sppia(spage-50+1, 1);
                spncpens = data.spncpens(spage-50+1, 1);
            elseif spage >= 70;
                sppia = data.sppia(70-50+1, 1);
                spncpens = data.spncpens(70-50+1, 1);
            end;
            if age >= sserage;
                ownben = adjown * pia;
            elseif age < sserage;
                ownben = 0;
            end;
            if spage >= sserage;
                spownben = spadjown * sppia;
            elseif spage < sserage;
                spownben = 0;
            end
            if age >= sserage && spage >= sserage
                benefitsp = max(adjsp * (0.5 * sppia - pia) - ncpens, 0);
                spbenefitsp = max(spadjsp * (0.5 * pia - sppia) - spncpens, 0);
            else
                benefitsp = 0;
                spbenefitsp = 0;
            end;
            
            adjfactor = 1.01^( year - 1992);
            if spage < spnrage || (spage < 70 && year < 2001);
                spearntest = 1;
                if spage < spnrage;
                    spearningstest = 7440 * adjfactor;
                    sprednrate = 0.5;
                else
                    spearningstest = 10200 * adjfactor;
                    sprednrate = 0.333333;
                end;
            else
                spearntest = 0;
            end;
            if 25 <= spage && spage < 70;
                spearnings = data.spwage(spage-25+1, 1);
            else
                spearnings = 0;
            end
            
            % both spouses survive (vcat = 1);
            pctlost = 0;
            if spearntest == 1;
                if spownben + benefitsp > 0;
                    sppctlost = sprednrate * (spearnings - spearningstest) / (spownben + benefitsp);
                    if sppctlost < 0;
                        sppctlost = 0;
                    elseif sppctlost > 1
                        sppctlost = 1;
                    end
                else
                    sppctlost = 1;
                end;
            else
                sppctlost = 0;
            end;
            if benefitsp > 0; % husband collecting spouse benefits;
                pctlostsp = sppctlost;
            else
                pctlostsp = 1;
            end
            if spbenefitsp > 0; % wife collecting spouse benefits;
                sppctlostsp = sppctlost;
            else
                sppctlostsp = 1;
            end;
            ssbenr(age - 50+1,0+1,scat+1) = (1 - pctlost) * ownben + (1 - pctlostsp) * benefitsp...
                + (1 - sppctlost) * spownben + (1 - sppctlostsp) * spbenefitsp;
            
            % husband only survives (vcat = 2);
            if age >= sserage;
                survben = max(ownben, sppia * max(0.825, spadjown));
            elseif age < sserage;
                survben = 0;
            end
            ssbenr(age-50+1, 1+1, scat+1) = survben;
            
            % wife only survives (vcat = 3)
            if spage >= sserage;
                spsurvben = max(spownben, pia * max(0.825, adjown));
                if spsurvben > 0;
                    if spearntest == 1;
                        spsurvpctlost = sprednrate * (spearnings - spearningstest) / spsurvben;
                        if spsurvpctlost < 0;
                            spsurvpctlost = 0;
                        elseif spsurvpctlost > 1;
                            spsurvpctlost = 1;
                        end;
                    else
                        spsurvpctlost = 0;
                    end;
                    ssben = (1 - spsurvpctlost) * spsurvben;
                else
                    ssben = 0;
                end;
            else
                ssben = 0;
            end;
            ssbenr(age - 50+1,2+1,scat+1) = ssben;
            
            % update adjustment factors;
            if age >= sserage && age < 70
                if age < nrage - 3;
                    pctchangesp = 0.05 * pctlostsp;
                elseif age < nrage;
                    pctchangesp = (0.25 / 3) * pctlostsp;
                elseif age >=nrage;
                    pctchangesp = 0;
                end;
            else
                pctchangesp = 0;
            end;
            if spage >= sserage && spage < 70
                if spage < spnrage - 3;
                    sppctchange = 0.05 * sppctlost;
                    sppctchangesp = 0.05 * sppctlostsp;
                elseif spage < spnrage
                    sppctchange = (0.2 / 3) * sppctlost;
                    sppctchangesp = (0.25 / 3) * sppctlostsp;
                elseif spage >= spnrage;
                    sppctchange = spdelayedret * sppctlost;
                    sppctchangesp = 0;
                end;
            else
                sppctchange = 0;
                sppctchangesp = 0;
            end;
            adjsp    = adjsp    + pctchangesp;
            spadjown = spadjown + sppctchange;
            spadjsp  = spadjsp  + sppctchangesp;
        end;
    end;
end;

% calculate benefits and adjustments if in secondary or partial retirement jobs;
for jcat = 1:1: 3-1
    for scat = 0:1: nscats-1
        switch(scat)
            case  0
                retage = 50;
            case  1
                retage = sserage;
            case  2
                retage = nrage;
            case  3
                retage = 70;
        end
        pia = data.pia(retage-50+1, 1);
        ncpens = data.ncpens(retage-50+1, 1);
        
        for age = 50:1:70-1
            year = age + birthyear;
            spage = year - spbirthyear;
            adjown   = adjownm(age - 50+1,scat+1);
            adjsp    = adjspm(age - 50+1,scat+1);
            spadjown = spadjownm(age - 50+1,scat+1);
            spadjsp  = spadjspm(age - 50+1,scat+1);
            if age >= sserage || spage >= sserage
                if spage < 50;
                    sppia = data.sppia(50-50+1, 1);
                    spncpens = data.spncpens(50-50+1, 1);
                elseif spage >=50 && spage < 70;
                    sppia = data.sppia(spage-50+1, 1);
                    spncpens = data.spncpens(spage-50+1, 1);
                elseif spage >= 70;
                    sppia = data.sppia(70-50+1, 1);
                    spncpens = data.spncpens(70-50+1, 1);
                end;
                if age >= sserage;
                    ownben = adjown * pia;
                elseif age < sserage;
                    ownben = 0;
                end;
                if spage >= sserage;
                    spownben = spadjown * sppia;
                elseif spage < sserage;
                    spownben = 0;
                end;
                if age >= sserage && spage >= sserage;
                    benefitsp = max(adjsp * (0.5 * sppia - pia) - ncpens, 0);
                    spbenefitsp = max(spadjsp * (0.5 * pia - sppia) - spncpens, 0);
                else
                    benefitsp = 0;
                    spbenefitsp = 0;
                end;
                adjfactor = 1.01^( year - 1992);
                
                if age < nrage || (age < 70 && year < 2001);
                    earntest = 1;
                    if age < nrage;
                        earningstest = 7440 * adjfactor;
                        rednrate = 0.5;
                    else
                        earningstest = 10200 * adjfactor;
                        rednrate = 0.333333;
                    end;
                else
                    earntest = 0;
                end;
                if spage < spnrage || (spage < 70 && year < 2001);
                    spearntest = 1;
                    if spage < spnrage;
                        spearningstest = 7440 * adjfactor;
                        sprednrate = 0.5;
                    else
                        spearningstest = 10200 * adjfactor;
                        sprednrate = 0.333333;
                    end
                else
                    spearntest = 0;
                end;
                if jcat == 1;
                    earnings = secwage(age - 50+1);
                else
                    earnings = prwage(age - 50+1);
                end;
                if spage >= 25 && spage < 70;
                    spearnings = data.spwage(spage-25+1, 1);
                else
                    spearnings = 0;
                end;
                
                % both spouses survive (vcat = 1);
                if earntest == 1
                    if ownben + spbenefitsp > 0;
                        pctlost = rednrate * (earnings - earningstest) / (ownben + spbenefitsp);
                        if pctlost < 0;
                            pctlost = 0;
                        elseif pctlost > 1;
                            pctlost = 1;
                        end;
                    else
                        pctlost = 1;
                    end;
                else
                    pctlost = 0;
                end;
                if spearntest == 1;
                    if spownben + benefitsp > 0;
                        sppctlost = sprednrate * (spearnings - spearningstest) / (spownben + benefitsp);
                        if sppctlost < 0;
                            sppctlost = 0;
                        elseif sppctlost > 1;
                            sppctlost = 1;
                        end;
                    else
                        sppctlost = 1;
                    end;
                else
                    sppctlost = 0;
                end;
                if benefitsp > 0; % husband collecting spouse benefits;
                    if sppctlost < pctlost; % additional loss of spouse benefits;
                        sppctlost = sppctlost - (pctlost - sppctlost) * benefitsp / spownben;
                        pctlostsp = pctlost;
                        if sppctlost < 0;
                            sppctlost = 0;
                        end;
                    else
                        pctlostsp = sppctlost;
                    end;
                else
                    pctlostsp = 1;
                end;
                
                if spbenefitsp > 0;  % wife collecting spouse benefits;
                    if pctlost < sppctlost % additional loss of spouse benefits;
                        pctlost = pctlost - (sppctlost - pctlost) * spbenefitsp / ownben;
                        sppctlostsp = sppctlost;
                        if pctlost < 0;
                            pctlost = 0;
                        end;
                    else
                        sppctlostsp = pctlost;
                    end
                else
                    sppctlostsp = 1;
                end;                
                ssben = (1 - pctlost) * ownben + (1 - pctlostsp) * benefitsp + ...
                    (1 - sppctlost) * spownben + (1 - sppctlostsp) * spbenefitsp;

                if jcat == 1;
                    ssbens(age - 50+1,0+1,scat+1) = ssben;
                else
                    ssbenp(age - 50+1,0+1,scat+1) = ssben;
                end
                
                % husband only survives (vcat = 2);
                if age >= sserage;
                    survben = max(ownben, sppia * max(0.825, spadjown));
                    if survben > 0;
                        if earntest == 1;
                            survpctlost = rednrate * (earnings - earningstest) / survben;
                            if survpctlost < 0;
                                survpctlost = 0;
                            elseif survpctlost > 1;
                                survpctlost = 1;
                            end;
                        else
                            survpctlost = 0;
                        end;
                    else
                        survpctlost = 1;
                    end;
                else
                    survpctlost = 0;
                end;
                ssben = (1 - survpctlost) * survben;
                if jcat == 1;
                    ssbens(age - 50+1,1+1,scat+1) = ssben;
                else
                    ssbenp(age - 50+1,1+1,scat+1) = ssben;
                end
                
                % calculate increase in future benefits if in secondary or partial retirement jobs;
                if age >= sserage;
                    if age >= sserage && age < 70;
                        if age < nrage - 3;
                            pctchange = 0.05 * pctlost;
                        elseif age < nrage;
                                pctchange = (0.2 / 3) * pctlost;
                        elseif age >= nrage;
                            pctchange = delayedret * pctlost;
                        end;
                    else
                        pctchange = 0;
                    end;
                    benchange = pctchange * ownben;
                    if jcat == 1;
                        benchanges(age - 62+1,0+1,scat+1) = benchange;
                    else
                        benchangep(age - 62+1,0+1,scat+1) = benchange;
                    end;
                    
                    if age >= sserage && age < 70;
                        if age < nrage - 3;
                            pctchange = 0.05 * survpctlost;
                        elseif age < nrage;
                            pctchange = (0.2 / 3) * survpctlost;
                        elseif age >= nrage;
                            pctchange = delayedret * survpctlost;
                        end
                    else
                        pctchange = 0;
                    end;
                    benchange = pctchange * ownben;
                    if jcat == 1;
                        benchanges(age - 62+1,1+1,scat+1) = benchange;
                    else
                        benchangep(age - 62+1,1+1,scat+1) = benchange;
                    end;
                end;
            end;
        end;
    end;
end;

% calculate initial scat values for each age of leaving main job;
for age = 50:70;
    if age < sserage;
        scat = 0;
        firstage = 50;
        lastage = sserage;
    elseif age < nrage;
        scat = 1;
        firstage = sserage;
        lastage = nrage;
    elseif age >= nrage;
        scat = 2;
        firstage = nrage;
        lastage = 70;
    end;
    if fbenefit(lastage-50+1, 1) - fbenefit(firstage-50+1, 1) > 0;
        initialscat(age-50+1, 1) = scat + (fbenefit(age-50+1, 1) - fbenefit(firstage-50+1, 1))/ (fbenefit(lastage-50+1, 1) - fbenefit(firstage-50+1, 1));
        if initialscat(age-50+1, 1) < scat;
            initialscat(age-50+1, 1) = scat;
        elseif initialscat(age-50+1, 1) > scat + 1
            if scat < 2;
                initialscat(age-50+1, 1) = scat + 1;
            elseif scat >= 2;
                initialscat(age-50+1, 1) = scat + 0.999;
            end;
        end;
    else
        initialscat(age-50+1, 1) = scat;
    end;
end;
calc.initialscat=initialscat;
ssbenf(0+1) = fbenefit(50-50+1, 1);
ssbenf(1+1) = fbenefit(sserage-50+1, 1);
ssbenf(2+1) = fbenefit(nrage-50+1, 1);
ssbenf(3+1) = fbenefit(70-50+1, 1);
calc.ssbenm=ssbenm;
calc.ssbenr=ssbenr;
calc.ssbens=ssbens;
calc.ssbenp=ssbenp;
calc.benchanges=benchanges;
calc.benchangep=benchangep;
calc.ssbenf=ssbenf;


