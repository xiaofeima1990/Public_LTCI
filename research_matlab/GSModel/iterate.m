% /*---------------------------------------------------------------------------
% 			 ITERATE
% 			 performs one evaluation of the objective function
%   ---------------------------------------------------------------------------*/
%
function iterate=iterate(nobs)
%   int    nobs)             /* number of observations */
%
% {
global parm
global nmoments
global nparms
global  nthreads
global arglist
global err
global threadstate
k=int32(0);
threadno=int32(0); age=int32(0);

q=0;
everreturnft=0; everreturnpt=0; everreturn=0;

ret1mat=zeros(21,1); ret2mat=zeros(21,1);

mvec(1:nmoments,1)=0;
winv(1:nmoments * (nmoments + 1) / 2,1)=0;



% 变量声明
arglist.mode = 1;
% 运行模式为1迭代
cparm = parm;
% PARM数据结构的指针

% for (k = 0; k < nparms; k++)
%   {
if (mod(k,10) == 0)
    fprintf('\n    ');
end
fprintf('%6.3f',cparm.sige);
fprintf('%6.3f',cparm.erho);
fprintf('%6.3f',cparm.beta0 );
fprintf('%6.3f',cparm.beta1);
fprintf('%6.3f',cparm.gamma0);
fprintf('%6.3f',cparm.gamma1);
fprintf('%6.3f',cparm.alpha );
%     }

q = f(mvec, winv, nobs, 1);
% 调用函数F evaluate q stastic for the moment
% 在f函数中已经差不多设置了arglist结构数组了
%   /* calculate results */
%
for age = 50:1:70-1
    %   {
    ret1mat(age - 50+1)  = 0;
    ret2mat(age - 50+1)  = 0;
    %
    for threadno = 0:1:nthreads-1
        %     {
        ret1mat(age - 50+1)  = ret1mat(age - 50+1) + arglist.ret1mat(threadno+1,age - 50+1);
        ret2mat(age - 50+1)  = ret2mat(age - 50+1) + arglist.ret2mat(threadno+1,age - 50+1);
        %       }
    end
    ret1mat(age - 50+1)  = 100 * ret1mat(age - 50+1) / nobs;
    ret2mat(age - 50+1)  = 100 * ret2mat(age - 50+1) / nobs;
    %     }
end
everreturnft = 0;
everreturnpt = 0;
everreturn   = 0;

for threadno = 0:1: nthreads-1
    %   {
    everreturnft = everreturnft + arglist.everreturnft(threadno+1);
    everreturnpt = everreturnpt + arglist.everreturnpt(threadno+1);
    everreturn   = everreturn + arglist.everreturn(threadno+1);
    %     }
end
everreturnft = 100 * everreturnft / nobs;
everreturnpt = 100 * everreturnpt / nobs;
everreturn   = 100 * everreturn / nobs;
% 上面都是相关的变量：退休不同类别的  退休后返回工作的不同类别的计算，差不多是计算平均值
%   /* print tabulations */
%
fprintf('\n\n                Percent                   Percent');
fprintf(  '\n            Pseudo-Retiring               Retired');
fprintf(  '\n           From                       From');
fprintf(  '\nAge       FT Work  Completely        FT Work  Completely');
fprintf(  '\n');

fprintf('\n 50                                  %5.1f     %5.1f', ret1mat(50 - 50+1), ret2mat(50 - 50+1));

for age = 51:1: 70-1
    fprintf('\n %2d       %5.1f    %5.1f             %5.1f     %5.1f', age,...
        ret1mat(age - 50+1) - ret1mat((age - 1) - 50+1), ret2mat(age - 50+1) - ret2mat((age - 1) - 50+1),...
        ret1mat(age - 50+1), ret2mat(age - 50+1));
end
fprintf('\n\nPercent returning to full time work after full or partial retirement: %5.1f', everreturnft);
fprintf('\nPercent returning to part time work after full retirement: %5.1f', everreturnpt);
fprintf('\nPercent returning to full time work after full or partial retirement');
fprintf('\n  or returning to part time work after full retirement: %5.1f', everreturn);
%
iterate=q;
%
%   }
%
