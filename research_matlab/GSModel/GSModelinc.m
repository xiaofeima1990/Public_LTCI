function [margu,totu,totutil,saving]=GSModelinc(age,alpha,acats,nacats,nassets,c,cv,consadj,dcat,f,mumax,reversal,pcat,tuv,tp,y,yac,vcat,scat)
%  %/* This routine takes current resources (including returns on assets) */
%  %/* and decides how much to consume (and how much to save or dissave). */


%%margu，totu，totutil以及saving均要回存，从而改变marguc，totuc，totuc，savd、savr
margu=zeros(40,1);
totu=zeros(40,1);
totutil=zeros(40,1);
saving=zeros(40,1);
  if (y < 10)
  y = 10;
  end


  if (tp < 2.9999)
%   { 
    reversal = 0;
    yacmin = 0;
    yacmax = 0;

    yac(0+1) = y - cv(0+1);

    for k = 1:nacats-1
%     { 
        yac(k+1) = y - acats(k+1) - cv(k+1);

      if (yac(k+1) > yac(k ))
%       { 
          if (reversal == 0)
%         { 
            yacmin = yac(k - 1+1);
            yacmax = yac(k+1);

          reversal = 1;
%           }
        else
%         { 
            if (yac(k - 1+1) < yacmin)
             yacmin = yac(k - 1+1);
            end

          if (yac(k+1) > yacmax)
          yacmax = yac(k+1);
          end
%           }
          end
%         }
      end
%       }
    end

    k = 0;

    for acat = 0:nacats-1
%     { 
        nassets = - acats(acat+1);

      if (reversal == 0 || nassets > yacmax || nassets < yacmin)   %/* monotonic yac function */
%       { 
          if (yac(k+1) < nassets)
%         { 
            k = k - 1;

          while(k >= 0 && yac(k+1) < nassets)
          k = k - 1;
          end
          
          if (k < 0)         %/* optimal to leave no assets to next period */
%           { 
              f = 0;
            k = 0;
%             }

          else f = (yac(k+1) - nassets) / (yac(k+1) - yac(k + 1+1));
          end
%           }
        else
%         { 
            while(k < nacats - 1 && yac(k + 1+1) >= nassets)
          k = k + 1;
            end

          if (k > nacats - 2)   %/* requires extrapolation */
%           {
              k = nacats - 2;

            if (cv(k + 1+1) > cv(k+1))
            f = (yac(k+1) - nassets) / (yac(k+1) - yac(k + 1+1));
            else f = 1 + (yac(k + 1+1) - nassets) / (acats(k + 1+1) - acats(k+1));
            end
%             }
          else f = (yac(k+1) - nassets) / (yac(k+1) - yac(k + 1+1));
          end
%           }
          end

        c = y + acats(acat+1) - ((1 - f) * acats(k+1) + f * acats(k + 1+1));

        if (vcat == 0)                        %/* married */
        mu = consadj *c^(alpha - 1);
        else mu = c^(alpha - 1);
        end

        tu = (1 - f) * tuv(k+1) + f * tuv(k + 1+1) + c * mu / alpha;
%         }
      else                   %/* yac nonmonotonic; need to check for global maximum */
%       { 
          tumax = -9e20;
      
        for k = 0:nacats - 2
        if (yac(k+1) >= nassets && nassets > yac(k + 1+1))
%         { 
            f = (yac(k+1) - nassets) / (yac(k+1) - yac(k + 1+1));

          c = y + acats(acat+1) - ((1 - f) * acats(k+1) + f * acats(k + 1+1));

          if (vcat == 0)                        %/* married */
          mu = consadj * c^(alpha - 1);
          else mu = c^(alpha - 1);
          end

          tu = (1 - f) * tuv(k+1) + f * tuv(k + 1+1) + c * mu / alpha;

          if (tu > tumax)
%           {
              cmax  = c;
            mumax = mu;
            tumax = tu;
%             }
          end
%           }
        end
        end

        if (yac(0+1) < nassets)         %/* potential corner solution at acats = 0 */
%         { 
            c = y + acats(acat+1);

          if (vcat == 0)                        %/* married */
          mu = consadj * c^( alpha - 1);
          else mu = c^(alpha - 1);
          end

          tu = tuv(0+1) + c * mu / alpha;

          if (tu > tumax)
%           { 
              cmax  = c;
             mumax = mu;
             tumax = tu;
%             }
          end
%           }
        end

        if (yac(nacats - 1+1) >= nassets)  %/* potential corner solution at acats > acats(nacats - 1) */
%         { 
            k = nacats - 2;

          if (cv(k + 1+1) > cv(k+1))
          f = (yac(k+1) - nassets) / (yac(k+1) - yac(k + 1+1));
          else f = 1 + (yac(k + 1+1) - nassets) / (acats(k + 1+1) - acats(k+1));
          end

          c = y + acats(acat+1) - ((1 - f) * acats(k+1) + f * acats(k + 1+1));

          if (vcat == 0)                        %/* married */
          mu = consadj * c^( alpha - 1);
          else mu = c^(alpha - 1);
          end

          tu = (1 - f) * tuv(k+1) + f * tuv(k + 1+1) + c * mu / alpha;

          if (tu > tumax)
%           { 
              cmax  = c;
            mumax = mu;
            tumax = tu;
%             }
          end
%           }
        end
        
        c  = cmax;
        mu = mumax;
        tu = tumax;
%         }
      end
      margu(acat+1) = mu;
      totu(acat+1) = tu;
      if (vcat == 0)
%       { 
        saving(acat+1) = y - c;
        totutil(acat+1) = tu;
%         }
      end
%       }
    end
%     }
  else               %/* no assets; individual consumes all resources each period */
%   { 
     for acat = 0: nacats-1
%     { 
        c = y + acats(acat+1);

      if (vcat == 0)                        %/* married */
      mu = consadj * c^( alpha - 1);
      else mu = c^(alpha - 1);
      end

      tu = c * mu / alpha;

      margu(acat+1) = mu;
      totu(acat+1) = tu;
      
      if (vcat == 0)
%       { 
        saving(acat+1) = y - c;
        totutil(acat+1) = tu;
%         }
      end
%       }
     end
%     }
  end
           
