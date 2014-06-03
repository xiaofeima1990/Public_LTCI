function [optism optixm optivm]=fn_policy_function_part_sm(para,LTCI)

optism.a=zeros(para.ns,para.ds);
optixm.a=zeros(para.ns,para.dx);
optivm.a=zeros(para.ns,1);
optixm.healthy=zeros(para.ns,para.dx,para.T);
optivm.healthy=zeros(para.ns,para.T);
optixm.hc=zeros(para.ns,para.dx,para.T);
optivm.hc=zeros(para.ns,para.T);
optixm.alf=zeros(para.ns,para.dx,para.T);
optivm.alf=zeros(para.ns,para.T);
optixm.nh=zeros(para.ns,para.dx,para.T);
optivm.nh=zeros(para.ns,para.T);

% discretitize state variables;
s_asset_min=log(0.00099);  % min is 99 cents. It's not $1 is to provent the 1e-19 i.e. sprime_asset out of range..
s_asset_max=log(para.cash*2.5);
logs_asset=(s_asset_min:(s_asset_max-s_asset_min)/(para.grid_asset-1):s_asset_max)'; 
s_asset=exp(logs_asset);
s_sick_t=(0:1:para.grid_sick_t-1)';
if (para.partner==0 && para.sick_T<para.T) || para.partner==1;
    s_protect=[0;1];
elseif para.partner==2;
    s_protect=(0:1/(para.grid_protect-1):1)';
elseif para.partner>4;
end;
% state space;
s=fn_gridmake(s_asset,s_sick_t,s_protect);
optism.a(:,:)=s; 
[nd_s_asset,nd_s_sick_t,nd_s_protect]=ndgrid(s_asset,s_sick_t,s_protect);

% discretitize action variables;
x_consumption_min=log(0.0001);
x_consumption_max=log(1);
logx_consumption=(x_consumption_min:(x_consumption_max-x_consumption_min)/(para.grid_consumption-1):x_consumption_max)';
x_consumption=exp(logx_consumption);
% x_consumption=(0:1/(para.grid_consumption-1):1)';
% action space;
x_layer1=fn_gridmake(x_consumption);

% combine state space and action space;
[asset,sick_t,protect,consumption]=fn_gridmake(s,x_layer1);

% BACKWARD RECURSION
for t=para.T:-1:1;
    t %#ok<NOPRT>
    % Healthy state
    F_healthy=fn_utility(para.cons_healthy+(asset+para.ss-LTCI*(sick_t<para.sick_T)*para.P(t,1)).*consumption,para.crra);
    % hc state 
    Mcaid_hc=(asset+para.ss+LTCI*(sick_t<=para.sick_T)*para.B(t,2)-para.M(t,2)<para.cbar_hc+para.wbar+LTCI*(sick_t>para.sick_T).*protect.*(asset-(para.RB-1)*asset/para.RB)).*(para.ss+LTCI*(sick_t<=para.sick_T)*para.B(t,2)-para.M(t,2)+(para.RB-1)*asset/para.RB<para.cbar_hc); % (para.RB-1)*asset/para.RB is interest income;
    F_hc=fn_utility(para.cons_hc+Mcaid_hc.*(para.cbar_hc+min(asset-(para.RB-1)*asset/para.RB,para.wbar+LTCI*(sick_t>para.sick_T).*protect.*(asset-(para.RB-1)*asset/para.RB)).*consumption)+(1-Mcaid_hc).*(asset+para.ss+LTCI*(sick_t<=para.sick_T)*para.B(t,2)-para.M(t,2)).*consumption,para.crra);
    % alf state
    Mcaid_alf=(asset+para.ss+LTCI*(sick_t<=para.sick_T)*para.B(t,3)-para.M(t,3)<para.cbar_alf+para.wbar+LTCI*(sick_t>para.sick_T).*protect.*(asset-(para.RB-1)*asset/para.RB)).*(para.ss+LTCI*(sick_t<=para.sick_T)*para.B(t,3)-para.M(t,3)+(para.RB-1)*asset/para.RB<para.cbar_alf);
    F_alf=fn_utility(para.cons_alf+Mcaid_alf.*(para.cbar_alf+min(asset-(para.RB-1)*asset/para.RB,para.wbar+LTCI*(sick_t>para.sick_T).*protect.*(asset-(para.RB-1)*asset/para.RB)).*consumption)+(1-Mcaid_alf).*(asset+para.ss+LTCI*(sick_t<=para.sick_T)*para.B(t,3)-para.M(t,3)).*consumption,para.crra);    
    % nh state
    Mcaid_nh=(asset+para.ss+LTCI*(sick_t<=para.sick_T)*para.B(t,4)-para.M(t,4)<para.cbar_nh+para.wbar+LTCI*(sick_t>para.sick_T).*protect.*(asset-(para.RB-1)*asset/para.RB)).*(para.ss+LTCI*(sick_t<=para.sick_T)*para.B(t,4)-para.M(t,4)+(para.RB-1)*asset/para.RB<para.cbar_nh);
    F_nh=fn_utility(para.cons_nh+Mcaid_nh.*(para.cbar_nh+min(asset-(para.RB-1)*asset/para.RB,para.wbar+LTCI*(sick_t>para.sick_T).*protect.*(asset-(para.RB-1)*asset/para.RB)).*consumption)+(1-Mcaid_nh).*(asset+para.ss+LTCI*(sick_t<=para.sick_T)*para.B(t,4)-para.M(t,4)).*consumption,para.crra);
  
    % FROM THE LAST PERIOD
    if t==para.T;
        [v,j]=max(reshape(F_healthy,size(s,1),size(x_layer1,1)),[],2);
        optixm.healthy(:,:,t) = x_layer1(j,:);
        optivm.healthy(:,t) = v;
        [v,j]=max(reshape(F_hc,size(s,1),size(x_layer1,1)),[],2);
        optixm.hc(:,:,t) = x_layer1(j,:);
        optivm.hc(:,t) = v;
        [v,j]=max(reshape(F_alf,size(s,1),size(x_layer1,1)),[],2);
        optixm.alf(:,:,t) = x_layer1(j,:);
        optivm.alf(:,t) = v;
        [v,j]=max(reshape(F_nh,size(s,1),size(x_layer1,1)),[],2);
        optixm.nh(:,:,t) = x_layer1(j,:);
        optivm.nh(:,t) = v;
    end;
    if t<para.T;
        sprime_asset_healthy=max(0.001,(asset+para.ss-LTCI*(sick_t<para.sick_T)*para.P(t,1)).*(1-consumption)*para.RB);
        sprime_asset_hc =max(0.001,(Mcaid_hc .*min(asset-(para.RB-1)*asset/para.RB,para.wbar+LTCI*(sick_t>para.sick_T).*protect.*(asset-(para.RB-1)*asset/para.RB))+(1-Mcaid_hc) .*(asset+para.ss+LTCI*(sick_t<=para.sick_T)*para.B(t,2)-para.M(t,2))).*(1-consumption)*para.RB);
        sprime_asset_alf=max(0.001,(Mcaid_alf.*min(asset-(para.RB-1)*asset/para.RB,para.wbar+LTCI*(sick_t>para.sick_T).*protect.*(asset-(para.RB-1)*asset/para.RB))+(1-Mcaid_alf).*(asset+para.ss+LTCI*(sick_t<=para.sick_T)*para.B(t,3)-para.M(t,3))).*(1-consumption)*para.RB);
        sprime_asset_nh =max(0.001,(Mcaid_nh .*min(asset-(para.RB-1)*asset/para.RB,para.wbar+LTCI*(sick_t>para.sick_T).*protect.*(asset-(para.RB-1)*asset/para.RB))+(1-Mcaid_nh) .*(asset+para.ss+LTCI*(sick_t<=para.sick_T)*para.B(t,4)-para.M(t,4))).*(1-consumption)*para.RB);
        sprime_sick_t_healthy=sick_t;
        sprime_sick_t_hc=min(para.sick_T+1*para.hcdaycount,sick_t+1);
        sprime_sick_t_alf=min(para.sick_T+1,sick_t+1);
        sprime_sick_t_nh=min(para.sick_T+1,sick_t+1);
        if para.partner==0 && para.sick_T<para.T;
            sprime_protect_healthy=zeros(para.nc,1);
            sprime_protect_hc=zeros(para.nc,1);
            sprime_protect_alf=zeros(para.nc,1);
            sprime_protect_nh=zeros(para.nc,1);             
        elseif para.partner==1;
            sprime_protect_healthy=ones(para.nc,1);
            sprime_protect_hc=ones(para.nc,1);
            sprime_protect_alf=ones(para.nc,1);
            sprime_protect_nh=ones(para.nc,1);            
        elseif para.partner==2;
            sprime_protect_healthy=protect.*asset./(sprime_asset_healthy-(para.RB-1)*sprime_asset_healthy/para.RB);
            sprime_protect_hc=min(1,(protect.*asset+LTCI*(sick_t<=para.sick_T)*para.B(t,2))./(sprime_asset_hc-(para.RB-1)*sprime_asset_hc/para.RB));
            sprime_protect_alf=min(1,(protect.*asset+LTCI*(sick_t<=para.sick_T)*para.B(t,3))./(sprime_asset_alf-(para.RB-1)*sprime_asset_alf/para.RB));
            sprime_protect_nh=min(1,(protect.*asset+LTCI*(sick_t<=para.sick_T)*para.B(t,4))./(sprime_asset_nh-(para.RB-1)*sprime_asset_nh/para.RB));
        elseif para.partner>4;
        end;

        if (para.partner==0 && para.sick_T<para.T) || para.partner==1;
            EV_healthy_healthy=interpn(s_asset,s_sick_t,s_protect,reshape(optivm.healthy(:,t+1),para.grid_asset,para.grid_sick_t,para.grid_protect),sprime_asset_healthy,sprime_sick_t_healthy,sprime_protect_healthy,'linear');
            EV_healthy_hc=interpn(s_asset,s_sick_t,s_protect,reshape(optivm.hc(:,t+1),para.grid_asset,para.grid_sick_t,para.grid_protect),sprime_asset_healthy,sprime_sick_t_healthy,sprime_protect_healthy,'linear');        
            EV_healthy_alf=interpn(s_asset,s_sick_t,s_protect,reshape(optivm.alf(:,t+1),para.grid_asset,para.grid_sick_t,para.grid_protect),sprime_asset_healthy,sprime_sick_t_healthy,sprime_protect_healthy,'linear');        
            EV_healthy_nh=interpn(s_asset,s_sick_t,s_protect,reshape(optivm.nh(:,t+1),para.grid_asset,para.grid_sick_t,para.grid_protect),sprime_asset_healthy,sprime_sick_t_healthy,sprime_protect_healthy,'linear');
            EV_hc_healthy=interpn(s_asset,s_sick_t,s_protect,reshape(optivm.healthy(:,t+1),para.grid_asset,para.grid_sick_t,para.grid_protect),sprime_asset_hc,sprime_sick_t_hc,sprime_protect_hc,'linear');
            EV_hc_hc=interpn(s_asset,s_sick_t,s_protect,reshape(optivm.hc(:,t+1),para.grid_asset,para.grid_sick_t,para.grid_protect),sprime_asset_hc,sprime_sick_t_hc,sprime_protect_hc,'linear');
            EV_hc_alf=interpn(s_asset,s_sick_t,s_protect,reshape(optivm.alf(:,t+1),para.grid_asset,para.grid_sick_t,para.grid_protect),sprime_asset_hc,sprime_sick_t_hc,sprime_protect_hc,'linear');
            EV_hc_nh=interpn(s_asset,s_sick_t,s_protect,reshape(optivm.nh(:,t+1),para.grid_asset,para.grid_sick_t,para.grid_protect),sprime_asset_hc,sprime_sick_t_hc,sprime_protect_hc,'linear');
            EV_alf_healthy=interpn(s_asset,s_sick_t,s_protect,reshape(optivm.healthy(:,t+1),para.grid_asset,para.grid_sick_t,para.grid_protect),sprime_asset_alf,sprime_sick_t_alf,sprime_protect_alf,'linear');
            EV_alf_hc=interpn(s_asset,s_sick_t,s_protect,reshape(optivm.hc(:,t+1),para.grid_asset,para.grid_sick_t,para.grid_protect),sprime_asset_alf,sprime_sick_t_alf,sprime_protect_alf,'linear');        
            EV_alf_alf=interpn(s_asset,s_sick_t,s_protect,reshape(optivm.alf(:,t+1),para.grid_asset,para.grid_sick_t,para.grid_protect),sprime_asset_alf,sprime_sick_t_alf,sprime_protect_alf,'linear');        
            EV_alf_nh=interpn(s_asset,s_sick_t,s_protect,reshape(optivm.nh(:,t+1),para.grid_asset,para.grid_sick_t,para.grid_protect),sprime_asset_alf,sprime_sick_t_alf,sprime_protect_alf,'linear');        
            EV_nh_healthy=interpn(s_asset,s_sick_t,s_protect,reshape(optivm.healthy(:,t+1),para.grid_asset,para.grid_sick_t,para.grid_protect),sprime_asset_nh,sprime_sick_t_nh,sprime_protect_nh,'linear');
            EV_nh_hc=interpn(s_asset,s_sick_t,s_protect,reshape(optivm.hc(:,t+1),para.grid_asset,para.grid_sick_t,para.grid_protect),sprime_asset_nh,sprime_sick_t_nh,sprime_protect_nh,'linear');        
            EV_nh_alf=interpn(s_asset,s_sick_t,s_protect,reshape(optivm.alf(:,t+1),para.grid_asset,para.grid_sick_t,para.grid_protect),sprime_asset_nh,sprime_sick_t_nh,sprime_protect_nh,'linear');        
            EV_nh_nh=interpn(s_asset,s_sick_t,s_protect,reshape(optivm.nh(:,t+1),para.grid_asset,para.grid_sick_t,para.grid_protect),sprime_asset_nh,sprime_sick_t_nh,sprime_protect_nh,'linear'); 
        elseif para.partner==2;
            EV_healthy_healthy=interpn(nd_s_asset,nd_s_sick_t,nd_s_protect,reshape(optivm.healthy(:,t+1),para.grid_asset,para.grid_sick_t,para.grid_protect),sprime_asset_healthy,sprime_sick_t_healthy,sprime_protect_healthy,'linear');
            EV_healthy_hc=interpn(nd_s_asset,nd_s_sick_t,nd_s_protect,reshape(optivm.hc(:,t+1),para.grid_asset,para.grid_sick_t,para.grid_protect),sprime_asset_healthy,sprime_sick_t_healthy,sprime_protect_healthy,'linear');        
            EV_healthy_alf=interpn(nd_s_asset,nd_s_sick_t,nd_s_protect,reshape(optivm.alf(:,t+1),para.grid_asset,para.grid_sick_t,para.grid_protect),sprime_asset_healthy,sprime_sick_t_healthy,sprime_protect_healthy,'linear');        
            EV_healthy_nh=interpn(nd_s_asset,nd_s_sick_t,nd_s_protect,reshape(optivm.nh(:,t+1),para.grid_asset,para.grid_sick_t,para.grid_protect),sprime_asset_healthy,sprime_sick_t_healthy,sprime_protect_healthy,'linear');
            EV_hc_healthy=interpn(nd_s_asset,nd_s_sick_t,nd_s_protect,reshape(optivm.healthy(:,t+1),para.grid_asset,para.grid_sick_t,para.grid_protect),sprime_asset_hc,sprime_sick_t_hc,sprime_protect_hc,'linear');
            EV_hc_hc=interpn(nd_s_asset,nd_s_sick_t,nd_s_protect,reshape(optivm.hc(:,t+1),para.grid_asset,para.grid_sick_t,para.grid_protect),sprime_asset_hc,sprime_sick_t_hc,sprime_protect_hc,'linear');
            EV_hc_alf=interpn(nd_s_asset,nd_s_sick_t,nd_s_protect,reshape(optivm.alf(:,t+1),para.grid_asset,para.grid_sick_t,para.grid_protect),sprime_asset_hc,sprime_sick_t_hc,sprime_protect_hc,'linear');
            EV_hc_nh=interpn(nd_s_asset,nd_s_sick_t,nd_s_protect,reshape(optivm.nh(:,t+1),para.grid_asset,para.grid_sick_t,para.grid_protect),sprime_asset_hc,sprime_sick_t_hc,sprime_protect_hc,'linear');
            EV_alf_healthy=interpn(nd_s_asset,nd_s_sick_t,nd_s_protect,reshape(optivm.healthy(:,t+1),para.grid_asset,para.grid_sick_t,para.grid_protect),sprime_asset_alf,sprime_sick_t_alf,sprime_protect_alf,'linear');
            EV_alf_hc=interpn(nd_s_asset,nd_s_sick_t,nd_s_protect,reshape(optivm.hc(:,t+1),para.grid_asset,para.grid_sick_t,para.grid_protect),sprime_asset_alf,sprime_sick_t_alf,sprime_protect_alf,'linear');        
            EV_alf_alf=interpn(nd_s_asset,nd_s_sick_t,nd_s_protect,reshape(optivm.alf(:,t+1),para.grid_asset,para.grid_sick_t,para.grid_protect),sprime_asset_alf,sprime_sick_t_alf,sprime_protect_alf,'linear');        
            EV_alf_nh=interpn(nd_s_asset,nd_s_sick_t,nd_s_protect,reshape(optivm.nh(:,t+1),para.grid_asset,para.grid_sick_t,para.grid_protect),sprime_asset_alf,sprime_sick_t_alf,sprime_protect_alf,'linear');        
            EV_nh_healthy=interpn(nd_s_asset,nd_s_sick_t,nd_s_protect,reshape(optivm.healthy(:,t+1),para.grid_asset,para.grid_sick_t,para.grid_protect),sprime_asset_nh,sprime_sick_t_nh,sprime_protect_nh,'linear');
            EV_nh_hc=interpn(nd_s_asset,nd_s_sick_t,nd_s_protect,reshape(optivm.hc(:,t+1),para.grid_asset,para.grid_sick_t,para.grid_protect),sprime_asset_nh,sprime_sick_t_nh,sprime_protect_nh,'linear');        
            EV_nh_alf=interpn(nd_s_asset,nd_s_sick_t,nd_s_protect,reshape(optivm.alf(:,t+1),para.grid_asset,para.grid_sick_t,para.grid_protect),sprime_asset_nh,sprime_sick_t_nh,sprime_protect_nh,'linear');        
            EV_nh_nh=interpn(nd_s_asset,nd_s_sick_t,nd_s_protect,reshape(optivm.nh(:,t+1),para.grid_asset,para.grid_sick_t,para.grid_protect),sprime_asset_nh,sprime_sick_t_nh,sprime_protect_nh,'linear'); 
        elseif para.partner>4;
        end;
        
        [v,j] = max(reshape(F_healthy+para.discount*(para.q(t+1,1)*EV_healthy_healthy+para.q(t+1,2)*EV_healthy_hc+para.q(t+1,3)*EV_healthy_alf+para.q(t+1,4)*EV_healthy_nh),para.ns,para.nx),[],2);
        optixm.healthy(:,:,t) = x_layer1(j,:); 
        optivm.healthy(:,t) = v;
        [v,j] = max(reshape(F_hc+para.discount*(para.q(t+1,6)*EV_hc_healthy+para.q(t+1,7)*EV_hc_hc+para.q(t+1,8)*EV_hc_alf+para.q(t+1,9)*EV_hc_nh),para.ns,para.nx),[],2);
        optixm.hc(:,:,t) = x_layer1(j,:); 
        optivm.hc(:,t) = v;
        [v,j] = max(reshape(F_alf+para.discount*(para.q(t+1,11)*EV_alf_healthy+para.q(t+1,12)*EV_alf_hc+para.q(t+1,13)*EV_alf_alf+para.q(t+1,14)*EV_alf_nh),para.ns,para.nx),[],2);
        optixm.alf(:,:,t) = x_layer1(j,:); 
        optivm.alf(:,t) = v;    
        [v,j] = max(reshape(F_nh+para.discount*(para.q(t+1,16)*EV_nh_healthy+para.q(t+1,17)*EV_nh_hc+para.q(t+1,18)*EV_nh_alf+para.q(t+1,19)*EV_nh_nh),para.ns,para.nx),[],2);
        optixm.nh(:,:,t) = x_layer1(j,:); 
        optivm.nh(:,t) = v;    
    end;
end;

% Initial healthy state.

% B&F treatment of the first period.
% They don't consume in the first period.
optivm.a(:,1)=para.discount*(para.q(1,1)*optivm.healthy(:,1)+para.q(1,2)*optivm.hc(:,1)+para.q(1,3)*optivm.alf(:,1)+para.q(1,4)*optivm.nh(:,1));













