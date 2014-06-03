%% output of health state simulation 
clc
clear
load('healthstate.mat')
healthstate=healthstate-1;
fstate=fopen('healthstate.txt','wt') ;
for ll=1:size(healthstate,1)
    for mm=1:size(healthstate,2)
        fprintf(fstate,'%d',healthstate(ll,mm));
        fprintf(fstate,' ');
    end
    fprintf(fstate,'\n');
end
fclose(fstate);