% /*---------------------------------------------------------------------------
%           RAND RESET routine
% 			 Resets the random number generator of frand
%   ---------------------------------------------------------------------------*/
% 
function randreset(threadno,seed)
%   int   threadno,
%   int   seed)
global gaussdevreset
global randresetflag
global randseed
% 
% { 
    randseed(threadno+1) = seed;
    randresetflag(threadno+1) = 1;
    gaussdevreset(threadno+1) = 1;
% 
%   }
