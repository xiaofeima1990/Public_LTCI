% /*---------------------------------------------------------------------------
% 			 QMIN
% 			 minimizes the q criterion for GMM estimates
% 算是求Q检验的标准值
%   ---------------------------------------------------------------------------*/
function qmin(nobs)
%   int    nobs)                     /* number of observations */
%
% {
i=int32(0); k=int32(0); l=int32(0); m=int32(0);
iter=int32(0); sameparms=int32(0);
intindex=int32(0);
incr=0; newincr=0;
v=0; v0=0; v1=0; v2=0;
q=0; q0=0; q1=0; q2=0;
dq0=0; dq1=0; dv0=0; dv1=0; dv02=0; dv12=0;
se=0; t=0;
%
global nparms
global nmoments
global parm
%   double lparm(nparms);
lparm(1:nparms,1)=0;
%   double *cparm;

%
persistent var
if isempty(var)
    var(1:nparms * (nparms + 1) / 2,1)=0;
end
persistent mvec
if isempty(mvec)
    mvec(1:nmoments,1)=0;
end
persistent mvec0
if isempty(mvec0)
    mvec0(1:nmoments,1)=0;
end
persistent mvec1
if isempty(mvec1)
    mvec1(1:nmoments,1)=0;
end
persistent mvec2
if isempty(mvec2)
    mvec2(1:nmoments,1)=0;
end
persistent winv
if isempty(winv)
    winv(1:nmoments * (nmoments + 1) / 2,1)=0;
end
persistent dmat
if isempty(dmat)
    dmat(1:nmoments * nparms,1)=0;
end
%   static double intervals(4)(8) = {
%     { 0.25,  0.05, 0.250, 0.025,  0.25,  0.25,  0.10,  0.05 },
%     { 0.25,  0.05, 0.025, 0.025,  0.25,  0.25,  0.10,  0.05 },
%     { 0.05,  0.02, 0.005, 0.005,  0.05,  0.05,  0.03,  0.02 },
%     { 0.01,  0.01, 0.001, 0.001,  0.01,  0.01,  0.01,  0.01 }};
persistent intervals
if isempty(intervals)
    intervals=[0.25, 0.05, 0.250, 0.025,  0.25,  0.25,  0.10,  0.05;...
        0.25,  0.05, 0.025, 0.025,  0.25,  0.25,  0.10,  0.05;...
        0.05,  0.02, 0.005, 0.005,  0.05,  0.05,  0.03,  0.02;...
        0.01,  0.01, 0.001, 0.001,  0.01,  0.01,  0.01,  0.01];
end

arglist.mode = 2;
%
cparm = parm;
%
for intindex = 0:(4-1)
    %   {
    sameparms = 0;
    %
    for iter = 0:(10-1)
        if (sameparms == 0)
            %     {
            %         for k = 0:nparms-1
            lparm(1) =cparm.sige;
            lparm(2) =cparm.erho;
            lparm(3)= cparm.beta0 ;
            lparm(4)= cparm.beta1;
            lparm(5)= cparm.beta2;
            lparm(6)= cparm.gamma0;
            lparm(7)= cparm.gamma1;
            lparm(8)= cparm.alpha ;
            
            %——————————对cparm的变换，把struct编程数组
            cparm=zeros(8,1);
            cparm(1:8)=lparm(1:8);
            %——————————
            
            
            %         end
            q1 = f(mvec1, winv, nobs, 1);
            
            fprintf('\n     %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f  %9.3f',...
                cparm(0+1), cparm(1+1), cparm(2+1), cparm(3+1), cparm(4+1), cparm(5+1), cparm(6+1), cparm(7+1), q1);
            %
            for k = 0:nparms-1
                %       {
                switch(k)
                    %         {
                    case  0
                        m =2;
                    case  1
                        m =3;
                    case  2
                        m = 7;
                    case  3
                        m=  0;
                    case  4
                        m=  4;
                    case  5
                        m=  1;
                    case  6
                        m=  5;
                    case  7
                        m=  6;
                        %           }
                end
                
                %
                v1 = cparm(m+1);
                %
                incr = intervals(intindex+1,m+1);
                %
                v0 = v1 - incr;
                cparm(m+1) = v0;
% % % % %                 parm
                %
                q0 = f(mvec0, winv, nobs, 0);
                %         fprintf('\n     %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f  %9.3f',...
                %           cparm(0+1), cparm(1+1), cparm(2+1), cparm(3+1), cparm(4+1), cparm(5+1), cparm(6+1), cparm(7+1), q0);
                
                newincr = incr;
                
                if (q0 < q1)
                    %         {
                    while (q0 < q1)
                        %           {
                        v2 = v1;
                        q2 = q1;
                        v1 = v0;
                        q1 = q0;
                        %
                        %             memcpy(mvec2, mvec1, sizeof(double(nmoments)));
                        %             memcpy(mvec1, mvec0, sizeof(double(nmoments)));
                        mvec2=mvec1;
                        mvec1=mvec0;
                        %
                        v0 = v1 - newincr;
                        cparm(m+1) = v0;
                        newincr = 2 * newincr;
                        %
                        q0 = f(mvec0, winv, nobs, 0);
                        %             fprintf('\n     %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f  %9.3f',...
                        %               cparm(0+1), cparm(1+1), cparm(2+1), cparm(3+1), cparm(4+1), cparm(5+1), cparm(6+1), cparm(7+1), q0);
                        %             }
                    end
                    %           }
                    
                else
                    %         {
                    v2 = v1 + newincr;
                    cparm(m+1) = v2;
                    %
                    q2 = f(mvec2, winv, nobs, 0);
                    %             fprintf('\n     %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f  %9.3f',...
                    %             cparm(0+1), cparm(1+1), cparm(2+1), cparm(3+1), cparm(4+1), cparm(5+1), cparm(6+1), cparm(7+1), q2);
                    
                    while (q2 <= q1)
                        %           {
                        v0 = v1;
                        q0 = q1;
                        v1 = v2;
                        q1 = q2;
                        
                        %             memcpy(mvec0, mvec1, sizeof(double(nmoments)));
                        %             memcpy(mvec1, mvec2, sizeof(double(nmoments)));
                        mvec0=mvec1;mvec1=mvec2;
                        v2 = v1 + newincr;
                        cparm(m+1) = v2;
                        newincr = 2 * newincr;
                        
                        q2 = f(mvec2, winv, nobs, 0);
                        %               fprintf('\n     %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f  %9.3f',...
                        %            cparm(0+1), cparm(1+1), cparm(2+1), cparm(3+1), cparm(4+1), cparm(5+1), cparm(6+1), cparm(7+1), q2);
                        %             }
                    end
                    %           }
                end
                
                while (v1 - v0 > 1.01 * incr || v2 - v1 > 1.01 * incr)
                    %         {
                    dv0 = v1 - v0;
                    dv1 = v2 - v1;
                    dq0 = q0 - q1;
                    dq1 = q2 - q1;
                    
                    dv02 = v1 * v1 - v0 * v0;
                    dv12 = v2 * v2 - v1 * v1;
                    
                    v = (dv12 * dq0 + dv02 * dq1) / (2 * (dv1 * dq0 + dv0 * dq1));
                    
                    if (v2 - v1 <= 1.01 * incr || (v < v1 && v1 - v0 > 1.01 * incr))
                        %           {
                        v = (v0 + v1) / 2;
                        cparm(m+1) = v;
                        %
                        q = f(mvec, winv, nobs, 0);
                        %             fprintf('\n     %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f  %9.3f',...
                        %               cparm(0+1), cparm(1+1), cparm(2+1), cparm(3+1), cparm(4+1), cparm(5+1), cparm(6+1), cparm(7+1), q);
                        %
                        if (q < q1)
                            %             {
                            v2 = v1;
                            q2 = q1;
                            v1 = v;
                            q1 = q;
                            
                            %               memcpy(mvec2, mvec1, sizeof(double(nmoments)));
                            %               memcpy(mvec1, mvec, sizeof(double(nmoments)));
                            mvec2=mvec1; mvec1=mvec;
                            %               }
                        else
                            %             {
                            v0 = v;
                            q0 = q;
                            %
                            %               memcpy(mvec0, mvec, sizeof(double(nmoments)));
                            mvec0=mvec;
                            %           }
                        end
                        %             }
                    else
                        %           {
                        v = (v1 + v2) / 2;
                        cparm(m+1) = v;
                        %
                        q = f(mvec, winv, nobs, 0);
                        %             fprintf('\n     %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f  %9.3f',...
                        %               cparm(0+1), cparm(1+1), cparm(2+1), cparm(3+1), cparm(4+1), cparm(5+1), cparm(6+1), cparm(7+1), q);
                        %
                        if (q < q1)
                            %             {
                            v0 = v1;
                            q0 = q1;
                            v1 = v;
                            q1 = q;
                            
                            %               memcpy(mvec0, mvec1, sizeof(double(nmoments)));
                            %               memcpy(mvec1, mvec, sizeof(double(nmoments)));
                            mvec0=mvec1;mvec1=mvec;
                            %               }
                        else
                            %             {
                            v2 = v;
                            q2 = q;
                            %
                            %               memcpy(mvec2, mvec, sizeof(double(nmoments)));
                            mvec2=mvec;
                            %             }
                        end
                        %           }
                    end
                    %         }
                end
                %
                for l = 0:1:nmoments-1
                    dmat(nmoments * m + l+1) = (mvec2(l+1) - mvec0(l+1)) / (2 * incr);
                end
                cparm(m+1) = v1;
                %         }
            end
            
            sameparms = 1;
            %
            for k = 0:1: nparms-1
                if (cparm(k+1) ~= lparm(k+1))
                    sameparms = 0;
                end
            end
            %       }
            %     }
        end
    end
end
[var,winv,dmat]=covar(var, winv, dmat);
%
fprintf('\n\n          coeff          s.e.           t');

k = -1;
for i = 0:1:nparms-1
    %   {
    k = k + i + 1;
    se = sqrt(var(k+1));
    t = cparm(i+1) / se;
    
    fprintf('\n%3i%14.6f%14.6f%12.4f', i, cparm(i+1), se, t);
    %     }
end
fprintf('\n\nnobs: %8d', nobs);
fprintf('\nq: %11.3f', q1);

%   }
%
