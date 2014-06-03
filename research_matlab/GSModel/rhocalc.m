% %/*---------------------------------------------------------------------------
% 			 RHO CALC
% 			 caluclates rho consistent with initial wealth and retirement
%   ---------------------------------------------------------------------------*/
%
function [rho] = rhocalc(gv, calc)

data = gv.data(calc.obs,1);
alpha = calc.alpha;

% calculate approximate retirement dates;
lastftage = 0;
firstprage = 99;
lastprage = 0;
firstretage = 99;
for age = 50:1:70-1
    if data.retv(age - 50+1,1) == 5;       %/* working full time */
        if firstprage == 99 && firstretage == 99;
            lastftage = age;
        end
        firstretage = 99;
    elseif data.retv(age - 50+1,1) == 3;  %/* partially retired */
        if firstprage == 99;
            firstprage = age;
        end
        lastprage = age;
        firstretage = 99;
    elseif data.retv(age - 50+1,1) == 1;  %/* completely retired */
        if firstretage == 99;
            firstretage = age;
        end;
    end;
end;

if lastftage > 0;       % working during survey;
    if firstprage < 99;       % partial retirement observed;
        retage = floor(((lastftage + 1) + firstprage) / 2);
    elseif firstprage == 99;
        if firstretage < 99;    % complete retirement observed;
            retage = floor(((lastftage + 1) + firstretage) / 2);
        elseif firstretage == 99;
            retage = lastftage + 1;
        end;
    end;
elseif lastftage == 0;
    if firstprage < 99;       %/* partial retirement observed */
        retage = firstprage;
    elseif firstprage == 99;
        if firstretage < 99; %/* complete retirement observed */
            retage = firstretage;
        elseif firstretage == 99;
            retage = 62;
        end;
    end;
end;

if retage < 50;
    retage = 50;
elseif retage > 70;
    retage = 70;
end;

%  if low assets, assign rho a high value;
wagevec=zeros(5,1);
for age = max(25, retage - 10):retage-1;
    earnings = data.ftwage(age - 25+1, 1);
    for row = 5:-1: 1;
        if earnings > wagevec(row,1);
            earntemp = wagevec(row,1);
            wagevec(row,1) = earnings;
            earnings = earntemp;
        end
    end
end
if data.assetwealth <= 0.25 * wagevec(3,1) ... % asset less than 25% of income of the third highest year;
        && data.plumpsum(retage - 50+1,1) < wagevec(3,1) % total pension wealath less than income of the third highest year;
    rho=3.0;
else
    % The following part could be easily replaced by fminsearch.???
    calc=incomecalc(retage, calc, data);
    % calculates conditional income for the three survival outcomes
    rho2 = 0.2;
    calc = conscalc(rho2, alpha, gv, calc);

    % calculates conditional consumption streams
    wealthdiff2 = wealthcalc(calc, data);

    % calculates differences between calculated and observed wealth
    if wealthdiff2 >= 0; % This means rho is between 0 and 0.2;
        rho1 = 0;
        wealthdiff1 = -1;    % actual wealth - simulated wealth in 1992;
    elseif wealthdiff2 < 0;
        for iter = 1:3;
            if wealthdiff2 < 0;
                rho1 = rho2;
                wealthdiff1 = wealthdiff2;
                rho2 = 2 * rho1;
                calc = conscalc(rho2, alpha, gv, calc);
                wealthdiff2 = wealthcalc(calc, data);
            end;
        end;
    end;
    if rho1 == 0 || wealthdiff2 >= 0;
        for iter = 1:20;
            rho = (rho1 + rho2) / 2;
            calc = conscalc(rho, alpha, gv, calc);
            wealthdiff = wealthcalc(calc, data);
            if wealthdiff >= 0;
                rho2 = rho;
                wealthdiff2 = wealthdiff;
            else
                rho1 = rho;
                wealthdiff1 = wealthdiff;
            end;
        end;
        rho = (rho1 * wealthdiff2 - rho2 * wealthdiff1) / (wealthdiff2 - wealthdiff1);
    else
        rho = rho2;
    end;
end;
