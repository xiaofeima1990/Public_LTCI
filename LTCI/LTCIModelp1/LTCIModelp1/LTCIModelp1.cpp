#include "LTCIModelp1.h"


#define TN 480
#define MAXGRID 2013



/************************************************************************/
/* project description for Long Term Care Insurance  (LTCI)             */
/************************************************************************/

/*
This project focus on the impact of revised long term care insurance on the older people.  
Since the elderly are badly in need  of long-term care . But HRS show that only 10% purchase long-term care insurance,
in that the government medicaid policy account for such phenmoenona. This lead  to high fiscal expenditure and low welfare for middle class people.
In order to improve such situation, we propose a deferred long term care insurance, which we add longer elimination periods or larger out-of-pocket deductibles, 
to investigate :
1) whether those who optimally choose not to purchase regular long-term care insurance are induced to purchase deferred long-term care insurance;
2) whether individuals who would have purchased regular policies will switch to policies with longer elimination periods or larger deductibles. 


the main content:
The project will consider consumer demand for the following various types of deferred long-term care insurance policies: 
1)  An elimination period of three months. 
2)  An elimination period of six months. 
3)  An elimination period of 12 months. 
4)  An elimination period of 18 months. 
5)  A deductible of $25,000. 
6)  A deductible of $50,000. 
7)  A deductible of $100,000. 


*/

/************************************************************************/
/* Methology  for dynamic programming                                   */
/************************************************************************/
/*
1)attempt to use dynamic multi-indexes to define the grid size
2)backward induction
*/


/*definition of structure*/

/*先用最笨的方法实现 */




typedef struct{
	
	double crra;

	double bencap;		// =1 if benefit cap applies; =0 uncapped 

	double beta; //Fraction of HC expenses that enter into utility function as consumption

	double qual_hc;      //   @ Medicaid quality for state 2: Typically equal to 1 unless there is stigma effect @;
	double qual_alf;      //   @ Medicaid quality for state 3 @;
	double qual_nh;      //   @ Medicaid quality for state 4 @;


	//Next parameters =1 unless state dependent utility is desired
	int phi_hc;  //coefficient on utility of consumption on homecare
	int phi_alf; //coefficient on utility of consumption on alf
	int phi_nh;  //coefficient on utility of consumption on nh

	int beq;         //coefficient on utility of bequests this program donot consider this
	int fo;			 //if fo=1, policy is facility only, meaning it covers only states 3 and 4.


	//parameter for wealth discretization
	double alpha;    //alpha is the fraction of total wealth annuitized 
	double wealth;   //wx is used purely to adjust upper bound of grid for discretization
	double wx;       //if LTCI value gets high (e.g., higher risk aversion), adjust wx up
	int    grid;     //grid = grid size used for discretization.
	int    wrow;     //total grid size row

	double W0;       //starting wealth pure asset;

	static const int age=65;
	static const int maxage=105;
	int tn;


	//the following  is the mcaid project parameter
	double Food;    //Food = SSI level used to parameterize food/housing benefit
	int Mcaid;   //=1 if there is a Medicaid program

	double    Wbar;	      // @ wealth excluded from Medicaid spend-down (base case is 2000/X)	@ 
	double 	Cbar;		  // @ min consumption provided if on Medicaid	@
	double	Cbar2;        // @ CBAR WHILE IN HOME CARE @;

	double	medicare;        // % @ Fraction of Home care costs covered by Medicare @
	
	//market load        //Alternative scenarios for market loads of private LTCI prices
	int MWcount;
	double  MW;


	//benefit 
	double Binf;               // % @ rate of nominal growth of benefits under LTCI policy  @;
	double Bben;               // % @ Monthly benefit from LTCI policy

	double Minf;

	//medical cost
	double      NHamt;      	       // % @ Monthly cost of NH  $51480  @
	double	  ALFamt;              //% @ Monthly cost of ALF $25908 per year  @

	double	  HCnonrn;               // @ Hourly HC costs (non RN) @
	double	  HCrn;                  // @ Hourly HC costs (RN)  @

	double	  r;			            // @ real interest rate				        @
	double	  rho;		            // @ discount rate for utility of consumption	@
	double	  d;			            // @ discount rate for utility of bequests		@
	double	  inf;		            // @ price inflation rate	                    @
	double	  rminf;		            // @ real medical cost growth (over inflation)	@

	//premium
	double premium;


	//eps precise
	double eps;




}PARA;


typedef struct{
	int naclim;
	int nsclim;
	int t;

	//load matrix
	double **qti;  //matrix of transition probabilities  rows=ages 65 to 111 

	//double **qfi;  //col 1 is age.  col 2 through 26 are  transition probs from state i to j
	double hcexp[TN]; // home care expense column 1 expenses

	double HC0[TN];    //HCutil is the amount of non-skilled NH care received, regardless of payer
	double Prob[492][5]; //unconditional tranzation probability


	double M[TN][5];   //M = medical expenditure matrix
	double B[TN][5];   //B = Benefit matrix 
	double P[TN][5];   //P = Premium matrix
	double A;   //A = annuity amount income 
					   //Rows are periods, cols are states
	double LTCIown[TN][5]; //the net payment to the policy holder.
	double LTCInone[TN][5];//individual does not own insurance	

}CALCSTRUCT;


typedef struct{
	double Vstar;
	double Medicalstar;
	double Mstar;


	
	double Istar;

	double pointM[10];
	double pointF[10];



}DIGRAM;


/*definition of functions */
void fn_util(double *Cons,double* OUTutil,double crra,double Consplus);  // the input parameter will change into double wealthpercentil,double gender, double gamma
void calcSetup();
void calcPrep(int wealthpercentil,int gender);
double calcModel(int protype, int flagLTCI);
//void putResult();
void inputData(int gender);
void willtopay(int gender);
void writeresult(double *wequiv ,int gender);
void gridsetup(int flag);

PARA		para;
CALCSTRUCT *CalcStruct;
DIGRAM     *Digram;

double wdis[MAXGRID];
double q[TN+12][25];


void main(){
	int gender;
	int wealthpercentil;
	int i,j;
	int testIndex,testIndex2;
	void *Calcbuffer;
	void *Digbuffer;


	//gender=1;				//0 is female 1 is male

	//wealthpercentil=7;		//0-9 different wealth distribution 

	// initialize the Calc struct
	Calcbuffer = malloc( 1 *sizeof(CALCSTRUCT));
	if(Calcbuffer==NULL) {cout<<"Calcbuffer allocation is failed"<<endl; system("pause"); exit(0);}
	CalcStruct= (CALCSTRUCT *) Calcbuffer;
	memset(CalcStruct,0,sizeof(CALCSTRUCT));

	//initialize the dig  struct
	Digbuffer = malloc( 1 *sizeof(DIGRAM));
	if(Digbuffer==NULL) {cout<<"Digbuffer allocation is failed"<<endl; system("pause"); exit(0);}
	Digram= (DIGRAM *) Digbuffer;
	memset(Digram,0,sizeof(DIGRAM));



	calcSetup();


	for(gender=0;gender<2;gender++)
	{
		cout<<endl;
		cout<<endl;
		cout<<"this is the gender:"<<gender<<endl;
		cout<<"-------------------------------------"<<endl;
		inputData(gender);
		willtopay(gender);

	}

//  	gender=0;
//  	inputData(gender);
//  	willtopay(gender);

	
	
// 	calcPrep(wealthpercentil,gender);
// 
// 	calcModel(1,1);
	//willtopay();
	//putResult();


	//finially delete dynamic index
	//delete [] wdis;


	free(Digbuffer);
	free(Calcbuffer);
	system("pause");




}


void calcSetup(){

	int WW,wrow;
	int i,j,k;


	double griddense;
	double X;
	
	X=1000;
	griddense=1/1;
	
	para.bencap=1;

	para.beta=0;
	
	para.eps=1e-15;

	//definition on utility and coefficient 

	para.Mcaid=1;
	//Medicaid quality
	para.qual_hc=1;
	para.qual_alf=1;
	para.qual_nh=1;
	//coefficient on utility of consumption
	para.phi_hc=1;
	para.phi_alf=1;
	para.phi_nh=1;

	para.beq=0; //coefficient on utility of bequests

	para.fo=0;  //if fo=1, policy is facility only, meaning it covers only states 3 and 4
				//if fo=0, policy covers HC (state 2) alsos


	


	para.tn=TN;

	para.crra=3;

	para.Food=515/X;      //Food = SSI level used to parameterize food/housing benefit
	
	para.Wbar=2;	      // @ wealth excluded from Medicaid spend-down (base case is 2000/X)	@ 
	para.Cbar=0.03;		  // @ min consumption provided if on Medicaid	@
	para.Cbar2=0.545;        // @ CBAR WHILE IN HOME CARE @;

	para.medicare=0.35;        // % @ Fraction of Home care costs covered by Medicare @



	//medical cost
	para.NHamt=4.29;      	       // % @ Monthly cost of NH  $51480  @
	para.ALFamt=2.159;              //% @ Monthly cost of ALF $25908 per year  @

	para.HCnonrn=0.018;               // @ Hourly HC costs (non RN) @
	para.HCrn=0.037;                  // @ Hourly HC costs (RN)  @


	

	para.Binf=0;
	para.Bben=3000/X;



	para.r=.03;			            // @ real interest rate				        @
	para.rho=.03;		            // @ discount rate for utility of consumption	@
	para.d=.03;			            // @ discount rate for utility of bequests		@
	para.inf=.03;		            // @ price inflation rate	                    @
	para.rminf=.015;		        // @ real medical cost growth (over inflation)	@

	//end of initialize parameter 

	//reconstruct parameter
	para.premium=150/X;

	para.Minf=para.inf+para.rminf;

	para.r=pow((1+para.r),(1.0/12))-1; 
	para.d=pow((1+para.d),(1.0/12))-1;
	para.rho=pow((1+para.rho),(1.0/12))-1;
	para.inf=pow((1+para.inf),(1.0/12))-1;
	para.Minf=pow((1+para.Minf),(1.0/12))-1;
	para.Binf=pow((1+para.Binf),(1.0/12))-1;


}


void inputData(int gender){

	int i,j;
	int fileno;
	int age;
	double hcexprob;
	char hcexprobc[20];

	char filename[60];
	char stringline[400];


	double qti[47][25];
	
	double hcexp0[77];
	double hcexp1[77];


	double hcexp[77];

	
	double (*Prob)[5];  //unconditional probability


	Prob=CalcStruct->Prob;

	// qfi qmi hcexp1mi65 hcexp1fi65 hcexp0mi65 hcexp0fi65
	
	memset(hcexp0,0,sizeof(double[77]));
	memset(hcexp1,0,sizeof(double[77]));
	memset(hcexp,0,sizeof(double[77]));
	memset(stringline,0,sizeof(char(400)));

	memset(qti,0,sizeof(double[47][25]));
	//memset(qmi0,0,sizeof(double[47][25]));

	//CalcStruct->hcexp= new double * [para.tn];

	char infilenamef[3][16] = {"qfi.txt", "hcexp0fi65.txt", "hcexp1fi65.txt" };
	char infilenamem[3][16] = {"qmi.txt", "hcexp0mi65.txt", "hcexp1mi65.txt" };


	FILE *infile,*infile2;
	int inhandle;
	

	for (fileno=1;fileno<3;fileno++)
	{	
		if(gender==0) strcpy(filename, infilenamef[fileno]);
		else		  strcpy(filename, infilenamem[fileno]);
// 		out.open(filename,ios::in);
// 		if(!out) {cout<<" File not found in "<<filename<<endl; system("pause");}
		infile = fopen(filename, "r");
		if(infile == NULL) {cout<<" File not found in "<<filename[fileno]<<endl; system("pause");}


		for(age=65;age<112;age++)
		{
			//out.getline(stringline,150,'\n');
			fgets(stringline, 150, infile);
			sscanf(&stringline[0], "%16c", &hcexprobc);
			hcexprob=(double)atof(hcexprobc);
			switch (fileno) {
			case 1: hcexp0[age-35]=hcexprob;break;
			//case 2: hcexp0m[age-35]=(double)hcexprob;break;
			case 2: hcexp1[age-35]=hcexprob;break;
			//case 5: hcexp1m[age-35]=(double)hcexprob;break;


			} 				

		}
		fclose(infile);

	}
	memset(stringline,0,sizeof(char(400)));


// 	cout<<"test for hcexp0f"<<endl;
// 	cout<<"gender :"<<gender<<endl;
// 	for (i=0;i<77;i++) cout<<i<<"\t"<<hcexp0[i]<<endl;

	fileno=0;
	{
		if(gender==0) strcpy(filename, infilenamef[fileno]);
		else		  strcpy(filename, infilenamem[fileno]);

		infile2 = fopen(filename, "r");
		if(infile2 == NULL) {cout<<" File not found in "<<filename[fileno]<<endl; system("pause");}

		for(age=65;age<112;age++)
		{
			fgets(stringline, 400, infile);
			for(i=0;i<25;i++)
			{
				sscanf(&stringline[i*15], "%13c", &hcexprobc);
				hcexprob=(double)atof(hcexprobc);
				qti[age-65][i]=(double)hcexprob;

			}
			
		

		}


		fclose(infile2);
	}

	/************************************************************************/
	/* the above finish the data input                                      */
	/************************************************************************/

	/*next i need to deal with the change of different probability

	*/

	//first is hcexp
	for(i=0;i<77;i++)
	{
			hcexp0[i]=hcexp0[i]*4.33333*para.HCnonrn;
			hcexp1[i]=hcexp1[i]*4.33333*para.HCrn;

// 			hcexp0m[i]=hcexp0m[i]*4.33333*para.HCnonrn;
// 			hcexp1m[i]=hcexp1m[i]*4.33333*para.HCrn;

			hcexp[i]=(1-para.medicare)*(hcexp0[i]+hcexp1[i]);
			//hcexpm[i]=(1-para.medicare)*(hcexp0m[i]+hcexp1m[i]);

			}


	for(j=0;j<40;j++)
	{
		for (i=0;i<12;i++){
			CalcStruct->hcexp[i+j*12]=hcexp[j+30];
			//CalcStruct->hcexpm[i+j*12]=hcexpm[j];
			CalcStruct->HC0  [i+j*12]=hcexp0[j+30]+hcexp1[j+30];
			//CalcStruct->HC0m  [i+j*12]=hcexp0m[j]+hcexp1m[j];
		}
		
	}


	//CREATE MONTHLY TRANSITION MATRIX
	// calarify the dynamic indexes of qm qf


// 	qm =new double *[para.tn+12];
// 	for(i=0;i<para.tn+12;i++) qm[i]=new double [25];





	for(j=0;j<40;j++)
	{
		for (i=0;i<12;i++){
			memcpy(q[i+j*12],qti[j],sizeof(double[25]));

		}
	}

	//Turn conditional probabilities into unconditional probability
	
	Prob[0][0]=1;

	for(i=1;i<para.tn+12+1;i++)
	{
		Prob[i][0]=q[i-1][0]*Prob[i-1][0]+q[i-1][5]*Prob[i-1][1]+q[i-1][10]*Prob[i-1][2]+q[i-1][15]*Prob[i-1][3];
		Prob[i][1]=q[i-1][1]*Prob[i-1][0]+q[i-1][6]*Prob[i-1][1]+q[i-1][11]*Prob[i-1][2]+q[i-1][16]*Prob[i-1][3];
		Prob[i][2]=q[i-1][2]*Prob[i-1][0]+q[i-1][7]*Prob[i-1][1]+q[i-1][12]*Prob[i-1][2]+q[i-1][17]*Prob[i-1][3];
		Prob[i][3]=q[i-1][3]*Prob[i-1][0]+q[i-1][8]*Prob[i-1][1]+q[i-1][13]*Prob[i-1][2]+q[i-1][18]*Prob[i-1][3];
		Prob[i][4]=q[i-1][4]*Prob[i-1][0]+q[i-1][9]*Prob[i-1][1]+q[i-1][14]*Prob[i-1][2]+q[i-1][19]*Prob[i-1][3]+ Prob[i-1][4];
	}


	//CalcStruct->qti = q;







}

void fn_util(double *Cons,double* OUTutil,double crra,double Consplus){
	int wrow;
	int i,j,k;

	wrow =para.wrow; 

	if(crra>1) for(i=0;i<wrow;i++) OUTutil[i]=(pow(Cons[i]+Consplus,(1-crra))-1)/(1-crra);
	else if(crra==1) for(i=0;i<wrow;i++)OUTutil[i]=log(Cons[i]+Consplus)-1;
	else if(crra==0) for(i=0;i<wrow;i++)OUTutil[i]=Cons[i]+Consplus;

	//for(i=0;i<wrow;i++) if(Cons[i]<=) OUTutil[i]=0; 

}



void calcPrep(int wealthpercentil,int gender)
{
	int i ,j, k;

	double bfactor[TN];
	double mfactor[TN];
	double ifactor[TN];
	double rfactor[TN];
	double cost[TN][5];
	double ben[TN][5];
	double scost,sben;
	double AFP, actfprem;
	double Atemp;
	double griddense;
	double X;
	int WW;
	int wrow;

	//calcate M B and find min(M,B)
	//都已经初始化过了



	/*wealth percentil and wealth grid initialization */

	X=1000;

	switch (wealthpercentil){
	case 0: para.wealth=40000;	para.alpha=0.98;	para.wx=0;		para.grid=20;	break;
	case 1: para.wealth=58450;	para.alpha=0.98;	para.wx=0;		para.grid=20;	break;
	case 2: para.wealth=93415;	para.alpha=0.91;	para.wx=20000;	para.grid=40;	break;
	case 3: para.wealth=126875;	para.alpha=0.82;	para.wx=30000;	para.grid=75;	break;
	case 4: para.wealth=169905;	para.alpha=0.70;	para.wx=10000;	para.grid=100;	break;
	case 5: para.wealth=222570;	para.alpha=0.60;	para.wx=50000;	para.grid=130;	break;
	case 6: para.wealth=292780;	para.alpha=0.52;	para.wx=20000;	para.grid=175;	break;
	case 7: para.wealth=385460;	para.alpha=0.41;	para.wx=40000;	para.grid=225;	break;
	case 8: para.wealth=525955;	para.alpha=0.35;	para.wx=40000;	para.grid=300;	break;
	case 9: para.wealth=789475;	para.alpha=0.26;	para.wx=75000;	para.grid=450;	break;


	}

	
	para.W0=para.wealth*(1-para.alpha)/X;   


	/* choose market load */
	para.MWcount=0;
	if(para.MWcount==0){if (gender==0) para.MW=1.058; else para.MW=0.5;}
	else if(para.MWcount==1){if (gender==0) para.MW=0.6; else para.MW=0.3;}
	else if(para.MWcount==2){if (gender==0) para.MW=1.358127; else para.MW=0.6418727;}
	else if(para.MWcount==3){if (gender==0) para.MW=1.358127; else para.MW=0.6418727;}






	memset(CalcStruct->M[0],0,sizeof(double[5]));

	for(i=0;i<TN;i++)
	{
		CalcStruct->M[i][1] = CalcStruct->hcexp[i];
		CalcStruct->M[i][2] = para.ALFamt;
		CalcStruct->M[i][3] = para.NHamt;

		switch (para.fo)
		{
			case 0: 
				{	
					for (j=1;j<4;j++) CalcStruct->B[i][j] = para.Bben; 
					CalcStruct->P[i][0] = para.premium; 
					break;
					
				} 
			case 1:
				{
					for (j=2;j<4;j++) CalcStruct->B[i][j] = para.Bben; 
					CalcStruct->P[i][0] = para.premium; 
					CalcStruct->P[i][1] = para.premium; 
					break;

				}

		} 
	
		
	}
			

	// Incorporate nominal growth rates 
	bfactor[0]=1+para.Binf; mfactor[0]=1+para.Minf;
	for (i=1;i<TN;i++) bfactor[i]=bfactor[i-1]*(1+para.Binf);
	for (i=1;i<TN;i++) mfactor[i]=mfactor[i-1]*(1+para.Minf);
	for (i=0;i<TN;i++) for (j=0;j<5;j++) CalcStruct->B[i][j]=CalcStruct->B[i][j]*bfactor[i];
	for (i=0;i<TN;i++) for (j=0;j<5;j++) CalcStruct->M[i][j]=CalcStruct->M[i][j]*mfactor[i];
	for (i=0;i<TN;i++) CalcStruct->HC0[i]=CalcStruct->HC0[i]*mfactor[i];
	
	// Now take the min of benefit level and actual cost 
	// compute MIN(B,M)
	if(para.bencap ==1 ) 
	for(i=0;i<TN;i++)for(j=0;j<5;j++)CalcStruct->B[i][j]=min(CalcStruct->B[i][j],CalcStruct->M[i][j]);

	else
	memcpy(CalcStruct->B,CalcStruct->M,sizeof(double [TN][5]));


	//Now convert from nominal to real
	ifactor[0]=1+para.inf; rfactor[0]=1+para.r; 
	for (i=1;i<TN;i++) ifactor[i]=ifactor[i-1]*(1+para.inf);
	for (i=0;i<TN;i++) for (j=0;j<5;j++) CalcStruct->P[i][j]=CalcStruct->P[i][j]/ifactor[i];
	for (i=0;i<TN;i++) for (j=0;j<5;j++) CalcStruct->B[i][j]=CalcStruct->B[i][j]/ifactor[i];
	for (i=0;i<TN;i++) for (j=0;j<5;j++) CalcStruct->M[i][j]=CalcStruct->M[i][j]/ifactor[i];
	for (i=0;i<TN;i++)					 CalcStruct->HC0[i] =CalcStruct->HC0[i] /ifactor[i];

	for (i=1;i<TN;i++) rfactor[i]=rfactor[i-1]*(1+para.r);

	//calculate actuarially fair premium

	for(i=0;i<TN;i++)for(j=0;j<5;j++)cost[i][j]=CalcStruct->P[i][j] * CalcStruct->Prob[i+1][j] / rfactor[i];
	for(i=0;i<TN;i++)for(j=0;j<5;j++)ben [i][j]=CalcStruct->B[i][j] * CalcStruct->Prob[i+1][j] / rfactor[i];

	scost=0; sben=0;
	for(i=0;i<TN;i++) scost=scost+cost[i][0];
	for(i=0;i<TN;i++) for(j=0;j<5;j++) sben=sben+ben[i][j];

	AFP = ( sben / scost)*para.premium;
	actfprem=AFP;

	for(i=0;i<TN;i++) for(j=0;j<5;j++) CalcStruct->P[i][j]=(CalcStruct->P[i][j] / para.premium) *(AFP / para.MW);


	//calculate monthly annuity amount A
	Atemp=0;
	for(i=0;i<TN;i++) Atemp=Atemp+ (1-CalcStruct->Prob[i+1][4]) / rfactor[i];

	CalcStruct->A = (para.alpha/(1-para.alpha)) *para.W0 / Atemp;

	/* Create LTCIown, a matrix that is tn rows x 5 states that is the net payment    */
	/* to the policy holder.  Will be equal to -P when healthy, equal to benefit when */
	/* receiving benefit and premium is waived, and equal to B-P when receiving 	  */
	/* benefit but policy is not waived.						                      */
	/* LTCInone is a matrix of zeros of same size as LTCIown to be used when the 	  */                                         
	/* individual does not own insurance						                      */

	for(i=0;i<TN;i++) for(j=0;j<5;j++) CalcStruct->LTCIown[i][j] = CalcStruct->B[i][j]- CalcStruct->P[i][j];

	
	}


void gridsetup(int flag){
	double X,griddense;
	int WW,i;


	X=1000;
	griddense=1/1;

	para.W0=para.wealth*(1-para.alpha);                   // % @ This section simply creates discretized grid @;

	if (flag==1)
		WW=(int)((para.W0*1.2-10000)/para.grid)+1; 
	else
		WW=(int)((para.W0*1.2+para.wx-10000)/para.grid)+1;

	if (WW*para.grid<10000)
	{
		wdis[0]=0;
		for (i=1;i<101;i++)		wdis[i]=wdis[i-1]+10*griddense/X;
		for(i=101;i<151;i++)	wdis[i]=wdis[i-1]+20*griddense/X;
		for(i=151;i<310;i++)	wdis[i]=wdis[i-1]+50*griddense/X;
		para.wrow=310;
	}else{
		wdis[0]=0;
		for (i=1;i<101;i++)		wdis[i]=wdis[i-1]+10*griddense/X;
		for(i=101;i<151;i++)	wdis[i]=wdis[i-1]+20*griddense/X;
		for(i=151;i<311;i++)	wdis[i]=wdis[i-1]+50*griddense/X;
		for(i=311;i<310+WW;i++)	wdis[i]=wdis[i-1]+para.grid*griddense/X;
		para.wrow=310+WW;

	}


	para.W0=para.W0/X;



}



double calcModel(int protype, int flagLTCI ){
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
	

	int t,j,i,k,l;
	int wrow,tn;
	int stateFlag;  //0: no medicaid 1: j=1 hc 2: alf 3:nh 
	int wcrit,tempIndex;
	int Vr;

	double Cbar,Wbcar,Cbar2,r;
	double phi;
	double tempVMax;
	double consplus;
	double wextra,wstart;
	double wequiv;


	double A;
	double Medicalstar;
	
	double Medical[TN][5];
	

	double (*LTCI)[5];
	double (*M)[5];
	double (*B)[5];
	double (*Prob)[5];
	double *hcexp;
	double *HC0;

	/*define a inserted structure*/

	typedef struct{
		double c[MAXGRID];
		double zeroind[MAXGRID];
		double OUTutil[MAXGRID];
		double insurance[4][MAXGRID];
		double insurance2[4][MAXGRID];
		double Medicaid[4][MAXGRID];
		double Medicaid2[4][MAXGRID];
		double Astream[TN][4][MAXGRID];
		double Cstream[TN][4][MAXGRID];
		double VV[4][MAXGRID];
		double Vmax[4][MAXGRID];
		double V[4][MAXGRID];
		double Vstar[MAXGRID];
		double Mstar[MAXGRID];
		double Istar[MAXGRID];

	}LOCALSTRUCT;

	LOCALSTRUCT *lcp;
	void *lcpbuffer;

// 	double c;
// 	double *zeroind,*OUTutil;
// 	double **insurance,**insurance2;
// 	double **Medicaid,**Medicaid2;
// 	double ***Astream;
// 	double ***Cstream;
// 	double **VV;
// 	double **Vmax;
// 	double **V,*Vstar;
// 	double *Mstar,*Istar;
	



	double constraint;


	if(flagLTCI==1) LTCI=CalcStruct->LTCIown;
	else		   LTCI=CalcStruct->LTCInone;

	
	r=para.r;
	Cbar=para.Cbar;
	Cbar2=para.Cbar2;
	Wbcar=para.Wbar;


	M=CalcStruct->M;
	B=CalcStruct->B;
	Prob=CalcStruct->Prob;
	hcexp=CalcStruct->hcexp;
	HC0=CalcStruct->HC0;

	A=CalcStruct->A;
	wrow=para.wrow;
	tn=TN;
	stateFlag=0;

	
	lcpbuffer = malloc( sizeof(LOCALSTRUCT));
	if(lcpbuffer==NULL) {cout<<"LOCALSTRUCT allocation is failed"<<endl; system("pause"); exit(0);}
	lcp= (LOCALSTRUCT *) lcpbuffer;
	memset(lcp,0,sizeof(LOCALSTRUCT));




	


	memset(Medical,0,sizeof(double[TN][5]));
	//check medicalstar
	memcpy(Medical[TN-1],CalcStruct->M[TN-1],sizeof(double[5]));

	for(t=TN-2;t>=0;t--) for(j=0;j<5;j++)
		Medical[t][j]=M[t][j]+(1/(1+para.r))*(q[t+1][j*5]*Medical[t+1][0] +q[t+1][j*5+1]*Medical[t+1][1] + q[t+1][j*5+2]*Medical[t+1][2] + q[t+1][j*5+3]*Medical[t+1][3]+ q[t+1][j*5+4]*Medical[t+1][4]);

	Medicalstar= (1/(1+para.r))*(q[0][0]*Medical[0][0] + q[0][1]*Medical[0][1] + q[0][2]*Medical[0][2] + q[0][3]*Medical[0][3]+ q[0][4]*Medical[0][4]);

	Digram->Medicalstar=Medicalstar;



	 /* Determines value function for period T */

	t=tn-1;
	memset(lcp->Medicaid,0,sizeof(double [4][MAXGRID]));
	memset(lcp->insurance,0,sizeof(double [4][MAXGRID]));

	for(j=0;j<4;j++)
	{
		for(i=0;i<wrow;i++)
		{
			//memset(VV,0,sizeof(double [row][4]));

			/* Medicaid is defined so that (a) if Medicaid exists, and 
         (b) starting wealth for period falls below Wbar (asset test) and 
         (c) income plus LCTI income is less than sum of medical expenses and minimum 
         consumption level Cbar, then person permitted to consume max of Cbar. */;

        /* Income test includes annuity, difference between insurance and expenses, +interest income) 
        % Since wdis already includes the interest, the asset test must subtract interest back off.  
        % The subtraction in the asset test and addition in the income test cancel in the combined constraint. */
			//constraint=A+LTCI[t][j]+wdis[i]-M[t][j];

			if(para.Mcaid==1 &&  A+LTCI[t][j]+wdis[i]-M[t][j] < (Cbar2+Wbcar) && A+LTCI[t][j]+r*wdis[i]/(1+r)-M[t][j] < Cbar2 && j==1)
			{
				
				if (wdis[i]/(1+r) > Wbcar) wextra = wdis[i]/(1+r) -Wbcar;
				else wextra=0;
				for(k=0;k<wrow;k++)
				{
					
					lcp->c[k]=wdis[i]/(1+r) -wdis[k]/(1+r)+Cbar2-wextra;
					if(lcp->c[k]>0)lcp->zeroind[k]=0;else {lcp->c[k]=0.0001;lcp->zeroind[k]=1;}
				}

				lcp->Medicaid[j][i]= M[t][j]-wextra-(A+LTCI[t][j]+r*wdis[i]/(1+r) -Cbar2);
				lcp->insurance[j][i] = LTCI[t][j];

			}else if(para.Mcaid==1 &&  A+LTCI[t][j]+wdis[i]-M[t][j] < (Cbar+Wbcar) && A+LTCI[t][j]+r*wdis[i]/(1+r)-M[t][j] < Cbar && j>1 )
			{
				
				if (wdis[i]/(1+r) > Wbcar) wextra=wdis[i]/(1+r) -Wbcar;
				else wextra=0;

				lcp->Medicaid[j][i]= M[t][j]-wextra-(A+LTCI[t][j]+r*wdis[i]/(1+r) -Cbar);
				lcp->insurance[j][i] = LTCI[t][j];
				
				for(k=0;k<wrow;k++)
				{
					
					lcp->c[k]=wdis[i]/(1+r) -wdis[k]/(1+r)+Cbar-wextra;
					if(lcp->c[k]>0) lcp->zeroind[k]=0;else{lcp->c[k]=0.0001;lcp->zeroind[k]=1;}
				}

				
			}else { // not on medicaid
				for(k=0;k<wrow;k++)
				{
					lcp->c[k]=wdis[i]-wdis[k]/(1+r) +A +LTCI[t][j]-M[t][j];
					if(lcp->c[k]>0 && wdis[i]+A-M[t][j]+LTCI[t][j] -lcp->c[k]>=0)lcp->zeroind[k]=0;else{lcp->c[k]=0.0001;lcp->zeroind[k]=1;}
				}

				lcp->Medicaid[j][i]=0;
				if (j>=1) lcp->insurance[j][i]=LTCI[t][j];

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
		case 0: { consplus=0; fn_util(lcp->c,lcp->OUTutil,para.crra,consplus); phi=para.phi_hc; break;}
		case 1: {  consplus=0; fn_util(lcp->c,lcp->OUTutil,para.crra,consplus);phi=para.phi_alf; break;}
			//if(stateFlag==1){ consplus=para.qual_alf*para.beta*HC0[t]; fn_util(c,OUTutil,para.crra,consplus); for(i=0;i<wrow;i++) VV[i][j]=para.phi_alf*OUTutil[i] +zeroind[i]*(-9999) ;}
			//	else {consplus=para.beta*HC0[t];  fn_util(c,OUTutil,para.crra,consplus); for(i=0;i<wrow;i++) VV[i][j]=para.phi_alf*OUTutil[i] +zeroind[i]*(-9999); }}
		case 2: { consplus=para.Food; fn_util(lcp->c,lcp->OUTutil,para.crra,consplus);phi=para.phi_nh;break; }

			//if(stateFlag==1){ consplus=para.qual_alf*para.beta*HC0[t]; fn_util(c,OUTutil,para.crra,consplus); for(i=0;i<wrow;i++) VV[i][j]=para.phi_alf*OUTutil[i] +zeroind[i]*(-9999) ;}
			//	else {consplus=para.beta*HC0[t];  fn_util(c,OUTutil,para.crra,consplus); for(i=0;i<wrow;i++) VV[i][j]=para.phi_alf*OUTutil[i] +zeroind[i]*(-9999); }}
		case 3: { consplus=para.Food; fn_util(lcp->c,lcp->OUTutil,para.crra,consplus);phi=para.phi_nh; break;}

		}


		for(l=0;l<wrow;l++) lcp->VV[j][l]=phi*lcp->OUTutil[l]*(1-lcp->zeroind[l]) +lcp->zeroind[l]*(-99999) ;


		//find the maximized VV Vmax Astream Cstream
		tempVMax=lcp->VV[j][0];
		tempIndex=0;
		for(k=0;k<wrow;k++){		
			if(lcp->VV[j][k]>tempVMax)
			{
				tempVMax=lcp->VV[j][k];
				tempIndex=k;
			}
		}


		lcp->Cstream[t][j][i]=lcp->c[tempIndex];
		lcp->Astream[t][j][i]=tempIndex;
		lcp->Vmax[j][i]=tempVMax;




		}//j

	}//i

	
		memcpy(lcp->V,lcp->Vmax,sizeof(double[4][MAXGRID]));
		memcpy(lcp->Medicaid2,lcp->Medicaid,sizeof(double [4][MAXGRID]));
		memcpy(lcp->insurance2,lcp->insurance,sizeof(double [4][MAXGRID]));


	



	for(t=tn-2;t>=0;t--)
	{

			memset(lcp->Medicaid,0,sizeof(double[4][MAXGRID]));
 			memset(lcp->insurance,0,sizeof(double[4][MAXGRID]));



	for (j=0;j<4;j++)
		for(i=0;i<wrow;i++)
		{
			//constraint=A+LTCI[t][j]+wdis[i]-M[t][j];

			//if(para.Mcaid==1 && constraint < (Cbar2+Wbcar) && constraint - wdis[i]/(1+r) < Cbar2 && j==1)
			if(para.Mcaid==1 && A+LTCI[t][j]+wdis[i]-M[t][j] < (Cbar2+Wbcar) && A+LTCI[t][j]+r*wdis[i]/(1+r)-M[t][j] < Cbar2 && j==1)
			{

				if (wdis[i]/(1+r) > Wbcar) wextra = wdis[i]/(1+r) -Wbcar;
				else wextra=0;
				for(k=0;k<wrow;k++)
				{
					lcp->c[k]=wdis[i]/(1+r) -wdis[k]/(1+r) + Cbar2-wextra;
					if(lcp->c[k]> 0) lcp->zeroind[k]=0;else {lcp->c[k]=0.0001;lcp->zeroind[k]=1;}
				}

				lcp->Medicaid[j][i]= M[t][j]-wextra-(A+LTCI[t][j]+r*wdis[i]/(1+r) -Cbar2);
				lcp->insurance[j][i] = LTCI[t][j];

			}else if(para.Mcaid==1 &&  A+LTCI[t][j]+wdis[i]-M[t][j] < (Cbar+Wbcar) && A+LTCI[t][j]+r*wdis[i]/(1+r)-M[t][j] < Cbar && j>1 )
			{
			
				if (wdis[i]/(1+r) > Wbcar) wextra=wdis[i]/(1+r) -Wbcar;
				else wextra=0;

				lcp->Medicaid[j][i]= M[t][j]-wextra-(A+LTCI[t][j]+r*wdis[i]/(1+r) -Cbar);
				lcp->insurance[j][i] = LTCI[t][j];

				for(k=0;k<wrow;k++)
				{
					
					lcp->c[k]=wdis[i]/(1+r) -wdis[k]/(1+r)+Cbar-wextra;
					if(lcp->c[k]> 0) lcp->zeroind[k]=0;else {lcp->c[k]=0.0001;lcp->zeroind[k]=1;}
				}


			}else { // not on medicaid
				for(k=0;k<wrow;k++)
				{
					lcp->c[k]=wdis[i]-wdis[k]/(1+r) +A +LTCI[t][j]-M[t][j];
					if(lcp->c[k]> 0 && (wdis[i]+A-M[t][j]+LTCI[t][j] - lcp->c[k]>=para.eps))lcp->zeroind[k]=0;else{lcp->c[k]=0.0001;lcp->zeroind[k]=1;}


				}

				lcp->Medicaid[j][i]=0;
				if (j>=1) lcp->insurance[j][i]=LTCI[t][j];

			}



		 /* Calculate value function for each combination of C(t) and W(t+1), given 
         that you came into this period with w(t) = wdis(i), and health status j */;
         
         /* Note, the only reason it is necessary to do the following if-then statements is
         if we one uses state dependent utility.  */


		switch(j){
		case 0: {  fn_util(lcp->c,lcp->OUTutil,para.crra,0); phi=para.phi_hc; break;}
		case 1: {  consplus=0; fn_util(lcp->c,lcp->OUTutil,para.crra,consplus);phi=para.phi_alf; break;}
			//if(stateFlag==1){ consplus=para.qual_alf*para.beta*HC0[t]; fn_util(c,OUTutil,para.crra,consplus); for(i=0;i<wrow;i++) VV[i][j]=para.phi_alf*OUTutil[i] +zeroind[i]*(-9999) ;}
			//	else {consplus=para.beta*HC0[t];  fn_util(c,OUTutil,para.crra,consplus); for(i=0;i<wrow;i++) VV[i][j]=para.phi_alf*OUTutil[i] +zeroind[i]*(-9999); }}
		case 2: { consplus=para.Food; fn_util(lcp->c,lcp->OUTutil,para.crra,consplus);phi=para.phi_nh;break; }

			//if(stateFlag==1){ consplus=para.qual_alf*para.beta*HC0[t]; fn_util(c,OUTutil,para.crra,consplus); for(i=0;i<wrow;i++) VV[i][j]=para.phi_alf*OUTutil[i] +zeroind[i]*(-9999) ;}
			//	else {consplus=para.beta*HC0[t];  fn_util(c,OUTutil,para.crra,consplus); for(i=0;i<wrow;i++) VV[i][j]=para.phi_alf*OUTutil[i] +zeroind[i]*(-9999); }}
		case 3: { consplus=para.Food; fn_util(lcp->c,lcp->OUTutil,para.crra,consplus);phi=para.phi_nh; break;}
		default:break;

		}


		for(l=0;l<wrow;l++) lcp->VV[j][l]=phi*lcp->OUTutil[l]*(1-lcp->zeroind[l]) +lcp->zeroind[l]*(-99999) ;


			
			/* Then, regardless of health status, we then have to add in the value of 
             taking wealth into the next period, recognizing you can enter next period 
             in any of 5 states.  */
			for(k=0;k<wrow;k++)
			lcp->VV[j][k]=lcp->VV[j][k]+(1/(1+para.rho))*q[t+1][j*5]*lcp->V[0][k]
									 +(1/(1+para.rho))*q[t+1][j*5+1]*lcp->V[1][k]
									 +(1/(1+para.rho))*q[t+1][j*5+2]*lcp->V[2][k]
									 +(1/(1+para.rho))*q[t+1][j*5+3]*lcp->V[3][k];
								// +(1/(1+para.d))*q[t+1][j*5+4]*para.beq;
			
			

			//find the maximized VV Vmax Astream Cstream

			tempVMax=lcp->VV[j][0];
			tempIndex=0;
			for(k=0;k<wrow;k++){		
				if(lcp->VV[j][k]>tempVMax)
				{
					tempVMax=lcp->VV[j][k];
					tempIndex=k;
				}
			}

			lcp->Medicaid[j][i] = lcp->Medicaid[j][i] +  (1/(1+r))*( q[t+1][j*5+0]*lcp->Medicaid2[0][tempIndex]
																	+q[t+1][j*5+1]*lcp->Medicaid2[1][tempIndex]
																	+q[t+1][j*5+2]*lcp->Medicaid2[2][tempIndex]
																	+q[t+1][j*5+3]*lcp->Medicaid2[3][tempIndex]);

			lcp->insurance[j][i]= lcp->insurance[j][i] + (1/(1+r))*(   q[t+1][j*5+0]*lcp->insurance2[0][tempIndex]
																	  +q[t+1][j*5+1]*lcp->insurance2[1][tempIndex]
																	  +q[t+1][j*5+2]*lcp->insurance2[2][tempIndex]
																	  +q[t+1][j*5+3]*lcp->insurance2[3][tempIndex]);
		

						
			lcp->Cstream[t][j][i]=lcp->c[tempIndex];
			lcp->Astream[t][j][i]=tempIndex;
			lcp->Vmax[j][i]=tempVMax;

		}//i,j

		
			memcpy(lcp->V,lcp->Vmax,sizeof(double[4][MAXGRID]));
			memcpy(lcp->Medicaid2, lcp->Medicaid,sizeof(double [4][MAXGRID]));
			memcpy(lcp->insurance2,lcp->insurance,sizeof(double [4][MAXGRID]));


		


	}//t

	/* This gives you utility as of period 1.  
	 Now go back to period 0 for healthy person. */

	for (i=0;i<wrow;i++)
	{
		lcp->Vstar[i]=(1/(1+para.rho)) * ( q[0][0]*lcp->V[0][i]
										+q[0][1]*lcp->V[1][i]
										+q[0][2]*lcp->V[2][i]
										+q[0][3]*lcp->V[3][i]);

		//Vstar[i]=Vstar[i]+(1/(1+para.d))*(q[0][4]*fn_utilbeq(para.beq));

		lcp->Mstar[i]=(1/(1+r)) *       ( q[0][0]*lcp->Medicaid2[0][i]
									+q[0][1]*lcp->Medicaid2[1][i]
									+q[0][2]*lcp->Medicaid2[2][i]
									+q[0][3]*lcp->Medicaid2[3][i]);

		//mstar[i]=Mstar[i]+(1/(1+para.d))*(q[0][4]*fn_utilbeq(para.beq)); 

		lcp->Istar[i]=(1/(1+r)) *( q[0][0]*lcp->insurance2[0][i]
							 +q[0][1]*lcp->insurance2[1][i]
							 +q[0][2]*lcp->insurance2[2][i]
							 +q[0][3]*lcp->insurance2[3][i]);
		////mstar[i]=Mstar[i]+(1/(1+para.d))*(q[0][4]*fn_utilbeq(para.beq)); 


	}
	/* protype==1 means want to report optimal value only
	   but  it does not matter, since output both contains 
	   the Vstar & VstarMatrix in Digram*/
	
	wcrit=0;
	
	
	wstart=para.W0*(1+r);

	for(i=0;i<wrow;i++) 
		if (wstart>=wdis[i]) wcrit++;

	if(protype==1) 
	if (wcrit>=wrow)
	{
		Digram->Vstar=lcp->Vstar[wrow-1];
		Digram->Mstar=lcp->Mstar[wrow-1];
		Digram->Istar=lcp->Istar[wrow-1];
	}else
	{
		Digram->Vstar=lcp->Vstar[wcrit-1]+(lcp->Vstar[wcrit]-lcp->Vstar[wcrit-1])*((wstart-wdis[wcrit-1])/(wdis[wcrit]-wdis[wcrit-1]));
		Digram->Mstar=lcp->Mstar[wcrit-1]+(lcp->Mstar[wcrit]-lcp->Mstar[wcrit-1])*((wstart-wdis[wcrit-1])/(wdis[wcrit]-wdis[wcrit-1]));
		Digram->Istar=lcp->Istar[wcrit-1]+(lcp->Istar[wcrit]-lcp->Istar[wcrit-1])*((wstart-wdis[wcrit-1])/(wdis[wcrit]-wdis[wcrit-1]));
	}		


	if(protype==0) 
	{
		if (wcrit>=wrow)
		{
			
			Digram->Mstar=lcp->Mstar[wrow-1];
			Digram->Istar=lcp->Istar[wrow-1];
		}else
		{
		
			Digram->Mstar=lcp->Mstar[wcrit-1]+(lcp->Mstar[wcrit]-lcp->Mstar[wcrit-1])*((wstart-wdis[wcrit-1])/(wdis[wcrit]-wdis[wcrit-1]));
			Digram->Istar=lcp->Istar[wcrit-1]+(lcp->Istar[wcrit]-lcp->Istar[wcrit-1])*((wstart-wdis[wcrit-1])/(wdis[wcrit]-wdis[wcrit-1]));
		}	
	
	
	
	// the LTCI is from 1 to 0

		/************************************************************************/
		/* calculate willingness to pay                                         */
		/************************************************************************/


	Vr=0;
	for (i=0;i<para.wrow;i++) if(Digram->Vstar> lcp->Vstar[i]) Vr=Vr+1;

	if(Vr==para.wrow) {cout<<"Grid not big enough!"<<endl;wequiv=-99999;}
	else if(Vr==0){cout<<"Vr==0:  LTCI is worth than losing all financial wealth."<<endl;	wequiv=para.Minf;}
	else if( lcp->Vstar[Vr]>=Digram->Vstar && Digram->Vstar>=lcp->Vstar[Vr-1])
	{
		wequiv=wdis[Vr-1]+((Digram->Vstar-lcp->Vstar[Vr-1])/(lcp->Vstar[Vr]-lcp->Vstar[Vr-1]))*(wdis[Vr]-wdis[Vr-1]); 
		wequiv=wequiv/(1+para.r) - para.W0;
	}else{
		cout<<"not correct"<<endl;
		wequiv=-999999;

	}

	}

	if(protype==1) return -9999;
	else return wequiv;

	

	free(lcpbuffer);





	}





void willtopay(int gender){
	/*this function is aimed to draw the plot of willingness to pay and compute implicit tax
	in this function , I will calculate 9 point of payment 
	*/


	int i,j,k,t;
	int WW;
	double griddense;
	double X;

	int wealthpercentil;// simulate number 
	int protype, LTCIflag;
	double EPDVMedical,EPDVMedical2;
	double MUstar,Mstar;
	double Istarown,Istarnone;
	int Vr;

	double Vstar;

	double wequiv[10];  // final point value to compute  

	time_t time_began,time_end;

	/*initialize */

	memset(wequiv,0,sizeof(double[10]));

	/************************************************************************/
	/*calculate V* Astream Cstream and Medicaid of different wealth percentil*/
	/************************************************************************/


	//for(wealthpercentil=3;wealthpercentil<10;wealthpercentil++)
	wealthpercentil=4;
	{
		time_began=time(NULL);
		/*calculate preparation*/
		calcPrep(wealthpercentil,gender);
		
		/*calculate Model*/
		for(j=1;j>=0;j--){

			//grid setup
			//flag indicate whether the situation Has LTCI insurance or Not
			//flag ==1 indicate: LTCI has ; flag == 0 indicate LTCI do not have
		
			gridsetup(j);
			                               
			
			protype=j;
			LTCIflag=j;
		

			wequiv[wealthpercentil]=calcModel(protype,LTCIflag);

			if (protype==1) {Mstar=Digram->Mstar;EPDVMedical=Digram->Medicalstar;Istarown=Digram->Istar;Vstar=Digram->Vstar;}
			else			{MUstar=Digram->Mstar;EPDVMedical2=Digram->Medicalstar;Istarnone=Digram->Istar;}
			

		}

		time_end=time(NULL);
		/*cout<<"this is gender : "<<gender<<endl;*/
		cout<<"*********************************************************************"<<endl;
		cout<<"this is the wealthpercentile"<<wealthpercentil<<endl;
		cout<<"time consuming is (minute)"<<(time_end-time_began)/60<<endl;
		cout<<"Medicaid share of EPDV of total LTC Exp (No private ins)		column 1"<<endl; 
		cout<<MUstar/EPDVMedical<<endl;
		cout<<"Medicaid share of EPDV of total LTC Exp (With private ins)	column 2"<<endl;
		cout<<Mstar/EPDVMedical<<endl;
		cout<<"implicit tax													column 3 "<<endl; 
		cout<<(MUstar - Mstar)/Istarown<<endl;
		cout<<"Net load														column 4"<<endl; 
		cout<<(1-(Istarown-(MUstar-Mstar))/(Istarown/para.MW))<<endl;


		cout<<"the wequiv is :"<<endl;

		cout<<wequiv[wealthpercentil]<<endl;

		cout<<"*********************************************************************"<<endl;


		/*delete dynamic index*/
			
	}
	writeresult(wequiv,gender);





	
	

	/**/




	


}


void writeresult(double *wequiv ,int gender){
	int i,j;


	if (gender==0)
	{
		ofstream out("female.txt");  
		if (out.is_open())   
		{  

			out << "the willingenss to pay .\n"; 
			for(i=0;i<10;i++) out<<wequiv[i]<<endl;
// 			out<<"Medicaid share of EPDV of total LTC Exp (No private ins) "<<endl; 
// 			out<<MUstar/EPDVMedical<<endl;
// 			out<<"Medicaid share of EPDV of total LTC Exp (With private ins) "<<endl; 
// 			out<<Mstar/EPDVMedical<<endl;
// 			out<<"implicit tax                                             "<<endl; 
// 			out<<(MUstar - Mstar)/Istarown<<endl;
// 			out<<"Net load                                                 "<<endl; 
// 			out<<(1-(Istarown-(MUstar-Mstar))/(Istarown/para.MW));


			out << "This is the end.\n";  
			out.close();  
		}  


	}else{
		ofstream out2("male.txt");
			if(out2.is_open())   
			{  

				out2 << "the willingenss to pay .\n"; 
				for(i=0;i<10;i++) out2<<wequiv[i]<<endl;
// 				out2<<"Medicaid share of EPDV of total LTC Exp (No private ins) "<<endl; 
// 				out2<<MUstar/EPDVMedical<<endl;
// 				out2<<"Medicaid share of EPDV of total LTC Exp (With private ins) "<<endl; 
// 				out2<<Mstar/EPDVMedical<<endl;
// 				out2<<"implicit tax                                             "<<endl; 
// 				out2<<(MUstar - Mstar)/Istarown<<endl;
// 				out2<<"Net load                                                 "<<endl; 
// 				out2<<(1-(Istarown-(MUstar-Mstar))/(Istarown/para.MW));


				out2 << "This is the end.\n";  
				out2.close();  
			}  
			


	}

	
}