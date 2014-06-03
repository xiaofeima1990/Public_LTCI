function f=f(mvec,winv,nobs,sw)
% /*---------------------------------------------------------------------------
% 			 F routine
% 			 Evaluates the q-statistic for the moments
%   ---------------------------------------------------------------------------*/

%   double *mvec,               /* moment vector           */
%   double *winv,               /* inverst of w matrix     */
% w的转置矩阵
%   int    nobs,                /* number of observations  */
%   int    sw)                  /* switch to evaluate winv */
%
% {

global err
global MOBSSTRUCT
global arglist
global parm
global nparms
global datav
global nthreads
global nmoments
global threadstate
global localthreadmin
global localthreadmax
%   double *cparm;

%   static char   *buffer;
persistent buffer
if isempty(buffer)
    buffer='';
end
%   static double *rvec;
persistent  rvec
if isempty(rvec)
    rvec=0;
end
%   static int    init = 1;
persistent  init
if isempty(init)
    init=int32(1);
end

%   static double alpha = 2;
persistent alpha
if isempty(alpha)
    alpha=2;
end

k=int32(0); l=int32(0); l1=int32(0); l2=int32(0);
threadindex=int32(0); threadno=int32(0); threadcheck=int32(0);
obs=int32(0); surv=int32(0); err=int32(0);
age=int32(0); age0=int32(0); age1=int32(0);
ret=int32(0); ret0=int32(0); ret1=int32(0);
q=0; eps=0;
%   DATA       *data;

%   MOBSSTRUCT *mobsStruct;
mobsStruct=MOBSSTRUCT ;

%   FILE *tempfile;
%     tempfile;
%
arglist.mvec=zeros(nthreads,nmoments);
arglist.wmat=zeros(nthreads,nmoments * (nmoments + 1) / 2);
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
cparm =parm;
fprintf('\n');

fprintf('%6.3f',cparm.sige);
fprintf('%6.3f',cparm.erho);
fprintf('%6.3f',cparm.beta0 );
fprintf('%6.3f',cparm.beta1);
fprintf('%6.3f',cparm.beta2);
fprintf('%6.3f',cparm.gamma0);
fprintf('%6.3f',cparm.gamma1);
fprintf('%6.3f',cparm.alpha );



if (init == 1)
    %   {
    %       init = 0;
    %
    arglist.nmat(1:nobs ,1: nmoments)=char(0);
    %
    %     /* get moment observations */
    %
    for obs = 0:1:nobs-1
        %     {
        data = datav(obs+1);
        
        %修改的地方
        mobsStruct = MOBSSTRUCT;
        %
        %       /* for (age = 54; age <= 66; age++)   * using retirement status at all ages *
        %       { ret = data(obs).retv(age - 50); */
        %
        for surv = 0:1: 6-1
            %       {
            age = data.age(surv+1);
            ret = data.ret(surv+1);
            %
            if (54 <= age && age <= 66 && 1 <= ret && ret <= 5)
                %         {
                mobsStruct.age(age - 54+1) = 1;
                
                if (age == 55)
                    k =  0;
                else if (age == 58)
                        k =  1;
                    else if (age == 60)
                            k =  2;
                        else if (age == 62)
                                k =  3;
                            else if (age == 65)
                                    k =  4;
                                else                     k = -1;
                                end
                            end
                        end
                    end
                end
                if (k >= 0)
                    %           {
                    mobsStruct.pr(k+1)       = 1;
                    %           pr=partial retiment
                    
                    if (data.inccat == 1)           mobsStruct.lowinc(k+1)   = 1;end
                    if (data.inccat == 3)           mobsStruct.highinc(k+1)  = 1;end
                    if (data.healthage <= age)      mobsStruct.health(k+1)   = 1;end
                    % age of health problem
                    if (data.healthage <= age)      mobsStruct.healthpr(k+1) = 1;end
                end
                %            }
                %           }
            end
            %         }
        end
        %
        for surv = 0:1:5-1  %加过1了
            %       {
            age0 = data.age(surv+1);
            ret0 = data.ret(surv+1);
            age1 = data.age(surv + 1+1);
            ret1 = data.ret(surv + 1+1);
            %
            if (54 <= age0 && age0 <= 66 && 1 <= ret0 && ret0 <= 5....
                    && 54 <= age1 && age1 <= 66 && 1 <= ret1 && ret1 <= 5)
                mobsStruct.reversal(surv+1) = 1;
            end
        end
        %         }
        %       /* fprintf('\n%4d', obs); for (l = 0; l < nmoments; l++) fprintf(' %1d', arglist.nmat(obs)(l)); */
        %       }
        %     }
        
        arglist.nmat(obs+1,1:13)=mobsStruct.age(1:13);
        arglist.nmat(obs+1,14:18)=mobsStruct.pr(1:5);
        arglist.nmat(obs+1,19:23)=mobsStruct.lowinc(1:5);
        arglist.nmat(obs+1,24:28)=mobsStruct.highinc(1:5);
        arglist.nmat(obs+1,29:33)=mobsStruct.health(1:5);
        arglist.nmat(obs+1,34:38)=mobsStruct.healthpr(1:5);
        arglist.nmat(obs+1,39:43)=mobsStruct.reversal(1:5);
    end
end

if (parm.sige <= 0.00001 || parm.erho <= -0.99999 || parm.erho >= 0.99999)
    %   {
    for l = 0:1:nmoments-1
        mvec(l+1) = 0;
    end
    
    f=9e20;
end
%     }
%
if (parm.alpha ~= alpha)
    %   {
    arglist.newalpha = 1;
    alpha = parm.alpha;
    %     }
else arglist.newalpha = 0;
end
%   /* call threads to fill mvec, dmat and smat matrices */

fprintf('\n');
%
for obs = 0:1: nobs-1
    %   {
    threadno = -1;
    %
    %      while (threadno < 0)
    % %     { checkMessages();
    % %
    %        for threadindex = 0:1:nthreads-1
    %        if (threadno < 0)
    %        if (threadstate(threadindex+1) == 0)
    %         threadno = threadindex;
    %
    %       end
    %       end
    %       end
    % %       }
    %      end
    %函数目的就是调用indivmodel
    
    if (localthreadmin == 0)
        if(threadno <= localthreadmax)
            threadstate(1)=1;
            
            indivmodel(0);
        end
    end
    threadstate(1)=0;
    
    threadno =0;
    threadobs(threadno+1) = obs;
    %——————————————————
    %存储设置
    % save('qimfresult');
    % dos('shutdown -s -t 30');
    %  load qimfresult
    
    threadno=0;
    threadobs(threadno+1) = obs;
    threadstate(threadno+1) = 1;
    
    
    %
    if (arglist.mode ~= 4)
        %     {
        if (obs < nobs - 1)
            %       {
            fprintf('\r%5d  ', obs);
            %
            for threadindex = 0 :1:nthreads-1
                if (threadindex <= 1 || (22 <= threadindex && threadindex <= 25) || threadindex >= 38)
                    fprintf('%5d', threadobs(threadindex+1));
                end
            end
            %         }
        else
            %       {
            fprintf('\r');
            for threadindex = 0:1:nthreads-1
                fprintf('%5d', threadobs(threadindex+1));
            end
            %         }
        end
        
        
        %       }
    else
        %     {
        fprintf('\n%4d', threadobs(1));
        %
        for threadindex = 1:1:nthreads-1
            fprintf('%5d', threadobs(threadindex+1));
        end
        %       }
    end
    threadstate(threadno+1) = 1;
    %     }
end
%      threadcheck = 0;
%      threadstate(threadno+1) = 0;

%      while(threadcheck == 0)
% %   { checkMessages();
% %
%       threadcheck = 1;
%
%      for threadno = 0:1:nthreads-1
%         if (threadstate(threadno+1) > 0)
%             threadcheck = 0;
%         end
%      end
% %     }
%      end
%   /* consolidate results */
for l = 0:1: nmoments-1
    %   {
    mvec(l+1) = 0;
    %
    for threadno = 0:1:nthreads-1
        mvec(l+1) = mvec(l+1) + arglist.mvec(threadno+1,l+1);
    end
    %     }
end

fprintf('\n mvec  ');
for l = 0:1: nmoments-1
    %   {
    if (l > 0 && mod(l,10) == 0)
        fprintf('\n       ');
    end
    fprintf('%7.3f', mvec(l+1));
    %     }
end

if (arglist.mode < 1)
    f=0;
end

if (sw > 0)
    %   {
    for k = 0:1: nmoments * (nmoments + 1) / 2 - 1
        %     {
        winv(k+1) = 0;
        
        for threadno = 0:1:nthreads-1
            winv(k+1) = winv(k+1) + arglist.wmat(threadno+1,k+1);
        end
        %       }
    end
    
    %     /* calculate inverse of w */
    
    eps = 0.0000001;
    
    winv=Inv(winv, nmoments, eps);
    % inv err转化为全局变量了
    if (err ~= 0)
        fprintf('\nw matrix not positive definite in f; err %d', err);
    end
    % }
end

%   /* calculate q statistic */

q = 0;
l = -1;

for l1 = 0:1: nmoments-1
    for l2 = 0:1: l1
        %   {
        l = l + 1;
        
        if (l1 == l2)
            q = q + mvec(l1+1) * winv(l+1) * mvec(l2+1);
        else q = q + 2 * mvec(l1+1) * winv(l+1) * mvec(l2+1);
        end
        %     }
    end
end
%
tempfile = fopen('HealthModelEst.tmp', 'at');  %%at啥意思
%
fprintf(tempfile, '\n\n%9.4f   ', q);

% for k = 0:nparms-1 nparm是要把cparm结构数组中的各个数组都输出出来，
% 但下面变换后就不用了
fprintf(tempfile,'%6.3f',cparm.sige);
fprintf(tempfile,'%6.3f',cparm.erho);
fprintf(tempfile,'%6.3f',cparm.beta0 );
fprintf(tempfile,'%6.3f',cparm.beta1);
fprintf(tempfile,'%6.3f',cparm.beta2);
fprintf(tempfile,'%6.3f',cparm.gamma0);
fprintf(tempfile,'%6.3f',cparm.gamma1);
fprintf(tempfile,'%6.3f',cparm.alpha );
%     end

fprintf(tempfile, '\n mvec  ');
for l = 0:1: nmoments-1
    %   {
    if (l > 0 && mod(l,10) == 0)
        fprintf(tempfile, '\n       ');
    end
    fprintf(tempfile, '%7.3f', mvec(l+1));
    %     }
end

fclose(tempfile);

f=q;

%   }
