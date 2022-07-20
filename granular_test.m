function granular_test()
  close all;
 
  X = [ 7.287566920144843, 3.445538732657047, 5.806249352619957, ...
               1.757907453134366, 7.060394604609237, 7.804911372469476, ...
               1.225288374949727, 2.257441258120462, 6.847180307905908, ...
               7.453440184613569, 8.542226314861731, 4.183189256501326, ...
               0.779016634282649, 6.118225923296698, 8.600711855342688, ...
               7.339124306230843, 2.225267670762494, 4.020632658353541, ...
               1.508953471012625, 3.209774924657622 ];

  Y = [ 5.257701555864911, 6.849660320371277, 2.061436198323450, ...
               7.962469978594390, 3.386507011729175, 9.112379801268046, ...
               1.290278279353838, 2.284047227611168, 6.114877170222211, ...
               0.827699499360753, 2.970900128531614, 0.767233091750447, ...
               6.530592728990055, 7.350546100569525, 5.367024822120446, ...
               7.941064142214791, 5.993093370640704, 5.449951531864693, ...
               3.709114215545194, 3.684426641318774 ];

  R = [ 0.312148715329510, 0.626876344030278, 0.696769226270939, ...
               0.505234659818597, 0.504914255117365, 0.472415275069837, ...
               0.326122317384866, 0.746727903462193, 0.280796860134930, ...
               0.442638128650111, 0.425063434009968, 0.647792961459490, ...
               0.369855110854458, 0.676801763970061, 0.521284121560368, ...
               0.401596914058040, 0.506660051391302, 0.608573354153289, ...
               0.670501677490117, 0.678386951758962 ];
             
  U(1:10) = 10; U(11:20) = 20; 
    
  n = length(X); m = 50;
  u = [X,Y,zeros(size(X)),zeros(size(Y))];  
  t = 0; dt = 0.005;
  L = 10; E = 50000; g = 100; D = 4; rho = 1;
  
  figure(); set(gcf,'color','white'); colormap('jet'); 
  
  for i=1:500
    k1 = granular(u            ,R,E,L,g,D,rho);   
    k2 = granular(u + dt*k1/2.0,R,E,L,g,D,rho);
    k3 = granular(u + dt*k2/2.0,R,E,L,g,D,rho);
    k4 = granular(u + dt*k3    ,R,E,L,g,D,rho);
    u = u + dt * (k1+2*k2+2*k3+k4)/6.0;  
    t = t + dt;    
    X = u(  1:  n);
    Y = u(n+1:2*n);    
    [v,x,y] = poisson(X,Y,R,U,m,L);
     
    clf; rectangle('Position',[-0.1 -0.1 L+0.2 L+0.2], ...
            'FaceColor','red'); hold on;
    contourf(x,y,v,10);
    for k=1:n
      rectangle('Position',[X(k)-R(k) Y(k)-R(k) 2*R(k) 2*R(k)], ...
              'Curvature',[1 1], ...
              'FaceColor','white');
    end
    text(2,9,sprintf('Time = %4.2f',t),'Color','red','FontSize',24);
    axis([-0.1 L+0.1 -0.1 L+0.1]); axis equal;   axis off;   
    drawnow 
  end
end

function [u,x,y] = poisson(X,Y,R,U,nx,L);
   
  n = nx*nx; h = L/(nx-1); 
  s = linspace(0,L,nx);
  [x y] = meshgrid(s,s);  
  
  B = zeros(n,1);
  A = sparse(n,n);           % Very very very IMPORTANT : matrice creuse !
  A((0:n-1)*(n+1) + 1) = 1;  % Assigner la diagonale a un en vectorisant
                             % On peut aussi ameliorer les lignes qui
                             % suivent pour les puristes....
  for i=2:nx-1
    for j=2:nx-1
      index = i + (j-1)*nx;
      A(index,index) = 4.0;
      A(index,index+1) = -1.0;
      A(index,index-1) = -1.0;
      A(index,index+nx) = -1.0;
      A(index,index-nx) = -1.0;
      B(index) = 0;
    end
  end
   
  m = length(X);
  xx = reshape(x,n,1); yy = reshape(y,n,1);
  for j = 1:m
    map = (((xx-X(j)).^2 + (yy-Y(j)).^2) < R(j)^2); 
    index = find(map>0);
    A(index,:) = 0;
    B(index) = U(j); 
    A((index-1)*(n+1)+1) = 1;
  end

  u = reshape(A\B,nx,nx);

end

