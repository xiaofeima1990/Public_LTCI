function Inv=Inv(a,n,eps)
%ÉùÃ÷Ò»¸öglobal err

%   double *a,
%   int    n,
%   double eps,
%   int    *err)

% {
i=int32(0); j=int32(0);  k=int32(0);  l=int32(0);  m=int32(0);
hor=int32(0);  ind=int32(0);  ipiv=int32(0);  kpiv=int32(0);  ver=int32(0);
tol=0;
invr=0; piv=0; sum=0; w=0;
global err

if (n <= 0)
    %   {
    err = -1;
    Inv=a;
    return;
    %     }
else err = 0;
end
%   /* factor a into t such that a = t't */
%
kpiv = -1;
for k = 1:1: n %(<=)
    %   {
    kpiv = kpiv + k;
    ind = kpiv;
    
    tol = eps * a(kpiv+1);
    
    if (tol < 0)
        tol = - tol;
    end
    for i = k:1: n
        %     {
        sum = 0;
        for l = 1:1: k-1
            sum = sum + a(kpiv - l+1) * a(ind - l+1);
        end
        sum = a(ind+1) - sum;
        %
        if (i == k)
            %       {
            if (sum - tol <= 0)
                %         {
                if (sum <= 0)
                    %           {
                    err = - (max(k, 2) - 1);
                    Inv=a;
                    return;
                    %             }
                else if (err == 0)
                        err = k - 1;
                    end
                end
                %           }
            end
            piv = sqrt(sum);
            a(kpiv+1) = piv;
            piv = 1 / piv;
            %         }
        else a(ind+1) = sum * piv;
        end
        ind = ind + i;
        %       }
    end
    %     }
end
%
%   /* invert t */
%
ipiv = n * (n + 1) / 2 - 1;
ind = ipiv;
%
for i = 1:1: n %(<=)
    %   {
    invr = 1 / a(ipiv+1);
    a(ipiv+1) = invr;
    m = n;
    j = ind;
    
    for k = 1:1:i-1
        %     {
        w = 0;
        m = m - 1;
        hor = ipiv;
        ver = j;
        
        for l = n - i + 1:1: m
            %       {
            ver = ver + 1;
            hor = hor + l;
            w = w + a(ver+1) * a(hor+1);
            %         }
        end
        a(j+1) = - w * invr;
        j = j - m;
        %       }
    end
    %
    ipiv = ipiv - m;
    ind = ind - 1;
    %     }
end
%
%   /* calculate a inverse from t inverse */
%
for i = 1:1: n %(<=)
    %   {
    ipiv = ipiv + i;
    j = ipiv;
    %
    for k = i:1:n %(<=)
        %     {
        w = 0;
        
        hor = j;
        for l = k:1: n %(<=)
            %       {
            w = w + a(hor+1) * a(hor + k - i+1);
            hor = hor + l;
            %         }
        end
        a(j+1) = w;
        j = j + k;
        %       }
    end
    %     }
end
%   }
Inv=a;

