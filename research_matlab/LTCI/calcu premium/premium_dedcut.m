%% calculate acturail fair premium
clc
clear
AFP=zeros(10,2);
global simul
for  i=1:10%deductile period
%i=1;
DEDUCT=(i-1)*2;
gender=0; %female
[fsben fscost fAFP]=fn_premium(gender,DEDUCT);
AFP(i,1)=fAFP;
gender=1; %male
[msben mscost mAFP]=fn_premium(gender,DEDUCT);
AFP(i,2)=mAFP;
end
disp('the result is fAFP mAFP');
AFP
save('AFPfile','AFP');  