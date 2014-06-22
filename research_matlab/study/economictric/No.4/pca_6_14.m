%% 主成分分析法
%%
% $\[z = X \cdot p\]$

% Z=XP
%ingredients->X
load hald
[pc,score,latent,tsquare]=princomp(ingredients); % 行对应于观测值，列表示变量 , ingredients 13*4 pc 表示“p”pc中一共有4个列，每列4个值
%每列对应ingredients 的各个列变量 latent：化成对角阵的方差阵 ； score 就是Z
%var(score(:,1))=latent(1)
pc,latent
cumsum(latent)./sum(latent) %求ratio

% [lambda,psi,T,stats,F]=factoran(X,m);
biplot(pc(:,1:2),'Scores',score(:,1:2),'VarLabels',...
		{'X1' 'X2' 'X3' 'X4'})
%表示：X1,X2,X3,X4 对 z1，z2的贡献 ingredients=[X1,X2,X3,X4]
%pc(:,1)[-0.0677999856954738;-0.678516235418647;0.0290208321062291;0.730873909451461]
%-0.0677999856954738;表示 ingredients（:,1) 对Z(:,1)的贡献
%-0.678516235418647;表示 ingredients（:,2) 对Z(:,1)的贡献
    
%对ingredients 的协方差矩阵做组成分分析    
covx=cov(ingredients);
[COEFF,latent,explained]=pcacov(covx);

COEFF'*covx*COEFF


%% 因子分析法
clear
clc
load carbig
X=[Acceleration Displacement Horsepower MPG Weight];
X=X(all(~isnan(X),2),:);
[lambda,psi,T,stats,F]=factoran(X,2,'scores','regression');
%psi 是 miu的方差
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
0.51	   0.35  	0.58	 0.38	0.63	  1];%定义相关系数矩阵pho%%从相关系数矩阵出发，进行因子分析，公共因子数为2，设置特殊方差下限为0，不进行因子旋转%

[Lambda, Psi, T] = factoran(PHO,2,'xtype','covariance','delta',0,'rotate','none')
% 返回包含m个公共因子的因子模型的载荷阵Lambda,特殊方差的估计值Psi,最大方差旋转法对应的旋转矩阵T
contribut=100*sum(Lambda.^2)/6;    %计算贡献率，因子载荷阵列元素之和除以维数%



[Lambda, Psi, T] = factoran(PHO,3,'xtype','covariance','delta',0)