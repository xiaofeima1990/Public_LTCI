%% calculate acturail fair premium
clc
clear
format long
AFP=zeros(20,2);
SBEN=zeros(20,2);
global simul
for  i=1:10%deductile period
%i=1;
DEDUCT=(i-1);
gender=0; %female
[fsben fscost fAFP]=fn_premium(gender,DEDUCT);
AFP(i,1)=fAFP;
SBEN(i,1)=fsben;
gender=1; %male
[msben mscost mAFP]=fn_premium(gender,DEDUCT);
AFP(i,2)=mAFP;
SBEN(i,2)=msben;
end
disp('the result is fAFP mAFP');
AFP
SBEN
save('AFPfile','AFP','SBEN');  
