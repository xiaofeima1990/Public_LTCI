% %/*---------------------------------------------------------------------------
% 			 INPT routine
% 			 obtains the input
%   ---------------------------------------------------------------------------*/
%
function gv = inpt(gv)

% load GSRetirementData.dat;
origobs = size(GSRetirementData,1);
badobsvec = zeros(12,1);

% C++ readin data row by row;
for obs = 0:origobs;
    totobs = totobs + 1; % only appears in this function, it reports reasons of delete variables;
    
    % Create original observation structure;
    deletionreason = 0;
    if origdata(obs,1).goodobs.spouseFTyears == 0;
        deletionreason = 11;
    end
    if origdata(obs,1).goodobs.goodPens == 0;
        deletionreason = 10;
    end
    if origdata(obs,1).goodobs.goodAssets == 0;
        deletionreason =  9;
    end
    if origdata(obs,1).goodobs.goodSSearn == 0;
        deletionreason =  8;
    end
    if origdata(obs,1).goodobs.goodearnings == 0;
        deletionreason =  7;
    end
    if origdata(obs,1).goodobs.goodFTyears == 0;
        deletionreason =  6;
    end
    if origdata(obs,1).goodobs.goodSSstatus == 0;
        deletionreason =  5;
    end
    if origdata(obs,1).goodobs.goodCareer == 0;
        deletionreason =  4;
    end
    if origdata(obs,1).goodobs.spouseinterview == 0;
        deletionreason =  3;
    end
    if origdata(obs,1).marstat ~= 2;
        deletionreason =  2;
    end
    if origdata(obs,1).gender ~= 1;
        deletionreason =  1;
    end
    
    if deletionreason > 0;
        badobsvec(deletionreason,1) = badobsvec(deletionreason,1) + 1;
    end

    if deletionreason == 0
        data.origobs      = origdata(obs+1).origobs;
        data.caseid       = origdata(obs+1).caseid;
        data.birthyear    = origdata(obs+1).birthyear;
        data.spbirthyear  = origdata(obs+1).spbirthyear;
        data.gender       = origdata(obs+1).gender;
        data.spretage     = origdata(obs+1).spretage;
        data.healthage    = origdata(obs+1).healthage;
        data.penjobend    = origdata(obs+1).penjobend;
        data.totalwealth  = origdata(obs+1).wealth;
        data.assetwealth  = origdata(obs+1).assetwealth;
        data.sppensben    = origdata(obs+1).sppensben;
        data.sppenstart   = origdata(obs+1).sppenstart;
        data.spplumpsum   = origdata(obs+1).spplumpsum;
        %
        %       for (surv = 0; surv < 6; surv++)
        %       { data.age(surv)  = origdata(obs).age(surv);
        %         data.ret(surv)  = origdata(obs).ret(surv);
        %         }
        data.age=origdata(obs+1).age;
        data.ret=origdata(obs+1).ret;
        %       for (age = 25; age < 70; age++)
        %       { data.ftwage(age - 25)   = origdata(obs).ftwage(age - 25);
        %         data.spwage(age - 25)   = origdata(obs).spwage(age - 25);
        %         }
        data.ftwage  = origdata(obs+1).ftwage;
        data.spwage  = origdata(obs+1).spwage;
        %       for (age = 50; age < 70; age++)
        %       {
        data.retv  = origdata(obs).retv;
        data.prwage= origdata(obs).prwage;
        data.secwage = origdata(obs).secwage;
        %         }
        data.retv   = origdata(obs+1).retv;
        data.prwage  = origdata(obs+1).prwage;
        data.secwage = origdata(obs+1).secwage;
        
        %       for (age = 50; age <= 70; age++)
        %       {
        data.pensben   = origdata(obs+1).pensben;
        data.penstart  = int (origdata(obs+1).penstart);
        data.plumpsum  = origdata(obs+1).plumpsum;
        data.eowamount = origdata(obs+1).eowamount;
        data.pia       = origdata(obs+1).pia;
        data.ncpens    = origdata(obs+1).ncpens;
        data.sppia     = origdata(obs+1).sppia;
        data.spncpens  = origdata(obs+1).spncpens;
        
        %         }
        %
        %       for (age = 25; age < 100; age++)
        data.othincome = origdata(obs+1).othincome;
        %
        data.inputobs = obs;
        %
        nobs = nobs + 1;
        %
        datav(nobs+1) = data;
        if nobs > gv.maxobs;
            error('Too many observations');
        end
    end
end

% Print table of deletions;
fprintf('Reasons for Deletions of Observations');
fprintf('Obs         Obs');
fprintf('Dropped     Left');


for deletionreason = 1:1:12
    if (deletionreason == 0 || badobsvec(deletionreason,1) > 0)
        if deletionreason == 0;
                fprintf('\nTotal sample individuals                    ');
        elseif deletionreason == 1;
                fprintf('\nNot specified gender                        ');
        elseif deletionreason == 2;
                fprintf('\nNot specified marital status                ');
        elseif deletionreason == 3;
                fprintf('\nSpouse not interviewed if married           ');
        elseif deletionreason == 4;
                fprintf('\nNot a career worker                         ');
        elseif deletionreason == 5;
                fprintf('\nAmbiguity about whether jobs are ss covered ');
        elseif deletionreason == 6;
                fprintf('\nFT years unavailable in wave 3 or ss record ');
        elseif deletionreason == 7;
                fprintf('\nNo FT earnings in ss record or self report  ');
        elseif deletionreason == 8;
                fprintf('\nNo sr earnings, and ss earnings over limit  ');
        elseif deletionreason == 9;
                fprintf('\nRelatively large business assets            ');
        elseif deletionreason == 10;
                fprintf('\nNo Pension Provider record in last job      ');
        elseif deletionreason == 11;
                fprintf('\nFT years unavailable for spouse             ');
        end;
        if deletionreason == 0;
            fprintf(totobs);
        else
            totobs = totobs - badobsvec(deletionreason+1);
            fprintf(badobsvec(deletionreason,1), totobs);
        end;
    end;
end;
    
    % process observations;
    for obs = 0:1:nobs-1;
        data = datav(obs+1);
        % 指针传递
        if (data.totalwealth < 0);
            data.totalwealth = 0;
        end;
        %
        if (data.assetwealth < 0);
            data.assetwealth = 0;
        end;
        
        % calculate lifetime wealth category;
        wealth = 0;
        %
        %     for (age = 25; age < 62; age++)
        wealth = wealth + data.ftwage + data.spwage...
            + data.othincome;
        % 加总
        wealth = wealth + data.plumpsum + data.spplumpsum;
        %  plum sum
        if wealth < 1250000;
            data.inccat = 1;
        elseif wealth < 1900000;
            data.inccat = 2;
        else
            data.inccat = 3;
        end
    end
    % Inccat是对个人收入的一个划分
    if (tabs == 1)
        %   { %/* sample tabulations of retirement status */
        % 退休状态表格
        %     memset(ret1, 0, sizeof(double(20)));
        %     memset(ret2, 0, sizeof(double(20)));
        %     memset(ret3, 0, sizeof(double(20)));
        ret1(1:20,1)=double(0);ret2(1:20,1)=double(0);ret3(1:20,1)=0;
        % 3种退休状态分类
        for obs = 0:1:nobs-1
            
            %     {
            ret = datav(obs+1).retv(age - 50);
            %
            if (ret == 5)
                ret1 = ret1+ 1;
            else if (ret == 3)
                    ret2 = ret2 + 1;
                else if (ret == 1)
                        ret3 = ret3 + 1;
                    end
                end
            end
            
        end
        %       }
        %
        fprintf('\n\n      Observed Retirement Percentages\n');
        %
        %     for age = 50 :1:70-1
        %     {
        tot = ret1 + ret2 + ret3;
        %
        ret1 = 100 .* ret1 ./ tot;
        ret2 = 100 .* ret2 ./ tot;
        ret3 = 100 .* ret3 ./ tot;
        %
        cret1 = 100 - ret1;
        cret2 = ret3;
        %
              if (age == 50)
                  ret1(1) = cret1(1);
                  ret2(1) = cret2(1);
              else
                  ret1(2:end) = cret1(2:end) - cret1(1:end-1);
                  ret2(2:end) = cret2(2:end) - cret2(1:end-1);
        fprintf('\n %2d  %5.1f %5.1f   %5.1f %5.1f   %4.0f', age,...
            ret1, ret2, cret1, cret2, tot);
        fprintf('\nTotal number of observed respondents: %d', nobs);
    end
end
