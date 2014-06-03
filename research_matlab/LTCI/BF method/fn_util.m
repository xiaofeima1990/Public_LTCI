function out=fn_util(c,gam)

if gam>1;
    out=((c).^(1-gam)-1)/(1-gam);
elseif gam==1;
    out=log(c)-1;
elseif gam==0;
    out=c;
end;