function r=tsar(n,p,r0)
r=zeros(n,1);
r(1)=p*r0+randn(1);
for i=2:n
    r(i)=r(i-1)*p+randn(1);
end
end