function f=getSurvivalRates(birthyear,gender,surv)
%   int    birthyear,            /* year of birth            */
%   int    gender,               /* sex of respondent        */
%   double *surv)                /* vector of survival rates */
% /*---------------------------------------------------------------------------
% 			 GET SURVIVAL RATES routine
% 			 gets birthyear and gender specific survival rates
%   ---------------------------------------------------------------------------*/
%
% {

fileno=int32(0);
ageo=int32(0); coho=int32(0); geno=int32(0); lineo=int32(0);
agechecko=int32(0); survprobo=int32(0);
count=0;
%
filename(1:60,1)=char(0);
stringline(1:151,1)=char(0);
%
%   static int init = 1;
%   static float survtable(91)(2)(120);
persistent init
%初始化
if isempty(init)
    init=1;
end
init=1;
persistent survtable
%初始化
if isempty(survtable)
    survtable=single(zeros(91,2,120));
end

%   static int startcohort(3) = { 0, 16, 56};
%   static int endcohort(3)   = {15, 55, 90};
%   static char infilename(3)(12) = {'coh0015.95t', 'coh1655.95t', 'coh5690.95t'};
persistent startcohort
if isempty(startcohort)
    startcohort=[0;16;56];
end

persistent endcohort
if isempty(endcohort)
    endcohort=[15;55;90];
end

persistent infilename
infilename(:,1)='COH0015.95T';
infilename(:,2)='COH1655.95T';
infilename(:,3)='COH5690.95T';

%   FILE *infile, *outfile;

inhandle=0;outhandle=0;
%
%
%   strcpy(filename, 'SurvTabs.dat');
filename='SurvTabs.dat';
if (init == 1)
    %   {
    if (exist(filename)~=2)
        
        %     {
        for fileno = 1:1: 3
            %       {
            filename=infilename(:,fileno);
            infile = fopen(filename, 'r');
            %
            if (infile == -1)
                error('File not found in getSurvivalRates');
            end
            %
            for coh = startcohort(fileno):1: endcohort(fileno) %(<=)
                for gen = 0:1: 2-1
                    for age = 0:1:120-1
                        %         {
                        if (mod(age,40) == 0)
                            for line = 0:1: 7
                                stringline= fgets(infile,150);
                            end
                        end
                        
                        stringline=fgets(infile,150);
                        %
                        agecheck=sscanf(stringline(1:4), '%3d');
                        
                        if (age ~= agecheck)
                            error('Bad input in getSurvivalRates');
                        end
                        %
                        survprob=sscanf(stringline(18:23), '%6d');
                        survtable(coh+1,gen+1,age+1) = survprob;
                        %
                        if (mod(age,5) == 4)
                            stringline=fgets(infile,150 );
                        end
                        %           }
                    end
                end
            end
            %
            fclose(infile);
            %         }
        end
        %
        filename= 'SurvTabs.dat';
        outhandle = fopen(filename, 'wb');
        %       outhandle = _fileno(outfile);
        fwrite(outhandle, survtable);
        fclose(outhandle);
        %       }
    else
        %     {
        inhandle = fopen(filename, 'r');
        %       inhandle = _fileno(infile);
        survtabletemp=fread(inhandle,87360,'*single');
        %处理数据把它搞成3维数组
        for i=0:90
            for j=0:1
                for k=0:119
                    survtable(i+1,j+1,k+1)=survtabletemp((i+j+count)*120+k+1);
                end
            end
            count=count+1;
        end
        
        
        fclose(inhandle);
        %       }
    end
    %
    init = 0;
    f=surv;
    return;
    
    %     }
end
%
if (birthyear < 1900 || birthyear > 1990 || gender < 1 || gender > 2)
    %   {
    fprintf('\nBad birthyear or gender: birthyear %d  gender %d', birthyear, gender);
    error('Bad birthyear or gender in getSurvivalRates');
    %     }
end


for age = 1:120
    surv(age) = survtable(birthyear - 1900+1,gender - 1+1,age);
end

f=surv;
%   }
