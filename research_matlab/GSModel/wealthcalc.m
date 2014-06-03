function wealthdiff= wealthcalc(calc,data)

age92 = 1992 - data.birthyear;
wealth = 0;
for age = 25 : age92-1;
    year = age + data.birthyear;
    if year > 1926;
        wealth = (1 + 0.01 * calc.realrate(year-1926, 1)) * wealth;
    elseif year <= 1926;
        wealth = (1 + calc.realrateg) * wealth;
    end;
    c = interp1(0:calc.nacats-1,squeeze(calc.cons(age-25+1,1,:)),wealth,'linear','extrap'); % ??? This cons(vcat) should be marital status;
    wealth = wealth + calc.income(1, age-25+1) - c;
end

if data.assetwealth > 0 || wealth > 0.1;
    wealthdiff = data.assetwealth - (1 + 0.01 * calc.realrate(1991-1926+1, 1)) * wealth;
else
    disp ('data.assetwealth <= 0 && wealth <= 0.1');
    wealthdiff = 0.1;
end;

