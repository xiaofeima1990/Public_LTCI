#include "LTCIparallel.h"

int    healthstate[NSIMUL][TN];
double q[TN+12][25];

extern int    healthstate[NSIMUL][TN];
extern double q[TN+12][25];

static double Preimum[10][2]={   
	0.162322821033513,   0.073874174822684,
	0.154994520734275,   0.073711243825464,
	0.152944581781425,   0.067285400764399,
	0.147071938552908,   0.067896435428286,
	0.145690799334747,   0.064174922538671,
	0.138761369184279,   0.062224985684947,
	0.134683986131120,   0.061388416283990,
	0.131488381673699,   0.058189010158005,
	0.128306756916874,   0.055619773804933,
	0.127918649067460,   0.053385302639523

};

 PARA para;
 CALCSTRUCT CalcStructv;


Parallel_LTCI::Parallel_LTCI(int _wealthdistribute, int _gender, int _deductgrid,int _weahth,int _wx,int _grid, double _alpha){
	double X=1000;
	wealthpercentile =_wealthdistribute;
	gender			 =_gender;
	deductgrid	     =_deductgrid;

 	memset(&CalcStruct,0,sizeof(CALCSTRUCT));

	CalcStruct.alpha = _alpha;
	CalcStruct.wealth=_weahth;
	CalcStruct.wx	  =_wx;
	CalcStruct.grid  =_grid;
	CalcStruct.W0=(double)CalcStruct.wealth*(1-CalcStruct.alpha)/X;   
	


}





void Parallel_LTCI::calcPrep(int gender, int wealthpercentile, int priflag)
{
	int i ,j;

	double bfactor[TN];
	double mfactor[TN];
	double ifactor[TN];
	double rfactor[TN];
	double cost[TN][5];
	double ben[TN][5];
	double scost,sben;
	double AFP, actfprem;
	double Atemp;

	int WW;
	int wrow;




	//calcate M B and find min(M,B)
	//都已经初始化过了


//	time_began=time(NULL);
	/* choose market load */

	if(para.MWcount==0){if (gender==0) para.MW=1.058; else para.MW=0.5;}
	else if(para.MWcount==1){if (gender==0) para.MW=0.6; else para.MW=0.3;}
	else if(para.MWcount==2){if (gender==0) para.MW=1.358127; else para.MW=0.6418727;}
	else if(para.MWcount==3){if (gender==0) para.MW=1.358127; else para.MW=0.6418727;}
	else if(para.MWcount==4){if (gender==0) para.MW=1; else para.MW=1;}






	memset(CalcStruct.M[0],0,sizeof(double[5]));

	for(i=0;i<TN;i++)
	{
		CalcStruct.M[i][1] = CalcStruct.hcexp[i];
		CalcStruct.M[i][2] = para.ALFamt;
		CalcStruct.M[i][3] = para.NHamt;

		switch (para.fo)
		{
		case 0: 
			{	
				for (j=1;j<4;j++) CalcStruct.B[i][j] = para.Bben; 
				CalcStruct.P[i][0] = para.premium; 
				break;

			} 
		case 1:
			{
				for (j=2;j<4;j++) CalcStruct.B[i][j] = para.Bben; 
				CalcStruct.P[i][0] = para.premium; 
				CalcStruct.P[i][1] = para.premium; 
				break;

			}

		} 


	}


	// Incorporate nominal growth rates 
	bfactor[0]=1+para.Binf; mfactor[0]=1+para.Minf;
	for (i=1;i<TN;i++) bfactor[i]=bfactor[i-1]*(1+para.Binf);
	for (i=1;i<TN;i++) mfactor[i]=mfactor[i-1]*(1+para.Minf);
	for (i=0;i<TN;i++) for (j=0;j<5;j++) CalcStruct.B[i][j]=CalcStruct.B[i][j]*bfactor[i];
	for (i=0;i<TN;i++) for (j=0;j<5;j++) CalcStruct.M[i][j]=CalcStruct.M[i][j]*mfactor[i];
	for (i=0;i<TN;i++) CalcStruct.HC0[i]=CalcStruct.HC0[i]*mfactor[i];

	// Now take the min of benefit level and actual cost 
	// compute MIN(B,M)
	if(para.bencap ==1 ) 
		for(i=0;i<TN;i++)for(j=0;j<5;j++)CalcStruct.B[i][j]=min(CalcStruct.B[i][j],CalcStruct.M[i][j]);

	else
		memcpy(CalcStruct.B,CalcStruct.M,sizeof(double [TN][5]));


	//Now convert from nominal to real
	ifactor[0]=1+para.inf; rfactor[0]=1+para.r; 
	for (i=1;i<TN;i++) ifactor[i]=ifactor[i-1]*(1+para.inf);
	for (i=0;i<TN;i++) for (j=0;j<5;j++) CalcStruct.P[i][j]=CalcStruct.P[i][j]/ifactor[i];
	for (i=0;i<TN;i++) for (j=0;j<5;j++) CalcStruct.B[i][j]=CalcStruct.B[i][j]/ifactor[i];
	for (i=0;i<TN;i++) for (j=0;j<5;j++) CalcStruct.M[i][j]=CalcStruct.M[i][j]/ifactor[i];
	for (i=0;i<TN;i++)					 CalcStruct.HC0[i] =CalcStruct.HC0[i] /ifactor[i];

	for (i=1;i<TN;i++) rfactor[i]=rfactor[i-1]*(1+para.r);





	//calculate actuarially fair premium	
		if (priflag==1)
		{
			if (deductgrid==1)
			{for(i=0;i<TN;i++)for(j=0;j<5;j++)cost[i][j]=CalcStruct.P[i][j] * CalcStruct.Prob[i+1][j] / rfactor[i];
			for(i=0;i<TN;i++)for(j=0;j<5;j++)ben [i][j]=CalcStruct.B[i][j] * CalcStruct.Prob[i+1][j] / rfactor[i];

			scost=0; sben=0;
			for(i=0;i<TN;i++) scost=scost+cost[i][0];
			for(i=0;i<TN;i++) for(j=0;j<5;j++) sben=sben+ben[i][j];

			AFP = ( sben / scost)*para.premium;}
			else
				AFP=Preimum[deductgrid-1][gender];

		}else
		{	for(i=0;i<TN;i++)for(j=0;j<5;j++)cost[i][j]=CalcStruct.P[i][j] * CalcStruct.Prob[i+1][j] / rfactor[i];
			for(i=0;i<TN;i++)for(j=0;j<5;j++)ben [i][j]=CalcStruct.B[i][j] * CalcStruct.Prob[i+1][j] / rfactor[i];

			scost=0; sben=0;
			for(i=0;i<TN;i++) scost=scost+cost[i][0];
			for(i=0;i<TN;i++) for(j=0;j<5;j++) sben=sben+ben[i][j];

			AFP = ( sben / scost)*para.premium;

		}




		actfprem=AFP;

		for(i=0;i<TN;i++) for(j=0;j<5;j++) CalcStruct.P[i][j]=(CalcStruct.P[i][j] / para.premium) *(AFP / para.MW);

		//calculate monthly annuity amount A
		Atemp=0;
		for(i=0;i<TN;i++) Atemp=Atemp+ (1-CalcStruct.Prob[i+1][4]) / rfactor[i];

		CalcStruct.A = (CalcStruct.alpha/(1-CalcStruct.alpha)) *CalcStruct.W0 / Atemp;

		/* Create LTCIown, a matrix that is tn rows x 5 states that is the net payment    */
		/* to the policy holder.  Will be equal to -P when healthy, equal to benefit when */
		/* receiving benefit and premium is waived, and equal to B-P when receiving 	  */
		/* benefit but policy is not waived.						                      */
		/* LTCInone is a matrix of zeros of same size as LTCIown to be used when the 	  */                                         
		/* individual does not own insurance						                      */

		for(i=0;i<TN;i++) for(j=0;j<5;j++) CalcStruct.LTCIown[i][j] = CalcStruct.B[i][j]- CalcStruct.P[i][j];

}


void Parallel_LTCI::gridsetup(int flag, int wealthpercentile){
	double X,griddense;
	int WW,i;
	int broden;
	double *wdis;

	wdis =CalcStruct.Wdis;


	X=1000;
	broden=1;
	griddense=1.0/broden;


	CalcStruct.W0=CalcStruct.wealth*(1-CalcStruct.alpha);                   // % @ This section simply creates discretized grid @;

	if (flag==1)
		WW=(int)((CalcStruct.W0*1.2-10000)/(CalcStruct.grid*griddense))+1; 
	else
		WW=(int)((CalcStruct.W0*1.2+CalcStruct.wx-10000)/(CalcStruct.grid*griddense))+1;


	
	if (WW*CalcStruct.grid<10000)
	{
		wdis[0]=0;
		for (i=1;i<101*broden;i++)			wdis[i]=wdis[i-1]+10*griddense/X;
		for(i=101*broden;i<151*broden;i++)	wdis[i]=wdis[i-1]+20*griddense/X;
		for(i=151*broden;i<311*broden;i++)	wdis[i]=wdis[i-1]+50*griddense/X;
		CalcStruct.wrow=310*broden;
	}else{
		wdis[0]=0;
		for (i=1;i<101*broden;i++)				wdis[i]=wdis[i-1]+10*griddense/X;
		for(i=101*broden;i<151*broden;i++)		wdis[i]=wdis[i-1]+20*griddense/X;
		for(i=151*broden;i<311*broden;i++)		wdis[i]=wdis[i-1]+50*griddense/X;
		for(i=311*broden;i<311*broden+WW;i++)	wdis[i]=wdis[i-1]+CalcStruct.grid*griddense/X;
		CalcStruct.wrow=311*broden+WW;

	}

	/*WW=4000;
	griddense=(int)((CalcStruct.W0*1.5)/WW);

	wdis[0]=0;
	for(i=1;i<WW;i++)wdis[i]=wdis[i-1]+griddense/X;

	CalcStruct.wrow=WW;
*/
	//WW=(int)((CalcStruct.W0*1.2)/(CalcStruct.grid*griddense))+1;

	//wdis[0]=0;
	//for(i=1;i<WW;i++)wdis[i]=wdis[i-1]+CalcStruct.grid*griddense/X;

	//CalcStruct.wrow=WW;

	if (CalcStruct.wrow>MAXGRID) {cout<<"maxgrid is too small"<<endl;system("pause");}

	CalcStruct.W0=CalcStruct.W0/X;

	memset(Deductile,0,sizeof(int [DEDUCTGRID]));
	Deductile[deductgrid-1]=1;  //19 is 1

}


void Parallel_LTCI::calcModel( int wealthpercentile,bool NIflag ){

		// about input parameter
		//LTCI,proctype,wrow,tn,M,r,q,Mcaid,A,wdis,Cbar2,Wbar,Cbar,phi1,phi2,phi3,phi4,gam,beq,d,wdisbeq,neginf,qual2,qual3,qual4,beta,HC0,Food,rho,w0
		/*
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
		%    These matrices will be saved (such as for subsequent graphing) if the "graphs" variable >0.  
		*/


		int t,j,i,k,l,p,deduct;
		int wrow,tn;  
		int wcrit,tempIndex;
		int Vr;
		int deductgrid;
		int (*Astream)[TN][4][MAXGRID];



		double Cbar,Wbcar,Cbar2,r;
		double phi;
		double tempVMax;
		double consplus;
		double wextra,wstart;
		


		double A;
		double Medicalstar;
		double constraint;

		double wequiv;

		double Medical[TN][5];
		double LTCIMM[TN][5];
		double (*M)[5];
		double (*B)[5];
		double (*Prob)[5];
		
		double *wdis;
		double *hcexp;
		double *HC0;
		
	
		/*define a inserted structure*/
		
		typedef struct{
			double c[DEDUCTGRID][MAXGRID];
			double zeroind[DEDUCTGRID][MAXGRID];
			double OUTutil[DEDUCTGRID][MAXGRID];
			double insurance[4][DEDUCTGRID][MAXGRID];
			double insurance2[4][DEDUCTGRID][MAXGRID];
			double Medicaid[4][DEDUCTGRID][MAXGRID];
			double Medicaid2[4][DEDUCTGRID][MAXGRID];
			double VV[4][DEDUCTGRID][MAXGRID];
			double Vmax[4][DEDUCTGRID][MAXGRID];
			double V[4][DEDUCTGRID][MAXGRID];
			double Vstar[DEDUCTGRID][MAXGRID];
			double Mstar[DEDUCTGRID][MAXGRID];
			double Istar[DEDUCTGRID][MAXGRID];
			

		}LOCALSTRUCT;

		LOCALSTRUCT *lcp;
		void *lcpbuffer;


		lcpbuffer = malloc( sizeof(LOCALSTRUCT));
		if(lcpbuffer==NULL) {cout<<"LOCALSTRUCT allocation is failed"<<endl; system("pause"); exit(0);}
		lcp= (LOCALSTRUCT *) lcpbuffer;
		memset(lcp,0,sizeof(LOCALSTRUCT));


		r=para.r;
		Cbar=para.Cbar;
		Cbar2=para.Cbar2;
		Wbcar=para.Wbar;
		
		tn=TN;


			



		M=CalcStruct.M;
		B=CalcStruct.B;
		Prob=CalcStruct.Prob;
		hcexp=CalcStruct.hcexp;
		HC0=CalcStruct.HC0;

		A=CalcStruct.A;


		if (!NIflag){
			memcpy(LTCIMM,CalcStruct.LTCIown,sizeof(double [TN][5]));
			gridsetup(1,wealthpercentile);
			deductgrid=DEDUCTGRID;
			Astream=CalcStruct.Astream;
		}else{
			memset(LTCIMM,0,sizeof(double [TN][5]));
			gridsetup(0,wealthpercentile);
			deductgrid=1;
			Astream=CalcStruct.AstreamN;
		}


		wrow=CalcStruct.wrow;
		wdis =CalcStruct.Wdis;


		/************************************************************************/
		/* Calculate Medical Star   EPDV                                        */
		/************************************************************************/

		memset(Medical,0,sizeof(double[TN][5]));
		memcpy(Medical[TN-1],CalcStruct.M[TN-1],sizeof(double[5]));

		for(t=TN-2;t>=0;t--) for(j=0;j<5;j++)
			Medical[t][j]=M[t][j]+(1/(1+para.r))*(q[t+1][j*5]*Medical[t+1][0] +q[t+1][j*5+1]*Medical[t+1][1] + q[t+1][j*5+2]*Medical[t+1][2] + q[t+1][j*5+3]*Medical[t+1][3]+ q[t+1][j*5+4]*Medical[t+1][4]);

		Medicalstar= (1/(1+para.r))*(q[0][0]*Medical[0][0] + q[0][1]*Medical[0][1] + q[0][2]*Medical[0][2] + q[0][3]*Medical[0][3]+ q[0][4]*Medical[0][4]);

		Digram.Medicalstar=Medicalstar;






		/* Determines value function for period T */

		t=tn-1;
		memset(lcp->Medicaid,0,sizeof(double [4][DEDUCTGRID][MAXGRID]));
		memset(lcp->insurance,0,sizeof(double [4][DEDUCTGRID][MAXGRID]));

		for(j=0;j<4;j++)
		{

			for(deduct=0;deduct<deductgrid;deduct++)	
				for(i=0;i<wrow;i++)
				{
					//当期病了算不算？？？ 感觉不应该算
					constraint=A+LTCIMM[t][j]*(deduct+(j>0)>deductgrid-2)+LTCIMM[t][0]*(deduct+(j>0) <= deductgrid-2 )+wdis[i]-M[t][j];// 这个写法满足要求


					/* Medicaid is defined so that (a) if Medicaid exists, and 
					(b) starting wealth for period falls below Wbar (asset test) and 
					(c) income plus LCTI income is less than sum of medical expenses and minimum 
					consumption level Cbar, then person permitted to consume max of Cbar. */;

					/* Income test includes annuity, difference between insurance and expenses, +interest income) 
					% Since wdis already includes the interest, the asset test must subtract interest back off.  
					% The subtraction in the asset test and addition in the income test cancel in the combined constraint. */

					if(para.Mcaid==1 &&  constraint < (Cbar2+Wbcar) && constraint-wdis[i]/(1+r) < Cbar2 && j==1)
					{

						wextra =max(double(wdis[i]/(1+r) -Wbcar),double(0));

						for(k=0;k<wrow;k++)
						{
							lcp->c[deduct][k]=wdis[i]/(1+r) -wdis[k]/(1+r)+Cbar2-wextra;
							if(lcp->c[deduct][k]>0)lcp->zeroind[deduct][k]=0;else {lcp->c[deduct][k]=0.0001;lcp->zeroind[deduct][k]=1;}
						}

						lcp->Medicaid[j][deduct][i]= (M[t][j]-LTCIMM[t][j]*(deduct+(j>0)>deductgrid-2)-LTCIMM[t][0]*(deduct+(j>0) <= deductgrid-2 ))-max((double)0,(double)(wextra+(A+r*wdis[i]/(1+r) -Cbar2)));
						if(deduct+(j>0)>deductgrid-2)lcp->insurance[j][deduct][i] = LTCIMM[t][j];

					}else if(para.Mcaid==1 &&  constraint < (Cbar+Wbcar) &&  constraint-wdis[i]/(1+r)< Cbar && j>1 )
					{

						wextra =max(double(wdis[i]/(1+r) -Wbcar),double(0));


						if(deduct+(j>0)>deductgrid-2)lcp->insurance[j][deduct][i] = LTCIMM[t][j];
						lcp->Medicaid[j][deduct][i]= (M[t][j]-LTCIMM[t][j]*(deduct+(j>0)>deductgrid-2)-LTCIMM[t][0]*(deduct+(j>0) <= deductgrid-2 ))-max((double)0,(double)(wextra+(A+r*wdis[i]/(1+r) -Cbar)));


						for(k=0;k<wrow;k++)
						{

							lcp->c[deduct][k]=wdis[i]/(1+r) -wdis[k]/(1+r)+Cbar-wextra;
							if(lcp->c[deduct][k]>0) lcp->zeroind[deduct][k]=0;else{lcp->c[deduct][k]=0.0001;lcp->zeroind[deduct][k]=1;}
						}


					}else { // not on medicaid  LTCI pay for insurance

						for(k=0;k<CalcStruct.wrow;k++)
						{
							lcp->c[deduct][k]=wdis[i]-wdis[k]/(1+r) +A +LTCIMM[t][j]*(deduct+(j>0)>deductgrid-2)+LTCIMM[t][0]*(deduct+(j>0) <= deductgrid-2 )-M[t][j];
							if(lcp->c[deduct][k]>0 && wdis[i]+A-M[t][j]+LTCIMM[t][j]*(deduct+(j>0)>deductgrid-2)+LTCIMM[t][0]*(deduct+(j>0) <= deductgrid-2 )-lcp->c[deduct][k]>=0)lcp->zeroind[deduct][k]=0;else{lcp->c[deduct][k]=0.0001;lcp->zeroind[deduct][k]=1;}
						}

						lcp->Medicaid[j][deduct][i]=0;
						if (j>=1) lcp->insurance[j][deduct][i]=LTCIMM[t][j]*(deduct+(j>0)>deductgrid-2);

					}


					/* Note that the consumption vector will include negative values of consumption.  Thus there are
					two constraints imposed -- one is that consumption be feasible, in that the individual's 
					starting wealth, annuity income, and net medical/LTCI payments must leave them with enough 
					income to consume the level c indicated.  The second is that consumption must be positive.  
					if either of these constraints fail, then the indicator zeroind replaces c with a small 
					positive value (.0001) just so that the CRRA utility function does not explode -- but 
					then later, it must replace the utility level associated with that consumption with neginf 
					(which stands for minus infinitiy - but is just a big negative number) so that we 
					are sure the program does not choose that path.  In some cases, these tests are redundant */;

					/* Calculate value function for each combination of C(t) and W(t+1), given 
					that you came into this period with w(t) = wdis(i), and health status j */;

					/* Note, the only reason it is necessary to do the following if-then statements is
					if we one uses state dependent utility.  */
					switch(j){
					case 0: { consplus=0;phi=para.phi_hc; break;}
					case 1: {  consplus=0;phi=para.phi_alf;  break;}
							//if(stateFlag==1){ consplus=para.qual_alf*para.beta*HC0[t]; fn_util(c,OUTutil,para.crra,consplus); for(i=0;i<wrow;i++) VV[i][j]=para.phi_alf*OUTutil[i] +zeroind[i]*(-9999) ;}
							//	else {consplus=para.beta*HC0[t];  fn_util(c,OUTutil,para.crra,consplus); for(i=0;i<wrow;i++) VV[i][j]=para.phi_alf*OUTutil[i] +zeroind[i]*(-9999); }}
					case 2: { consplus=para.Food;phi=para.phi_nh; break; }

							//if(stateFlag==1){ consplus=para.qual_alf*para.beta*HC0[t]; fn_util(c,OUTutil,para.crra,consplus); for(i=0;i<wrow;i++) VV[i][j]=para.phi_alf*OUTutil[i] +zeroind[i]*(-9999) ;}
							//	else {consplus=para.beta*HC0[t];  fn_util(c,OUTutil,para.crra,consplus); for(i=0;i<wrow;i++) VV[i][j]=para.phi_alf*OUTutil[i] +zeroind[i]*(-9999); }}
					case 3: { consplus=para.Food;phi=para.phi_nh;break;}

					}
					fn_util(lcp->c[deduct],lcp->zeroind[deduct],lcp->VV[j][deduct],para.crra,consplus,phi);



					//find the maximized VV Vmax Astream Cstream
					tempVMax=lcp->VV[j][deduct][0];
					tempIndex=0;
					for(k=0;k<wrow;k++){		
						if(lcp->VV[j][deduct][k]>tempVMax)
						{
							tempVMax=lcp->VV[j][deduct][k];
							tempIndex=k;
						}
					}


					CalcStruct.Cstream[deduct][t][j][i]=lcp->c[deduct][tempIndex];
					Astream[deduct][t][j][i]=tempIndex;
					lcp->Vmax[j][deduct][i]=tempVMax;


				}//i

		}//j


		memcpy(lcp->V,lcp->Vmax,sizeof(double[4][DEDUCTGRID][MAXGRID]));
		memcpy(lcp->Medicaid2,lcp->Medicaid,sizeof(double [4][DEDUCTGRID][MAXGRID]));
		memcpy(lcp->insurance2,lcp->insurance,sizeof(double [4][DEDUCTGRID][MAXGRID]));



		for(t=tn-2;t>=deductgrid-1;t--)
		{

			memset(lcp->Medicaid,0,sizeof(double[4][DEDUCTGRID][MAXGRID]));
			memset(lcp->insurance,0,sizeof(double[4][DEDUCTGRID][MAXGRID]));


			 
			for (j=0;j<4;j++)
				for(deduct=0;deduct<deductgrid;deduct++)
					for(i=0;i<CalcStruct.wrow;i++)
					{
						constraint=A+LTCIMM[t][j]*(deduct+(j>0)>deductgrid-2)+LTCIMM[t][0]*(deduct+(j>0) <= deductgrid-2 )+wdis[i]-M[t][j];

						if(para.Mcaid==1 &&  constraint < (Cbar2+Wbcar) && constraint-wdis[i]/(1+r) < Cbar2 && j==1)
						{

							if (wdis[i]/(1+r) > Wbcar) wextra = wdis[i]/(1+r) -Wbcar;
							else wextra=0;
							for(k=0;k<CalcStruct.wrow;k++)
							{

								lcp->c[deduct][k]=wdis[i]/(1+r) -wdis[k]/(1+r)+Cbar2-wextra;
								if(lcp->c[deduct][k]>0)lcp->zeroind[deduct][k]=0;else {lcp->c[deduct][k]=0.0001;lcp->zeroind[deduct][k]=1;}
							}

							lcp->Medicaid[j][deduct][i]= (M[t][j]-LTCIMM[t][j]*(deduct+(j>0)>deductgrid-2)-LTCIMM[t][0]*(deduct+(j>0) <= deductgrid-2 ))-max((double)0,(double)(wextra+(A+r*wdis[i]/(1+r) -Cbar2)));

							if(deduct+(j>0) > deductgrid-2)lcp->insurance[j][deduct][i] = LTCIMM[t][j];

						}else if(para.Mcaid==1 &&  constraint < (Cbar+Wbcar) &&  constraint-wdis[i]/(1+r)< Cbar && j>1 )
						{

							if (wdis[i]/(1+r) > Wbcar) wextra=wdis[i]/(1+r) -Wbcar;
							else wextra=0;


							lcp->Medicaid[j][deduct][i]= (M[t][j]-LTCIMM[t][j]*(deduct+(j>0)>deductgrid-2)-LTCIMM[t][0]*(deduct+(j>0) <= deductgrid-2 ))-max((double)0,(double)(wextra+(A+r*wdis[i]/(1+r) -Cbar)));
							if(deduct+(j>0) > deductgrid-2)lcp->insurance[j][deduct][i] = LTCIMM[t][j];

							for(k=0;k<CalcStruct.wrow;k++)
							{

								lcp->c[deduct][k]=wdis[i]/(1+r) -wdis[k]/(1+r)+Cbar-wextra;
								if(lcp->c[deduct][k]>0) lcp->zeroind[deduct][k]=0;else{lcp->c[deduct][k]=0.0001;lcp->zeroind[deduct][k]=1;}
							}


						}else { // not on medicaid  // LTCI pay for insurance

							for(k=0;k<CalcStruct.wrow;k++)
							{
								lcp->c[deduct][k]=wdis[i]-wdis[k]/(1+r) +A +LTCIMM[t][j]*(deduct+(j>0)>deductgrid-2)+LTCIMM[t][0]*(deduct+(j>0) <= deductgrid-2 )-M[t][j];
								if(lcp->c[deduct][k]>0 && wdis[i]+A-M[t][j]+LTCIMM[t][j]*(deduct+(j>0)>deductgrid-2)+LTCIMM[t][0]*(deduct+(j>0) <= deductgrid-2 )-lcp->c[deduct][k]>=0)lcp->zeroind[deduct][k]=0;else{lcp->c[deduct][k]=0.0001;lcp->zeroind[deduct][k]=1;}
							}

							lcp->Medicaid[j][deduct][i]=0;
							if (j>=1) lcp->insurance[j][deduct][i]=LTCIMM[t][j]*(deduct+(j>0)>deductgrid-2);



						}



						/* Calculate value function for each combination of C(t) and W(t+1), given 
						that you came into this period with w(t) = wdis(i), and health status j */;

						/* Note, the only reason it is necessary to do the following if-then statements is
						if we one uses state dependent utility.  */


						switch(j){
						case 0: { consplus=0;phi=para.phi_hc; break;}
						case 1: {  consplus=0;phi=para.phi_alf;  break;}
								//if(stateFlag==1){ consplus=para.qual_alf*para.beta*HC0[t]; fn_util(c,OUTutil,para.crra,consplus); for(i=0;i<wrow;i++) VV[i][j]=para.phi_alf*OUTutil[i] +zeroind[i]*(-9999) ;}
								//	else {consplus=para.beta*HC0[t];  fn_util(c,OUTutil,para.crra,consplus); for(i=0;i<wrow;i++) VV[i][j]=para.phi_alf*OUTutil[i] +zeroind[i]*(-9999); }}
						case 2: { consplus=para.Food;phi=para.phi_nh; break; }

								//if(stateFlag==1){ consplus=para.qual_alf*para.beta*HC0[t]; fn_util(c,OUTutil,para.crra,consplus); for(i=0;i<wrow;i++) VV[i][j]=para.phi_alf*OUTutil[i] +zeroind[i]*(-9999) ;}
								//	else {consplus=para.beta*HC0[t];  fn_util(c,OUTutil,para.crra,consplus); for(i=0;i<wrow;i++) VV[i][j]=para.phi_alf*OUTutil[i] +zeroind[i]*(-9999); }}
						case 3: { consplus=para.Food;phi=para.phi_nh;break;}

						}
						fn_util(lcp->c[deduct],lcp->zeroind[deduct],lcp->VV[j][deduct],para.crra,consplus,phi);


						/* Then, regardless of health status, we then have to add in the value of 
						taking wealth into the next period, recognizing you can enter next period 
						in any of 5 states.  */

						/* for the deductile situation we need some adjust*/
						//如果当期j=0健康，那么下一期肯定deductile计算清零 deduct =0
						for(k=0;k<CalcStruct.wrow;k++)
							if(j==0)
								lcp->VV[j][deduct][k]=lcp->VV[j][deduct][k]+
							 (1/(1+para.rho))*q[t+1][j*5  ]*lcp->V[0][0][k]
							+(1/(1+para.rho))*q[t+1][j*5+1]*lcp->V[1][0][k]
							+(1/(1+para.rho))*q[t+1][j*5+2]*lcp->V[2][0][k]
							+(1/(1+para.rho))*q[t+1][j*5+3]*lcp->V[3][0][k];
							else if(j>=1&&deduct<deductgrid-1)
								lcp->VV[j][deduct][k]=lcp->VV[j][deduct][k]+
							 (1/(1+para.rho))*q[t+1][j*5  ]*lcp->V[0][deduct+1][k]
							+(1/(1+para.rho))*q[t+1][j*5+1]*lcp->V[1][deduct+1][k]
							+(1/(1+para.rho))*q[t+1][j*5+2]*lcp->V[2][deduct+1][k]
							+(1/(1+para.rho))*q[t+1][j*5+3]*lcp->V[3][deduct+1][k];
							else if(j>=1 && deduct>=deductgrid-1)
								lcp->VV[j][deduct][k]=lcp->VV[j][deduct][k]+
								(1/(1+para.rho))*q[t+1][j*5  ]*lcp->V[0][deduct][k]
							+(1/(1+para.rho))*q[t+1][j*5+1]*lcp->V[1][deduct][k]
							+(1/(1+para.rho))*q[t+1][j*5+2]*lcp->V[2][deduct][k]
							+(1/(1+para.rho))*q[t+1][j*5+3]*lcp->V[3][deduct][k];


							//find the maximized VV Vmax Astream Cstream

							tempVMax=lcp->VV[j][deduct][0];
							tempIndex=0;
							for(k=0;k<CalcStruct.wrow;k++){		
								if(lcp->VV[j][deduct][k]>tempVMax)
								{
									tempVMax=lcp->VV[j][deduct][k];
									tempIndex=k;
								}
							}


							if(j==0)
								lcp->Medicaid[j][deduct][i] = lcp->Medicaid[j][deduct][i] +  (1/(1+r))*( 
							 q[t+1][j*5+0]*lcp->Medicaid2[0][0][tempIndex]
							+q[t+1][j*5+1]*lcp->Medicaid2[1][0][tempIndex]
							+q[t+1][j*5+2]*lcp->Medicaid2[2][0][tempIndex]
							+q[t+1][j*5+3]*lcp->Medicaid2[3][0][tempIndex]);

							else if(j>=1&&deduct<deductgrid-1)
								lcp->Medicaid[j][deduct][i] = lcp->Medicaid[j][deduct][i] +  (1/(1+r))*( 
							 q[t+1][j*5+0]*lcp->Medicaid2[0][deduct+1][tempIndex]
							+q[t+1][j*5+1]*lcp->Medicaid2[1][deduct+1][tempIndex]
							+q[t+1][j*5+2]*lcp->Medicaid2[2][deduct+1][tempIndex]
							+q[t+1][j*5+3]*lcp->Medicaid2[3][deduct+1][tempIndex]);
							else if(j>=0 && deduct==deductgrid-1)
								lcp->Medicaid[j][deduct][i] = lcp->Medicaid[j][deduct][i] +  (1/(1+r))*( 
								q[t+1][j*5+0]*lcp->Medicaid2[0][deduct][tempIndex]
							+q[t+1][j*5+1]*lcp->Medicaid2[1][deduct][tempIndex]
							+q[t+1][j*5+2]*lcp->Medicaid2[2][deduct][tempIndex]
							+q[t+1][j*5+3]*lcp->Medicaid2[3][deduct][tempIndex]);




							if(j==0)
								lcp->insurance[j][deduct][i]= lcp->insurance[j][deduct][i] + (1/(1+r))*(   
							 q[t+1][j*5+0]*lcp->insurance2[0][0][tempIndex]
							+q[t+1][j*5+1]*lcp->insurance2[1][0][tempIndex]
							+q[t+1][j*5+2]*lcp->insurance2[2][0][tempIndex]
							+q[t+1][j*5+3]*lcp->insurance2[3][0][tempIndex]);

							else if(j>=1&&deduct<deductgrid-1)
								lcp->insurance[j][deduct][i]= lcp->insurance[j][deduct][i] + (1/(1+r))*(   
							 q[t+1][j*5+0]*lcp->insurance2[0][deduct+1][tempIndex]
							+q[t+1][j*5+1]*lcp->insurance2[1][deduct+1][tempIndex]
							+q[t+1][j*5+2]*lcp->insurance2[2][deduct+1][tempIndex]
							+q[t+1][j*5+3]*lcp->insurance2[3][deduct+1][tempIndex]);

							else if(j>=1 && deduct==deductgrid-1)
								lcp->insurance[j][deduct][i]= lcp->insurance[j][deduct][i] + (1/(1+r))*(   
								q[t+1][j*5+0]*lcp->insurance2[0][deduct][tempIndex]
							+q[t+1][j*5+1]*lcp->insurance2[1][deduct][tempIndex]
							+q[t+1][j*5+2]*lcp->insurance2[2][deduct][tempIndex]
							+q[t+1][j*5+3]*lcp->insurance2[3][deduct][tempIndex]);


							CalcStruct.Cstream[deduct][t][j][i]=lcp->c[deduct][tempIndex];
							Astream[deduct][t][j][i]=tempIndex;
							lcp->Vmax[j][deduct][i]=tempVMax;

					}//i,j


					memcpy(lcp->V,lcp->Vmax,sizeof(double[4][DEDUCTGRID][MAXGRID]));
					memcpy(lcp->Medicaid2, lcp->Medicaid,sizeof(double [4][DEDUCTGRID][MAXGRID]));
					memcpy(lcp->insurance2,lcp->insurance,sizeof(double [4][DEDUCTGRID][MAXGRID]));


		}//t


		if(deductgrid>=2)
			for(t=deductgrid-2;t>=0;t--)
			{
				memset(lcp->Medicaid,0,sizeof(double[4][DEDUCTGRID][MAXGRID]));
				memset(lcp->insurance,0,sizeof(double[4][DEDUCTGRID][MAXGRID]));



				for (j=0;j<4;j++)
					for(deduct=0;deduct<t;deduct++)
						for(i=0;i<CalcStruct.wrow;i++)
						{
							//constraint=A+LTCI[t][j]*Deductile*(deduct+1>=deductgrid-1)+wdis[i]-M[t][j];
							constraint=A+wdis[i]+LTCIMM[t][0]-M[t][j];

							if(para.Mcaid==1 &&  constraint < (Cbar2+Wbcar) && constraint-wdis[i]/(1+r) < Cbar2 && j==1)
							{

								if (wdis[i]/(1+r) > Wbcar) wextra = wdis[i]/(1+r) -Wbcar;
								else wextra=0;
								for(k=0;k<CalcStruct.wrow;k++)
								{
									lcp->c[deduct][k]=wdis[i]/(1+r) -wdis[k]/(1+r)+Cbar2-wextra;
									if(lcp->c[deduct][k]>0)lcp->zeroind[deduct][k]=0;else {lcp->c[deduct][k]=0.0001;lcp->zeroind[deduct][k]=1;}
								}

								lcp->Medicaid[j][deduct][i]= (M[t][j]-LTCIMM[t][0]*(deduct+(j>0) <= deductgrid-2 ))-max((double)0,(double)(wextra+(A+r*wdis[i]/(1+r) -Cbar2)));

								lcp->insurance[j][deduct][i] =0;

							}else if(para.Mcaid==1 &&  constraint < (Cbar+Wbcar) &&  constraint-wdis[i]/(1+r)< Cbar && j>1 )
							{

								if (wdis[i]/(1+r) > Wbcar) wextra=wdis[i]/(1+r) -Wbcar;
								else wextra=0;


								lcp->insurance[j][deduct][i] =0;
								lcp->Medicaid[j][deduct][i]= (M[t][j]-LTCIMM[t][0]*(deduct+(j>0) <= deductgrid-2 ))-max((double)0,(double)(wextra+(A+r*wdis[i]/(1+r) -Cbar)));


								for(k=0;k<CalcStruct.wrow;k++)
								{
									lcp->c[deduct][k]=wdis[i]/(1+r) -wdis[k]/(1+r)+Cbar-wextra;
									if(lcp->c[deduct][k]>0) lcp->zeroind[deduct][k]=0;else{lcp->c[deduct][k]=0.0001;lcp->zeroind[deduct][k]=1;}
								}


							}else { // not on medicaid  // LTCI pay for insurance

								for(k=0;k<CalcStruct.wrow;k++)
								{
									lcp->c[deduct][k]=wdis[i]-wdis[k]/(1+r) +A +LTCIMM[t][0] -M[t][j];
									if(lcp->c[deduct][k]>0 && wdis[i]+A-M[t][j]+LTCIMM[t][0] -lcp->c[deduct][k]>=para.eps)lcp->zeroind[deduct][k]=0;else{lcp->c[deduct][k]=0.0001;lcp->zeroind[deduct][k]=1;}
								}

								lcp->Medicaid[j][deduct][i]=0;
								if (j>=1) lcp->insurance[j][deduct][i]=0;

							}



							/* Calculate value function for each combination of C(t) and W(t+1), given 
							that you came into this period with w(t) = wdis(i), and health status j */;

							/* Note, the only reason it is necessary to do the following if-then statements is
							if we one uses state dependent utility.  */

							switch(j){
							case 0: { consplus=0;phi=para.phi_hc; break;}
							case 1: {  consplus=0;phi=para.phi_alf;  break;}
									//if(stateFlag==1){ consplus=para.qual_alf*para.beta*HC0[t]; fn_util(c,OUTutil,para.crra,consplus); for(i=0;i<wrow;i++) VV[i][j]=para.phi_alf*OUTutil[i] +zeroind[i]*(-9999) ;}
									//	else {consplus=para.beta*HC0[t];  fn_util(c,OUTutil,para.crra,consplus); for(i=0;i<wrow;i++) VV[i][j]=para.phi_alf*OUTutil[i] +zeroind[i]*(-9999); }}
							case 2: { consplus=para.Food;phi=para.phi_nh; break; }

									//if(stateFlag==1){ consplus=para.qual_alf*para.beta*HC0[t]; fn_util(c,OUTutil,para.crra,consplus); for(i=0;i<wrow;i++) VV[i][j]=para.phi_alf*OUTutil[i] +zeroind[i]*(-9999) ;}
									//	else {consplus=para.beta*HC0[t];  fn_util(c,OUTutil,para.crra,consplus); for(i=0;i<wrow;i++) VV[i][j]=para.phi_alf*OUTutil[i] +zeroind[i]*(-9999); }}
							case 3: { consplus=para.Food;phi=para.phi_nh;break;}

							}
							fn_util(lcp->c[deduct],lcp->zeroind[deduct],lcp->VV[j][deduct],para.crra,consplus,phi);


							for(k=0;k<CalcStruct.wrow;k++)
								if(j==0)
									lcp->VV[j][deduct][k]=lcp->VV[j][deduct][k]+
								 (1/(1+para.rho))*q[t+1][j*5  ]*lcp->V[0][0][k]
								+(1/(1+para.rho))*q[t+1][j*5+1]*lcp->V[1][0][k]
								+(1/(1+para.rho))*q[t+1][j*5+2]*lcp->V[2][0][k]
								+(1/(1+para.rho))*q[t+1][j*5+3]*lcp->V[3][0][k];
								else if(j>=1&&deduct<deductgrid-1)
									lcp->VV[j][deduct][k]=lcp->VV[j][deduct][k]+
								 (1/(1+para.rho))*q[t+1][j*5  ]*lcp->V[0][deduct+1][k]
								+(1/(1+para.rho))*q[t+1][j*5+1]*lcp->V[1][deduct+1][k]
								+(1/(1+para.rho))*q[t+1][j*5+2]*lcp->V[2][deduct+1][k]
								+(1/(1+para.rho))*q[t+1][j*5+3]*lcp->V[3][deduct+1][k];
								else if(j>=1 && deduct==deductgrid-1)
									lcp->VV[j][deduct][k]=lcp->VV[j][deduct][k]+
								(1/(1+para.rho))*q[t+1][j*5  ]*lcp->V[0][deduct][k]
								+(1/(1+para.rho))*q[t+1][j*5+1]*lcp->V[1][deduct][k]
								+(1/(1+para.rho))*q[t+1][j*5+2]*lcp->V[2][deduct][k]
								+(1/(1+para.rho))*q[t+1][j*5+3]*lcp->V[3][deduct][k];


								//find the maximized VV Vmax Astream Cstream
								tempVMax=lcp->VV[j][deduct][0];
								tempIndex=0;
								for(k=0;k<CalcStruct.wrow;k++){		
									if(lcp->VV[j][deduct][k]>tempVMax)
									{
										tempVMax=lcp->VV[j][deduct][k];
										tempIndex=k;
									}
								}


								if(j==0)
									lcp->Medicaid[j][deduct][i] = lcp->Medicaid[j][deduct][i] + 
				     (1/(1+r))*( q[t+1][j*5+0]*lcp->Medicaid2[0][0][tempIndex]
								+q[t+1][j*5+1]*lcp->Medicaid2[1][0][tempIndex]
								+q[t+1][j*5+2]*lcp->Medicaid2[2][0][tempIndex]
								+q[t+1][j*5+3]*lcp->Medicaid2[3][0][tempIndex]);

								else if(j>=1&&deduct<deductgrid-1)
									lcp->Medicaid[j][deduct][i] = lcp->Medicaid[j][deduct][i] +  
					 (1/(1+r))*( q[t+1][j*5+0]*lcp->Medicaid2[0][deduct+1][tempIndex]
								+q[t+1][j*5+1]*lcp->Medicaid2[1][deduct+1][tempIndex]
								+q[t+1][j*5+2]*lcp->Medicaid2[2][deduct+1][tempIndex]
								+q[t+1][j*5+3]*lcp->Medicaid2[3][deduct+1][tempIndex]);
								else if(j>=1 && deduct==deductgrid-1)
									lcp->Medicaid[j][deduct][i] = lcp->Medicaid[j][deduct][i] + 
									(1/(1+r))*( q[t+1][j*5+0]*lcp->Medicaid2[0][deduct][tempIndex]
								+q[t+1][j*5+1]*lcp->Medicaid2[1][deduct][tempIndex]
								+q[t+1][j*5+2]*lcp->Medicaid2[2][deduct][tempIndex]
								+q[t+1][j*5+3]*lcp->Medicaid2[3][deduct][tempIndex]);

								

								if(j==0)
									lcp->insurance[j][deduct][i]= lcp->insurance[j][deduct][i] + 
				      (1/(1+r))*(q[t+1][j*5+0]*lcp->insurance2[0][0][tempIndex]
								+q[t+1][j*5+1]*lcp->insurance2[1][0][tempIndex]
								+q[t+1][j*5+2]*lcp->insurance2[2][0][tempIndex]
								+q[t+1][j*5+3]*lcp->insurance2[3][0][tempIndex]);

								else if(j>=1&&deduct<deductgrid-1)
									lcp->insurance[j][deduct][i]= lcp->insurance[j][deduct][i] + (1/(1+r))*(   q[t+1][j*5+0]*lcp->insurance2[0][deduct+1][tempIndex]
								+q[t+1][j*5+1]*lcp->insurance2[1][deduct+1][tempIndex]
								+q[t+1][j*5+2]*lcp->insurance2[2][deduct+1][tempIndex]
								+q[t+1][j*5+3]*lcp->insurance2[3][deduct+1][tempIndex]);
								else if(j>=1 && deduct==deductgrid-1)
									lcp->insurance[j][deduct][i]= lcp->insurance[j][deduct][i] + 
					(1/(1+r))*(   q[t+1][j*5+0]*lcp->insurance2[0][deduct][tempIndex]
								+q[t+1][j*5+1]*lcp->insurance2[1][deduct][tempIndex]
								+q[t+1][j*5+2]*lcp->insurance2[2][deduct][tempIndex]
								+q[t+1][j*5+3]*lcp->insurance2[3][deduct][tempIndex]);


								CalcStruct.Cstream[deduct][t][j][i]=lcp->c[deduct][tempIndex];
								Astream[deduct][t][j][i]=tempIndex;
								lcp->Vmax[j][deduct][i]=tempVMax;

						}//i,j


						memcpy(lcp->V,lcp->Vmax,sizeof(double[4][DEDUCTGRID][MAXGRID]));
						memcpy(lcp->Medicaid2, lcp->Medicaid,sizeof(double [4][DEDUCTGRID][MAXGRID]));
						memcpy(lcp->insurance2,lcp->insurance,sizeof(double [4][DEDUCTGRID][MAXGRID]));



			}



			/* This gives you utility as of period 1.  
			Now go back to period 0 for healthy person. */

			for(deduct=0;deduct<1;deduct++)
				for (i=0;i<CalcStruct.wrow;i++)
				{
					lcp->Vstar[deduct][i]=(1/(1+para.rho)) * 
				   ( q[0][0]*lcp->V[0][deduct][i]
					+q[0][1]*lcp->V[1][deduct][i]
					+q[0][2]*lcp->V[2][deduct][i]
					+q[0][3]*lcp->V[3][deduct][i]);

					//Vstar[i]=Vstar[i]+(1/(1+para.d))*(q[0][4]*fn_utilbeq(para.beq));

					lcp->Mstar[deduct][i]=(1/(1+r))*
				   ( q[0][0]*lcp->Medicaid2[0][deduct][i]
					+q[0][1]*lcp->Medicaid2[1][deduct][i]
					+q[0][2]*lcp->Medicaid2[2][deduct][i]
					+q[0][3]*lcp->Medicaid2[3][deduct][i]);

					//mstar[i]=Mstar[i]+(1/(1+para.d))*(q[0][4]*fn_utilbeq(para.beq)); 

					lcp->Istar[deduct][i]=(1/(1+r)) *
				   ( q[0][0]*lcp->insurance2[0][deduct][i]
					+q[0][1]*lcp->insurance2[1][deduct][i]
					+q[0][2]*lcp->insurance2[2][deduct][i]
					+q[0][3]*lcp->insurance2[3][deduct][i]);
					////mstar[i]=Mstar[i]+(1/(1+para.d))*(q[0][4]*fn_utilbeq(para.beq)); 


				}

				wcrit=0;


				wstart=CalcStruct.W0*(1+r);


				for(i=0;i<wrow;i++) if (wstart>=wdis[i]) wcrit++;
				deduct=0;

				if (!NIflag){
					if (wcrit>=CalcStruct.wrow)
					{
						Digram.Vstar=lcp->Vstar[deduct][CalcStruct.wrow-1];
						Digram.Mstar=lcp->Mstar[deduct][CalcStruct.wrow-1];
						Digram.Istar=lcp->Istar[deduct][CalcStruct.wrow-1];
					}else
					{
						Digram.Vstar=lcp->Vstar[deduct][wcrit-1]+(lcp->Vstar[deduct][wcrit]-lcp->Vstar[deduct][wcrit-1])*((wstart-wdis[wcrit-1])/(wdis[wcrit]-wdis[wcrit-1]));
						Digram.Mstar=lcp->Mstar[deduct][wcrit-1]+(lcp->Mstar[deduct][wcrit]-lcp->Mstar[deduct][wcrit-1])*((wstart-wdis[wcrit-1])/(wdis[wcrit]-wdis[wcrit-1]));
						Digram.Istar=lcp->Istar[deduct][wcrit-1]+(lcp->Istar[deduct][wcrit]-lcp->Istar[deduct][wcrit-1])*((wstart-wdis[wcrit-1])/(wdis[wcrit]-wdis[wcrit-1]));
					}		

					

				}else{

					if (wcrit>=CalcStruct.wrow)
					{

						Digram.MstarNI=lcp->Mstar[deduct][CalcStruct.wrow-1];
						Digram.IstarNI=lcp->Istar[deduct][CalcStruct.wrow-1];
					}else
					{

						Digram.MstarNI=lcp->Mstar[deduct][wcrit-1]+(lcp->Mstar[deduct][wcrit]-lcp->Mstar[deduct][wcrit-1])*((wstart-wdis[wcrit-1])/(wdis[wcrit]-wdis[wcrit-1]));
						Digram.IstarNI=lcp->Istar[deduct][wcrit-1]+(lcp->Istar[deduct][wcrit]-lcp->Istar[deduct][wcrit-1])*((wstart-wdis[wcrit-1])/(wdis[wcrit]-wdis[wcrit-1]));
					}	

					memcpy(Digram.VstarNI,lcp->Vstar,sizeof(double [MAXGRID]));
					/************************************************************************/
					/* calculate willingness to pay   at  no insurance status               */
					/************************************************************************/


					Vr=0;

					for (i=0;i<CalcStruct.wrow;i++) if(Digram.Vstar> Digram.VstarNI[i]) Vr=Vr+1;

					if(Vr==CalcStruct.wrow) {cout<<"Grid not big enough!"<<endl;wequiv=-99999;}
					else if(Vr==0){cout<<"Vr==0:  LTCI is worth than losing all financial wealth."<<endl;	wequiv=para.Minf;}
					else if( Digram.VstarNI[Vr]>=Digram.Vstar&& Digram.Vstar>=Digram.VstarNI[Vr-1])
					{
						wequiv=wdis[Vr-1]+((Digram.Vstar-Digram.VstarNI[Vr-1])/(Digram.VstarNI[Vr]-Digram.VstarNI[Vr-1]))*(wdis[Vr]-wdis[Vr-1]); 
						wequiv=wequiv/(1+para.r) - CalcStruct.W0;
					}else{
						cout<<"not correct"<<endl;
						wequiv=-999999;

					}


					Digram.wequiv=wequiv;
				
				
				}


					

					free(lcpbuffer);



	}




void Parallel_LTCI::simulate(int wealthpercentile){
		
		/************************************************************************/
		/* simulate to calculate both Mstar and Istarown  medicad 
		expenditure and insurance benefit										*/
		/************************************************************************/

		int i,j,t,iniW,k,ii;
		int wrow;
		int nsimul,deductgrid;
		int (*Astream)[TN][4][MAXGRID];


		double N,W0,A;  //total individual to simulate;
		double constraint;
		double Cbar2,Wbcar,Cbar;
		double r,wextra;
		double sum_Medicaid,sum_insurance,sum_medcost,sum_MUedicaid;
		double sum_testins,sum_testmed;
		double rfactor[TN];
		double (*LTCI)[5];
		double (*M)[5];
		double (*B)[5];
		double *wdis;


		typedef struct{
			int	   curWW[NSIMUL];
			int	   nextWW[NSIMUL];
			int    deductstate[NSIMUL];
			double MUedicaid[NSIMUL];
			double Medcost[NSIMUL];
			double Medicaid[NSIMUL];
			double insurance[NSIMUL];

		} SIMULATE;







		SIMULATE *s;
		void *sbuffer;



		sbuffer = malloc( sizeof(SIMULATE));
		if(sbuffer==NULL) {cout<<"LOCALSTRUCT allocation is failed"<<endl; system("pause"); exit(0);}
		s= (SIMULATE *) sbuffer;
		memset(s,0,sizeof(SIMULATE));


		rfactor[0]=1+para.r;
		for (i=1;i<TN;i++) rfactor[i]=rfactor[i-1]*(1+para.r);

		//initial wealth:
		



		r=para.r;
		Cbar=para.Cbar;
		Cbar2=para.Cbar2;
		Wbcar=para.Wbar;
		nsimul=NSIMUL;

		
		sum_insurance=0;sum_Medicaid=0;sum_medcost=0;sum_MUedicaid=0;sum_testins=0;sum_testmed=0;

		
		M=CalcStruct.M;
		B=CalcStruct.B;
		A=CalcStruct.A;
		
		LTCI=CalcStruct.LTCIown;

		


 for(ii=0;ii<2;ii++){
	 //ii =0 NI senario

	 gridsetup(ii,wealthpercentile);
	 wrow=CalcStruct.wrow;
	 W0=CalcStruct.W0;
	 wdis=CalcStruct.Wdis;
	 for (i=0;i<wrow;i++) if(wdis[i]>=W0){iniW=i;break;}
	 for(j=0;j<NSIMUL;j++) s->curWW[j]=iniW;

	 if(ii==0){
		 Astream=CalcStruct.AstreamN;
		 deductgrid=1;
	 
	 }
	 else{
		 deductgrid=DEDUCTGRID;
		 Astream=CalcStruct.Astream;
	 }
		 
		 


	 for(t=0;t<TN;t++){
		 for(i=0;i<NSIMUL;i++) 
			 if(healthstate[i][t]!=4){

				 s->Medcost[i]=s->Medcost[i]+(1/rfactor[t])*M[t][healthstate[i][t]];

				 //first part is insurance 

				 constraint=A+ii*LTCI[t][healthstate[i][t]]*(s->deductstate[i]+1>=deductgrid-1)+wdis[s->curWW[i]]-M[t][healthstate[i][t]];

				 if(para.Mcaid==1 &&  constraint < (Cbar2+Wbcar) && constraint-wdis[s->curWW[i]]/(1+r) < Cbar2 && healthstate[i][t]==1)
				 {

					 if (wdis[s->curWW[i]]/(1+r) > Wbcar) wextra = wdis[s->curWW[i]]/(1+r) -Wbcar;
					 else wextra=0;

					 s->nextWW[i]=Astream[s->deductstate[i]][t][healthstate[i][t]][s->curWW[i]];
					 //lcp->c[deduct][i]=wdis[i]/(1+r) -wdis[k]/(1+r)+Cbar2-wextra;

					 //medicaid may be sheilded by insurance
					 if(ii==0)
						 s->MUedicaid[i]=s->MUedicaid[i]+ (1 / rfactor[t])*(M[t][healthstate[i][t]]-wextra-(A+r*wdis[s->curWW[i]]/(1+r) -Cbar2));
					 else{
						 s->Medicaid[i]=s->Medicaid[i]+ (1 / rfactor[t])*(M[t][healthstate[i][t]]-wextra-(A+LTCI[t][healthstate[i][t]]*(s->deductstate[i]+1>=deductgrid-1)+r*wdis[s->curWW[i]]/(1+r) -Cbar2));
						 if(s->deductstate[i]+1>=deductgrid-1)s->insurance[i] =s->insurance[i] + (1/rfactor[t])*LTCI[t][healthstate[i][t]];
					 }


				 }else if(para.Mcaid==1 &&  constraint < (Cbar+Wbcar) &&  constraint-wdis[s->curWW[i]]/(1+r)< Cbar && healthstate[i][t] > 1 )
				 {

					 if (wdis[s->curWW[i]]/(1+r) > Wbcar) wextra=wdis[s->curWW[i]]/(1+r) -Wbcar;
					 else wextra=0;

					 s->nextWW[i]=Astream[s->deductstate[i]][t][healthstate[i][t]][s->curWW[i]];

					 if(ii==0)
						 s->MUedicaid[i]= s->MUedicaid[i] +(1/rfactor[t])*( M[t][healthstate[i][t]]-wextra-(A+r*wdis[s->curWW[i]]/(1+r) -Cbar));
					 else{
						 if(s->deductstate[i]+1>=deductgrid-1)s->insurance[i] =s->insurance[i]+ (1/rfactor[t])*LTCI[t][healthstate[i][t]];
						 s->Medicaid[i]= s->Medicaid[i] +(1/rfactor[t])*( M[t][healthstate[i][t]]-wextra-(A+LTCI[t][healthstate[i][t]]*(s->deductstate[i]+1>=deductgrid-1)+r*wdis[s->curWW[i]]/(1+r) -Cbar));

					 }


				 }
				 else { // not on medicaid  // LTCI pay for insurance


					
					 s->nextWW[i]=Astream[s->deductstate[i]][t][healthstate[i][t]][s->curWW[i]];
					 if (healthstate[i][t]>=1 && s->deductstate[i]+1>=deductgrid-1) s->insurance[i]=s->insurance[i] + (1/rfactor[t])*LTCI[t][healthstate[i][t]];

				 }

				 if (healthstate[i][t] >0 && healthstate[i][t] < 4 ) {if (s->deductstate[i]+1<deductgrid-1) s->deductstate[i]=s->deductstate[i]+1; }
				 s->curWW[i]=s->nextWW[i];


			 }

	 }//t



 }

		// average the result: Medicaid insurance 

		for(i=0;i<NSIMUL;i++){
			sum_insurance= s->insurance[i]+sum_insurance;
			sum_Medicaid=sum_Medicaid+ s->Medicaid[i];
			sum_MUedicaid=sum_MUedicaid+ s->MUedicaid[i];
			sum_medcost=sum_medcost+s->Medcost[i];
		}

		sum_insurance=sum_insurance/nsimul;
		sum_Medicaid=sum_Medicaid/nsimul;
		sum_MUedicaid=sum_MUedicaid/nsimul;
		sum_medcost=sum_medcost/nsimul;


		Digram.MMstar=sum_Medicaid;
		Digram.IIstar=sum_insurance;
		Digram.Medcost=sum_medcost;
		Digram.MUstar=sum_MUedicaid;
		free(sbuffer);

	}



void Parallel_LTCI::writeresult(int wealthpercentile ,int gender){
		int i,j;
		char filename[2][11]={"female.txt","male.txt"};
		double EPDVMedical;
		double MUstar,Mstar;
		double Istarown,Istarnone;
				
		
		char *wday[]={"星期天","星期一","星期二","星期三","星期四","星期五","星期六"};
		time_t timep;
		struct tm *p;
		time(&timep);
		p=localtime(&timep); /* 获取当前时间 */

		MUstar=Digram.MstarNI;Istarnone=Digram.IstarNI;
		Mstar=Digram.Mstar;Istarown=Digram.Istar;
		EPDVMedical=Digram.Medicalstar;


		ofstream out(filename[gender], ios::app);
		if (out.is_open())   
		{  
			

			out<<"*********************************************************************"<<endl;
			out<<(1900+p->tm_year)<<"年"<<(1+p->tm_mon)<<"月"<<p->tm_mday<<"日"<<p->tm_hour<<"："<<p->tm_min<<":"<<p->tm_sec<<endl;
			out<<"this is the wealthpercentile"<<wealthpercentile<<endl;
			out<<"deductile grid is :"<<deductgrid<<endl;
			out<<"the grid size is "<<CalcStruct.wrow<<endl;
			//out<<"consuming time :"<<(time_began-time_end)/60<<endl;
			out<<"Medicaid share of EPDV of total LTC Exp (No private ins)		column 1"<<endl; 
			out<<MUstar/EPDVMedical<<endl;	
			out<<"Medicaid share of EPDV of total LTC Exp (With private  ins)	column 2"<<endl;
			out<<Digram.Mstar/EPDVMedical<<"\t";
			out<<endl;
			out<<"simulate"<<endl;
			out<<Digram.MMstar/EPDVMedical<<endl;
			out<<"implicit tax                                                  column 3 "<<endl; 
			out<<(MUstar - Mstar)/Istarown<<"\t";
			out<<endl;
			out<<"simulate"<<endl;
			out<<(MUstar-Digram.MMstar)/Digram.IIstar<<endl;

			out<<"Net load														column 4"<<endl; 
			out<<(1-(Istarown-(MUstar-Mstar))/(Istarown/para.MW))<<"\t";
			out<<endl;


			out<<"simulate"<<endl;
			out<<(1-(Digram.IIstar-(MUstar-Digram.MMstar))/(Digram.IIstar/para.MW))<<endl;
			out<<"the wequiv is :"<<endl;
			out<<Digram.wequiv<<"\t";
			out<<endl;


			out<<"*********************************************************************"<<endl;

			out.close();  
		}  


	}

void Parallel_LTCI::outprint(){

	double EPDVMedical;
	double MUstar,Mstar;
	double Istarown,Istarnone;
	time_t	time_began;
	Mstar=Digram.Mstar;EPDVMedical=Digram.Medicalstar;Istarown=Digram.Istar;
	MUstar=Digram.MstarNI;Istarnone=Digram.IstarNI;
	
	time_end=time(NULL);

			cur_time();
            cout<<"*********************************************************************"<<endl;
			cout<<"this is the wealthpercentile"<<wealthpercentile<<endl;
			cout<<"the grid size is "<<CalcStruct.wrow<<endl;
			//cout<<"consuming time :"<<(time_began-time_end)/60<<endl;
			cout<<"Medicaid share of EPDV of total LTC Exp (No private ins)		column 1"<<endl; 
			cout<<MUstar/EPDVMedical<<endl;
			cout<<"simulate"<<endl;
			cout<<Digram.MUstar/Digram.Medcost<<endl;
			cout<<"Medicaid share of EPDV of total LTC Exp (With private ins)	column 2"<<endl;
			cout<<Mstar/EPDVMedical<<endl;
			cout<<"simulate"<<endl;
			cout<<Digram.MMstar/Digram.Medcost<<endl;
			cout<<"implicit tax													column 3 "<<endl; 
			cout<<(MUstar - Mstar)/Istarown<<endl;
			cout<<"simulate"<<endl;
			cout<<(Digram.MUstar-Digram.MMstar)/Digram.IIstar<<endl;
			cout<<"Net load														column 4"<<endl; 
			cout<<(1-(Istarown-(MUstar-Mstar))/(Istarown/para.MW))<<endl;
			cout<<"simulate"<<endl;
			cout<<(1-(Digram.IIstar-(Digram.MUstar-Digram.MMstar))/(Digram.IIstar/para.MW))<<endl;

			cout<<"the wequiv is :"<<endl;

			cout<<Digram.wequiv<<endl;

			cout<<"*********************************************************************"<<endl;





}


void Parallel_LTCI:: fn_util(double *Cons,double *zeroind,double* OUTutil,double crra,double Consplus,double phi){
	int wrow;
	int i,j,k;

	wrow =CalcStruct.wrow; 

	if(crra>1) for(i=0;i<wrow;i++) OUTutil[i]=phi*(pow(Cons[i]+Consplus,(1-crra))-1)/(1-crra)*(1-zeroind[i])-zeroind[i]*99999;
	else if(crra==1) for(i=0;i<wrow;i++)OUTutil[i]=phi*(log(Cons[i]+Consplus)-1)*(1-zeroind[i])-zeroind[i]*99999;
	else if(crra==0) for(i=0;i<wrow;i++)OUTutil[i]=phi*(Cons[i]+Consplus)*(1-zeroind[i])-zeroind[i]*99999;

	//for(i=0;i<wrow;i++) if(Cons[i]<=) OUTutil[i]=0; 

}

void Parallel_LTCI::comput(){
	calcPrep(gender,wealthpercentile,1);
	calcModel(wealthpercentile,false);
	calcPrep(gender,wealthpercentile,0);
	calcModel(wealthpercentile,true);
	//simulate(wealthpercentile);
	writeresult(wealthpercentile,gender);
	outprint();

}

void Parallel_LTCI::cur_time()
{
	char *wday[]={"星期天","星期一","星期二","星期三","星期四","星期五","星期六"};
	time_t timep;
	struct tm *p;
	time(&timep);
	p=localtime(&timep); /* 获取当前时间 */
	printf("-------%d 年 %02d 月 %02d 日",(1900+p->tm_year),(1+p->tm_mon),p->tm_mday);
	printf("%s %02d : %02d : %02d ---------\n",wday[p->tm_wday],p->tm_hour,p->tm_min,p->tm_sec);
}