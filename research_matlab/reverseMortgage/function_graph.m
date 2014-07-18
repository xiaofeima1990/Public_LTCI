%% Reverse Mortgage function graph 
a=500:10:1000;
x=500:10:1000;
r=2.5;
[A,X] = meshgrid(a,x);

% for the prime function
Z=exp(-(r - X./A).^2).*log(X);
figure
mesh(A,X,Z);
title('e^{ - {{(H/A - \gamma )}^2}}ln(H)', 'FontName','Times New Roman','FontSize',10);
xlabel('$A$','Interpreter','LaTex','FontName','Times New Roman','FontSize',10);
ylabel('$H$','Interpreter','LaTex','FontName','Times New Roman','FontSize',10);


% diff 
syms H A b gamma
f=exp(-(H/(A)-gamma)^2)*log(A);
df_h=diff(f,H);
df_A=diff(f,A);


a=450:20:1100;
h=500:20:1000;
[A,H] = meshgrid(a,h);
gamma=0.5;
% Z_H=subs(df_h,gamma,r);
Z_H=(2.*exp(-(gamma - H./A).^2).*log(A).*(gamma - H./A))./A;
figure
mesh(A,H,Z_H);
title(['e^{ - {{(H/A - \gamma )}^2}}ln(H) derivate on H r=',num2str(gamma)], 'FontName','Times New Roman','FontSize',10);
xlabel('$A$','Interpreter','LaTex','FontName','Times New Roman','FontSize',10);
ylabel('$H$','Interpreter','LaTex','FontName','Times New Roman','FontSize',10);


% Z_A=subs(df_A,H,h);
% Z_A=subs(Z_A,A,a);
% Z_A=double(Z_A);
a=450:10:1000;
h=500:10:1000;


[A,H] = meshgrid(a,h);
gamma=1.5;
Z_A=exp(-(gamma - H./A).^2)./A - (2.*H.*exp(-(gamma - H./A).^2).*log(A).*(gamma - H./A))./A.^2;
figure 
mesh(A,H,Z_A);
title(['e^{ - {{(H/A - \gamma )}^2}}ln(H) derivate on A r=' num2str(gamma)], 'FontName','Times New Roman','FontSize',10);
xlabel('$A$','Interpreter','LaTex','FontName','Times New Roman','FontSize',10);
ylabel('$H$','Interpreter','LaTex','FontName','Times New Roman','FontSize',10);

