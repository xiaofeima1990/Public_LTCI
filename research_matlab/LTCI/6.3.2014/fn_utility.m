function out=fn_utility(c,crra)

if crra>1;
    out=((c).^(1-crra)-1)/(1-crra);
elseif crra==1;
    out=log(c)-1;
elseif crra==0;
    out=c;
end;