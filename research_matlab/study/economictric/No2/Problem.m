%% problem 1
%���ϵ��Ϊp��X,Y�ı�׼��̬�ֲ���X*Y����0�ĸ���q�����ϵ��p�Ĺ�ϵ������ͼչʾ��X=p*Y+sqrt(1-p^2)*rand();���κ�����Ȥ������
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



