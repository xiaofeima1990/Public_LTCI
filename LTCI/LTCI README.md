
#about LTCI model 

##LTCI for deductile 
引入免赔期，总计形式，就是在累计病了若干次后，剩余的每一次病了保险公司都赔。
涉及的结构主要是每一period 免赔期deductile 的循环 以及对madicaid 免赔期的计算

**consumption calculation part**  

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
						lcp->Medicaid[j][deduct][i]= ((M[t][j]-LTCIMM[t][j])*(deduct+(j>0)> deductgrid-2)+M[t][j]*(1-(deduct+(j>0)<=deductgrid-2)&&j==3)-LTCIMM[t][0]*(deduct+(j>0) <= deductgrid-2 ))-max((double)0,(double)(wextra+(A+r*wdis[i]/(1+r) -Cbar)));

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



## LTCI parallel model for 3 enter elimination
在这种情况下，每一次进去重新计算免赔期的时间就是
**1 1 1 0 1 1 0 0 1 1 1 1**  
前三个1 保险公司不赔 中间两个1 保险公司也不赔 最后4个1 保险公司平赔一个

这种情况我主要处理的部分是 

**value function iteration part**
主要思想为 当期健康时，下一期的deductile 直接清零 重新累计计算


        for(k=0;k<CalcStruct.wrow;k++)
							if(j==0)
								lcp->VV[j][deduct][k]=lcp->VV[j][deduct][k]+
							 (1/(1+para.rho))*q[t+1][j*5  ]*lcp->V[0][0][k]
							+(1/(1+para.rho))*q[t+1][j*5+1]*lcp->V[1][0][k]
							+(1/(1+para.rho))*q[t+1][j*5+2]*lcp->V[2][0][k]
							+(1/(1+para.rho))*q[t+1][j*5+3]*lcp->V[3][0][k];
							else if(j>=1 && deduct<deductgrid-1)
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
							else if(j>=1 && deduct==deductgrid-1)
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

							else if(j>=1 &&deduct<deductgrid-1)
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


但这里初始的 **no insurance** 情况是应该变回到原来状态，我在程序里少了这个部分


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

##LTCI only medicare comparasion 
这种情况只比较 medicare 对 nursing home 每一次进入的前三期免赔所造成的差异 




> Written with [StackEdit](https://stackedit.io/).