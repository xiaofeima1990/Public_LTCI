#include "LTCIparallel.h"

extern int    healthstate[NSIMUL][TN];
extern double q[TN+12][25];



extern PARA para;
extern CALCSTRUCT CalcStructv;


void calcSetup(){

	
	int i;
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

	para.Food=0.644;      //Food = SSI level used to parameterize food/housing benefit

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
		char hcexprobc[20];

		char filename[60];
		char stringline[1000];


		double qti[47][25];
		double hcexprob,lama;
		double hcexp0[77];
		double hcexp1[77];


		double hcexp[77];


		double (*Prob)[5];  //unconditional probability



		

		Prob=CalcStructv.Prob;

		// qfi qmi hcexp1mi65 hcexp1fi65 hcexp0mi65 hcexp0fi65

		memset(hcexp0,0,sizeof(double[77]));
		memset(hcexp1,0,sizeof(double[77]));
		memset(hcexp,0,sizeof(double[77]));
		memset(stringline,0,sizeof(char(400)));

		memset(qti,0,sizeof(double[47][25]));

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
				CalcStructv.hcexp[i+j*12]=hcexp[j+30];
				//CalcStruct->hcexpm[i+j*12]=hcexpm[j];
				CalcStructv.HC0  [i+j*12]=hcexp0[j+30]+hcexp1[j+30];
				//CalcStruct->HC0m  [i+j*12]=hcexp0m[j]+hcexp1m[j];
			}

		}



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


		
			

		

	}





extern void Setup(Parallel_LTCI *LTCI){

  memcpy(&(LTCI->para),&para,sizeof(PARA));
}


extern void inData(int gender,Parallel_LTCI *LTCI){

	memcpy(&(LTCI->CalcStruct.hcexp),&CalcStructv.hcexp,sizeof(double[TN]));
	memcpy(&(LTCI->CalcStruct.HC0),&CalcStructv.HC0,sizeof(double[TN]));
	memcpy(&(LTCI->CalcStruct.Prob),&CalcStructv.Prob,sizeof(double[TN+12][5]));


}


void cur_time(void)
{
	char *wday[]={"星期天","星期一","星期二","星期三","星期四","星期五","星期六"};
	time_t timep;
	struct tm *p;
	time(&timep);
	p=localtime(&timep); /* 获取当前时间 */
	printf("%d 年 %02d 月 %02d 日",(1900+p->tm_year),(1+p->tm_mon),p->tm_mday);
	printf("%s %02d : %02d : %02d \n",wday[p->tm_wday],p->tm_hour,p->tm_min,p->tm_sec);
}


int main(){
		int gender;
		int wealthpercentile;
		int i,j;
		int deductgrid;
		int wealth;
		int wx;
		int grid;
		double alpha;
		int offset;
		task_group tasks;

		time_t time_began,time_end;

		//memset(&CalcStruct[0],0,sizeof(CALCSTRUCT));

		gender=1;				//0 is female 1 is male
		deductgrid=DEDUCTGRID;
		//wealthpercentile=3;		//0-9 different wealth distribution 


		/*
		calculating declaration:
		this time run for gird*4 total size 
		from 4-8
		so the program make some adjustment
		
		*/


		cout<<"calculating declaration: this time run for gird*4 total size from 4-8 \n so the program make some adjustment"<<endl;




				
		cur_time();
		offset =4;

		Parallel_LTCI  *LTCI[5];

		
		{
			

		for(gender=1;gender<2;gender++){
		// initilize the class of LTCI 
		for(wealthpercentile=4;wealthpercentile<9;wealthpercentile ++)
		{
		switch (wealthpercentile){
		case 0: wealth=40000;	alpha=0.98;	wx=0;		grid=20;	break;
		case 1: wealth=58450;	alpha=0.98;	wx=0;		grid=20;	break;
		case 2: wealth=93415;	alpha=0.91;	wx=20000;	grid=40;	break;
		case 3: wealth=126875;	alpha=0.82;	wx=30000;	grid=75;	break;
		case 4: wealth=169905;	alpha=0.70;	wx=10000;	grid=100;	break;
		case 5: wealth=222570;	alpha=0.60;	wx=50000;	grid=130;	break;
		case 6: wealth=292780;	alpha=0.52;	wx=20000;	grid=175;	break;
		case 7: wealth=385460;	alpha=0.41;	wx=40000;	grid=225;	break;
		case 8: wealth=525955;	alpha=0.35;	wx=40000;	grid=300;	break;
		case 9: wealth=789475;	alpha=0.26;	wx=75000;	grid=450;	break;


		}
		wealth =wealth*224.937/172.792;


		LTCI[int(wealthpercentile)-offset]=new Parallel_LTCI(wealthpercentile,gender,deductgrid,wealth,wx,grid,alpha);
		

		}
		

			calcSetup();
			inputData(gender);


			for(i=0;i<9-offset;i++){
				Setup(LTCI[i]);
				inData(gender,LTCI[i]);

			}



		cout<<"calculating for 0:female 1: male ------"<<gender<<endl;
		cout<<"deductile period is : \t"<<deductgrid<<endl;
		cout<<"**********************************************"<<endl;
		cout<<"**********************************************"<<endl;




		/*task for 1 to 4*/
		
		//tasks.run([&gender,&LTCI,&offset](){
		//	    int wealthpercentile=4-offset; 
		//	//for(int wealthpercentile=4-offset;wealthpercentile<5-offset;wealthpercentile++)
		//		LTCI[wealthpercentile]->comput();



		//});

		/*task for  5*/
	
			tasks.run([&gender,&LTCI,&offset](){
				int wealthpercentile=5-offset; 				
				LTCI[wealthpercentile]->comput();

				});

		/*task for  6*/
			tasks.run([&gender,&LTCI,&offset](){
				int wealthpercentile=6-offset; 				
				LTCI[wealthpercentile]->comput();

			});


			/*task for 7*/
			tasks.run([&gender,&LTCI,&offset](){
				int wealthpercentile=7-offset;
				
				LTCI[wealthpercentile]->comput();
			});

			/*task for 8*/
			tasks.run_and_wait([&gender,&LTCI,&offset](){
				int wealthpercentile=8-offset;

				LTCI[wealthpercentile]->comput();
			});


			/*task for 8 to 9*/
			//tasks.run_and_wait([&gender,&LTCI](){
			//	int wealthpercentile=9;			
			//	LTCI[wealthpercentile]->comput();			

			//});


		}
		

		for(i=0;i<10-offset-1;i++) delete LTCI[i];


	}



		system("pause");
		return 0;


	}













//void willtopay(int gender){
//		/*this function is aimed to draw the plot of willingness to pay and compute implicit tax
//		in this function , I will calculate 9 point of payment 
//		*/
//
//
//		int i,j,k,t;
//		int Vr,deduct;
//
//		int wealthpercentile;// simulate number
//		int priflag;
//		int  LTCIflag;
//		double X;
//		double EPDVMedical,EPDVMedical2;
//		double MUstar,Mstar;
//		double Istarown,Istarnone;
//
//		CALCSTRUCT *CalcStruct;
//
//		//double wequiv[10][DEDUCTGRID];  // final point value to compute  
//
//		time_t time_began,time_end;
//
//
//		task_group tasks;
//		
//
//		//memset(wequiv,0,sizeof(double[DEDUCTGRID][10]));
//
//		/************************************************************************/
//		/*calculate V* Astream Cstream and Medicaid of different wealth percentil*/
//		/************************************************************************/
//
//
//		
//
//		time_began=time(NULL);
//
//		priflag=0;
//
//		/*task for 1 to 4*/
//
//		tasks.run([&gender,&wealthpercentile,&priflag,&CalcStruct](){
//			int X;
//			
//			for(wealthpercentile=0;wealthpercentile<5;wealthpercentile++){
//				CalcStruct=&CalcStructv[wealthpercentile];
//				switch (wealthpercentile){
//				case 0: CalcStruct->wealth=40000;	CalcStruct->alpha=0.98;	CalcStruct->wx=0;		CalcStruct->grid=20;	break;
//				case 1: CalcStruct->wealth=58450;	CalcStruct->alpha=0.98;	CalcStruct->wx=0;		CalcStruct->grid=20;	break;
//				case 2: CalcStruct->wealth=93415;	CalcStruct->alpha=0.91;	CalcStruct->wx=20000;	CalcStruct->grid=40;	break;
//				case 3: CalcStruct->wealth=126875;	CalcStruct->alpha=0.82;	CalcStruct->wx=30000;	CalcStruct->grid=75;	break;
//				case 4: CalcStruct->wealth=169905;	CalcStruct->alpha=0.70;	CalcStruct->wx=10000;	CalcStruct->grid=100;	break;
//
//				}
//				X=1000;
//				CalcStruct->W0=CalcStruct->wealth*(1-CalcStruct->alpha)/X;   
//
//				prar_Calcu(gender,wealthpercentile,priflag);
//			
//			}
//			
//			
//		
//		
//		
//		});
//
//		/*task for 5 to 6*/
//
//		tasks.run_and_wait([&gender,&wealthpercentile,&priflag,&CalcStruct](){
//			int X;
//
//			for(wealthpercentile=5;wealthpercentile<7;wealthpercentile++){
//				CalcStruct=&CalcStructv[wealthpercentile];
//				switch (wealthpercentile){
//				case 5: CalcStruct->wealth=222570;	CalcStruct->alpha=0.60;	CalcStruct->wx=50000;	CalcStruct->grid=130;	break;
//				case 6: CalcStruct->wealth=292780;	CalcStruct->alpha=0.52;	CalcStruct->wx=20000;	CalcStruct->grid=175;	break;
//
//				}
//				X=1000;
//				CalcStruct->W0=CalcStruct->wealth*(1-CalcStruct->alpha)/X;   
//
//				prar_Calcu(gender,wealthpercentile,priflag);
//
//			}
//
//
//		});
//
		/*task for 7*/

		//tasks.run([&gender,&wealthpercentile,&priflag](){
		//	int X;
		//wealthpercentile=7;
		//CalcStruct=&CalcStructv[wealthpercentile];
		//	CalcStruct->wealth=385460;	CalcStruct->alpha=0.41;	CalcStruct->wx=40000;	CalcStruct->grid=225;
		//	X=1000;
		//	CalcStruct->W0=CalcStruct->wealth*(1-CalcStruct->alpha)/X;   

		//	prar_Calcu(gender,wealthpercentile,priflag);


		//});

		///*task for 8*/

		//tasks.run([&gender,&wealthpercentile,&priflag](){
		//	int X;
		//wealthpercentile=8;
		//CalcStruct=&CalcStructv[wealthpercentile];
		//	CalcStruct->wealth=525955;	CalcStruct->alpha=0.35;	CalcStruct->wx=40000;	CalcStruct->grid=300;
		//	X=1000;
		//	CalcStruct->W0=CalcStruct->wealth*(1-CalcStruct->alpha)/X;   

		//	prar_Calcu(gender,wealthpercentile,priflag);


		//});

		///*task for 9*/

		//tasks.run_and_wait([&gender,&wealthpercentile,&priflag](){
		//	int X;
		//wealthpercentile=9;
		//CalcStruct=&CalcStructv[wealthpercentile];
		//	CalcStruct->wealth=789475;	CalcStruct->alpha=0.26;	CalcStruct->wx=75000;	CalcStruct->grid=450;
		//	X=1000;
		//	CalcStruct->W0=CalcStruct->wealth*(1-CalcStruct->alpha)/X;   

		//	prar_Calcu(gender,wealthpercentile,priflag);


		//});

		
		//time_end=time(NULL);


		////for(wealthpercentil=0;wealthpercentil<10;wealthpercentil++)
		//wealthpercentile=3;
		//{
		//	time_began=time(NULL);
		//	/*calculate preparation*/
		//	/*wealth percentil and wealth grid initialization */

		//	

		//	switch (wealthpercentile){
		//	case 0: para.wealth=40000;	para.alpha=0.98;	para.wx=0;		para.grid=20;	break;
		//	case 1: para.wealth=58450;	para.alpha=0.98;	para.wx=0;		para.grid=20;	break;
		//	case 2: para.wealth=93415;	para.alpha=0.91;	para.wx=20000;	para.grid=40;	break;
		//	case 3: para.wealth=126875;	para.alpha=0.82;	para.wx=30000;	para.grid=75;	break;
		//	case 4: para.wealth=169905;	para.alpha=0.70;	para.wx=10000;	para.grid=100;	break;
		//	case 5: para.wealth=222570;	para.alpha=0.60;	para.wx=50000;	para.grid=130;	break;
		//	case 6: para.wealth=292780;	para.alpha=0.52;	para.wx=20000;	para.grid=175;	break;
		//	case 7: para.wealth=385460;	para.alpha=0.41;	para.wx=40000;	para.grid=225;	break;
		//	case 8: para.wealth=525955;	para.alpha=0.35;	para.wx=40000;	para.grid=300;	break;
		//	case 9: para.wealth=789475;	para.alpha=0.26;	para.wx=75000;	para.grid=450;	break;


		//	}


		//	



		//	calcPrep(gender,wealthpercentile,priflag);
		//	gridsetup(0,wealthpercentile);

		//	calcModelNI(wealthpercentile);
		////	{MUstar=Digram->MstarNI;Istarnone=Digram->IstarNI;}

		//	calcPrep(gender,wealthpercentile,priflag);
		//	gridsetup(1,wealthpercentile);
		//	calcModel(wealthpercentile);



		//	/*Mstar=Digram->Mstar[0];EPDVMedical=Digram->Medicalstar;Istarown=Digram->Istar[0];*/
		//	simulate(wealthpercentile);

			//time_end=time(NULL);


			/*cout<<"*********************************************************************"<<endl;
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

			cout<<"*********************************************************************"<<endl;*/

			/*delete dynamic index*/


		//}


	//}


