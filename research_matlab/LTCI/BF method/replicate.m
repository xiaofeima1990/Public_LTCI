% replicate of Brown and Finkelstein 2008, AER
% /* The program calculates the LTCI values found in     */
% /* Figures 1 and 2, as well as data for Table 2        */

% diary('replicate.log');
clear
clc
close all
tic

figure1m=zeros(10,1);
figure1f=zeros(10,1);
figure2m=zeros(10,1);
figure2f=zeros(10,1);
griddense=1/1; % If griddense smaller than 1, the larger grid size.
                    	
% /*-----------------------------------------------------*/
% /* This GAUSS program accompanies Brown & Finkelstein  */
% /* "The Interaction of Public and Private Insurance"   */
% /* Medicaid and the Long-Term Care Insurance Market"   */
% /* in the American Economic Review                     */
% /*                                                     */
% /* The program calculates the LTCI values found in     */
% /* Figures 1 and 2, as well as data for Table 2        */
% /*-----------------------------------------------------*/

% format /rdt 1,5;                    	
% /***************************************************************************/
% /*      VARIABLES TO BE INPUTED BY USER                                    */
% /***************************************************************************/

bencap=1;		% @ =1 if benefit cap applies. =0 if policy benefits are uncapped @;
while bencap<=1;

    X=1000;         % @ Wealth scaling factor - converts to units of $X              @

    male=1;			% @ =1 if male, =0 if female			@
    while male>=0;

        beta=0;         % @ Fraction of HC expenses that enter into utility function as consumption   @;

        qual2=1;        % @ Medicaid quality for state 2: Typically equal to 1 unless there is stigma effect @;
        qual3=1;        % @ Medicaid quality for state 3 @;
        qual4=1;        % @ Medicaid quality for state 4 @;

                        % @ Next parameters =1 unless state dependent utility is desired @;
        phi1=1;         % @ coefficient on utility of consumption in state 1  @;
        phi2=1;         % @ coefficient on utility of consumption in state 2  @;
        phi3=1;         % @ coefficient on utility of consumption in state 3  @;
        phi4=1;         % @ coefficient on utility of consumption in state 4  @;

        beq=0;          % @ coefficient on utility of bequests @;
        fo=0;           % @ if fo=1, policy is facility only, meaning it covers only states 3 and 4.@;
        while fo<=0;    % @ if fo=0, policy covers HC (state 2) also @

            wcount=3;                   % @ This tells program which wealth deciles to loop through.              @;
            while wcount<=9;            % @ for each case, starting wealth is defined by "wealth"                 @;
                                        % @ alpha is the fraction of total wealth annuitized                      @;
                if wcount==0;           % @ wx is used purely to adjust upper bound of grid for discretization    @;
                    wealth=40000;       % @ if LTCI value gets high (e.g., higher risk aversion), adjust wx up    @;
                    alpha=.98;          % @ grid = grid size used for discretization.                             @;
                    wx=0;
                    grid=20;
                elseif wcount==1;
                    wealth=58450;
                    alpha=.98;
                    wx=0;                   
                    grid=20;
                elseif wcount==2;           
                    wealth=93415;
                    alpha=.91;
                    wx=20000;
                    grid=40;
                elseif wcount==3;
                    wealth=126875; 
                    alpha=.82;
                    wx=30000;
                    grid=75;
                elseif wcount==4;
                    wealth=169905;
                    alpha=.70;
                    wx=10000;
                    grid=100; 
                elseif wcount==5;
                    wealth=222570;
                    alpha=.60;
                    wx=50000;    
                    grid=130;   
                elseif wcount==6;
                    wealth=292780;
                    alpha=.52;
                    wx=20000;
                    grid=175;
                elseif wcount==7;
                    wealth=385460;
                    alpha=.41;
                    wx=40000;
                    grid=225;
                elseif wcount==8;
                    wealth=525955;
                    alpha=.35;
                    wx=40000;
                    grid=300;
                elseif wcount==9;
                    wealth=789475;
                    alpha=.26;
                    wx=75000;
                    grid=450;
                end;

                w0=wealth*(1-alpha);                    % @ This section simply creates discretized grid @;
                ww=round((w0*1.2-10000)/grid); 
                if ww*grid<10000;
                    wdis=[(0:10*griddense:990)' ; (1000:20*griddense:1980)' ; (2000:50*griddense:9950)'];
                else
                    wdis=[(0:10*griddense:990)' ; (1000:20*griddense:1980)' ; (2000:50*griddense:9950)'; (10000:grid*griddense:10000+(ww-1)*grid)'];
                end;
                wdis=wdis/X;
                w0=w0/X;
                wrow=size(wdis,1);

                neginf=-999999999999;       % @ Felicity value of zero consumption (negative infinity)    	@
                age=65;                     % @ Age at time of purchase	          	@
                maxage=105;		            % @ Max age for calculation			@

                tn=(maxage-age)*12;			% @ number of periods in the problem	@

                graphs = 0;		            % @put in the # of different health trajectories you want to graph@

                gam=3;			            % @ coefficient of relative risk aversion		@
                while gam<=3.1;          % @ Note that when gam=1, undefined.  So uses value 'approaching' 1 @;
                    gam=floor(gam);

                    Food=515/X;                 % @ Food = SSI level used to parameterize food/housing benefit @ 
                    while Food<=515/X;

                        Mcaid=1;		            % @ =1 if there is a Medicaid program		@

                        medscale=1;                 % @ scaling variable used for sensitivity checks.  Typically set = 1 @;
                        while medscale<=1;

                            Wbar=2000/X;	            % @ wealth excluded from Medicaid spend-down (base case is 2000/X)	@ 
                            Cbar=30/X;		            % @ min consumption provided if on Medicaid	@
                            Cbar2=545/X;                % @ CBAR WHILE IN HOME CARE @;

                            Wbar=medscale*Wbar;

%                             @ Cbar=medscale*Cbar;
%                             @ Cbar2=medscale*Cbar2;


                            Medicare=.35;		        % @ Fraction of Home care costs covered by Medicare @
                            while Medicare<=.35;


                                MWcount=0;                  % @ Alternative scenarios for market loads of private LTCI prices @
                                while MWcount<=0;

                                    if MWcount==0;          % @ Base case market loads @
                                        if male==0;
                                            MW=1.058;
                                        elseif male==1;
                                            MW=0.5;
                                        else
                                        end;
                                    elseif MWcount==1;
                                        if male==0;
                                            MW=.6;
                                        elseif male==1;
                                            MW=0.3;
                                        else
                                        end;
                                    elseif MWcount==2;         % @ actuarially fair on average but still with unisex pricing @
                                        if male==0;
                                            MW=1.358127; 
                                        elseif male==1;
                                            MW=0.6418727;
                                        else
                                        end;
                                    else                       % @ Actuarially fair prices @
                                        MW=1;
                                    end;


                                    Binf=0;                     % @ rate of nominal growth of benefits under LTCI policy  @;
                                    Bben=3000/X;                % @ Monthly benefit from LTCI policy     		            @;
                                    while Bben<=(3000/X);


                                        NHamt=4290/X;      	        % @ Monthly cost of NH  $51480  @
                                        ALFamt=2159/X;              % @ Monthly cost of ALF $25908 per year  @

                                        HCnonrn=18/X;               % @ Hourly HC costs (non RN) @
                                        HCrn=37/X;                  % @ Hourly HC costs (RN)  @

                                        r=.03;			            % @ real interest rate				        @
                                        rho=.03;		            % @ discount rate for utility of consumption	@
                                        d=.03;			            % @ discount rate for utility of bequests		@
                                        inf=.03;		            % @ price inflation rate	                    @
                                        rminf=.015;		            % @ real medical cost growth (over inflation)	@
                                    
                                    % *************************************************************************
                                    % * 	END USER INPUT						                              *
                                    % *************************************************************************

                                        if beq==1;          %  /* This speeds up procedure when no bequests */;
                                            wdisbeq=wdis; 
                                        else
                                            wdisbeq=1; 
                                        end;

                                        Prem = 150/X;		%	@ Just a placeholder -- later we replace with fair premium @;

                                        Minf=rminf+inf;     %   @ nominal medical price inflation  @                                

                                        % /* Convert annual growth rates into monthly growth rates */;

                                        r=((1+r)^(1/12))-1;
                                        d=((1+d)^(1/12))-1;
                                        rho=((1+rho)^(1/12))-1;
                                        inf=((1+inf)^(1/12))-1;
                                        Minf=((1+Minf)^(1/12))-1;
                                        Binf=((1+Binf)^(1/12))-1;                                    

                                        % /*----------------------------------------------*/
                                        % /*      LOAD DATA MATRICES                      */
                                        % /*----------------------------------------------*/

                                        load trans
                                        if male==1;
                                            q=qmi;
                                        % 					@ matrix of transition probabilities 	@
                                        % 					@ rows=ages 65 to 111                   @
                                        % 					@ col 1 is age.  col 2 through 26 are	@
                                        % 					@ transition probs from state i to j	@;
                                            hcexp0=hcexp0mi65; % unskilled nurse.
                                            hcexp1=hcexp1mi65; % skilled nurse.
                                        else
                                            q=qfi;
                                            hcexp0=hcexp0fi65;
                                            hcexp1=hcexp1fi65;
                                        end;      
                                        
%                                          /* Note: The next few lines add 30 rows of zeros to the transition and HC cost matrices.  The 
%                                          reason is that the whole program was written assuming that these matrices started at age 35.  The
%                                          data files now have the matrices starting at 65.  So rows of zeros (which are later dropped anyway) 
%                                          simply allowed existing program to continue functioning appropriately. */;
                                        q=[zeros(30,26); q]; %#ok<AGROW>
                                        hcexp0=[zeros(30,2); hcexp0]; %#ok<AGROW>
                                        hcexp1=[zeros(30,2); hcexp1]; %#ok<AGROW>
                                    
%                                         /* Recall that the hcexp matrices have column 1=age, column 2 = expenses */;
                                        hcexp0(:,2)=hcexp0(:,2)*(4.33333*HCnonrn);
                                        hcexp1(:,2)=hcexp1(:,2)*(4.33333*HCrn);
                                        hcexp=[hcexp0(:,1) (1-Medicare)*(hcexp0(:,2)+hcexp1(:,2))];
                                        hcexp=kron(hcexp((age-35)+1:(maxage-35)+1,2),ones(12,1));
                                        hcexp=hcexp(1:tn,1);
%                                         /*  HCutil is the amount of non-skilled NH care received, regardless of payer */;
                                        HC0=kron(hcexp0((age-35)+1:(maxage-35)+1,2),ones(12,1))+kron(hcexp1((age-35)+1:(maxage-35)+1,2),ones(12,1));
                                        HC0=HC0(1:tn,1);
                                        
%                                         @ B = Benefit matrix 			      @   
%                                         @ P = Premium matrix                @
%                                         @ M = medical expenditure matrix    @
%                                         @ Rows are periods, cols are states @

                                        M=[zeros(tn,1) hcexp ALFamt*ones(tn,1) NHamt*ones(tn,1) zeros(tn,1)];

                                        if fo==0;  % @ not facility only, so benefits paid in all sick states @;                                          
                                            B=[zeros(tn,1) Bben*ones(tn,3) zeros(tn,1)];	
                                                P=Prem*[ones(tn,1) zeros(tn,4)];
                                        elseif fo==1;  % @ if facility only, so benefits paid only in alf or nh @;
                                            B=[zeros(tn,2) Bben*ones(tn,2) zeros(tn,1)];	
                                                P=[Prem*ones(tn,2) zeros(tn,3)];
                                        else
                                        end;

%                                         @ Incorporate nominal growth rates @
                                        bfactor=cumprod((1+Binf)*ones(tn,1));
                                        mfactor=cumprod((1+Minf)*ones(tn,1));
                                        B=B.*(bfactor*ones(1,size(B,2)));
                                        M=M.*(mfactor*ones(1,size(M,2)));
                                        HC0=HC0.*(mfactor*ones(1,size(HC0,2)));

%                                         @ Now take the min of benefit level and actual cost @;
                                        mcomp=(M<=B);	% @mcomp=(M.<=B)@
                                        bcomp=(B<M);	% @bcomp=(B.<M)@

                                        if bencap==1;
                                            if sum(reshape((mcomp+bcomp)',[],1))==(size(B,1)*size(B,2));
                                                B=(M.*mcomp)+(B.*bcomp);
                                            else
                                                disp('mistake');
                                            end;
                                        elseif bencap==0;
                                            B=M;
                                        else
                                            disp('need to define bencap as 0 or 1');
                                        end;
% 
%                                         @ Now convert from nominal to real @;
                                        ifactor=cumprod((1+inf)*ones(tn,1));

                                        P=P./(ifactor*ones(1,size(P,2)));
                                        B=B./(ifactor*ones(1,size(B,2)));
                                        M=M./(ifactor*ones(1,size(M,2)));
                                        HC0=HC0./(ifactor*ones(1,size(HC0,2)));

%                                         /*----------------------------------------------*/
%                                         /*	CREATE MONTHLY TRANSITION MATRIX	*/
%                                         /*----------------------------------------------*/

                                        q=kron(q((age-35)+1:(maxage-35)+1,2:26),ones(12,1));

%                                         /*----------------------------------------------*/
%                                         /*	CREATE ACTUARIALLY FAIR PREMIUM			*/
%                                         /*----------------------------------------------*/
% 
%                                         /*Turn conditional probabilities into unconditional probabilies*/
                                        prob = zeros(size(q,1) + 1,5);			% @initialize@
                                        prob(1,1) = 1;				% @everyone starts out of care @
%  
                                        for i=2:size(q,1)+1;
                                              prob(i,1) = q(i-1,1)*prob(i-1,1) + q(i-1,6)*prob(i-1,2) + q(i-1,11)*prob(i-1,3) + q(i-1,16)*prob(i-1,4);
                                              prob(i,2) = q(i-1,2)*prob(i-1,1) + q(i-1,7)*prob(i-1,2) + q(i-1,12)*prob(i-1,3) + q(i-1,17)*prob(i-1,4);
                                              prob(i,3) = q(i-1,3)*prob(i-1,1) + q(i-1,8)*prob(i-1,2) + q(i-1,13)*prob(i-1,3) + q(i-1,18)*prob(i-1,4);
                                              prob(i,4) = q(i-1,4)*prob(i-1,1) + q(i-1,9)*prob(i-1,2) + q(i-1,14)*prob(i-1,3) + q(i-1,19)*prob(i-1,4);
                                              prob(i,5) = q(i-1,5)*prob(i-1,1) + q(i-1,10)*prob(i-1,2) + q(i-1,15)*prob(i-1,3) + q(i-1,20)*prob(i-1,4) + prob(i-1,5);
                                        end;

                                        rfactor=cumprod((1+r).*ones(size(q,1)-12,1));

                                        cost = P.*prob(2:size(prob,1)-12,:);
                                        cost = cost./(rfactor*ones(1,size(cost,2)));			% @Discount@
                                        ben = B.*prob(2:size(prob,1)-12,:);

                                        ben = ben./(rfactor*ones(1,size(ben,2)));			% @Discount@

                                        scost = sum(sum(cost));
                                        sben = sum(sum(ben));

                                        AFP = (sben/scost)*Prem;		% @actuarially fair monthly premium@
                                        actfprem=AFP(1,1);

%                                         /* Now replace P with actuarially fair premium * Money's Worth */

                                        P=(P/Prem)*(AFP/MW);

%                                         clear cost;
%                                         clear scost;
%                                         clear ben;

%                                         /* Calculate monthly annuity amount     */

                                        A=((alpha/(1-alpha))*w0)/sum((1-prob(2:size(prob,1)-12,5))./rfactor);
                                        lifexp=sum(1-prob(2:size(prob,1)-12,5))/12;

%                                         clear prob;

%                                         /* Create LTCIown, a matrix that is tn rows x 5 states that is the net payment    */
%                                         /* to the policy holder.  Will be equal to -P when healthy, equal to benefit when */
%                                         /* receiving benefit and premium is waived, and equal to B-P when receiving 	  */
%                                         /* benefit but policy is not waived.						                      */
%                                         /* LTCInone is a matrix of zeros of same size as LTCIown to be used when the 	  */
%                                         /* individual does not own insurance						                      */

                                        LTCIown=B-P;
                                        LTCInone=zeros(size(LTCIown,1),size(LTCIown,2));

                                        % /*----------------------------------------------*/
                                        % /*      UTILITY FUNCTIONS                       */
                                        % /*----------------------------------------------*/

                                        if gam==1;
                                                gam=1.00000001;                 % /* If gamma=1, util is ')undefined') */
                                        % else                                    % /* though it really equals natural */
                                        %         gam=gam;                        % /* log in the limit                */
                                        end;

                                        % define function: fn_utility(c,gam);  % fn util(c)=(((c)^(1-gam))-1)/(1-gam);  % /* CRRA Utility for health state=1 	 */
                                        % define function: fn_utility(c,beq);  % fn utilbeq(c)=beq*c;

                                        % /* So now we calculate maximum lifetime expected utility given that person owns an LTCI policy */;

                                         [Vstar, Mstar, EPDVMedical, Istarown,Astream,Cstream] = fn_utilopt(LTCIown,1,wrow,tn,M,r,q,Mcaid,A,wdis,Cbar2,Wbar,Cbar,phi1,phi2,phi3,phi4,gam,beq,d,wdisbeq,neginf,qual2,qual3,qual4,beta,HC0,Food,rho,w0);   % @ Note that utilopt procedure is defined below @;

                                        % /*
                                        % =================================================================================
                                        %        FINDING WEALTH EQUIVALENT                                                 
                                        % =================================================================================
                                        %   This section asks the question:  ')Purchasing a LTCI policy gives me utility 	 
                                        %        of Vstar.  Now suppose I take away the LTCI.  What level of wealth must  
                                        %        I have to attain the level of utility Vstar without access to LTCI?')     */

                                        clear Vmax;
                                        clear V;
                                        clear VV;
                                        clear conrow;

                                        clear Medicaid;
                                        clear Medicaid2;


                                        % /* Now have procedure run through, calculating the Utility you get from 
                                        % having NO LTCI policy, and have it report the entire vector.  In other words, 
                                        % have it report the max utility achievable from following optimal consumption 
                                        % path given every level of starting wealth from 0 to wmax */;

                                        w0=wealth*(1-alpha);
                                        ww=round((w0*1.2+wx-10000)/grid); 
                                        if ww*grid<10000;
                                            wdis=[(0:10*griddense:990)' ; (1000:20*griddense:1980)' ; (2000:50*griddense:9950)'];
                                        else
                                            wdis=[(0:10*griddense:990)' ; (1000:20*griddense:1980)' ; (2000:50*griddense:9950)'; (10000:grid*griddense:10000+(ww-1)*grid)'];
                                        end;
                                        wdis=wdis/X;
                                        w0=w0/X;
                                        wrow=size(wdis,1);

                                        if beq==1;          
                                            wdisbeq=wdis;
                                        else
                                            wdisbeq=1;
                                        end;

                                        [Ustar, MUstar, EPDVMed2, Istarnone,Astream,Cstream] = fn_utilopt(LTCInone,2,wrow,tn,M,r,q,Mcaid,A,wdis,Cbar2,Wbar,Cbar,phi1,phi2,phi3,phi4,gam,beq,d,wdisbeq,neginf,qual2,qual3,qual4,beta,HC0,Food,rho,w0);

                                        % /* Then we want to find the element in Ustar that is closest to Vstar, 
                                        % and then interpolate with the nearest value, in order to hone in on the level 
                                        % of wealth that would get you utility of Vstar */;

                                        Vr=sum(Vstar>Ustar);		    

                                        if Vr==size(Ustar,1);
                                            disp ('Grid not big enough!');       % @ if get this message, go back and adjust wx @;
                                            wequiv=neginf;
                                        elseif Vr==0;
                                            disp ('Vr==0:  LTCI is worth than losing all financial wealth.');
                                            wequiv=Minf;
                                        else
                                            if Ustar(Vr+1,1)>=Vstar && Vstar>=Ustar(Vr,1);
                                                wequiv=wdis(Vr,1)+((Vstar-Ustar(Vr,1))/(Ustar(Vr+1,1)-Ustar(Vr,1)))*(wdis(Vr+1,1)-wdis(Vr,1));
                                                wequiv=(wequiv/(1+r))-w0;
                                            else
                                                disp ('Ustar[1]~Ustar[Vr+1]~Vstar~Ustar[Vr]~Ustar[rows(Ustar)]');
                                                disp([Ustar(1) Ustar(Vr+1,1) Vstar Ustar(Vr,1) Ustar(size(Ustar,1))]);
                                                wequiv=neginf;
                                            end;
                                        end;
    
%                                         /* OUTPUT TO SCREEN */;

                                        if male==0;
                                           disp ('gender =                                                   female');        
                                        else
                                           disp ('gender =                                                    male');
                                        end;
                                        disp (' ');
                                        disp ('wealth decile                                               ') 
                                        disp (wcount);
                                        disp (' ');
                                        disp ('Is there benefit cap? yes=1, 0=no                           ') 
                                        disp (bencap);
                                        disp ('Gross load                                                  ') 
                                        disp (1-MW);
                                        disp (' ');


                                        disp ('Medicaid share of EPDV of total LTC Exp (No private ins)   ') 
                                        disp (MUstar/EPDVMedical);
                                        disp ('     (Previous figure is column 1 of table 2)');
                                        disp (' ');
                                        disp ('Medicaid share of EPDV of total LTC Exp (With private ins) ') 
                                        disp (Mstar/EPDVMedical);
                                        disp ('     (Previous figure is column 2 of table 2)');
                                        disp (' ');
                                        disp ('implicit tax                                             ') 
                                        disp ((MUstar - Mstar)/Istarown);
                                        disp ('     (Previous figure is column 3 of table 4)');
                                        disp (' ');
                                        disp ('Net load                                                 ') 
                                        disp (1-(Istarown-(MUstar-Mstar))/(Istarown/MW));
                                        disp ('     (Previous figure is column 4 of table 4)');
                                        disp (' ');
                                        disp ('Willingness to pay for private LTCI (figures 1 and 2)');
                                        if size(wequiv,1)==1;
                                            if Vr==size(Ustar,1); 
                                                disp ('     Increase in wealth exceeds ') 
                                                disp (wequiv);   % @ if so, need to increase grid @;
                                            elseif Vr<=1;
                                                disp ('     LTCI is worse than losing all financial wealth ') 
                                                disp (wequiv);
                                            else
                                                disp ('     LTCI is equiv to increase in wealth of  ') 
                                                disp ([(wdis(Vr)/(1+r))-w0 wequiv*X (wdis(Vr+1)/(1+r))-w0]);
                                                
                                                if bencap==0 && MWcount==3 && male==1;
                                                    figure2m(wcount+1,1)=wequiv;
                                                elseif bencap==0 && MWcount==3 && male==0; 
                                                    figure2f(wcount+1,1)=wequiv;
                                                elseif bencap==1 && MWcount==0 && male==1
                                                    figure1m(wcount+1,1)=wequiv;
                                                elseif bencap==1 && MWcount==0 && male==0;
                                                    figure1f(wcount+1,1)=wequiv;
                                                end;
                                            end;
                                        else
                                            disp ('     Too many rows of wequiv!');    % @ signifies error  @;
                                        end;
                                        disp (' ');
                                        disp (' ');
                                        disp ('ASSUMPTIONS AND INTERMEDIATE OUTPUT FOLLOWS ...');
                                        disp ('Medicaid 						                        ') 
                                        disp (Mstar);
                                        disp ('Medicaid w/o LTCI                  				        ') 
                                        disp (MUstar);
                                        disp ('EPDV of All Medical Costs 				                ') 
                                        disp (EPDVMedical);
                                        disp ('EPDV of All Medical Costs w/o LTCI (should be same)	    ') 
                                        disp (EPDVMed2);
                                        disp ('EPDV of Insurance benefits (should be same as sben)		') 
                                        disp (Istarown);
                                        disp ('EPDV of Insurance benefits w/o insurance (should be 0)	') 
                                        disp (Istarnone);
                                        disp ('Vstar		           			                      	') 
                                        disp (Vstar);
                                        disp ('risk aversion is                                         ') 
                                        disp (gam);
                                        disp ('Total wealth and financial wealth (w0) are               ') 
                                        disp ([wealth w0]);
                                        disp ('Fraction of total wealth annuitized and monthly annuity: ') 
                                        disp ([alpha A]);
                                        disp ('Is it facility only policy yes=1, no=0                   ') 
                                        disp (fo);
                                        disp ('Fraction of HC covered by Medicare                       ') 
                                        disp (Medicare);
                                        disp ('age and maxage are                                       ') 
                                        disp ([age maxage]);
                                        disp ('r, rho and delta are                                     ') 
                                        disp ([((1+r)^12)-1 ((1+rho)^12)-1 ((1+d)^12)-1]);
                                        disp ('inflation is                                             ') 
                                        disp (((1+inf)^12)-1);
                                        disp ('Medicaid? (=1 if yes) is                                 ') 
                                        disp (Mcaid);
                                        disp ('Food value                                               ') 
                                        disp (Food);
                                        disp ('Wbar, Cbar and Cbar2 are                                 ') 
                                        disp ([Wbar Cbar Cbar2]);
                                        disp ('Qual2, Qual3 and Qual4                                   ') 
                                        disp ([qual2 qual3 qual4]);
                                        disp ('A dollar in home care is worth Beta in consumption       ') 
                                        disp (beta);
                                        disp ('LTCI benefit level is                                    ') 
                                        disp (Bben);
                                        disp ('Benefit inflation protection / growth is                 ') 
                                        disp (((1+Binf)^12)-1);
                                        disp ('Starting medical expenditures for alf and nh are         ') 
                                        disp ([ALFamt NHamt]);
                                        disp ('Bequest factor is                                        ') 
                                        disp (beq);
                                        disp ('State dependent utility (phi), states 1 - 4 private pay  ') 
                                        disp ([phi1 phi2 phi3 phi4]);
                                        disp ('Monthly premium when healthy is                          ') 
                                        disp (P(1,1));
                                        disp ('actuarially fair premium is                              ') 
                                        disp (actfprem);
                                        disp ('Actuarial value of benefits is                           ') 
                                        disp (sben);
                                        disp ('Moneys worth                                             ') 
                                        disp (MW);
                                        disp ('life expectancy is                                       ') 
                                        disp (lifexp);
                                        disp ('SCaling factor X is                                      ') 
                                        disp (X);
                                        disp ('Discretization - # rows of wdis                          ') 
                                        disp (size(wdis,1));
                                        disp ('If wequiv greater than this value, increase wx           ') 
                                        disp (wx);
                                        disp ('end time is');

                                        Bben=Bben+1500/X;
                                        toc
                                    end;
                                    MWcount=MWcount+2;
                                end;
                                Medicare=Medicare+.4;
                            end;
                            medscale=medscale+5;
                        end;
                        Food=Food+250/X;
                    end;
                    gam=gam+2;
                end;
                wcount=wcount+1;
            end;
            fo=fo+1;
        end;
        male=male-1;
    end;
    bencap=bencap+1;
end;
toc































