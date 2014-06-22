%% ���ɷַ�����
%%
% $\[z = X \cdot p\]$

% Z=XP
%ingredients->X
load hald
[pc,score,latent,tsquare]=princomp(ingredients); % �ж�Ӧ�ڹ۲�ֵ���б�ʾ���� , ingredients 13*4 pc ��ʾ��p��pc��һ����4���У�ÿ��4��ֵ
%ÿ�ж�Ӧingredients �ĸ����б��� latent�����ɶԽ���ķ����� �� score ����Z
%var(score(:,1))=latent(1)
pc,latent
cumsum(latent)./sum(latent) %��ratio

% [lambda,psi,T,stats,F]=factoran(X,m);
biplot(pc(:,1:2),'Scores',score(:,1:2),'VarLabels',...
		{'X1' 'X2' 'X3' 'X4'})
%��ʾ��X1,X2,X3,X4 �� z1��z2�Ĺ��� ingredients=[X1,X2,X3,X4]
%pc(:,1)[-0.0677999856954738;-0.678516235418647;0.0290208321062291;0.730873909451461]
%-0.0677999856954738;��ʾ ingredients��:,1) ��Z(:,1)�Ĺ���
%-0.678516235418647;��ʾ ingredients��:,2) ��Z(:,1)�Ĺ���
    
%��ingredients ��Э�����������ɷַ���    
covx=cov(ingredients);
[COEFF,latent,explained]=pcacov(covx);

COEFF'*covx*COEFF


%% ���ӷ�����
clear
clc
load carbig
X=[Acceleration Displacement Horsepower MPG Weight];
X=X(all(~isnan(X),2),:);
[lambda,psi,T,stats,F]=factoran(X,2,'scores','regression');
%psi �� miu�ķ���
sum(lambda.^2,2)+psi

inv(T'*T)
F*T'
lambda*inv(T'*T)*lambda'+diag(psi)
biplot(lambda,'LineWidth',2,'MarkerSize',20);



HO=[1	     0.79	  0.36	 0.76	0.25	  0.51;
0.79	   1	     0.31	 0.55	0.17	  0.35;
0.36	   0.31	  1	    0.35	0.64	  0.58;
0.76	   0.55	  0.35	 1	     0.16	  0.38;
0.25    0.17	0.64	 0.16	1	    0.63;
0.51	   0.35  	0.58	 0.38	0.63	  1];%�������ϵ������pho%%�����ϵ������������������ӷ���������������Ϊ2���������ⷽ������Ϊ0��������������ת%

[Lambda, Psi, T] = factoran(PHO,2,'xtype','covariance','delta',0,'rotate','none')
% ���ذ���m���������ӵ�����ģ�͵��غ���Lambda,���ⷽ��Ĺ���ֵPsi,��󷽲���ת����Ӧ����ת����T
contribut=100*sum(Lambda.^2)/6;    %���㹱���ʣ������غ�����Ԫ��֮�ͳ���ά��%



[Lambda, Psi, T] = factoran(PHO,3,'xtype','covariance','delta',0)