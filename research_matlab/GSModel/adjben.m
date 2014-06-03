% /*---------------------------------------------------------------------------
% 			 ADJ BEN routine
% 			 actualrially adjusts pension benefits to a new starting age
%   ---------------------------------------------------------------------------*/

function f=adjben(origstart,newstart,calc)

inflrate = calc.inflrate;
realrate = calc.realrateg;
penadjrate = calc.penadjrate;
srate = calc.srate;
start = min(origstart, newstart);

for age = 99:-1:start;
    if age >= origstart
        pv0 = pv0 + 1;
    end
    if age >= newstart;
        pv1 = pv1 + 1;
    end
    if age >= start;
        if age > origstart;
            pv0 = pv0 * srate(0+1,age - 25+1) / (1 + realrate + inflrate * (1 - penadjrate));
        elseif age > start;
            pv0 = pv0 * srate(0+1,age - 25+1) / (1 + realrate);
        end
    end
    if age > newstart;
        pv1 = pv1 * srate(0+1,age - 25+1) / (1 + realrate + inflrate * (1 - penadjrate));
    elseif age > start;
        pv1 = pv1 * srate(0+1,age - 25+1) / (1 + realrate);
    end
end
f=pv0 / pv1;

