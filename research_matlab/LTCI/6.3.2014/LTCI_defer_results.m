% matlabpool open 8;
clear
% clc
close all
pause on
tic

% Definitions of user input parameters;
% crra: risk averse coefficient;
% rho: time discount factor;
% r: risk-free interest rate;
% inf: inflation;
% rmg: real medical cost growth rate;
% nbg: nominal benefit growth rate (inflation protection);
% wealth: wealth decile;
% bencap_hc: home care daily benefit cap of LTCI policy (in 000); 0 means unlimited benefit;
% bencap_alf: assisted living facility daily benefit cap of LTCI policy (in 000); 0 means unlimited benefit;
% bencap_nh: nursing home daily benefit cap of LTCI policy (in 000); 0 means unlimited benefit;
% marketload: ratio of EPV benefit on EPV premium; type 0 means actuarially fair. type 1 means male 0.5, female 1.058 as in Brown and Finkelstein (2008);
% singlem, singlef, couple: marital status; only singles available in the current setting;
% defer: defer insurance type; 0 means no defer; 1 means period defer (elimination period); 2 and 3 mean dollar amount defer (deductible); 
% sick_T: insurance elimination period/deductible; If defer==0, sick_T=0; If defer==1, sick_T=6/12/18/24/36 months. If defer==2, sick_T=25/50/75/100 thousand dollars. If defer==3, sick_T= 25/50% of the expected long-term care expenditure. 
% *useless hcdaycount: always 1. 
% *useless NY: always 0. 2000 numbers if NY==-1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% test=zeros(12,1);
% crra=3;rho=0.03;r=0.03;inf=0.03;rmg=0.015;nbg=0.05;wealth=6;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;defer=1;sick_T=6;hcdaycount=1;NY=0;
% [test(1,1) test(2,1) test(3,1) test(4,1) test(5,1) test(6,1) test(7,1) test(8,1) test(9,1) test(10,1) test(11,1) test(12,1)]= ...
%     fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,defer,sick_T,hcdaycount,NY);  
% toc
% toc
% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 6 months elimination period;
table1m_0=zeros(9,1);
table1m_1=zeros(9,1);
table1m_2=zeros(9,1);
table1m_3=zeros(9,1);
table1m_4=zeros(9,1);
table1m_5=zeros(9,1);
table1m_6=zeros(9,1);
table1m_7=zeros(9,1);
table1m_8=zeros(9,1);
table1m_9=zeros(9,1);
table1m_10=zeros(9,1);
table1m_11=zeros(9,1);
for i=2:9;
    if i==2;
        crra=3;rho=0.03;r=0.03;inf=0.03;rmg=0.015;nbg=0.05;wealth=2;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=0;singlef=1;couple=0;defer=0;sick_T=0;hcdaycount=1;NY=0;
        [table1m_0(i,1) table1m_1(i,1) table1m_2(i,1) table1m_3(i,1) table1m_4(i,1) table1m_5(i,1) table1m_6(i,1) table1m_7(i,1) table1m_8(i,1) table1m_9(i,1) table1m_10(i,1) table1m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,defer,sick_T,hcdaycount,NY);
    elseif i==3;
        crra=3;rho=0.03;r=0.03;inf=0.03;rmg=0.015;nbg=0.05;wealth=3;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;defer=1;sick_T=6;hcdaycount=1;NY=-1;
        [table1m_0(i,1) table1m_1(i,1) table1m_2(i,1) table1m_3(i,1) table1m_4(i,1) table1m_5(i,1) table1m_6(i,1) table1m_7(i,1) table1m_8(i,1) table1m_9(i,1) table1m_10(i,1) table1m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,defer,sick_T,hcdaycount,NY);
    elseif i==4;
        crra=3;rho=0.03;r=0.03;inf=0.03;rmg=0.015;nbg=0.05;wealth=4;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;defer=1;sick_T=6;hcdaycount=1;NY=-1;
        [table1m_0(i,1) table1m_1(i,1) table1m_2(i,1) table1m_3(i,1) table1m_4(i,1) table1m_5(i,1) table1m_6(i,1) table1m_7(i,1) table1m_8(i,1) table1m_9(i,1) table1m_10(i,1) table1m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,defer,sick_T,hcdaycount,NY);
    elseif i==5;
        crra=3;rho=0.03;r=0.03;inf=0.03;rmg=0.015;nbg=0.05;wealth=5;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;defer=1;sick_T=6;hcdaycount=1;NY=-1;
        [table1m_0(i,1) table1m_1(i,1) table1m_2(i,1) table1m_3(i,1) table1m_4(i,1) table1m_5(i,1) table1m_6(i,1) table1m_7(i,1) table1m_8(i,1) table1m_9(i,1) table1m_10(i,1) table1m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,defer,sick_T,hcdaycount,NY);
    elseif i==6;
        crra=3;rho=0.03;r=0.03;inf=0.03;rmg=0.015;nbg=0.05;wealth=6;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;defer=1;sick_T=6;hcdaycount=1;NY=-1;
        [table1m_0(i,1) table1m_1(i,1) table1m_2(i,1) table1m_3(i,1) table1m_4(i,1) table1m_5(i,1) table1m_6(i,1) table1m_7(i,1) table1m_8(i,1) table1m_9(i,1) table1m_10(i,1) table1m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,defer,sick_T,hcdaycount,NY);
    elseif i==7;
        crra=3;rho=0.03;r=0.03;inf=0.03;rmg=0.015;nbg=0.05;wealth=7;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;defer=1;sick_T=6;hcdaycount=1;NY=-1;
        [table1m_0(i,1) table1m_1(i,1) table1m_2(i,1) table1m_3(i,1) table1m_4(i,1) table1m_5(i,1) table1m_6(i,1) table1m_7(i,1) table1m_8(i,1) table1m_9(i,1) table1m_10(i,1) table1m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,defer,sick_T,hcdaycount,NY);
    elseif i==8;
        crra=3;rho=0.03;r=0.03;inf=0.03;rmg=0.015;nbg=0.05;wealth=8;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;defer=1;sick_T=6;hcdaycount=1;NY=-1;
        [table1m_0(i,1) table1m_1(i,1) table1m_2(i,1) table1m_3(i,1) table1m_4(i,1) table1m_5(i,1) table1m_6(i,1) table1m_7(i,1) table1m_8(i,1) table1m_9(i,1) table1m_10(i,1) table1m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,defer,sick_T,hcdaycount,NY);
    elseif i==9;
        crra=3;rho=0.03;r=0.03;inf=0.03;rmg=0.015;nbg=0.05;wealth=9;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;defer=1;sick_T=6;hcdaycount=1;NY=-1;
        [table1m_0(i,1) table1m_1(i,1) table1m_2(i,1) table1m_3(i,1) table1m_4(i,1) table1m_5(i,1) table1m_6(i,1) table1m_7(i,1) table1m_8(i,1) table1m_9(i,1) table1m_10(i,1) table1m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,defer,sick_T,hcdaycount,NY);
    end;
end;
table1m_201_101=[table1m_0(:,1) table1m_1(:,1) table1m_2(:,1) table1m_3(:,1) table1m_4(:,1) table1m_5(:,1) table1m_6(:,1) table1m_7(:,1) table1m_8(:,1) table1m_9(:,1) table1m_10(:,1) table1m_11(:,1)];
save LTCI_defer_tables table*
toc
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 18 months elimination period;
table2m_0=zeros(9,1);
table2m_1=zeros(9,1);
table2m_2=zeros(9,1);
table2m_3=zeros(9,1);
table2m_4=zeros(9,1);
table2m_5=zeros(9,1);
table2m_6=zeros(9,1);
table2m_7=zeros(9,1);
table2m_8=zeros(9,1);
table2m_9=zeros(9,1);
table2m_10=zeros(9,1);
table2m_11=zeros(9,1);
parfor i=4:9;
    if i==2;
        crra=3;rho=0.03;r=0.03;inf=0.03;rmg=0.015;nbg=0.05;wealth=2;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;defer=1;sick_T=18;hcdaycount=1;NY=-1;
        [table2m_0(i,1) table2m_1(i,1) table2m_2(i,1) table2m_3(i,1) table2m_4(i,1) table2m_5(i,1) table2m_6(i,1) table2m_7(i,1) table2m_8(i,1) table2m_9(i,1) table2m_10(i,1) table2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,defer,sick_T,hcdaycount,NY);
    elseif i==3;
        crra=3;rho=0.03;r=0.03;inf=0.03;rmg=0.015;nbg=0.05;wealth=3;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;defer=1;sick_T=18;hcdaycount=1;NY=-1;
        [table2m_0(i,1) table2m_1(i,1) table2m_2(i,1) table2m_3(i,1) table2m_4(i,1) table2m_5(i,1) table2m_6(i,1) table2m_7(i,1) table2m_8(i,1) table2m_9(i,1) table2m_10(i,1) table2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,defer,sick_T,hcdaycount,NY);
    elseif i==4;
        crra=3;rho=0.03;r=0.03;inf=0.03;rmg=0.015;nbg=0.05;wealth=4;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;defer=1;sick_T=18;hcdaycount=1;NY=-1;
        [table2m_0(i,1) table2m_1(i,1) table2m_2(i,1) table2m_3(i,1) table2m_4(i,1) table2m_5(i,1) table2m_6(i,1) table2m_7(i,1) table2m_8(i,1) table2m_9(i,1) table2m_10(i,1) table2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,defer,sick_T,hcdaycount,NY);
    elseif i==5;
        crra=3;rho=0.03;r=0.03;inf=0.03;rmg=0.015;nbg=0.05;wealth=5;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;defer=1;sick_T=18;hcdaycount=1;NY=-1;
        [table2m_0(i,1) table2m_1(i,1) table2m_2(i,1) table2m_3(i,1) table2m_4(i,1) table2m_5(i,1) table2m_6(i,1) table2m_7(i,1) table2m_8(i,1) table2m_9(i,1) table2m_10(i,1) table2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,defer,sick_T,hcdaycount,NY);
    elseif i==6;
        crra=3;rho=0.03;r=0.03;inf=0.03;rmg=0.015;nbg=0.05;wealth=6;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;defer=1;sick_T=18;hcdaycount=1;NY=-1;
        [table2m_0(i,1) table2m_1(i,1) table2m_2(i,1) table2m_3(i,1) table2m_4(i,1) table2m_5(i,1) table2m_6(i,1) table2m_7(i,1) table2m_8(i,1) table2m_9(i,1) table2m_10(i,1) table2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,defer,sick_T,hcdaycount,NY);
    elseif i==7;
        crra=3;rho=0.03;r=0.03;inf=0.03;rmg=0.015;nbg=0.05;wealth=7;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;defer=1;sick_T=18;hcdaycount=1;NY=-1;
        [table2m_0(i,1) table2m_1(i,1) table2m_2(i,1) table2m_3(i,1) table2m_4(i,1) table2m_5(i,1) table2m_6(i,1) table2m_7(i,1) table2m_8(i,1) table2m_9(i,1) table2m_10(i,1) table2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,defer,sick_T,hcdaycount,NY);
    elseif i==8;
        crra=3;rho=0.03;r=0.03;inf=0.03;rmg=0.015;nbg=0.05;wealth=8;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;defer=1;sick_T=18;hcdaycount=1;NY=-1;
        [table2m_0(i,1) table2m_1(i,1) table2m_2(i,1) table2m_3(i,1) table2m_4(i,1) table2m_5(i,1) table2m_6(i,1) table2m_7(i,1) table2m_8(i,1) table2m_9(i,1) table2m_10(i,1) table2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,defer,sick_T,hcdaycount,NY);
    elseif i==9;
        crra=3;rho=0.03;r=0.03;inf=0.03;rmg=0.015;nbg=0.05;wealth=9;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;defer=1;sick_T=18;hcdaycount=1;NY=-1;
        [table2m_0(i,1) table2m_1(i,1) table2m_2(i,1) table2m_3(i,1) table2m_4(i,1) table2m_5(i,1) table2m_6(i,1) table2m_7(i,1) table2m_8(i,1) table2m_9(i,1) table2m_10(i,1) table2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,defer,sick_T,hcdaycount,NY);
    end;
end;
table2m_201_101=[table2m_0(:,1) table2m_1(:,1) table2m_2(:,1) table2m_3(:,1) table2m_4(:,1) table2m_5(:,1) table2m_6(:,1) table2m_7(:,1) table2m_8(:,1) table2m_9(:,1) table2m_10(:,1) table2m_11(:,1)];
save LTCI_defer_tables table*
toc
toc























% old codes;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%Tables%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% table1m_0=zeros(8,1);
% table1m_1=zeros(8,1);
% table1m_2=zeros(8,1);
% table1m_3=zeros(8,1);
% table1m_4=zeros(8,1);
% table1m_5=zeros(8,1);
% table1m_6=zeros(8,1);
% table1m_7=zeros(8,1);
% table1m_8=zeros(8,1);
% table1m_9=zeros(8,1);
% table1m_10=zeros(8,1);
% table1m_11=zeros(8,1);
% parfor i=1:8;
%     if i==1;
%         crra=3;rho=0.03;r=0.03;inf=0.03;rmg=0.015;nbg=0;wealth=2;bencap_hc=0.1;bencap_alf=0.1;bencap_nh=0.1;marketload=1;singlem=1;singlef=0;couple=0;defer=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table1m_0(i,1) table1m_1(i,1) table1m_2(i,1) table1m_3(i,1) table1m_4(i,1) table1m_5(i,1) table1m_6(i,1) table1m_7(i,1) table1m_8(i,1) table1m_9(i,1) table1m_10(i,1) table1m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,defer,sick_T,hcdaycount,NY);
%     elseif i==2;
%         crra=3;rho=0.03;r=0.03;inf=0.03;rmg=0.015;nbg=0;wealth=3;bencap_hc=0.1;bencap_alf=0.1;bencap_nh=0.1;marketload=1;singlem=1;singlef=0;couple=0;defer=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table1m_0(i,1) table1m_1(i,1) table1m_2(i,1) table1m_3(i,1) table1m_4(i,1) table1m_5(i,1) table1m_6(i,1) table1m_7(i,1) table1m_8(i,1) table1m_9(i,1) table1m_10(i,1) table1m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,defer,sick_T,hcdaycount,NY);
%     elseif i==3;
%         crra=3;rho=0.03;r=0.03;inf=0.03;rmg=0.015;nbg=0;wealth=4;bencap_hc=0.1;bencap_alf=0.1;bencap_nh=0.1;marketload=1;singlem=1;singlef=0;couple=0;defer=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table1m_0(i,1) table1m_1(i,1) table1m_2(i,1) table1m_3(i,1) table1m_4(i,1) table1m_5(i,1) table1m_6(i,1) table1m_7(i,1) table1m_8(i,1) table1m_9(i,1) table1m_10(i,1) table1m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,defer,sick_T,hcdaycount,NY);
%     elseif i==4;
%         crra=3;rho=0.03;r=0.03;inf=0.03;rmg=0.015;nbg=0;wealth=5;bencap_hc=0.1;bencap_alf=0.1;bencap_nh=0.1;marketload=1;singlem=1;singlef=0;couple=0;defer=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table1m_0(i,1) table1m_1(i,1) table1m_2(i,1) table1m_3(i,1) table1m_4(i,1) table1m_5(i,1) table1m_6(i,1) table1m_7(i,1) table1m_8(i,1) table1m_9(i,1) table1m_10(i,1) table1m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,defer,sick_T,hcdaycount,NY);
%     elseif i==5;
%         crra=3;rho=0.03;r=0.03;inf=0.03;rmg=0.015;nbg=0;wealth=6;bencap_hc=0.1;bencap_alf=0.1;bencap_nh=0.1;marketload=1;singlem=1;singlef=0;couple=0;defer=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table1m_0(i,1) table1m_1(i,1) table1m_2(i,1) table1m_3(i,1) table1m_4(i,1) table1m_5(i,1) table1m_6(i,1) table1m_7(i,1) table1m_8(i,1) table1m_9(i,1) table1m_10(i,1) table1m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,defer,sick_T,hcdaycount,NY);
%     elseif i==6;
%         crra=3;rho=0.03;r=0.03;inf=0.03;rmg=0.015;nbg=0;wealth=7;bencap_hc=0.1;bencap_alf=0.1;bencap_nh=0.1;marketload=1;singlem=1;singlef=0;couple=0;defer=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table1m_0(i,1) table1m_1(i,1) table1m_2(i,1) table1m_3(i,1) table1m_4(i,1) table1m_5(i,1) table1m_6(i,1) table1m_7(i,1) table1m_8(i,1) table1m_9(i,1) table1m_10(i,1) table1m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,defer,sick_T,hcdaycount,NY);
%     elseif i==7;
%         crra=3;rho=0.03;r=0.03;inf=0.03;rmg=0.015;nbg=0;wealth=8;bencap_hc=0.1;bencap_alf=0.1;bencap_nh=0.1;marketload=1;singlem=1;singlef=0;couple=0;defer=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table1m_0(i,1) table1m_1(i,1) table1m_2(i,1) table1m_3(i,1) table1m_4(i,1) table1m_5(i,1) table1m_6(i,1) table1m_7(i,1) table1m_8(i,1) table1m_9(i,1) table1m_10(i,1) table1m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,defer,sick_T,hcdaycount,NY);
%     elseif i==8;
%         crra=3;rho=0.03;r=0.03;inf=0.03;rmg=0.015;nbg=0;wealth=9;bencap_hc=0.1;bencap_alf=0.1;bencap_nh=0.1;marketload=1;singlem=1;singlef=0;couple=0;defer=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table1m_0(i,1) table1m_1(i,1) table1m_2(i,1) table1m_3(i,1) table1m_4(i,1) table1m_5(i,1) table1m_6(i,1) table1m_7(i,1) table1m_8(i,1) table1m_9(i,1) table1m_10(i,1) table1m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,defer,sick_T,hcdaycount,NY);
%     end;
% end;
% table1m=[table1m_0(:,1) table1m_1(:,1) table1m_2(:,1) table1m_3(:,1) table1m_4(:,1) table1m_5(:,1) table1m_6(:,1) table1m_7(:,1) table1m_8(:,1) table1m_9(:,1) table1m_10(:,1) table1m_11(:,1)];
% save LTCI_defer_tables table*
% toc










% table0_2m_0=zeros(8,1);
% table0_2m_1=zeros(8,1);
% table0_2m_2=zeros(8,1);
% table0_2m_3=zeros(8,1);
% table0_2m_4=zeros(8,1);
% table0_2m_5=zeros(8,1);
% table0_2m_6=zeros(8,1);
% table0_2m_7=zeros(8,1);
% table0_2m_8=zeros(8,1);
% table0_2m_9=zeros(8,1);
% table0_2m_10=zeros(8,1);
% table0_2m_11=zeros(8,1);
% parfor i=1:8;
%     if i==1;
%         crra=3;rho=0.03;r=0.03;inf=0.03;rmg=0.015;nbg=0;wealth=2;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table0_2m_0(i,1) table0_2m_1(i,1) table0_2m_2(i,1) table0_2m_3(i,1) table0_2m_4(i,1) table0_2m_5(i,1) table0_2m_6(i,1) table0_2m_7(i,1) table0_2m_8(i,1) table0_2m_9(i,1) table0_2m_10(i,1) table0_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==2;
%         crra=3;rho=0.03;r=0.03;inf=0.03;rmg=0.015;nbg=0;wealth=3;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table0_2m_0(i,1) table0_2m_1(i,1) table0_2m_2(i,1) table0_2m_3(i,1) table0_2m_4(i,1) table0_2m_5(i,1) table0_2m_6(i,1) table0_2m_7(i,1) table0_2m_8(i,1) table0_2m_9(i,1) table0_2m_10(i,1) table0_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==3;
%         crra=3;rho=0.03;r=0.03;inf=0.03;rmg=0.015;nbg=0;wealth=4;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table0_2m_0(i,1) table0_2m_1(i,1) table0_2m_2(i,1) table0_2m_3(i,1) table0_2m_4(i,1) table0_2m_5(i,1) table0_2m_6(i,1) table0_2m_7(i,1) table0_2m_8(i,1) table0_2m_9(i,1) table0_2m_10(i,1) table0_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==4;
%         crra=3;rho=0.03;r=0.03;inf=0.03;rmg=0.015;nbg=0;wealth=5;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table0_2m_0(i,1) table0_2m_1(i,1) table0_2m_2(i,1) table0_2m_3(i,1) table0_2m_4(i,1) table0_2m_5(i,1) table0_2m_6(i,1) table0_2m_7(i,1) table0_2m_8(i,1) table0_2m_9(i,1) table0_2m_10(i,1) table0_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==5;
%         crra=3;rho=0.03;r=0.03;inf=0.03;rmg=0.015;nbg=0;wealth=6;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table0_2m_0(i,1) table0_2m_1(i,1) table0_2m_2(i,1) table0_2m_3(i,1) table0_2m_4(i,1) table0_2m_5(i,1) table0_2m_6(i,1) table0_2m_7(i,1) table0_2m_8(i,1) table0_2m_9(i,1) table0_2m_10(i,1) table0_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==6;
%         crra=3;rho=0.03;r=0.03;inf=0.03;rmg=0.015;nbg=0;wealth=7;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table0_2m_0(i,1) table0_2m_1(i,1) table0_2m_2(i,1) table0_2m_3(i,1) table0_2m_4(i,1) table0_2m_5(i,1) table0_2m_6(i,1) table0_2m_7(i,1) table0_2m_8(i,1) table0_2m_9(i,1) table0_2m_10(i,1) table0_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==7;
%         crra=3;rho=0.03;r=0.03;inf=0.03;rmg=0.015;nbg=0;wealth=8;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table0_2m_0(i,1) table0_2m_1(i,1) table0_2m_2(i,1) table0_2m_3(i,1) table0_2m_4(i,1) table0_2m_5(i,1) table0_2m_6(i,1) table0_2m_7(i,1) table0_2m_8(i,1) table0_2m_9(i,1) table0_2m_10(i,1) table0_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==8;
%         crra=3;rho=0.03;r=0.03;inf=0.03;rmg=0.015;nbg=0;wealth=9;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table0_2m_0(i,1) table0_2m_1(i,1) table0_2m_2(i,1) table0_2m_3(i,1) table0_2m_4(i,1) table0_2m_5(i,1) table0_2m_6(i,1) table0_2m_7(i,1) table0_2m_8(i,1) table0_2m_9(i,1) table0_2m_10(i,1) table0_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     end;
% end;
% table0_2m=[table0_2m_0(:,1) table0_2m_1(:,1) table0_2m_2(:,1) table0_2m_3(:,1) table0_2m_4(:,1) table0_2m_5(:,1) table0_2m_6(:,1) table0_2m_7(:,1) table0_2m_8(:,1) table0_2m_9(:,1) table0_2m_10(:,1) table0_2m_11(:,1)];
% save LTCI_partner_tables table*
% toc
% 
% table1m_0=zeros(8,1);
% table1m_1=zeros(8,1);
% table1m_2=zeros(8,1);
% table1m_3=zeros(8,1);
% table1m_4=zeros(8,1);
% table1m_5=zeros(8,1);
% table1m_6=zeros(8,1);
% table1m_7=zeros(8,1);
% table1m_8=zeros(8,1);
% table1m_9=zeros(8,1);
% table1m_10=zeros(8,1);
% table1m_11=zeros(8,1);
% parfor i=1:8;
%     if i==1;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=2;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table1m_0(i,1) table1m_1(i,1) table1m_2(i,1) table1m_3(i,1) table1m_4(i,1) table1m_5(i,1) table1m_6(i,1) table1m_7(i,1) table1m_8(i,1) table1m_9(i,1) table1m_10(i,1) table1m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==2;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=3;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table1m_0(i,1) table1m_1(i,1) table1m_2(i,1) table1m_3(i,1) table1m_4(i,1) table1m_5(i,1) table1m_6(i,1) table1m_7(i,1) table1m_8(i,1) table1m_9(i,1) table1m_10(i,1) table1m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==3;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=4;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table1m_0(i,1) table1m_1(i,1) table1m_2(i,1) table1m_3(i,1) table1m_4(i,1) table1m_5(i,1) table1m_6(i,1) table1m_7(i,1) table1m_8(i,1) table1m_9(i,1) table1m_10(i,1) table1m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==4;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=5;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table1m_0(i,1) table1m_1(i,1) table1m_2(i,1) table1m_3(i,1) table1m_4(i,1) table1m_5(i,1) table1m_6(i,1) table1m_7(i,1) table1m_8(i,1) table1m_9(i,1) table1m_10(i,1) table1m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==5;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=6;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table1m_0(i,1) table1m_1(i,1) table1m_2(i,1) table1m_3(i,1) table1m_4(i,1) table1m_5(i,1) table1m_6(i,1) table1m_7(i,1) table1m_8(i,1) table1m_9(i,1) table1m_10(i,1) table1m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==6;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=7;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table1m_0(i,1) table1m_1(i,1) table1m_2(i,1) table1m_3(i,1) table1m_4(i,1) table1m_5(i,1) table1m_6(i,1) table1m_7(i,1) table1m_8(i,1) table1m_9(i,1) table1m_10(i,1) table1m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==7;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=8;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table1m_0(i,1) table1m_1(i,1) table1m_2(i,1) table1m_3(i,1) table1m_4(i,1) table1m_5(i,1) table1m_6(i,1) table1m_7(i,1) table1m_8(i,1) table1m_9(i,1) table1m_10(i,1) table1m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==8;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=9;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table1m_0(i,1) table1m_1(i,1) table1m_2(i,1) table1m_3(i,1) table1m_4(i,1) table1m_5(i,1) table1m_6(i,1) table1m_7(i,1) table1m_8(i,1) table1m_9(i,1) table1m_10(i,1) table1m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     end;
% end;
% table1m=[table1m_0(:,1) table1m_1(:,1) table1m_2(:,1) table1m_3(:,1) table1m_4(:,1) table1m_5(:,1) table1m_6(:,1) table1m_7(:,1) table1m_8(:,1) table1m_9(:,1) table1m_10(:,1) table1m_11(:,1)];
% save LTCI_partner_tables table*
% toc
% 
% table2m_0=zeros(8,1);
% table2m_1=zeros(8,1);
% table2m_2=zeros(8,1);
% table2m_3=zeros(8,1);
% table2m_4=zeros(8,1);
% table2m_5=zeros(8,1);
% table2m_6=zeros(8,1);
% table2m_7=zeros(8,1);
% table2m_8=zeros(8,1);
% table2m_9=zeros(8,1);
% table2m_10=zeros(8,1);
% table2m_11=zeros(8,1);
% parfor i=1:8;
%     if i==1;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0;wealth=2;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table2m_0(i,1) table2m_1(i,1) table2m_2(i,1) table2m_3(i,1) table2m_4(i,1) table2m_5(i,1) table2m_6(i,1) table2m_7(i,1) table2m_8(i,1) table2m_9(i,1) table2m_10(i,1) table2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==2;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0;wealth=3;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table2m_0(i,1) table2m_1(i,1) table2m_2(i,1) table2m_3(i,1) table2m_4(i,1) table2m_5(i,1) table2m_6(i,1) table2m_7(i,1) table2m_8(i,1) table2m_9(i,1) table2m_10(i,1) table2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==3;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0;wealth=4;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table2m_0(i,1) table2m_1(i,1) table2m_2(i,1) table2m_3(i,1) table2m_4(i,1) table2m_5(i,1) table2m_6(i,1) table2m_7(i,1) table2m_8(i,1) table2m_9(i,1) table2m_10(i,1) table2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==4;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0;wealth=5;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table2m_0(i,1) table2m_1(i,1) table2m_2(i,1) table2m_3(i,1) table2m_4(i,1) table2m_5(i,1) table2m_6(i,1) table2m_7(i,1) table2m_8(i,1) table2m_9(i,1) table2m_10(i,1) table2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==5;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0;wealth=6;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table2m_0(i,1) table2m_1(i,1) table2m_2(i,1) table2m_3(i,1) table2m_4(i,1) table2m_5(i,1) table2m_6(i,1) table2m_7(i,1) table2m_8(i,1) table2m_9(i,1) table2m_10(i,1) table2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==6;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0;wealth=7;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table2m_0(i,1) table2m_1(i,1) table2m_2(i,1) table2m_3(i,1) table2m_4(i,1) table2m_5(i,1) table2m_6(i,1) table2m_7(i,1) table2m_8(i,1) table2m_9(i,1) table2m_10(i,1) table2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==7;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0;wealth=8;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table2m_0(i,1) table2m_1(i,1) table2m_2(i,1) table2m_3(i,1) table2m_4(i,1) table2m_5(i,1) table2m_6(i,1) table2m_7(i,1) table2m_8(i,1) table2m_9(i,1) table2m_10(i,1) table2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==8;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0;wealth=9;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table2m_0(i,1) table2m_1(i,1) table2m_2(i,1) table2m_3(i,1) table2m_4(i,1) table2m_5(i,1) table2m_6(i,1) table2m_7(i,1) table2m_8(i,1) table2m_9(i,1) table2m_10(i,1) table2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     end;
% end;
% table2m=[table2m_0(:,1) table2m_1(:,1) table2m_2(:,1) table2m_3(:,1) table2m_4(:,1) table2m_5(:,1) table2m_6(:,1) table2m_7(:,1) table2m_8(:,1) table2m_9(:,1) table2m_10(:,1) table2m_11(:,1)];
% save LTCI_partner_tables table*
% toc
% 
% table3m_0=zeros(8,1);
% table3m_1=zeros(8,1);
% table3m_2=zeros(8,1);
% table3m_3=zeros(8,1);
% table3m_4=zeros(8,1);
% table3m_5=zeros(8,1);
% table3m_6=zeros(8,1);
% table3m_7=zeros(8,1);
% table3m_8=zeros(8,1);
% table3m_9=zeros(8,1);
% table3m_10=zeros(8,1);
% table3m_11=zeros(8,1);
% parfor i=1:8;
%     if i==1;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=2;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table3m_0(i,1) table3m_1(i,1) table3m_2(i,1) table3m_3(i,1) table3m_4(i,1) table3m_5(i,1) table3m_6(i,1) table3m_7(i,1) table3m_8(i,1) table3m_9(i,1) table3m_10(i,1) table3m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==2;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=3;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table3m_0(i,1) table3m_1(i,1) table3m_2(i,1) table3m_3(i,1) table3m_4(i,1) table3m_5(i,1) table3m_6(i,1) table3m_7(i,1) table3m_8(i,1) table3m_9(i,1) table3m_10(i,1) table3m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==3;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=4;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table3m_0(i,1) table3m_1(i,1) table3m_2(i,1) table3m_3(i,1) table3m_4(i,1) table3m_5(i,1) table3m_6(i,1) table3m_7(i,1) table3m_8(i,1) table3m_9(i,1) table3m_10(i,1) table3m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==4;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=5;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table3m_0(i,1) table3m_1(i,1) table3m_2(i,1) table3m_3(i,1) table3m_4(i,1) table3m_5(i,1) table3m_6(i,1) table3m_7(i,1) table3m_8(i,1) table3m_9(i,1) table3m_10(i,1) table3m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==5;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=6;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table3m_0(i,1) table3m_1(i,1) table3m_2(i,1) table3m_3(i,1) table3m_4(i,1) table3m_5(i,1) table3m_6(i,1) table3m_7(i,1) table3m_8(i,1) table3m_9(i,1) table3m_10(i,1) table3m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==6;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=7;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table3m_0(i,1) table3m_1(i,1) table3m_2(i,1) table3m_3(i,1) table3m_4(i,1) table3m_5(i,1) table3m_6(i,1) table3m_7(i,1) table3m_8(i,1) table3m_9(i,1) table3m_10(i,1) table3m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==7;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=8;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table3m_0(i,1) table3m_1(i,1) table3m_2(i,1) table3m_3(i,1) table3m_4(i,1) table3m_5(i,1) table3m_6(i,1) table3m_7(i,1) table3m_8(i,1) table3m_9(i,1) table3m_10(i,1) table3m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==8;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=9;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table3m_0(i,1) table3m_1(i,1) table3m_2(i,1) table3m_3(i,1) table3m_4(i,1) table3m_5(i,1) table3m_6(i,1) table3m_7(i,1) table3m_8(i,1) table3m_9(i,1) table3m_10(i,1) table3m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     end;
% end;
% table3m=[table3m_0(:,1) table3m_1(:,1) table3m_2(:,1) table3m_3(:,1) table3m_4(:,1) table3m_5(:,1) table3m_6(:,1) table3m_7(:,1) table3m_8(:,1) table3m_9(:,1) table3m_10(:,1) table3m_11(:,1)];
% save LTCI_partner_tables table*
% toc
% 
% table4_1m_0=zeros(8,1);
% table4_1m_1=zeros(8,1);
% table4_1m_2=zeros(8,1);
% table4_1m_3=zeros(8,1);
% table4_1m_4=zeros(8,1);
% table4_1m_5=zeros(8,1);
% table4_1m_6=zeros(8,1);
% table4_1m_7=zeros(8,1);
% table4_1m_8=zeros(8,1);
% table4_1m_9=zeros(8,1);
% table4_1m_10=zeros(8,1);
% table4_1m_11=zeros(8,1);
% parfor i=1:8;
%     if i==1;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=2;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_1m_0(i,1) table4_1m_1(i,1) table4_1m_2(i,1) table4_1m_3(i,1) table4_1m_4(i,1) table4_1m_5(i,1) table4_1m_6(i,1) table4_1m_7(i,1) table4_1m_8(i,1) table4_1m_9(i,1) table4_1m_10(i,1) table4_1m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==2;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=3;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_1m_0(i,1) table4_1m_1(i,1) table4_1m_2(i,1) table4_1m_3(i,1) table4_1m_4(i,1) table4_1m_5(i,1) table4_1m_6(i,1) table4_1m_7(i,1) table4_1m_8(i,1) table4_1m_9(i,1) table4_1m_10(i,1) table4_1m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==3;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=4;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_1m_0(i,1) table4_1m_1(i,1) table4_1m_2(i,1) table4_1m_3(i,1) table4_1m_4(i,1) table4_1m_5(i,1) table4_1m_6(i,1) table4_1m_7(i,1) table4_1m_8(i,1) table4_1m_9(i,1) table4_1m_10(i,1) table4_1m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==4;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=5;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_1m_0(i,1) table4_1m_1(i,1) table4_1m_2(i,1) table4_1m_3(i,1) table4_1m_4(i,1) table4_1m_5(i,1) table4_1m_6(i,1) table4_1m_7(i,1) table4_1m_8(i,1) table4_1m_9(i,1) table4_1m_10(i,1) table4_1m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==5;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=6;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_1m_0(i,1) table4_1m_1(i,1) table4_1m_2(i,1) table4_1m_3(i,1) table4_1m_4(i,1) table4_1m_5(i,1) table4_1m_6(i,1) table4_1m_7(i,1) table4_1m_8(i,1) table4_1m_9(i,1) table4_1m_10(i,1) table4_1m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==6;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=7;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_1m_0(i,1) table4_1m_1(i,1) table4_1m_2(i,1) table4_1m_3(i,1) table4_1m_4(i,1) table4_1m_5(i,1) table4_1m_6(i,1) table4_1m_7(i,1) table4_1m_8(i,1) table4_1m_9(i,1) table4_1m_10(i,1) table4_1m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==7;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=8;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_1m_0(i,1) table4_1m_1(i,1) table4_1m_2(i,1) table4_1m_3(i,1) table4_1m_4(i,1) table4_1m_5(i,1) table4_1m_6(i,1) table4_1m_7(i,1) table4_1m_8(i,1) table4_1m_9(i,1) table4_1m_10(i,1) table4_1m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==8;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=9;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_1m_0(i,1) table4_1m_1(i,1) table4_1m_2(i,1) table4_1m_3(i,1) table4_1m_4(i,1) table4_1m_5(i,1) table4_1m_6(i,1) table4_1m_7(i,1) table4_1m_8(i,1) table4_1m_9(i,1) table4_1m_10(i,1) table4_1m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     end;
% end;
% table4_1m=[table4_1m_0(:,1) table4_1m_1(:,1) table4_1m_2(:,1) table4_1m_3(:,1) table4_1m_4(:,1) table4_1m_5(:,1) table4_1m_6(:,1) table4_1m_7(:,1) table4_1m_8(:,1) table4_1m_9(:,1) table4_1m_10(:,1) table4_1m_11(:,1)];
% save LTCI_partner_tables table*
% toc
% 
% table4_2m_0=zeros(8,1);
% table4_2m_1=zeros(8,1);
% table4_2m_2=zeros(8,1);
% table4_2m_3=zeros(8,1);
% table4_2m_4=zeros(8,1);
% table4_2m_5=zeros(8,1);
% table4_2m_6=zeros(8,1);
% table4_2m_7=zeros(8,1);
% table4_2m_8=zeros(8,1);
% table4_2m_9=zeros(8,1);
% table4_2m_10=zeros(8,1);
% table4_2m_11=zeros(8,1);
% parfor i=1:8;
%     if i==1;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=2;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_2m_0(i,1) table4_2m_1(i,1) table4_2m_2(i,1) table4_2m_3(i,1) table4_2m_4(i,1) table4_2m_5(i,1) table4_2m_6(i,1) table4_2m_7(i,1) table4_2m_8(i,1) table4_2m_9(i,1) table4_2m_10(i,1) table4_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==2;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=3;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_2m_0(i,1) table4_2m_1(i,1) table4_2m_2(i,1) table4_2m_3(i,1) table4_2m_4(i,1) table4_2m_5(i,1) table4_2m_6(i,1) table4_2m_7(i,1) table4_2m_8(i,1) table4_2m_9(i,1) table4_2m_10(i,1) table4_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==3;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=4;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_2m_0(i,1) table4_2m_1(i,1) table4_2m_2(i,1) table4_2m_3(i,1) table4_2m_4(i,1) table4_2m_5(i,1) table4_2m_6(i,1) table4_2m_7(i,1) table4_2m_8(i,1) table4_2m_9(i,1) table4_2m_10(i,1) table4_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==4;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=5;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_2m_0(i,1) table4_2m_1(i,1) table4_2m_2(i,1) table4_2m_3(i,1) table4_2m_4(i,1) table4_2m_5(i,1) table4_2m_6(i,1) table4_2m_7(i,1) table4_2m_8(i,1) table4_2m_9(i,1) table4_2m_10(i,1) table4_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==5;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=6;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_2m_0(i,1) table4_2m_1(i,1) table4_2m_2(i,1) table4_2m_3(i,1) table4_2m_4(i,1) table4_2m_5(i,1) table4_2m_6(i,1) table4_2m_7(i,1) table4_2m_8(i,1) table4_2m_9(i,1) table4_2m_10(i,1) table4_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==6;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=7;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_2m_0(i,1) table4_2m_1(i,1) table4_2m_2(i,1) table4_2m_3(i,1) table4_2m_4(i,1) table4_2m_5(i,1) table4_2m_6(i,1) table4_2m_7(i,1) table4_2m_8(i,1) table4_2m_9(i,1) table4_2m_10(i,1) table4_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==7;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=8;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_2m_0(i,1) table4_2m_1(i,1) table4_2m_2(i,1) table4_2m_3(i,1) table4_2m_4(i,1) table4_2m_5(i,1) table4_2m_6(i,1) table4_2m_7(i,1) table4_2m_8(i,1) table4_2m_9(i,1) table4_2m_10(i,1) table4_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==8;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=9;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_2m_0(i,1) table4_2m_1(i,1) table4_2m_2(i,1) table4_2m_3(i,1) table4_2m_4(i,1) table4_2m_5(i,1) table4_2m_6(i,1) table4_2m_7(i,1) table4_2m_8(i,1) table4_2m_9(i,1) table4_2m_10(i,1) table4_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     end;
% end;
% table4_2m=[table4_2m_0(:,1) table4_2m_1(:,1) table4_2m_2(:,1) table4_2m_3(:,1) table4_2m_4(:,1) table4_2m_5(:,1) table4_2m_6(:,1) table4_2m_7(:,1) table4_2m_8(:,1) table4_2m_9(:,1) table4_2m_10(:,1) table4_2m_11(:,1)];
% save LTCI_partner_tables table*
% toc
% 
% table5m_0=zeros(8,1);
% table5m_1=zeros(8,1);
% table5m_2=zeros(8,1);
% table5m_3=zeros(8,1);
% table5m_4=zeros(8,1);
% table5m_5=zeros(8,1);
% table5m_6=zeros(8,1);
% table5m_7=zeros(8,1);
% table5m_8=zeros(8,1);
% table5m_9=zeros(8,1);
% table5m_10=zeros(8,1);
% table5m_11=zeros(8,1);
% parfor i=1:8;
%     if i==1;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=2;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=1;sick_T=36;hcdaycount=1;NY=0;
%         [table5m_0(i,1) table5m_1(i,1) table5m_2(i,1) table5m_3(i,1) table5m_4(i,1) table5m_5(i,1) table5m_6(i,1) table5m_7(i,1) table5m_8(i,1) table5m_9(i,1) table5m_10(i,1) table5m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==2;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=3;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=1;sick_T=36;hcdaycount=1;NY=0;
%         [table5m_0(i,1) table5m_1(i,1) table5m_2(i,1) table5m_3(i,1) table5m_4(i,1) table5m_5(i,1) table5m_6(i,1) table5m_7(i,1) table5m_8(i,1) table5m_9(i,1) table5m_10(i,1) table5m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==3;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=4;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=1;sick_T=36;hcdaycount=1;NY=0;
%         [table5m_0(i,1) table5m_1(i,1) table5m_2(i,1) table5m_3(i,1) table5m_4(i,1) table5m_5(i,1) table5m_6(i,1) table5m_7(i,1) table5m_8(i,1) table5m_9(i,1) table5m_10(i,1) table5m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==4;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=5;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=1;sick_T=36;hcdaycount=1;NY=0;
%         [table5m_0(i,1) table5m_1(i,1) table5m_2(i,1) table5m_3(i,1) table5m_4(i,1) table5m_5(i,1) table5m_6(i,1) table5m_7(i,1) table5m_8(i,1) table5m_9(i,1) table5m_10(i,1) table5m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==5;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=6;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=1;sick_T=36;hcdaycount=1;NY=0;
%         [table5m_0(i,1) table5m_1(i,1) table5m_2(i,1) table5m_3(i,1) table5m_4(i,1) table5m_5(i,1) table5m_6(i,1) table5m_7(i,1) table5m_8(i,1) table5m_9(i,1) table5m_10(i,1) table5m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==6;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=7;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=1;sick_T=36;hcdaycount=1;NY=0;
%         [table5m_0(i,1) table5m_1(i,1) table5m_2(i,1) table5m_3(i,1) table5m_4(i,1) table5m_5(i,1) table5m_6(i,1) table5m_7(i,1) table5m_8(i,1) table5m_9(i,1) table5m_10(i,1) table5m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==7;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=8;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=1;sick_T=36;hcdaycount=1;NY=0;
%         [table5m_0(i,1) table5m_1(i,1) table5m_2(i,1) table5m_3(i,1) table5m_4(i,1) table5m_5(i,1) table5m_6(i,1) table5m_7(i,1) table5m_8(i,1) table5m_9(i,1) table5m_10(i,1) table5m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==8;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=9;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=1;sick_T=36;hcdaycount=1;NY=0;
%         [table5m_0(i,1) table5m_1(i,1) table5m_2(i,1) table5m_3(i,1) table5m_4(i,1) table5m_5(i,1) table5m_6(i,1) table5m_7(i,1) table5m_8(i,1) table5m_9(i,1) table5m_10(i,1) table5m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     end;
% end;
% table5m=[table5m_0(:,1) table5m_1(:,1) table5m_2(:,1) table5m_3(:,1) table5m_4(:,1) table5m_5(:,1) table5m_6(:,1) table5m_7(:,1) table5m_8(:,1) table5m_9(:,1) table5m_10(:,1) table5m_11(:,1)];
% save LTCI_partner_tables table*
% toc
% 
% table6m_0=zeros(8,1);
% table6m_1=zeros(8,1);
% table6m_2=zeros(8,1);
% table6m_3=zeros(8,1);
% table6m_4=zeros(8,1);
% table6m_5=zeros(8,1);
% table6m_6=zeros(8,1);
% table6m_7=zeros(8,1);
% table6m_8=zeros(8,1);
% table6m_9=zeros(8,1);
% table6m_10=zeros(8,1);
% table6m_11=zeros(8,1);
% parfor i=1:8;
%     if i==1;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=2;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table6m_0(i,1) table6m_1(i,1) table6m_2(i,1) table6m_3(i,1) table6m_4(i,1) table6m_5(i,1) table6m_6(i,1) table6m_7(i,1) table6m_8(i,1) table6m_9(i,1) table6m_10(i,1) table6m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==2;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=3;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table6m_0(i,1) table6m_1(i,1) table6m_2(i,1) table6m_3(i,1) table6m_4(i,1) table6m_5(i,1) table6m_6(i,1) table6m_7(i,1) table6m_8(i,1) table6m_9(i,1) table6m_10(i,1) table6m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==3;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=4;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table6m_0(i,1) table6m_1(i,1) table6m_2(i,1) table6m_3(i,1) table6m_4(i,1) table6m_5(i,1) table6m_6(i,1) table6m_7(i,1) table6m_8(i,1) table6m_9(i,1) table6m_10(i,1) table6m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==4;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=5;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table6m_0(i,1) table6m_1(i,1) table6m_2(i,1) table6m_3(i,1) table6m_4(i,1) table6m_5(i,1) table6m_6(i,1) table6m_7(i,1) table6m_8(i,1) table6m_9(i,1) table6m_10(i,1) table6m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==5;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=6;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table6m_0(i,1) table6m_1(i,1) table6m_2(i,1) table6m_3(i,1) table6m_4(i,1) table6m_5(i,1) table6m_6(i,1) table6m_7(i,1) table6m_8(i,1) table6m_9(i,1) table6m_10(i,1) table6m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==6;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=7;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table6m_0(i,1) table6m_1(i,1) table6m_2(i,1) table6m_3(i,1) table6m_4(i,1) table6m_5(i,1) table6m_6(i,1) table6m_7(i,1) table6m_8(i,1) table6m_9(i,1) table6m_10(i,1) table6m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==7;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=8;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table6m_0(i,1) table6m_1(i,1) table6m_2(i,1) table6m_3(i,1) table6m_4(i,1) table6m_5(i,1) table6m_6(i,1) table6m_7(i,1) table6m_8(i,1) table6m_9(i,1) table6m_10(i,1) table6m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==8;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=9;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table6m_0(i,1) table6m_1(i,1) table6m_2(i,1) table6m_3(i,1) table6m_4(i,1) table6m_5(i,1) table6m_6(i,1) table6m_7(i,1) table6m_8(i,1) table6m_9(i,1) table6m_10(i,1) table6m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     end;
% end;
% table6m=[table6m_0(:,1) table6m_1(:,1) table6m_2(:,1) table6m_3(:,1) table6m_4(:,1) table6m_5(:,1) table6m_6(:,1) table6m_7(:,1) table6m_8(:,1) table6m_9(:,1) table6m_10(:,1) table6m_11(:,1)];
% save LTCI_partner_tables table*
% toc
% 
% table7m_0=zeros(8,1);
% table7m_1=zeros(8,1);
% table7m_2=zeros(8,1);
% table7m_3=zeros(8,1);
% table7m_4=zeros(8,1);
% table7m_5=zeros(8,1);
% table7m_6=zeros(8,1);
% table7m_7=zeros(8,1);
% table7m_8=zeros(8,1);
% table7m_9=zeros(8,1);
% table7m_10=zeros(8,1);
% table7m_11=zeros(8,1);
% parfor i=1:8;
%     if i==1;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=2;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table7m_0(i,1) table7m_1(i,1) table7m_2(i,1) table7m_3(i,1) table7m_4(i,1) table7m_5(i,1) table7m_6(i,1) table7m_7(i,1) table7m_8(i,1) table7m_9(i,1) table7m_10(i,1) table7m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==2;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=3;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table7m_0(i,1) table7m_1(i,1) table7m_2(i,1) table7m_3(i,1) table7m_4(i,1) table7m_5(i,1) table7m_6(i,1) table7m_7(i,1) table7m_8(i,1) table7m_9(i,1) table7m_10(i,1) table7m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==3;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=4;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table7m_0(i,1) table7m_1(i,1) table7m_2(i,1) table7m_3(i,1) table7m_4(i,1) table7m_5(i,1) table7m_6(i,1) table7m_7(i,1) table7m_8(i,1) table7m_9(i,1) table7m_10(i,1) table7m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==4;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=5;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table7m_0(i,1) table7m_1(i,1) table7m_2(i,1) table7m_3(i,1) table7m_4(i,1) table7m_5(i,1) table7m_6(i,1) table7m_7(i,1) table7m_8(i,1) table7m_9(i,1) table7m_10(i,1) table7m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==5;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=6;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table7m_0(i,1) table7m_1(i,1) table7m_2(i,1) table7m_3(i,1) table7m_4(i,1) table7m_5(i,1) table7m_6(i,1) table7m_7(i,1) table7m_8(i,1) table7m_9(i,1) table7m_10(i,1) table7m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==6;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=7;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table7m_0(i,1) table7m_1(i,1) table7m_2(i,1) table7m_3(i,1) table7m_4(i,1) table7m_5(i,1) table7m_6(i,1) table7m_7(i,1) table7m_8(i,1) table7m_9(i,1) table7m_10(i,1) table7m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==7;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=8;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table7m_0(i,1) table7m_1(i,1) table7m_2(i,1) table7m_3(i,1) table7m_4(i,1) table7m_5(i,1) table7m_6(i,1) table7m_7(i,1) table7m_8(i,1) table7m_9(i,1) table7m_10(i,1) table7m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==8;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=9;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table7m_0(i,1) table7m_1(i,1) table7m_2(i,1) table7m_3(i,1) table7m_4(i,1) table7m_5(i,1) table7m_6(i,1) table7m_7(i,1) table7m_8(i,1) table7m_9(i,1) table7m_10(i,1) table7m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     end;
% end;
% table7m=[table7m_0(:,1) table7m_1(:,1) table7m_2(:,1) table7m_3(:,1) table7m_4(:,1) table7m_5(:,1) table7m_6(:,1) table7m_7(:,1) table7m_8(:,1) table7m_9(:,1) table7m_10(:,1) table7m_11(:,1)];
% save LTCI_partner_tables table*
% toc
% 
% table0_1f_0=zeros(8,1);
% table0_1f_1=zeros(8,1);
% table0_1f_2=zeros(8,1);
% table0_1f_3=zeros(8,1);
% table0_1f_4=zeros(8,1);
% table0_1f_5=zeros(8,1);
% table0_1f_6=zeros(8,1);
% table0_1f_7=zeros(8,1);
% table0_1f_8=zeros(8,1);
% table0_1f_9=zeros(8,1);
% table0_1f_10=zeros(8,1);
% table0_1f_11=zeros(8,1);
% parfor i=1:8;
%     if i==1;
%         crra=3;rho=0.03;r=0.03;inf=0.03;rmg=0.015;nbg=0;wealth=2;bencap_hc=0.1;bencap_alf=0.1;bencap_nh=0.1;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table0_1f_0(i,1) table0_1f_1(i,1) table0_1f_2(i,1) table0_1f_3(i,1) table0_1f_4(i,1) table0_1f_5(i,1) table0_1f_6(i,1) table0_1f_7(i,1) table0_1f_8(i,1) table0_1f_9(i,1) table0_1f_10(i,1) table0_1f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==2;
%         crra=3;rho=0.03;r=0.03;inf=0.03;rmg=0.015;nbg=0;wealth=3;bencap_hc=0.1;bencap_alf=0.1;bencap_nh=0.1;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table0_1f_0(i,1) table0_1f_1(i,1) table0_1f_2(i,1) table0_1f_3(i,1) table0_1f_4(i,1) table0_1f_5(i,1) table0_1f_6(i,1) table0_1f_7(i,1) table0_1f_8(i,1) table0_1f_9(i,1) table0_1f_10(i,1) table0_1f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==3;
%         crra=3;rho=0.03;r=0.03;inf=0.03;rmg=0.015;nbg=0;wealth=4;bencap_hc=0.1;bencap_alf=0.1;bencap_nh=0.1;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table0_1f_0(i,1) table0_1f_1(i,1) table0_1f_2(i,1) table0_1f_3(i,1) table0_1f_4(i,1) table0_1f_5(i,1) table0_1f_6(i,1) table0_1f_7(i,1) table0_1f_8(i,1) table0_1f_9(i,1) table0_1f_10(i,1) table0_1f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==4;
%         crra=3;rho=0.03;r=0.03;inf=0.03;rmg=0.015;nbg=0;wealth=5;bencap_hc=0.1;bencap_alf=0.1;bencap_nh=0.1;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table0_1f_0(i,1) table0_1f_1(i,1) table0_1f_2(i,1) table0_1f_3(i,1) table0_1f_4(i,1) table0_1f_5(i,1) table0_1f_6(i,1) table0_1f_7(i,1) table0_1f_8(i,1) table0_1f_9(i,1) table0_1f_10(i,1) table0_1f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==5;
%         crra=3;rho=0.03;r=0.03;inf=0.03;rmg=0.015;nbg=0;wealth=6;bencap_hc=0.1;bencap_alf=0.1;bencap_nh=0.1;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table0_1f_0(i,1) table0_1f_1(i,1) table0_1f_2(i,1) table0_1f_3(i,1) table0_1f_4(i,1) table0_1f_5(i,1) table0_1f_6(i,1) table0_1f_7(i,1) table0_1f_8(i,1) table0_1f_9(i,1) table0_1f_10(i,1) table0_1f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==6;
%         crra=3;rho=0.03;r=0.03;inf=0.03;rmg=0.015;nbg=0;wealth=7;bencap_hc=0.1;bencap_alf=0.1;bencap_nh=0.1;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table0_1f_0(i,1) table0_1f_1(i,1) table0_1f_2(i,1) table0_1f_3(i,1) table0_1f_4(i,1) table0_1f_5(i,1) table0_1f_6(i,1) table0_1f_7(i,1) table0_1f_8(i,1) table0_1f_9(i,1) table0_1f_10(i,1) table0_1f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==7;
%         crra=3;rho=0.03;r=0.03;inf=0.03;rmg=0.015;nbg=0;wealth=8;bencap_hc=0.1;bencap_alf=0.1;bencap_nh=0.1;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table0_1f_0(i,1) table0_1f_1(i,1) table0_1f_2(i,1) table0_1f_3(i,1) table0_1f_4(i,1) table0_1f_5(i,1) table0_1f_6(i,1) table0_1f_7(i,1) table0_1f_8(i,1) table0_1f_9(i,1) table0_1f_10(i,1) table0_1f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==8;
%         crra=3;rho=0.03;r=0.03;inf=0.03;rmg=0.015;nbg=0;wealth=9;bencap_hc=0.1;bencap_alf=0.1;bencap_nh=0.1;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table0_1f_0(i,1) table0_1f_1(i,1) table0_1f_2(i,1) table0_1f_3(i,1) table0_1f_4(i,1) table0_1f_5(i,1) table0_1f_6(i,1) table0_1f_7(i,1) table0_1f_8(i,1) table0_1f_9(i,1) table0_1f_10(i,1) table0_1f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     end;
% end;
% table0_1f=[table0_1f_0(:,1) table0_1f_1(:,1) table0_1f_2(:,1) table0_1f_3(:,1) table0_1f_4(:,1) table0_1f_5(:,1) table0_1f_6(:,1) table0_1f_7(:,1) table0_1f_8(:,1) table0_1f_9(:,1) table0_1f_10(:,1) table0_1f_11(:,1)];
% save LTCI_partner_tables table*
% toc
% 
% table0_2f_0=zeros(8,1);
% table0_2f_1=zeros(8,1);
% table0_2f_2=zeros(8,1);
% table0_2f_3=zeros(8,1);
% table0_2f_4=zeros(8,1);
% table0_2f_5=zeros(8,1);
% table0_2f_6=zeros(8,1);
% table0_2f_7=zeros(8,1);
% table0_2f_8=zeros(8,1);
% table0_2f_9=zeros(8,1);
% table0_2f_10=zeros(8,1);
% table0_2f_11=zeros(8,1);
% parfor i=1:8;
%     if i==1;
%         crra=3;rho=0.03;r=0.03;inf=0.03;rmg=0.015;nbg=0;wealth=2;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table0_2f_0(i,1) table0_2f_1(i,1) table0_2f_2(i,1) table0_2f_3(i,1) table0_2f_4(i,1) table0_2f_5(i,1) table0_2f_6(i,1) table0_2f_7(i,1) table0_2f_8(i,1) table0_2f_9(i,1) table0_2f_10(i,1) table0_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==2;
%         crra=3;rho=0.03;r=0.03;inf=0.03;rmg=0.015;nbg=0;wealth=3;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table0_2f_0(i,1) table0_2f_1(i,1) table0_2f_2(i,1) table0_2f_3(i,1) table0_2f_4(i,1) table0_2f_5(i,1) table0_2f_6(i,1) table0_2f_7(i,1) table0_2f_8(i,1) table0_2f_9(i,1) table0_2f_10(i,1) table0_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==3;
%         crra=3;rho=0.03;r=0.03;inf=0.03;rmg=0.015;nbg=0;wealth=4;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table0_2f_0(i,1) table0_2f_1(i,1) table0_2f_2(i,1) table0_2f_3(i,1) table0_2f_4(i,1) table0_2f_5(i,1) table0_2f_6(i,1) table0_2f_7(i,1) table0_2f_8(i,1) table0_2f_9(i,1) table0_2f_10(i,1) table0_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==4;
%         crra=3;rho=0.03;r=0.03;inf=0.03;rmg=0.015;nbg=0;wealth=5;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table0_2f_0(i,1) table0_2f_1(i,1) table0_2f_2(i,1) table0_2f_3(i,1) table0_2f_4(i,1) table0_2f_5(i,1) table0_2f_6(i,1) table0_2f_7(i,1) table0_2f_8(i,1) table0_2f_9(i,1) table0_2f_10(i,1) table0_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==5;
%         crra=3;rho=0.03;r=0.03;inf=0.03;rmg=0.015;nbg=0;wealth=6;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table0_2f_0(i,1) table0_2f_1(i,1) table0_2f_2(i,1) table0_2f_3(i,1) table0_2f_4(i,1) table0_2f_5(i,1) table0_2f_6(i,1) table0_2f_7(i,1) table0_2f_8(i,1) table0_2f_9(i,1) table0_2f_10(i,1) table0_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==6;
%         crra=3;rho=0.03;r=0.03;inf=0.03;rmg=0.015;nbg=0;wealth=7;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table0_2f_0(i,1) table0_2f_1(i,1) table0_2f_2(i,1) table0_2f_3(i,1) table0_2f_4(i,1) table0_2f_5(i,1) table0_2f_6(i,1) table0_2f_7(i,1) table0_2f_8(i,1) table0_2f_9(i,1) table0_2f_10(i,1) table0_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==7;
%         crra=3;rho=0.03;r=0.03;inf=0.03;rmg=0.015;nbg=0;wealth=8;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table0_2f_0(i,1) table0_2f_1(i,1) table0_2f_2(i,1) table0_2f_3(i,1) table0_2f_4(i,1) table0_2f_5(i,1) table0_2f_6(i,1) table0_2f_7(i,1) table0_2f_8(i,1) table0_2f_9(i,1) table0_2f_10(i,1) table0_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==8;
%         crra=3;rho=0.03;r=0.03;inf=0.03;rmg=0.015;nbg=0;wealth=9;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table0_2f_0(i,1) table0_2f_1(i,1) table0_2f_2(i,1) table0_2f_3(i,1) table0_2f_4(i,1) table0_2f_5(i,1) table0_2f_6(i,1) table0_2f_7(i,1) table0_2f_8(i,1) table0_2f_9(i,1) table0_2f_10(i,1) table0_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     end;
% end;
% table0_2f=[table0_2f_0(:,1) table0_2f_1(:,1) table0_2f_2(:,1) table0_2f_3(:,1) table0_2f_4(:,1) table0_2f_5(:,1) table0_2f_6(:,1) table0_2f_7(:,1) table0_2f_8(:,1) table0_2f_9(:,1) table0_2f_10(:,1) table0_2f_11(:,1)];
% save LTCI_partner_tables table*
% toc
% 
% table1f_0=zeros(8,1);
% table1f_1=zeros(8,1);
% table1f_2=zeros(8,1);
% table1f_3=zeros(8,1);
% table1f_4=zeros(8,1);
% table1f_5=zeros(8,1);
% table1f_6=zeros(8,1);
% table1f_7=zeros(8,1);
% table1f_8=zeros(8,1);
% table1f_9=zeros(8,1);
% table1f_10=zeros(8,1);
% table1f_11=zeros(8,1);
% parfor i=1:8;
%     if i==1;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=2;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table1f_0(i,1) table1f_1(i,1) table1f_2(i,1) table1f_3(i,1) table1f_4(i,1) table1f_5(i,1) table1f_6(i,1) table1f_7(i,1) table1f_8(i,1) table1f_9(i,1) table1f_10(i,1) table1f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==2;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=3;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table1f_0(i,1) table1f_1(i,1) table1f_2(i,1) table1f_3(i,1) table1f_4(i,1) table1f_5(i,1) table1f_6(i,1) table1f_7(i,1) table1f_8(i,1) table1f_9(i,1) table1f_10(i,1) table1f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==3;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=4;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table1f_0(i,1) table1f_1(i,1) table1f_2(i,1) table1f_3(i,1) table1f_4(i,1) table1f_5(i,1) table1f_6(i,1) table1f_7(i,1) table1f_8(i,1) table1f_9(i,1) table1f_10(i,1) table1f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==4;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=5;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table1f_0(i,1) table1f_1(i,1) table1f_2(i,1) table1f_3(i,1) table1f_4(i,1) table1f_5(i,1) table1f_6(i,1) table1f_7(i,1) table1f_8(i,1) table1f_9(i,1) table1f_10(i,1) table1f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==5;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=6;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table1f_0(i,1) table1f_1(i,1) table1f_2(i,1) table1f_3(i,1) table1f_4(i,1) table1f_5(i,1) table1f_6(i,1) table1f_7(i,1) table1f_8(i,1) table1f_9(i,1) table1f_10(i,1) table1f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==6;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=7;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table1f_0(i,1) table1f_1(i,1) table1f_2(i,1) table1f_3(i,1) table1f_4(i,1) table1f_5(i,1) table1f_6(i,1) table1f_7(i,1) table1f_8(i,1) table1f_9(i,1) table1f_10(i,1) table1f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==7;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=8;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table1f_0(i,1) table1f_1(i,1) table1f_2(i,1) table1f_3(i,1) table1f_4(i,1) table1f_5(i,1) table1f_6(i,1) table1f_7(i,1) table1f_8(i,1) table1f_9(i,1) table1f_10(i,1) table1f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==8;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=9;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table1f_0(i,1) table1f_1(i,1) table1f_2(i,1) table1f_3(i,1) table1f_4(i,1) table1f_5(i,1) table1f_6(i,1) table1f_7(i,1) table1f_8(i,1) table1f_9(i,1) table1f_10(i,1) table1f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     end;
% end;
% table1f=[table1f_0(:,1) table1f_1(:,1) table1f_2(:,1) table1f_3(:,1) table1f_4(:,1) table1f_5(:,1) table1f_6(:,1) table1f_7(:,1) table1f_8(:,1) table1f_9(:,1) table1f_10(:,1) table1f_11(:,1)];
% save LTCI_partner_tables table*
% toc
% 
% table2f_0=zeros(8,1);
% table2f_1=zeros(8,1);
% table2f_2=zeros(8,1);
% table2f_3=zeros(8,1);
% table2f_4=zeros(8,1);
% table2f_5=zeros(8,1);
% table2f_6=zeros(8,1);
% table2f_7=zeros(8,1);
% table2f_8=zeros(8,1);
% table2f_9=zeros(8,1);
% table2f_10=zeros(8,1);
% table2f_11=zeros(8,1);
% parfor i=1:8;
%     if i==1;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0;wealth=2;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table2f_0(i,1) table2f_1(i,1) table2f_2(i,1) table2f_3(i,1) table2f_4(i,1) table2f_5(i,1) table2f_6(i,1) table2f_7(i,1) table2f_8(i,1) table2f_9(i,1) table2f_10(i,1) table2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==2;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0;wealth=3;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table2f_0(i,1) table2f_1(i,1) table2f_2(i,1) table2f_3(i,1) table2f_4(i,1) table2f_5(i,1) table2f_6(i,1) table2f_7(i,1) table2f_8(i,1) table2f_9(i,1) table2f_10(i,1) table2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==3;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0;wealth=4;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table2f_0(i,1) table2f_1(i,1) table2f_2(i,1) table2f_3(i,1) table2f_4(i,1) table2f_5(i,1) table2f_6(i,1) table2f_7(i,1) table2f_8(i,1) table2f_9(i,1) table2f_10(i,1) table2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==4;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0;wealth=5;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table2f_0(i,1) table2f_1(i,1) table2f_2(i,1) table2f_3(i,1) table2f_4(i,1) table2f_5(i,1) table2f_6(i,1) table2f_7(i,1) table2f_8(i,1) table2f_9(i,1) table2f_10(i,1) table2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==5;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0;wealth=6;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table2f_0(i,1) table2f_1(i,1) table2f_2(i,1) table2f_3(i,1) table2f_4(i,1) table2f_5(i,1) table2f_6(i,1) table2f_7(i,1) table2f_8(i,1) table2f_9(i,1) table2f_10(i,1) table2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==6;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0;wealth=7;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table2f_0(i,1) table2f_1(i,1) table2f_2(i,1) table2f_3(i,1) table2f_4(i,1) table2f_5(i,1) table2f_6(i,1) table2f_7(i,1) table2f_8(i,1) table2f_9(i,1) table2f_10(i,1) table2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==7;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0;wealth=8;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table2f_0(i,1) table2f_1(i,1) table2f_2(i,1) table2f_3(i,1) table2f_4(i,1) table2f_5(i,1) table2f_6(i,1) table2f_7(i,1) table2f_8(i,1) table2f_9(i,1) table2f_10(i,1) table2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==8;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0;wealth=9;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table2f_0(i,1) table2f_1(i,1) table2f_2(i,1) table2f_3(i,1) table2f_4(i,1) table2f_5(i,1) table2f_6(i,1) table2f_7(i,1) table2f_8(i,1) table2f_9(i,1) table2f_10(i,1) table2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     end;
% end;
% table2f=[table2f_0(:,1) table2f_1(:,1) table2f_2(:,1) table2f_3(:,1) table2f_4(:,1) table2f_5(:,1) table2f_6(:,1) table2f_7(:,1) table2f_8(:,1) table2f_9(:,1) table2f_10(:,1) table2f_11(:,1)];
% save LTCI_partner_tables table*
% toc
% 
% table3f_0=zeros(8,1);
% table3f_1=zeros(8,1);
% table3f_2=zeros(8,1);
% table3f_3=zeros(8,1);
% table3f_4=zeros(8,1);
% table3f_5=zeros(8,1);
% table3f_6=zeros(8,1);
% table3f_7=zeros(8,1);
% table3f_8=zeros(8,1);
% table3f_9=zeros(8,1);
% table3f_10=zeros(8,1);
% table3f_11=zeros(8,1);
% parfor i=1:8;
%     if i==1;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=2;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table3f_0(i,1) table3f_1(i,1) table3f_2(i,1) table3f_3(i,1) table3f_4(i,1) table3f_5(i,1) table3f_6(i,1) table3f_7(i,1) table3f_8(i,1) table3f_9(i,1) table3f_10(i,1) table3f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==2;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=3;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table3f_0(i,1) table3f_1(i,1) table3f_2(i,1) table3f_3(i,1) table3f_4(i,1) table3f_5(i,1) table3f_6(i,1) table3f_7(i,1) table3f_8(i,1) table3f_9(i,1) table3f_10(i,1) table3f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==3;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=4;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table3f_0(i,1) table3f_1(i,1) table3f_2(i,1) table3f_3(i,1) table3f_4(i,1) table3f_5(i,1) table3f_6(i,1) table3f_7(i,1) table3f_8(i,1) table3f_9(i,1) table3f_10(i,1) table3f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==4;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=5;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table3f_0(i,1) table3f_1(i,1) table3f_2(i,1) table3f_3(i,1) table3f_4(i,1) table3f_5(i,1) table3f_6(i,1) table3f_7(i,1) table3f_8(i,1) table3f_9(i,1) table3f_10(i,1) table3f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==5;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=6;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table3f_0(i,1) table3f_1(i,1) table3f_2(i,1) table3f_3(i,1) table3f_4(i,1) table3f_5(i,1) table3f_6(i,1) table3f_7(i,1) table3f_8(i,1) table3f_9(i,1) table3f_10(i,1) table3f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==6;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=7;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table3f_0(i,1) table3f_1(i,1) table3f_2(i,1) table3f_3(i,1) table3f_4(i,1) table3f_5(i,1) table3f_6(i,1) table3f_7(i,1) table3f_8(i,1) table3f_9(i,1) table3f_10(i,1) table3f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==7;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=8;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table3f_0(i,1) table3f_1(i,1) table3f_2(i,1) table3f_3(i,1) table3f_4(i,1) table3f_5(i,1) table3f_6(i,1) table3f_7(i,1) table3f_8(i,1) table3f_9(i,1) table3f_10(i,1) table3f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==8;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=9;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table3f_0(i,1) table3f_1(i,1) table3f_2(i,1) table3f_3(i,1) table3f_4(i,1) table3f_5(i,1) table3f_6(i,1) table3f_7(i,1) table3f_8(i,1) table3f_9(i,1) table3f_10(i,1) table3f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     end;
% end;
% table3f=[table3f_0(:,1) table3f_1(:,1) table3f_2(:,1) table3f_3(:,1) table3f_4(:,1) table3f_5(:,1) table3f_6(:,1) table3f_7(:,1) table3f_8(:,1) table3f_9(:,1) table3f_10(:,1) table3f_11(:,1)];
% save LTCI_partner_tables table*
% toc
% 
% table4_1f_0=zeros(8,1);
% table4_1f_1=zeros(8,1);
% table4_1f_2=zeros(8,1);
% table4_1f_3=zeros(8,1);
% table4_1f_4=zeros(8,1);
% table4_1f_5=zeros(8,1);
% table4_1f_6=zeros(8,1);
% table4_1f_7=zeros(8,1);
% table4_1f_8=zeros(8,1);
% table4_1f_9=zeros(8,1);
% table4_1f_10=zeros(8,1);
% table4_1f_11=zeros(8,1);
% parfor i=1:8;
%     if i==1;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=2;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_1f_0(i,1) table4_1f_1(i,1) table4_1f_2(i,1) table4_1f_3(i,1) table4_1f_4(i,1) table4_1f_5(i,1) table4_1f_6(i,1) table4_1f_7(i,1) table4_1f_8(i,1) table4_1f_9(i,1) table4_1f_10(i,1) table4_1f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==2;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=3;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_1f_0(i,1) table4_1f_1(i,1) table4_1f_2(i,1) table4_1f_3(i,1) table4_1f_4(i,1) table4_1f_5(i,1) table4_1f_6(i,1) table4_1f_7(i,1) table4_1f_8(i,1) table4_1f_9(i,1) table4_1f_10(i,1) table4_1f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==3;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=4;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_1f_0(i,1) table4_1f_1(i,1) table4_1f_2(i,1) table4_1f_3(i,1) table4_1f_4(i,1) table4_1f_5(i,1) table4_1f_6(i,1) table4_1f_7(i,1) table4_1f_8(i,1) table4_1f_9(i,1) table4_1f_10(i,1) table4_1f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==4;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=5;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_1f_0(i,1) table4_1f_1(i,1) table4_1f_2(i,1) table4_1f_3(i,1) table4_1f_4(i,1) table4_1f_5(i,1) table4_1f_6(i,1) table4_1f_7(i,1) table4_1f_8(i,1) table4_1f_9(i,1) table4_1f_10(i,1) table4_1f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==5;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=6;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_1f_0(i,1) table4_1f_1(i,1) table4_1f_2(i,1) table4_1f_3(i,1) table4_1f_4(i,1) table4_1f_5(i,1) table4_1f_6(i,1) table4_1f_7(i,1) table4_1f_8(i,1) table4_1f_9(i,1) table4_1f_10(i,1) table4_1f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==6;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=7;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_1f_0(i,1) table4_1f_1(i,1) table4_1f_2(i,1) table4_1f_3(i,1) table4_1f_4(i,1) table4_1f_5(i,1) table4_1f_6(i,1) table4_1f_7(i,1) table4_1f_8(i,1) table4_1f_9(i,1) table4_1f_10(i,1) table4_1f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==7;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=8;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_1f_0(i,1) table4_1f_1(i,1) table4_1f_2(i,1) table4_1f_3(i,1) table4_1f_4(i,1) table4_1f_5(i,1) table4_1f_6(i,1) table4_1f_7(i,1) table4_1f_8(i,1) table4_1f_9(i,1) table4_1f_10(i,1) table4_1f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==8;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=9;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_1f_0(i,1) table4_1f_1(i,1) table4_1f_2(i,1) table4_1f_3(i,1) table4_1f_4(i,1) table4_1f_5(i,1) table4_1f_6(i,1) table4_1f_7(i,1) table4_1f_8(i,1) table4_1f_9(i,1) table4_1f_10(i,1) table4_1f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     end;
% end;
% table4_1f=[table4_1f_0(:,1) table4_1f_1(:,1) table4_1f_2(:,1) table4_1f_3(:,1) table4_1f_4(:,1) table4_1f_5(:,1) table4_1f_6(:,1) table4_1f_7(:,1) table4_1f_8(:,1) table4_1f_9(:,1) table4_1f_10(:,1) table4_1f_11(:,1)];
% save LTCI_partner_tables table*
% toc
% 
% table4_2f_0=zeros(8,1);
% table4_2f_1=zeros(8,1);
% table4_2f_2=zeros(8,1);
% table4_2f_3=zeros(8,1);
% table4_2f_4=zeros(8,1);
% table4_2f_5=zeros(8,1);
% table4_2f_6=zeros(8,1);
% table4_2f_7=zeros(8,1);
% table4_2f_8=zeros(8,1);
% table4_2f_9=zeros(8,1);
% table4_2f_10=zeros(8,1);
% table4_2f_11=zeros(8,1);
% parfor i=1:8;
%     if i==1;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=2;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_2f_0(i,1) table4_2f_1(i,1) table4_2f_2(i,1) table4_2f_3(i,1) table4_2f_4(i,1) table4_2f_5(i,1) table4_2f_6(i,1) table4_2f_7(i,1) table4_2f_8(i,1) table4_2f_9(i,1) table4_2f_10(i,1) table4_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==2;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=3;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_2f_0(i,1) table4_2f_1(i,1) table4_2f_2(i,1) table4_2f_3(i,1) table4_2f_4(i,1) table4_2f_5(i,1) table4_2f_6(i,1) table4_2f_7(i,1) table4_2f_8(i,1) table4_2f_9(i,1) table4_2f_10(i,1) table4_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==3;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=4;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_2f_0(i,1) table4_2f_1(i,1) table4_2f_2(i,1) table4_2f_3(i,1) table4_2f_4(i,1) table4_2f_5(i,1) table4_2f_6(i,1) table4_2f_7(i,1) table4_2f_8(i,1) table4_2f_9(i,1) table4_2f_10(i,1) table4_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==4;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=5;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_2f_0(i,1) table4_2f_1(i,1) table4_2f_2(i,1) table4_2f_3(i,1) table4_2f_4(i,1) table4_2f_5(i,1) table4_2f_6(i,1) table4_2f_7(i,1) table4_2f_8(i,1) table4_2f_9(i,1) table4_2f_10(i,1) table4_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==5;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=6;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_2f_0(i,1) table4_2f_1(i,1) table4_2f_2(i,1) table4_2f_3(i,1) table4_2f_4(i,1) table4_2f_5(i,1) table4_2f_6(i,1) table4_2f_7(i,1) table4_2f_8(i,1) table4_2f_9(i,1) table4_2f_10(i,1) table4_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==6;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=7;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_2f_0(i,1) table4_2f_1(i,1) table4_2f_2(i,1) table4_2f_3(i,1) table4_2f_4(i,1) table4_2f_5(i,1) table4_2f_6(i,1) table4_2f_7(i,1) table4_2f_8(i,1) table4_2f_9(i,1) table4_2f_10(i,1) table4_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==7;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=8;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_2f_0(i,1) table4_2f_1(i,1) table4_2f_2(i,1) table4_2f_3(i,1) table4_2f_4(i,1) table4_2f_5(i,1) table4_2f_6(i,1) table4_2f_7(i,1) table4_2f_8(i,1) table4_2f_9(i,1) table4_2f_10(i,1) table4_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==8;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=9;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_2f_0(i,1) table4_2f_1(i,1) table4_2f_2(i,1) table4_2f_3(i,1) table4_2f_4(i,1) table4_2f_5(i,1) table4_2f_6(i,1) table4_2f_7(i,1) table4_2f_8(i,1) table4_2f_9(i,1) table4_2f_10(i,1) table4_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     end;
% end;
% table4_2f=[table4_2f_0(:,1) table4_2f_1(:,1) table4_2f_2(:,1) table4_2f_3(:,1) table4_2f_4(:,1) table4_2f_5(:,1) table4_2f_6(:,1) table4_2f_7(:,1) table4_2f_8(:,1) table4_2f_9(:,1) table4_2f_10(:,1) table4_2f_11(:,1)];
% save LTCI_partner_tables table*
% toc
% 
% table5f_0=zeros(8,1);
% table5f_1=zeros(8,1);
% table5f_2=zeros(8,1);
% table5f_3=zeros(8,1);
% table5f_4=zeros(8,1);
% table5f_5=zeros(8,1);
% table5f_6=zeros(8,1);
% table5f_7=zeros(8,1);
% table5f_8=zeros(8,1);
% table5f_9=zeros(8,1);
% table5f_10=zeros(8,1);
% table5f_11=zeros(8,1);
% parfor i=1:8;
%     if i==1;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=2;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=1;sick_T=36;hcdaycount=1;NY=0;
%         [table5f_0(i,1) table5f_1(i,1) table5f_2(i,1) table5f_3(i,1) table5f_4(i,1) table5f_5(i,1) table5f_6(i,1) table5f_7(i,1) table5f_8(i,1) table5f_9(i,1) table5f_10(i,1) table5f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==2;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=3;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=1;sick_T=36;hcdaycount=1;NY=0;
%         [table5f_0(i,1) table5f_1(i,1) table5f_2(i,1) table5f_3(i,1) table5f_4(i,1) table5f_5(i,1) table5f_6(i,1) table5f_7(i,1) table5f_8(i,1) table5f_9(i,1) table5f_10(i,1) table5f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==3;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=4;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=1;sick_T=36;hcdaycount=1;NY=0;
%         [table5f_0(i,1) table5f_1(i,1) table5f_2(i,1) table5f_3(i,1) table5f_4(i,1) table5f_5(i,1) table5f_6(i,1) table5f_7(i,1) table5f_8(i,1) table5f_9(i,1) table5f_10(i,1) table5f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==4;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=5;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=1;sick_T=36;hcdaycount=1;NY=0;
%         [table5f_0(i,1) table5f_1(i,1) table5f_2(i,1) table5f_3(i,1) table5f_4(i,1) table5f_5(i,1) table5f_6(i,1) table5f_7(i,1) table5f_8(i,1) table5f_9(i,1) table5f_10(i,1) table5f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==5;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=6;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=1;sick_T=36;hcdaycount=1;NY=0;
%         [table5f_0(i,1) table5f_1(i,1) table5f_2(i,1) table5f_3(i,1) table5f_4(i,1) table5f_5(i,1) table5f_6(i,1) table5f_7(i,1) table5f_8(i,1) table5f_9(i,1) table5f_10(i,1) table5f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==6;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=7;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=1;sick_T=36;hcdaycount=1;NY=0;
%         [table5f_0(i,1) table5f_1(i,1) table5f_2(i,1) table5f_3(i,1) table5f_4(i,1) table5f_5(i,1) table5f_6(i,1) table5f_7(i,1) table5f_8(i,1) table5f_9(i,1) table5f_10(i,1) table5f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==7;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=8;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=1;sick_T=36;hcdaycount=1;NY=0;
%         [table5f_0(i,1) table5f_1(i,1) table5f_2(i,1) table5f_3(i,1) table5f_4(i,1) table5f_5(i,1) table5f_6(i,1) table5f_7(i,1) table5f_8(i,1) table5f_9(i,1) table5f_10(i,1) table5f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==8;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=9;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=1;sick_T=36;hcdaycount=1;NY=0;
%         [table5f_0(i,1) table5f_1(i,1) table5f_2(i,1) table5f_3(i,1) table5f_4(i,1) table5f_5(i,1) table5f_6(i,1) table5f_7(i,1) table5f_8(i,1) table5f_9(i,1) table5f_10(i,1) table5f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     end;
% end;
% table5f=[table5f_0(:,1) table5f_1(:,1) table5f_2(:,1) table5f_3(:,1) table5f_4(:,1) table5f_5(:,1) table5f_6(:,1) table5f_7(:,1) table5f_8(:,1) table5f_9(:,1) table5f_10(:,1) table5f_11(:,1)];
% save LTCI_partner_tables table*
% toc
% 
% table6f_0=zeros(8,1);
% table6f_1=zeros(8,1);
% table6f_2=zeros(8,1);
% table6f_3=zeros(8,1);
% table6f_4=zeros(8,1);
% table6f_5=zeros(8,1);
% table6f_6=zeros(8,1);
% table6f_7=zeros(8,1);
% table6f_8=zeros(8,1);
% table6f_9=zeros(8,1);
% table6f_10=zeros(8,1);
% table6f_11=zeros(8,1);
% parfor i=1:8;
%     if i==1;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=2;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table6f_0(i,1) table6f_1(i,1) table6f_2(i,1) table6f_3(i,1) table6f_4(i,1) table6f_5(i,1) table6f_6(i,1) table6f_7(i,1) table6f_8(i,1) table6f_9(i,1) table6f_10(i,1) table6f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==2;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=3;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table6f_0(i,1) table6f_1(i,1) table6f_2(i,1) table6f_3(i,1) table6f_4(i,1) table6f_5(i,1) table6f_6(i,1) table6f_7(i,1) table6f_8(i,1) table6f_9(i,1) table6f_10(i,1) table6f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==3;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=4;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table6f_0(i,1) table6f_1(i,1) table6f_2(i,1) table6f_3(i,1) table6f_4(i,1) table6f_5(i,1) table6f_6(i,1) table6f_7(i,1) table6f_8(i,1) table6f_9(i,1) table6f_10(i,1) table6f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==4;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=5;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table6f_0(i,1) table6f_1(i,1) table6f_2(i,1) table6f_3(i,1) table6f_4(i,1) table6f_5(i,1) table6f_6(i,1) table6f_7(i,1) table6f_8(i,1) table6f_9(i,1) table6f_10(i,1) table6f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==5;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=6;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table6f_0(i,1) table6f_1(i,1) table6f_2(i,1) table6f_3(i,1) table6f_4(i,1) table6f_5(i,1) table6f_6(i,1) table6f_7(i,1) table6f_8(i,1) table6f_9(i,1) table6f_10(i,1) table6f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==6;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=7;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table6f_0(i,1) table6f_1(i,1) table6f_2(i,1) table6f_3(i,1) table6f_4(i,1) table6f_5(i,1) table6f_6(i,1) table6f_7(i,1) table6f_8(i,1) table6f_9(i,1) table6f_10(i,1) table6f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==7;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=8;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table6f_0(i,1) table6f_1(i,1) table6f_2(i,1) table6f_3(i,1) table6f_4(i,1) table6f_5(i,1) table6f_6(i,1) table6f_7(i,1) table6f_8(i,1) table6f_9(i,1) table6f_10(i,1) table6f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==8;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=9;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table6f_0(i,1) table6f_1(i,1) table6f_2(i,1) table6f_3(i,1) table6f_4(i,1) table6f_5(i,1) table6f_6(i,1) table6f_7(i,1) table6f_8(i,1) table6f_9(i,1) table6f_10(i,1) table6f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     end;
% end;
% table6f=[table6f_0(:,1) table6f_1(:,1) table6f_2(:,1) table6f_3(:,1) table6f_4(:,1) table6f_5(:,1) table6f_6(:,1) table6f_7(:,1) table6f_8(:,1) table6f_9(:,1) table6f_10(:,1) table6f_11(:,1)];
% save LTCI_partner_tables table*
% toc
% 
% table7f_0=zeros(8,1);
% table7f_1=zeros(8,1);
% table7f_2=zeros(8,1);
% table7f_3=zeros(8,1);
% table7f_4=zeros(8,1);
% table7f_5=zeros(8,1);
% table7f_6=zeros(8,1);
% table7f_7=zeros(8,1);
% table7f_8=zeros(8,1);
% table7f_9=zeros(8,1);
% table7f_10=zeros(8,1);
% table7f_11=zeros(8,1);
% parfor i=1:8;
%     if i==1;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=2;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=0;singlef=1;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table7f_0(i,1) table7f_1(i,1) table7f_2(i,1) table7f_3(i,1) table7f_4(i,1) table7f_5(i,1) table7f_6(i,1) table7f_7(i,1) table7f_8(i,1) table7f_9(i,1) table7f_10(i,1) table7f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==2;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=3;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=0;singlef=1;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table7f_0(i,1) table7f_1(i,1) table7f_2(i,1) table7f_3(i,1) table7f_4(i,1) table7f_5(i,1) table7f_6(i,1) table7f_7(i,1) table7f_8(i,1) table7f_9(i,1) table7f_10(i,1) table7f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==3;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=4;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=0;singlef=1;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table7f_0(i,1) table7f_1(i,1) table7f_2(i,1) table7f_3(i,1) table7f_4(i,1) table7f_5(i,1) table7f_6(i,1) table7f_7(i,1) table7f_8(i,1) table7f_9(i,1) table7f_10(i,1) table7f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==4;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=5;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=0;singlef=1;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table7f_0(i,1) table7f_1(i,1) table7f_2(i,1) table7f_3(i,1) table7f_4(i,1) table7f_5(i,1) table7f_6(i,1) table7f_7(i,1) table7f_8(i,1) table7f_9(i,1) table7f_10(i,1) table7f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==5;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=6;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=0;singlef=1;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table7f_0(i,1) table7f_1(i,1) table7f_2(i,1) table7f_3(i,1) table7f_4(i,1) table7f_5(i,1) table7f_6(i,1) table7f_7(i,1) table7f_8(i,1) table7f_9(i,1) table7f_10(i,1) table7f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==6;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=7;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=0;singlef=1;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table7f_0(i,1) table7f_1(i,1) table7f_2(i,1) table7f_3(i,1) table7f_4(i,1) table7f_5(i,1) table7f_6(i,1) table7f_7(i,1) table7f_8(i,1) table7f_9(i,1) table7f_10(i,1) table7f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==7;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=8;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=0;singlef=1;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table7f_0(i,1) table7f_1(i,1) table7f_2(i,1) table7f_3(i,1) table7f_4(i,1) table7f_5(i,1) table7f_6(i,1) table7f_7(i,1) table7f_8(i,1) table7f_9(i,1) table7f_10(i,1) table7f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==8;
%         crra=3;rho=0.03;r=0.03;inf=0.025;rmg=0.015;nbg=0.05;wealth=9;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=0;singlef=1;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table7f_0(i,1) table7f_1(i,1) table7f_2(i,1) table7f_3(i,1) table7f_4(i,1) table7f_5(i,1) table7f_6(i,1) table7f_7(i,1) table7f_8(i,1) table7f_9(i,1) table7f_10(i,1) table7f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     end;
% end;
% table7f=[table7f_0(:,1) table7f_1(:,1) table7f_2(:,1) table7f_3(:,1) table7f_4(:,1) table7f_5(:,1) table7f_6(:,1) table7f_7(:,1) table7f_8(:,1) table7f_9(:,1) table7f_10(:,1) table7f_11(:,1)];
% save LTCI_partner_tables table*
% toc
% 
% 
% 
% 
% 
% 
% 
% %%%%%%%%%r=0.01%%%%%%%%%%%%%%%%%%%%%%%
% table0_1_2m_0=zeros(8,1);
% table0_1_2m_1=zeros(8,1);
% table0_1_2m_2=zeros(8,1);
% table0_1_2m_3=zeros(8,1);
% table0_1_2m_4=zeros(8,1);
% table0_1_2m_5=zeros(8,1);
% table0_1_2m_6=zeros(8,1);
% table0_1_2m_7=zeros(8,1);
% table0_1_2m_8=zeros(8,1);
% table0_1_2m_9=zeros(8,1);
% table0_1_2m_10=zeros(8,1);
% table0_1_2m_11=zeros(8,1);
% parfor i=1:8;
%     if i==1;
%         crra=3;rho=0.03;r=0.01;inf=0.03;rmg=0.015;nbg=0;wealth=2;bencap_hc=0.1;bencap_alf=0.1;bencap_nh=0.1;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table0_1_2m_0(i,1) table0_1_2m_1(i,1) table0_1_2m_2(i,1) table0_1_2m_3(i,1) table0_1_2m_4(i,1) table0_1_2m_5(i,1) table0_1_2m_6(i,1) table0_1_2m_7(i,1) table0_1_2m_8(i,1) table0_1_2m_9(i,1) table0_1_2m_10(i,1) table0_1_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==2;
%         crra=3;rho=0.03;r=0.01;inf=0.03;rmg=0.015;nbg=0;wealth=3;bencap_hc=0.1;bencap_alf=0.1;bencap_nh=0.1;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table0_1_2m_0(i,1) table0_1_2m_1(i,1) table0_1_2m_2(i,1) table0_1_2m_3(i,1) table0_1_2m_4(i,1) table0_1_2m_5(i,1) table0_1_2m_6(i,1) table0_1_2m_7(i,1) table0_1_2m_8(i,1) table0_1_2m_9(i,1) table0_1_2m_10(i,1) table0_1_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==3;
%         crra=3;rho=0.03;r=0.01;inf=0.03;rmg=0.015;nbg=0;wealth=4;bencap_hc=0.1;bencap_alf=0.1;bencap_nh=0.1;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table0_1_2m_0(i,1) table0_1_2m_1(i,1) table0_1_2m_2(i,1) table0_1_2m_3(i,1) table0_1_2m_4(i,1) table0_1_2m_5(i,1) table0_1_2m_6(i,1) table0_1_2m_7(i,1) table0_1_2m_8(i,1) table0_1_2m_9(i,1) table0_1_2m_10(i,1) table0_1_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==4;
%         crra=3;rho=0.03;r=0.01;inf=0.03;rmg=0.015;nbg=0;wealth=5;bencap_hc=0.1;bencap_alf=0.1;bencap_nh=0.1;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table0_1_2m_0(i,1) table0_1_2m_1(i,1) table0_1_2m_2(i,1) table0_1_2m_3(i,1) table0_1_2m_4(i,1) table0_1_2m_5(i,1) table0_1_2m_6(i,1) table0_1_2m_7(i,1) table0_1_2m_8(i,1) table0_1_2m_9(i,1) table0_1_2m_10(i,1) table0_1_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==5;
%         crra=3;rho=0.03;r=0.01;inf=0.03;rmg=0.015;nbg=0;wealth=6;bencap_hc=0.1;bencap_alf=0.1;bencap_nh=0.1;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table0_1_2m_0(i,1) table0_1_2m_1(i,1) table0_1_2m_2(i,1) table0_1_2m_3(i,1) table0_1_2m_4(i,1) table0_1_2m_5(i,1) table0_1_2m_6(i,1) table0_1_2m_7(i,1) table0_1_2m_8(i,1) table0_1_2m_9(i,1) table0_1_2m_10(i,1) table0_1_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==6;
%         crra=3;rho=0.03;r=0.01;inf=0.03;rmg=0.015;nbg=0;wealth=7;bencap_hc=0.1;bencap_alf=0.1;bencap_nh=0.1;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table0_1_2m_0(i,1) table0_1_2m_1(i,1) table0_1_2m_2(i,1) table0_1_2m_3(i,1) table0_1_2m_4(i,1) table0_1_2m_5(i,1) table0_1_2m_6(i,1) table0_1_2m_7(i,1) table0_1_2m_8(i,1) table0_1_2m_9(i,1) table0_1_2m_10(i,1) table0_1_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==7;
%         crra=3;rho=0.03;r=0.01;inf=0.03;rmg=0.015;nbg=0;wealth=8;bencap_hc=0.1;bencap_alf=0.1;bencap_nh=0.1;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table0_1_2m_0(i,1) table0_1_2m_1(i,1) table0_1_2m_2(i,1) table0_1_2m_3(i,1) table0_1_2m_4(i,1) table0_1_2m_5(i,1) table0_1_2m_6(i,1) table0_1_2m_7(i,1) table0_1_2m_8(i,1) table0_1_2m_9(i,1) table0_1_2m_10(i,1) table0_1_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==8;
%         crra=3;rho=0.03;r=0.01;inf=0.03;rmg=0.015;nbg=0;wealth=9;bencap_hc=0.1;bencap_alf=0.1;bencap_nh=0.1;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table0_1_2m_0(i,1) table0_1_2m_1(i,1) table0_1_2m_2(i,1) table0_1_2m_3(i,1) table0_1_2m_4(i,1) table0_1_2m_5(i,1) table0_1_2m_6(i,1) table0_1_2m_7(i,1) table0_1_2m_8(i,1) table0_1_2m_9(i,1) table0_1_2m_10(i,1) table0_1_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     end;
% end;
% table0_1_2m=[table0_1_2m_0(:,1) table0_1_2m_1(:,1) table0_1_2m_2(:,1) table0_1_2m_3(:,1) table0_1_2m_4(:,1) table0_1_2m_5(:,1) table0_1_2m_6(:,1) table0_1_2m_7(:,1) table0_1_2m_8(:,1) table0_1_2m_9(:,1) table0_1_2m_10(:,1) table0_1_2m_11(:,1)];
% save LTCI_partner_tables table*
% toc
% 
% table0_2_2m_0=zeros(8,1);
% table0_2_2m_1=zeros(8,1);
% table0_2_2m_2=zeros(8,1);
% table0_2_2m_3=zeros(8,1);
% table0_2_2m_4=zeros(8,1);
% table0_2_2m_5=zeros(8,1);
% table0_2_2m_6=zeros(8,1);
% table0_2_2m_7=zeros(8,1);
% table0_2_2m_8=zeros(8,1);
% table0_2_2m_9=zeros(8,1);
% table0_2_2m_10=zeros(8,1);
% table0_2_2m_11=zeros(8,1);
% parfor i=1:8;
%     if i==1;
%         crra=3;rho=0.03;r=0.01;inf=0.03;rmg=0.015;nbg=0;wealth=2;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table0_2_2m_0(i,1) table0_2_2m_1(i,1) table0_2_2m_2(i,1) table0_2_2m_3(i,1) table0_2_2m_4(i,1) table0_2_2m_5(i,1) table0_2_2m_6(i,1) table0_2_2m_7(i,1) table0_2_2m_8(i,1) table0_2_2m_9(i,1) table0_2_2m_10(i,1) table0_2_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==2;
%         crra=3;rho=0.03;r=0.01;inf=0.03;rmg=0.015;nbg=0;wealth=3;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table0_2_2m_0(i,1) table0_2_2m_1(i,1) table0_2_2m_2(i,1) table0_2_2m_3(i,1) table0_2_2m_4(i,1) table0_2_2m_5(i,1) table0_2_2m_6(i,1) table0_2_2m_7(i,1) table0_2_2m_8(i,1) table0_2_2m_9(i,1) table0_2_2m_10(i,1) table0_2_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==3;
%         crra=3;rho=0.03;r=0.01;inf=0.03;rmg=0.015;nbg=0;wealth=4;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table0_2_2m_0(i,1) table0_2_2m_1(i,1) table0_2_2m_2(i,1) table0_2_2m_3(i,1) table0_2_2m_4(i,1) table0_2_2m_5(i,1) table0_2_2m_6(i,1) table0_2_2m_7(i,1) table0_2_2m_8(i,1) table0_2_2m_9(i,1) table0_2_2m_10(i,1) table0_2_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==4;
%         crra=3;rho=0.03;r=0.01;inf=0.03;rmg=0.015;nbg=0;wealth=5;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table0_2_2m_0(i,1) table0_2_2m_1(i,1) table0_2_2m_2(i,1) table0_2_2m_3(i,1) table0_2_2m_4(i,1) table0_2_2m_5(i,1) table0_2_2m_6(i,1) table0_2_2m_7(i,1) table0_2_2m_8(i,1) table0_2_2m_9(i,1) table0_2_2m_10(i,1) table0_2_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==5;
%         crra=3;rho=0.03;r=0.01;inf=0.03;rmg=0.015;nbg=0;wealth=6;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table0_2_2m_0(i,1) table0_2_2m_1(i,1) table0_2_2m_2(i,1) table0_2_2m_3(i,1) table0_2_2m_4(i,1) table0_2_2m_5(i,1) table0_2_2m_6(i,1) table0_2_2m_7(i,1) table0_2_2m_8(i,1) table0_2_2m_9(i,1) table0_2_2m_10(i,1) table0_2_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==6;
%         crra=3;rho=0.03;r=0.01;inf=0.03;rmg=0.015;nbg=0;wealth=7;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table0_2_2m_0(i,1) table0_2_2m_1(i,1) table0_2_2m_2(i,1) table0_2_2m_3(i,1) table0_2_2m_4(i,1) table0_2_2m_5(i,1) table0_2_2m_6(i,1) table0_2_2m_7(i,1) table0_2_2m_8(i,1) table0_2_2m_9(i,1) table0_2_2m_10(i,1) table0_2_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==7;
%         crra=3;rho=0.03;r=0.01;inf=0.03;rmg=0.015;nbg=0;wealth=8;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table0_2_2m_0(i,1) table0_2_2m_1(i,1) table0_2_2m_2(i,1) table0_2_2m_3(i,1) table0_2_2m_4(i,1) table0_2_2m_5(i,1) table0_2_2m_6(i,1) table0_2_2m_7(i,1) table0_2_2m_8(i,1) table0_2_2m_9(i,1) table0_2_2m_10(i,1) table0_2_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==8;
%         crra=3;rho=0.03;r=0.01;inf=0.03;rmg=0.015;nbg=0;wealth=9;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table0_2_2m_0(i,1) table0_2_2m_1(i,1) table0_2_2m_2(i,1) table0_2_2m_3(i,1) table0_2_2m_4(i,1) table0_2_2m_5(i,1) table0_2_2m_6(i,1) table0_2_2m_7(i,1) table0_2_2m_8(i,1) table0_2_2m_9(i,1) table0_2_2m_10(i,1) table0_2_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     end;
% end;
% table0_2_2m=[table0_2_2m_0(:,1) table0_2_2m_1(:,1) table0_2_2m_2(:,1) table0_2_2m_3(:,1) table0_2_2m_4(:,1) table0_2_2m_5(:,1) table0_2_2m_6(:,1) table0_2_2m_7(:,1) table0_2_2m_8(:,1) table0_2_2m_9(:,1) table0_2_2m_10(:,1) table0_2_2m_11(:,1)];
% save LTCI_partner_tables table*
% toc
% 
% table1_2m_0=zeros(8,1);
% table1_2m_1=zeros(8,1);
% table1_2m_2=zeros(8,1);
% table1_2m_3=zeros(8,1);
% table1_2m_4=zeros(8,1);
% table1_2m_5=zeros(8,1);
% table1_2m_6=zeros(8,1);
% table1_2m_7=zeros(8,1);
% table1_2m_8=zeros(8,1);
% table1_2m_9=zeros(8,1);
% table1_2m_10=zeros(8,1);
% table1_2m_11=zeros(8,1);
% parfor i=1:8;
%     if i==1;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=2;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table1_2m_0(i,1) table1_2m_1(i,1) table1_2m_2(i,1) table1_2m_3(i,1) table1_2m_4(i,1) table1_2m_5(i,1) table1_2m_6(i,1) table1_2m_7(i,1) table1_2m_8(i,1) table1_2m_9(i,1) table1_2m_10(i,1) table1_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==2;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=3;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table1_2m_0(i,1) table1_2m_1(i,1) table1_2m_2(i,1) table1_2m_3(i,1) table1_2m_4(i,1) table1_2m_5(i,1) table1_2m_6(i,1) table1_2m_7(i,1) table1_2m_8(i,1) table1_2m_9(i,1) table1_2m_10(i,1) table1_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==3;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=4;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table1_2m_0(i,1) table1_2m_1(i,1) table1_2m_2(i,1) table1_2m_3(i,1) table1_2m_4(i,1) table1_2m_5(i,1) table1_2m_6(i,1) table1_2m_7(i,1) table1_2m_8(i,1) table1_2m_9(i,1) table1_2m_10(i,1) table1_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==4;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=5;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table1_2m_0(i,1) table1_2m_1(i,1) table1_2m_2(i,1) table1_2m_3(i,1) table1_2m_4(i,1) table1_2m_5(i,1) table1_2m_6(i,1) table1_2m_7(i,1) table1_2m_8(i,1) table1_2m_9(i,1) table1_2m_10(i,1) table1_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==5;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=6;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table1_2m_0(i,1) table1_2m_1(i,1) table1_2m_2(i,1) table1_2m_3(i,1) table1_2m_4(i,1) table1_2m_5(i,1) table1_2m_6(i,1) table1_2m_7(i,1) table1_2m_8(i,1) table1_2m_9(i,1) table1_2m_10(i,1) table1_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==6;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=7;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table1_2m_0(i,1) table1_2m_1(i,1) table1_2m_2(i,1) table1_2m_3(i,1) table1_2m_4(i,1) table1_2m_5(i,1) table1_2m_6(i,1) table1_2m_7(i,1) table1_2m_8(i,1) table1_2m_9(i,1) table1_2m_10(i,1) table1_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==7;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=8;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table1_2m_0(i,1) table1_2m_1(i,1) table1_2m_2(i,1) table1_2m_3(i,1) table1_2m_4(i,1) table1_2m_5(i,1) table1_2m_6(i,1) table1_2m_7(i,1) table1_2m_8(i,1) table1_2m_9(i,1) table1_2m_10(i,1) table1_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==8;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=9;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table1_2m_0(i,1) table1_2m_1(i,1) table1_2m_2(i,1) table1_2m_3(i,1) table1_2m_4(i,1) table1_2m_5(i,1) table1_2m_6(i,1) table1_2m_7(i,1) table1_2m_8(i,1) table1_2m_9(i,1) table1_2m_10(i,1) table1_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     end;
% end;
% table1_2m=[table1_2m_0(:,1) table1_2m_1(:,1) table1_2m_2(:,1) table1_2m_3(:,1) table1_2m_4(:,1) table1_2m_5(:,1) table1_2m_6(:,1) table1_2m_7(:,1) table1_2m_8(:,1) table1_2m_9(:,1) table1_2m_10(:,1) table1_2m_11(:,1)];
% save LTCI_partner_tables table*
% toc
% 
% table2_2m_0=zeros(8,1);
% table2_2m_1=zeros(8,1);
% table2_2m_2=zeros(8,1);
% table2_2m_3=zeros(8,1);
% table2_2m_4=zeros(8,1);
% table2_2m_5=zeros(8,1);
% table2_2m_6=zeros(8,1);
% table2_2m_7=zeros(8,1);
% table2_2m_8=zeros(8,1);
% table2_2m_9=zeros(8,1);
% table2_2m_10=zeros(8,1);
% table2_2m_11=zeros(8,1);
% parfor i=1:8;
%     if i==1;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0;wealth=2;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table2_2m_0(i,1) table2_2m_1(i,1) table2_2m_2(i,1) table2_2m_3(i,1) table2_2m_4(i,1) table2_2m_5(i,1) table2_2m_6(i,1) table2_2m_7(i,1) table2_2m_8(i,1) table2_2m_9(i,1) table2_2m_10(i,1) table2_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==2;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0;wealth=3;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table2_2m_0(i,1) table2_2m_1(i,1) table2_2m_2(i,1) table2_2m_3(i,1) table2_2m_4(i,1) table2_2m_5(i,1) table2_2m_6(i,1) table2_2m_7(i,1) table2_2m_8(i,1) table2_2m_9(i,1) table2_2m_10(i,1) table2_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==3;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0;wealth=4;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table2_2m_0(i,1) table2_2m_1(i,1) table2_2m_2(i,1) table2_2m_3(i,1) table2_2m_4(i,1) table2_2m_5(i,1) table2_2m_6(i,1) table2_2m_7(i,1) table2_2m_8(i,1) table2_2m_9(i,1) table2_2m_10(i,1) table2_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==4;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0;wealth=5;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table2_2m_0(i,1) table2_2m_1(i,1) table2_2m_2(i,1) table2_2m_3(i,1) table2_2m_4(i,1) table2_2m_5(i,1) table2_2m_6(i,1) table2_2m_7(i,1) table2_2m_8(i,1) table2_2m_9(i,1) table2_2m_10(i,1) table2_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==5;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0;wealth=6;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table2_2m_0(i,1) table2_2m_1(i,1) table2_2m_2(i,1) table2_2m_3(i,1) table2_2m_4(i,1) table2_2m_5(i,1) table2_2m_6(i,1) table2_2m_7(i,1) table2_2m_8(i,1) table2_2m_9(i,1) table2_2m_10(i,1) table2_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==6;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0;wealth=7;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table2_2m_0(i,1) table2_2m_1(i,1) table2_2m_2(i,1) table2_2m_3(i,1) table2_2m_4(i,1) table2_2m_5(i,1) table2_2m_6(i,1) table2_2m_7(i,1) table2_2m_8(i,1) table2_2m_9(i,1) table2_2m_10(i,1) table2_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==7;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0;wealth=8;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table2_2m_0(i,1) table2_2m_1(i,1) table2_2m_2(i,1) table2_2m_3(i,1) table2_2m_4(i,1) table2_2m_5(i,1) table2_2m_6(i,1) table2_2m_7(i,1) table2_2m_8(i,1) table2_2m_9(i,1) table2_2m_10(i,1) table2_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==8;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0;wealth=9;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table2_2m_0(i,1) table2_2m_1(i,1) table2_2m_2(i,1) table2_2m_3(i,1) table2_2m_4(i,1) table2_2m_5(i,1) table2_2m_6(i,1) table2_2m_7(i,1) table2_2m_8(i,1) table2_2m_9(i,1) table2_2m_10(i,1) table2_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     end;
% end;
% table2_2m=[table2_2m_0(:,1) table2_2m_1(:,1) table2_2m_2(:,1) table2_2m_3(:,1) table2_2m_4(:,1) table2_2m_5(:,1) table2_2m_6(:,1) table2_2m_7(:,1) table2_2m_8(:,1) table2_2m_9(:,1) table2_2m_10(:,1) table2_2m_11(:,1)];
% save LTCI_partner_tables table*
% toc
% 
% table3_2m_0=zeros(8,1);
% table3_2m_1=zeros(8,1);
% table3_2m_2=zeros(8,1);
% table3_2m_3=zeros(8,1);
% table3_2m_4=zeros(8,1);
% table3_2m_5=zeros(8,1);
% table3_2m_6=zeros(8,1);
% table3_2m_7=zeros(8,1);
% table3_2m_8=zeros(8,1);
% table3_2m_9=zeros(8,1);
% table3_2m_10=zeros(8,1);
% table3_2m_11=zeros(8,1);
% parfor i=1:8;
%     if i==1;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=2;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table3_2m_0(i,1) table3_2m_1(i,1) table3_2m_2(i,1) table3_2m_3(i,1) table3_2m_4(i,1) table3_2m_5(i,1) table3_2m_6(i,1) table3_2m_7(i,1) table3_2m_8(i,1) table3_2m_9(i,1) table3_2m_10(i,1) table3_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==2;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=3;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table3_2m_0(i,1) table3_2m_1(i,1) table3_2m_2(i,1) table3_2m_3(i,1) table3_2m_4(i,1) table3_2m_5(i,1) table3_2m_6(i,1) table3_2m_7(i,1) table3_2m_8(i,1) table3_2m_9(i,1) table3_2m_10(i,1) table3_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==3;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=4;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table3_2m_0(i,1) table3_2m_1(i,1) table3_2m_2(i,1) table3_2m_3(i,1) table3_2m_4(i,1) table3_2m_5(i,1) table3_2m_6(i,1) table3_2m_7(i,1) table3_2m_8(i,1) table3_2m_9(i,1) table3_2m_10(i,1) table3_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==4;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=5;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table3_2m_0(i,1) table3_2m_1(i,1) table3_2m_2(i,1) table3_2m_3(i,1) table3_2m_4(i,1) table3_2m_5(i,1) table3_2m_6(i,1) table3_2m_7(i,1) table3_2m_8(i,1) table3_2m_9(i,1) table3_2m_10(i,1) table3_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==5;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=6;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table3_2m_0(i,1) table3_2m_1(i,1) table3_2m_2(i,1) table3_2m_3(i,1) table3_2m_4(i,1) table3_2m_5(i,1) table3_2m_6(i,1) table3_2m_7(i,1) table3_2m_8(i,1) table3_2m_9(i,1) table3_2m_10(i,1) table3_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==6;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=7;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table3_2m_0(i,1) table3_2m_1(i,1) table3_2m_2(i,1) table3_2m_3(i,1) table3_2m_4(i,1) table3_2m_5(i,1) table3_2m_6(i,1) table3_2m_7(i,1) table3_2m_8(i,1) table3_2m_9(i,1) table3_2m_10(i,1) table3_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==7;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=8;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table3_2m_0(i,1) table3_2m_1(i,1) table3_2m_2(i,1) table3_2m_3(i,1) table3_2m_4(i,1) table3_2m_5(i,1) table3_2m_6(i,1) table3_2m_7(i,1) table3_2m_8(i,1) table3_2m_9(i,1) table3_2m_10(i,1) table3_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==8;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=9;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table3_2m_0(i,1) table3_2m_1(i,1) table3_2m_2(i,1) table3_2m_3(i,1) table3_2m_4(i,1) table3_2m_5(i,1) table3_2m_6(i,1) table3_2m_7(i,1) table3_2m_8(i,1) table3_2m_9(i,1) table3_2m_10(i,1) table3_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     end;
% end;
% table3_2m=[table3_2m_0(:,1) table3_2m_1(:,1) table3_2m_2(:,1) table3_2m_3(:,1) table3_2m_4(:,1) table3_2m_5(:,1) table3_2m_6(:,1) table3_2m_7(:,1) table3_2m_8(:,1) table3_2m_9(:,1) table3_2m_10(:,1) table3_2m_11(:,1)];
% save LTCI_partner_tables table*
% toc
% 
% table4_1_2m_0=zeros(8,1);
% table4_1_2m_1=zeros(8,1);
% table4_1_2m_2=zeros(8,1);
% table4_1_2m_3=zeros(8,1);
% table4_1_2m_4=zeros(8,1);
% table4_1_2m_5=zeros(8,1);
% table4_1_2m_6=zeros(8,1);
% table4_1_2m_7=zeros(8,1);
% table4_1_2m_8=zeros(8,1);
% table4_1_2m_9=zeros(8,1);
% table4_1_2m_10=zeros(8,1);
% table4_1_2m_11=zeros(8,1);
% parfor i=1:8;
%     if i==1;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=2;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_1_2m_0(i,1) table4_1_2m_1(i,1) table4_1_2m_2(i,1) table4_1_2m_3(i,1) table4_1_2m_4(i,1) table4_1_2m_5(i,1) table4_1_2m_6(i,1) table4_1_2m_7(i,1) table4_1_2m_8(i,1) table4_1_2m_9(i,1) table4_1_2m_10(i,1) table4_1_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==2;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=3;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_1_2m_0(i,1) table4_1_2m_1(i,1) table4_1_2m_2(i,1) table4_1_2m_3(i,1) table4_1_2m_4(i,1) table4_1_2m_5(i,1) table4_1_2m_6(i,1) table4_1_2m_7(i,1) table4_1_2m_8(i,1) table4_1_2m_9(i,1) table4_1_2m_10(i,1) table4_1_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==3;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=4;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_1_2m_0(i,1) table4_1_2m_1(i,1) table4_1_2m_2(i,1) table4_1_2m_3(i,1) table4_1_2m_4(i,1) table4_1_2m_5(i,1) table4_1_2m_6(i,1) table4_1_2m_7(i,1) table4_1_2m_8(i,1) table4_1_2m_9(i,1) table4_1_2m_10(i,1) table4_1_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==4;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=5;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_1_2m_0(i,1) table4_1_2m_1(i,1) table4_1_2m_2(i,1) table4_1_2m_3(i,1) table4_1_2m_4(i,1) table4_1_2m_5(i,1) table4_1_2m_6(i,1) table4_1_2m_7(i,1) table4_1_2m_8(i,1) table4_1_2m_9(i,1) table4_1_2m_10(i,1) table4_1_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==5;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=6;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_1_2m_0(i,1) table4_1_2m_1(i,1) table4_1_2m_2(i,1) table4_1_2m_3(i,1) table4_1_2m_4(i,1) table4_1_2m_5(i,1) table4_1_2m_6(i,1) table4_1_2m_7(i,1) table4_1_2m_8(i,1) table4_1_2m_9(i,1) table4_1_2m_10(i,1) table4_1_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==6;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=7;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_1_2m_0(i,1) table4_1_2m_1(i,1) table4_1_2m_2(i,1) table4_1_2m_3(i,1) table4_1_2m_4(i,1) table4_1_2m_5(i,1) table4_1_2m_6(i,1) table4_1_2m_7(i,1) table4_1_2m_8(i,1) table4_1_2m_9(i,1) table4_1_2m_10(i,1) table4_1_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==7;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=8;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_1_2m_0(i,1) table4_1_2m_1(i,1) table4_1_2m_2(i,1) table4_1_2m_3(i,1) table4_1_2m_4(i,1) table4_1_2m_5(i,1) table4_1_2m_6(i,1) table4_1_2m_7(i,1) table4_1_2m_8(i,1) table4_1_2m_9(i,1) table4_1_2m_10(i,1) table4_1_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==8;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=9;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_1_2m_0(i,1) table4_1_2m_1(i,1) table4_1_2m_2(i,1) table4_1_2m_3(i,1) table4_1_2m_4(i,1) table4_1_2m_5(i,1) table4_1_2m_6(i,1) table4_1_2m_7(i,1) table4_1_2m_8(i,1) table4_1_2m_9(i,1) table4_1_2m_10(i,1) table4_1_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     end;
% end;
% table4_1_2m=[table4_1_2m_0(:,1) table4_1_2m_1(:,1) table4_1_2m_2(:,1) table4_1_2m_3(:,1) table4_1_2m_4(:,1) table4_1_2m_5(:,1) table4_1_2m_6(:,1) table4_1_2m_7(:,1) table4_1_2m_8(:,1) table4_1_2m_9(:,1) table4_1_2m_10(:,1) table4_1_2m_11(:,1)];
% save LTCI_partner_tables table*
% toc
% 
% table4_2_2m_0=zeros(8,1);
% table4_2_2m_1=zeros(8,1);
% table4_2_2m_2=zeros(8,1);
% table4_2_2m_3=zeros(8,1);
% table4_2_2m_4=zeros(8,1);
% table4_2_2m_5=zeros(8,1);
% table4_2_2m_6=zeros(8,1);
% table4_2_2m_7=zeros(8,1);
% table4_2_2m_8=zeros(8,1);
% table4_2_2m_9=zeros(8,1);
% table4_2_2m_10=zeros(8,1);
% table4_2_2m_11=zeros(8,1);
% parfor i=1:8;
%     if i==1;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=2;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_2_2m_0(i,1) table4_2_2m_1(i,1) table4_2_2m_2(i,1) table4_2_2m_3(i,1) table4_2_2m_4(i,1) table4_2_2m_5(i,1) table4_2_2m_6(i,1) table4_2_2m_7(i,1) table4_2_2m_8(i,1) table4_2_2m_9(i,1) table4_2_2m_10(i,1) table4_2_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==2;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=3;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_2_2m_0(i,1) table4_2_2m_1(i,1) table4_2_2m_2(i,1) table4_2_2m_3(i,1) table4_2_2m_4(i,1) table4_2_2m_5(i,1) table4_2_2m_6(i,1) table4_2_2m_7(i,1) table4_2_2m_8(i,1) table4_2_2m_9(i,1) table4_2_2m_10(i,1) table4_2_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==3;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=4;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_2_2m_0(i,1) table4_2_2m_1(i,1) table4_2_2m_2(i,1) table4_2_2m_3(i,1) table4_2_2m_4(i,1) table4_2_2m_5(i,1) table4_2_2m_6(i,1) table4_2_2m_7(i,1) table4_2_2m_8(i,1) table4_2_2m_9(i,1) table4_2_2m_10(i,1) table4_2_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==4;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=5;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_2_2m_0(i,1) table4_2_2m_1(i,1) table4_2_2m_2(i,1) table4_2_2m_3(i,1) table4_2_2m_4(i,1) table4_2_2m_5(i,1) table4_2_2m_6(i,1) table4_2_2m_7(i,1) table4_2_2m_8(i,1) table4_2_2m_9(i,1) table4_2_2m_10(i,1) table4_2_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==5;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=6;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_2_2m_0(i,1) table4_2_2m_1(i,1) table4_2_2m_2(i,1) table4_2_2m_3(i,1) table4_2_2m_4(i,1) table4_2_2m_5(i,1) table4_2_2m_6(i,1) table4_2_2m_7(i,1) table4_2_2m_8(i,1) table4_2_2m_9(i,1) table4_2_2m_10(i,1) table4_2_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==6;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=7;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_2_2m_0(i,1) table4_2_2m_1(i,1) table4_2_2m_2(i,1) table4_2_2m_3(i,1) table4_2_2m_4(i,1) table4_2_2m_5(i,1) table4_2_2m_6(i,1) table4_2_2m_7(i,1) table4_2_2m_8(i,1) table4_2_2m_9(i,1) table4_2_2m_10(i,1) table4_2_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==7;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=8;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_2_2m_0(i,1) table4_2_2m_1(i,1) table4_2_2m_2(i,1) table4_2_2m_3(i,1) table4_2_2m_4(i,1) table4_2_2m_5(i,1) table4_2_2m_6(i,1) table4_2_2m_7(i,1) table4_2_2m_8(i,1) table4_2_2m_9(i,1) table4_2_2m_10(i,1) table4_2_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==8;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=9;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_2_2m_0(i,1) table4_2_2m_1(i,1) table4_2_2m_2(i,1) table4_2_2m_3(i,1) table4_2_2m_4(i,1) table4_2_2m_5(i,1) table4_2_2m_6(i,1) table4_2_2m_7(i,1) table4_2_2m_8(i,1) table4_2_2m_9(i,1) table4_2_2m_10(i,1) table4_2_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     end;
% end;
% table4_2_2m=[table4_2_2m_0(:,1) table4_2_2m_1(:,1) table4_2_2m_2(:,1) table4_2_2m_3(:,1) table4_2_2m_4(:,1) table4_2_2m_5(:,1) table4_2_2m_6(:,1) table4_2_2m_7(:,1) table4_2_2m_8(:,1) table4_2_2m_9(:,1) table4_2_2m_10(:,1) table4_2_2m_11(:,1)];
% save LTCI_partner_tables table*
% toc
% 
% table5_2m_0=zeros(8,1);
% table5_2m_1=zeros(8,1);
% table5_2m_2=zeros(8,1);
% table5_2m_3=zeros(8,1);
% table5_2m_4=zeros(8,1);
% table5_2m_5=zeros(8,1);
% table5_2m_6=zeros(8,1);
% table5_2m_7=zeros(8,1);
% table5_2m_8=zeros(8,1);
% table5_2m_9=zeros(8,1);
% table5_2m_10=zeros(8,1);
% table5_2m_11=zeros(8,1);
% parfor i=1:8;
%     if i==1;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=2;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=1;sick_T=36;hcdaycount=1;NY=0;
%         [table5_2m_0(i,1) table5_2m_1(i,1) table5_2m_2(i,1) table5_2m_3(i,1) table5_2m_4(i,1) table5_2m_5(i,1) table5_2m_6(i,1) table5_2m_7(i,1) table5_2m_8(i,1) table5_2m_9(i,1) table5_2m_10(i,1) table5_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==2;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=3;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=1;sick_T=36;hcdaycount=1;NY=0;
%         [table5_2m_0(i,1) table5_2m_1(i,1) table5_2m_2(i,1) table5_2m_3(i,1) table5_2m_4(i,1) table5_2m_5(i,1) table5_2m_6(i,1) table5_2m_7(i,1) table5_2m_8(i,1) table5_2m_9(i,1) table5_2m_10(i,1) table5_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==3;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=4;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=1;sick_T=36;hcdaycount=1;NY=0;
%         [table5_2m_0(i,1) table5_2m_1(i,1) table5_2m_2(i,1) table5_2m_3(i,1) table5_2m_4(i,1) table5_2m_5(i,1) table5_2m_6(i,1) table5_2m_7(i,1) table5_2m_8(i,1) table5_2m_9(i,1) table5_2m_10(i,1) table5_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==4;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=5;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=1;sick_T=36;hcdaycount=1;NY=0;
%         [table5_2m_0(i,1) table5_2m_1(i,1) table5_2m_2(i,1) table5_2m_3(i,1) table5_2m_4(i,1) table5_2m_5(i,1) table5_2m_6(i,1) table5_2m_7(i,1) table5_2m_8(i,1) table5_2m_9(i,1) table5_2m_10(i,1) table5_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==5;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=6;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=1;sick_T=36;hcdaycount=1;NY=0;
%         [table5_2m_0(i,1) table5_2m_1(i,1) table5_2m_2(i,1) table5_2m_3(i,1) table5_2m_4(i,1) table5_2m_5(i,1) table5_2m_6(i,1) table5_2m_7(i,1) table5_2m_8(i,1) table5_2m_9(i,1) table5_2m_10(i,1) table5_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==6;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=7;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=1;sick_T=36;hcdaycount=1;NY=0;
%         [table5_2m_0(i,1) table5_2m_1(i,1) table5_2m_2(i,1) table5_2m_3(i,1) table5_2m_4(i,1) table5_2m_5(i,1) table5_2m_6(i,1) table5_2m_7(i,1) table5_2m_8(i,1) table5_2m_9(i,1) table5_2m_10(i,1) table5_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==7;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=8;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=1;sick_T=36;hcdaycount=1;NY=0;
%         [table5_2m_0(i,1) table5_2m_1(i,1) table5_2m_2(i,1) table5_2m_3(i,1) table5_2m_4(i,1) table5_2m_5(i,1) table5_2m_6(i,1) table5_2m_7(i,1) table5_2m_8(i,1) table5_2m_9(i,1) table5_2m_10(i,1) table5_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==8;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=9;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=1;sick_T=36;hcdaycount=1;NY=0;
%         [table5_2m_0(i,1) table5_2m_1(i,1) table5_2m_2(i,1) table5_2m_3(i,1) table5_2m_4(i,1) table5_2m_5(i,1) table5_2m_6(i,1) table5_2m_7(i,1) table5_2m_8(i,1) table5_2m_9(i,1) table5_2m_10(i,1) table5_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     end;
% end;
% table5_2m=[table5_2m_0(:,1) table5_2m_1(:,1) table5_2m_2(:,1) table5_2m_3(:,1) table5_2m_4(:,1) table5_2m_5(:,1) table5_2m_6(:,1) table5_2m_7(:,1) table5_2m_8(:,1) table5_2m_9(:,1) table5_2m_10(:,1) table5_2m_11(:,1)];
% save LTCI_partner_tables table*
% toc
% 
% table6_2m_0=zeros(8,1);
% table6_2m_1=zeros(8,1);
% table6_2m_2=zeros(8,1);
% table6_2m_3=zeros(8,1);
% table6_2m_4=zeros(8,1);
% table6_2m_5=zeros(8,1);
% table6_2m_6=zeros(8,1);
% table6_2m_7=zeros(8,1);
% table6_2m_8=zeros(8,1);
% table6_2m_9=zeros(8,1);
% table6_2m_10=zeros(8,1);
% table6_2m_11=zeros(8,1);
% parfor i=1:8;
%     if i==1;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=2;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table6_2m_0(i,1) table6_2m_1(i,1) table6_2m_2(i,1) table6_2m_3(i,1) table6_2m_4(i,1) table6_2m_5(i,1) table6_2m_6(i,1) table6_2m_7(i,1) table6_2m_8(i,1) table6_2m_9(i,1) table6_2m_10(i,1) table6_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==2;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=3;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table6_2m_0(i,1) table6_2m_1(i,1) table6_2m_2(i,1) table6_2m_3(i,1) table6_2m_4(i,1) table6_2m_5(i,1) table6_2m_6(i,1) table6_2m_7(i,1) table6_2m_8(i,1) table6_2m_9(i,1) table6_2m_10(i,1) table6_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==3;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=4;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table6_2m_0(i,1) table6_2m_1(i,1) table6_2m_2(i,1) table6_2m_3(i,1) table6_2m_4(i,1) table6_2m_5(i,1) table6_2m_6(i,1) table6_2m_7(i,1) table6_2m_8(i,1) table6_2m_9(i,1) table6_2m_10(i,1) table6_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==4;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=5;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table6_2m_0(i,1) table6_2m_1(i,1) table6_2m_2(i,1) table6_2m_3(i,1) table6_2m_4(i,1) table6_2m_5(i,1) table6_2m_6(i,1) table6_2m_7(i,1) table6_2m_8(i,1) table6_2m_9(i,1) table6_2m_10(i,1) table6_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==5;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=6;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table6_2m_0(i,1) table6_2m_1(i,1) table6_2m_2(i,1) table6_2m_3(i,1) table6_2m_4(i,1) table6_2m_5(i,1) table6_2m_6(i,1) table6_2m_7(i,1) table6_2m_8(i,1) table6_2m_9(i,1) table6_2m_10(i,1) table6_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==6;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=7;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table6_2m_0(i,1) table6_2m_1(i,1) table6_2m_2(i,1) table6_2m_3(i,1) table6_2m_4(i,1) table6_2m_5(i,1) table6_2m_6(i,1) table6_2m_7(i,1) table6_2m_8(i,1) table6_2m_9(i,1) table6_2m_10(i,1) table6_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==7;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=8;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table6_2m_0(i,1) table6_2m_1(i,1) table6_2m_2(i,1) table6_2m_3(i,1) table6_2m_4(i,1) table6_2m_5(i,1) table6_2m_6(i,1) table6_2m_7(i,1) table6_2m_8(i,1) table6_2m_9(i,1) table6_2m_10(i,1) table6_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==8;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=9;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=1;singlef=0;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table6_2m_0(i,1) table6_2m_1(i,1) table6_2m_2(i,1) table6_2m_3(i,1) table6_2m_4(i,1) table6_2m_5(i,1) table6_2m_6(i,1) table6_2m_7(i,1) table6_2m_8(i,1) table6_2m_9(i,1) table6_2m_10(i,1) table6_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     end;
% end;
% table6_2m=[table6_2m_0(:,1) table6_2m_1(:,1) table6_2m_2(:,1) table6_2m_3(:,1) table6_2m_4(:,1) table6_2m_5(:,1) table6_2m_6(:,1) table6_2m_7(:,1) table6_2m_8(:,1) table6_2m_9(:,1) table6_2m_10(:,1) table6_2m_11(:,1)];
% save LTCI_partner_tables table*
% toc
% 
% table7_2m_0=zeros(8,1);
% table7_2m_1=zeros(8,1);
% table7_2m_2=zeros(8,1);
% table7_2m_3=zeros(8,1);
% table7_2m_4=zeros(8,1);
% table7_2m_5=zeros(8,1);
% table7_2m_6=zeros(8,1);
% table7_2m_7=zeros(8,1);
% table7_2m_8=zeros(8,1);
% table7_2m_9=zeros(8,1);
% table7_2m_10=zeros(8,1);
% table7_2m_11=zeros(8,1);
% parfor i=1:8;
%     if i==1;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=2;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table7_2m_0(i,1) table7_2m_1(i,1) table7_2m_2(i,1) table7_2m_3(i,1) table7_2m_4(i,1) table7_2m_5(i,1) table7_2m_6(i,1) table7_2m_7(i,1) table7_2m_8(i,1) table7_2m_9(i,1) table7_2m_10(i,1) table7_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==2;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=3;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table7_2m_0(i,1) table7_2m_1(i,1) table7_2m_2(i,1) table7_2m_3(i,1) table7_2m_4(i,1) table7_2m_5(i,1) table7_2m_6(i,1) table7_2m_7(i,1) table7_2m_8(i,1) table7_2m_9(i,1) table7_2m_10(i,1) table7_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==3;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=4;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table7_2m_0(i,1) table7_2m_1(i,1) table7_2m_2(i,1) table7_2m_3(i,1) table7_2m_4(i,1) table7_2m_5(i,1) table7_2m_6(i,1) table7_2m_7(i,1) table7_2m_8(i,1) table7_2m_9(i,1) table7_2m_10(i,1) table7_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==4;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=5;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table7_2m_0(i,1) table7_2m_1(i,1) table7_2m_2(i,1) table7_2m_3(i,1) table7_2m_4(i,1) table7_2m_5(i,1) table7_2m_6(i,1) table7_2m_7(i,1) table7_2m_8(i,1) table7_2m_9(i,1) table7_2m_10(i,1) table7_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==5;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=6;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table7_2m_0(i,1) table7_2m_1(i,1) table7_2m_2(i,1) table7_2m_3(i,1) table7_2m_4(i,1) table7_2m_5(i,1) table7_2m_6(i,1) table7_2m_7(i,1) table7_2m_8(i,1) table7_2m_9(i,1) table7_2m_10(i,1) table7_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==6;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=7;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table7_2m_0(i,1) table7_2m_1(i,1) table7_2m_2(i,1) table7_2m_3(i,1) table7_2m_4(i,1) table7_2m_5(i,1) table7_2m_6(i,1) table7_2m_7(i,1) table7_2m_8(i,1) table7_2m_9(i,1) table7_2m_10(i,1) table7_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==7;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=8;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table7_2m_0(i,1) table7_2m_1(i,1) table7_2m_2(i,1) table7_2m_3(i,1) table7_2m_4(i,1) table7_2m_5(i,1) table7_2m_6(i,1) table7_2m_7(i,1) table7_2m_8(i,1) table7_2m_9(i,1) table7_2m_10(i,1) table7_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==8;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=9;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=1;singlef=0;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table7_2m_0(i,1) table7_2m_1(i,1) table7_2m_2(i,1) table7_2m_3(i,1) table7_2m_4(i,1) table7_2m_5(i,1) table7_2m_6(i,1) table7_2m_7(i,1) table7_2m_8(i,1) table7_2m_9(i,1) table7_2m_10(i,1) table7_2m_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     end;
% end;
% table7_2m=[table7_2m_0(:,1) table7_2m_1(:,1) table7_2m_2(:,1) table7_2m_3(:,1) table7_2m_4(:,1) table7_2m_5(:,1) table7_2m_6(:,1) table7_2m_7(:,1) table7_2m_8(:,1) table7_2m_9(:,1) table7_2m_10(:,1) table7_2m_11(:,1)];
% save LTCI_partner_tables table*
% toc
% 
% table0_1_2f_0=zeros(8,1);
% table0_1_2f_1=zeros(8,1);
% table0_1_2f_2=zeros(8,1);
% table0_1_2f_3=zeros(8,1);
% table0_1_2f_4=zeros(8,1);
% table0_1_2f_5=zeros(8,1);
% table0_1_2f_6=zeros(8,1);
% table0_1_2f_7=zeros(8,1);
% table0_1_2f_8=zeros(8,1);
% table0_1_2f_9=zeros(8,1);
% table0_1_2f_10=zeros(8,1);
% table0_1_2f_11=zeros(8,1);
% parfor i=1:8;
%     if i==1;
%         crra=3;rho=0.03;r=0.01;inf=0.03;rmg=0.015;nbg=0;wealth=2;bencap_hc=0.1;bencap_alf=0.1;bencap_nh=0.1;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table0_1_2f_0(i,1) table0_1_2f_1(i,1) table0_1_2f_2(i,1) table0_1_2f_3(i,1) table0_1_2f_4(i,1) table0_1_2f_5(i,1) table0_1_2f_6(i,1) table0_1_2f_7(i,1) table0_1_2f_8(i,1) table0_1_2f_9(i,1) table0_1_2f_10(i,1) table0_1_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==2;
%         crra=3;rho=0.03;r=0.01;inf=0.03;rmg=0.015;nbg=0;wealth=3;bencap_hc=0.1;bencap_alf=0.1;bencap_nh=0.1;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table0_1_2f_0(i,1) table0_1_2f_1(i,1) table0_1_2f_2(i,1) table0_1_2f_3(i,1) table0_1_2f_4(i,1) table0_1_2f_5(i,1) table0_1_2f_6(i,1) table0_1_2f_7(i,1) table0_1_2f_8(i,1) table0_1_2f_9(i,1) table0_1_2f_10(i,1) table0_1_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==3;
%         crra=3;rho=0.03;r=0.01;inf=0.03;rmg=0.015;nbg=0;wealth=4;bencap_hc=0.1;bencap_alf=0.1;bencap_nh=0.1;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table0_1_2f_0(i,1) table0_1_2f_1(i,1) table0_1_2f_2(i,1) table0_1_2f_3(i,1) table0_1_2f_4(i,1) table0_1_2f_5(i,1) table0_1_2f_6(i,1) table0_1_2f_7(i,1) table0_1_2f_8(i,1) table0_1_2f_9(i,1) table0_1_2f_10(i,1) table0_1_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==4;
%         crra=3;rho=0.03;r=0.01;inf=0.03;rmg=0.015;nbg=0;wealth=5;bencap_hc=0.1;bencap_alf=0.1;bencap_nh=0.1;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table0_1_2f_0(i,1) table0_1_2f_1(i,1) table0_1_2f_2(i,1) table0_1_2f_3(i,1) table0_1_2f_4(i,1) table0_1_2f_5(i,1) table0_1_2f_6(i,1) table0_1_2f_7(i,1) table0_1_2f_8(i,1) table0_1_2f_9(i,1) table0_1_2f_10(i,1) table0_1_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==5;
%         crra=3;rho=0.03;r=0.01;inf=0.03;rmg=0.015;nbg=0;wealth=6;bencap_hc=0.1;bencap_alf=0.1;bencap_nh=0.1;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table0_1_2f_0(i,1) table0_1_2f_1(i,1) table0_1_2f_2(i,1) table0_1_2f_3(i,1) table0_1_2f_4(i,1) table0_1_2f_5(i,1) table0_1_2f_6(i,1) table0_1_2f_7(i,1) table0_1_2f_8(i,1) table0_1_2f_9(i,1) table0_1_2f_10(i,1) table0_1_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==6;
%         crra=3;rho=0.03;r=0.01;inf=0.03;rmg=0.015;nbg=0;wealth=7;bencap_hc=0.1;bencap_alf=0.1;bencap_nh=0.1;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table0_1_2f_0(i,1) table0_1_2f_1(i,1) table0_1_2f_2(i,1) table0_1_2f_3(i,1) table0_1_2f_4(i,1) table0_1_2f_5(i,1) table0_1_2f_6(i,1) table0_1_2f_7(i,1) table0_1_2f_8(i,1) table0_1_2f_9(i,1) table0_1_2f_10(i,1) table0_1_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==7;
%         crra=3;rho=0.03;r=0.01;inf=0.03;rmg=0.015;nbg=0;wealth=8;bencap_hc=0.1;bencap_alf=0.1;bencap_nh=0.1;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table0_1_2f_0(i,1) table0_1_2f_1(i,1) table0_1_2f_2(i,1) table0_1_2f_3(i,1) table0_1_2f_4(i,1) table0_1_2f_5(i,1) table0_1_2f_6(i,1) table0_1_2f_7(i,1) table0_1_2f_8(i,1) table0_1_2f_9(i,1) table0_1_2f_10(i,1) table0_1_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==8;
%         crra=3;rho=0.03;r=0.01;inf=0.03;rmg=0.015;nbg=0;wealth=9;bencap_hc=0.1;bencap_alf=0.1;bencap_nh=0.1;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table0_1_2f_0(i,1) table0_1_2f_1(i,1) table0_1_2f_2(i,1) table0_1_2f_3(i,1) table0_1_2f_4(i,1) table0_1_2f_5(i,1) table0_1_2f_6(i,1) table0_1_2f_7(i,1) table0_1_2f_8(i,1) table0_1_2f_9(i,1) table0_1_2f_10(i,1) table0_1_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     end;
% end;
% table0_1_2f=[table0_1_2f_0(:,1) table0_1_2f_1(:,1) table0_1_2f_2(:,1) table0_1_2f_3(:,1) table0_1_2f_4(:,1) table0_1_2f_5(:,1) table0_1_2f_6(:,1) table0_1_2f_7(:,1) table0_1_2f_8(:,1) table0_1_2f_9(:,1) table0_1_2f_10(:,1) table0_1_2f_11(:,1)];
% save LTCI_partner_tables table*
% toc
% 
% table0_2_2f_0=zeros(8,1);
% table0_2_2f_1=zeros(8,1);
% table0_2_2f_2=zeros(8,1);
% table0_2_2f_3=zeros(8,1);
% table0_2_2f_4=zeros(8,1);
% table0_2_2f_5=zeros(8,1);
% table0_2_2f_6=zeros(8,1);
% table0_2_2f_7=zeros(8,1);
% table0_2_2f_8=zeros(8,1);
% table0_2_2f_9=zeros(8,1);
% table0_2_2f_10=zeros(8,1);
% table0_2_2f_11=zeros(8,1);
% parfor i=1:8;
%     if i==1;
%         crra=3;rho=0.03;r=0.01;inf=0.03;rmg=0.015;nbg=0;wealth=2;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table0_2_2f_0(i,1) table0_2_2f_1(i,1) table0_2_2f_2(i,1) table0_2_2f_3(i,1) table0_2_2f_4(i,1) table0_2_2f_5(i,1) table0_2_2f_6(i,1) table0_2_2f_7(i,1) table0_2_2f_8(i,1) table0_2_2f_9(i,1) table0_2_2f_10(i,1) table0_2_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==2;
%         crra=3;rho=0.03;r=0.01;inf=0.03;rmg=0.015;nbg=0;wealth=3;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table0_2_2f_0(i,1) table0_2_2f_1(i,1) table0_2_2f_2(i,1) table0_2_2f_3(i,1) table0_2_2f_4(i,1) table0_2_2f_5(i,1) table0_2_2f_6(i,1) table0_2_2f_7(i,1) table0_2_2f_8(i,1) table0_2_2f_9(i,1) table0_2_2f_10(i,1) table0_2_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==3;
%         crra=3;rho=0.03;r=0.01;inf=0.03;rmg=0.015;nbg=0;wealth=4;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table0_2_2f_0(i,1) table0_2_2f_1(i,1) table0_2_2f_2(i,1) table0_2_2f_3(i,1) table0_2_2f_4(i,1) table0_2_2f_5(i,1) table0_2_2f_6(i,1) table0_2_2f_7(i,1) table0_2_2f_8(i,1) table0_2_2f_9(i,1) table0_2_2f_10(i,1) table0_2_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==4;
%         crra=3;rho=0.03;r=0.01;inf=0.03;rmg=0.015;nbg=0;wealth=5;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table0_2_2f_0(i,1) table0_2_2f_1(i,1) table0_2_2f_2(i,1) table0_2_2f_3(i,1) table0_2_2f_4(i,1) table0_2_2f_5(i,1) table0_2_2f_6(i,1) table0_2_2f_7(i,1) table0_2_2f_8(i,1) table0_2_2f_9(i,1) table0_2_2f_10(i,1) table0_2_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==5;
%         crra=3;rho=0.03;r=0.01;inf=0.03;rmg=0.015;nbg=0;wealth=6;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table0_2_2f_0(i,1) table0_2_2f_1(i,1) table0_2_2f_2(i,1) table0_2_2f_3(i,1) table0_2_2f_4(i,1) table0_2_2f_5(i,1) table0_2_2f_6(i,1) table0_2_2f_7(i,1) table0_2_2f_8(i,1) table0_2_2f_9(i,1) table0_2_2f_10(i,1) table0_2_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==6;
%         crra=3;rho=0.03;r=0.01;inf=0.03;rmg=0.015;nbg=0;wealth=7;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table0_2_2f_0(i,1) table0_2_2f_1(i,1) table0_2_2f_2(i,1) table0_2_2f_3(i,1) table0_2_2f_4(i,1) table0_2_2f_5(i,1) table0_2_2f_6(i,1) table0_2_2f_7(i,1) table0_2_2f_8(i,1) table0_2_2f_9(i,1) table0_2_2f_10(i,1) table0_2_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==7;
%         crra=3;rho=0.03;r=0.01;inf=0.03;rmg=0.015;nbg=0;wealth=8;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table0_2_2f_0(i,1) table0_2_2f_1(i,1) table0_2_2f_2(i,1) table0_2_2f_3(i,1) table0_2_2f_4(i,1) table0_2_2f_5(i,1) table0_2_2f_6(i,1) table0_2_2f_7(i,1) table0_2_2f_8(i,1) table0_2_2f_9(i,1) table0_2_2f_10(i,1) table0_2_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==8;
%         crra=3;rho=0.03;r=0.01;inf=0.03;rmg=0.015;nbg=0;wealth=9;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=-1;
%         [table0_2_2f_0(i,1) table0_2_2f_1(i,1) table0_2_2f_2(i,1) table0_2_2f_3(i,1) table0_2_2f_4(i,1) table0_2_2f_5(i,1) table0_2_2f_6(i,1) table0_2_2f_7(i,1) table0_2_2f_8(i,1) table0_2_2f_9(i,1) table0_2_2f_10(i,1) table0_2_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     end;
% end;
% table0_2_2f=[table0_2_2f_0(:,1) table0_2_2f_1(:,1) table0_2_2f_2(:,1) table0_2_2f_3(:,1) table0_2_2f_4(:,1) table0_2_2f_5(:,1) table0_2_2f_6(:,1) table0_2_2f_7(:,1) table0_2_2f_8(:,1) table0_2_2f_9(:,1) table0_2_2f_10(:,1) table0_2_2f_11(:,1)];
% save LTCI_partner_tables table*
% toc
% 
% table1_2f_0=zeros(8,1);
% table1_2f_1=zeros(8,1);
% table1_2f_2=zeros(8,1);
% table1_2f_3=zeros(8,1);
% table1_2f_4=zeros(8,1);
% table1_2f_5=zeros(8,1);
% table1_2f_6=zeros(8,1);
% table1_2f_7=zeros(8,1);
% table1_2f_8=zeros(8,1);
% table1_2f_9=zeros(8,1);
% table1_2f_10=zeros(8,1);
% table1_2f_11=zeros(8,1);
% parfor i=1:8;
%     if i==1;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=2;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table1_2f_0(i,1) table1_2f_1(i,1) table1_2f_2(i,1) table1_2f_3(i,1) table1_2f_4(i,1) table1_2f_5(i,1) table1_2f_6(i,1) table1_2f_7(i,1) table1_2f_8(i,1) table1_2f_9(i,1) table1_2f_10(i,1) table1_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==2;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=3;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table1_2f_0(i,1) table1_2f_1(i,1) table1_2f_2(i,1) table1_2f_3(i,1) table1_2f_4(i,1) table1_2f_5(i,1) table1_2f_6(i,1) table1_2f_7(i,1) table1_2f_8(i,1) table1_2f_9(i,1) table1_2f_10(i,1) table1_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==3;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=4;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table1_2f_0(i,1) table1_2f_1(i,1) table1_2f_2(i,1) table1_2f_3(i,1) table1_2f_4(i,1) table1_2f_5(i,1) table1_2f_6(i,1) table1_2f_7(i,1) table1_2f_8(i,1) table1_2f_9(i,1) table1_2f_10(i,1) table1_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==4;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=5;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table1_2f_0(i,1) table1_2f_1(i,1) table1_2f_2(i,1) table1_2f_3(i,1) table1_2f_4(i,1) table1_2f_5(i,1) table1_2f_6(i,1) table1_2f_7(i,1) table1_2f_8(i,1) table1_2f_9(i,1) table1_2f_10(i,1) table1_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==5;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=6;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table1_2f_0(i,1) table1_2f_1(i,1) table1_2f_2(i,1) table1_2f_3(i,1) table1_2f_4(i,1) table1_2f_5(i,1) table1_2f_6(i,1) table1_2f_7(i,1) table1_2f_8(i,1) table1_2f_9(i,1) table1_2f_10(i,1) table1_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==6;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=7;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table1_2f_0(i,1) table1_2f_1(i,1) table1_2f_2(i,1) table1_2f_3(i,1) table1_2f_4(i,1) table1_2f_5(i,1) table1_2f_6(i,1) table1_2f_7(i,1) table1_2f_8(i,1) table1_2f_9(i,1) table1_2f_10(i,1) table1_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==7;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=8;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table1_2f_0(i,1) table1_2f_1(i,1) table1_2f_2(i,1) table1_2f_3(i,1) table1_2f_4(i,1) table1_2f_5(i,1) table1_2f_6(i,1) table1_2f_7(i,1) table1_2f_8(i,1) table1_2f_9(i,1) table1_2f_10(i,1) table1_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==8;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=9;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table1_2f_0(i,1) table1_2f_1(i,1) table1_2f_2(i,1) table1_2f_3(i,1) table1_2f_4(i,1) table1_2f_5(i,1) table1_2f_6(i,1) table1_2f_7(i,1) table1_2f_8(i,1) table1_2f_9(i,1) table1_2f_10(i,1) table1_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     end;
% end;
% table1_2f=[table1_2f_0(:,1) table1_2f_1(:,1) table1_2f_2(:,1) table1_2f_3(:,1) table1_2f_4(:,1) table1_2f_5(:,1) table1_2f_6(:,1) table1_2f_7(:,1) table1_2f_8(:,1) table1_2f_9(:,1) table1_2f_10(:,1) table1_2f_11(:,1)];
% save LTCI_partner_tables table*
% toc
% 
% table2_2f_0=zeros(8,1);
% table2_2f_1=zeros(8,1);
% table2_2f_2=zeros(8,1);
% table2_2f_3=zeros(8,1);
% table2_2f_4=zeros(8,1);
% table2_2f_5=zeros(8,1);
% table2_2f_6=zeros(8,1);
% table2_2f_7=zeros(8,1);
% table2_2f_8=zeros(8,1);
% table2_2f_9=zeros(8,1);
% table2_2f_10=zeros(8,1);
% table2_2f_11=zeros(8,1);
% parfor i=1:8;
%     if i==1;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0;wealth=2;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table2_2f_0(i,1) table2_2f_1(i,1) table2_2f_2(i,1) table2_2f_3(i,1) table2_2f_4(i,1) table2_2f_5(i,1) table2_2f_6(i,1) table2_2f_7(i,1) table2_2f_8(i,1) table2_2f_9(i,1) table2_2f_10(i,1) table2_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==2;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0;wealth=3;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table2_2f_0(i,1) table2_2f_1(i,1) table2_2f_2(i,1) table2_2f_3(i,1) table2_2f_4(i,1) table2_2f_5(i,1) table2_2f_6(i,1) table2_2f_7(i,1) table2_2f_8(i,1) table2_2f_9(i,1) table2_2f_10(i,1) table2_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==3;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0;wealth=4;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table2_2f_0(i,1) table2_2f_1(i,1) table2_2f_2(i,1) table2_2f_3(i,1) table2_2f_4(i,1) table2_2f_5(i,1) table2_2f_6(i,1) table2_2f_7(i,1) table2_2f_8(i,1) table2_2f_9(i,1) table2_2f_10(i,1) table2_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==4;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0;wealth=5;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table2_2f_0(i,1) table2_2f_1(i,1) table2_2f_2(i,1) table2_2f_3(i,1) table2_2f_4(i,1) table2_2f_5(i,1) table2_2f_6(i,1) table2_2f_7(i,1) table2_2f_8(i,1) table2_2f_9(i,1) table2_2f_10(i,1) table2_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==5;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0;wealth=6;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table2_2f_0(i,1) table2_2f_1(i,1) table2_2f_2(i,1) table2_2f_3(i,1) table2_2f_4(i,1) table2_2f_5(i,1) table2_2f_6(i,1) table2_2f_7(i,1) table2_2f_8(i,1) table2_2f_9(i,1) table2_2f_10(i,1) table2_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==6;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0;wealth=7;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table2_2f_0(i,1) table2_2f_1(i,1) table2_2f_2(i,1) table2_2f_3(i,1) table2_2f_4(i,1) table2_2f_5(i,1) table2_2f_6(i,1) table2_2f_7(i,1) table2_2f_8(i,1) table2_2f_9(i,1) table2_2f_10(i,1) table2_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==7;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0;wealth=8;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table2_2f_0(i,1) table2_2f_1(i,1) table2_2f_2(i,1) table2_2f_3(i,1) table2_2f_4(i,1) table2_2f_5(i,1) table2_2f_6(i,1) table2_2f_7(i,1) table2_2f_8(i,1) table2_2f_9(i,1) table2_2f_10(i,1) table2_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==8;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0;wealth=9;bencap_hc=999999;bencap_alf=999999;bencap_nh=999999;marketload=0;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table2_2f_0(i,1) table2_2f_1(i,1) table2_2f_2(i,1) table2_2f_3(i,1) table2_2f_4(i,1) table2_2f_5(i,1) table2_2f_6(i,1) table2_2f_7(i,1) table2_2f_8(i,1) table2_2f_9(i,1) table2_2f_10(i,1) table2_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     end;
% end;
% table2_2f=[table2_2f_0(:,1) table2_2f_1(:,1) table2_2f_2(:,1) table2_2f_3(:,1) table2_2f_4(:,1) table2_2f_5(:,1) table2_2f_6(:,1) table2_2f_7(:,1) table2_2f_8(:,1) table2_2f_9(:,1) table2_2f_10(:,1) table2_2f_11(:,1)];
% save LTCI_partner_tables table*
% toc
% 
% table3_2f_0=zeros(8,1);
% table3_2f_1=zeros(8,1);
% table3_2f_2=zeros(8,1);
% table3_2f_3=zeros(8,1);
% table3_2f_4=zeros(8,1);
% table3_2f_5=zeros(8,1);
% table3_2f_6=zeros(8,1);
% table3_2f_7=zeros(8,1);
% table3_2f_8=zeros(8,1);
% table3_2f_9=zeros(8,1);
% table3_2f_10=zeros(8,1);
% table3_2f_11=zeros(8,1);
% parfor i=1:8;
%     if i==1;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=2;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table3_2f_0(i,1) table3_2f_1(i,1) table3_2f_2(i,1) table3_2f_3(i,1) table3_2f_4(i,1) table3_2f_5(i,1) table3_2f_6(i,1) table3_2f_7(i,1) table3_2f_8(i,1) table3_2f_9(i,1) table3_2f_10(i,1) table3_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==2;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=3;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table3_2f_0(i,1) table3_2f_1(i,1) table3_2f_2(i,1) table3_2f_3(i,1) table3_2f_4(i,1) table3_2f_5(i,1) table3_2f_6(i,1) table3_2f_7(i,1) table3_2f_8(i,1) table3_2f_9(i,1) table3_2f_10(i,1) table3_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==3;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=4;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table3_2f_0(i,1) table3_2f_1(i,1) table3_2f_2(i,1) table3_2f_3(i,1) table3_2f_4(i,1) table3_2f_5(i,1) table3_2f_6(i,1) table3_2f_7(i,1) table3_2f_8(i,1) table3_2f_9(i,1) table3_2f_10(i,1) table3_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==4;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=5;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table3_2f_0(i,1) table3_2f_1(i,1) table3_2f_2(i,1) table3_2f_3(i,1) table3_2f_4(i,1) table3_2f_5(i,1) table3_2f_6(i,1) table3_2f_7(i,1) table3_2f_8(i,1) table3_2f_9(i,1) table3_2f_10(i,1) table3_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==5;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=6;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table3_2f_0(i,1) table3_2f_1(i,1) table3_2f_2(i,1) table3_2f_3(i,1) table3_2f_4(i,1) table3_2f_5(i,1) table3_2f_6(i,1) table3_2f_7(i,1) table3_2f_8(i,1) table3_2f_9(i,1) table3_2f_10(i,1) table3_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==6;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=7;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table3_2f_0(i,1) table3_2f_1(i,1) table3_2f_2(i,1) table3_2f_3(i,1) table3_2f_4(i,1) table3_2f_5(i,1) table3_2f_6(i,1) table3_2f_7(i,1) table3_2f_8(i,1) table3_2f_9(i,1) table3_2f_10(i,1) table3_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==7;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=8;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table3_2f_0(i,1) table3_2f_1(i,1) table3_2f_2(i,1) table3_2f_3(i,1) table3_2f_4(i,1) table3_2f_5(i,1) table3_2f_6(i,1) table3_2f_7(i,1) table3_2f_8(i,1) table3_2f_9(i,1) table3_2f_10(i,1) table3_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==8;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=9;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=480;hcdaycount=1;NY=0;
%         [table3_2f_0(i,1) table3_2f_1(i,1) table3_2f_2(i,1) table3_2f_3(i,1) table3_2f_4(i,1) table3_2f_5(i,1) table3_2f_6(i,1) table3_2f_7(i,1) table3_2f_8(i,1) table3_2f_9(i,1) table3_2f_10(i,1) table3_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     end;
% end;
% table3_2f=[table3_2f_0(:,1) table3_2f_1(:,1) table3_2f_2(:,1) table3_2f_3(:,1) table3_2f_4(:,1) table3_2f_5(:,1) table3_2f_6(:,1) table3_2f_7(:,1) table3_2f_8(:,1) table3_2f_9(:,1) table3_2f_10(:,1) table3_2f_11(:,1)];
% save LTCI_partner_tables table*
% toc
% 
% table4_1_2f_0=zeros(8,1);
% table4_1_2f_1=zeros(8,1);
% table4_1_2f_2=zeros(8,1);
% table4_1_2f_3=zeros(8,1);
% table4_1_2f_4=zeros(8,1);
% table4_1_2f_5=zeros(8,1);
% table4_1_2f_6=zeros(8,1);
% table4_1_2f_7=zeros(8,1);
% table4_1_2f_8=zeros(8,1);
% table4_1_2f_9=zeros(8,1);
% table4_1_2f_10=zeros(8,1);
% table4_1_2f_11=zeros(8,1);
% parfor i=1:8;
%     if i==1;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=2;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_1_2f_0(i,1) table4_1_2f_1(i,1) table4_1_2f_2(i,1) table4_1_2f_3(i,1) table4_1_2f_4(i,1) table4_1_2f_5(i,1) table4_1_2f_6(i,1) table4_1_2f_7(i,1) table4_1_2f_8(i,1) table4_1_2f_9(i,1) table4_1_2f_10(i,1) table4_1_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==2;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=3;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_1_2f_0(i,1) table4_1_2f_1(i,1) table4_1_2f_2(i,1) table4_1_2f_3(i,1) table4_1_2f_4(i,1) table4_1_2f_5(i,1) table4_1_2f_6(i,1) table4_1_2f_7(i,1) table4_1_2f_8(i,1) table4_1_2f_9(i,1) table4_1_2f_10(i,1) table4_1_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==3;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=4;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_1_2f_0(i,1) table4_1_2f_1(i,1) table4_1_2f_2(i,1) table4_1_2f_3(i,1) table4_1_2f_4(i,1) table4_1_2f_5(i,1) table4_1_2f_6(i,1) table4_1_2f_7(i,1) table4_1_2f_8(i,1) table4_1_2f_9(i,1) table4_1_2f_10(i,1) table4_1_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==4;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=5;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_1_2f_0(i,1) table4_1_2f_1(i,1) table4_1_2f_2(i,1) table4_1_2f_3(i,1) table4_1_2f_4(i,1) table4_1_2f_5(i,1) table4_1_2f_6(i,1) table4_1_2f_7(i,1) table4_1_2f_8(i,1) table4_1_2f_9(i,1) table4_1_2f_10(i,1) table4_1_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==5;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=6;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_1_2f_0(i,1) table4_1_2f_1(i,1) table4_1_2f_2(i,1) table4_1_2f_3(i,1) table4_1_2f_4(i,1) table4_1_2f_5(i,1) table4_1_2f_6(i,1) table4_1_2f_7(i,1) table4_1_2f_8(i,1) table4_1_2f_9(i,1) table4_1_2f_10(i,1) table4_1_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==6;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=7;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_1_2f_0(i,1) table4_1_2f_1(i,1) table4_1_2f_2(i,1) table4_1_2f_3(i,1) table4_1_2f_4(i,1) table4_1_2f_5(i,1) table4_1_2f_6(i,1) table4_1_2f_7(i,1) table4_1_2f_8(i,1) table4_1_2f_9(i,1) table4_1_2f_10(i,1) table4_1_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==7;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=8;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_1_2f_0(i,1) table4_1_2f_1(i,1) table4_1_2f_2(i,1) table4_1_2f_3(i,1) table4_1_2f_4(i,1) table4_1_2f_5(i,1) table4_1_2f_6(i,1) table4_1_2f_7(i,1) table4_1_2f_8(i,1) table4_1_2f_9(i,1) table4_1_2f_10(i,1) table4_1_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==8;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=9;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_1_2f_0(i,1) table4_1_2f_1(i,1) table4_1_2f_2(i,1) table4_1_2f_3(i,1) table4_1_2f_4(i,1) table4_1_2f_5(i,1) table4_1_2f_6(i,1) table4_1_2f_7(i,1) table4_1_2f_8(i,1) table4_1_2f_9(i,1) table4_1_2f_10(i,1) table4_1_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     end;
% end;
% table4_1_2f=[table4_1_2f_0(:,1) table4_1_2f_1(:,1) table4_1_2f_2(:,1) table4_1_2f_3(:,1) table4_1_2f_4(:,1) table4_1_2f_5(:,1) table4_1_2f_6(:,1) table4_1_2f_7(:,1) table4_1_2f_8(:,1) table4_1_2f_9(:,1) table4_1_2f_10(:,1) table4_1_2f_11(:,1)];
% save LTCI_partner_tables table*
% toc
% 
% table4_2_2f_0=zeros(8,1);
% table4_2_2f_1=zeros(8,1);
% table4_2_2f_2=zeros(8,1);
% table4_2_2f_3=zeros(8,1);
% table4_2_2f_4=zeros(8,1);
% table4_2_2f_5=zeros(8,1);
% table4_2_2f_6=zeros(8,1);
% table4_2_2f_7=zeros(8,1);
% table4_2_2f_8=zeros(8,1);
% table4_2_2f_9=zeros(8,1);
% table4_2_2f_10=zeros(8,1);
% table4_2_2f_11=zeros(8,1);
% parfor i=1:8;
%     if i==1;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=2;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_2_2f_0(i,1) table4_2_2f_1(i,1) table4_2_2f_2(i,1) table4_2_2f_3(i,1) table4_2_2f_4(i,1) table4_2_2f_5(i,1) table4_2_2f_6(i,1) table4_2_2f_7(i,1) table4_2_2f_8(i,1) table4_2_2f_9(i,1) table4_2_2f_10(i,1) table4_2_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==2;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=3;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_2_2f_0(i,1) table4_2_2f_1(i,1) table4_2_2f_2(i,1) table4_2_2f_3(i,1) table4_2_2f_4(i,1) table4_2_2f_5(i,1) table4_2_2f_6(i,1) table4_2_2f_7(i,1) table4_2_2f_8(i,1) table4_2_2f_9(i,1) table4_2_2f_10(i,1) table4_2_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==3;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=4;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_2_2f_0(i,1) table4_2_2f_1(i,1) table4_2_2f_2(i,1) table4_2_2f_3(i,1) table4_2_2f_4(i,1) table4_2_2f_5(i,1) table4_2_2f_6(i,1) table4_2_2f_7(i,1) table4_2_2f_8(i,1) table4_2_2f_9(i,1) table4_2_2f_10(i,1) table4_2_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==4;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=5;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_2_2f_0(i,1) table4_2_2f_1(i,1) table4_2_2f_2(i,1) table4_2_2f_3(i,1) table4_2_2f_4(i,1) table4_2_2f_5(i,1) table4_2_2f_6(i,1) table4_2_2f_7(i,1) table4_2_2f_8(i,1) table4_2_2f_9(i,1) table4_2_2f_10(i,1) table4_2_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==5;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=6;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_2_2f_0(i,1) table4_2_2f_1(i,1) table4_2_2f_2(i,1) table4_2_2f_3(i,1) table4_2_2f_4(i,1) table4_2_2f_5(i,1) table4_2_2f_6(i,1) table4_2_2f_7(i,1) table4_2_2f_8(i,1) table4_2_2f_9(i,1) table4_2_2f_10(i,1) table4_2_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==6;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=7;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_2_2f_0(i,1) table4_2_2f_1(i,1) table4_2_2f_2(i,1) table4_2_2f_3(i,1) table4_2_2f_4(i,1) table4_2_2f_5(i,1) table4_2_2f_6(i,1) table4_2_2f_7(i,1) table4_2_2f_8(i,1) table4_2_2f_9(i,1) table4_2_2f_10(i,1) table4_2_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==7;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=8;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_2_2f_0(i,1) table4_2_2f_1(i,1) table4_2_2f_2(i,1) table4_2_2f_3(i,1) table4_2_2f_4(i,1) table4_2_2f_5(i,1) table4_2_2f_6(i,1) table4_2_2f_7(i,1) table4_2_2f_8(i,1) table4_2_2f_9(i,1) table4_2_2f_10(i,1) table4_2_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==8;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=9;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=0;sick_T=36;hcdaycount=1;NY=0;
%         [table4_2_2f_0(i,1) table4_2_2f_1(i,1) table4_2_2f_2(i,1) table4_2_2f_3(i,1) table4_2_2f_4(i,1) table4_2_2f_5(i,1) table4_2_2f_6(i,1) table4_2_2f_7(i,1) table4_2_2f_8(i,1) table4_2_2f_9(i,1) table4_2_2f_10(i,1) table4_2_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     end;
% end;
% table4_2_2f=[table4_2_2f_0(:,1) table4_2_2f_1(:,1) table4_2_2f_2(:,1) table4_2_2f_3(:,1) table4_2_2f_4(:,1) table4_2_2f_5(:,1) table4_2_2f_6(:,1) table4_2_2f_7(:,1) table4_2_2f_8(:,1) table4_2_2f_9(:,1) table4_2_2f_10(:,1) table4_2_2f_11(:,1)];
% save LTCI_partner_tables table*
% toc
% 
% table5_2f_0=zeros(8,1);
% table5_2f_1=zeros(8,1);
% table5_2f_2=zeros(8,1);
% table5_2f_3=zeros(8,1);
% table5_2f_4=zeros(8,1);
% table5_2f_5=zeros(8,1);
% table5_2f_6=zeros(8,1);
% table5_2f_7=zeros(8,1);
% table5_2f_8=zeros(8,1);
% table5_2f_9=zeros(8,1);
% table5_2f_10=zeros(8,1);
% table5_2f_11=zeros(8,1);
% parfor i=1:8;
%     if i==1;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=2;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=1;sick_T=36;hcdaycount=1;NY=0;
%         [table5_2f_0(i,1) table5_2f_1(i,1) table5_2f_2(i,1) table5_2f_3(i,1) table5_2f_4(i,1) table5_2f_5(i,1) table5_2f_6(i,1) table5_2f_7(i,1) table5_2f_8(i,1) table5_2f_9(i,1) table5_2f_10(i,1) table5_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==2;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=3;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=1;sick_T=36;hcdaycount=1;NY=0;
%         [table5_2f_0(i,1) table5_2f_1(i,1) table5_2f_2(i,1) table5_2f_3(i,1) table5_2f_4(i,1) table5_2f_5(i,1) table5_2f_6(i,1) table5_2f_7(i,1) table5_2f_8(i,1) table5_2f_9(i,1) table5_2f_10(i,1) table5_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==3;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=4;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=1;sick_T=36;hcdaycount=1;NY=0;
%         [table5_2f_0(i,1) table5_2f_1(i,1) table5_2f_2(i,1) table5_2f_3(i,1) table5_2f_4(i,1) table5_2f_5(i,1) table5_2f_6(i,1) table5_2f_7(i,1) table5_2f_8(i,1) table5_2f_9(i,1) table5_2f_10(i,1) table5_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==4;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=5;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=1;sick_T=36;hcdaycount=1;NY=0;
%         [table5_2f_0(i,1) table5_2f_1(i,1) table5_2f_2(i,1) table5_2f_3(i,1) table5_2f_4(i,1) table5_2f_5(i,1) table5_2f_6(i,1) table5_2f_7(i,1) table5_2f_8(i,1) table5_2f_9(i,1) table5_2f_10(i,1) table5_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==5;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=6;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=1;sick_T=36;hcdaycount=1;NY=0;
%         [table5_2f_0(i,1) table5_2f_1(i,1) table5_2f_2(i,1) table5_2f_3(i,1) table5_2f_4(i,1) table5_2f_5(i,1) table5_2f_6(i,1) table5_2f_7(i,1) table5_2f_8(i,1) table5_2f_9(i,1) table5_2f_10(i,1) table5_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==6;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=7;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=1;sick_T=36;hcdaycount=1;NY=0;
%         [table5_2f_0(i,1) table5_2f_1(i,1) table5_2f_2(i,1) table5_2f_3(i,1) table5_2f_4(i,1) table5_2f_5(i,1) table5_2f_6(i,1) table5_2f_7(i,1) table5_2f_8(i,1) table5_2f_9(i,1) table5_2f_10(i,1) table5_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==7;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=8;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=1;sick_T=36;hcdaycount=1;NY=0;
%         [table5_2f_0(i,1) table5_2f_1(i,1) table5_2f_2(i,1) table5_2f_3(i,1) table5_2f_4(i,1) table5_2f_5(i,1) table5_2f_6(i,1) table5_2f_7(i,1) table5_2f_8(i,1) table5_2f_9(i,1) table5_2f_10(i,1) table5_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==8;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=9;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=1;sick_T=36;hcdaycount=1;NY=0;
%         [table5_2f_0(i,1) table5_2f_1(i,1) table5_2f_2(i,1) table5_2f_3(i,1) table5_2f_4(i,1) table5_2f_5(i,1) table5_2f_6(i,1) table5_2f_7(i,1) table5_2f_8(i,1) table5_2f_9(i,1) table5_2f_10(i,1) table5_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     end;
% end;
% table5_2f=[table5_2f_0(:,1) table5_2f_1(:,1) table5_2f_2(:,1) table5_2f_3(:,1) table5_2f_4(:,1) table5_2f_5(:,1) table5_2f_6(:,1) table5_2f_7(:,1) table5_2f_8(:,1) table5_2f_9(:,1) table5_2f_10(:,1) table5_2f_11(:,1)];
% save LTCI_partner_tables table*
% toc
% 
% table6_2f_0=zeros(8,1);
% table6_2f_1=zeros(8,1);
% table6_2f_2=zeros(8,1);
% table6_2f_3=zeros(8,1);
% table6_2f_4=zeros(8,1);
% table6_2f_5=zeros(8,1);
% table6_2f_6=zeros(8,1);
% table6_2f_7=zeros(8,1);
% table6_2f_8=zeros(8,1);
% table6_2f_9=zeros(8,1);
% table6_2f_10=zeros(8,1);
% table6_2f_11=zeros(8,1);
% parfor i=1:8;
%     if i==1;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=2;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table6_2f_0(i,1) table6_2f_1(i,1) table6_2f_2(i,1) table6_2f_3(i,1) table6_2f_4(i,1) table6_2f_5(i,1) table6_2f_6(i,1) table6_2f_7(i,1) table6_2f_8(i,1) table6_2f_9(i,1) table6_2f_10(i,1) table6_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==2;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=3;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table6_2f_0(i,1) table6_2f_1(i,1) table6_2f_2(i,1) table6_2f_3(i,1) table6_2f_4(i,1) table6_2f_5(i,1) table6_2f_6(i,1) table6_2f_7(i,1) table6_2f_8(i,1) table6_2f_9(i,1) table6_2f_10(i,1) table6_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==3;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=4;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table6_2f_0(i,1) table6_2f_1(i,1) table6_2f_2(i,1) table6_2f_3(i,1) table6_2f_4(i,1) table6_2f_5(i,1) table6_2f_6(i,1) table6_2f_7(i,1) table6_2f_8(i,1) table6_2f_9(i,1) table6_2f_10(i,1) table6_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==4;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=5;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table6_2f_0(i,1) table6_2f_1(i,1) table6_2f_2(i,1) table6_2f_3(i,1) table6_2f_4(i,1) table6_2f_5(i,1) table6_2f_6(i,1) table6_2f_7(i,1) table6_2f_8(i,1) table6_2f_9(i,1) table6_2f_10(i,1) table6_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==5;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=6;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table6_2f_0(i,1) table6_2f_1(i,1) table6_2f_2(i,1) table6_2f_3(i,1) table6_2f_4(i,1) table6_2f_5(i,1) table6_2f_6(i,1) table6_2f_7(i,1) table6_2f_8(i,1) table6_2f_9(i,1) table6_2f_10(i,1) table6_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==6;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=7;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table6_2f_0(i,1) table6_2f_1(i,1) table6_2f_2(i,1) table6_2f_3(i,1) table6_2f_4(i,1) table6_2f_5(i,1) table6_2f_6(i,1) table6_2f_7(i,1) table6_2f_8(i,1) table6_2f_9(i,1) table6_2f_10(i,1) table6_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==7;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=8;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table6_2f_0(i,1) table6_2f_1(i,1) table6_2f_2(i,1) table6_2f_3(i,1) table6_2f_4(i,1) table6_2f_5(i,1) table6_2f_6(i,1) table6_2f_7(i,1) table6_2f_8(i,1) table6_2f_9(i,1) table6_2f_10(i,1) table6_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==8;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=9;bencap_hc=0.241;bencap_alf=0.241;bencap_nh=0.241;marketload=1;singlem=0;singlef=1;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table6_2f_0(i,1) table6_2f_1(i,1) table6_2f_2(i,1) table6_2f_3(i,1) table6_2f_4(i,1) table6_2f_5(i,1) table6_2f_6(i,1) table6_2f_7(i,1) table6_2f_8(i,1) table6_2f_9(i,1) table6_2f_10(i,1) table6_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     end;
% end;
% table6_2f=[table6_2f_0(:,1) table6_2f_1(:,1) table6_2f_2(:,1) table6_2f_3(:,1) table6_2f_4(:,1) table6_2f_5(:,1) table6_2f_6(:,1) table6_2f_7(:,1) table6_2f_8(:,1) table6_2f_9(:,1) table6_2f_10(:,1) table6_2f_11(:,1)];
% save LTCI_partner_tables table*
% toc
% 
% table7_2f_0=zeros(8,1);
% table7_2f_1=zeros(8,1);
% table7_2f_2=zeros(8,1);
% table7_2f_3=zeros(8,1);
% table7_2f_4=zeros(8,1);
% table7_2f_5=zeros(8,1);
% table7_2f_6=zeros(8,1);
% table7_2f_7=zeros(8,1);
% table7_2f_8=zeros(8,1);
% table7_2f_9=zeros(8,1);
% table7_2f_10=zeros(8,1);
% table7_2f_11=zeros(8,1);
% parfor i=1:8;
%     if i==1;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=2;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=0;singlef=1;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table7_2f_0(i,1) table7_2f_1(i,1) table7_2f_2(i,1) table7_2f_3(i,1) table7_2f_4(i,1) table7_2f_5(i,1) table7_2f_6(i,1) table7_2f_7(i,1) table7_2f_8(i,1) table7_2f_9(i,1) table7_2f_10(i,1) table7_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==2;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=3;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=0;singlef=1;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table7_2f_0(i,1) table7_2f_1(i,1) table7_2f_2(i,1) table7_2f_3(i,1) table7_2f_4(i,1) table7_2f_5(i,1) table7_2f_6(i,1) table7_2f_7(i,1) table7_2f_8(i,1) table7_2f_9(i,1) table7_2f_10(i,1) table7_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==3;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=4;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=0;singlef=1;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table7_2f_0(i,1) table7_2f_1(i,1) table7_2f_2(i,1) table7_2f_3(i,1) table7_2f_4(i,1) table7_2f_5(i,1) table7_2f_6(i,1) table7_2f_7(i,1) table7_2f_8(i,1) table7_2f_9(i,1) table7_2f_10(i,1) table7_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==4;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=5;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=0;singlef=1;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table7_2f_0(i,1) table7_2f_1(i,1) table7_2f_2(i,1) table7_2f_3(i,1) table7_2f_4(i,1) table7_2f_5(i,1) table7_2f_6(i,1) table7_2f_7(i,1) table7_2f_8(i,1) table7_2f_9(i,1) table7_2f_10(i,1) table7_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==5;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=6;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=0;singlef=1;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table7_2f_0(i,1) table7_2f_1(i,1) table7_2f_2(i,1) table7_2f_3(i,1) table7_2f_4(i,1) table7_2f_5(i,1) table7_2f_6(i,1) table7_2f_7(i,1) table7_2f_8(i,1) table7_2f_9(i,1) table7_2f_10(i,1) table7_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==6;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=7;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=0;singlef=1;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table7_2f_0(i,1) table7_2f_1(i,1) table7_2f_2(i,1) table7_2f_3(i,1) table7_2f_4(i,1) table7_2f_5(i,1) table7_2f_6(i,1) table7_2f_7(i,1) table7_2f_8(i,1) table7_2f_9(i,1) table7_2f_10(i,1) table7_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==7;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=8;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=0;singlef=1;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table7_2f_0(i,1) table7_2f_1(i,1) table7_2f_2(i,1) table7_2f_3(i,1) table7_2f_4(i,1) table7_2f_5(i,1) table7_2f_6(i,1) table7_2f_7(i,1) table7_2f_8(i,1) table7_2f_9(i,1) table7_2f_10(i,1) table7_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     elseif i==8;
%         crra=3;rho=0.03;r=0.01;inf=0.025;rmg=0.015;nbg=0.05;wealth=9;bencap_hc=0.158;bencap_alf=0.158;bencap_nh=0.158;marketload=1;singlem=0;singlef=1;couple=0;partner=3;sick_T=36;hcdaycount=1;NY=0;
%         [table7_2f_0(i,1) table7_2f_1(i,1) table7_2f_2(i,1) table7_2f_3(i,1) table7_2f_4(i,1) table7_2f_5(i,1) table7_2f_6(i,1) table7_2f_7(i,1) table7_2f_8(i,1) table7_2f_9(i,1) table7_2f_10(i,1) table7_2f_11(i,1)]=fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,partner,sick_T,hcdaycount,NY);
%     end;
% end;
% table7_2f=[table7_2f_0(:,1) table7_2f_1(:,1) table7_2f_2(:,1) table7_2f_3(:,1) table7_2f_4(:,1) table7_2f_5(:,1) table7_2f_6(:,1) table7_2f_7(:,1) table7_2f_8(:,1) table7_2f_9(:,1) table7_2f_10(:,1) table7_2f_11(:,1)];
% save LTCI_partner_tables table*
% toc


























