function solveout(a,b,c)
z = b^2-4*a*c;
syms x
if z > 0,
    disp('����������ͬ��ʵ����');
    solve(a*x^2+b*x+c)
    disp('\n');
end
if z == 0,
    disp('��������ͬ��ʵ����');
    solve(a*x^2+b*x+c)
    disp('(������������ͬ)');
end
if z < 0,
    disp('û��ʵ����');
end