function [optisf optixf optivf]=fn_policy_function_nodefer_sf(para,LTCI)

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

% DISCRETITIZE STATE SPACE
s_asset_min=log(0.00099);  
s_asset_max=log(para.cash*2.5);
logs_asset=(s_asset_min:(s_asset_max-s_asset_min)/(para.grid_asset-1):s_asset_max)'; 
s_asset=exp(logs_asset);
%     s_asset=[(0:0.01:0.99)' ; (1:0.02:1.98)' ; (2:0.05:9.95)'; (10:0.075:para.cash*1.2-0.075)'];

% STATE SPACE
s=fn_gridmake(s_asset);
optisf.a(:,1)=s; 

% discretitize action variables;
x_consumption_min=log(0.0001);
x_consumption_max=log(1);
logx_consumption=(x_consumption_min:(x_consumption_max-x_consumption_min)/(para.grid_consumption-1):x_consumption_max)';
x_consumption=exp(logx_consumption);
% x_consumption=(0:1/(para.grid_consumption-1):1)';

% action space;
x_layer1=fn_gridmake(x_consumption);

% COMBINE STATE SPACE AND ACTION SPACE
[asset,consumption]=fn_gridmake(s,x_layer1);
    
% BACKWARD RECURSION
for t=para.T:-1:1;
    t %#ok<NOPRT>
    % Healthy state
    F_healthy=fn_utility(para.cons_healthy+(asset+para.ss-LTCI*para.P(t,1)).*consumption,para.crra);
    % hc state 
    Mcaid_hc=(asset+para.ss+LTCI*para.B(t,2)-para.M(t,2)<para.cbar_hc+para.wbar).*(para.ss+LTCI*para.B(t,2)-para.M(t,2)+(para.RB-1)*asset/para.RB<para.cbar_hc); % (para.RB-1)*asset/para.RB is interest income;
    F_hc=fn_utility(para.cons_hc+Mcaid_hc.*(para.cbar_hc+min(asset-(para.RB-1)*asset/para.RB,para.wbar).*consumption)+(1-Mcaid_hc).*(asset+para.ss+LTCI*para.B(t,2)-para.M(t,2)).*consumption,para.crra);
    % alf state
    Mcaid_alf=(asset+para.ss+LTCI*para.B(t,3)-para.M(t,3)<para.cbar_alf+para.wbar).*(para.ss+LTCI*para.B(t,3)-para.M(t,3)+(para.RB-1)*asset/para.RB<para.cbar_alf);
    F_alf=fn_utility(para.cons_alf+Mcaid_alf.*(para.cbar_alf+min(asset-(para.RB-1)*asset/para.RB,para.wbar).*consumption)+(1-Mcaid_alf).*(asset+para.ss+LTCI*para.B(t,3)-para.M(t,3)).*consumption,para.crra);    
    % nh state
    Mcaid_nh=(asset+para.ss+LTCI*para.B(t,4)-para.M(t,4)<para.cbar_nh+para.wbar).*(para.ss+LTCI*para.B(t,4)-para.M(t,4)+(para.RB-1)*asset/para.RB<para.cbar_nh);
    F_nh=fn_utility(para.cons_nh+Mcaid_nh.*(para.cbar_nh+min(asset-(para.RB-1)*asset/para.RB,para.wbar).*consumption)+(1-Mcaid_nh).*(asset+para.ss+LTCI*para.B(t,4)-para.M(t,4)).*consumption,para.crra);

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
        sprime_asset_hc =max(0.001,(Mcaid_hc .*min(asset-(para.RB-1)*asset/para.RB,para.wbar)+(1-Mcaid_hc) .*(asset+para.ss+LTCI*para.B(t,2)-para.M(t,2))).*(1-consumption)*para.RB);
        sprime_asset_alf=max(0.001,(Mcaid_alf.*min(asset-(para.RB-1)*asset/para.RB,para.wbar)+(1-Mcaid_alf).*(asset+para.ss+LTCI*para.B(t,3)-para.M(t,3))).*(1-consumption)*para.RB);
        sprime_asset_nh =max(0.001,(Mcaid_nh .*min(asset-(para.RB-1)*asset/para.RB,para.wbar)+(1-Mcaid_nh) .*(asset+para.ss+LTCI*para.B(t,4)-para.M(t,4))).*(1-consumption)*para.RB);
        
        EV_healthy_healthy=interp1(optisf.a(:,1),optivf.healthy(:,t+1),sprime_asset_healthy,'linear','extrap');
        EV_healthy_hc=interp1(optisf.a(:,1),optivf.hc(:,t+1),sprime_asset_healthy,'linear','extrap');        
        EV_healthy_alf=interp1(optisf.a(:,1),optivf.alf(:,t+1),sprime_asset_healthy,'linear','extrap');        
        EV_healthy_nh=interp1(optisf.a(:,1),optivf.nh(:,t+1),sprime_asset_healthy,'linear','extrap');
        EV_hc_healthy=interp1(optisf.a(:,1),optivf.healthy(:,t+1),sprime_asset_hc,'linear','extrap');
        EV_hc_hc=interp1(optisf.a(:,1),optivf.hc(:,t+1),sprime_asset_hc,'linear','extrap');
        EV_hc_alf=interp1(optisf.a(:,1),optivf.alf(:,t+1),sprime_asset_hc,'linear','extrap');
        EV_hc_nh=interp1(optisf.a(:,1),optivf.nh(:,t+1),sprime_asset_hc,'linear','extrap');
        EV_alf_healthy=interp1(optisf.a(:,1),optivf.healthy(:,t+1),sprime_asset_alf,'linear','extrap');
        EV_alf_hc=interp1(optisf.a(:,1),optivf.hc(:,t+1),sprime_asset_alf,'linear','extrap');        
        EV_alf_alf=interp1(optisf.a(:,1),optivf.alf(:,t+1),sprime_asset_alf,'linear','extrap');        
        EV_alf_nh=interp1(optisf.a(:,1),optivf.nh(:,t+1),sprime_asset_alf,'linear','extrap');        
        EV_nh_healthy=interp1(optisf.a(:,1),optivf.healthy(:,t+1),sprime_asset_nh,'linear','extrap');
        EV_nh_hc=interp1(optisf.a(:,1),optivf.hc(:,t+1),sprime_asset_nh,'linear','extrap');        
        EV_nh_alf=interp1(optisf.a(:,1),optivf.alf(:,t+1),sprime_asset_nh,'linear','extrap');        
        EV_nh_nh=interp1(optisf.a(:,1),optivf.nh(:,t+1),sprime_asset_nh,'linear','extrap'); 
        
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

% % All start from healthy state.
% % They consume in the first period.
% F_healthy=fn_utility((asset+para.ss-LTCI*para.P(t,1)).*consumption,para.crra);
% sprime_asset_healthy=max(0.001,(asset+para.ss-LTCI*para.P(t,1)).*(1-consumption)*para.RB);
% EV_healthy_healthy=interp1(optism.a(:,1),optivm.healthy(:,1),sprime_asset_healthy,'linear','extrap');
% EV_healthy_hc=interp1(optism.a(:,1),optivm.hc(:,1),sprime_asset_healthy,'linear','extrap');
% EV_healthy_alf=interp1(optism.a(:,1),optivm.alf(:,1),sprime_asset_healthy,'linear','extrap');
% EV_healthy_nh=interp1(optism.a(:,1),optivm.nh(:,1),sprime_asset_healthy,'linear','extrap');
% [v,j] = max(reshape(F_healthy+para.discount*(para.q(1,1)*EV_healthy_healthy+para.q(1,2)*EV_healthy_hc+para.q(1,3)*EV_healthy_alf+para.q(1,4)*EV_healthy_nh),para.ns,para.nx),[],2);
% optixm.a(:,:) = x_layer1(j,:); 
% optivm.a(:,1) = v;









