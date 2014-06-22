#include "LTCIII.h"


#define TN 480
#define MAXGRID 6087
//#define DEDUCTGRID 19
#define DEDUCTGRID 8
#define NSIMUL		50000
/************************************************************************/
/* a test for my suppose only two indexes for in period and out period 
revised version for simulate
/************************************************************************/



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
	int Astream[TN][4][DEDUCTGRID][MAXGRID];
	int AstreamN[TN][4][MAXGRID];
	double Cstream[TN][4][DEDUCTGRID][MAXGRID];

	double LTCIown[TN][5]; //the net payment to the policy holder.
	double LTCInone[TN][5];//individual does not own insurance 


}CALCSTRUCT;


typedef struct{
	double Medicalstar;
	double MstarNI;
	double IstarNI;

	double MMstar;
	double IIstar;
	double MUstar;
	double Medcost;

	double VstarNI[MAXGRID];
	double Vstar[DEDUCTGRID];	
	double Mstar[DEDUCTGRID];
	double Istar[DEDUCTGRID];
	double wequiv[DEDUCTGRID];
	double pointM[10];
	double pointF[10];



}DIGRAM;


/*definition of functions */
void fn_util(double *Cons,double *zeroind,double* OUTutil,double crra,double Consplus,double phi);  // the input parameter will change into double wealthpercentil,double gender, double gamma
void calcSetup();
void calcPrep(int gender);
void calcModel( int flagLTCI );
void calcModel2(int flagLTCI);
void simulate();
//void putResult();
void generaterand();
void inputData(int gender);
void willtopay(int gender);
void writeresult(int wealthpercentile ,int gender);
void gridsetup(int flag);
void cur_time();

PARA		para;
CALCSTRUCT *CalcStruct;
DIGRAM     *Digram;

int    healthstate[NSIMUL][TN];
double wdis[MAXGRID];
double Deductile[DEDUCTGRID];
double q[TN+12][25];
//double Probq[TN];   // deductible probabiliy
/*double D_Prob[TN];*/


static double Preimum[10][2]={   
	0.454813049,	0.20096996,
	0.439435863,	0.185611818,
	0.417177805,	0.171281873,
	0.396360788,	0.158439056,
	0.376949484,	0.146653683,
	0.358820655,	0.135746975,
	0.34173364,	0.125675334,
	0.32572715,	0.116503167,
	0.310722823,	0.108132752,
	0.296530096,	0.100434849
};

int deduflag=0;
  

int main(){
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


	for(gender=1;gender<2;gender++)
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

	
	

	free(Digbuffer);
	free(Calcbuffer);
	system("pause");
	return 0;



}

//void cur_time(){
//	char *wday[]={"星期天","星期一","星期二","星期三","星期四","星期五","星期六"};
//	time_t timep;
//	struct tm *p;
//	time(&timep);
//	p=localtime(&timep); /* 获取当前时间 */
//	printf("%d 年 %02d 月 %02d 日",(1900+p->tm_year),(1+p->tm_mon),p->tm_mday);
//	printf("%s %02d : %02d : %02d \n",wday[p->tm_wday],p->tm_hour,p->tm_min,p->tm_sec);
//}



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

	para.Food=644/X;      //Food = SSI level used to parameterize food/housing benefit
	
	para.Wbar=2;	      // @ wealth excluded from Medicaid spend-down (base case is 2000/X)	@ 
	para.Cbar=0.03;		  // @ min consumption provided if on Medicaid	@
	para.Cbar2=0.674;        // @ CBAR WHILE IN HOME CARE @;

	para.medicare=0.35;        // % @ Fraction of Home care costs covered by Medicare @




	//medical cost
	para.NHamt=78.110/12;      	       // % @ Monthly cost of NH  $51480  @
	para.ALFamt=3.477;              //% @ Monthly cost of ALF $25908 per year  @

	para.HCnonrn=0.021;               // @ Hourly HC costs (non RN) @
	para.HCrn=0.043;                  // @ Hourly HC costs (RN)  @




	para.Binf=0.05;
	para.Bben=4740/X;



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
	int sim_p1,sim_p2;
	int simtemp;
	int product;
	char hcexprobc[20];

	char filename[60];
	char stringline[1000];


	double qti[47][25];
	double hcexprob,lama;
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


	FILE *infile,*infile2,*infile3;
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
			fgets(stringline, 400, infile2);
			for(i=0;i<25;i++)
			{
				sscanf(&stringline[i*15], "%13c", &hcexprobc);
				hcexprob=(double)atof(hcexprobc);
				qti[age-65][i]=(double)hcexprob;

			}
			
		

		}


		fclose(infile2);
	}

	if(gender==0)
	infile3 = fopen("healthstatef.txt","r");
	else
	infile3 = fopen("healthstatem.txt","r");

	if(infile3 == NULL) {cout<<" File not found in "<<"healthstate.txt"<<endl; system("pause");}

	for(sim_p1=0;sim_p1<NSIMUL;sim_p1++){
		fgets(stringline,1000,infile3);
		for(sim_p2=0;sim_p2<TN;sim_p2++){
			sscanf(&stringline[sim_p2*2], "%d", &simtemp);
			healthstate[sim_p1][sim_p2]=(int)simtemp;
		
		
		}

	}
	fclose(infile3);






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
// 	memset(Probq,0,sizeof(double[TN]));
// 	for(i=18;i<para.tn;i++)
// 		product=1;
// 	    lama=(1-Prob[i][0])*para.tn;
// 		for(j=0;j<19;j++){
// 			product=(i+1)*product;
// 			Probq[i]=Probq[i]+exp(-lama)*(pow(lama,j)/product);
// 
// 		}
// 	





}

void fn_util(double *Cons,double *zeroind,double* OUTutil,double crra,double Consplus,double phi){
	int wrow;
	int i,j,k;

	wrow =para.wrow; 

	if(crra>1) for(i=0;i<wrow;i++) OUTutil[i]=phi*(pow(Cons[i]+Consplus,(1-crra))-1)/(1-crra)*(1-zeroind[i])-zeroind[i]*99999;
	else if(crra==1) for(i=0;i<wrow;i++)OUTutil[i]=phi*(log(Cons[i]+Consplus)-1)*(1-zeroind[i])-zeroind[i]*99999;
	else if(crra==0) for(i=0;i<wrow;i++)OUTutil[i]=phi*(Cons[i]+Consplus)*(1-zeroind[i])-zeroind[i]*99999;

	//for(i=0;i<wrow;i++) if(Cons[i]<=) OUTutil[i]=0; 

}



void calcPrep(int gender)
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
	int deductgrid;

	//calcate M B and find min(M,B)
	//都已经初始化过了



	deductgrid=DEDUCTGRID;


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


 	//for(i=0;i<TN;i++)for(j=0;j<5;j++)cost[i][j]=CalcStruct->P[i][j] * CalcStruct->Prob[i+1][j] / rfactor[i];
 	//for(i=0;i<TN;i++)for(j=0;j<5;j++)ben [i][j]=CalcStruct->B[i][j] * CalcStruct->Prob[i+1][j] / rfactor[i];
 
 	//scost=0; sben=0;
 	//for(i=0;i<TN;i++) scost=scost+cost[i][0];
 	//for(i=0;i<TN;i++) for(j=0;j<5;j++) sben=sben+ben[i][j];
 
 	//AFP = ( sben / scost)*para.premium;
////// 	
	switch (deductgrid){
	case 1: {if(gender==0) AFP=Preimum[0][0];else AFP=Preimum[0][1]; break;}
	case 4: {if(gender==0) AFP=Preimum[1][0];else AFP=Preimum[1][1]; break;}
	case 6: {if(gender==0) AFP=Preimum[2][0];else AFP=Preimum[2][1]; break;}
	case 8: {if(gender==0) AFP=Preimum[3][0];else AFP=Preimum[3][1]; break;}
	case 10: {if(gender==0) AFP=Preimum[4][0];else AFP=Preimum[4][1]; break;}
	case 12: {if(gender==0) AFP=Preimum[5][0];else AFP=Preimum[5][1]; break;}										
	case 14: {if(gender==0) AFP=Preimum[6][0];else AFP=Preimum[6][1]; break;}	
	case 16: {if(gender==0) AFP=Preimum[7][0];else AFP=Preimum[7][1]; break;}
	case 18: {if(gender==0) AFP=Preimum[8][0];else AFP=Preimum[8][1]; break;}
	case 20: {if(gender==0) AFP=Preimum[9][0];else AFP=Preimum[9][1]; break;}
	}

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
	int broden;
	int WW,i;


	X=1000;
	broden=3;
	griddense=1.0/broden;

	para.W0=para.wealth*(1-para.alpha);                   // % @ This section simply creates discretized grid @;

	if (flag==1)
		WW=(int)((para.W0*1.2-10000)/(para.grid*griddense))+1; 
	else
		WW=(int)((para.W0*1.2+para.wx-10000)/(para.grid*griddense))+1;



	if (WW*para.grid<10000)
	{
		wdis[0]=0;
		for (i=1;i<101*broden;i++)			wdis[i]=wdis[i-1]+10*griddense/X;
		for(i=101*broden;i<151*broden;i++)	wdis[i]=wdis[i-1]+20*griddense/X;
		for(i=151*broden;i<311*broden;i++)	wdis[i]=wdis[i-1]+50*griddense/X;
		para.wrow=310*broden;
	}else{
		wdis[0]=0;
		for (i=1;i<101*broden;i++)				wdis[i]=wdis[i-1]+10*griddense/X;
		for(i=101*broden;i<151*broden;i++)		wdis[i]=wdis[i-1]+20*griddense/X;
		for(i=151*broden;i<311*broden;i++)		wdis[i]=wdis[i-1]+50*griddense/X;
		for(i=311*broden;i<311*broden+WW;i++)	wdis[i]=wdis[i-1]+para.grid*griddense/X;
		para.wrow=311*broden+WW;

	}







	/*
	WW=(int)((para.W0*1.2)/(para.grid*griddense))+1;

	wdis[0]=0;
	for(i=1;i<WW;i++)wdis[i]=wdis[i-1]+para.grid*griddense/X;

	para.wrow=WW;*/

	para.W0=para.W0/X;
	memset(Deductile,0,sizeof(double [DEDUCTGRID]));
	Deductile[DEDUCTGRID-1]=1;  //19 is 1

}



void calcModel( int flagLTCI ){
	
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
	

	int t,j,i,k,l,deduct,ded2;
	int wrow,tn;
	int stateFlag;  //0: no medicaid 1: j=1 hc 2: alf 3:nh 
	int wcrit,tempIndex;
	int Vr;
	int deductgrid;

	double Cbar,Wbcar,Cbar2,r;
	double phi;
	double tempVMax;
	double consplus;
	double wextra,wstart;
	


	double A;
	double Medicalstar;
	
	double Medical[TN][5];
	double wequiv[DEDUCTGRID];

	double (*LTCI)[5];
	double (*M)[5];
	double (*B)[5];
	double (*Prob)[5];
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
	deductgrid=DEDUCTGRID;

	
	lcpbuffer = malloc( sizeof(LOCALSTRUCT));
	if(lcpbuffer==NULL) {cout<<"LOCALSTRUCT allocation is failed"<<endl; system("pause"); exit(0);}
	lcp= (LOCALSTRUCT *) lcpbuffer;
	memset(lcp,0,sizeof(LOCALSTRUCT));




	


	memset(Medical,0,sizeof(double[TN][5]));
	//check medicalstar
	memcpy(Medical[TN-1],CalcStruct->M[TN-1],sizeof(double[5]));

	//for(t=TN-2;t>=0;t--) for(j=0;j<5;j++)
	//	Medical[t][j]=M[t][j]+(1/(1+para.r))*(q[t+1][j*5]*Medical[t+1][0] +q[t+1][j*5+1]*Medical[t+1][1] + q[t+1][j*5+2]*Medical[t+1][2] + q[t+1][j*5+3]*Medical[t+1][3]+ q[t+1][j*5+4]*Medical[t+1][4]);

	//Medicalstar= (1/(1+para.r))*(q[0][0]*Medical[0][0] + q[0][1]*Medical[0][1] + q[0][2]*Medical[0][2] + q[0][3]*Medical[0][3]+ q[0][4]*Medical[0][4]);

	//Digram->Medicalstar=Medicalstar;



	 /* Determines value function for period T */

	t=tn-1;
	memset(lcp->Medicaid,0,sizeof(double [4][DEDUCTGRID][MAXGRID]));
	memset(lcp->insurance,0,sizeof(double [4][DEDUCTGRID][MAXGRID]));

	for(j=0;j<4;j++)
	{

	   for(deduct=0;deduct<deductgrid;deduct++)	
		for(i=0;i<wrow;i++)
		{
			//memset(VV,0,sizeof(double [row][4]));

		constraint=A+LTCI[t][j]*(deduct+(j>0)>deductgrid-2)+LTCI[t][0]*(deduct+(j>0) <= deductgrid-2 )+wdis[i]-M[t][j];


					/* Medicaid is defined so that (a) if Medicaid exists, and 
					(b) starting wealth for period falls below Wbar (asset test) and 
					(c) income plus LCTI income is less than sum of medical expenses and minimum 
					consumption level Cbar, then person permitted to consume max of Cbar. */;

					/* Income test includes annuity, difference between insurance and expenses, +interest income) 
					% Since wdis already includes the interest, the asset test must subtract interest back off.  
					% The subtraction in the asset test and addition in the income test cancel in the combined constraint. */

					if(para.Mcaid==1 &&  constraint < (Cbar2+Wbcar) && constraint-wdis[i]/(1+r) < Cbar2 && j==1)
					{

						if (wdis[i]/(1+r) > Wbcar) wextra = wdis[i]/(1+r) -Wbcar;
						else wextra=0;

						for(k=0;k<wrow;k++)
						{

							lcp->c[deduct][k]=wdis[i]/(1+r) -wdis[k]/(1+r)+Cbar2-wextra;
							if(lcp->c[deduct][k]>0)lcp->zeroind[deduct][k]=0;else {lcp->c[deduct][k]=0.0001;lcp->zeroind[deduct][k]=1;}
						}

						lcp->Medicaid[j][deduct][i]= M[t][j]-wextra-(A+LTCI[t][j]*(deduct+(j>0)>deductgrid-2)+LTCI[t][0]*(deduct+(j>0) <= deductgrid-2 )+r*wdis[i]/(1+r) -Cbar2);
						if(deduct+(j>0)>deductgrid-2)lcp->insurance[j][deduct][i] = LTCI[t][j];

					}else if(para.Mcaid==1 &&  constraint < (Cbar+Wbcar) &&  constraint-wdis[i]/(1+r)< Cbar && j>1 )
					{

						if (wdis[i]/(1+r) > Wbcar) wextra=wdis[i]/(1+r) -Wbcar;
						else wextra=0;


						if(deduct+(j>0)>deductgrid-2)lcp->insurance[j][deduct][i] = LTCI[t][j];
						lcp->Medicaid[j][deduct][i]= M[t][j]-wextra-(A+LTCI[t][j]*(deduct+(j>0)>deductgrid-2)+LTCI[t][0]*(deduct+(j>0) <= deductgrid-2 )+r*wdis[i]/(1+r) -Cbar2);

						for(k=0;k<wrow;k++)
						{

							lcp->c[deduct][k]=wdis[i]/(1+r) -wdis[k]/(1+r)+Cbar-wextra;
							if(lcp->c[deduct][k]>0) lcp->zeroind[deduct][k]=0;else{lcp->c[deduct][k]=0.0001;lcp->zeroind[deduct][k]=1;}
						}


					}else { // not on medicaid  // LTCI pay for insurance

						for(k=0;k<wrow;k++)
						{
							lcp->c[deduct][k]=wdis[i]-wdis[k]/(1+r) +A +LTCI[t][j]*(deduct+(j>0)>deductgrid-2)+LTCI[t][0]*(deduct+(j>0) <= deductgrid-2 )-M[t][j];
							if(lcp->c[deduct][k]>0 && wdis[i]+A-M[t][j]+LTCI[t][j]*(deduct+(j>0)>deductgrid-2)+LTCI[t][0]*(deduct+(j>0) <= deductgrid-2 )-lcp->c[deduct][k]>=0)lcp->zeroind[deduct][k]=0;else{lcp->c[deduct][k]=0.0001;lcp->zeroind[deduct][k]=1;}
						}

						lcp->Medicaid[j][deduct][i]=0;
						if (j>=1) lcp->insurance[j][deduct][i]=LTCI[t][j]*(deduct+(j>0)>deductgrid-2);

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



	/*	for(l=0;l<wrow;l++) lcp->VV[j][deduct][l]=phi*lcp->OUTutil[deduct][l]*(1-lcp->zeroind[l]) +lcp->zeroind[l]*(-99999) ;*/


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


		CalcStruct->Cstream[t][j][deduct][i]=lcp->c[deduct][tempIndex];
		CalcStruct->Astream[t][j][deduct][i]=tempIndex;
		lcp->Vmax[j][deduct][i]=tempVMax;




		}//j

	}//i

	
		memcpy(lcp->V,lcp->Vmax,sizeof(double[4][DEDUCTGRID][MAXGRID]));
		memcpy(lcp->Medicaid2,lcp->Medicaid,sizeof(double [4][DEDUCTGRID][MAXGRID]));
		memcpy(lcp->insurance2,lcp->insurance,sizeof(double [4][DEDUCTGRID][MAXGRID]));


	



	for(t=tn-2;t>=DEDUCTGRID-1;t--)
	{

			memset(lcp->Medicaid,0,sizeof(double[4][DEDUCTGRID][MAXGRID]));
 			memset(lcp->insurance,0,sizeof(double[4][DEDUCTGRID][MAXGRID]));



	for (j=0;j<4;j++)
	for(deduct=0;deduct<deductgrid;deduct++)
	for(i=0;i<wrow;i++)
		{
		constraint=A+LTCI[t][j]*(deduct+(j>0)>deductgrid-2)+LTCI[t][0]*(deduct+(j>0) <= deductgrid-2 )+wdis[i]-M[t][j];

						if(para.Mcaid==1 &&  constraint < (Cbar2+Wbcar) && constraint-wdis[i]/(1+r) < Cbar2 && j==1)
						{

							if (wdis[i]/(1+r) > Wbcar) wextra = wdis[i]/(1+r) -Wbcar;
							else wextra=0;
							for(k=0;k<wrow;k++)
							{

								lcp->c[deduct][k]=wdis[i]/(1+r) -wdis[k]/(1+r)+Cbar2-wextra;
								if(lcp->c[deduct][k]>0)lcp->zeroind[deduct][k]=0;else {lcp->c[deduct][k]=0.0001;lcp->zeroind[deduct][k]=1;}
							}

							lcp->Medicaid[j][deduct][i]= M[t][j]-wextra-(A+LTCI[t][j]*(deduct+(j>0)>deductgrid-2)+LTCI[t][0]*(deduct+(j>0) <= deductgrid-2 )+r*wdis[i]/(1+r) -Cbar2);
							if(deduct+(j>0) > deductgrid-2)lcp->insurance[j][deduct][i] = LTCI[t][j];

						}else if(para.Mcaid==1 &&  constraint < (Cbar+Wbcar) &&  constraint-wdis[i]/(1+r)< Cbar && j>1 )
						{

							if (wdis[i]/(1+r) > Wbcar) wextra=wdis[i]/(1+r) -Wbcar;
							else wextra=0;


							lcp->Medicaid[j][deduct][i]= M[t][j]-wextra-(A+LTCI[t][j]*(deduct+(j>0)>deductgrid-2)+LTCI[t][0]*(deduct+(j>0) <= deductgrid-2 )+r*wdis[i]/(1+r) -Cbar2);
							if(deduct+(j>0) > deductgrid-2)lcp->insurance[j][deduct][i] = LTCI[t][j];

							for(k=0;k<wrow;k++)
							{

								lcp->c[deduct][k]=wdis[i]/(1+r) -wdis[k]/(1+r)+Cbar-wextra;
								if(lcp->c[deduct][k]>0) lcp->zeroind[deduct][k]=0;else{lcp->c[deduct][k]=0.0001;lcp->zeroind[deduct][k]=1;}
							}


						}else { // not on medicaid  // LTCI pay for insurance

							for(k=0;k<wrow;k++)
							{
								lcp->c[deduct][k]=wdis[i]-wdis[k]/(1+r) +A +LTCI[t][j]*(deduct+(j>0)>deductgrid-2)+LTCI[t][0]*(deduct+(j>0) <= deductgrid-2 )-M[t][j];
								if(lcp->c[deduct][k]>0 && wdis[i]+A-M[t][j]+LTCI[t][j]*(deduct+(j>0)>deductgrid-2)+LTCI[t][0]*(deduct+(j>0) <= deductgrid-2 )-lcp->c[deduct][k]>=0)lcp->zeroind[deduct][k]=0;else{lcp->c[deduct][k]=0.0001;lcp->zeroind[deduct][k]=1;}
							}

							lcp->Medicaid[j][deduct][i]=0;
							if (j>=1) lcp->insurance[j][deduct][i]=LTCI[t][j]*(deduct+(j>0)>deductgrid-2);



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
			for(k=0;k<wrow;k++)
				if(j==0||deduct==DEDUCTGRID-1)
				lcp->VV[j][deduct][k]=lcp->VV[j][deduct][k]+(1/(1+para.rho))*q[t+1][j*5]*lcp->V[0][deduct][k]
														+(1/(1+para.rho))*q[t+1][j*5+1]*lcp->V[1][deduct][k]
														+(1/(1+para.rho))*q[t+1][j*5+2]*lcp->V[2][deduct][k]
														+(1/(1+para.rho))*q[t+1][j*5+3]*lcp->V[3][deduct][k];
				else if(j>=1&&deduct<DEDUCTGRID-1)
				lcp->VV[j][deduct][k]=lcp->VV[j][deduct][k]+(1/(1+para.rho))*q[t+1][j*5]*lcp->V[0][deduct+1][k]
														+(1/(1+para.rho))*q[t+1][j*5+1]*lcp->V[1][deduct+1][k]
														+(1/(1+para.rho))*q[t+1][j*5+2]*lcp->V[2][deduct+1][k]
														+(1/(1+para.rho))*q[t+1][j*5+3]*lcp->V[3][deduct+1][k];
				
			// +(1/(1+para.d))*q[t+1][j*5+4]*para.beq;
			
			
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


			if(j==0||deduct==DEDUCTGRID-1)
				lcp->Medicaid[j][deduct][i] = lcp->Medicaid[j][deduct][i] +  (1/(1+r))*( q[t+1][j*5+0]*lcp->Medicaid2[0][deduct][tempIndex]
																						+q[t+1][j*5+1]*lcp->Medicaid2[1][deduct][tempIndex]
																						+q[t+1][j*5+2]*lcp->Medicaid2[2][deduct][tempIndex]
																						+q[t+1][j*5+3]*lcp->Medicaid2[3][deduct][tempIndex]);

			else if(j>=1&&deduct<DEDUCTGRID-1)
				lcp->Medicaid[j][deduct][i] = lcp->Medicaid[j][deduct][i] +  (1/(1+r))*( q[t+1][j*5+0]*lcp->Medicaid2[0][deduct+1][tempIndex]
																						+q[t+1][j*5+1]*lcp->Medicaid2[1][deduct+1][tempIndex]
																						+q[t+1][j*5+2]*lcp->Medicaid2[2][deduct+1][tempIndex]
																						+q[t+1][j*5+3]*lcp->Medicaid2[3][deduct+1][tempIndex]);

			
																						
			if(j==0||deduct==DEDUCTGRID-1)
			lcp->insurance[j][deduct][i]= lcp->insurance[j][deduct][i] + (1/(1+r))*(   q[t+1][j*5+0]*lcp->insurance2[0][deduct][tempIndex]
																					  +q[t+1][j*5+1]*lcp->insurance2[1][deduct][tempIndex]
																					  +q[t+1][j*5+2]*lcp->insurance2[2][deduct][tempIndex]
																					  +q[t+1][j*5+3]*lcp->insurance2[3][deduct][tempIndex]);
		
			else if(j>=1&&deduct<DEDUCTGRID-1)
				lcp->insurance[j][deduct][i]= lcp->insurance[j][deduct][i] + (1/(1+r))*(   q[t+1][j*5+0]*lcp->insurance2[0][deduct+1][tempIndex]
																							+q[t+1][j*5+1]*lcp->insurance2[1][deduct+1][tempIndex]
																							+q[t+1][j*5+2]*lcp->insurance2[2][deduct+1][tempIndex]
																							+q[t+1][j*5+3]*lcp->insurance2[3][deduct+1][tempIndex]);



						
			CalcStruct->Cstream[t][j][deduct][i]=lcp->c[deduct][tempIndex];
			CalcStruct->Astream[t][j][deduct][i]=tempIndex;
			lcp->Vmax[j][deduct][i]=tempVMax;

		}//i,j

		
			memcpy(lcp->V,lcp->Vmax,sizeof(double[4][DEDUCTGRID][MAXGRID]));
			memcpy(lcp->Medicaid2, lcp->Medicaid,sizeof(double [4][DEDUCTGRID][MAXGRID]));
			memcpy(lcp->insurance2,lcp->insurance,sizeof(double [4][DEDUCTGRID][MAXGRID]));


		


	}//t


	if(DEDUCTGRID>=2)
	for(t=DEDUCTGRID-2;t>=0;t--)
	{
		memset(lcp->Medicaid,0,sizeof(double[4][DEDUCTGRID][MAXGRID]));
		memset(lcp->insurance,0,sizeof(double[4][DEDUCTGRID][MAXGRID]));



		for (j=0;j<4;j++)
			for(deduct=0;deduct<DEDUCTGRID;deduct++)
				for(i=0;i<wrow;i++)
				{
					//constraint=A+LTCI[t][j]*Deductile*(deduct+1>=DEDUCTGRID-1)+wdis[i]-M[t][j];
					  constraint=A+wdis[i]-M[t][j];

			if(para.Mcaid==1 &&  constraint < (Cbar2+Wbcar) && constraint-wdis[i]/(1+r) < Cbar2 && j==1)
			{

				if (wdis[i]/(1+r) > Wbcar) wextra = wdis[i]/(1+r) -Wbcar;
				else wextra=0;
				for(k=0;k<wrow;k++)
				{

					lcp->c[deduct][k]=wdis[i]/(1+r) -wdis[k]/(1+r)+Cbar2-wextra;
					if(lcp->c[deduct][k]>0)lcp->zeroind[deduct][k]=0;else {lcp->c[deduct][k]=0.0001;lcp->zeroind[deduct][k]=1;}
				}

				lcp->Medicaid[j][deduct][i]= M[t][j]-wextra-(A+r*wdis[i]/(1+r) -Cbar2);
				lcp->insurance[j][deduct][i] =0;

			}else if(para.Mcaid==1 &&  constraint < (Cbar+Wbcar) &&  constraint-wdis[i]/(1+r)< Cbar && j>1 )
			{

				if (wdis[i]/(1+r) > Wbcar) wextra=wdis[i]/(1+r) -Wbcar;
				else wextra=0;


				lcp->insurance[j][deduct][i] =0;
				lcp->Medicaid[j][deduct][i]= M[t][j]-wextra-(A+r*wdis[i]/(1+r) -Cbar);

				for(k=0;k<wrow;k++)
				{

					lcp->c[deduct][k]=wdis[i]/(1+r) -wdis[k]/(1+r)+Cbar-wextra;
					if(lcp->c[deduct][k]>0) lcp->zeroind[deduct][k]=0;else{lcp->c[deduct][k]=0.0001;lcp->zeroind[deduct][k]=1;}
				}


			}else { // not on medicaid  // LTCI pay for insurance

				for(k=0;k<wrow;k++)
				{
					lcp->c[deduct][k]=wdis[i]-wdis[k]/(1+r) +A +LTCI[t][j]*(j==0)-M[t][j];
					if(lcp->c[deduct][k]>0 && wdis[i]+A-M[t][j]+LTCI[t][j]*(j==0) -lcp->c[deduct][k]>=para.eps)lcp->zeroind[deduct][k]=0;else{lcp->c[deduct][k]=0.0001;lcp->zeroind[deduct][k]=1;}
				}

				lcp->Medicaid[j][deduct][i]=0;
				if (j>=1) lcp->insurance[j][deduct][i]=0;

			}



		 /* Calculate value function for each combination of C(t) and W(t+1), given 
         that you came into this period with w(t) = wdis(i), and health status j */;
         
         /* Note, the only reason it is necessary to do the following if-then statements is
         if we one uses state dependent utility.  */


			switch(j){
			case 0: { consplus=0;phi=para.phi_hc; fn_util(lcp->c[deduct],lcp->zeroind[deduct],lcp->VV[j][deduct],para.crra,consplus,phi);  break;}
			case 1: {  consplus=0;phi=para.phi_alf; fn_util(lcp->c[deduct],lcp->zeroind[deduct],lcp->VV[j][deduct],para.crra,consplus,phi); break;}
					//if(stateFlag==1){ consplus=para.qual_alf*para.beta*HC0[t]; fn_util(c,OUTutil,para.crra,consplus); for(i=0;i<wrow;i++) VV[i][j]=para.phi_alf*OUTutil[i] +zeroind[i]*(-9999) ;}
					//	else {consplus=para.beta*HC0[t];  fn_util(c,OUTutil,para.crra,consplus); for(i=0;i<wrow;i++) VV[i][j]=para.phi_alf*OUTutil[i] +zeroind[i]*(-9999); }}
			case 2: { consplus=para.Food;phi=para.phi_nh; fn_util(lcp->c[deduct],lcp->zeroind[deduct],lcp->VV[j][deduct],para.crra,consplus,phi);break; }

					//if(stateFlag==1){ consplus=para.qual_alf*para.beta*HC0[t]; fn_util(c,OUTutil,para.crra,consplus); for(i=0;i<wrow;i++) VV[i][j]=para.phi_alf*OUTutil[i] +zeroind[i]*(-9999) ;}
					//	else {consplus=para.beta*HC0[t];  fn_util(c,OUTutil,para.crra,consplus); for(i=0;i<wrow;i++) VV[i][j]=para.phi_alf*OUTutil[i] +zeroind[i]*(-9999); }}
			case 3: { consplus=para.Food;phi=para.phi_nh; fn_util(lcp->c[deduct],lcp->zeroind[deduct],lcp->VV[j][deduct],para.crra,consplus,phi); break;}

			}


			for(k=0;k<wrow;k++)
				if(j==0||deduct==DEDUCTGRID-1)
					lcp->VV[j][deduct][k]=lcp->VV[j][deduct][k]+(1/(1+para.rho))*q[t+1][j*5]*lcp->V[0][deduct][k]
																+(1/(1+para.rho))*q[t+1][j*5+1]*lcp->V[1][deduct][k]
																+(1/(1+para.rho))*q[t+1][j*5+2]*lcp->V[2][deduct][k]
																+(1/(1+para.rho))*q[t+1][j*5+3]*lcp->V[3][deduct][k];
				else if(j>=1&&deduct<DEDUCTGRID-1)
					lcp->VV[j][deduct][k]=lcp->VV[j][deduct][k]+(1/(1+para.rho))*q[t+1][j*5]*lcp->V[0][deduct+1][k]
																+(1/(1+para.rho))*q[t+1][j*5+1]*lcp->V[1][deduct+1][k]
																+(1/(1+para.rho))*q[t+1][j*5+2]*lcp->V[2][deduct+1][k]
																+(1/(1+para.rho))*q[t+1][j*5+3]*lcp->V[3][deduct+1][k];

				// +(1/(1+para.d))*q[t+1][j*5+4]*para.beq;


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
				if(j==0||deduct==DEDUCTGRID-1)
					lcp->Medicaid[j][deduct][i] = lcp->Medicaid[j][deduct][i] +  (1/(1+r))*( q[t+1][j*5+0]*lcp->Medicaid2[0][deduct][tempIndex]
				+q[t+1][j*5+1]*lcp->Medicaid2[1][deduct][tempIndex]
				+q[t+1][j*5+2]*lcp->Medicaid2[2][deduct][tempIndex]
				+q[t+1][j*5+3]*lcp->Medicaid2[3][deduct][tempIndex]);

				else if(j>=1&&deduct<DEDUCTGRID-1)
					lcp->Medicaid[j][deduct][i] = lcp->Medicaid[j][deduct][i] +  (1/(1+r))*( q[t+1][j*5+0]*lcp->Medicaid2[0][deduct+1][tempIndex]
				+q[t+1][j*5+1]*lcp->Medicaid2[1][deduct+1][tempIndex]
				+q[t+1][j*5+2]*lcp->Medicaid2[2][deduct+1][tempIndex]
				+q[t+1][j*5+3]*lcp->Medicaid2[3][deduct+1][tempIndex]);



				if(j==0||deduct==DEDUCTGRID-1)
					lcp->insurance[j][deduct][i]= lcp->insurance[j][deduct][i] + (1/(1+r))*(   q[t+1][j*5+0]*lcp->insurance2[0][deduct][tempIndex]
				+q[t+1][j*5+1]*lcp->insurance2[1][deduct][tempIndex]
				+q[t+1][j*5+2]*lcp->insurance2[2][deduct][tempIndex]
				+q[t+1][j*5+3]*lcp->insurance2[3][deduct][tempIndex]);

				else if(j>=1&&deduct<DEDUCTGRID-1)
					lcp->insurance[j][deduct][i]= lcp->insurance[j][deduct][i] + (1/(1+r))*(   q[t+1][j*5+0]*lcp->insurance2[0][deduct+1][tempIndex]
				+q[t+1][j*5+1]*lcp->insurance2[1][deduct+1][tempIndex]
				+q[t+1][j*5+2]*lcp->insurance2[2][deduct+1][tempIndex]
				+q[t+1][j*5+3]*lcp->insurance2[3][deduct+1][tempIndex]);



				CalcStruct->Cstream[t][j][deduct][i]=lcp->c[deduct][tempIndex];
				CalcStruct->Astream[t][j][deduct][i]=tempIndex;
				lcp->Vmax[j][deduct][i]=tempVMax;

				}//i,j


				memcpy(lcp->V,lcp->Vmax,sizeof(double[4][DEDUCTGRID][MAXGRID]));
				memcpy(lcp->Medicaid2, lcp->Medicaid,sizeof(double [4][DEDUCTGRID][MAXGRID]));
				memcpy(lcp->insurance2,lcp->insurance,sizeof(double [4][DEDUCTGRID][MAXGRID]));



	}



		/* This gives you utility as of period 1.  
	 Now go back to period 0 for healthy person. */

	for(deduct=0;deduct<deductgrid;deduct++)
	for (i=0;i<wrow;i++)
	{
		lcp->Vstar[deduct][i]=(1/(1+para.rho)) * ( q[0][0]*lcp->V[0][deduct][i]
										+q[0][1]*lcp->V[1][deduct][i]
										+q[0][2]*lcp->V[2][deduct][i]
										+q[0][3]*lcp->V[3][deduct][i]);

		//Vstar[i]=Vstar[i]+(1/(1+para.d))*(q[0][4]*fn_utilbeq(para.beq));

		lcp->Mstar[deduct][i]=(1/(1+r)) *       ( q[0][0]*lcp->Medicaid2[0][deduct][i]
									+q[0][1]*lcp->Medicaid2[1][deduct][i]
									+q[0][2]*lcp->Medicaid2[2][deduct][i]
									+q[0][3]*lcp->Medicaid2[3][deduct][i]);

		//mstar[i]=Mstar[i]+(1/(1+para.d))*(q[0][4]*fn_utilbeq(para.beq)); 

		lcp->Istar[deduct][i]=(1/(1+r)) *( q[0][0]*lcp->insurance2[0][deduct][i]
							 +q[0][1]*lcp->insurance2[1][deduct][i]
							 +q[0][2]*lcp->insurance2[2][deduct][i]
							 +q[0][3]*lcp->insurance2[3][deduct][i]);
		////mstar[i]=Mstar[i]+(1/(1+para.d))*(q[0][4]*fn_utilbeq(para.beq)); 


	}
	/* protype==1 means want to report optimal value only
	   but  it does not matter, since output both contains 
	   the Vstar & VstarMatrix in Digram*/
	
	wcrit=0;
	
	
	wstart=para.W0*(1+r);

	for(i=0;i<wrow;i++) if (wstart>=wdis[i]) wcrit++;


for(deduct=0;deduct<DEDUCTGRID;deduct++)
	if (wcrit>=wrow)
	{
		Digram->Vstar[deduct]=lcp->Vstar[deduct][wrow-1];
		Digram->Mstar[deduct]=lcp->Mstar[deduct][wrow-1];
		Digram->Istar[deduct]=lcp->Istar[deduct][wrow-1];
	}else
	{
		Digram->Vstar[deduct]=lcp->Vstar[deduct][wcrit-1]+(lcp->Vstar[deduct][wcrit]-lcp->Vstar[deduct][wcrit-1])*((wstart-wdis[wcrit-1])/(wdis[wcrit]-wdis[wcrit-1]));
		Digram->Mstar[deduct]=lcp->Mstar[deduct][wcrit-1]+(lcp->Mstar[deduct][wcrit]-lcp->Mstar[deduct][wcrit-1])*((wstart-wdis[wcrit-1])/(wdis[wcrit]-wdis[wcrit-1]));
		Digram->Istar[deduct]=lcp->Istar[deduct][wcrit-1]+(lcp->Istar[deduct][wcrit]-lcp->Istar[deduct][wcrit-1])*((wstart-wdis[wcrit-1])/(wdis[wcrit]-wdis[wcrit-1]));
	}		


	


	memcpy(Digram->wequiv,wequiv,sizeof(double[DEDUCTGRID]));
	
	free(lcpbuffer);






	}

void calcModel2( int flagLTCI ){
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



	double A;
	double Medicalstar;
	double Medtemp;
	double wequiv;
	
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
		//double Astream[TN][4][MAXGRID];
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

				lcp->Medicaid[j][i]= M[t][j]-wextra-min((double)0,(double)(A+LTCI[t][j]+r*wdis[i]/(1+r) -Cbar2));
				lcp->insurance[j][i] = LTCI[t][j];

			}else if(para.Mcaid==1 &&  A+LTCI[t][j]+wdis[i]-M[t][j] < (Cbar+Wbcar) && A+LTCI[t][j]+r*wdis[i]/(1+r)-M[t][j] < Cbar && j>1 )
			{
				
				if (wdis[i]/(1+r) > Wbcar) wextra=wdis[i]/(1+r) -Wbcar;
				else wextra=0;

				lcp->Medicaid[j][i]= M[t][j]-wextra-min((double)0,(double)(A+LTCI[t][j]+r*wdis[i]/(1+r) -Cbar));
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
			case 0: { consplus=0;phi=para.phi_hc; fn_util(lcp->c,lcp->zeroind,lcp->VV[j],para.crra,consplus,phi);  break;}
			case 1: {  consplus=0;phi=para.phi_alf; fn_util(lcp->c,lcp->zeroind,lcp->VV[j],para.crra,consplus,phi); break;}
					//if(stateFlag==1){ consplus=para.qual_alf*para.beta*HC0[t]; fn_util(c,OUTutil,para.crra,consplus); for(i=0;i<wrow;i++) VV[i][j]=para.phi_alf*OUTutil[i] +zeroind[i]*(-9999) ;}
					//	else {consplus=para.beta*HC0[t];  fn_util(c,OUTutil,para.crra,consplus); for(i=0;i<wrow;i++) VV[i][j]=para.phi_alf*OUTutil[i] +zeroind[i]*(-9999); }}
			case 2: { consplus=para.Food;phi=para.phi_nh; fn_util(lcp->c,lcp->zeroind,lcp->VV[j],para.crra,consplus,phi);break; }

					//if(stateFlag==1){ consplus=para.qual_alf*para.beta*HC0[t]; fn_util(c,OUTutil,para.crra,consplus); for(i=0;i<wrow;i++) VV[i][j]=para.phi_alf*OUTutil[i] +zeroind[i]*(-9999) ;}
					//	else {consplus=para.beta*HC0[t];  fn_util(c,OUTutil,para.crra,consplus); for(i=0;i<wrow;i++) VV[i][j]=para.phi_alf*OUTutil[i] +zeroind[i]*(-9999); }}
			case 3: { consplus=para.Food;phi=para.phi_nh; fn_util(lcp->c,lcp->zeroind,lcp->VV[j],para.crra,consplus,phi); break;}

			}


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
		CalcStruct->AstreamN[t][j][i]=tempIndex;
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

				lcp->Medicaid[j][i]= M[t][j]-wextra-min((double)0,(double)(A+LTCI[t][j]+r*wdis[i]/(1+r) -Cbar2));
				lcp->insurance[j][i] = LTCI[t][j];

			}else if(para.Mcaid==1 &&  A+LTCI[t][j]+wdis[i]-M[t][j] < (Cbar+Wbcar) && A+LTCI[t][j]+r*wdis[i]/(1+r)-M[t][j] < Cbar && j>1 )
			{
			
				if (wdis[i]/(1+r) > Wbcar) wextra=wdis[i]/(1+r) -Wbcar;
				else wextra=0;

				lcp->Medicaid[j][i]= M[t][j]-wextra-min((double)0,(double)(A+LTCI[t][j]+r*wdis[i]/(1+r) -Cbar));
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
			case 0: { consplus=0;phi=para.phi_hc; fn_util(lcp->c,lcp->zeroind,lcp->VV[j],para.crra,consplus,phi);  break;}
			case 1: {  consplus=0;phi=para.phi_alf; fn_util(lcp->c,lcp->zeroind,lcp->VV[j],para.crra,consplus,phi); break;}
					//if(stateFlag==1){ consplus=para.qual_alf*para.beta*HC0[t]; fn_util(c,OUTutil,para.crra,consplus); for(i=0;i<wrow;i++) VV[i][j]=para.phi_alf*OUTutil[i] +zeroind[i]*(-9999) ;}
					//	else {consplus=para.beta*HC0[t];  fn_util(c,OUTutil,para.crra,consplus); for(i=0;i<wrow;i++) VV[i][j]=para.phi_alf*OUTutil[i] +zeroind[i]*(-9999); }}
			case 2: { consplus=para.Food;phi=para.phi_nh; fn_util(lcp->c,lcp->zeroind,lcp->VV[j],para.crra,consplus,phi);break; }

					//if(stateFlag==1){ consplus=para.qual_alf*para.beta*HC0[t]; fn_util(c,OUTutil,para.crra,consplus); for(i=0;i<wrow;i++) VV[i][j]=para.phi_alf*OUTutil[i] +zeroind[i]*(-9999) ;}
					//	else {consplus=para.beta*HC0[t];  fn_util(c,OUTutil,para.crra,consplus); for(i=0;i<wrow;i++) VV[i][j]=para.phi_alf*OUTutil[i] +zeroind[i]*(-9999); }}
			case 3: { consplus=para.Food;phi=para.phi_nh; fn_util(lcp->c,lcp->zeroind,lcp->VV[j],para.crra,consplus,phi); break;}

			}


			
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
			CalcStruct->AstreamN[t][j][i]=tempIndex;
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

	for(i=0;i<wrow;i++) if (wstart>=wdis[i]) wcrit++;


	
		if (wcrit>=wrow)
		{
			
			Digram->MstarNI=lcp->Mstar[wrow-1];
			Digram->IstarNI=lcp->Istar[wrow-1];
		}else
		{
		
			Digram->MstarNI=lcp->Mstar[wcrit-1]+(lcp->Mstar[wcrit]-lcp->Mstar[wcrit-1])*((wstart-wdis[wcrit-1])/(wdis[wcrit]-wdis[wcrit-1]));
			Digram->IstarNI=lcp->Istar[wcrit-1]+(lcp->Istar[wcrit]-lcp->Istar[wcrit-1])*((wstart-wdis[wcrit-1])/(wdis[wcrit]-wdis[wcrit-1]));
		}	

	memcpy(Digram->VstarNI,lcp->Vstar,sizeof(double [MAXGRID]));


	/************************************************************************/
	/* calculate willingness to pay                                         */
	/************************************************************************/


		Vr=0;

		for (i=0;i<wrow;i++) if(Digram->Vstar[0]> Digram->VstarNI[i]) Vr=Vr+1;

		if(Vr==wrow) {cout<<"Grid not big enough!"<<endl;wequiv=-99999;}
		else if(Vr==0){cout<<"Vr==0:  LTCI is worth than losing all financial wealth."<<endl;	wequiv=para.Minf;}
		else if( Digram->VstarNI[Vr]>=Digram->Vstar[0] && Digram->Vstar[0]>=Digram->VstarNI[Vr-1])
		{
			wequiv=wdis[Vr-1]+((Digram->Vstar[0]-Digram->VstarNI[Vr-1])/(Digram->VstarNI[Vr]-Digram->VstarNI[Vr-1]))*(wdis[Vr]-wdis[Vr-1]); 
			wequiv=wequiv/(1+para.r) - para.W0;
		}else{
			cout<<"not correct"<<endl;
			wequiv=-999999;

		



	}

		Digram->wequiv[0]=wequiv;

	

	free(lcpbuffer);





	}

void generaterand(){

	int i,t,j;
	double probmatrix[NSIMUL][TN];




	srand((unsigned)3);


	t=0;
	for(i=0;i<NSIMUL;i++){
		healthstate[i][t]=
			1*(                                                                      probmatrix[i][t]<=q[t][0]                     )+
			2*(probmatrix[i][t]>q[t][0]                                        && probmatrix[i][t]<=q[t][0]+q[t][1]                 )+
			3*(probmatrix[i][t]>q[t][0]+q[t][1]                             && probmatrix[i][t]<=q[t][0]+q[t][1]+q[t][2]            )+
			4*(probmatrix[i][t]>q[t][0]+q[t][1]+q[t][2]                 && probmatrix[i][t]<=q[t][0]+q[t][1]+q[t][2]+q[t][3]        )+
			5*(probmatrix[i][t]>q[t][0]+q[t][1]+q[t][2]+q[t][3]     && probmatrix[i][t]<=q[t][0]+q[t][1]+q[t][2]+q[t][3]+q[t][4]    );
	}


	for (t=1;t<TN;t++){
		if( healthstate[i][t-1]==5)
			healthstate[i][t]=5;
		else{
			healthstate[i][t]=
				1*(                                                                      probmatrix[i][t]<=q[t][0]                                                     )*(healthstate[i][t-1]==1)+
				2*(probmatrix[i][t]>q[t][0]                                         && probmatrix[i][t]<=q[t][0]+q[t][1]                                         )*(healthstate[i][t-1]==1)+
				3*(probmatrix[i][t]>q[t][0]+q[t][1]                             && probmatrix[i][t]<=q[t][0]+q[t][1]+q[t][2]                             )*(healthstate[i][t-1]==1)+
				4*(probmatrix[i][t]>q[t][0]+q[t][1]+q[t][2]                 && probmatrix[i][t]<=q[t][0]+q[t][1]+q[t][2]+q[t][3]                 )*(healthstate[i][t-1]==1)+
				5*(probmatrix[i][t]>q[t][0]+q[t][1]+q[t][2]+q[t][3]     && probmatrix[i][t]<=q[t][0]+q[t][1]+q[t][2]+q[t][3]+q[t][4]     )*(healthstate[i][t-1]==1)+
				1*(                                                                      probmatrix[i][t]<=q[t][5]                                                     )*(healthstate[i][t-1]==2)+
				2*(probmatrix[i][t]>q[t][5]                                         && probmatrix[i][t]<=q[t][5]+q[t][6]                                         )*(healthstate[i][t-1]==2)+
				3*(probmatrix[i][t]>q[t][5]+q[t][6]                             && probmatrix[i][t]<=q[t][5]+q[t][6]+q[t][7]                             )*(healthstate[i][t-1]==2)+
				4*(probmatrix[i][t]>q[t][5]+q[t][6]+q[t][7]                 && probmatrix[i][t]<=q[t][5]+q[t][6]+q[t][7]+q[t][8]                 )*(healthstate[i][t-1]==2)+
				5*(probmatrix[i][t]>q[t][5]+q[t][6]+q[t][7]+q[t][8]     && probmatrix[i][t]<=q[t][5]+q[t][6]+q[t][7]+q[t][8]+q[t][9]    )*(healthstate[i][t-1]==2)+        
				1*(                                                                      probmatrix[i][t]<=q[t][10]                                                    )*(healthstate[i][t-1]==3)+
				2*(probmatrix[i][t]>q[t][10]                                        && probmatrix[i][t]<=q[t][10]+q[t][11]                                       )*(healthstate[i][t-1]==3)+
				3*(probmatrix[i][t]>q[t][10]+q[t][11]                           && probmatrix[i][t]<=q[t][10]+q[t][11]+q[t][12]                          )*(healthstate[i][t-1]==3)+
				4*(probmatrix[i][t]>q[t][10]+q[t][11]+q[t][12]              && probmatrix[i][t]<=q[t][10]+q[t][11]+q[t][12]+q[t][13]             )*(healthstate[i][t-1]==3)+
				5*(probmatrix[i][t]>q[t][10]+q[t][11]+q[t][12]+q[t][13] && probmatrix[i][t]<=q[t][10]+q[t][11]+q[t][12]+q[t][13]+q[t][14])*(healthstate[i][t-1]==3)+         
				1*(                                                                      probmatrix[i][t]<=q[t][15]                                                    )*(healthstate[i][t-1]==4)+
				2*(probmatrix[i][t]>q[t][15]                                        && probmatrix[i][t]<=q[t][15]+q[t][16]                                       )*(healthstate[i][t-1]==4)+
				3*(probmatrix[i][t]>q[t][15]+q[t][16]                           && probmatrix[i][t]<=q[t][15]+q[t][16]+q[t][17]                          )*(healthstate[i][t-1]==4)+
				4*(probmatrix[i][t]>q[t][15]+q[t][16]+q[t][17]              && probmatrix[i][t]<=q[t][15]+q[t][16]+q[t][17]+q[t][18]             )*(healthstate[i][t-1]==4)+
				5*(probmatrix[i][t]>q[t][15]+q[t][16]+q[t][17]+q[t][18] && probmatrix[i][t]<=q[t][15]+q[t][16]+q[t][17]+q[t][18]+q[t][19])*(healthstate[i][t-1]==4)+         
				1*(                                                                      probmatrix[i][t]<=q[t][20]                                                    )*(healthstate[i][t-1]==5)+
				2*(probmatrix[i][t]>q[t][20]                                        && probmatrix[i][t]<=q[t][20]+q[t][21]                                       )*(healthstate[i][t-1]==5)+
				3*(probmatrix[i][t]>q[t][20]+q[t][21]                           && probmatrix[i][t]<=q[t][20]+q[t][21]+q[t][22]                          )*(healthstate[i][t-1]==5)+
				4*(probmatrix[i][t]>q[t][20]+q[t][21]+q[t][22]              && probmatrix[i][t]<=q[t][20]+q[t][21]+q[t][22]+q[t][23]             )*(healthstate[i][t-1]==5)+
				5*(probmatrix[i][t]>q[t][20]+q[t][21]+q[t][22]+q[t][23] && probmatrix[i][t]<=q[t][20]+q[t][21]+q[t][22]+q[t][23]+q[t][24])*(healthstate[i][t-1]==5);  
		}

	}	







}




void simulate(){
	/************************************************************************/
	/* simulate to calculate both Mstar and Istarown  medicad 
	expenditure and insurance benefit										*/
	/************************************************************************/
	
	int i,j,t,iniW,k;
	int    wrow;
	int nsimul,deductgrid;
	
	double N,W0,A;  //total individual to simulate;
	double constraint;
	double Cbar2,Wbcar,Cbar;
	double r,wextra;
	double sum_Medicaid,sum_insurance,sum_medcost,sum_MUedicaid;
	double sum_testins,sum_testmed;
	typedef struct{
	int	   curWW[NSIMUL];
	int	   nextWW[NSIMUL];
	int    nextWW2[NSIMUL];
	int    curWW2[NSIMUL];
	//int	   healthstate[NSIMUL];
	int    deductstate[NSIMUL];
	double MUedicaid[NSIMUL];
	double Medcost[NSIMUL];
	double Medicaid[NSIMUL];
	double insurance[NSIMUL];
	//double testins[NSIMUL];
	//double testmedcost[NSIMUL];
	} SIMULATE;

	double rfactor[TN];

	double (*LTCI)[5];
	double (*M)[5];
	double (*B)[5];

	SIMULATE *s;
	void *sbuffer;

	//srand((unsigned)3);
	rfactor[0]=1+para.r;
	for (i=1;i<TN;i++) rfactor[i]=rfactor[i-1]*(1+para.r);

	//initial wealth:
	W0=para.W0;
	for (i=110;i<wrow;i++) if(wdis[i]>=W0){iniW=i;break;}
	

	sbuffer = malloc( sizeof(SIMULATE));
	if(sbuffer==NULL) {cout<<"LOCALSTRUCT allocation is failed"<<endl; system("pause"); exit(0);}
	s= (SIMULATE *) sbuffer;
	memset(s,0,sizeof(SIMULATE));

	r=para.r;
	Cbar=para.Cbar;
	Cbar2=para.Cbar2;
	Wbcar=para.Wbar;
	nsimul=NSIMUL;
	deductgrid=DEDUCTGRID;

	M=CalcStruct->M;
	B=CalcStruct->B;
	A=CalcStruct->A;
	wrow=para.wrow;
	sum_insurance=0;sum_Medicaid=0;sum_medcost=0;sum_MUedicaid=0;sum_testins=0;sum_testmed=0;
	LTCI=CalcStruct->LTCIown;
	
	memset(s->curWW,iniW,sizeof(int [NSIMUL]));

	for(j=0;j<NSIMUL;j++) s->curWW[j]=iniW;
	
for(t=0;t<TN;t++){
	//for(i=0;i<NSIMUL;i++) healthstate[i]=0+(int)4*rand()/(RAND_MAX+1);
	for(i=0;i<NSIMUL;i++) 
		if(healthstate[i][t]!=4){

		
		
	



	//s->testins[i]=s->testins[i]+B[t][healthstate[i][t]]/rfactor[t];
	//s->testmedcost[i]=s->testmedcost[i]+M[t][healthstate[i][t]]/rfactor[t];
	
		//first part is insurance 
		
	constraint=A+LTCI[t][healthstate[i][t]]*(s->deductstate[i]+1>=deductgrid-1)+wdis[s->curWW[i]]-M[t][healthstate[i][t]];

	if(para.Mcaid==1 &&  constraint < (Cbar2+Wbcar) && constraint-wdis[s->curWW[i]]/(1+r) < Cbar2 && healthstate[i][t]==1)
	{

		if (wdis[s->curWW[i]]/(1+r) > Wbcar) wextra = wdis[s->curWW[i]]/(1+r) -Wbcar;
		else wextra=0;

		s->nextWW[i]=CalcStruct->Astream[t][healthstate[i][t]][s->deductstate[i]][s->curWW[i]];
		//lcp->c[deduct][i]=wdis[i]/(1+r) -wdis[k]/(1+r)+Cbar2-wextra;
		s->Medcost[i]=s->Medcost[i]+(1 / rfactor[t])*M[t][healthstate[i][t]];
		//medicaid may be sheilded by insurance
		s->Medicaid[i]=s->Medicaid[i]+ (1 / rfactor[t])*(M[t][healthstate[i][t]]-wextra-(A+LTCI[t][healthstate[i][t]]*(s->deductstate[i]+1>=deductgrid-1)+r*wdis[s->curWW[i]]/(1+r) -Cbar2));
		if(s->deductstate[i]+1>=deductgrid-1)s->insurance[i] =s->insurance[i] + (1/rfactor[t])*LTCI[t][healthstate[i][t]];

	}else if(para.Mcaid==1 &&  constraint < (Cbar+Wbcar) &&  constraint-wdis[s->curWW[i]]/(1+r)< Cbar && healthstate[i][t] > 1 )
	{

		if (wdis[s->curWW[i]]/(1+r) > Wbcar) wextra=wdis[s->curWW[i]]/(1+r) -Wbcar;
		else wextra=0;

		s->nextWW[i]=CalcStruct->Astream[t][healthstate[i][t]][s->deductstate[i]][s->curWW[i]];

		if(s->deductstate[i]+1>=deductgrid-1)s->insurance[i] =s->insurance[i]+ (1/rfactor[t])*LTCI[t][healthstate[i][t]];
		s->Medicaid[i]= s->Medicaid[i] +(1/rfactor[t])*( M[t][healthstate[i][t]]-wextra-(A+LTCI[t][healthstate[i][t]]*(s->deductstate[i]+1>=deductgrid-1)+r*wdis[s->curWW[i]]/(1+r) -Cbar));
		s->Medcost[i]=s->Medcost[i]+(1/rfactor[t])*M[t][healthstate[i][t]];

			//lcp->c[deduct][k]=wdis[i]/(1+r) -wdis[k]/(1+r)+Cbar-wextra;
		


	}
	else { // not on medicaid  // LTCI pay for insurance

		
			//lcp->c[deduct][k]=wdis[i]-wdis[k]/(1+r) +A +LTCI[t][healthstate]*(healthstate==0 ||(deduct+1>=DEDUCTGRID-1)&&healthstate!=0)-M[t][healthstate];
		s->nextWW[i]=CalcStruct->Astream[t][healthstate[i][t]][s->deductstate[i]][s->curWW[i]];
		if (healthstate[i][t]>=1) s->insurance[i]=s->insurance[i] + (1/rfactor[t])*LTCI[t][healthstate[i][t]]*(s->deductstate[i]+1>=deductgrid-1);
		s->Medcost[i]=s->Medcost[i]+(1/rfactor[t])*M[t][healthstate[i][t]];
	}

	if (healthstate[i][t] >0 && healthstate[i][t] < 4 ) {if (s->deductstate[i]+1<deductgrid-1) s->deductstate[i]=s->deductstate[i]+1; }
	s->curWW[i]=s->nextWW[i];


	}

}

//second part is without insurance
gridsetup(0);
for(j=0;j<NSIMUL;j++) s->curWW2[j]=iniW;



for(t=0;t<TN;t++){
	//for(i=0;i<NSIMUL;i++) healthstate[i]=0+(int)4*rand()/(RAND_MAX+1);
	for(i=0;i<NSIMUL;i++) if(healthstate[i][t]!=4){



constraint=A+wdis[s->curWW2[i]]-M[t][healthstate[i][t]];

if(para.Mcaid==1 &&  constraint < (Cbar2+Wbcar) && constraint-wdis[s->curWW2[i]]/(1+r) < Cbar2 && healthstate[i][t]==1)
{

	if (wdis[s->curWW2[i]]/(1+r) > Wbcar) wextra = wdis[s->curWW2[i]]/(1+r) -Wbcar;
	else wextra=0;

	s->nextWW2[i]=CalcStruct->AstreamN[t][healthstate[i][t]][s->curWW2[i]];

	//medicaid may be sheilded by insurance
	s->MUedicaid[i]=s->MUedicaid[i]+ (1 / rfactor[t])*(M[t][healthstate[i][t]]-wextra-(A+r*wdis[s->curWW2[i]]/(1+r) -Cbar2));

}else if(para.Mcaid==1 &&  constraint < (Cbar+Wbcar) &&  constraint-wdis[s->curWW2[i]]/(1+r)< Cbar && healthstate[i][t] > 1 )
{

	if (wdis[s->curWW2[i]]/(1+r) > Wbcar) wextra=wdis[s->curWW2[i]]/(1+r) -Wbcar;
	else wextra=0;

	s->nextWW2[i]=CalcStruct->AstreamN[t][healthstate[i][t]][s->curWW2[i]];
	s->MUedicaid[i]= s->MUedicaid[i] +(1/rfactor[t])*( M[t][healthstate[i][t]]-wextra-(A+r*wdis[s->curWW2[i]]/(1+r) -Cbar));



}
else { // not on medicaid  // LTCI pay for insurance


//lcp->c[deduct][k]=wdis[i]-wdis[k]/(1+r) +A +LTCI[t][healthstate]*(healthstate==0 ||(deduct+1>=DEDUCTGRID-1)&&healthstate!=0)-M[t][healthstate];
s->nextWW2[i]=CalcStruct->AstreamN[t][healthstate[i][t]][s->curWW2[i]];

}


s->curWW2[i]=s->nextWW2[i];
	
	}
}

// average the result: Medicaid insurance 

 for(i=0;i<NSIMUL;i++){
	 sum_insurance= s->insurance[i]+sum_insurance;
	 sum_Medicaid=sum_Medicaid+ s->Medicaid[i];
	 sum_MUedicaid=sum_MUedicaid+ s->MUedicaid[i];
	 
	 
	 sum_medcost=sum_medcost+s->Medcost[i];

	 //sum_testins=sum_testins+s->testins[i];
	 //sum_testmed=sum_testmed+s->testmedcost[i];

    }

	  sum_insurance=sum_insurance/nsimul;
	  sum_Medicaid=sum_Medicaid/nsimul;
	  sum_MUedicaid=sum_MUedicaid/nsimul;
	  sum_medcost=sum_medcost/nsimul;
	  //sum_testins=sum_testins/nsimul;
	  //sum_testmed=sum_testmed/nsimul;


	  Digram->MMstar=sum_Medicaid;
	  Digram->IIstar=sum_insurance;
	  Digram->Medcost=sum_medcost;
	  Digram->MUstar=sum_MUedicaid;
	  free(sbuffer);

}


void willtopay(int gender){
	/*this function is aimed to draw the plot of willingness to pay and compute implicit tax
	in this function , I will calculate 9 point of payment 
	*/


	int i,j,k,t;
	int Vr,deduct;

	int wealthpercentil;// simulate number 
	int  LTCIflag;
	double X;
	double EPDVMedical,EPDVMedical2;
	double MUstar,Mstar;
	double Istarown,Istarnone;
	


	double wequiv[10][DEDUCTGRID];  // final point value to compute  

	time_t time_began,time_end;

	/*initialize */

	memset(wequiv,0,sizeof(double[DEDUCTGRID][10]));

	/************************************************************************/
	/*calculate V* Astream Cstream and Medicaid of different wealth percentil*/
	/************************************************************************/




	//for(wealthpercentil=3;wealthpercentil<10;wealthpercentil++)
	wealthpercentil=9;
	{
		time_began=time(NULL);
		/*calculate preparation*/
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
		para.wealth=para.wealth*224.937/172.192;

		para.W0=para.wealth*(1-para.alpha)/X;   



			
			
		
			/*calculate Model*/
			//grid setup
			//flag indicate whether the situation Has LTCI insurance or Not
			//flag ==1 indicate: LTCI has ; flag == 0 indicate LTCI do not have

 			deduflag=1;
			calcPrep(gender);
			gridsetup(0);
			calcModel(1);

			deduflag=0;	
			calcPrep(gender);
			gridsetup(0);

			calcModel2(0);
			{MUstar=Digram->MstarNI;Istarnone=Digram->IstarNI;}

			

 		//	for(i=0;i<DEDUCTGRID;i++)
 		//	{Mstar[i]=Digram->Mstar[i];Istarown[i]=Digram->Istar[i];wequiv[wealthpercentil][i]=Digram->wequiv[i];}
			//EPDVMedical=Digram->Medicalstar;
			
			Mstar=Digram->Mstar[0];EPDVMedical=Digram->Medicalstar;Istarown=Digram->Istar[0];
			//simulate();

		time_end=time(NULL);

		//cur_time();
		cout<<"*********************************************************************"<<endl;
		cout<<"this is the wealthpercentile"<<wealthpercentil<<endl;
		cout<<"time consuming is (minute)"<<(time_end-time_began)/60<<endl;
		cout<<"Medicaid share of EPDV of total LTC Exp (No private ins)		column 1"<<endl; 
		cout<<MUstar/EPDVMedical<<endl;
		cout<<"simulate"<<endl;
		cout<<Digram->MUstar/Digram->Medcost<<endl;
		cout<<"Medicaid share of EPDV of total LTC Exp (With private ins)	column 2"<<endl;
		cout<<Mstar/EPDVMedical<<endl;
		cout<<"simulate"<<endl;
		cout<<Digram->MMstar/Digram->Medcost<<endl;
		cout<<"implicit tax													column 3 "<<endl; 
		cout<<(MUstar - Mstar)/Istarown<<endl;
		cout<<"simulate"<<endl;
		cout<<(Digram->MUstar-Digram->MMstar)/Digram->IIstar<<endl;
		cout<<"Net load														column 4"<<endl; 
		cout<<(1-(Istarown-(MUstar-Mstar))/(Istarown/para.MW))<<endl;
		cout<<"simulate"<<endl;
		cout<<(1-(Digram->IIstar-(Digram->MUstar-Digram->MMstar))/(Digram->IIstar/para.MW))<<endl;

		cout<<"the wequiv is :"<<endl;

		cout<<Digram->wequiv[0]<<endl;

		cout<<"*********************************************************************"<<endl;

		/*delete dynamic index*/
		writeresult(wealthpercentil,gender);
			
	}
	





	
	

	/**/




	


}


void writeresult(int wealthpercentil ,int gender){
	int i,j;
	double EPDVMedical,EPDVMedical2;
	double MUstar,Mstar[1];
	double Istarown[1],Istarnone;



	double wequiv[1];  // final point value to compute  
	

	
	{MUstar=Digram->MstarNI;Istarnone=Digram->IstarNI;}
	i=0;
	{Mstar[i]=Digram->Mstar[i];Istarown[i]=Digram->Istar[i];wequiv[i]=Digram->wequiv[i];}
	
	EPDVMedical=Digram->Medicalstar;


// 	switch(gender){
// 	case 1:{ofstream out("female.txt");break;}
// 	case 2:{ofstream out("male.txt");break;}
// 	default:{cout<<"fail to open file"<<endl;break;}
// 	
// 	}
	if(gender==0){
		ofstream out("female.txt", ios::app);
		if (out.is_open())   
		{  

			out<<"*********************************************************************"<<endl;
			out<<"this is the wealthpercentile"<<wealthpercentil<<endl;

			out<<"Medicaid share of EPDV of total LTC Exp (No private ins)		column 1"<<endl; 
			out<<MUstar/EPDVMedical<<endl;	
			out<<"Medicaid share of EPDV of total LTC Exp (With private 6m deduct ins)	column 2"<<endl;



			out<<Digram->Mstar[0]/EPDVMedical<<"/t";
			
			out<<endl;

			out<<"simulate"<<endl;
			out<<Digram->MMstar/EPDVMedical<<endl;

			out<<"implicit tax													column 3 "<<endl; 

	
			out<<(MUstar - Mstar[0])/Istarown[0]<<"\t";
			
			out<<endl;

			out<<"simulate"<<endl;
			out<<(MUstar-Digram->MMstar)/Digram->IIstar<<endl;



			out<<"Net load														column 4"<<endl; 

				
			out<<(1-(Istarown[0]-(MUstar-Mstar[0]))/(Istarown[0]/para.MW))<<"\t";
			
			out<<endl;


			out<<"simulate"<<endl;
			out<<(1-(Digram->IIstar-(MUstar-Digram->MMstar))/(Digram->IIstar/para.MW))<<endl;

			out<<"the wequiv is :"<<endl;


				
			out<<wequiv[0]<<"\t";
			

			out<<endl;


			out<<"*********************************************************************"<<endl;

			out.close();  
		}  

	}else{
		ofstream out("male.txt", ios::app);
		if (out.is_open())   
		{  
			out<<"_______________________________________________________________________________"<<endl;
			out<<"_______________________________________________________________________________"<<endl;
			out<<"______________________________________new______________________________________"<<endl;
			out<<"_______________________________________________________________________________"<<endl;
			out<<"*********************************************************************"<<endl;
			out<<"this is the wealthpercentile"<<wealthpercentil<<endl;

			out<<"Medicaid share of EPDV of total LTC Exp (No private ins)		column 1"<<endl; 
			out<<MUstar/EPDVMedical<<endl;	
			out<<"Medicaid share of EPDV of total LTC Exp (With private 6m deduct ins)	column 2"<<endl;



			out<<Digram->Mstar[0]/EPDVMedical<<"/t";

			out<<endl;

			out<<"simulate"<<endl;
			out<<Digram->MMstar/EPDVMedical<<endl;

			out<<"implicit tax													column 3 "<<endl; 


			out<<(MUstar - Mstar[0])/Istarown[0]<<"\t";

			out<<endl;

			out<<"simulate"<<endl;
			out<<(MUstar-Digram->MMstar)/Digram->IIstar<<endl;



			out<<"Net load														column 4"<<endl; 


			out<<(1-(Istarown[0]-(MUstar-Mstar[0]))/(Istarown[0]/para.MW))<<"\t";

			out<<endl;


			out<<"simulate"<<endl;
			out<<(1-(Digram->IIstar-(MUstar-Digram->MMstar))/(Digram->IIstar/para.MW))<<endl;

			out<<"the wequiv is :"<<endl;



			out<<wequiv[0]<<"\t";


			out<<endl;


			out<<"*********************************************************************"<<endl;

			out.close();  
		}  
	}
	
	
}