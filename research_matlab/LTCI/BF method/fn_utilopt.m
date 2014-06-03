% /*
% =================================================================================
%        PROCEDURE for COMPUTING UTILITY GIVEN LONG-TERM CARE MATRIX                              
% =================================================================================
% 
%  NOTE: 	This section defines a procedure called "utilopt" that is then called   
%      	just like any other Gauss procedure.  It takes 2 arguments:  
%         LTCI is matrix of LTCI values.  If insurance exists, then
%    	    call up using LTCIown as the LTCI matrix.  If no insurance, then use 	
% 	    LTCInone (which is a matrix of zeros.  Proctype indicates if entire 
%    	    Vstar vector or just the optimal value should be the output of the procedure 
% 
% A few other notes:
%    1) Medicaid:  When one passes the asset and income test to qualify for Medicaid, the
%    Medicaid vector keeps track of the amount of $ Medicaid is paying towards your care in that health
%    and asset state.  This is updated every period to take into account the possibility of needing
%    care tomorrow, and to do so uses the matrix Medicaid2.
% 
% 2) Consumption and Asset paths:
%    Matrices keep track of the potential consumption options in each period, and the program then
%    picks the optimal consumption based on the vector of utility derived from each consumption level.
%    Building on this, we define the matrix ASTREAM that keeps track of which "bin" in the descritized wealth
%    vector is where that maximum is achieved.  Note: this matrix keeps track of the maximum for ANY HEALTH.WEALTH
%    combination - so it has (tn*wrow) rows and 4 columns.  This info is used to define the CSTREAM matrix, 
%    which keeps track of the consumption at each of these maximum bins.  Again, this is a large matrix that can 
%    be used to trace out ANY consumption path for ANY health path.
%    These matrices will be saved (such as for subsequent graphing) if the "graphs" variable >0.  */


function [Vstar Mstar Medicalstar Istar,Astream,Cstream]=fn_utilopt(LTCI,proctype,wrow,tn,M,r,q,Mcaid,A,wdis,Cbar2,Wbar,Cbar,phi1,phi2,phi3,phi4,gam,beq,d,wdisbeq,neginf,qual2,qual3,qual4,beta,HC0,Food,rho,w0)
%     local Vmax,B,c,cmaxind,cnegind,zeroind,VV;
%     local t,wstart,wcompare,wcrit,Vstar,i,j,V,wextra;
% 	local Medicaid2, Medicaid, cell, Mstar;
% 	local insurance2, insurance, Istar;
% 	local Medical, Medicalstar;
% 	local Astream, Astream2, Cstream, Cstream1;
% 	local prec, field, fmat, s,w,g,l, amatrixname, cmatrixname;
% 	local gr, money;

    Vmax=zeros(wrow,4);             	% /* Place holder for value function 	*/
	Medical = zeros(tn,5);


% /* This section is simply a consistency check on the Medicaid programming*/
Medical(tn,:) = M(tn,1:5);
t = tn-1;


while t >0;
	j = 1;
    while j<=5;
        Medical(t,j) = M(t,j) + (1/(1+r))*(q(t+1,(j-1)*5+1)*Medical(t+1,1) + q(t+1,(j-1)*5+2)*Medical(t+1,2) + q(t+1,(j-1)*5+3)*Medical(t+1,3) + q(t+1,(j-1)*5+4)*Medical(t+1,4)+ q(t+1,(j-1)*5+5)*Medical(t+1,5));
        j = j+1;
    end;
	t=t-1;
end;

% /*Now discount it back one more period*/ Medicalstar equals to sben if there's no benefit cap.
Medicalstar = (1/(1+r))*(q(1,1)*Medical(1,1) + q(1,2)*Medical(1,2) + q(1,3)*Medical(1,3) + q(1,4)*Medical(1,4));

% /*END OF CHECK*/

% /* Create necessary matrices */;
insurance = zeros(wrow,4);
% insurance2= zeros(wrow,4);
% Medicaid2 = zeros(wrow,4);
Medicaid = zeros(wrow,4);

Astream=zeros(tn*wrow,4);
Cstream=zeros(tn*wrow,4);

% astream2=0;
% cstream1=0;

%         /* Determines value function for period T */
t=tn;
i=1;                    % /* i indexes wealth vector - amount of wealth at start of period */;
while i<=wrow;
    j=1;                    % /* j indexes health status 1 through 5 */
    while j<=4;

        VV=zeros(wrow,4);


        % /* Medicaid is defined so that (a) if Medicaid exists, and 
        % (b) starting wealth for period falls below Wbar (asset test) and 
        % (c) income plus LCTI income is less than sum of medical expenses and minimum 
        % consumption level Cbar, then person permitted to consume max of Cbar. */;

        % /* Income test includes annuity, difference between insurance and expenses, +interest income) 
        % Since wdis already includes the interest, the asset test must subtract interest back off.  
        % The subtraction in the asset test and addition in the income test cancel in the combined constraint. */;

        if Mcaid==1 && (A+LTCI(t,j)+wdis(i)-M(t,j))<(Cbar2+Wbar) && (A+LTCI(t,j)-M(t,j)+r*wdis(i)/(1+r))<(Cbar2) && j==2;

            if wdis(i)/(1+r)>Wbar;
                wextra=wdis(i)/(1+r)-Wbar;
            else
                wextra=0;
            end;
            c=wdis(i)/(1+r)-wdis/(1+r)+Cbar2-wextra;%???

            Medicaid(i,j) = M(t,j) - wextra - (A+LTCI(t,j)+r*wdis(i)/(1+r) -Cbar2);
            insurance(i,j) = LTCI(t,j);

            cnegind=(c>0);	% @cnegind=(c.>0)@
            zeroind=1-cnegind;     
            c=c.*(1-zeroind)+zeroind.*(.0001);        
        elseif Mcaid==1 && (A+LTCI(t,j)+wdis(i)-M(t,j))<(Cbar+Wbar) && (A+LTCI(t,j)-M(t,j)+r*wdis(i)/(1+r))<(Cbar) && j>2;

            if wdis(i)/(1+r)>Wbar;
                wextra=wdis(i)/(1+r)-Wbar;
            else
                wextra=0;
            end;
                Medicaid(i,j) = M(t,j) - wextra - (A+LTCI(t,j)+r*wdis(i)/(1+r)-Cbar);
                insurance(i,j) = LTCI(t,j);

            c=wdis(i)/(1+r)-wdis/(1+r)+Cbar-wextra;


            cnegind=(c>0);	% @cnegind=(c.>0);@
            zeroind=1-cnegind;     
            c=c.*(1-zeroind)+zeroind.*(.0001);        

        else % @not on Medicaid@
            c=wdis(i)-M(t,j)+LTCI(t,j)+A-wdis/(1+r);
            Medicaid(i,j) = 0;
            if j >=2;
               insurance(i,j) = LTCI(t,j);
            end;

            cmaxind=(wdis(i)+A-M(t,j)+LTCI(t,j)>=c);		% @.>=@
            cnegind=(c>0);		%@cnegind=(c.>0);@
            zeroind=1-(cmaxind.*cnegind);
            c=c.*(1-zeroind)+zeroind.*(.0001);
        end;


        % /* Note that the consumption vector will include negative values of consumption.  Thus there are
        % two constraints imposed -- one is that consumption be feasible, in that the individual's 
        % starting wealth, annuity income, and net medical/LTCI payments must leave them with enough 
        % income to consume the level c indicated.  The second is that consumption must be positive.  
        % if either of these constraints fail, then the indicator zeroind replaces c with a small 
        % positive value (.0001) just so that the CRRA utility function does not explode -- but 
        % then later, it must replace the utility level associated with that consumption with neginf 
        % (which stands for minus infinitiy - but is just a big negative number) so that we 
        % are sure the program does not choose that path.  In some cases, these tests are redundant */;
        %                         
        % /* Calculate value function for each combination of C(t) and W(t+1), given 
        % that you came into this period with w(t) = wdis(i), and health status j */;
        % 
        % /* Note, the only reason it is necessary to do the following if-then statements is
        % if we one uses state dependent utility.  */;

        if j==1;
                VV(:,j)=(phi1*fn_util(c,gam)+((1/(1+d))*fn_utilbeq(wdisbeq,beq))).*(1-zeroind)+zeroind*neginf;
        elseif j==2;
            if Mcaid==1 && (A+LTCI(t,j)+wdis(i)-M(t,j))<(Cbar2+Wbar) && (A+LTCI(t,j)-M(t,j)+r*wdis(i)/(1+r))<(Cbar2);
                VV(:,j)=(phi2*fn_util(c+qual2*beta*HC0(t,1),gam)+((1/(1+d))*fn_utilbeq(wdisbeq,beq))).*(1-zeroind)+zeroind*neginf;
            else
                VV(:,j)=(phi2*fn_util(c+beta*HC0(t,1),gam)+((1/(1+d))*fn_utilbeq(wdisbeq,beq))).*(1-zeroind)+zeroind*neginf; 
            end;
        elseif j==3;
            if Mcaid==1 && (A+LTCI(t,j)+wdis(i)-M(t,j))<(Cbar+Wbar) && (A+LTCI(t,j)-M(t,j)+r*wdis(i)/(1+r))<(Cbar);                
                VV(:,j)=(phi3*fn_util(c+qual3*Food,gam)+((1/(1+d))*fn_utilbeq(wdisbeq,beq))).*(1-zeroind)+zeroind*neginf;
            else
                VV(:,j)=(phi3*fn_util(c+Food,gam)+((1/(1+d))*fn_utilbeq(wdisbeq,beq))).*(1-zeroind)+zeroind*neginf; 
            end;
        elseif j==4;
            if Mcaid==1 && (A+LTCI(t,j)+wdis(i)-M(t,j))<(Cbar+Wbar) && (A+LTCI(t,j)-M(t,j)+r*wdis(i)/(1+r))<(Cbar);
                VV(:,j)=(phi4*fn_util(c+qual4*Food,gam)+((1/(1+d))*fn_utilbeq(wdisbeq,beq))).*(1-zeroind)+zeroind*neginf;
            else
                VV(:,j)=(phi4*fn_util(c+Food,gam)+((1/(1+d))*fn_utilbeq(wdisbeq,beq))).*(1-zeroind)+zeroind*neginf; 
            end;
        else

        end;

        % /* For each possible combination of starting wealth for the period and health 
        % status, choose the maximum value of VV */;

        [Vmax(i,j) Astream(((t-1)*wrow)+i,j)]=max(VV(:,j));   

%         Astream(((t-1)*wrow)+i,j) = indexcat(VV(:,j),Vmax(i,j)); % @this picks the bin number where the maximum utility is reached@

        Cstream(((t-1)*wrow)+i,j) = c(Astream(((t-1)*wrow)+i,j),1); % @this picks the consumption amt in the bin where the maximum utility is reached@

        j=j+1;
    end;
i=i+1;
end;

V=Vmax;
Medicaid2 = Medicaid;
insurance2= insurance;


% /* V now represents the value function -- the max utility achievable from 
% following optimal consumption path in period tn.  Now 
% we go back to period tn-1, and ultimately back to time 0 */;
disp('main loop time ')
tic
t=tn-1;
while t>=1;
    Medicaid = zeros(wrow,4);
    insurance = zeros(wrow,4);

    i=1;                            % /* i indexes t wealth state */
    while (i<=wrow);
        j=1;			            % /* j indexes t health state */
        while (j<=4);

            if Mcaid==1 && (A+LTCI(t,j)+wdis(i)-M(t,j))<(Cbar2+Wbar) && (A+LTCI(t,j)-M(t,j)+r*wdis(i)/(1+r))<(Cbar2) && j==2;

                if wdis(i)/(1+r)>Wbar;
                    wextra=wdis(i)/(1+r)-Wbar;
                else
                    wextra=0;
                end;
                c=wdis(i)/(1+r)-wdis/(1+r)+Cbar2-wextra;

                  Medicaid(i,j) = M(t,j) - wextra - (A+LTCI(t,j)+r*wdis(i)/(1+r)-Cbar2);
                insurance(i,j) = LTCI(t,j);


                cnegind=(c>0);		% @cnegind=(c.>0);@
                zeroind=1-cnegind;     
                c=c.*(1-zeroind)+zeroind.*(.0001);
            elseif Mcaid==1 && (A+LTCI(t,j)+wdis(i)-M(t,j))<(Cbar+Wbar) && (A+LTCI(t,j)-M(t,j)+r*wdis(i)/(1+r))<(Cbar) && j>2;

                if wdis(i)/(1+r)>Wbar;
                    wextra=wdis(i)/(1+r)-Wbar;
                else
                    wextra=0;
                end;
                c=wdis(i)/(1+r)-wdis/(1+r)+Cbar-wextra;

                  Medicaid(i,j) = M(t,j) - wextra - (A+LTCI(t,j)+r*wdis(i)/(1+r) -Cbar);					          
                insurance(i,j) = LTCI(t,j);

                cnegind=(c>0);		% @cnegind=(c.>0);@
                zeroind=1-cnegind;     
                c=c.*(1-zeroind)+zeroind.*(.0001);
            else % @not on Medicaid@
                Medicaid(i,j) = 0;
                if j>=2;
                   insurance(i,j) = LTCI(t,j);
                end;
                c=wdis(i)-M(t,j)+LTCI(t,j)+A-wdis/(1+r);
                cmaxind=(wdis(i)+A-M(t,j)+LTCI(t,j)>=c);		% @.>=@
                cnegind=(c>0);		% @cnegind=(c.>0);@
                zeroind=1-(cmaxind.*cnegind);
                c=c.*(1-zeroind)+zeroind.*(.0001);
            end;

            if j==1;
                VV(:,j)=phi1*fn_util(c,gam).*(1-zeroind)+zeroind*neginf;
            elseif j==2;
                if Mcaid==1 && (A+LTCI(t,j)+wdis(i)-M(t,j))<(Cbar2+Wbar) && (A+LTCI(t,j)-M(t,j)+r*wdis(i)/(1+r))<(Cbar2);
                    VV(:,j)=(phi2*fn_util(c+qual2*beta*HC0(t,1),gam)).*(1-zeroind)+zeroind*neginf;
                else
                    VV(:,j)=(phi2*fn_util(c+beta*HC0(t,1),gam)).*(1-zeroind)+zeroind*neginf; 
                end;
            elseif j==3;
                if Mcaid==1 && (A+LTCI(t,j)+wdis(i)-M(t,j))<(Cbar+Wbar) && (A+LTCI(t,j)-M(t,j)+r*wdis(i)/(1+r))<(Cbar);
                    VV(:,j)=phi3*fn_util(c+qual3*Food,gam).*(1-zeroind)+zeroind*neginf;
                else
                    VV(:,j)=phi3*fn_util(c+Food,gam).*(1-zeroind)+zeroind*neginf; 
                end;
            elseif j==4;
                if Mcaid==1 && (A+LTCI(t,j)+wdis(i)-M(t,j))<(Cbar+Wbar) && (A+LTCI(t,j)-M(t,j)+r*wdis(i)/(1+r))<(Cbar);
                    VV(:,j)=phi4*fn_util(c+qual4*Food,gam).*(1-zeroind)+zeroind*neginf;
                else
                    VV(:,j)=phi4*fn_util(c+Food,gam).*(1-zeroind)+zeroind*neginf; 
                end;
            else

            end;

            % /* Then, regardless of health status, we then have to add in the value of 
            % taking wealth into the next period, recognizing you can enter next period 
            % in any of 5 states.  */;			

            VV(:,j)=VV(:,j)+(1/(1+rho))*q(t+1,(j-1)*5+1)*V(:,1);
            VV(:,j)=VV(:,j)+(1/(1+rho))*q(t+1,(j-1)*5+2)*V(:,2);
            VV(:,j)=VV(:,j)+(1/(1+rho))*q(t+1,(j-1)*5+3)*V(:,3);
            VV(:,j)=VV(:,j)+(1/(1+rho))*q(t+1,(j-1)*5+4)*V(:,4);
            VV(:,j)=(VV(:,j)+(1/(1+d))*q(t+1,(j-1)*5+5)*fn_utilbeq(wdisbeq,beq));

            % /* Now pick maximum value */;
		    [Vmax(i,j) cell]=max(VV(:,j));

% 			cell = indexcat(VV(:,j),Vmax(i,j));

			Medicaid(i,j) = Medicaid(i,j) + (1/(1+r))*(q(t+1,(j-1)*5+1)*Medicaid2(cell,1) + q(t+1,(j-1)*5+2)*Medicaid2(cell,2) + q(t+1,(j-1)*5+3)*Medicaid2(cell,3) + q(t+1,(j-1)*5+4)*Medicaid2(cell,4));
			insurance(i,j) = insurance(i,j) + (1/(1+r))*(q(t+1,(j-1)*5+1)*insurance2(cell,1) + q(t+1,(j-1)*5+2)*insurance2(cell,2) + q(t+1,(j-1)*5+3)*insurance2(cell,3) + q(t+1,(j-1)*5+4)*insurance2(cell,4));
			Astream(((t-1)*wrow)+i,j) = cell;
%             Astream(((t-1)*wrow)+i,j) = indexcat(VV(:,j),Vmax(i,j));
			Cstream(((t-1)*wrow)+i,j) = c(Astream(((t-1)*wrow)+i,j),1);

			j=j+1;
        end;
        i=i+1;
    end;
    V=Vmax;
	Medicaid2 = Medicaid;
	insurance2 = insurance;

  	t=t-1;
end;
toc
disp('loop is done')


% /* This gives you utility as of period 1.  
% Now go back to period 0 for healthy person. */;

Vstar=(1/(1+rho))*((q(1,1))*V(:,1)+(q(1,2))*V(:,2)+(q(1,3))*V(:,3)+(q(1,4))*V(:,4));
Vstar=Vstar+(1/(1+d))*(q(1,5))*fn_utilbeq(wdisbeq,beq);

Mstar=(1/(1+r))*((q(1,1))*Medicaid2(:,1)+(q(1,2))*Medicaid2(:,2)+(q(1,3))*Medicaid2(:,3)+(q(1,4))*Medicaid2(:,4));
Mstar=Mstar+(1/(1+d))*(q(1,5))*fn_utilbeq(wdisbeq,beq);

Istar=(1/(1+r))*((q(1,1))*insurance2(:,1)+(q(1,2))*insurance2(:,2)+(q(1,3))*insurance2(:,3)+(q(1,4))*insurance2(:,4));
Istar=Istar+(1/(1+d))*(q(1,5))*fn_utilbeq(wdisbeq,beq);
	
% /* Vstar is utility as of period 0 and given initial wealth for healthy person as of starting age */

if proctype==1;         % /* proctype==1 means want to report optimal value only */

    wstart=w0*(1+r);
    wcompare=(wstart>=wdis);	
    wcrit=sum(wcompare);
    if wcrit>=wrow;             
        Vstar=Vstar(wrow);
        Mstar=Mstar(wrow);
        Istar=Istar(wrow);
    else
        Vstar=Vstar(wcrit)+(Vstar(wcrit+1)-Vstar(wcrit))*((wstart-wdis(wcrit))/(wdis(wcrit+1)-wdis(wcrit)));
        Mstar=Mstar(wcrit)+(Mstar(wcrit+1)-Mstar(wcrit))*((wstart-wdis(wcrit))/(wdis(wcrit+1)-wdis(wcrit)));
        Istar=Istar(wcrit)+(Istar(wcrit+1)-Istar(wcrit))*((wstart-wdis(wcrit))/(wdis(wcrit+1)-wdis(wcrit)));
    end;
elseif proctype==2;         % @this is the same as if proctype = 1, except we don't calculate Vstar, only Mstar@

    wstart=w0*(1+r);
    wcompare=(wstart>=wdis);		% @wcompare=(wstart.>=wdis);@
    wcrit=sum(wcompare);
    if wcrit>=wrow;             
        Mstar=Mstar(wrow);
        Istar=Istar(wrow);
    else
        Mstar=Mstar(wcrit)+(Mstar(wcrit+1)-Mstar(wcrit))*((wstart-wdis(wcrit))/(wdis(wcrit+1)-wdis(wcrit)));
        Istar=Istar(wcrit)+(Istar(wcrit+1)-Istar(wcrit))*((wstart-wdis(wcrit))/(wdis(wcrit+1)-wdis(wcrit)));
    end;

end;

% % /*SAVES THE ASSET AND CONSUMPTION MATRICES IF WE WANT TO GRAPH LATER*/
% if graphs >0;
%     prec = 0;
%     field = 1;
%     fmat = "_w%*.*lf";
% 
%     w = ftos(wcount,fmat,field,prec);
% 
%     fmat = "_gam%*.*lf";
% 
%     g = ftos(gam,fmat,field,prec);
% 
%     fmat = "_grid%*.*lf";
% 
%     gr = ftos(grid,fmat,field,prec);
% 
%     fmat = "_MW%*.*lf";
% 
%     money = ftos(MW*100, fmat, field, prec);
% 
%     if proctype == 1;
%         l="_own";
%     elseif proctype == 2;
%         l="_none";
%     end;
% 
%     if male == 1;
%         s="_M";
%     elseif male == 0;
%         s="_F";
%     end;
% 
%     Amatrixname = "A" $+ s $+ w $+ g $+ gr $+ money $+ l;
%     cmatrixname = "C" $+ s $+ w $+ g $+ gr $+ money $+ l;
% 
%     save ^Amatrixname = Astream;
%     save ^Cmatrixname = Cstream;
% end;
		
% retp(Vstar, Mstar, Medicalstar, Istar);


% /*=================================================================================*/
% /*       END UTILITY PROCEDURE                                                     */
% /*=================================================================================*/
