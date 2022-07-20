function[]=approx_test()
X = [0.2 -0.7 -0.8  0.4  0   -0.5  0   0.6 0.0];
Y = [0.1  0.5 -0.1 -0.9  0.6  0   -0.8 0.2 0.0];
U = [9.0  2.0  2.0  5.0  6.0  9.0  2.0 4.0 6.0];
pu = approx(X,Y,U);
[x,y] = meshgrid([-1:2:1]);
u = pu(1) * x + pu(2) * y + pu(3);
Ua = pu(1) * X + pu(2) * Y + pu(3);
surf(x,y,u,'FaceAlpha',0.4); hold on; axis off;
surf(x,y,zeros(size(x)),'FaceAlpha',0.2);
for i=1:length(X)
    plot3([X(i) X(i)], [Y(i) Y(i)], [0 max(U(i),Ua(i))],'-r', 'MarkerSize', 30);
end
plot3(X, Y, zeros(size(X)), '.k', 'MarkerSize', 30);
plot3(X, Y, U, '.r', 'MarkerSize', 30);
plot3(X, Y, Ua, '.b', 'MarkerSize', 30);
end