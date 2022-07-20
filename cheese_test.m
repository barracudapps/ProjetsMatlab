function cheese_test()
  close all;
  clear all;
  
  L = 10; radius = 0.2; ratio = 8.0; n = 10; error = 10e-6;
  
% Parametres pour les figures de l'enonce :-)
% L = 10; radius = 0.2; ratio =  8.0; n = 10;
% L = 10; radius = 0.5; ratio =  1.0; n = 40; 
% L = 10; radius = 0.1; ratio = 50.0; n = 20;
% L = 10; radius = 0.5; ratio =  2.0; n = 50;

  I = cheese_create(n,L,radius,ratio);
  fprintf('\n ==== Analytical integral  : %14.7e \n',I);
  tic;
  Ih = cheese(L,radius,error,@f); telapsed = toc;
  fprintf('\n\n ==== Numerical quadrature : %14.7e ',Ih);
  fprintf('\n ==== Requested error : %14.7e ',error);  
  fprintf('\n ==== Observed error  : %14.7e ',abs(Ih-I));  
  fprintf('\n ==== Elapsed time for quadrature : %8.1e seconds \n',telapsed);

end

%
% Generation d'un morceau de gruyere
% Construction automatique de la fonction f
% Joli graphique
% et ... calcul exact de la compacite du gruyere
%

function I = cheese_create(n,side,radius,ratio)

%
% -1- Creation de n trous classes par ordre de taille decroissant
%     On place d'abord les plus gros :-)
%


  X = zeros(n,1);
  Y = zeros(n,1);
  R = sort(rand(n,1)*radius*(ratio-1.0)+radius,'descend');

%
% -2- Insertion des trous en evitant les superpositions
%     Apres 10 essais infructueux, le trou est abandonne !
% 
  i = 1;
  iLoc = 0;
  iFail = 0;
  iTest = 0;
  while (i <= n)
    
    Rloc = R(i);
    x = rand*(side-2*Rloc)+Rloc;
    y = rand*(side-2*Rloc)+Rloc;

    for j=1:i
      if ( ((X(j)-x)^2+(Y(j)-y)^2) < (R(j)+R(i))^2 )
        iFail = 1;
        break;
      end
    end
    
    if (iTest == 9 && iFail == 1)
      fprintf('  == Circle %d (R=%9.2e) cannot be inserted :-( \n',i,R(i));
      i = i+1;
      iTest = 0;
    end

    if (iFail == 0)
      fprintf('  == Circle %d (R=%9.2e) %d trials performed \n',i,R(i),iTest+1);
      iLoc = iLoc+1;
      X(iLoc) = x;
      Y(iLoc) = y;
      R(iLoc) = R(i);     
      i = i+1;
      iTest = 0;    
    end
    
    iFail = 0;
    iTest = iTest+1;
  end
  
%
% -3- Ecriture de la fonction a integrer dans le fichier f.m
%
  
  fid =fopen('f.m','w');
  fprintf(fid,'function [uh] = f(x,y)\n\n');
  fprintf(fid,'  n = %d;\n',iLoc);
  fprintf(fid,'  X = [');
  for i=1:iLoc-1
    fprintf(fid,'%14.7e,',X(i));
    if (mod(i,3) == 0) fprintf(fid,' ...\n       '); end
  end
  fprintf(fid,'%14.7e];\n',X(iLoc));
  fprintf(fid,'  Y = [');
  for i=1:iLoc-1
    fprintf(fid,'%14.7e,',Y(i));
    if (mod(i,3) == 0) fprintf(fid,' ...\n       '); end
  end
  fprintf(fid,'%14.7e];\n',Y(iLoc));
  fprintf(fid,'  R = [');
  for i=1:iLoc-1
    fprintf(fid,'%14.7e,',R(i));
    if (mod(i,3) == 0) fprintf(fid,' ...\n       '); end
  end
  fprintf(fid,'%14.7e];\n',R(iLoc));
  fprintf(fid,'  uh = zeros(size(x));\n');
  fprintf(fid,'  for i = 1:n\n');
  fprintf(fid,'    uh = uh + ((x-X(i)).^2 + (y-Y(i)).^2 < R(i)^2);\n');
  fprintf(fid,'  end\n\nend');
%
% Version altenative de Matthieu Constant pour les 4 dernieres lignes
% Devrait etre plus rapide mais est plus lent sur mon ordinateur
% En tous cas, c'est joli et bien complique :-)
%
%   fprintf(fid,' C = bsxfun(@le,bsxfun(@minus,x,X).^2+bsxfun(@minus,y,Y).^2,R.^2);\n');
%   fprintf(fid,' uh = sum(C,1)./max(sum(C,1),1);\n');
%   fprintf(fid,'end');
%   
  fclose(fid);

%
% -4- Une jolie figure du morceau de gruyere
%

  figure;
  rectangle('Position',[0 0 side side], ...
            'FaceColor',[1,215/255,0]); hold on;
  for i=1:iLoc
    rectangle('Position',[X(i)-R(i) Y(i)-R(i) 2*R(i) 2*R(i)], ...
              'Curvature',[1 1], ...
              'FaceColor','white');
  end
  set(gcf,'color','white');
  axis equal; axis off;
  
%
% -5- Calcul de la compacite du gruyere
%     Gruyere sans trous = 1.0
%     Rien que des trous = 0.0
%

  I = 1.0 - sum(R(1:iLoc).*R(1:iLoc))*pi/(side*side);

end