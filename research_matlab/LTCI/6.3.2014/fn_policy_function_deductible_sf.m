function [optisf optixf optivf]=fn_policy_function_deductible_sf(para,LTCI)

optisf.a=zeros(para.ns,para.ds);
optixf.a=zeros(para.ns,para.dx);
optivf.a=zeros(para.ns,1);
optixf.healthy=zeros(para.ns,para.dx,para.T);
optivf.healthy=zeros(para.ns,para.T);
optixf.hc=zeros(para.ns,para.dx,para.T);
optivf.hc=zeros(para.ns,para.T);
optixf.alf=zeros(para.ns,para.dx,para.T);
optivf.alf=zeros(para.ns,para.T);
optixf.nh=zeros(para.ns,para.dx,para.T);
optivf.nh=zeros(para.ns,para.T);

% discretitize state variables;
s_asset_min=log(0.00099);  % min is 99 cents. It's not $1 is to provent the 1e-19 i.e. sprime_asset out of range..
s_asset_max=log(para.cash*2.5);
logs_asset=(s_asset_min:(s_asset_max-s_asset_min)/(para.grid_asset-1):s_asset_max)'; 
s_asset=exp(logs_asset);
s_medcost_nominal_min=0;
s_medcost_nominal_max=para.sick_T+1;
s_medcost_nominal=(s_medcost_nominal_min:(s_medcost_nominal_max-s_medcost_nominal_min)/(para.grid_medcost_nominal-1):s_medcost_nominal_max)';
s_protect=[0;1];
% state space;
s=fn_gridmake(s_asset,s_medcost_nominal,s_protect);
optisf.a(:,:)=s;

% discretitize action variables;
x_consumption_min=log(0.0001);
x_consumption_max=log(1);
logx_consumption=(x_consumption_min:(x_consumption_max-x_consumption_min)/(para.grid_consumption-1):x_consumption_max)';
x_consumption=exp(logx_consumption);
% x_consumption=(0:1/(para.grid_consumption-1):1)';
% action space;
x_layer1=fn_gridmake(x_consumption);

% combine state space and action space;
[asset,medcost_nominal,protect,consumption]=fn_gridmake(s,x_layer1); %#ok<ASGLU>

% BACKWARD RECURSION
for t=para.T:-1:1;
    t %#ok<NOPRT>
    % Healthy state
    F_healthy=fn_utility(para.cons_healthy+(asset+para.ss-LTCI*para.P(t,1)).*consumption,para.crra);
    % hc state 
    Mcaid_hc=(asset+para.ss+LTCI*(medcost_nominal>para.sick_T)*para.B(t,2)-(medcost_nominal<=para.sick_T)*para.P(t,1)-para.M(t,2)<para.cbar_hc+para.wbar).*(para.ss+LTCI*(medcost_nominal>para.sick_T)*para.B(t,2)-(medcost_nominal<=para.sick_T)*para.P(t,1)-para.M(t,2)+(para.RB-1)*asset/para.RB<para.cbar_hc); % (para.RB-1)*asset/para.RB is interest income;
    F_hc=fn_utility(para.cons_hc+Mcaid_hc.*(para.cbar_hc+min(asset-(para.RB-1)*asset/para.RB,para.wbar).*consumption)+(1-Mcaid_hc).*(asset+para.ss+LTCI*(medcost_nominal>para.sick_T)*para.B(t,2)-(medcost_nominal<=para.sick_T)*para.P(t,1)-para.M(t,2)).*consumption,para.crra);
    % alf state
    Mcaid_alf=(asset+para.ss+LTCI*(medcost_nominal>para.sick_T)*para.B(t,3)-(medcost_nominal<=para.sick_T)*para.P(t,1)-para.M(t,3)<para.cbar_alf+para.wbar).*(para.ss+LTCI*(medcost_nominal>para.sick_T)*para.B(t,3)-(medcost_nominal<=para.sick_T)*para.P(t,1)-para.M(t,3)+(para.RB-1)*asset/para.RB<para.cbar_alf);
    F_alf=fn_utility(para.cons_alf+Mcaid_alf.*(para.cbar_alf+min(asset-(para.RB-1)*asset/para.RB,para.wbar).*consumption)+(1-Mcaid_alf).*(asset+para.ss+LTCI*(medcost_nominal>para.sick_T)*para.B(t,3)-(medcost_nominal<=para.sick_T)*para.P(t,1)-para.M(t,3)).*consumption,para.crra);    
    % nh state
    Mcaid_nh=(asset+para.ss+LTCI*(medcost_nominal>para.sick_T)*para.B(t,4)-(medcost_nominal<=para.sick_T)*para.P(t,1)-para.M(t,4)<para.cbar_nh+para.wbar).*(para.ss+LTCI*(medcost_nominal>para.sick_T)*para.B(t,4)-(medcost_nominal<=para.sick_T)*para.P(t,1)-para.M(t,4)+(para.RB-1)*asset/para.RB<para.cbar_nh);
    F_nh=fn_utility(para.cons_nh+Mcaid_nh.*(para.cbar_nh+min(asset-(para.RB-1)*asset/para.RB,para.wbar).*consumption)+(1-Mcaid_nh).*(asset+para.ss+LTCI*(medcost_nominal>para.sick_T)*para.B(t,4)-(medcost_nominal<=para.sick_T)*para.P(t,1)-para.M(t,4)).*consumption,para.crra);
  
    % FROM THE LAST PERIOD
    if t==para.T;
        [v,j]=max(reshape(F_healthy,size(s,1),size(x_layer1,1)),[],2);
        optixf.healthy(:,:,t) = x_layer1(j,:);
        optivf.healthy(:,t) = v;
        [v,j]=max(reshape(F_hc,size(s,1),size(x_layer1,1)),[],2);
        optixf.hc(:,:,t) = x_layer1(j,:);
        optivf.hc(:,t) = v;
        [v,j]=max(reshape(F_alf,size(s,1),size(x_layer1,1)),[],2);
        optixf.alf(:,:,t) = x_layer1(j,:);
        optivf.alf(:,t) = v;
        [v,j]=max(reshape(F_nh,size(s,1),size(x_layer1,1)),[],2);
        optixf.nh(:,:,t) = x_layer1(j,:);
        optivf.nh(:,t) = v;
    end;
    if t<para.T;
        sprime_asset_healthy=max(0.001,(asset+para.ss-LTCI*para.P(t,1)).*(1-consumption)*para.RB);
        sprime_asset_hc =max(0.001,(Mcaid_hc .*min(asset-(para.RB-1)*asset/para.RB,para.wbar)+(1-Mcaid_hc) .*(asset+para.ss+LTCI*(medcost_nominal>para.sick_T)*para.B(t,2)-(medcost_nominal<=para.sick_T)*para.P(t,1)-para.M(t,2))).*(1-consumption)*para.RB);
        sprime_asset_alf=max(0.001,(Mcaid_alf.*min(asset-(para.RB-1)*asset/para.RB,para.wbar)+(1-Mcaid_alf).*(asset+para.ss+LTCI*(medcost_nominal>para.sick_T)*para.B(t,3)-(medcost_nominal<=para.sick_T)*para.P(t,1)-para.M(t,3))).*(1-consumption)*para.RB);
        sprime_asset_nh =max(0.001,(Mcaid_nh .*min(asset-(para.RB-1)*asset/para.RB,para.wbar)+(1-Mcaid_nh) .*(asset+para.ss+LTCI*(medcost_nominal>para.sick_T)*para.B(t,4)-(medcost_nominal<=para.sick_T)*para.P(t,1)-para.M(t,4))).*(1-consumption)*para.RB);
        sprime_medcost_nominal_healthy=medcost_nominal;
        sprime_medcost_nominal_hc=min(para.sick_T+1,medcost_nominal+para.M(t,2)*para.ifactor(t,1));
        sprime_medcost_nominal_alf=min(para.sick_T+1,medcost_nominal+para.M(t,3)*para.ifactor(t,1));
        sprime_medcost_nominal_nh=min(para.sick_T+1,medcost_nominal+para.M(t,4)*para.ifactor(t,1));
        sprime_protect_healthy=zeros(para.nc,1);
        sprime_protect_hc=zeros(para.nc,1);
        sprime_protect_alf=zeros(para.nc,1);
        sprime_protect_nh=zeros(para.nc,1);

        EV_healthy_healthy=interpn(s_asset,s_medcost_nominal,s_protect,reshape(optivf.healthy(:,t+1),para.grid_asset,para.grid_medcost_nominal,para.grid_protect),sprime_asset_healthy,sprime_medcost_nominal_healthy,sprime_protect_healthy,'linear');
        EV_healthy_hc=interpn(s_asset,s_medcost_nominal,s_protect,reshape(optivf.hc(:,t+1),para.grid_asset,para.grid_medcost_nominal,para.grid_protect),sprime_asset_healthy,sprime_medcost_nominal_healthy,sprime_protect_healthy,'linear');        
        EV_healthy_alf=interpn(s_asset,s_medcost_nominal,s_protect,reshape(optivf.alf(:,t+1),para.grid_asset,para.grid_medcost_nominal,para.grid_protect),sprime_asset_healthy,sprime_medcost_nominal_healthy,sprime_protect_healthy,'linear');        
        EV_healthy_nh=interpn(s_asset,s_medcost_nominal,s_protect,reshape(optivf.nh(:,t+1),para.grid_asset,para.grid_medcost_nominal,para.grid_protect),sprime_asset_healthy,sprime_medcost_nominal_healthy,sprime_protect_healthy,'linear');
        EV_hc_healthy=interpn(s_asset,s_medcost_nominal,s_protect,reshape(optivf.healthy(:,t+1),para.grid_asset,para.grid_medcost_nominal,para.grid_protect),sprime_asset_hc,sprime_medcost_nominal_hc,sprime_protect_hc,'linear');
        EV_hc_hc=interpn(s_asset,s_medcost_nominal,s_protect,reshape(optivf.hc(:,t+1),para.grid_asset,para.grid_medcost_nominal,para.grid_protect),sprime_asset_hc,sprime_medcost_nominal_hc,sprime_protect_hc,'linear');
        EV_hc_alf=interpn(s_asset,s_medcost_nominal,s_protect,reshape(optivf.alf(:,t+1),para.grid_asset,para.grid_medcost_nominal,para.grid_protect),sprime_asset_hc,sprime_medcost_nominal_hc,sprime_protect_hc,'linear');
        EV_hc_nh=interpn(s_asset,s_medcost_nominal,s_protect,reshape(optivf.nh(:,t+1),para.grid_asset,para.grid_medcost_nominal,para.grid_protect),sprime_asset_hc,sprime_medcost_nominal_hc,sprime_protect_hc,'linear');
        EV_alf_healthy=interpn(s_asset,s_medcost_nominal,s_protect,reshape(optivf.healthy(:,t+1),para.grid_asset,para.grid_medcost_nominal,para.grid_protect),sprime_asset_alf,sprime_medcost_nominal_alf,sprime_protect_alf,'linear');
        EV_alf_hc=interpn(s_asset,s_medcost_nominal,s_protect,reshape(optivf.hc(:,t+1),para.grid_asset,para.grid_medcost_nominal,para.grid_protect),sprime_asset_alf,sprime_medcost_nominal_alf,sprime_protect_alf,'linear');        
        EV_alf_alf=interpn(s_asset,s_medcost_nominal,s_protect,reshape(optivf.alf(:,t+1),para.grid_asset,para.grid_medcost_nominal,para.grid_protect),sprime_asset_alf,sprime_medcost_nominal_alf,sprime_protect_alf,'linear');        
        EV_alf_nh=interpn(s_asset,s_medcost_nominal,s_protect,reshape(optivf.nh(:,t+1),para.grid_asset,para.grid_medcost_nominal,para.grid_protect),sprime_asset_alf,sprime_medcost_nominal_alf,sprime_protect_alf,'linear');        
        EV_nh_healthy=interpn(s_asset,s_medcost_nominal,s_protect,reshape(optivf.healthy(:,t+1),para.grid_asset,para.grid_medcost_nominal,para.grid_protect),sprime_asset_nh,sprime_medcost_nominal_nh,sprime_protect_nh,'linear');
        EV_nh_hc=interpn(s_asset,s_medcost_nominal,s_protect,reshape(optivf.hc(:,t+1),para.grid_asset,para.grid_medcost_nominal,para.grid_protect),sprime_asset_nh,sprime_medcost_nominal_nh,sprime_protect_nh,'linear');        
        EV_nh_alf=interpn(s_asset,s_medcost_nominal,s_protect,reshape(optivf.alf(:,t+1),para.grid_asset,para.grid_medcost_nominal,para.grid_protect),sprime_asset_nh,sprime_medcost_nominal_nh,sprime_protect_nh,'linear');        
        EV_nh_nh=interpn(s_asset,s_medcost_nominal,s_protect,reshape(optivf.nh(:,t+1),para.grid_asset,para.grid_medcost_nominal,para.grid_protect),sprime_asset_nh,sprime_medcost_nominal_nh,sprime_protect_nh,'linear'); 

        [v,j] = max(reshape(F_healthy+para.discount*(para.q(t+1,1)*EV_healthy_healthy+para.q(t+1,2)*EV_healthy_hc+para.q(t+1,3)*EV_healthy_alf+para.q(t+1,4)*EV_healthy_nh),para.ns,para.nx),[],2);
        optixf.healthy(:,:,t) = x_layer1(j,:); 
        optivf.healthy(:,t) = v;
        [v,j] = max(reshape(F_hc+para.discount*(para.q(t+1,6)*EV_hc_healthy+para.q(t+1,7)*EV_hc_hc+para.q(t+1,8)*EV_hc_alf+para.q(t+1,9)*EV_hc_nh),para.ns,para.nx),[],2);
        optixf.hc(:,:,t) = x_layer1(j,:); 
        optivf.hc(:,t) = v;
        [v,j] = max(reshape(F_alf+para.discount*(para.q(t+1,11)*EV_alf_healthy+para.q(t+1,12)*EV_alf_hc+para.q(t+1,13)*EV_alf_alf+para.q(t+1,14)*EV_alf_nh),para.ns,para.nx),[],2);
        optixf.alf(:,:,t) = x_layer1(j,:); 
        optivf.alf(:,t) = v;    
        [v,j] = max(reshape(F_nh+para.discount*(para.q(t+1,16)*EV_nh_healthy+para.q(t+1,17)*EV_nh_hc+para.q(t+1,18)*EV_nh_alf+para.q(t+1,19)*EV_nh_nh),para.ns,para.nx),[],2);
        optixf.nh(:,:,t) = x_layer1(j,:); 
        optivf.nh(:,t) = v;    
    end;
end;

% Initial healthy state.

% B&F treatment of the first period.
% They don't consume in the first period.
optivf.a(:,1)=para.discount*(para.q(1,1)*optivf.healthy(:,1)+para.q(1,2)*optivf.hc(:,1)+para.q(1,3)*optivf.alf(:,1)+para.q(1,4)*optivf.nh(:,1));

























