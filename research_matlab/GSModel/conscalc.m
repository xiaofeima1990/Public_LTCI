% /*---------------------------------------------------------------------------
% 			 CONS CALC routine
% 			 calculates conditional consumption streams
%   ---------------------------------------------------------------------------*/
%
function [calc] = conscalc(rho, alpha, gv, calc)

tp = 1 + rho;
consadj = 2^(0.5 * (1 - alpha));
load calcsurv;

% calculate marginal utilities for age 99;
margu(1,:)=(calc.acats(:,1)+calc.income(1,gv.T-25+1)).^(alpha-1)*consadj;
margu(2,:)=(calc.acats(:,1)+calc.income(2,gv.T-25+1)).^(alpha-1);
margu(3,:)=(calc.acats(:,1)+calc.income(3,gv.T-25+1)).^(alpha-1);

for age = gv.T-1:-1:gv.t0;
    for vcat = 1:3;
        murv = zeros(3,calc.nacats);
        mur = zeros(3,calc.nacats);
        for rcat = 1:calc.nrcats; % The interpolation has some issues with the upper bound; Leave it for now;
            murv(1,:) = interp1((0:calc.nacats-1),margu(1,:),calc.rtransa(:,rcat),'linear','extrap'); 
            murv(2,:) = interp1((0:calc.nacats-1),margu(2,:),calc.rtransa(:,rcat),'linear','extrap');
            murv(3,:) = interp1((0:calc.nacats-1),margu(3,:),calc.rtransa(:,rcat),'linear','extrap');
            mur(1,:) = mur(1,:) + calc.rprob(rcat,1)*murv(1,:);
            if vcat == 1; % ??? why do this???
                mur(2,:) = mur(2,:) + calc.rprob(rcat,1)*murv(2,:);
                mur(3,:) = mur(3,:) + calc.rprob(rcat,1)*murv(3,:);
            elseif vcat == 2 || vcat == 3;
                mur(2,:) = mur(2,:) + calc.rprob(rcat,1)*murv(1,:);
                mur(3,:) = mur(3,:) + calc.rprob(rcat,1)*murv(1,:);                
            end;
        end;
        if vcat == 1;
            mu = 1/tp*(calc.transrate(1, age-25+1)*mur(1,:) + calc.transrate(2, age-25+1)*mur(2,:) + calc.transrate(3, age-25+1)*mur(3,:));
            cv = 2^0.5 * mu.^ (1 / (alpha - 1));
        elseif vcat == 2;
            mu = 1/tp*calc.srate(1, age-25+1)*mur(2,:);
            cv = mu.^ (1 / (alpha - 1));
        elseif vcat ==  3;
            mu = 1/tp*calc.srate(2, age-25+1)*mur(3,:);
            cv = mu.^ (1 / (alpha - 1));
        end;
        y = calc.income(vcat, age-25+1);
        yac = y - calc.acats - cv';
        k = max(0,interp1(yac,(0:calc.nacats-1),-calc.acats,'linear','extrap'));
        atplus1 = interp1((0:calc.nacats-1),calc.acats,k,'linear','extrap');
        c = y + calc.acats - atplus1;
        calc.cons(age-25+1,vcat,:) = c;
        if vcat == 1; % married
            mu = consadj * c.^ (alpha - 1);
        elseif vcat > 1;
            mu = c.^ (alpha - 1);
        end;
        margu(vcat,:)=mu;
    end;
end;

