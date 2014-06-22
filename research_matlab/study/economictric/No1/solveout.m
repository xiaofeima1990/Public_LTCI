function solveout(a,b,c)
z = b^2-4*a*c;
syms x
if z > 0,
    disp('有两个不相同的实数根');
    solve(a*x^2+b*x+c)
    disp('\n');
end
if z == 0,
    disp('有两个相同的实数根');
    solve(a*x^2+b*x+c)
    disp('(以上两个根相同)');
end
if z < 0,
    disp('没有实数根');
end