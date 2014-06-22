%% attemp to modeling the environment control 

X=10:1:300;
Y=10:1:300;

[X,Y]=meshgrid(X,Y);
Z=X+Y + 1000./(0.04.*X+0.01.*Y.^1.2)+Y.^0.9;

surf(X,Y,Z)
mesh(Z)
colormap(jet)


[v,j]=min(min(Z));
(X(j)+Y(j))*1