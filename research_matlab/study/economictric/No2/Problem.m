%% problem 1
%相关系数为p的X,Y的标准正态分布，X*Y大于0的概率q和相关系数p的关系，并作图展示。X=p*Y+sqrt(1-p^2)*rand();（课后有兴趣做）。
% x=p*y+sqrt(1-p^2)*z

p=0.6;
flag=0;
% for i=1:10000
%     y=randn;
%     z=randn;
%     x=p*y+sqrt(1-p^2)*z;
% %    if (x*y>0)
% %        flag=flag+1;
% %    end
% 
% flag=flag+(x.*y>0) ;
% end
y=randn(10000,1);
z=randn(10000,1);
x=p.*y+sqrt(1-p^2).*z;
flag=sum(x.*y>0);



flag/10000



