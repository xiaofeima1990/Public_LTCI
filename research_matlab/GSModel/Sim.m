
function Sim( nobs)                  % int nobs /* number of observations */
%  /*---------------------------------------------------------------------------
% 			 SIM
% 			 simulates the model with the estimated parameters
%   ---------------------------------------------------------------------------*/
%
% {

i=int32(0); j=int32(0);
age=int32(0); cat=int32(0);
threadindex=int32(0); threadno=int32(0); threadcheck=int32(0);
obs=int32(0);
everreturnft=0; everreturnpt=0; everreturn=0;
%
rhocats(1:21,1)=int32(0);
ret0mat=zeros(21,1); ret1mat=zeros(21,1); ret2mat=zeros(21,1);
returnft=zeros(21,1); returnpt=zeros(21,1); newpt=zeros(21,1);
%
%全局变量的声明
global threadstate
global threadobs
global arglist
global nthreads
global localthreadmin
global localthreadmax
arglist.mode     = 3;
arglist.newalpha = 1;
%

arglist.ret0mat=zeros(nthreads,21);
arglist.ret1mat=zeros(nthreads,21);
arglist.ret2mat=zeros(nthreads,21);
arglist.returnft=zeros(nthreads,21);
arglist.returnpt=zeros(nthreads,21);
arglist.newpt=zeros(nthreads,21);
arglist.everreturnft=zeros(nthreads,1);
arglist.everreturnpt=zeros(nthreads,1);
arglist.everreturn=zeros(nthreads,1);
%
%   /* call threads to fill mvec, dmat and smat matrices */
%
fprintf('\n');
%
for obs = 0:1: nobs-1
    %   {
    threadno = -1;
    %
    %      while (threadno < 0)
    % %     { checkMessages();
    % %
    %        for threadindex = 0: nthreads-1
    %         if (threadno < 0)
    %          if (threadstate(threadindex+1) == 0)
    %           threadno = threadindex;
    %          end
    %         end
    %        end
    %      end
    for threadindex = 0: nthreads-1
        if (threadno < 0)
            if (threadstate(threadindex+1) == 0)
                threadno = threadindex;
            end
        end
        
        if (localthreadmin == 0)
            if(threadno <= localthreadmax)
                threadstate(threadno+1)=1;
                
                indivmodel(0);
            end
        end
    end
    % %       }
    % %
    % save('Simfresult');
    % dos('shutdown -s -t 30');
    % load Simfresult
    threadno=0;
    threadobs(threadno+1) = obs;
    threadstate(threadno+1) = 1;
    %
    fprintf('\r%5d  ', obs);
    %
    for threadindex = 0: 1:nthreads-1
        if (threadindex <= 1 || (22 <= threadindex && threadindex <= 25) || threadindex >= 38)
            fprintf('%5d', threadobs(threadindex+1));
        end
    end
end
%     }
%
threadcheck = 0;


%检查线程状态有没有问题的，感觉用处不大————————————
%    while(threadcheck == 0)
% %   {      checkMessages();
% %
%       threadcheck = 1;
% %
%      for threadno = 0 :1:nthreads-1
%        if (threadstate(threadno+1))
%         threadcheck = 0;
%        end
%      end
%    end
%     }
%
%
%   /* consolidate results */
%
for age = 50:1:70-1
    %   {
    ret0mat(age - 50+1)  = 0;
    ret1mat(age - 50+1)  = 0;
    ret2mat(age - 50+1)  = 0;
    returnft(age - 50+1) = 0;
    returnpt(age - 50+1) = 0;
    newpt(age - 50+1)    = 0;
    %
    for threadno = 0:1:nthreads-1
        % {
        ret0mat(age - 50+1)  = ret0mat(age - 50+1) + arglist.ret0mat(threadno+1,age - 50+1);
        ret1mat(age - 50+1)  = ret1mat(age - 50+1) + arglist.ret1mat(threadno+1,age - 50+1);
        ret2mat(age - 50+1)  = ret2mat(age - 50+1) + arglist.ret2mat(threadno+1,age - 50+1);
        returnft(age - 50+1) = returnft(age - 50+1) + arglist.returnft(threadno+1,age - 50+1);
        returnpt(age - 50+1) = returnpt(age - 50+1) + arglist.returnpt(threadno+1,age - 50+1);
        newpt(age - 50+1)    = newpt(age - 50+1) + arglist.newpt(threadno+1,age - 50+1);
    end
    %      }
    
    ret0mat(age - 50+1)  = 100 * ret0mat(age - 50+1) / nobs;
    ret1mat(age - 50+1)  = 100 * ret1mat(age - 50+1) / nobs;
    ret2mat(age - 50+1)  = 100 * ret2mat(age - 50+1) / nobs;
    returnft(age - 50+1) = 100 * returnft(age - 50+1) / nobs;
    returnpt(age - 50+1) = 100 * returnpt(age - 50+1) / nobs;
    newpt(age - 50+1)    = 100 * newpt(age - 50+1) / nobs;
end
%     }
%
everreturnft = 0;
everreturnpt = 0;
everreturn   = 0;
%
for threadno = 0:1:nthreads-1
    % {
    everreturnft = everreturnft + arglist.everreturnft(threadno+1);
    everreturnpt = everreturnpt + arglist.everreturnpt(threadno+1);
    everreturn   = everreturn + arglist.everreturn(threadno+1);
end
%  }
%
everreturnft = 100 * everreturnft / nobs;
everreturnpt = 100 * everreturnpt / nobs;
everreturn   = 100 * everreturn / nobs;
%
%   /* calculate and print tabulations */
%
fprintf('\n\n                Percent                   Percent');
fprintf(  '\n            Pseudo-Retiring               Retired');
fprintf(  '\n           From                       From');
fprintf(  '\nAge       FT Work  Completely        FT Work  Completely');
fprintf(  '\n');
%
fprintf('\n 50                                  %5.1f     %5.1f',...
    ret1mat(50 - 50+1), ret2mat(50 - 50+1));
%
for age = 51:1:70-1
    fprintf('\n %2d       %5.1f    %5.1f             %5.1f     %5.1f', age,...
        ret1mat(age - 50+1) - ret1mat((age - 1) - 50+1), ret2mat(age - 50+1) - ret2mat((age - 1) - 50+1),...
        ret1mat(age - 50+1), ret2mat(age - 50+1));
end
%
%
fprintf('\n\n\n                       Percent    Percent                          Percent Newly');
fprintf(    '\n                         in        Newly                   Percent   Returned');
fprintf(    '\n        Percent        FT Work    Returned       Percent    Newly   to PT Work');
fprintf(    '\nAge     in Main         after       to             in        in     Previously');
fprintf(    '\n          Job          Retiring   FT Work        PT Work   PT Work   Retired');
fprintf(    '\n');

fprintf('\n 50      %5.1f                                   %5.1f',...
    100 - ret0mat(50 - 50+1), ret1mat(50 - 50+1) - ret2mat(50 - 50+1));

for age = 51:1:70-1
    fprintf('\n %2d      %5.1f          %5.1f     %5.1f          %5.1f     %5.1f     %5.1f', age,...
        100 - ret0mat(age - 50+1), ret0mat(age - 50+1) - ret1mat(age - 50+1), returnft(age - 50+1),...
        ret1mat(age - 50+1) - ret2mat(age - 50+1), newpt(age - 50+1), returnpt(age - 50+1));
end

fprintf('\n\nPercent returning to full time work after full or partial retirement: %5.1f', everreturnft);
fprintf('\nPercent returning to part time work after full retirement: %5.1f', everreturnpt);
fprintf('\nPercent returning to full time work after full or partial retirement');
fprintf('\n  or returning to part time work after full retirement: %5.1f', everreturn);

%   /* distribution of time preferences */
%
fprintf('\n\nDistribution of time preference rates\n');
%
%   memset(rhocats, 0, sizeof(int(21)));
rhocats(1:21,1)=int32(0);
%
for obs = 0:1:nobs-1
    %   {
    if (arglist.rvec(obs+1) < 0)
        rhocats(0+1) = rhocats(0+1) + 1;
    else if (arglist.rvec(obs+1) > 1)
            rhocats(20+1) = rhocats(20+1) + 1;
        else
            %     {
            cat = floor(20 * arglist.rvec(obs+1));
            rhocats(cat+1) = rhocats(cat+1) + 1;
        end
    end
end

%       }
%     }
%
for i = 0:1: 5-1
    %   {
    fprintf('\n');
    for j = 0 : 1 : 5-1
        if (j < 4 || i == 0)
            fprintf('   %5.2f %5d', (0.05 * (5 * j + i)), rhocats(5 * j + i+1));
        end
    end
end

%     }
%
%   }
