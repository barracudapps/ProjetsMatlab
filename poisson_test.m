% -------------------------------------------------------------------------
%
% MATLAB-OCTAVE for DUMMIES 17-18
% Probleme 9
%
% Solution detaillee
%  Vincent Legat
%
% -------------------------------------------------------------------------
%
function poisson_test()

  close all;
  warning('off');  % Pour eviter les messages intempestifs d'Octave :-(

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
  T(1:10) = 10; T(11:20) = 20;
  
  nx = 140; L = 10;  
  [u x y] = poisson(X,Y,R,T,nx,L);

  figure; set(gcf,'color','white');
  colormap('jet'); 
  contourf(x,y,u,10); hold on;
  
  for k=1:20
    rectangle('Position',[X(k)-R(k) Y(k)-R(k) 2*R(k) 2*R(k)], ...
              'Curvature',[1 1], ...
              'FaceColor','white');
  end
  axis equal; 
  axis([0 L 0 L]);   % Requis pour Octave, mais c'est pas normal :-( 
  axis off; 
  
  

end

function [u x y] = poisson(X,Y,R,U,nx,L);
 
%
% -1- Initialisation de la matrice creuse
%     avec une diagonale unitaire 
%     Observer la vectorisation pour ecrire cette diagonale :-)
%
  n = nx*nx; h = L/(nx-1); 
  s = linspace(0,L,nx);
  [x y] = meshgrid(s,s);  
  
  B = zeros(n,1);
  A = sparse(n,n);           % Very very very IMPORTANT
  A((0:n-1)*(n+1) + 1) = 1;  % Assigner la diagonale a un en vectorisant
                             % On peut aussi ameliorer les lignes qui
                             % suivent pour les puristes....
                             % C'est toutefois laisse a vos bons soins !

%
% -2- Operateur discret de Laplace
%
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
%
% -3- Imposition des conditions essentielles sur le cercle.
%     Observer que le test a ete vectorise !
%
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