% ---------------------------------------------------------------------------
% 			 INDIV MODEL
%           calculates the moments of individual observations
%   ---------------------------------------------------------------------------

function [gv] = indivmodel(gv)

    for obs=1:gv.nobs;
%         newalpha = gv.arglist.newalpha;
%         mode = gv.arglist.mode;
%         rvec = gv.arglist.rvec(obs,1);
        data = gv.data(obs,1); % retrive household's information;
        calc = gv.calc; % Initialize structure variable calc;
        
        calc.mode = gv.arglist.mode;
        calc.obs = obs;
        
        calc.sige = gv.parm.sige * gv.parm.beta1;
        calc.erho = gv.parm.erho;
        calc.gamma0 = gv.parm.gamma0;
        calc.gamma1 = gv.parm.gamma1;
        calc.beta0 = gv.parm.beta0 + 10 * (gv.parm.alpha + 1);   %/* to enhance stability */;
        calc.beta1 = gv.parm.beta1;
        calc.beta2 = gv.parm.beta2 * gv.parm.beta1;
        calc.alpha = gv.parm.alpha;
        
        if calc.mode == 0;
            firstage = 50; % Age entering survey;
            lastage  = 69; % Age leaving survey;
        elseif calc.mode == 1 || calc.mode == 2;
            firstage = 99;
            lastage = 0;
            for survey = 1:6; % 6 waves of surveys, 92, 94, 96, 98, 00, 02;
                age = data.age(survey,1);
                ret = data.ret(survey,1);
                % survey age;
                if (age >= 54 && age <= 66 && ret >=1 && ret <= 5)
                    if age < firstage;
                        firstage = age;
                    end;
                    if age > lastage;
                        lastage = age;
                    end;
                end;
            end;
            % assign firstage and lastage based on survey data;
            if firstage > lastage;
                firstage = firstage - 1;
                if lastage < 60;
                    lastage = lastage + 2;
                else
                    lastage = lastage + 3;
                end;
            end;
        end;

        if firstage <= lastage;
            calc.firstage = firstage;
            calc.lastage = lastage;
            
            [gv calc] = calcprep(gv,calc,data);
%             gv.arglist.rvec(obs,1) = rhocalc(gv,calc);
            gv.arglist.rvec(obs,1) = 0.1237;
            % caluclates rho consistent with initial wealth and retirement
            if gv.arglist.newalpha == 1;
                rvec = rhocalc(gv,calc);
                gv.arglist.rvec(obs,1)=rvec;
            end;

            for tcat = 0:gv.ntcatlim-1;
                calc = calcModel(gv,calc,tcat);
                calc = getMoments(gv,calc,tcat);
            end;
        end;
%         gv.calc(threadno - localthreadmin+1)=calc;
%         gv.data(obs,1)=data;
    end;

























