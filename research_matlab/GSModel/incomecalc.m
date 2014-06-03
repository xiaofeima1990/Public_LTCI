% %/*---------------------------------------------------------------------------
% 			 INCOME CALC routine
% 			 calculates conditional income for the three survival outcomes
%   ---------------------------------------------------------------------------*/
%
function [calc] = incomecalc(retage, calc, data)

i1=2;j1=0;k1=0;
i2=0;j2=0;k2=0;

% Setup income vector if both survive;
birthyear   = data.birthyear;
spbirthyear = data.spbirthyear;
ftwage      = data.ftwage;      % full-time wages at ages 25-69
spwage      = data.spwage;      % wages of spouse at spouse ages 25-69
pensben     = data.pensben;     % annual pension benefit for retirement at 50-70
penstart    = data.penstart;    % starting age of pension for retirement at 50-70
plumpsum    = data.plumpsum;    % lump-sum pension benefit for retirement at 50-70
othincome   = data.othincome;   % inheritances for ages 25-99

sserage = calc.sserage;
nrage   = calc.nrage;
nragew  = calc.spnrage;
nscats = calc.nscats;
initialscat = calc.initialscat;
ssbenm = calc.ssbenm;
ssbenr = calc.ssbenr;
income = calc.income;
inflrate = calc.inflrate;
penadjrate = calc.penadjrate;


for age = 25:min(retage,70)-1;
    income(1,age - 25+1) = ftwage(age - 25+1,1);
    income(2,age - 25+1) = ftwage(age - 25+1,1);
end
if spbirthyear > 0;
    for age = 25:1:100-1
        spage = age + birthyear - spbirthyear;
        if spage >= 25 && spage < 70;
            income(1,age - 25+1) = income(1,age - 25+1) + spwage(spage - 25+1,1);
            income(3,age - 25+1) = spwage(spage - 25+1,1);
        end
    end
end
p = (1 - penadjrate) * inflrate;
pben = pensben(retage - 50+1,1);
for age = penstart(retage - 50+1,1):100-1;
    income(1,age - 25+1) = income(1,age - 25+1) + pben;
    income(2,age - 25+1) = income(2,age - 25+1) + pben;
    pben = pben / (1 + p);
end
income(1,retage - 25+1) = income(1,retage - 25+1) + plumpsum(retage - 50+1,1);
income(2,retage - 25+1) = income(2,retage - 25+1) + plumpsum(retage - 50+1,1);

if data.sppenstart < 99;
    sppensben = data.sppensben;
    for spage = data.sppenstart:100-1;
        age = spage + spbirthyear - birthyear;
        if age > 25 && age < 100;
            income(1,age - 25+1) = income(1,age - 25+1) + sppensben;
            income(3,age - 25+1) = income(3,age - 25+1) + sppensben;
        end
        pben = pben / (1 + p);
    end
    age = data.sppenstart + spbirthyear - birthyear;
    if 25 <= age && age < 100;
        income(1,age - 25+1) = income(1,age - 25+1) + data.spplumpsum;
        income(3,age - 25+1) = income(3,age - 25+1) + data.spplumpsum;
    end
end
scat = floor(initialscat(retage - 50+1));

if scat >= nscats - 1;
    scat = nscats - 2;
end
fs = initialscat(retage - 50+1,1) - scat;

for age = 25:100-1;
    for vcat = 1:3;
        if (vcat < 3 && age < retage)
            ssbenefit = ssbenm(age - 25+1,vcat);
        else
            
            if (age>=25 && age<=35 && vcat==3)
                
                i1=i1+fix((j1+3)/2);
                if (mod(j1,2)==1)
                    j1=0;
                else
                    j1=1;
                end
                ssbenefit = (1 - fs) * calc.ssbens(i1+1,j1+1,k1+1    )+...
                    fs * calc.ssbens(i1+1,j1+1,k1 + 1+1);
            end
            
            if age>36 && age< 50 && vcat==3;
                
                i2=i2+fix((j2+3)/2);
                if (mod(j2,2)==1)
                    j2=0;
                else
                    j2=1;
                end
                ssbenefit = (1 - fs) * calc.ssbenp(i2+1,j2+1,k2+1    )+...
                    fs * calc.ssbenp(i2+1,j2+1,k2 + 1+1);
            end
            if age>=50;
                ssbenefit = (1 - fs) * ssbenr(age - 50+1,vcat,scat+1)+...
                    fs * ssbenr(age - 50+1,vcat,scat + 1+1);
            end;
        end;
        income(vcat,age - 25+1) = income(vcat,age - 25+1) +  ssbenefit;
    end;
end;

for vcat = 1:3;
    for age = 25:100-1;
        income(vcat,age - 25+1) = income(vcat,age - 25+1) + othincome(age - 25+1,1);
    end
end

income=max(income,10);
calc.income=income;


