function [] = bouncingBall_test()

  close all;

  nloop = 20; dt = 0.01; t = 0;
  g = 9.81; k = 0.1; m = 1.0;
  Ustart = [-1 0 4.0 0 0]; 
  fprintf('========         Gravity        : %7.3f [m/s2]  \n',g);
  fprintf('========         Mass           : %7.3f [m/s2]  \n',m);
  fprintf('========         Damping factor : %7.3f [kg/s]  \n',k);
  fprintf('========         Time :  Position x  Position y (Radius) == \n');
  fprintf('= %3d ==  %11.7f : %11.7f %11.7f (%6.3f) == \n',...
             0,Ustart(5),Ustart(1),Ustart(2),norm(Ustart(1:2)));
           
  figure();
  set(gcf,'Color',[1 1 1]);
  theta = linspace(0,2*pi,100);
  plot(cos(theta),sin(theta),'-k'); hold on; 
  axis equal; axis off;

  for loop=1:nloop
    [U Ubouncing] = bouncingBall(dt,Ustart,g,m,k);
    n = size(U,1);
    plot(U(1:n,1),U(1:n,2),'-r');
    plot(U(1:n,1),U(1:n,2),'.r','MarkerSize',20);
    
 %
 %  Pour Octave : remplacer la precedente ligne par :
 %  plot(U(1:n,1),U(1:n,2),'.r','MarkerSize',10);
 %  Parfois, le clone n'est pas tout-a-fait un bon clone...
 %
    
    
    Ustart = Ubouncing; 
    fprintf('= %3d ==  %11.7f : %11.7f %11.7f (%6.3f) == \n',...
             loop,Ustart(5),Ustart(1),Ustart(2),norm(Ustart(1:2)));
  end
end