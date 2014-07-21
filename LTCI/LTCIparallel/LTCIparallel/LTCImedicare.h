#include <iostream>
#include <math.h>
#include <fstream>
#include <sstream>
#include <string>
#include <malloc.h>
#include <ppl.h>
#include <io.h>
#include <string>
#include <time.h>



using namespace std;
using namespace Concurrency;

  
#define TN 480
#define MAXGRID 2020
#define WEALTHPERCENTIL 10
#define DEDUCTGRID 1
#define NSIMUL		10000


//market load choose (male): 0 :0.5; 1: 0.3; 2:0.6; 3: 0.6; 4: 0
#define START 3



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

	double alpha;    //alpha is the fraction of total wealth annuitized 
	double wealth;   //wx is used purely to adjust upper bound of grid for discretization
	double wx;       //if LTCI value gets high (e.g., higher risk aversion), adjust wx up
	int    grid;     //grid = grid size used for discretization.
	int    wrow;     //total grid size row


	double W0;       //starting wealth pure asset;

	double Wdis[MAXGRID];

	//double **qfi;  //col 1 is age.  col 2 through 26 are  transition probs from state i to j
	double hcexp[TN]; // home care expense column 1 expenses

	double HC0[TN];    //HCutil is the amount of non-skilled NH care received, regardless of payer
	double Prob[492][5]; //unconditional tranzation probability


	double M[TN][5];   //M = medical expenditure matrix
	double B[TN][5];   //B = Benefit matrix 
	double P[TN][5];   //P = Premium matrix
	double A;   //A = annuity amount income 
	//Rows are periods, cols are states
	int Astream[DEDUCTGRID][TN][4][MAXGRID];
	int AstreamN[1][TN][4][MAXGRID];
	double Cstream[DEDUCTGRID][TN][4][MAXGRID];

	double LTCIown[TN][5]; //the net payment to the policy holder. 

} CALCSTRUCT;


struct DIGRAM{
	double Medicalstar;
	double MstarNI;
	double IstarNI;

	double MMstar;
	double IIstar;
	double MUstar;
	double Medcost;

	double VstarNI[MAXGRID];
	double Vstar;	
	double Mstar;
	double Istar;
	double wequiv;
	double S_wequiv;

};








class Parallel_LTCI{

	friend void Setup(Parallel_LTCI *LTCI);
	friend void inData(int gender , Parallel_LTCI *LTCI );
	friend void record_result(int wealthpercentile ,Parallel_LTCI *LTCI);
	
private:

	int				wealthpercentile;
	int				gender;
	int				flag;
	PARA			para;
	CALCSTRUCT		CalcStruct;
	DIGRAM			Digram;
	int				Deductile[20];
	int				deductgrid;
	time_t			time_began,time_end;

public:
	Parallel_LTCI(int _wealthdistribute = 3, int _gender = 0, int _deductgrid = 1, int _wealth = 126875, int _wx=30000,int _grid = 75, double _alpha = 0.82);
	~Parallel_LTCI(){cout<<"de construct the object"<<endl;};
	void calcModel(int wealthdistribute,bool NIflag);
	void gridsetup(int flag, int wealthpercentile);
	void calcPrep(int gender,int wealthpercentile, int priflag);
	void simulate(int wealthpercentile);
	void writeresult(int wealthpercentile ,int gender);
	void outprint();
	void fn_util(double *Cons,double *zeroind,double* OUTutil,double crra,double Consplus,double phi);
	void comput();
	void cur_time();
};





