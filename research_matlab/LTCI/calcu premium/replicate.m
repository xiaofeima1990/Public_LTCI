% replicate of Brown and Finkelstein 2008, AER
% /* The program calculates the LTCI values found in     */
% /* Figures 1 and 2, as well as data for Table 2        */
function replicate(gender)
% diary('replicate.log');
global simul

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

    X=1000;         % @ Wealth scaling factor - converts to units of $X              @
    bencap=1;
    male=gender;			% @ =1 if male, =0 if female			@
  
    

               
                age=65;                     % @ Age at time of purchase	          	@
                maxage=105;		            % @ Max age for calculation			@

                tn=(maxage-age)*12;			% @ number of periods in the problem	@

                graphs = 0;		            % @put in the # of different health trajectories you want to graph@

                gam=3;			            % @ coefficient of relative risk aversion		@
                  % @ Note that when gam=1, undefined.  So uses value 'approaching' 1 @;
                    gam=floor(gam);

                    Food=644/X;                 % @ Food = SSI level used to parameterize food/housing benefit @ 
              

                        Mcaid=1;		            % @ =1 if there is a Medicaid program		@

                        medscale=1;                 % @ scaling variable used for sensitivity checks.  Typically set = 1 @;
                     

                            Wbar=2000/X;	            % @ wealth excluded from Medicaid spend-down (base case is 2000/X)	@ 
                            Cbar=30/X;		            % @ min consumption provided if on Medicaid	@
                            Cbar2=674/X;                % @ CBAR WHILE IN HOME CARE @;

                            Wbar=medscale*Wbar;

%                             @ Cbar=medscale*Cbar;
%                             @ Cbar2=medscale*Cbar2;


                            Medicare=.35;		        % @ Fraction of Home care costs covered by Medicare @
                           


                                MWcount=0;                  % @ Alternative scenarios for market loads of private LTCI prices @
                               

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


                                    Binf=0.05;                     % @ rate of nominal growth of benefits under LTCI policy  @;
                                    Bben=4740/X;                % @ Monthly benefit from LTCI policy     		            @;
                                   


                                        NHamt=78110/(12*X);      	        % @ Monthly cost of NH  $51480  @
                                        ALFamt=3477/X;              % @ Monthly cost of ALF $25908 per year  @

                                        HCnonrn=21/X;               % @ Hourly HC costs (non RN) @
                                        HCrn=43/X;                  % @ Hourly HC costs (RN)  @

                                        r=.03;			            % @ real interest rate				        @
                                        rho=.03;		            % @ discount rate for utility of consumption	@
                                        d=.03;			            % @ discount rate for utility of bequests		@
                                        inf=.03;		            % @ price inflation rate	                    @
                                        rminf=.015;		            % @ real medical cost growth (over inflation)	@
                                    
                                    % *************************************************************************
                                    % * 	END USER INPUT						                              *
                                    % *************************************************************************



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
                                        q=[zeros(30,26); q]; 
                                        hcexp0=[zeros(30,2); hcexp0]; 
                                        hcexp1=[zeros(30,2); hcexp1]; 
                                    
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
                                        fo=0;
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
                                        

                  simul.q=q;
                  simul.B=B;
                  simul.M=M;
                  simul.rfactor=rfactor;
                  simul.P=P;
                  simul.T=tn;
                  simul.Prem=Prem;
                  




