%simulating the medicaid expenditure & insurance 

function simulate(Astream,Cstream,M,LTCI,A,wdis,wrow)
X=1000;
Mcaid=1;
%about some parameter
Wbar=2000/X;	            % @ wealth excluded from Medicaid spend-down (base case is 2000/X)	@ 
Cbar=30/X;		            % @ min consumption provided if on Medicaid	@
Cbar2=545/X;                % @ CBAR WHILE IN HOME CARE @;



r=.03;			            % @ real interest rate				        @
rho=.03;		            % @ discount rate for utility of consumption	@
d=.03;			            % @ discount rate for utility of bequests		@
inf=.03;		            % @ price inflation rate	                    @
rminf=.015;		            % @ real medical cost growth (over inflation)	@
tn=480;                                    

%simulate parameter
N=10000;
t=1;
Wealth=ones(N,1).*1100;
c=zeros(tn,N);
Mecaidmatrix=zeros(N,1);
Insurancematrix=zeros(N,1);
stateMatrix=zeros(N,1);
nextW=zeros(N,1);

for t=1:tn
    stateMatrix=ceil(rand(N,1).*4); 
  if Mcaid==1 && (A+LTCI(t,stateMatrix)+wdis(Wealth)-M(t,stateMatrix))<(Cbar2+Wbar) && (A+LTCI(t,stateMatrix)-M(t,stateMatrix)+r.*wdis(Wealth)./(1+r))<(Cbar2) && stateMatrix==2;

             if wdis(Wealth)./(1+r)>Wbar;
                wextra=wdis(Wealth) ./(1+r)-Wbar;
            else
                wextra=zeros(N,1);
            end;
            %nextW=find(wdis(wdis>A+LTCI(t,stateMatrix)+Wealth-M(t,stateMatrix)),fist)-1;
            nextW=Astream([(t-1)*wrow+Wealth, stateMatrix]);
            c(t,:)=Wealth./(1+r)-wdis(nextW)./(1+r)+Cbar2-wextra;
            %c=Cstream([(t-1)*wrow+nextW, stateMatrix]);

            Mecaidmatrix = Mecaidmatrix+ M(t,stateMatrix) - wextra - (A+LTCI(t,stateMatrix)+r.* wealth./(1+r) -Cbar2);
            Insurancematrix =Insurancematrix+ LTCI(t,stateMatrix);
            Wealth=nextW;
       
        elseif Mcaid==1 &&  (A+LTCI(t,stateMatrix)+wdis(Wealth)-M(t,stateMatrix))<(Cbar+Wbar) && (A+LTCI(t,stateMatrix)-M(t,stateMatrix)+r.*wdis(Wealth)./(1+r))<(Cbar) && stateMatrix==2;

             if wdis(Wealth)./(1+r)>Wbar;
                wextra=wdis(Wealth) ./(1+r)-Wbar;
            else
                wextra=zeros(N,1);
            end;
            
                Mecaidmatrix = Mecaidmatrix+ M(t,stateMatrix) - wextra - (A+LTCI(t,stateMatrix)+r.* wealth./(1+r) -Cbar);
                Insurancematrix =Insurancematrix+ LTCI(t,stateMatrix);

            %nextW=find(wdis(wdis>A+LTCI(t,stateMatrix)+Wealth-M(t,stateMatrix)),fist)-1;
            nextW=Astream([(t-1)*wrow+Wealth, stateMatrix]);
            c(t,:)=Wealth./(1+r)-wdis(nextW)./(1+r)+Cbar2-wextra;

            Wealth=nextW;       

        else % @not on Medicaid@
            %nextW=find(wdis(wdis>A+LTCI(t,stateMatrix)+Wealth-M(t,stateMatrix)),fist)-1;
            nextW=Astream([(t-1)*wrow+Wealth, stateMatrix]);
            c(t,:)=wdis(Wealth)-M(t,stateMatrix)+LTCI(t,stateMatrix)+A-wdis(nextW)./(1+r);
            %Mecaidmatrix = Mecaidmatrix+0;
            if stateMatrix >=2;
               Insurancematrix= Insurancematrix+LTCI(t,stateMatrix);
            end;
        end;
end