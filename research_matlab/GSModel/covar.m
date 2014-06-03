function [var,winv,dmat]=covar(var,winv,dmat)
%传递来的参数C++中都是指针，这里先用global 代替
global nmoments
global nparms
global err
%局部变量
k=int32(0);k1=int32(0) ;k2=int32(0) ;l=int32(0) ;l1=int32(0) ;l2=int32(0);
err=int32(0);
eps=0;x=0;
persistent dtmp
if isempty(dtmp)
dtmp=zeros(nmoments * nparms,1);
end
%   /* calculate variance matrix as G' winv G */
for k = 0 :1: nparms-1         %/* calculate G' times winv */
  for l1 = 0 :1: nmoments-1
%    {
      x = 0;

    l = (l1 * (l1 + 1)) / 2 - 1;

    for l2 = 0:1: nmoments-1
    % {
        if (l2 <= l1)
            l = l + 1;
        else l = l + l2;
        end

      x = x + winv(l+1) * dmat(nmoments * k + l2+1);
      % }  
    end

    dtmp(nmoments * k + l1+1) = x;
%    }
  end
end

%   /* calculate (G'winv) times G */

  k = -1;

  for k1 = 0:1: nparms-1
  for k2 = 0:1: k1 %(<=)
%   {
      k = k + 1;

    x = 0;

    for l = 0:1: nmoments-1
    x = x + dtmp(nmoments * k1 + l+1) * dmat(nmoments * k2 + l+1);
    end
    var(k+1) = x;
%     }
  end
  end

  eps = 0.0000001;

   var=Inv(var, nparms, eps);

  if (err ~= 0)
  disp('\nvar matrix not positive definite in covar')
  end
  

