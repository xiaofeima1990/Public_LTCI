function nobs=createdata()
clear
clc
%%���ò���������
obsNums=2;
global datav

ret1=zeros(20,1);ret2=zeros(20,1);ret3=zeros(20,1);
cret1=zeros(20,1);cret2=zeros(20,1);tot=zeros(20,1);

%��ԭʼ�������㣨setData��
% ��̬�������� �������� �������� 
persistent ages
ages=[58; 60; 62; 64; 66; 68];
persistent rets
rets=[ 5;  5;  1;  1;  1;  1];
persistent retv
retv =  [ 0; 0; 0; 0; 0; 0; 0; 5; 5; 5; 5; 0; 1; 1; 1; 1; 1; 1; 1; 0 ];

%   DATA   *data;
     tabs = 1;
%   
%    data = datav(1);
% 
  data.inputobs = 0;                             %/*observation number in input file                   */
% inputobs����input�ļ��� ��������
%   %/*husband's variables */
% 
  data.origobs     =     obsNums;                      %/*observation number in original data set            */
% ԭʼ�ļ�����������
  data.caseid      = 10001;                      %/*caseid number in original data set                 */case ID number ��ԭʼ������
  data.birthyear   =  1931;                      %/*year of birth                                      */������
  data.spbirthyear =  1933;                      %/*year of spouse's birth                             */��ż������
  data.gender      =     1;                      %/*gender                                             */�����Ա�
  data.healthage   =    99;                      %/*initial age of health problem                      */����ʲô����������������
  data.penjobend   =    99;                      %/*age at potential last year in pension job          */
% ���������pension������
  for surv = 0:1: 6-1
%   { 
    data.age(surv+1) =  ages(surv+1);                %/*age at the survey dates                            */ ages(6)   =  { 58, 60, 62, 64, 66, 68 } ��������
    data.ret(surv+1) = rets(surv+1);                 %/*retirement status at survey dates                  */�ڵ�������ʱ������״̬ rets(6)  =  {  5,  5,  1,  1,  1,  1 };
% 
%     }
  end
  
  for age = 50:1: 70-1
  data.retv(age - 50+1) = retv(age - 50+1);          %/*retirement status at ages 50-70                  */
  end
  % 50-70��ʱ������״̬
  for age = 25:1: 70-1
  data.ftwage(age - 25+1) = 30000;                 %/*full-time wages at ages 25-69                      */
  end
  % ����full time������25-69
  for age = 50:1: 70-1
%   { 
    data.secwage(age - 50+1) = 18000;              %/*full-time wages in reversal jobs at ages 50-69     */50-69full time ��ת����
    data.prwage(age - 50+1)  =  6000;              %/*partial retirement wages at ages 50-69             */�������ݹ��� 50-69
%     }
  end
  
  for age = 25:1: 70-1
%   { 
     if (age < 62)
    data.spwage(age - 25+1) = 10000;               %/*wages of spouse at spouse ages 25-69full-time wages at ages 25-69                      */
    else data.spwage(age - 25+1) = 0;
     end
%     }
  end
  
  for age = 50:1:70
%   { 
    data.pensben(age - 50+1)   =     0;            %/*annual pension benefit for retirement at 50-70     */
    data.penstart(age - 50+1)  =    99;            %/*starting age of pension for retirement at 50-70    */
    data.plumpsum(age - 50+1)  =     0;            %/*lump-sum pension benefit for retirement at 50-70   */
    data.eowamount(age - 50+1) =     0;            %/*early out window lump sum amounts at 50-70         */
% ��������pension�趨Ϊ0��������pension��Ӱ��
    data.pia(age - 50+1)       = 10000;            %/*pia at ages 50-69                                  */pia ����
    data.ncpens(age - 50+1)    =     0;            %/*noncovered pensions for retirement at 50-70        */
    data.sppia(age - 50+1)     =  4000;            %/*pia at ages 50-69, wife                            */��ż��pia����
    data.spncpens(age - 50+1)  =     0;            %/*noncovered pensions for retirement at 50-70, wife  */
%     }
  end

  for age = 50:1:70  %(<=)
%   { 
     data.pensben(age - 50+1) = 4000 + 200 * (age - 50);   %/*annual pension benefit for retirement at 50-70 */
% ��pension benefit ����
    if (age < 60)
%     { 
       data.pensben(age - 50+1) = data.pensben(age - 50+1) / exp(0.0248 * (60 - 60) + 0.05 * (60 - age));
      data.penstart(age - 50+1) = 60 ;             %/*starting age of pension for retirement at 50-70    */
%       }���л���60��Ϊ��
    else data.penstart(age - 50+1) =  age;
    end
    
    data.plumpsum(age - 50+1) = 500 * (age - 40);  %/*lump-sum pension benefit for retirement at 50-70 */
%     }
  end
  
   data.sppensben = 700;                          %/*annual pension benefit, wife   */
   data.sppenstart = 62;                          %/*starting age of pension, wife  */
  data.spplumpsum = 0;                           %/*lump-sum pension benefit, wife */
% ��ż��pension benefit��age lump-sum������
  for age = 50:1: 70 %(<=)
%   { 
    data.pia(age - 50+1) = 10000 + 100 * (age - 65);
    data.sppia(age - 50+1) = 4000 + 25 * (age - 65);
%     }
  end
  
    data.totalwealth =  10000;                     %/*wealth in 1992                                                        */�Ը��˲Ƹ�ֵ
    data.assetwealth =  10000;                     %/*land, business, financial & "other" wealth in 1992 (excludes housing) */
% 
  for age = 25:1:100-1
  data.othincome(age - 25+1) = 0;  %/*inheritances for ages 25-99                        */
  end
  % �Լ̳��Ų�������=otherincome Ϊ��
  data.inputobs = 0;
  data.inccat = 0;
  
  %���������
  
  if (obsNums>=2)
for i=2:obsNums   
   data(i).inputobs = i;                             %/*observation number in input file                   */

%   %/*husband's variables */
%
  data(i).origobs     =     obsNums;                      %/*observation number in original data set            */
% ԭʼ�ļ�����������
  data(i).caseid      = 10001;                      %/*caseid number in original data set                 */case ID number ��ԭʼ������
  data(i).birthyear   =  1931;                      %/*year of birth                                      */������
  data(i).spbirthyear =  1933;                      %/*year of spouse's birth                             */��ż������
  data(i).gender      =     1;                      %/*gender                                             */�����Ա�
  data(i).healthage   =    90+floor(9*rand);                      %/*initial age of health problem                      */����ʲô����������������
  data(i).penjobend   =    90+floor(9*rand);   
  
    data(i).age =data(1).age;                %/*age at the survey dates                            */ ages(6)   =  { 58, 60, 62, 64, 66, 68 } ��������
    data(i).ret =data(1).ret;                 %/*retirement status at survey dates                  */�ڵ�������ʱ������״̬ rets(6)  =  {  5,  5,  1,  1,  1,  1 };
% 
    data(i).retv=data(1).retv;
 
    data(i).ftwage =data(1).ftwage ;                 %/*full-time wages at ages 25-69                      */
    data(i).secwage=data(1).secwage;              %/*full-time wages in reversal jobs at ages 50-69     */50-69full time ��ת����
    data(i).prwage=data(1).prwage;              %/*partial retirement wages at ages 50-69             */�������ݹ��� 50-69
    data(i).spwage = data(1).spwage;               %/*wages of spouse at spouse ages 25-69full-time wages at ages 25-69                      */


%   { 
    data(i).pensben=data(1).pensben ;             %/*annual pension benefit for retirement at 50-70     */
    data(i).penstart=data(1).penstart;            %/*starting age of pension for retirement at 50-70    */
    data(i).plumpsum=data(1).plumpsum;            %/*lump-sum pension benefit for retirement at 50-70   */
    data(i).eowamount=data(1).eowamount;          %/*early out window lump sum amounts at 50-70         */
    data(i).pia=data(1).pia;                      %/*pia at ages 50-69                                  */pia ����
    data(i).ncpens=data(1).ncpens;                %/*noncovered pensions for retirement at 50-70        */
    data(i).sppia=data(1).sppia;                  %/*pia at ages 50-69, wife                            */��ż��pia����
    data(i).spncpens=data(1).spncpens;            %/*noncovered pensions for retirement at 50-70, wife  */
%     }

%   { 
    data(i).pensben = data(1).pensben;   %/*annual pension benefit for retirement at 50-70 */
    data(i).penstart =data(1).penstart;             %/*starting age of pension for retirement at 50-70    */

    data(i).plumpsum=data(1).plumpsum;  %/*lump-sum pension benefit for retirement at 50-70 */
%     }

  
   data(i).sppensben = 700;                          %/*annual pension benefit, wife   */
   data(i).sppenstart = 62;                          %/*starting age of pension, wife  */
  data(i).spplumpsum = 0;                           %/*lump-sum pension benefit, wife */
% ��ż��pension benefit��age lump-sum������

    data(i).pia = data(1).pia;
    data(i).sppia = data(1).sppia;
 
    data(i).totalwealth =  10000+2000*rand;                     %/*wealth in 1992                                                        */�Ը��˲Ƹ�ֵ
    data(i).assetwealth =  10000+2000*rand;                     %/*land, business, financial & "other" wealth in 1992 (excludes housing) */
% 
    data(i).othincome =data(1).othincome ;  %/*inheritances for ages 25-99                        */
    
    data(i).inccat = 0;
  
end
  end
 
 
    for i = 1:obsNums
        %   {
        if (data(i).totalwealth < 0)
            data(i).totalwealth = 0;
        end
        %
        if (data(i).assetwealth < 0)
            data(i).assetwealth = 0;
        end
        
         wealth = 0;
% 

    for age = 25:1:62-1
    wealth = wealth + data(i).ftwage(age - 25+1) + data(i).spwage(age - 25+1)...
            + data(i).othincome(age - 25+1);
    end

% ����
    wealth = wealth + data(i).plumpsum(62-50+1) + data(i).spplumpsum;
    
        if (wealth < 1250000)
            data(i).inccat = 1;
        else if (wealth < 1900000)
                data(i).inccat = 2;
            else    data(i).inccat = 3;
            end
        end
%     }    
    end
    
    if (tabs == 1)
        %   { %/* sample tabulations of retirement status */
        ret1(1:20,1)=double(0);ret2(1:20,1)=double(0);ret3(1:20,1)=0;
        % 3������״̬����
        for obs = 0:obsNums-1
            for age = 50:70-1
                %     {
                ret = data(obs+1).retv(age - 50+1);
                %
                if (ret == 5)
                    ret1(age - 50+1) = ret1(age - 50+1)+ 1;
                else if (ret == 3)
                        ret2(age - 50+1) = ret2(age - 50+1) + 1;
                    else if (ret == 1)
                            ret3(age - 50+1) = ret3(age - 50+1) + 1;
                        end
                    end
                end
                
            end
        end
        fprintf('\n\n      Observed Retirement Percentages\n');
        %
       for age = 50:1:70-1
%     { 
        tot(age - 50+1) = ret1(age - 50+1) + ret2(age - 50+1) + ret3(age - 50+1);

      ret1(age - 50+1) = 100 * ret1(age - 50+1) / tot(age - 50+1);
      ret2(age - 50+1) = 100 * ret2(age - 50+1) / tot(age - 50+1);
      ret3(age - 50+1) = 100 * ret3(age - 50+1) / tot(age - 50+1);

      cret1(age - 50+1) = 100 - ret1(age - 50+1);
      cret2(age - 50+1) = ret3(age - 50+1);

      if (age == 50)
%       { 
          ret1(age - 50+1) = cret1(age - 50+1);
        ret2(age - 50+1) = cret2(age - 50+1);
%         }
      else
%       { 
          ret1(age - 50+1) = cret1(age - 50+1) - cret1((age - 1) - 50+1);
        ret2(age - 50+1) = cret2(age - 50+1) - cret2((age - 1) - 50+1);
%         }
      end

      fprintf('\n %2d  %5.1f %5.1f   %5.1f %5.1f   %4.0f', age,...
       ret1(age - 50+1), ret2(age - 50+1), cret1(age - 50+1), cret2(age - 50+1), tot(age - 50+1));
%       }
      end
        % ���ڲ�ͬ�������͵İٷ���ʾ����Ҫ�Ǳ仯�İٷֱ�
        fprintf('\nTotal number of observed respondents: %d', obsNums);
        %     }
    end

  
 datav=data;
 nobs=obsNums;
 