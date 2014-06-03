% /*---------------------------------------------------------------------------
% 			 CALC MODEL routine
% 			 calculates utility, savings, and job choices for the model
%   ---------------------------------------------------------------------------*/

function calc = calcModel(gv, calc, tcat)
% tcat % category of utility of partial retirement category;

tempp=zeros(2,1); 
temps=zeros(2,1);
muvbuf=zeros(gv.nacatlim,1); cvbuf=zeros(gv.nacatlim,1); tuvbuf=zeros(gv.nacatlim,1); yac=zeros(gv.nacatlim,1);
mula=zeros(gv.nlcatlim,gv.nacatlim); tula=zeros(gv.nlcatlim,gv.nacatlim);
mular=zeros(gv.nlcatlim,gv.nacatlim,gv.nrcatlim);tular=zeros(gv.nlcatlim,gv.nacatlim,gv.nrcatlim);
lacats=zeros(gv.nlcatlim,gv.nacatlim);
lacatsr=zeros(gv.nlcatlim,gv.nacatlim); lacatsw=zeros(gv.nlcatlim,gv.nacatlim);
tuj=zeros(4,1); muj=zeros(4,1);
cv=0; tuv=0; margu=0; totu=0; 
ufm=zeros(4,gv.nscatlim,gv.nacatlim);
uft=zeros(4,gv.nscatlim,gv.nacatlim);
ucrm=zeros(gv.nscatlim,gv.necatlim,gv.nacatlim);
ucrt=zeros(gv.nscatlim,gv.necatlim,gv.nacatlim);

obs = calc.obs;
alpha = calc.alpha;
rho = gv.arglist.rvec(obs,1);
firstage = calc.firstage;
lastage = calc.lastage;
earlypenage = calc.earlypenage;
delayedpenage = calc.delayedpenage;
contribstartage = calc.contribstartage;
penjobend = calc.penjobend;
sserage = calc.sserage;
nrage = calc.nrage;
nragew = calc.spnrage;
delayedret = calc.delayedret;
delayedretw = calc.spdelayedret;

nacats = calc.nacats;
necats = calc.necats;
nlcats = calc.nlcats;
npcats = calc.npcats;
nrcats = calc.nrcats;
nscats = calc.nscats;

acats= calc.acats;
lcats = calc.lcats;
pcats = calc.pcats;
tcats = calc.tcats;

mainwage = calc.mainwage;
secwage  = calc.secwage;
prwage   = calc.prwage;

ssbenf = calc.ssbenf;
ssbenm = calc.ssbenm;
ssbens = calc.ssbens;
ssbenp = calc.ssbenp;
ssbenr = calc.ssbenr;
eowamount = calc.eowamount;
othincome = calc.othincome;

initialpcat = calc.initialpcat;
initialscat = calc.initialscat;

benchanges  = calc.benchanges;
benchangep  = calc.benchangep;

srate = calc.srate;
transrate = calc.transrate;
etrans = calc.etrans;
rprob = calc.rprob;
rtransa = calc.rtransa;
rtransl = calc.rtransl;

utilr = calc.utilr;
marguc = calc.marguc;
totuc = calc.totuc;

marguf = calc.marguf;
totuf = calc.totuf;

margufw = calc.margufw;
totufw = calc.totufw;

margufr = calc.margufr;
totufr = calc.totufr;

cmatw = calc.cmatw;
tumatw = calc.tumatw;

cmatr = calc.cmatr;
tumatr = calc.tumatr;

margucw = calc.margucw;
totucw = calc.totucw;
margucr = calc.margucr;
totucr = calc.totucr;

totuw = calc.totuw;

totud = calc.totud;
savw = calc.savw;
savd = calc.savd;
savr = calc.savr;

mjchoice = calc.mjchoice;
retchoice = calc.retchoice;


tp = 1 + rho;
r = 1 + calc.realrateg;

inflrate = calc.inflrate;
penadjrate = calc.penadjrate;

sqrt2 = sqrt(2.0);
consadj = 2^( 0.5 * (1 - alpha));

% calculate consumption and utility at age 99;
agew = 99 + calc.birthyear - calc.spbirthyear;

% Age 99, consume everything, asset+pension+social security+other income;
[vcat dcat pcat scat acat]=fn_gridmake((1:gv.nvcatlim)',(1:gv.ndcatlim)',(1:gv.npcatlim)',(1:gv.nscatlim)',(1:gv.nacatlim)');
y = max(10, acats(acat,1) + (pcats(pcat,1) * exp(- inflrate * (1 - penadjrate) * (99 - 50))).*(vcat <3 & npcats > 1) + ssbenr(sub2ind(size(ssbenr),99-50+1*ones(size(vcat,1),1),vcat,scat)) + othincome (99-25+1, vcat)');
marguf = (dcat==1).*(pcat==1 | vcat <3).* y .^ (alpha-1) .* (ones(size(vcat,1),1) + (consadj-1) * (vcat == 1));
totuf = y .* marguf /alpha;
marguf = reshape(marguf, 3, 2, gv.npcatlim, gv.nscatlim, gv.nacatlim);
totuf = reshape(totuf, 3, 2, gv.npcatlim, gv.nscatlim, gv.nacatlim);
[pcat scat acat]=fn_gridmake((1:gv.npcatlim)',(1:gv.nscatlim)',(1:gv.nacatlim)');
savr(99-70+1,1,:,:,:) = reshape(-acats(acat,1), gv.npcatlim, gv.nscatlim, gv.nacatlim);


% calculate consumption and utility for ages lastage to 99;
for age = 98:-1: lastage+1 % marrital status, dcat means whether delayed claiming pension?, pension, social security, asset, asset return;
    %   { /* calculate expectations with respect to interest rates */
    margu = muvbuf;
    totu  = tuvbuf;
    cv    = cvbuf;
    tuv   = tuvbuf;
% [vcat dcat pcat scat acat]=fn_gridmake((1:gv.nvcatlim)',(1:gv.ndcatlim)',(1:gv.npcatlim)',(1:gv.nscatlim)',(1:gv.nacatlim)');
% nacats = calc.nacats;
% necats = calc.necats;
% nlcats = calc.nlcats;
% npcats = calc.npcats;
% nrcats = calc.nrcats;
% nscats = calc.nscats;
        
    acati=min(nacats - 1,floor(rtransa(acat,rcat)));
    fa = rtransa(acat,rcat) - acati;%可以合并
    
    
    mu=zeros(17,3,2,npcats,nscats);%储存插值的函数
    tu=zeros(17,3,2,npcats,nscats);%储存插值的函数
    
    
    %多维矩阵转置permute
    mu0=permute(marguf,[5,1,2,3,4]);
    tu0=permute(totuf,[5,1,2,3,4]);
%     mu0(1,:,:,:,:,:)=marguf(1:3,1:2,1:npcats,1:nscats,1:nacats-1);
%     mu0(2,:,:,:,:,:)=marguf(1:3,1:2,1:npcats,1:nscats,2:nacats);
%     
%     tu0(1,:,:,:,:,:)= totuf(:,:,:,:,1:nacats-1);
%     tu0(2,:,:,:,:,:)=totuf(:,:,:,:,2:nacats);
%     
    
    %线性插值：区间是1：acat  插值的大小事1：rcat  多少次循环呢？：vcat dcat pcat scat 
   %——————————————————————%
for irmt=1:nrcats  
mu=interp1([0:39],mu0(min(nacats - 1,floor(rtransa(:,irmt)))+1,:,:,:,:),rtransa(:,irmt)-min(nacats - 1,floor(rtransa(:,irmt)))');
tu=interp1([0:39],tu0(min(nacats - 1,floor(rtransa(:,irmt)))+1,:,:,:,:),rtransa(:,irmt)-min(nacats - 1,floor(rtransa(:,irmt))));
  mur=mur+rprob(irmt)*mu;
  tur=tur+rprob(irmt)*mu;
  
end
mur=permute(mur,[2,3,4,5,1]);
tur=permute(tur,[2,3,4,5,1]);
 
judgeMatrix=((vcat==0)||(age>62))*(dcat==0||(vcat<2&& earlypenage <= age && age < delayedpenage))*(pcat == 0 || vcat < 2);
judgeMatrix=reshape(judgeMatrix,[3,2,4,4,40]);
marguf=marguf*(1-judgeMatrix)+mur*judgeMatrix;
totuf=totuf*(1-judgeMatrix)+tur*judgeMatrix;
    %——————————————————————% 
    
% end % age = 98:-1: lastage+1 


% calculate consumption and utility for ages lastage to 99;
% for age = 98:-1: lastage+1 % marrital status, dcat means whether delayed claiming pension?, pension, social security, asset, asset return;
% %       { /* calculate expectations with respect to interest rates */
%         %
%         margu = muvbuf;
%         totu  = tuvbuf;
%         cv    = cvbuf;
%         tuv   = tuvbuf;
%     
%          for vcat = 0:1: 3-1
%             if (vcat == 0 || age > 62)
%                 %     {
%                 for dcat = 0:1: 2-1
%                     if (dcat == 0 || (vcat < 2 && earlypenage <= age && age < delayedpenage))
%                         %       {
%                         for pcat = 0:1:npcats-1
%                             if (pcat == 0 || vcat < 2)
%                                 %         {
%                                 for scat = 0:1:nscats-1
%                                     %           {
%                                     for acat = 0:1:nacats-1
%                                         %             {
%                                         mur = 0;
%                                         tur = 0;
%     
%                                         for rcat = 0:1:nrcats-1
%                                             %               {
%                                             acati=floor(rtransa(acat+1,rcat+1));
%     
%                                             if (acati >= nacats - 1)
%                                                 acati = nacats - 2;
%                                             end
%     
%                                             fa = rtransa(acat+1,rcat+1) - acati;
%     
%                                             mu0 = marguf(vcat+1,dcat+1,pcat+1,scat+1,acati+1);
%                                             mu1 = marguf(vcat+1,dcat+1,pcat+1,scat+1,acati + 2);
%                                             tu0 = totuf(vcat+1,dcat+1,pcat+1,scat+1,acati+1    );
%                                             tu1 = totuf(vcat+1,dcat+1,pcat+1,scat+1,acati + 2);
%     
%                                             if (mu0 <= 0 || mu1 <= 0)
%                                                 %                 {
%                                                 fprintf('\nBad mu in post-retirement section: %2d %2d %14.6e %14.6e %2d %2d %2d %2d %2d %2d',...
%                                                     obs, age, mu0, mu1, vcat, dcat, pcat, scat, acat, acati);
%                                                 %                   pause();
%                                                 %                   }
%                                             end
%     
%                                             if (fa <= 1)
%                                                 %                 {
%                                                 mu = (1 - fa) * mu0 + fa * mu1;
%                                                 tu = (1 - fa) * tu0 + fa * tu1;
%                                                 %                   }
%                                             else
%                                                 %                 {
%                                                 if (mu0 > mu1 && tu1 > tu0)
%                                                     %                   {
%                                                     dmu = mu0 - mu1;
%                                                     dtu = tu1 - tu0;
%                                                     muratio = mu0 / mu1;
%                                                     mufact = dmu / mu0;
%                                                     %
%                                                     mu = mu1 / (1 + (fa - 1) * mufact);
%                                                     tu = tu1 + (dtu / log(muratio)) * log(1 + (fa - 1) * mufact);
%                                                     %                     }
%                                                 else
%                                                     %                   {
%                                                     mu = mu1;
%                                                     %
%                                                     if (tu1 > tu0)
%                                                         tu = (1 - fa) * tu0 + fa * tu1;
%                                                     else tu = tu1;
%                                                     end
%                                                     %                     }
%                                                 end
%                                                 %                   }
%                                             end
%     
%                                             mur = mur + rprob(rcat+1) * mu;
%                                             tur = tur + rprob(rcat+1) * tu;
%                                             %                 }
%                                         end
%                                         margu(acat+1) = mur;
%                                         totu(acat+1) = tur;
%                                         %               }
%                                     end
%     
%                                     marguf(vcat+1,dcat+1,pcat+1,scat+1,1:nacats) = margu(1:nacats);
%                                     totuf(vcat+1,dcat+1,pcat+1,scat+1,1:nacats) = totu(1:nacats);
%     
%     
%                                     %             }
%                                 end
%                                 %           }
%                             end
%                         end
%                         %         }
%                     end
%                 end
%                 %       }
%             end
%         end
    
%%%%    
%over1
%%%%
    
    %     /* calculate expectations with respect to survival */
    
    marguf2=reshape(marguf(3,1,1,:,:),[1,numel(marguf(3,1,1,:,:))]);
    marguf2=kron(marguf2,ones(2*4,1));
    marguf2=reshape(marguf2,[2,4,4,40]);
    
    totuf2=reshape(totuf(3,1,1,:,:),[1,numel(marguf(3,1,1,:,:))]);
    totuf2=kron(totuf2,ones(2*4,1));
    totuf2=reshape(totuf2,[2,4,4,40]);
    
   marguf(1,:,:,:,:)=transrate(1,age-25+1)*marguf(1,:,:,:,:)+transrate(2,age-25+1)*marguf(2,:,:,:,:)+transrate(3,age-25+1)*marguf2(:,:,:,:);
   totuf(1,:,:,:,:)=transrate(1,age-25+1)*totuf(1,:,:,:,:)+transrate(2,age-25+1)*totuf(2,:,:,:,:)+transrate(3,age-25+1)*totuf2(:,:,:,:);
   
    
%     if (age >= 62)                                  % /* vcat = 0 */
%         %     {
%         for dcat = 0:1: 2-1
%             if (dcat == 0 || (vcat < 2 && earlypenage <= age && age < delayedpenage))
%                 %       {
%                 for pcat = 0:1:npcats-1
%                     for scat = 0:1:nscats-1
%                         for acat = 0:1:nacats-1
%                             %         {
%                             marguf0 = marguf(0+1,dcat+1,pcat+1,scat+1,acat+1);
%                             totuf0 = totuf(0+1,dcat+1,pcat+1,scat+1,acat+1);
%                             
%                             marguf1 = marguf(1+1,dcat+1,pcat+1,scat+1,acat+1);
%                             totuf1 = totuf(1+1,dcat+1,pcat+1,scat+1,acat+1);
%                             
%                             marguf2 = marguf(2+1,0+1,0+1,scat+1,acat+1);
%                             totuf2 = totuf(2+1,0+1,0+1,scat+1,acat+1);
%                             
%                             marguf(0+1,dcat+1,pcat+1,scat+1,acat+1)...
%                                 =  transrate(0+1,age - 25+1) * marguf0...
%                                 + transrate(1+1,age - 25+1) * marguf1...
%                                 + transrate(2+1,age - 25+1) * marguf2;
%                             
%                             totuf(0+1,dcat+1,pcat+1,scat+1,acat+1)...
%                                 =  transrate(0+1,age - 25+1) * totuf0...
%                                 + transrate(1+1,age - 25+1) * totuf1...
%                                 + transrate(2+1,age - 25+1) * totuf2;
%                             %           }
%                         end
%                     end
%                 end
%                 %         }
%             end
%         end
%         %       }
%     end
    
    %     /* calculate consumption and utility */
    
    
    
    
    
    
    for vcat = 0:3-1
        if (vcat == 0 || age > 62)
            %     {
            for dcat = 0:2-1
                if (dcat == 0 || (vcat < 2 && earlypenage <= age && age < delayedpenage))
                    %       {
                    for pcat = 0:1:npcats-1
                        if (pcat == 0 || vcat < 2)
                            %         {
                            if (vcat < 2 && dcat == 0 && earlypenage <= age)
                                pben = pcats(pcat+1) * exp(- inflrate * (1 - penadjrate) * (age - 50));
                            else pben = 0;
                            end
                            
                            for scat = 0:1:nscats-1
                                %           { checkMessages();
                                %
                                for acat = 0:1: nacats-1
                                    %             {
                                    mu = marguf(vcat+1,dcat+1,pcat+1,scat+1,acat+1);
                                    tu = totuf(vcat+1,dcat+1,pcat+1,scat+1,acat+1);
                                    
                                    if (mu <= 0)
                                        %               {
                                        fprintf('\nBad mu for post-retirement decision: %2d %14.6e %2d %2d %2d %2d %2d',...
                                            age, mu0, mu1, vcat, dcat, pcat, scat, acat);
                                        pause();
                                        %                 }
                                    end
                                    
                                    if (vcat == 0)
                                        %               {
                                        cv(acat+1) = sqrt2 * (mu / tp)^(1 / (alpha - 1));
                                        tuv(acat+1) = tu / tp;
                                        %                 }
                                    else
                                        %               {
                                        cv(acat+1) = (mu * srate(vcat - 1+1,age - 25+1) / tp)^ (1 / (alpha - 1));
                                        tuv(acat+1) = tu * srate(vcat - 1+1,age - 25+1) / tp;
                                        %                 }
                                    end
                                    %               }
                                end
                                %
                                %%margu，totu，totutil以及saving均是marguc，totuc，totuc，savd、savr的指针引用，如果改写了
                                %%margu，totu，totutil以及saving那么marguc，totuc，totuc，savd、savr所代表的数组也会改变
                                %             margu = marguc(vcat+1,dcat+1,pcat+1,scat+1,:);
                                %             totu = totuc(vcat+1,dcat+1,pcat+1,scat+1,:);
                                %             totutil = totuc(vcat+1,dcat+1,pcat+1,scat+1,:);
                                
                                %             if (age < 70)
                                %             saving = savd(age - 50+1,2+1,dcat+1,pcat+1,scat+1,1,:);
                                %             else saving = savr(age - 70+1,dcat+1,pcat+1,scat+1,:);
                                %             end
                                %
                                sben = ssbenr(age - 50+1,vcat+1,scat+1);
                                
                                y = pben + sben + othincome(age - 25+1,vcat+1);
                                
                                %             #include 'GSModel.inc'
                                [margu,totu,totutil,saving]=GSModelinc(age,alpha,acats,nacats,nassets,c,cv,consadj,dcat,f,mumax,reversal,pcat,tuv,tp,y,yac,vcat,scat);
                                
                                marguc(vcat+1,dcat+1,pcat+1,scat+1,1:40)=margu(1:40);
                                totuc(vcat+1,dcat+1,pcat+1,scat+1,1:40)= totu(1:40);
                                
                                if(vcat==0)
                                    totuc(vcat+1,dcat+1,pcat+1,scat+1,1:40)=totutil(1:40);
                                    if (age < 70)
                                        savd(age - 50+1,2+1,dcat+1,pcat+1,scat+1,1,1:40)=saving(1:40);
                                    else  savr(age - 70+1,dcat+1,pcat+1,scat+1,1:40)=saving(1:40) ;
                                    end
                                    
                                end
                                
                            end
                            %             }
                        end
                    end
                    %           }
                end
            end
            %         }
            %       /* allow for delayed pension receipt */
            %
            %主要是回存的vcat
            if (vcat < 2)
                %       {
                if (earlypenage < age && age == delayedpenage)
                    
                    marguc(vcat+1,2,:,:,:)=marguc(vcat+1,1,:,:,:);
                    totuc(vcat+1,2,:,:,:)=totuc(vcat+1,1,:,:,:);
                    
                else if (earlypenage == age && age < delayedpenage)
                                            
                        marguc(vcat+1,1,:,:,:)=marguc(vcat+1,2,:,:,:);
                        totuc(vcat+1,1,:,:,:)=totuc(vcat+1,2,:,:,:);
                       
                    end
                end
                %         }
            end
            %       }
        end
    end
    
    %
    %     /* transfer margu & totu to future matrices */
    
    
    marguf=marguc;
    totuf=totuc;
    %     }
end   %age for 循环

%   /* force retirement at lastage + 1 */

pcat = floor(initialpcat((lastage + 1) - 50+1));
scat = floor(initialscat((lastage + 1) - 50+1));

fp = initialpcat((lastage + 1) - 50+1) - pcat;
fs = initialscat((lastage + 1) - 50+1) - scat;

eowamt = eowamount((lastage + 1) - 50+1);

for lcat = 0:1:nlcats-1
    %   {
    if ((lcat > 0 && penjobend + 1 >= (lastage + 1) && (lastage + 1) > contribstartage)...
            || (lcat == 0 && eowamt > 0))
        %     {
        for acat = 0:1:nacats-1
            %       {
            pwealth = acats(acat+1) + lcats(lcat+1) + eowamt;
            
            if (acat < nacats - 1)
                lacat = acat + 1;
            else lacat = nacats - 1;
            end
            
            while (lacat < nacats - 1 && pwealth > acats(lacat+1))
                lacat = lacat + 1;
            end
            
            lacat = lacat - 1;
            
            lacats(lcat+1,acat+1) = lacat + (pwealth - acats(lacat+1)) / (acats(lacat + 1+1) - acats(lacat+1));
            %         }
        end
        %       }
    else if (lcat == 0)
            %     {
            %      for acat = 0:1: nacats-1
            lacats(lcat+1,1:nacats) =0:1: nacats-1;
            %      end
            %       }
        end
        %     }
    end
end

for vcat = 0:1: 2-1
    if (vcat == 0 || (lastage + 1) > 62)
        %   {
        for lcat = 0:1: nlcats-1
            if (lcat == 0 || ((penjobend + 1) >= (lastage + 1) && (lastage + 1) > contribstartage))
                %     {
                for acat = 0 :1: nacats-1
                    %       {
                    lacat = floor(lacats(lcat+1,acat+1));
                    
                    if (lacat > nacats - 2)
                        lacat = nacats - 2;
                    end
                    
                    fla = lacats(lcat+1,acat+1) - lacat;
                    %%数组的引用~~~ufm,uft在原C++中是指针的存在
                    ufm(:,:,:) = marguf(vcat+1,1,:,:,:);
                    uft(:,:,:) = totuf(vcat+1,1,:,:,:);
                    
                    for utype = 0:1: 1 %(<=)
                        %         {
                        for  pcati = pcat:1: pcat + 1
                            if (pcati == pcat || fp ~= 0)
                                %           {
                                for scati = scat:1:scat + 1 %(<=)
                                    if (scati == scat || fs ~= 0)
                                        %             {
                                        if (fla ~= 0)
                                            %               {
                                            if (utype == 0)
                                                %                 {
                                                mu0 = ufm(pcati+1,scati+1,lacat+1);
                                                mu1 = ufm(pcati+1,scati+1,lacat + 2);
                                                
                                                if (fla <= 1)
                                                    temp = (1 - fla) * mu0 + fla * mu1;
                                                else if (mu0 > mu1)
                                                        %                   {
                                                        dmu = mu0 - mu1;
                                                        mufact = dmu / mu0;
                                                        
                                                        temp = mu1 / (1 + (fla - 1) * mufact);
                                                        %                     }
                                                    else temp = mu1;
                                                    end
                                                end
                                                %                   }
                                            else
                                                %                 {
                                                tu0 = uft(pcati+1,scati+1,lacat+1);
                                                tu1 = uft(pcati+1,scati+1,lacat + 2);
                                                
                                                if (fla <= 1)
                                                    temp = (1 - fla) * tu0 + fla * tu1;
                                                else
                                                    %                   {
                                                    mu0 = ufm(pcati+1,scati+1,lacat+1);
                                                    mu1 = ufm(pcati+1,scati+1,lacat + 2);
                                                    
                                                    if (mu0 > mu1 && tu1 > tu0)
                                                        %                     {
                                                        dmu = mu0 - mu1;
                                                        dtu = tu1 - tu0;
                                                        muratio = mu0 / mu1;
                                                        mufact = dmu / mu0;
                                                        
                                                        temp = tu1 + (dtu / log(muratio)) * log(1 + (fla - 1) * mufact);
                                                        %                       }
                                                    else if (tu1 > tu0)
                                                            temp = (1 - fla) * tu0 + fla * tu1;
                                                        else temp = tu1;
                                                        end
                                                    end
                                                    %                     }
                                                end
                                                %                   }
                                            end
                                            %                 }
                                        else
                                            %               {
                                            if (utype == 0)
                                                temp = ufm(pcati+1,scati+1,lacat+1);
                                            else temp = uft(pcati+1,scati+1,lacat+1);
                                            end
                                            %                 }
                                        end
                                        
                                        if (scati == scat)
                                            temps(1) = temp;
                                        else temps(2) = temp;
                                        end
                                        %               }
                                    end
                                end % for (scati = scat; scati <= scat + 1; scati++)
                                
                                if (fs ~= 0)
                                    util = (1 - fs) * temps(1) + fs * temps(2);
                                else util = temps(1);
                                end
                                
                                if (pcati == pcat)
                                    tempp(1) = temp;
                                else tempp(2) = temp;
                                end
                            end
                            %             }
                        end
                        
                        if (fp ~= 0)
                            util = (1 - fp) * tempp(1) + fp * tempp(2);
                        else util = tempp(1);
                        end
                        
                        if (utype == 0)
                            %           {
                            %               for ecat = 0:1: necats-1
                            margufw(vcat+1,lcat+1,1:necats,acat+1) = util;
                            %               end
                            %             }
                        else
                            %           {
                            %               for ecat = 0:1:necats-1
                            totufw(vcat+1,lcat+1,1:necats,acat+1) = util;
                            %               end
                            %             }
                        end
                        %           }
                    end
                    %         }
                end
                %       }
            end
        end
        %     }
        
    end
end

%   /* set consumption and utility for all eps categories at lastage + 1 */

for vcat = 0:1: 3-1
    if (vcat == 0 || (lastage + 1) > 62)
        %   {
        for dcat = 0:1:2-1
            if (dcat == 0 || (vcat < 2 && earlypenage < (lastage + 1) && (lastage + 1) <= delayedpenage))
                %     {
                for pcat = 0:1:npcats-1
                    if (pcat == 0 || vcat < 2)
                        %       {
                        for scat = 0:1:nscats-1
                            for ecat = 0:1: necats-1
                                if (ecat == 0 || vcat < 2)
                                    %         {
                                    for acat = 0:1:nacats-1
                                        %           {
                                        margufr(vcat+1,dcat+1,pcat+1,scat+1,ecat+1,acat+1) = marguf(vcat+1,dcat+1,pcat+1,scat+1,acat+1);
                                        totufr(vcat+1,dcat+1,pcat+1,scat+1,ecat+1,acat+1) = totuf(vcat+1,dcat+1,pcat+1,scat+1,acat+1);
                                        
                                        if (margufr(vcat+1,dcat+1,pcat+1,scat+1,ecat+1,acat+1) <= 0)
                                            %                 {
                                            fprintf('\ndd %2d %d %d %d %d %d %d', lastage + 1, vcat, dcat, pcat, scat, ecat, acat); pause();
                                            %             }
                                        end
                                        %             }
                                    end
                                    %           }
                                end
                            end
                        end
                        %         }
                    end
                end
                %       }
            end
        end
        %     }
    end
end

%   /* calculate utility and consumption for firstage to lastage */
%
for age = lastage:-1: firstage
    %   { /* calculate expectations with respect to returns, given exit from main job */
    margu = muvbuf;
    totu = tuvbuf;
    
    for vcat = 0:1: 3-1
        if (vcat == 0 || age > 62)
            %     { checkMessages();
            
            for dcat = 0:1:2-1
                if (dcat == 0 || (vcat < 2 && earlypenage <= age && age < delayedpenage))
                    %       {
                    for pcat = 0:1:npcats-1
                        if (pcat == 0 || vcat < 2)
                            %         {
                            for scat = 0:1:nscats-1
                                for ecat = 0:1:necats-1
                                    if (ecat == 0 || vcat < 2)
                                        %           {
                                        for acat = 0:1:nacats-1
                                            %             {
                                            mu = 0;
                                            tu = 0;
                                            
                                            for rcat = 0:1:nrcats-1
                                                %               {
                                                acati = floor( rtransa(acat+1,rcat+1));
                                                
                                                if (acati >= nacats - 1)
                                                    acati = nacats - 2;
                                                end
                                                
                                                fa = rtransa(acat+1,rcat+1) - acati;
                                                
                                                mu0 = margufr(vcat+1,dcat+1,pcat+1,scat+1,ecat+1,acati+1    );
                                                mu1 = margufr(vcat+1,dcat+1,pcat+1,scat+1,ecat+1,acati + 2);
                                                tu0 = totufr(vcat+1,dcat+1,pcat+1,scat+1,ecat+1,acati+1    );
                                                tu1 = totufr(vcat+1,dcat+1,pcat+1,scat+1,ecat+1,acati + 2);
                                                
                                                if (mu0 <= 0 || mu1 <= 0)
                                                    %                 {
                                                    fprintf('\nBad mu in decision-retired section: %2d %14.6e %14.6e %2d %2d %2d %2d %2d %2d %2d %2d',...
                                                        age, mu0, mu1, vcat, dcat, pcat, scat, ecat, acat, acati, rcat);
                                                    pause();
                                                    %                   }
                                                end
                                                
                                                if (fa <= 1)
                                                    %                 {
                                                    mur = (1 - fa) * mu0 + fa * mu1;
                                                    tur = (1 - fa) * tu0 + fa * tu1;
                                                    %                   }
                                                else
                                                    %                 {
                                                    if (mu0 > mu1 && tu1 > tu0)
                                                        %                   {
                                                        dmu = mu0 - mu1;
                                                        dtu = tu1 - tu0;
                                                        muratio = mu0 / mu1;
                                                        mufact = dmu / mu0;
                                                        
                                                        mur = mu1 / (1 + (fa - 1) * mufact);
                                                        tur = tu1 + (dtu / log(muratio)) * log(1 + (fa - 1) * mufact);
                                                        %                     }
                                                    else
                                                        %                   {
                                                        mur = mu1;
                                                        
                                                        if (tu1 > tu0)
                                                            tur = (1 - fa) * tu0 + fa * tu1;
                                                        else tur = tu1;
                                                        end
                                                        %                     }
                                                    end
                                                    %                   }
                                                end
                                                
                                                mu = mu + rprob(rcat+1) * mur;
                                                tu = tu + rprob(rcat+1) * tur;
                                                %                 }
                                            end
                                            
                                            margu(acat+1) = mu;
                                            totu(acat+1) = tu;
                                            %               }
                                        end
                                        %
                                        %             for (acat = 0; acat < nacats; acat++)
                                        %             {
                                        margufr(vcat+1,dcat+1,pcat+1,scat+1,ecat+1,1:nacats) = margu(1:nacats);
                                        totufr(vcat+1,dcat+1,pcat+1,scat+1,ecat+1,1:nacats) = totu((1:nacats));
                                        %               }
                                        
                                        %             }
                                    end
                                end
                            end
                            %           }
                        end
                    end
                    %         }
                end
            end
            %       }
        end
    end
    %     /* calculate expectations with respect to returns, given current main job */
    %
    for vcat = 0:1: 2-1
        if (vcat == 0 || age > 62)
            %     { checkMessages();
            
            for ecat = 0:1: necats-1
                %       {
                for lcat = 0:1: nlcats-1
                    if (lcat == 0 || (penjobend >= age && age > contribstartage))
                        %         {
                        for acat = 0:1: nacats-1
                            %           {
                            mu = 0;
                            tu = 0;
                            
                            for rcat = 0:1: nrcats-1
                                %             {
                                acati = floor( rtransa(acat+1,rcat+1));
                                
                                if (acati >= nacats - 1)
                                    acati = nacats - 2;
                                end
                                
                                fa = rtransa(acat+1,rcat+1) - acati;
                                
                                if (nlcats > 1 && penjobend + 1 > age && age > contribstartage)
                                    %               {
                                    lcati = floor( rtransl(age - 25+1,lcat+1,rcat+1));
                                    
                                    if (lcati >= nlcats - 1)
                                        lcati = nlcats - 2;
                                    end
                                    
                                    fl = rtransl(age - 25+1,lcat+1,rcat+1) - lcati;
                                    
                                    if (fa <= 1 && fl <= 1)
                                        %                 {
                                        mur = (1 - fl) * ((1 - fa) * margufw(vcat+1,lcati    +1,ecat+1,acati+1)...
                                            +   fa     * margufw(vcat+1,lcati    +1,ecat+1,acati +2))...
                                            +  fl     * ((1 - fa) * margufw(vcat+1,lcati + 2,ecat+1,acati+1)...
                                            +   fa     * margufw(vcat+1,lcati + 2,ecat+1,acati +2));
                                        
                                        tur = (1 - fl) * ((1 - fa) * totufw(vcat+1,lcati    +1,ecat+1,acati+1)...
                                            +   fa     * totufw(vcat+1,lcati    +1,ecat+1,acati + 2))...
                                            + fl     * ((1 - fa) * totufw(vcat+1,lcati + 2,ecat+1,acati+1)...
                                            +  fa     * totufw(vcat+1,lcati + 2,ecat+1,acati + 2));
                                        
                                        if (mur <= 0)
                                            %                   {
                                            fprintf('\nBad mu in decision-main job section: %2d %14.6e %14.6e %14.6e %14.6e',...
                                                age, margufw(vcat+1,lcati    +1,ecat+1,acati+1),...
                                                margufw(vcat+1,lcati    +1,ecat+1,acati + 2),...
                                                margufw(vcat+1,lcati + 1+1,ecat+1,acati+1),...
                                                margufw(vcat+1,lcati + 1+1,ecat+1,acati + 2));
                                            fprintf(' %2d %2d %2d %2d %2d %2d %2d', vcat, lcat, lcati, ecat, acat, acati, rcat);
                                            pause();
                                            %                     }
                                        end
                                        %                   }
                                    else
                                        %                 {
                                        if (rcat >= 2)
                                            %                   {
                                            mu0 = mular(lcat+1,acat+1,rcat - 2+1);
                                            mu1 = mular(lcat+1,acat+1,rcat - 1+1);
                                            tu0 = tular(lcat+1,acat+1,rcat - 2+1);
                                            tu1 = tular(lcat+1,acat+1,rcat - 1+1);
                                            
                                            if (mu0 > mu1 && tu1 > tu0)
                                                %                     {
                                                dmu = mu0 - mu1;
                                                dtu = tu1 - tu0;
                                                muratio = mu0 / mu1;
                                                mufact = dmu / mu0;
                                                
                                                mur = mu1 / (1 + mufact);
                                                tur = tu1 + (dtu / log(muratio)) * log(1 + mufact);
                                                %                       }
                                            else
                                                %                     {
                                                mur = mu1;
                                                %
                                                if (tu1 > tu0)
                                                    tur = 2 * tu1 - tu0;
                                                else tur = tu1;
                                                end
                                                %                       }
                                            end
                                            %                     }
                                        else if (lcat > nlcats - 5)
                                                %                   {
                                                mu0 = mular(lcat - 2+1,acat+1,rcat+1);
                                                mu1 = mular(lcat - 1+1,acat+1,rcat+1);
                                                tu0 = tular(lcat - 2+1,acat+1,rcat+1);
                                                tu1 = tular(lcat - 1+1,acat+1,rcat+1);
                                                
                                                if (mu0 > mu1 && tu1 > tu0)
                                                    %                     {
                                                    dmu = mu0 - mu1;
                                                    dtu = tu1 - tu0;
                                                    muratio = mu0 / mu1;
                                                    mufact = dmu / mu0;
                                                    
                                                    mur = mu1 / (1 + (fl - 1) * mufact);
                                                    tur = tu1 + (dtu / log(muratio)) * log(1 + (fl - 1) * mufact);
                                                    %                       }
                                                else
                                                    %                     {
                                                    mur = mu1;
                                                    
                                                    if (tu1 > tu0)
                                                        tur = (1 - fl) * tu0 + fl * tu1;
                                                    else tur = tu1;
                                                    end
                                                    %                       }
                                                end
                                                %                     }
                                            else
                                                %                   {
                                                fprintf('\nfl problem: age %d rcat %d lcat %d %d %6.3f acat %d %d %6.3f rtransl %6.3f',...
                                                    age, rcat, lcat, lcati, fl, acat, acati, fa, rtransl(age - 25+1,lcat+1,rcat+1));
                                                pause();
                                                %                     }
                                            end
                                        end
                                        
                                        
                                        if (rcat > 0)
                                            if (mur > mular(lcat+1,acat+1,rcat - 1+1))
                                                mur = mular(lcat+1,acat+1,rcat - 1+1);
                                            end
                                        end
                                        
                                        if (lcat > 0)
                                            if (mur > mular(lcat - 1+1,acat+1,rcat+1))
                                                mur = mular(lcat - 1+1,acat+1,rcat+1);
                                            end
                                        end
                                        
                                        if (rcat > 0)
                                            if (tur < tular(lcat+1,acat+1,rcat - 1+1))
                                                tur = tular(lcat+1,acat+1,rcat - 1+1);
                                            end
                                        end
                                        
                                        if (lcat > 0)
                                            if (tur < tular(lcat - 1+1,acat+1,rcat+1))
                                                tur = tular(lcat - 1+1,acat+1,rcat+1);
                                            end
                                        end
                                        %                   }
                                        
                                    end
                                    %                 }
                                else
                                    %               {
                                    if (fa <= 1)
                                        %                 {
                                        mur = (1 - fa) * margufw(vcat+1,1,ecat+1,acati+1)...
                                            +  fa     * margufw(vcat+1,1,ecat+1,acati + 2);
                                        tur = (1 - fa) * totufw(vcat+1,1,ecat+1,acati+1)...
                                            +  fa     * totufw(vcat+1,1,ecat+1,acati + 2);
                                        %                   }
                                    else
                                        %                 {
                                        if (rcat >= 2)
                                            %                   {
                                            mu0 = mular(0+1,acat+1,rcat - 2+1);
                                            mu1 = mular(0+1,acat+1,rcat - 1+1);
                                            tu0 = tular(0+1,acat+1,rcat - 2+1);
                                            tu1 = tular(0+1,acat+1,rcat - 1+1);
                                            
                                            if (mu0 > mu1 && tu1 > tu0)
                                                %                     {
                                                dmu = mu0 - mu1;
                                                dtu = tu1 - tu0;
                                                muratio = mu0 / mu1;
                                                mufact = dmu / mu0;
                                                
                                                mur = mu1 / (1 + mufact);
                                                tur = tu1 + (dtu / log(muratio)) * log(1 + mufact);
                                                %                       }
                                            else
                                                %                     {
                                                mur = mu1;
                                                
                                                if (tu1 > tu0)
                                                    tur = 2 * tu1 - tu0;
                                                else tur = tu1;
                                                end
                                                %                       }
                                            end
                                            
                                            %                     }
                                        else
                                            %                   {
                                            fprintf('\nfl problem: age %d rcat %d lcat %d %d %6.3f acat %d %d %6.3f rtransl %6.3f',...
                                                age, rcat, lcat, lcati, fl, acat, acati, fa, rtransl(age - 25+1,lcat+1,rcat+1));
                                            pause();
                                            %                     }
                                        end
                                        
                                        if (rcat > 0)
                                            if (mur > mular(lcat+1,acat+1,rcat - 1+1))
                                                mur = mular(lcat+1,acat+1,rcat - 1+1);
                                            end
                                        end
                                        
                                        if (rcat > 0)
                                            if (tur < tular(lcat+1,acat+1,rcat - 1+1))
                                                tur = tular(lcat+1,acat+1,rcat - 1+1);
                                            end
                                        end
                                        %                   }
                                    end
                                    %                 }
                                end
                                
                                mular(lcat+1,acat+1,rcat+1) = mur;
                                tular(lcat+1,acat+1,rcat+1) = tur;
                                
                                mu = mu + rprob(rcat+1) * mur;
                                tu = tu + rprob(rcat+1) * tur;
                                %               }
                            end
                            mula(lcat+1,acat+1) = mu;
                            tula(lcat+1,acat+1) = tu;
                            %             }
                        end
                        %           }
                    end
                end
                %
                for lcat = 0:1: nlcats-1
                    if (lcat == 0 || (penjobend + 1 > age && age > contribstartage))
                        %         {
                        %           for (acat = 0; acat < nacats; acat++)
                        %           {
                        margufw(vcat+1,lcat+1,ecat+1,1:nacats) = mula(lcat+1,1:nacats);
                        totufw(vcat+1,lcat+1,ecat+1,1:nacats) = tula(lcat+1,1:nacats);
                        %             }
                        %           }
                    end
                end
                %         }
            end
            %       }
        end
    end
    %     /* calculate expectations with respect to survival, given exit from main job */
    
    if (age >= 62)                          %  /* vcat == 0 */
        for dcat = 0:1: 2-1
            if (dcat == 0 || (earlypenage <= age && age < delayedpenage))
                %     {
                for pcat = 0 :1:npcats-1
                    for scat = 0:1:nscats-1
                        for ecat = 0:1:necats-1
                            for acat = 0:1:nacats-1
                                %       {
                                margufr0 = margufr(0+1,dcat+1,pcat+1,scat+1,ecat+1,acat+1);
                                totufr0 = totufr(0+1,dcat+1,pcat+1,scat+1,ecat+1,acat+1);
                                
                                margufr1 = margufr(1+1,dcat+1,pcat+1,scat+1,ecat+1,acat+1);
                                totufr1 = totufr(1+1,dcat+1,pcat+1,scat+1,ecat+1,acat+1);
                                
                                margufr2 = margufr(2+1,0+1,0+1,scat+1,0+1,acat+1);
                                totufr2 = totufr(2+1,0+1,0+1,scat+1,0+1,acat+1);
                                
                                margufr(0+1,dcat+1,pcat+1,scat+1,ecat+1,acat+1)=transrate(0+1,age - 25+1) * margufr0...
                                    + transrate(1+1,age - 25+1) * margufr1...
                                    + transrate(2+1,age - 25+1) * margufr2;
                                
                                totufr(0+1,dcat+1,pcat+1,scat+1,ecat+1,acat+1)=transrate(0+1,age - 25+1) * totufr0...
                                    + transrate(1+1,age - 25+1) * totufr1...
                                    + transrate(2+1,age - 25+1) * totufr2;
                                
                                %         }
                            end
                        end
                    end
                end
                %       }
            end
        end
    end
    
    %     /* calculate expectations with respect to survival, given current main job */
    %
    if (age >= 62)                       %   /* vcat = 0 */
        %     {
        scat = floor(initialscat((lastage + 1) - 50+1));
        fs = initialscat((lastage + 1) - 50+1) - scat;
        
        for ecat = 0:1: necats-1
            for lcat = 0:1: nlcats-1
                if (lcat == 0 || (penjobend >= age && age > contribstartage))
                    %       {
                    for acat = 0:1: nacats-1
                        %         {
                        wealth = acats(acat+1) + lcats(lcat+1);
                        
                        if (acat < nacats - 1)
                            acati = acat + 1;
                        else acati = nacats - 1;
                        end
                        
                        while (acati < nacats - 1 && wealth > acats(acati+1))
                            acati = acati + 1;
                        end
                        
                        acati = acati - 1;
                        
                        fa = (wealth - acats(acati+1)) / (acats(acati + 1+1) - acats(acati+1));
                        
                        margufw0 = margufw(0+1,lcat+1,ecat+1,acat+1);
                        totufw0 = totufw(0+1,lcat+1,ecat+1,acat+1);
                        
                        margufw1 = margufw(1+1,lcat+1,ecat+1,acat+1);
                        totufw1 = totufw(1+1,lcat+1,ecat+1,acat+1);
                        
                        if (scat==3)
                            %%margufr 是3*2*4*4*17*40滴多维数组，当scat=3的时候scat+1+1超限所以需要调整
                            mu0 = (1 - fs) * margufr(3,1,1,scat+1,1,acati +1)...
                                +  fs     * margufr(3,1,2,1,1,acati +1   );
                            mu1 = (1 - fs) * margufr(2+1,1,1,scat    +1,0+1,acati + 1+1)...
                                +  fs     * margufr(2+1,1,2,1,1,acati + 1+1);
                            tu0 = (1 - fs) * totufr(2+1,0+1,0+1,scat    +1,0+1,acati +1   )...
                                +  fs     * totufr(2+1,0+1,2,1,0+1,acati +1   );
                            tu1 = (1 - fs) * totufr(2+1,0+1,0+1,scat    +1,0+1,acati + 1+1)...
                                +  fs     * totufr(2+1,0+1,2,1,0+1,acati + 1+1);
                            
                        else
                            mu0 = (1 - fs) * margufr(2+1,0+1,0+1,scat+1,0+1,acati +1)...
                                +  fs     * margufr(2+1,0+1,0+1,scat + 1+1,0+1,acati +1   );
                            mu1 = (1 - fs) * margufr(2+1,0+1,0+1,scat    +1,0+1,acati + 1+1)...
                                +  fs     * margufr(2+1,0+1,0+1,scat + 1+1,0+1,acati + 1+1);
                            tu0 = (1 - fs) * totufr(2+1,0+1,0+1,scat    +1,0+1,acati +1   )...
                                +  fs     * totufr(2+1,0+1,0+1,scat + 1+1,0+1,acati +1   );
                            tu1 = (1 - fs) * totufr(2+1,0+1,0+1,scat    +1,0+1,acati + 1+1)...
                                +  fs     * totufr(2+1,0+1,0+1,scat + 1+1,0+1,acati + 1+1);
                        end
                        
                        if (fa <= 1)
                            %           {
                            margufr2 = (1 - fa) * mu0 + fa * mu1;
                            totufr2 = (1 - fa) * tu0 + fa * tu1;
                            %             }
                        else
                            %           {
                            if (mu0 > mu1 && tu1 > tu0)
                                %             {
                                dmu = mu0 - mu1;
                                dtu = tu1 - tu0;
                                muratio = mu0 / mu1;
                                mufact = dmu / mu0;
                                
                                margufr2 = mu1 / (1 + (fa - 1) * mufact);
                                totufr2 = tu1 + (dtu / log(muratio)) * log(1 + (fa - 1) * mufact);
                                %               }
                            else
                                %             {
                                margufr2 = mu1;
                                
                                if (tu1 > tu0)
                                    totufr2 = (1 - fa) * tu0 + fa * tu1;
                                else totufr2 = tu1;
                                end
                                %               }
                            end
                            %             }
                        end
                        %
                        margufw(0+1,lcat+1,ecat+1,acat+1)...
                            =  transrate(0+1,age - 25+1) * margufw0...
                            + transrate(1+1,age - 25+1) * margufw1...
                            + transrate(2+1,age - 25+1) * margufr2;
                        
                        totufw(0+1,lcat+1,ecat+1,acat+1)...
                            =  transrate(0+1,age - 25+1) * totufw0...
                            + transrate(1+1,age - 25+1) * totufw1...
                            + transrate(2+1,age - 25+1) * totufr2;
                        %           }
                    end
                    %         }
                end
            end
        end
        %       }
    end
    
    %     /* caculate consumption equivalents of future marginal utility, given exit from main job */
    %
    for vcat = 0:1:3-1
        if (vcat == 0 || age > 62)
            %     { checkMessages();
            
            for dcat = 0:1:2-1
                if (dcat == 0 || (vcat < 2 && earlypenage <= age && age < delayedpenage))
                    %       {
                    for pcat = 0:1: npcats-1
                        if (pcat == 0 || vcat < 2)
                            %         {
                            for scat = 0:1:nscats-1
                                for ecat = 0:1:necats-1
                                    if (ecat == 0 || vcat < 2)
                                        %           {
                                        for acat = 0:1:nacats-1
                                            %             {
                                            mu = margufr(vcat+1,dcat+1,pcat+1,scat+1,ecat+1,acat+1);
                                            tu = totufr(vcat+1,dcat+1,pcat+1,scat+1,ecat+1,acat+1);
                                            
                                            if (mu <= 0)
                                                %               {
                                                fprintf('\nBad mu for decision-retired consumption: %2d %14.6e %2d %2d %2d %2d %2d %2d',...
                                                    age, mu0, mu1, vcat, dcat, pcat, scat, ecat, acat);
                                                pause();
                                                %                 }
                                            end
                                            
                                            if (vcat == 0)
                                                %               {
                                                cmatr(vcat+1,dcat+1,pcat+1,scat+1,ecat+1,acat+1) = sqrt2 * pow((mu / tp), 1 / (alpha - 1));
                                                tumatr(vcat+1,dcat+1,pcat+1,scat+1,ecat+1,acat+1) = tu / tp;
                                                %                 }
                                            else
                                                %               {
                                                cmatr(vcat+1,dcat+1,pcat+1,scat+1,ecat+1,acat+1) = pow(mu * srate(vcat - 1+1,age - 25+1) / tp, 1 / (alpha - 1));
                                                tumatr(vcat+1,dcat+1,pcat+1,scat+1,ecat+1,acat+1) = tu * srate(vcat - 1+1,age - 25+1) / tp;
                                                %                 }
                                            end
                                            %               }
                                        end
                                        %             }
                                    end
                                end
                            end
                            %           }
                        end
                    end
                    %         }
                end
            end
            %       }
        end
    end
    %     /* caculate consumption equivalents of future marginal utility, given current main job */
    %
    for vcat = 0:1: 2-1
        if (vcat == 0 || age > 62)
            %     { checkMessages();
            %
            for ecat = 0:1:necats-1
                %       {
                for lcat = 0:1: nlcats-1
                    if (lcat == 0 || (penjobend >= age && age > contribstartage))
                        %         { /* if (age == 67 && vcat == 0 && (ecat == 86 || ecat == 87)) { fprintf('\n %2d', ecat); for (acat = 30; acat < 35; acat++) fprintf(' %d %14.6e', acat, margufw(vcat+1,lcat+1,ecat+1,acat)); } */
                        for acat = 0:1:nacats-1
                            %           {
                            mu = margufw(vcat+1,lcat+1,ecat+1,acat+1);
                            tu = totufw(vcat+1,lcat+1,ecat+1,acat+1);
                            
                            if (mu <= 0)
                                %             {
                                fprintf('\nBad mu for decision-main job consumption: %2d %14.6e %2d %2d %2d %2d',...
                                    age, mu0, mu1, vcat, lcat, ecat, acat);
                                pause();
                                %               }
                            end
                            
                            if (vcat == 0)
                                %             {
                                cmatw(vcat+1,lcat+1,ecat+1,acat+1) = sqrt2 * pow((mu / tp), 1 / (alpha - 1));
                                tumatw(vcat+1,lcat+1,ecat+1,acat+1) = tu / tp;
                                %               }
                            else
                                %             {
                                cmatw(vcat+1,lcat+1,ecat+1,acat+1) = pow(mu * srate(vcat - 1+1,age - 25+1) / tp, 1 / (alpha - 1));
                                tumatw(vcat+1,lcat+1,ecat+1,acat+1) = tu * srate(vcat - 1+1,age - 25+1) / tp;
                                %               }
                            end
                            %             }
                        end
                        %           }
                    end
                end
                %         }
            end
            %       }
        end
    end
    %
    %     /* calculate consumption, saving, and utility for staying in main job */
    %
    if (npcats > 1 && age > penjobend)
        %     {
        pcat = floor( initialpcat((max(penjobend, 49) + 1) - 50+1));
        fp = initialpcat((max(penjobend, 49) + 1+1) - 50+1) - pcat;
        
        if (fp ~= 0)
            pben = ((1 - fp) * pcats(pcat+1) + fp * pcats(pcat + 1+1))...
                * exp(- inflrate * (1 - penadjrate) * (age - 50));
        else pben = pcats(pcat+1) * exp(- inflrate * (1 - penadjrate) * (age - 50));
        end
        %       }
        
    else pben = 0;
    end
    
    for vcat = 0:1: 2-1
        if (vcat == 0 || age > 62)
            %     { checkMessages();
            
            sben = ssbenm(age - 25+1,vcat+1);
            
            for lcat = 0:1:nlcats-1
                if (lcat == 0 || (penjobend >= age && age > contribstartage))
                    %       {
                    for ecat = 0:1:necats-1
                        %         {
                        cv(1:nacats) = cmatw(vcat+1,lcat+1,ecat+1,1:nacats);
                        tuv(1:nacats) = tumatw(vcat+1,lcat+1,ecat+1,1:nacats);
                        
                        %           margu = margucw(vcat+1,lcat+1,ecat+1,:);
                        %           totu = totucw(vcat+1,lcat+1,ecat+1,:);
                        %
                        %           saving = savw(age - 25+1,lcat+1,ecat+1,:);
                        %           totutil = totuw(age - 25+1,lcat+1,ecat+1,:);
                        
                        y = mainwage(age - 25+1) + pben + sben + othincome(age - 25+1,vcat+1);
                        
                        %           #include 'GSModel.inc'
                        [margu,totu,totutil,saving]=GSModelinc(age,alpha,acats,nacats,nassets,c,cv,consadj,dcat,f,mumax,reversal,pcat,tuv,tp,y,yac,vcat,scat);
                        
                        %            cmatw(vcat+1,lcat+1,ecat+1,:)=cv;
                        %            tumatw(vcat+1,lcat+1,ecat+1,:)=tuv;
                        
                        margucw(vcat+1,lcat+1,ecat+1,1:nacats)=margu(1:nacats);
                        totucw(vcat+1,lcat+1,ecat+1,1:nacats)=totu(1:nacats);
                        if(vcat==0)
                            savw(age - 25+1,lcat+1,ecat+1,1:nacats)=saving(1:nacats);
                            totuw(age - 25+1,lcat+1,ecat+1,1:nacats)=totutil(1:nacats);
                        end
                        
                        
                        %           }
                    end
                    %         }
                end
            end
            %       }
        end
    end
    %     /* calculate consumption, saving, and utility for retirement */
    %
    for vcat = 0:1: 3-1
        if (vcat == 0 || age > 62)
            %     { checkMessages();
            
            for dcat = 0:1: 2-1
                if (dcat == 0 || (vcat < 2 && earlypenage <= age && age < delayedpenage))
                    %       {
                    for pcat = 0:1:npcats-1
                        if (pcat == 0 || vcat < 2)
                            %         {
                            if (vcat < 2 && dcat == 0 && earlypenage <= age)
                                pben = pcats(pcat+1) * exp(- inflrate * (1 - penadjrate) * (age - 50));
                            else pben = 0;
                            end
                            
                            for scat = 0:1:nscats-1
                                %           {
                                sben = ssbenr(age - 50+1,vcat+1,scat+1);
                                
                                for ecat = 0:1:necats-1
                                    if (ecat == 0 || vcat < 2)
                                        %             {
                                        cv(1:nacats) = cmatr(vcat+1,dcat+1,pcat+1,scat+1,ecat+1,1:nacats);
                                        tuv(1:nacats) = tumatr(vcat+1,dcat+1,pcat+1,scat+1,ecat+1,1:nacats);
                                        %
                                        %               margu = margucr(2+1,vcat+1,dcat+1,pcat+1,scat+1,ecat+1);
                                        %               totu = totucr(2+1,vcat+1,dcat+1,pcat+1,scat+1,ecat+1);
                                        %
                                        %               saving = savd(age - 50+1,2+1,dcat+1,pcat+1,scat+1,ecat+1);
                                        %               totutil = totud(age - 50+1,2+1,dcat+1,pcat+1,scat+1,ecat+1);
                                        
                                        y = pben + sben + othincome(age - 25+1,vcat+1);
                                        
                                        %               #include 'GSModel.inc'
                                        [margu,totu,totutil,saving]=GSModelinc(age,alpha,acats,nacats,nassets,c,cv,consadj,dcat,f,mumax,reversal,pcat,tuv,tp,y,yac,vcat,scat);
                                        
                                        
                                        
                                        for acat = 0:nacats-1
                                            %     {
                                            totu(acat+1) = totu(acat+1) + utilr(ecat+1,age - 50+1);
                                            if (vcat == 0)
                                                totutil(acat+1) = totutil(acat+1) + utilr(ecat+1,age - 50+1);
                                            end
                                            %     }
                                            
                                        end
                                        
                                        margucr(2+1,vcat+1,dcat+1,pcat+1,scat+1,ecat+1,1:nacats)=margu(1:nacats) ;
                                        totucr(2+1,vcat+1,dcat+1,pcat+1,scat+1,ecat+1,1:nacats)=totu(1:nacats) ;
                                        
                                        if(vcat==0)
                                            savd(age - 50+1,2+1,dcat+1,pcat+1,scat+1,ecat+1,1:nacats)=saving(1:nacats) ;
                                            totud(age - 50+1,2+1,dcat+1,pcat+1,scat+1,ecat+1,1:nacats)=totutil(1:nacats) ;
                                        end
                                        
                                        %               }
                                    end
                                end
                                %             }
                            end
                            %           }
                        end
                    end
                    %         }
                end
            end
            %       }
        end
    end
    %     /* calculate consumption, saving, and utility for partial retirement */
    %
    for vcat = 0:1: 2-1
        if (vcat == 0 || age > 62)
            %     { checkMessages();
            
            for dcat = 0:1: 2-1
                if (dcat == 0 || (earlypenage <= age && age < delayedpenage))
                    %       {
                    for pcat = 0:1: npcats-1
                        %         {
                        if (dcat == 0 && earlypenage <= age)
                            pben = pcats(pcat+1) * exp(- inflrate * (1 - penadjrate) * (age - 50));
                        else pben = 0;
                        end
                        
                        for scat = 0:1:nscats-1
                            %           {
                            if (sserage <= age && age < 70)
                                %             {
                                benchange = benchangep(age - 62+1,vcat+1,scat+1);
                                
                                if (benchange > 0)
                                    %               {
                                    sbenf = ssbenf(scat+1) + benchangep(age - 62+1,vcat+1,scat+1);
                                    
                                    fs = -1;
                                    
                                    for scati = scat + 1:1:nscats-1
                                        %                 {
                                        if (fs == -1 && sbenf < ssbenf(scati+1))
                                            fs = (scati - 1) + (sbenf - ssbenf(scati - 1+1))...
                                                / (ssbenf(scati+1) - ssbenf(scati - 1+1));
                                        end
                                        %                   }
                                    end
                                    
                                    
                                    if (fs == -1)
                                        fs = (scati - 2) + 0.99;
                                    end
                                    
                                    scati =floor( fs);
                                    fs = fs - scati;
                                    %                 }
                                else
                                    %               {
                                    scati = scat;
                                    fs = 0;
                                    %                 }
                                end
                                %               }
                            else
                                %             {
                                scati = scat;
                                fs = 0;
                                %               }
                            end
                            
                            sben = ssbenp(age - 50+1,vcat+1,scat+1);
                            
                            for ecat = 0:1: necats-1
                                %             {
                                if (fs ~= 0)
                                    %               {
                                    cv = cvbuf;
                                    tuv = tuvbuf;
                                    
                                    %                 for (acat = 0; acat < nacats; acat++)
                                    %                 {
                                    cv(1:nacats) = (1 - fs) .* cmatr(vcat+1,dcat+1,pcat+1,scati+1,ecat+1,1:nacats)...
                                        +  fs     .* cmatr(vcat+1,dcat+1,pcat+1,scati + 1+1,ecat+1,1:nacats);
                                    tuv(1:nacats) = (1 - fs) .* tumatr(vcat+1,dcat+1,pcat+1,scati+1,ecat+1,1:nacats)...
                                        +  fs     .* tumatr(vcat+1,dcat+1,pcat+1,scati + 1+1,ecat+1,1:nacats);
                                    %                   }
                                    
                                    %                 }
                                else
                                    %               {
                                    cv(1:nacats) = cmatr(vcat+1,dcat+1,pcat+1,scati+1,ecat+1,1:nacats);
                                    tuv(1:nacats) = tumatr(vcat+1,dcat+1,pcat+1,scati+1,ecat+1,1:nacats);
                                    %                 }
                                end
                                
                                %               margu = margucr(1+1,vcat+1,dcat+1,pcat+1,scat+1,ecat+1);
                                %               totu = totucr(1+1,vcat+1,dcat+1,pcat+1,scat+1,ecat+1);
                                %
                                %               saving = savd(age - 50+1,1+1,dcat+1,pcat+1,scat+1,ecat+1);
                                %               totutil = totud(age - 50+1,1+1,dcat+1,pcat+1,scat+1,ecat+1);
                                
                                y = prwage(age - 50+1) + pben + sben + othincome(age - 25+1,vcat+1);
                                
                                %               #include 'GSModel.inc'
                                [margu,totu,totutil,saving]=GSModelinc(age,alpha,acats,nacats,nassets,c,cv,consadj,dcat,f,mumax,reversal,pcat,tuv,tp,y,yac,vcat,scat);
                                
                                for acat = 0: nacats-1
                                    %               {
                                    totu(acat+1) = totu(acat+1) + tcats(tcat+1,age - 50+1) * utilr(ecat+1,age - 50+1);
                                    
                                    if (vcat == 0)
                                        totutil(acat+1) = totutil(acat+1) + tcats(tcat+1,age - 50+1) * utilr(ecat+1,age - 50+1);
                                        %                 }
                                    end
                                end
                                %                 }
                                
                                margucr(1+1,vcat+1,dcat+1,pcat+1,scat+1,ecat+1,1:nacats)=margu(1:nacats) ;
                                totucr(1+1,vcat+1,dcat+1,pcat+1,scat+1,ecat+1,1:nacats)=totu(1:nacats) ;
                                if(vcat==0)
                                    savd(age - 50+1,1+1,dcat+1,pcat+1,scat+1,ecat+1,1:nacats)=saving(1:nacats) ;
                                    
                                    totud(age - 50+1,1+1,dcat+1,pcat+1,scat+1,ecat+1,1:nacats)=totutil(1:nacats);
                                end
                                
                                %               }
                            end
                            %             }
                        end
                        %           }
                    end
                    %         }
                end
            end
            %       }
        end
    end
    %
    %     /* calculate consumption, saving, and utility for return to work */
    %
    for vcat = 0:1: 2-1
        if (vcat == 0 || age > 62)
            %     { checkMessages();
            
            for dcat = 0:1:2-1
                if (dcat == 0 || (earlypenage <= age && age < delayedpenage))
                    %       {
                    for pcat = 0:1: npcats-1
                        %         {
                        if (dcat == 0 && earlypenage <= age)
                            pben = pcats(pcat+1) * exp(- inflrate * (1 - penadjrate) * (age - 50));
                        else pben = 0;
                        end
                        
                        for scat = 0:1:nscats-1
                            %           {
                            if (sserage <= age && age < 70)
                                %             {
                                benchange = benchanges(age - 62+1,vcat+1,scat+1);
                                
                                if (benchange > 0)
                                    %               {
                                    sbenf = ssbenf(scat+1) + benchange;
                                    
                                    fs = -1;
                                    
                                    if (scat==3)
                                        scati=4;
                                    else
                                        
                                        for scati = scat + 1:1: nscats-1
                                            %                 {
                                            if (fs == -1 && sbenf < ssbenf(scati+1))
                                                fs = (scati - 1) + (sbenf - ssbenf(scati - 1+1))...
                                                    / (ssbenf(scati+1) - ssbenf(scati - 1+1));
                                            end
                                            %                   }
                                        end
                                        
                                    end
                                    
                                    if (fs == -1)
                                        fs = (scati - 2) + 0.99;
                                    end
                                    
                                    scati = floor(fs);
                                    fs = fs - scati;
                                    %                 }
                                else
                                    %               {
                                    scati = scat;
                                    fs = 0;
                                    %                 }
                                end
                                
                                %               }
                            else
                                %             {
                                scati = scat;
                                fs = 0;
                                %               }
                            end
                            
                            sben = ssbens(age - 50+1,vcat+1,scat+1);
                            
                            for ecat = 0:1: necats-1
                                %             {
                                if (fs ~= 0)
                                    %               {
                                    cv = cvbuf;
                                    tuv = tuvbuf;
                                    
                                    
                                    %                 {
                                    cv(1:nacats) = (1 - fs) .* cmatr(vcat+1,dcat+1,pcat+1,scati+1,ecat+1,1:nacats)...
                                        +  fs     .* cmatr(vcat+1,dcat+1,pcat+1,scati + 1+1,ecat+1,1:nacats);
                                    tuv(1:nacats) = (1 - fs) * tumatr(vcat+1,dcat+1,pcat+1,scati+1,ecat+1,1:nacats)...
                                        +  fs     .* tumatr(vcat+1,dcat+1,pcat+1,scati + 1+1,ecat+1,1:nacats);
                                    %                   }
                                    
                                    %                 }
                                else
                                    %               {
                                    cv(1:nacats) = cmatr(vcat+1,dcat+1,pcat+1,scati+1,ecat+1,1:nacats);
                                    tuv(1:nacats) = tumatr(vcat+1,dcat+1,pcat+1,scati+1,ecat+1,1:nacats);
                                    
                                    %                 }
                                end
                                
                                %               margu = margucr(0+1,vcat+1,dcat+1,pcat+1,scat+1,ecat+1);
                                %               totu = totucr(0+1,vcat+1,dcat+1,pcat+1,scat+1,ecat+1);
                                %
                                %               saving = savd(age - 50+1,0+1,dcat+1,pcat+1,scat+1,ecat+1);
                                %               totutil = totud(age - 50+1,0+1,dcat+1,pcat+1,scat+1,ecat+1);
                                
                                y = secwage(age - 50+1) + pben + sben + othincome(age - 25+1,vcat+1);
                                %
                                %               #include 'GSModel.inc'
                                [margu,totu,totutil,saving]=GSModelinc(age,alpha,acats,nacats,nassets,c,cv,consadj,dcat,f,mumax,reversal,pcat,tuv,tp,y,yac,vcat,scat);
                                
                                margucr(0+1,vcat+1,dcat+1,pcat+1,scat+1,ecat+1,1:nacats)=margu(1:nacats) ;
                                totucr(0+1,vcat+1,dcat+1,pcat+1,scat+1,ecat+1,1:nacats)=totu(1:nacats) ;
                                if(vcat==0)
                                    savd(age - 50+1,0+1,dcat+1,pcat+1,scat+1,ecat+1,1:nacats)=saving(1:nacats) ;
                                    totud(age - 50+1,0+1,dcat+1,pcat+1,scat+1,ecat+1,1:nacats)=totutil(1:nacats) ;
                                end
                                
                                %               }
                            end
                            %             }
                        end
                        %           }
                    end
                    %         }
                end
            end
            %       }
        end
    end
    %     /* choose between work and retirement if left main job previously */
    %
    for vcat = 0:1: 2-1
        if (vcat == 0 || age > 62)
            %     { checkMessages();
            
            for dcat = 0:1: 2-1
                if (dcat == 0 || (earlypenage <= age && age < delayedpenage))
                    %       {
                    for pcat = 0:1:npcats-1
                        for scat = 0:1:nscats-1
                            for ecat = 0:1:necats-1
                                for acat = 0:1:nacats-1
                                    %         {
                                    for job = 0:1: 3-1
                                        %           {
                                        muj(job+1) = margucr(job+1,vcat+1,dcat+1,pcat+1,scat+1,ecat+1,acat+1);
                                        tuj(job+1) = totucr(job+1,vcat+1,dcat+1,pcat+1,scat+1,ecat+1,acat+1);
                                        %             }
                                    end
                                    
                                    jobmax = -1;
                                    tumax = 0;
                                    
                                    for job = 0:1:3-1
                                        if (jobmax == -1 || tuj(job+1) > tumax)
                                            %           {
                                            tumax = tuj(job+1);
                                            jobmax = job;
                                            %             }
                                        end
                                    end
                                    
                                    margufr(vcat+1,dcat+1,pcat+1,scat+1,ecat+1,acat+1) = muj(jobmax+1);
                                    totufr(vcat+1,dcat+1,pcat+1,scat+1,ecat+1,acat+1) = tuj(jobmax+1);
                                    
                                    if (vcat == 0)
                                        retchoice(age - 50+1,dcat+1,pcat+1,scat+1,ecat+1,acat+1) = jobmax + 1;
                                    end
                                    %           }
                                end
                            end
                        end
                    end
                    %         }
                end
            end
            
            if (earlypenage < age && age == delayedpenage)
                %       {
                %%memcpy 替代
                margufr(vcat+1,2,1:npcatlim,1:nscatlim,1:necatlim,1:nacatlim)=margufr(vcat+1,1,1:npcatlim,1:nscatlim,1:necatlim,1:nacatlim);
                totufr(vcat+1,2,1:npcatlim,1:nscatlim,1:necatlim,1:nacatlim)=totufr(vcat+1,1,1:npcatlim,1:nscatlim,1:necatlim,1:nacatlim);
                %         }
            else if (earlypenage == age && age < delayedpenage)
                    %       {
                    margufr(vcat+1,1,1:npcatlim,1:nscatlim,1:necatlim,1:nacatlim)=margufr(vcat+1,2,1:npcatlim,1:nscatlim,1:necatlim,1:nacatlim);
                    totufr(vcat+1,1,1:npcatlim,1:nscatlim,1:necatlim,1:nacatlim)=totufr(vcat+1,2,1:npcatlim,1:nscatlim,1:necatlim,1:nacatlim);
                    %         }
                end
            end
            %       }
        end
    end
    
    if (age > 62)                                % /* vcat = 2 */
        %     {
        if (sserage <= agew && agew < 70)
            %       {
            %           for scat = 0;1:nscats-1
            %           for acat = 0:1:nacats-1
            %         {
            margufr(3,1,1,1:nscats,1,1:nacats) = margucr(3,3,1,1,1:nscats,1,1:nacats);
            totufr(3,1,1,1:nscats,1,1:nacats) = totucr(3,3,1,1,1:nscats,1,1:nacats);
            %           }
            %         }
        end
        %       }
    end
    %
    %     /* chooose between work and retirement if previously in main job */
    %
    pcat = floor( initialpcat(age - 50+1));
    scat = floor(initialscat(age - 50+1));
    
    fp = initialpcat(age - 50+1) - pcat;
    fs = initialscat(age - 50+1) - scat;
    
    eowamt = eowamount(age - 50+1);
    
    for lcat = 0:1: nlcats-1
        %     {
        if (lcat > 0 && penjobend + 1 == age)
            %       {
            for acat = 0:1: nacats-1
                %         {
                pwealth = acats(acat+1) + lcats(lcat+1);
                
                if (acat < nacats - 1)
                    lacat = acat + 1;
                else lacat = nacats - 1;
                end
                
                while (lacat < nacats - 1 && pwealth > acats(lacat+1))
                    lacat = lacat + 1;
                end
                
                lacat = lacat - 1;
                
                lacatsw(lcat+1,acat+1) = lacat + (pwealth - acats(lacat+1))...
                    / (acats(lacat + 1+1) - acats(lacat+1));
                %           }
            end
            %         }
        else if (lcat == 0 || (penjobend <= age && age < contribstartage))
                %       {
                for acat = 0:1: nacats-1
                    lacatsw(lcat+1,acat+1) = acat;
                end
                %         }
            end
        end
        %       }
    end
    
    for lcat = 0:1:nlcats-1
        %     {
        if ((lcat > 0 && penjobend + 1 >= age && age > contribstartage)...
                || (lcat == 0 && eowamt > 0))
            %       {
            for acat = 0:1:nacats-1
                %         {
                pwealth = acats(acat+1) + lcats(lcat+1) + eowamt;
                
                if (acat < nacats - 1)
                    lacat = acat + 1;
                else lacat = nacats - 1;
                end
                
                while (lacat < nacats - 1 && pwealth > acats(lacat+1))
                    lacat = lacat + 1;
                end
                
                lacat = lacat - 1;
                
                lacatsr(lcat+1,acat+1) = lacat + (pwealth - acats(lacat+1)) / (acats(lacat + 1+1) - acats(lacat+1));
                %           }
            end
            %         }
        else if (lcat == 0)
                %       {
                %           for acat = 0:1: nacats-1
                lacatsr(lcat+1,1:nacats) =0:1: nacats-1;
                %           end
                
                %         }
            end
        end
        %       }
    end
    
    for vcat = 0:1:2-1
        if (vcat == 0 || age > 62)
            %     { checkMessages();
            
            for lcat = 0:1:nlcats-1
                if (lcat == 0 || (penjobend + 1 >= age && age > contribstartage))
                    %       {
                    for ecat = 0:1:necats-1
                        for acat = 0:1:nacats-1
                            %         {
                            lacat = floor(lacatsw(lcat+1,acat+1));
                            
                            if (lacat > nacats - 2)
                                lacat = nacats - 2;
                            end
                            
                            fla = lacatsw(lcat+1,acat+1) - lacat;
                            
                            if (penjobend + 1 == age)
                                %           {
                                if (fla > 0)
                                    %             {
                                    mu0 = margucw(vcat+1,0+1,ecat+1,lacat+1    );
                                    mu1 = margucw(vcat+1,0+1,ecat+1,lacat + 2);
                                    tu0 = totucw(vcat+1,0+1,ecat+1,lacat +1   );
                                    tu1 = totucw(vcat+1,0+1,ecat+1,lacat + 2);
                                    
                                    if (fla <= 1)
                                        %               {
                                        muj(1) = (1 - fla) * mu0 + fla * mu1;
                                        tuj(1) = (1 - fla) * tu0 + fla * tu1;
                                        %                 }
                                    else
                                        %               {
                                        if (mu0 > mu1 && tu1 > tu0)
                                            %                 {
                                            dmu = mu0 - mu1;
                                            dtu = tu1 - tu0;
                                            muratio = mu0 / mu1;
                                            mufact = dmu / mu0;
                                            
                                            muj(1) = mu1 / (1 + (fla - 1) * mufact);
                                            tuj(1) = tu1 + (dtu / log(muratio)) * log(1 + (fla - 1) * mufact);
                                            %                   }
                                        else
                                            %                 {
                                            muj(1) = mu1;
                                            
                                            if (tu1 > tu0)
                                                tuj(1) = (1 - fla ) * tu0 + fla * tu1;
                                            else tuj(1) = tu1;
                                            end
                                            %                   }
                                        end
                                        %                 }
                                    end
                                    %               }
                                else
                                    %             {
                                    muj(1) = margucw(vcat+1,1,ecat+1,lacat+1);
                                    tuj(1) = totucw(vcat+1,1,ecat+1,lacat+1);
                                    %               }
                                end
                                %             }
                            else
                                %           {
                                muj(1) = margucw(vcat+1,lcat+1,ecat+1,acat+1);
                                tuj(1) = totucw(vcat+1,lcat+1,ecat+1,acat+1);
                                %             }
                            end
                            
                            lacat = floor( lacatsr(lcat+1,acat+1));
                            
                            if (lacat > nacats - 2)
                                lacat = nacats - 2;
                            end
                            
                            fla = lacatsr(lcat+1,acat+1) - lacat;
                            
                            for choice = 1:1: 3  %(<=)
                                if (vcat < 2 || choice == 3)
                                    %           {
                                    ucrm(1:npcatlim,1:nscatlim,1:necatlim,1:nacatlim) = margucr(choice - 1+1,vcat+1,1,1:npcatlim,1:nscatlim,1:necatlim,1:nacatlim);
                                    ucrt(1:npcatlim,1:nscatlim,1:necatlim,1:nacatlim) = totucr(choice - 1+1,vcat+1,1,1:npcatlim,1:nscatlim,1:necatlim,1:nacatlim);
                                    
                                    for utype = 0:1: 1  %(<=)
                                        %             {
                                        for pcati = pcat:1:pcat + 1  %(<=)
                                            if (pcati == pcat || fp ~= 0)
                                                %               {
                                                for scati = scat:1: scat + 1  %(<=)
                                                    if (scati == scat || fs ~= 0)
                                                        %                 {
                                                        if (fla ~= 0)
                                                            %                   {
                                                            if (utype == 0)
                                                                %                     {
                                                                mu0 = ucrm(pcati+1,scati+1,ecat+1,lacat+1    );
                                                                mu1 = ucrm(pcati+1,scati+1,ecat+1,lacat + 1+1);
                                                                
                                                                if (fla <= 1)
                                                                    temp = (1 - fla) * mu0 + fla * mu1;
                                                                else if (mu0 > mu1)
                                                                        %                       {
                                                                        dmu = mu0 - mu1;
                                                                        mufact = dmu / mu0;
                                                                        
                                                                        temp = mu1 / (1 + (fla - 1) * mufact);
                                                                        %                         }
                                                                    else temp = mu1;
                                                                    end
                                                                end
                                                                %                       }
                                                            else
                                                                %                     {
                                                                tu0 = ucrt(pcati+1,scati+1,ecat+1,lacat+1    );
                                                                tu1 = ucrt(pcati+1,scati+1,ecat+1,lacat + 2);
                                                                
                                                                if (fla <= 1)
                                                                    temp = (1 - fla) * tu0 + fla * tu1;
                                                                else
                                                                    %                       {
                                                                    mu0 = ucrm(pcati+1,scati+1,ecat+1,lacat+1    );
                                                                    mu1 = ucrm(pcati+1,scati+1,ecat+1,lacat + 2);
                                                                    
                                                                    if (mu0 > mu1 && tu1 > tu0)
                                                                        %                         {
                                                                        dmu = mu0 - mu1;
                                                                        dtu = tu1 - tu0;
                                                                        muratio = mu0 / mu1;
                                                                        mufact = dmu / mu0;
                                                                        
                                                                        temp = tu1 + (dtu / log(muratio)) * log(1 + (fla - 1) * mufact);
                                                                        %                           }
                                                                    else if (tu1 > tu0)
                                                                            temp = (1 - fla) * tu0 + fla * tu1;
                                                                        else temp = tu1;
                                                                        end
                                                                    end
                                                                    %                         }
                                                                end
                                                                %                       }
                                                            end
                                                            %                     }
                                                        else
                                                            %                   {
                                                            if (utype == 0)
                                                                temp = ucrm(pcati+1,scati+1,ecat+1,lacat+1);
                                                            else
                                                                temp = ucrt(pcati+1,scati+1,ecat+1,lacat+1);
                                                            end
                                                            %                     }
                                                        end
                                                        
                                                        if (scati == scat)
                                                            temps(1) = temp;
                                                        else temps(2) = temp;
                                                        end
                                                        %                   }
                                                    end
                                                end
                                                
                                                if (fs ~= 0)
                                                    temp = (1 - fs) * temps(1) + fs * temps(2);
                                                else temp = temps(1);
                                                end
                                                
                                                if (pcati == pcat)
                                                    tempp(1) = temp;
                                                else tempp(2) = temp;
                                                end
                                                %                 }
                                            end
                                        end
                                        
                                        if (fp ~= 0)
                                            util = (1 - fp) * tempp(1) + fp * tempp(2);
                                        else util = tempp(1);
                                        end
                                        
                                        if (utype == 0)
                                            muj(choice+1) = util;
                                        else tuj(choice+1) = util;
                                        end
                                        %               }
                                    end
                                    %             }
                                end
                            end
                            
                            
                            jobmax = -1;
                            tumax = 0;
                            
                            for job = 0:1: 4-1
                                if (jobmax == -1 || tuj(job+1) > tumax)
                                    %           {
                                    tumax = tuj(job+1);
                                    jobmax = job;
                                    %             }
                                end
                            end
                            
                            margufw(vcat+1,lcat+1,ecat+1,acat+1) = muj(jobmax+1);
                            totufw(vcat+1,lcat+1,ecat+1,acat+1) = tuj(jobmax+1);
                            
                            if (vcat == 0)
                                mjchoice(age - 50+1,lcat+1,ecat+1,acat+1) = jobmax;
                            end
                            %           }
                        end
                    end
                    %         }
                end
            end
            %       }
        end
    end
    %     }
end

%   /* calculate consumption and saving for age 25 to firstage - 1 */
% load calcModelresult
cv = cvbuf;
tuv = tuvbuf;

for age = firstage - 1:-1: 25  %(>=)
    %   { /* expectations with regard to returns, husband living */
    
    for vcat = 0:1:2-1
        if (vcat == 0 || age > 62)
            %     { checkMessages();
            
            for ecat = 0:1:necats-1
                %       {
                for lcat = 0:1: nlcats-1
                    if (lcat == 0 || (penjobend >= age && age > contribstartage))
                        %         {
                        for acat = 0:1:nacats-1
                            %           {
                            mu = 0;
                            tu = 0;
                            
                            for rcat = 0:1:nrcats-1
                                %             {
                                acati = floor( rtransa(acat+1,rcat+1));
                                %
                                if (acati >= nacats - 1)
                                    acati = nacats - 2;
                                end
                                
                                fa = rtransa(acat+1,rcat+1) - acati;
                                
                                if (nlcats > 1 && penjobend >= age && age > contribstartage)
                                    %               {
                                    lcati = floor(rtransl(age - 25+1,lcat+1,rcat+1));
                                    %
                                    if (lcati >= nlcats - 1)
                                        lcati = nlcats - 2;
                                    end
                                    
                                    fl = rtransl(age - 25+1,lcat+1,rcat+1) - lcati;
                                    
                                    if (fa <= 1 && fl <= 1)
                                        %                 {
                                        mur = (1 - fl) * ((1 - fa) * margufw(vcat+1,lcati    +1,ecat+1,acati+1)...
                                            +   fa     * margufw(vcat+1,lcati    +1,ecat+1,acati + 1+1))...
                                            +  fl     * ((1 - fa) * margufw(vcat+1,lcati + 1+1,ecat+1,acati+1)...
                                            +   fa     * margufw(vcat+1,lcati + 1+1,ecat+1,acati + 1+1));
                                        
                                        tur = (1 - fl) * ((1 - fa) * totufw(vcat+1,lcati    +1,ecat+1,acati+1)...
                                            +   fa     * totufw(vcat+1,lcati    +1,ecat+1,acati + 1+1))...
                                            +  fl     * ((1 - fa) * totufw(vcat+1,lcati + 1+1,ecat+1,acati+1)...
                                            +   fa     * totufw(vcat+1,lcati + 1+1,ecat+1,acati + 1+1));
                                        
                                        if (margufw(vcat+1,lcati    +1,ecat+1,acati+1    ) <= 0 || margufw(vcat+1,lcati    +1,ecat+1,acati + 1+1) <= 0 ...
                                                || margufw(vcat+1,lcati + 1+1,ecat+1,acati+1    ) <= 0 || margufw(vcat+1,lcati + 1+1,ecat+1,acati + 1+1) <= 0)
                                            %                   {
                                            fprintf('\nBad mu in work section-living: %5d %2d %14.6e %14.6e %14.6e %14.6e',...
                                                obs, age, margufw(vcat+1,lcati    +1,ecat+1,acati +1   ), margufw(vcat+1,lcati    +1,ecat+1,acati + 1+1),...
                                                margufw(vcat+1,lcati + 1+1,ecat+1,acati  +1  ), margufw(vcat+1,lcati + 1+1,ecat+1,acati + 1+1));
                                            fprintf(' %2d %2d %2d %2d %2d %2d %2d', vcat, lcat, lcati, ecat, acat, acati, rcat);
                                            pause();
                                            %                     }
                                        end
                                        %
                                        %                   }
                                    else
                                        %                 {
                                        if (rcat >= 2)
                                            %                   {
                                            mu0 = mular(lcat+1,acat+1,rcat - 2+1);
                                            mu1 = mular(lcat+1,acat+1,rcat - 1+1);
                                            tu0 = tular(lcat+1,acat+1,rcat - 2+1);
                                            tu1 = tular(lcat+1,acat+1,rcat - 1+1);
                                            
                                            if (mu0 > mu1 && tu1 > tu0)
                                                %                     {
                                                dmu = mu0 - mu1;
                                                dtu = tu1 - tu0;
                                                muratio = mu0 / mu1;
                                                mufact = dmu / mu0;
                                                
                                                mur = mu1 / (1 + mufact);
                                                tur = tu1 + (dtu / log(muratio)) * log(1 + mufact);
                                                %                       }
                                            else
                                                %                     {
                                                mur = mu1;
                                                
                                                if (tu1 > tu0)
                                                    tur = 2 * tu1 - tu0;
                                                else tur = tu1;
                                                end
                                                %                       }
                                            end
                                            %                     }
                                        else if (lcat > nlcats - 5)
                                                %                   {
                                                mu0 = mular(lcat - 2+1,acat+1,rcat+1);
                                                mu1 = mular(lcat - 1+1,acat+1,rcat+1);
                                                tu0 = tular(lcat - 2+1,acat+1,rcat+1);
                                                tu1 = tular(lcat - 1+1,acat+1,rcat+1);
                                                
                                                if (mu0 > mu1 && tu1 > tu0)
                                                    %                     {
                                                    dmu = mu0 - mu1;
                                                    dtu = tu1 - tu0;
                                                    muratio = mu0 / mu1;
                                                    mufact = dmu / mu0;
                                                    
                                                    mur = mu1 / (1 + (fl - 1) * mufact);
                                                    tur = tu1 + (dtu / log(muratio)) * log(1 + (fl - 1) * mufact);
                                                    %                       }
                                                else
                                                    %                     {
                                                    mur = mu1;
                                                    
                                                    if (tu1 > tu0)
                                                        tur = (1 - fl) * tu0 + fl * tu1;
                                                    else tur = tu1;
                                                    end
                                                    %                       }
                                                end
                                                %                     }
                                            else
                                                %                   {
                                                fprintf('\nfl problem: age %d rcat %d lcat %d', age, rcat, lcat);
                                                pause();
                                                %                     }
                                            end
                                        end
                                        %
                                        if (rcat > 0)
                                            %                   {
                                            if (mur > mular(lcat+1,acat+1,rcat - 1+1))
                                                mur = mular(lcat+1,acat+1,rcat - 1+1);
                                            end
                                            
                                            if (tur < tular(lcat+1,acat+1,rcat - 1+1))
                                                tur = tular(lcat+1,acat+1,rcat - 1+1);
                                            end
                                            %                     }
                                        end
                                        %
                                        if (lcat > 0)
                                            %                   {
                                            if (mur > mular(lcat - 1+1,acat+1,rcat+1))
                                                mur = mular(lcat - 1+1,acat+1,rcat+1);
                                            end
                                            
                                            if (tur < tular(lcat - 1+1,acat+1,rcat+1))
                                                tur = tular(lcat - 1+1,acat+1,rcat+1);
                                            end
                                            %                     }
                                        end
                                        %                   }
                                    end
                                    
                                    mular(lcat+1,acat+1,rcat+1) = mur;
                                    tular(lcat+1,acat+1,rcat+1) = tur;
                                    %                 }
                                else
                                    %               {
                                    if (fa <= 1)
                                        %                 {
                                        mur = (1 - fa) * margufw(vcat+1,0+1,ecat+1,acati+1)...
                                            +  fa     * margufw(vcat+1,0+1,ecat+1,acati + 1+1);
                                        
                                        tur = (1 - fa) * totufw(vcat+1,0+1,ecat+1,acati+1)...
                                            +  fa     * totufw(vcat+1,0+1,ecat+1,acati + 1+1);
                                        %                   }
                                    else
                                        %                 {
                                        mu0 = mular(1,acat+1,rcat - 2+1);
                                        mu1 = mular(1,acat+1,rcat - 1+1);
                                        tu0 = tular(1,acat+1,rcat - 2+1);
                                        tu1 = tular(1,acat+1,rcat - 1+1);
                                        
                                        if (mu0 > mu1 && tu1 > tu0)
                                            %                   {
                                            dmu = mu0 - mu1;
                                            dtu = tu1 - tu0;
                                            muratio = mu0 / mu1;
                                            mufact = dmu / mu0;
                                            
                                            mur = mu1 / (1 + mufact);
                                            tur = tu1 + (dtu / log(muratio)) * log(1 + mufact);
                                            %                     }
                                        else
                                            %                   {
                                            mur = mu1;
                                            
                                            if (tu1 > tu0)
                                                tur = 2 * tu1 - tu0;
                                            else tur = tu1;
                                            end
                                            %                     }
                                        end
                                        %                   }
                                    end
                                    %                 }
                                end
                                
                                mu = mu + rprob(rcat+1) * mur;
                                tu = tu + rprob(rcat+1) * tur;
                                %               }
                            end
                            mula(lcat+1,acat+1) = mu;
                            tula(lcat+1,acat+1) = tu;
                            %             }
                        end
                        %           }\
                    end
                end
                %
                for lcat = 0:1: nlcats-1
                    if (lcat == 0 || (penjobend >= age && age > contribstartage))
                        %         {
                        %            for (acat = 0; acat < nacats; acat++)
                        %           {
                        margufw(vcat+1,lcat+1,ecat+1,1:nacats) = mula(lcat+1,1:nacats);
                        totufw(vcat+1,lcat+1,ecat+1,1:nacats) = tula(lcat+1,1:nacats);
                        %             }
                        %           }
                    end
                end
                %         }
            end
            %       }
        end
    end
    %     /* expectations with respect to returns, husband deceased */
    %
    if (age > 62)
        %     {
        for scat = 0:1:nscats-1
            %       {
            for acat = 0:1:nacats-1
                %         {
                mu = 0;
                tu = 0;
                
                for rcat = 0:1:nrcats-1
                    %           {
                    acati = floor(rtransa(acat+1,rcat+1));
                    
                    if (acati >= nacats - 1)
                        acati = nacats - 2;
                    end
                    
                    fa = rtransa(acat+1,rcat+1) - acati;
                    
                    mu0 = margufr(2+1,0+1,0+1,scat+1,0+1,acati +1   );
                    mu1 = margufr(2+1,0+1,0+1,scat+1,0+1,acati + 1+1);
                    tu0 = totufr(2+1,0+1,0+1,scat+1,0+1,acati +1   );
                    tu1 = totufr(2+1,0+1,0+1,scat+1,0+1,acati + 1+1);
                    
                    if (mu0 <= 0 || mu1 <= 0)
                        %             {
                        fprintf('\nBad mu in work section-deceased: %2d %14.6e %14.6e %2d %2d %2d %2d',...
                            age, mu0, mu1, scat, acat, acati, rcat);
                        pause();
                        %               }
                    end
                    
                    if (fa <= 1)
                        %             {
                        mu = mu + rprob(rcat+1) * ((1 - fa) * mu0 + fa * mu1);
                        tu = tu + rprob(rcat+1) * ((1 - fa) * tu0 + fa * mu1);
                        %               }
                    else
                        %             {
                        if (mu0 > mu1 && tu1 > tu0)
                            %               {
                            dmu = mu0 - mu1;
                            dtu = tu1 - tu0;
                            muratio = mu0 / mu1;
                            mufact = dmu / mu0;
                            
                            mu = mu + rprob(rcat+1) * mu1 / (1 + (fa - 1) * mufact);
                            tu = tu + rprob(rcat+1) * (tu1 + (dtu / log(muratio)) * log(1 + (fa - 1) * mufact));
                            %                 }
                        else
                            %               {
                            mu = mu + rprob(rcat+1) * mu1;
                            %
                            if (tu1 > tu0)
                                tu = tu + rprob(rcat+1) * ((1 - fa) * tu0 + fa * tu1);
                            else tu = tu + rprob(rcat+1) * tu1;
                            end
                            %                 }
                        end
                        %               }
                    end
                    %             }
                end
                margu(acat+1) = mu;
                totu(acat+1) = tu;
                %           }
            end
            
            %         for (acat = 0; acat < nacats; acat++)
            %         {
            margufr(3,1,1,scat+1,1,1:nacats) = margu(1:nacats);
            totufr(3,1,1,scat+1,1,1:nacats) = totu(1:nacats);
            %           }
            
            %         }
        end
        %       }
    end
    
    %     /* expectations with respect to survival, husband living */
    %
    if (age >= 62)                           %   /* vcat = 0 */
        %     {
        scat = floor(initialscat(age - 50+1));
        fs = initialscat(age - 50+1) - scat;
        
        for lcat = 0:1:nlcats-1
            if (lcat == 0 || (penjobend >= age && age > contribstartage))
                %       {
                for ecat = 0:1: necats-1
                    for acat = 0:1:nacats-1
                        %         {
                        wealth = acats(acat+1) + lcats(lcat+1);
                        
                        if (acat < nacats - 1)
                            acati = acat + 1;
                        else acati = nacats - 1;
                        end
                        
                        while (acati < nacats - 1 && wealth > acats(acati+1))
                            acati = acati + 1;
                        end
                        
                        acati = acati - 1;
                        
                        fa = (wealth - acats(acati+1)) / (acats(acati + 1+1) - acats(acati+1));
                        
                        margufw0 = margufw(0+1,lcat+1,ecat+1,acat+1);
                        totufw0 = totufw(0+1,lcat+1,ecat+1,acat+1);
                        
                        margufw1 = margufw(1+1,lcat+1,ecat+1,acat+1);
                        totufw1 = totufw(1+1,lcat+1,ecat+1,acat+1);
                        
                        mu0 = (1 - fs) * margufr(2+1,0+1,0+1,scat    +1,0+1,acati +1   )...
                            +  fs     * margufr(2+1,0+1,0+1,scat + 1+1,0+1,acati +1   );
                        mu1 = (1 - fs) * margufr(2+1,0+1,0+1,scat    +1,0+1,acati + 1+1)...
                            +  fs     * margufr(2+1,0+1,0+1,scat + 1+1,0+1,acati + 1+1);
                        tu0 = (1 - fs) * totufr(2+1,0+1,0+1,scat    +1,0+1,acati  +1 )...
                            +  fs     * totufr(2+1,0+1,0+1,scat + 1+1,0+1,acati  +1  );
                        tu1 = (1 - fs) * totufr(2+1,0+1,0+1,scat    +1,0+1,acati + 1+1)...
                            +  fs     * totufr(2+1,0+1,0+1,scat + 1+1,0+1,acati + 1+1);
                        
                        if (fa <= 1)
                            %           {
                            margufr2 = (1 - fa) * mu0 + fa * mu1;
                            totufr2 = (1 - fa) * tu0 + fa * tu1;
                            %             }
                        else
                            %           {
                            if (mu0 > mu1 && tu1 > tu0)
                                %             {
                                dmu = mu0 - mu1;
                                dtu = tu1 - tu0;
                                muratio = mu0 / mu1;
                                mufact = dmu / mu0;
                                
                                margufr2 = mu1 / (1 + (fa - 1) * mufact);
                                totufr2 = tu1 + (dtu / log(muratio)) * log(1 + (fa - 1) * mufact);
                                %               }
                            else
                                %             {
                                margufr2 = mu1;
                                
                                if (tu1 > tu0)
                                    totufr2 = (1 - fa) * tu0 + fa * tu1;
                                else totufr2 = tu1;
                                end
                                %               }
                            end
                            %             }
                        end
                        %
                        margufw(0+1,lcat+1,ecat+1,acat+1)...
                            =  transrate(0+1,age - 25+1) * margufw0...
                            + transrate(1+1,age - 25+1) * margufw1...
                            + transrate(2+1,age - 25+1) * margufr2;
                        
                        totufw(0+1,lcat+1,ecat+1,acat)...
                            =  transrate(0+1,age - 25+1) * totufw0...
                            + transrate(1+1,age - 25+1) * totufw1...
                            + transrate(2+1,age - 25+1) * totufr2;
                        %           }
                    end
                end
                %         }
            end
        end
        %       }
    end
    %
    %     /* current consumption and saving, husband living */
    
    cv = cvbuf;
    tuv = tuvbuf;
    
    for vcat = 0:1:2-1
        if (vcat == 0 || age > 62)
            %     { checkMessages();
            
            for lcat = 0:1:nlcats-1
                if (lcat == 0 || (penjobend >= age && age > contribstartage))
                    %       { checkMessages();
                    %
                    for ecat = 0:1:necats-1
                        %         {
                        for acat = 0:1: nacats-1
                            %           {
                            mu = margufw(vcat+1,lcat+1,ecat+1,acat+1);
                            tu = totufw(vcat+1,lcat+1,ecat+1,acat+1);
                            
                            if (mu <= 0)
                                %             {
                                fprintf('\nBad mu for work section-living consumption: %5d %2d %14.6e %2d %2d %2d %2d',...
                                    obs, age, mu, vcat, lcat, ecat, acat);
                                fprintf('\n fa %d', firstage);
                                pause();
                                %               }
                            end
                            
                            if (vcat == 0)
                                %             {
                                cv(acat+1) = sqrt2 * (mu / tp)^( 1 / (alpha - 1));
                                tuv(acat+1) = tu / tp;
                                %               }
                            else
                                %             {
                                cv(acat+1) = (mu * srate(vcat - 1+1,age - 25+1) / tp)^ (1 / (alpha - 1));
                                tuv(acat+1) = tu * srate(vcat - 1+1,age - 25+1) / tp;
                                %               }
                            end
                            %             }
                        end
                        sben = ssbenm(age - 25+1,vcat+1);
                        
                        %           margu = margufw(vcat+1,lcat+1,ecat+1);
                        %           totu = totufw(vcat+1,lcat+1,ecat+1);
                        %           saving = savw(age - 25+1,lcat+1,ecat+1);
                        %           totutil = totuw(age - 25+1,lcat+1,ecat+1);
                        
                        y = mainwage(age - 25+1) + sben + othincome(age - 25+1,vcat+1);
                        
                        %           #include 'GSModel.inc'
                        [margu,totu,totutil,saving]=GSModelinc(age,alpha,acats,nacats,nassets,c,cv,consadj,dcat,f,mumax,reversal,pcat,tuv,tp,y,yac,vcat,scat);
                        margufw(vcat+1,lcat+1,ecat+1,1:nacats)=margu(1:nacats) ;
                        totufw(vcat+1,lcat+1,ecat+1,1:nacats)=totu(1:nacats) ;
                        
                        if(vcat==0)
                            savw(age - 25+1,lcat+1,ecat+1,1:nacats)=saving(1:nacats) ;
                            totuw(age - 25+1,lcat+1,ecat+1,1:nacats)=totutil(1:nacats);
                        end
                        
                        %           /* at end of penjob, transfer dc assets to unrestricted assets */
                        
                        
                        if (penjobend + 1 == age)
                            %           {
                            for lcati = 1:1:nlcats-1
                                %             {
                                %                 margu(1:nacats) = margufw(vcat+1,lcati+1,ecat+1,1:nacats);
                                %                 totu(1:nacats) = totufw(vcat+1,lcati+1,ecat+1,1:nacats);
                                
                                for acat = 0:1:nacats-1
                                    %               {
                                    pwealth = acats(acat+1) + lcats(lcat+1);
                                    
                                    if (acat < nacats - 1)
                                        lacat = acat + 1;
                                    else lacat = nacats - 1;
                                    end
                                    
                                    while (lacat < nacats - 1 && pwealth > acats(lacat+1))
                                        lacat = lacat + 1;
                                    end
                                    
                                    lacat = lacat - 1;
                                    
                                    fla = (pwealth - acats(lacat+1)) / (acats(lacat + 1+1) - acats(lacat+1));
                                    
                                    if (fla == 0)
                                        %                 {
                                        %                   margu(acat+1) = margufw(vcat+1,0+1,ecat+1,lacat+1);
                                        %                   totu(acat+1) = totufw(vcat+1,0+1,ecat+1,lacat+1);
                                        margufw(vcat+1,0+1,ecat+1,lacat+1)=margu(acat+1);
                                        totufw(vcat+1,0+1,ecat+1,lacat+1)=totu(acat+1);
                                        %                   }
                                    else
                                        %                 {
                                        mu0 = margufw(vcat+1,0+1,ecat+1,lacat +1   );
                                        mu1 = margufw(vcat+1,0+1,ecat+1,lacat + 1+1);
                                        tu0 = totufw(vcat+1,0+1,ecat+1,lacat  +1  );
                                        tu1 = totufw(vcat+1,0+1,ecat+1,lacat + 1+1);
                                        
                                        if (fla <= 1)
                                            %                   {
                                            margu(acat+1) = (1 - fla) * mu0 + fla * mu1;
                                            totu(acat+1) = (1 - fla) * tu0 + fla * tu1;
                                            %                     }
                                        else
                                            %                   {
                                            if (mu0 > mu1 && tu1 > tu0)
                                                %                     {
                                                dmu = mu0 - mu1;
                                                dtu = tu1 - tu0;
                                                muratio = mu0 / mu1;
                                                mufact = dmu / mu0;
                                                
                                                margu(acat+1) = mu1 / (1 + (fla - 1) * mufact);
                                                totu(acat+1) = tu1 + (dtu / log(muratio)) * log(1 + (fla - 1) * mufact);
                                                %                       }
                                            else
                                                %                     {
                                                margu(acat+1) = mu1;
                                                
                                                if (tu1 > tu0)
                                                    totu(acat+1) = (1 - fla) * tu0 + fla * tu1;
                                                else totu(acat+1) = tu1;
                                                end
                                                %                       }
                                            end
                                            %                     }
                                        end
                                        %                   }
                                    end
                                    %                 }
                                end
                                %               }
                                margufw(vcat+1,lcati+1,ecat+1,1:nacats)=margu(1:nacats) ;
                                totufw(vcat+1,lcati+1,ecat+1,1:nacats)=totu(1:nacats) ;
                            end
                            %             }
                        end
                        %           }
                    end
                    %         }
                end
            end
            %       }
        end
    end
    %
    %     /* current consumption and saving, husband deceased */
    %
    vcat = 2;
    
    if (age > 62)
        %     {
        for scat = 0:1:nscats-1
            %       {
            for acat = 0:1:nacats-1
                %         {
                mu = margufr(2+1,1,1,scat+1,1,acat+1);
                tu = totufr(2+1,1,1,scat+1,1,acat+1);
                
                if (mu <= 0)
                    %           {
                    fprintf('\nBad mu for work section-deceased consumption: %2d %14.6e %14.6e %2d %2d',...
                        age, mu, scat, acat);
                    pause();
                    %             }
                end
                
                cv(acat+1) = (mu * srate(1+1,age - 25+1) / tp)^( 1 / (alpha - 1));
                tuv(acat+1) = tu * srate(vcat - 1+1,age - 25+1) / tp;
                
                %           }
            end
            
            %         margu = margufr(3,1,1,scat+1,1);
            %         totu = totufr(3,1,1,scat+1,1);
            
            y = ssbenr(age - 50+1,2+1,scat+1) + othincome(age - 25+1,vcat+1);
            %
            %         #include 'GSModel.inc'
            [margu,totu,totutil,saving]=GSModelinc(age,alpha,acats,nacats,nassets,c,cv,consadj,dcat,f,mumax,reversal,pcat,tuv,tp,y,yac,vcat,scat);
            margufr(3,1,1,scat+1,1,1:nacats)=margu(1:nacats) ;
            totufr(3,1,1,scat+1,1,1:nacats)=totu(1:nacats) ;
            
            
            %         }
        end
        %       }
    end
    %     }
end

calc.marguc = marguc;
calc.totuc = totuc;
calc.marguf = marguf;
calc.totuf = totuf;
calc.margufw = margufw;
calc.totufw = totufw;
calc.margufr =  margufr;
calc.totufr = totufr;
calc.cmatw = cmatw;
calc.tumatw = tumatw;
calc.cmatr = cmatr;
calc.tumatr = tumatr;
calc.margucw = margucw;
calc.totucw  = totucw;
calc.margucr = margucr;
calc.totucr =  totucr;
calc.totuw  = totuw;
calc.totud =  totud;
calc.savw = savw;
calc.savd = savd;
calc.savr = savr;
calc.mjchoice = mjchoice;
calc.retchoice = retchoice;
