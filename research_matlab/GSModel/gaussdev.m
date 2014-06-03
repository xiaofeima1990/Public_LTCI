%
% /*---------------------------------------------------------------------------
% 			 GAUSSDEV routine
% 			 Obtains a normal gaussian deviate
%   ---------------------------------------------------------------------------*/

% int gaussdevreset(nthreads);
%数组转换！！！
function g=gaussdev(threadno)
%   传入参数 int   threadno)

% {
factor=0; r=0; v1=0; v2=0;

global gaussdevreset
global nthreads

persistent alternate
if isempty(alternate)
    alternate(1:nthreads,1)=int32(0);
end

persistent gaussdev1
if isempty(gaussdev1)
    gaussdev1=zeros(nthreads,1);
end

persistent gaussdev2
if isempty(gaussdev2)
    gaussdev2=zeros(nthreads,1);
end

if (gaussdevreset(threadno+1) == 1)
    %   {
    alternate(threadno+1) = 0;
    gaussdevreset(threadno+1) = 0;
    %     }
end

if (alternate(threadno+1) == 0)
    %   {
    alternate(threadno+1) = 1;
    r = 2;
    
    while (r >= 1)
        %     {
        v1 = 2 * rand-1;
        v2 = 2 * rand-1;
        r = v1 * v1 + v2 * v2;
        %       }
    end
    
    factor = sqrt(-2 * log(r) / r);
    
    gaussdev1(threadno+1) = v1 * factor;
    gaussdev2(threadno+1) = v2 * factor;
    %
    g=gaussdev1(threadno+1);
    %     }
else
    %   {
    alternate(threadno+1) = 0;
    g=gaussdev2(threadno+1);
    %     }
end

%   }
