function [eqwealth Mcaidshare_noLTCI Mcaidshare_LTCI imptax netload medcost_LTCI medcost_noLTCI Medicaid_LTCI Medicaid_beforeprogram_LTCI Medicaid_noLTCI benefit_LTCI premium_LTCI]= ...
    fn_LTCI(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,defer,sick_T,hcdaycount,NY)

if defer==0 && sick_T>0;
    disp('check defer type');
    return;
end;

if singlem==1;
    LTCI=0; % no LTCI;
    para=fn_readin(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,defer,sick_T,hcdaycount,NY,LTCI);
    [opti_noLTCI.s opti_noLTCI.x opti_noLTCI.v]=fn_policy_function_nodefer_sm(para,LTCI);
    LTCI=1; % hold LTCI;
    para=fn_readin(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,defer,sick_T,hcdaycount,NY,LTCI);
    if para.defer==0 && para.sick_T==0;
        [opti_LTCI.s opti_LTCI.x opti_LTCI.v]=fn_policy_function_nodefer_sm(para,LTCI);
    elseif para.defer==1;
        [opti_LTCI.s opti_LTCI.x opti_LTCI.v]=fn_policy_function_elimination_sm(para,LTCI);
    elseif para.defer==2;
        [opti_LTCI.s opti_LTCI.x opti_LTCI.v]=fn_policy_function_deductible_sm(para,LTCI);
    end;
elseif singlef==1;
    LTCI=0;
    para=fn_readin(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,defer,sick_T,hcdaycount,NY,LTCI);
    [opti_noLTCI.s opti_noLTCI.x opti_noLTCI.v]=fn_policy_function_nodefer_sf(para,LTCI); 
    LTCI=1;
    para=fn_readin(crra,rho,r,inf,rmg,nbg,wealth,bencap_hc,bencap_alf,bencap_nh,marketload,singlem,singlef,couple,defer,sick_T,hcdaycount,NY,LTCI);
    if para.defer==0 && para.sick_T==0;
        [opti_LTCI.s opti_LTCI.x opti_LTCI.v]=fn_policy_function_nodefer_sf(para,LTCI);
    elseif para.defer==1;
        [opti_LTCI.s opti_LTCI.x opti_LTCI.v]=fn_policy_function_elimination_sf(para,LTCI);
    elseif para.defer==2;
        [opti_LTCI.s opti_LTCI.x opti_LTCI.v]=fn_policy_function_deductible_sf(para,LTCI);
    end;
elseif couple==1;
end;

% save (['policy','_crra',num2str(crra),'_rho',num2str(rho*100),'_r',num2str(r*100),'_inf',num2str(inf*1000),'_rmg',num2str(rmg*1000),'_nbg',num2str(nbg*100),...
%     '_wealth',num2str(wealth),'_bencap_hc',num2str(bencap_hc*1000),'_bencap_nh',num2str(bencap_nh*1000),'_marketload',num2str(marketload),'_singlem',num2str(singlem),'_singlef',num2str(singlef),...
%     '_defer',num2str(defer),'_sick_T',num2str(sick_T),'_hcdaycount',num2str(hcdaycount*10),'_NY',num2str(NY+1)])
% save (['defer',num2str(defer),'_wealth',num2str(wealth)]);

maxv1=interp1(opti_LTCI.s.a(1:para.grid_asset,1),opti_LTCI.v.a(1:para.grid_asset,1),para.cash,'linear','extrap');
eqwealth=interp1(opti_noLTCI.v.a(:,1),opti_noLTCI.s.a(:,1),maxv1,'linear','extrap')-para.cash;

[simul simul_LTCI simul_noLTCI]=fn_simul(para,opti_LTCI,opti_noLTCI); %#ok<ASGLU>
Mcaidshare_LTCI=sum(mean(simul_LTCI.Medicaid(:,:)))/sum(mean(simul_LTCI.medcost(:,:)));
Mcaidshare_noLTCI=sum(mean(simul_noLTCI.Medicaid(:,:)))/sum(mean(simul_noLTCI.medcost(:,:)));
imptax=(sum(mean(simul_noLTCI.Medicaid(:,:)))-sum(mean(simul_LTCI.Medicaid(:,:))))/sum(mean(simul_LTCI.benefit(:,:)));
netload=1-para.insload+(sum(mean(simul_noLTCI.Medicaid(:,:)))-sum(mean(simul_LTCI.Medicaid(:,:))))/sum(mean(simul_LTCI.premium(:,:)));
medcost_LTCI=sum(mean(simul_LTCI.medcost(:,:)));
medcost_noLTCI=sum(mean(simul_noLTCI.medcost(:,:)));
Medicaid_LTCI=sum(mean(simul_LTCI.Medicaid(:,:)));
Medicaid_beforeprogram_LTCI=sum(mean(simul_LTCI.Medicaid_beforeprogram(:,:)));
Medicaid_noLTCI=sum(mean(simul_noLTCI.Medicaid(:,:)));
benefit_LTCI=sum(mean(simul_LTCI.benefit(:,:)));
premium_LTCI=sum(mean(simul_LTCI.premium(:,:)));


























